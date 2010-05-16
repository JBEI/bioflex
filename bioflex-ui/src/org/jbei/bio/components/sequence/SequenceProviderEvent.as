package org.jbei.bio.components.sequence
{
    import flash.events.Event;
    
    import org.jbei.bio.sequence.dna.DNASequence;
    
    /**
     * @author Zinovii Dmytriv
     */
    public class SequenceProviderEvent extends Event
    {
        public static const SEQUENCE_CHANGING:String = "SequenceChanging";
        public static const SEQUENCE_CHANGED:String = "SequenceChanged";
        public static const KIND_INSERT:String = "KindInsert";
        public static const KIND_DELETE:String = "KindDelete";
        
        public var kind:String;
        public var position:int;
        public var count:int;
        public var dnaSequence:DNASequence;
        
        // Constructor
        public function SequenceProviderEvent(type:String, kind:String, position:int, count:int = 0, dnaSequence:DNASequence = null)
        {
            super(type, false, false);
            
            this.kind = kind;
            this.position = position;
            this.count = count;
            this.dnaSequence = dnaSequence;
        }
    }
}