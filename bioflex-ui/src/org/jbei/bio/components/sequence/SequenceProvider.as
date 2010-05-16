package org.jbei.bio.components.sequence
{
    import flash.events.EventDispatcher;
    
    import org.jbei.bio.sequence.DNATools;
    import org.jbei.bio.sequence.dna.DNASequence;

    /**
     * @author Zinovii Dmytriv
     */
    public class SequenceProvider extends EventDispatcher
    {
        private var _dnaSequence:DNASequence;
        private var _revComSequence:DNASequence;
        
        private var dirty:Boolean;
        
        // Constructor
        public function SequenceProvider(dnaSequence:DNASequence)
        {
            _dnaSequence = dnaSequence;
            
            dirty = true;
            _revComSequence = null;
        }
        
        // Properties
        public function get name():String
        {
            return _dnaSequence.name;
        }
        
        public function get circular():Boolean
        {
            return _dnaSequence.circular;
        }
        
        public final function get sequence():DNASequence
        {
            return _dnaSequence;
        }
        
        public final function get revComSequence():DNASequence
        {
            if(dirty) {
                _revComSequence = new DNASequence(DNATools.complement(_dnaSequence));
                
                dirty = false;
                
                trace("revcom recalculated!");
            }
            
            return _revComSequence;
        }
        
        public function get length():int
        {
            return _dnaSequence.length;
        }
        
        // Public Methods
        /* @throws RangeError */
        public function insertSequence(newDnaSequence:DNASequence, position:int):void
        {
            if(newDnaSequence.length == 0) { return; }
            
            dispatchEvent(new SequenceProviderEvent(SequenceProviderEvent.SEQUENCE_CHANGING, SequenceProviderEvent.KIND_INSERT, position, -1, newDnaSequence));
            
            try {
                _dnaSequence.insertSymbols(position, newDnaSequence);
            } finally {
                dispatchEvent(new SequenceProviderEvent(SequenceProviderEvent.SEQUENCE_CHANGED, SequenceProviderEvent.KIND_INSERT, position, -1, newDnaSequence));
            }
            
            dirty = true;
        }
        
        /* @throws RangeError */
        public function deleteSequence(position:int, count:int):void
        {
            if(count == 0) { return; }
            
            dispatchEvent(new SequenceProviderEvent(SequenceProviderEvent.SEQUENCE_CHANGING, SequenceProviderEvent.KIND_DELETE, position, count));
            
            try {
                _dnaSequence.deleteSymbols(position, count);
            } finally {
                dispatchEvent(new SequenceProviderEvent(SequenceProviderEvent.SEQUENCE_CHANGED, SequenceProviderEvent.KIND_DELETE, position, count));
            }
            
            dirty = true;
        }
    }
}
