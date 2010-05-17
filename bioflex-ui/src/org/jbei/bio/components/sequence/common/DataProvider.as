package org.jbei.bio.components.sequence.common
{
    import org.jbei.bio.components.sequence.SequenceProvider;
    import org.jbei.bio.components.sequence.SequenceProviderEvent;
    import org.jbei.bio.sequence.dna.DNASequence;

    /**
     * @author Zinovii Dmytriv
     */
    public class DataProvider
    {
        private var _sequenceProvider:SequenceProvider;
        
        // Constructor
        public function DataProvider(sequenceProvider:SequenceProvider)
        {
            this.sequenceProvider = sequenceProvider;
        }
        
        // Properties
        public function get sequenceProvider():SequenceProvider
        {
            return _sequenceProvider;
        }
        
        public function set sequenceProvider(value:SequenceProvider):void
        {
            _sequenceProvider = value;
            
            if(_sequenceProvider) {
                _sequenceProvider.addEventListener(SequenceProviderEvent.SEQUENCE_CHANGED, onSequenceProviderChanged);
            }
        }
        
        // Protected Methods
        protected function handleSequenceInsertion(position:int, dnaSequence:DNASequence):void
        {
            
        }
        
        protected function handleSequenceDeletion(position:int, count:int):void
        {
            
        }
        
        // Private Methods
        private function onSequenceProviderChanged(event:SequenceProviderEvent):void
        {
            if(event.kind == SequenceProviderEvent.KIND_INSERT) {
                handleSequenceInsertion(event.position, event.dnaSequence);
            } else if(event.kind == SequenceProviderEvent.KIND_DELETE) {
                handleSequenceDeletion(event.position, event.count);
            }
        }
    }
}