package org.jbei.bio.sequence.dna
{
    import org.jbei.bio.BioException;
    import org.jbei.bio.sequence.common.SymbolList;

    /**
    * DNA sequence with features.
    * 
    * @author Zinovii Dmytriv
    */
    public class RichDNASequence extends DNASequence
    {
        private var _features:Vector.<Feature> = new Vector.<Feature>();
        
        // Constructor
        /**
        * Contructor
        * 
        * @param symbolList DNA sequence
        * @param name Sequence name
        * @param circular Defines if sequence is circular or not. Default <code>false</code>
        * @param accession Sequence accession number
        * @param version Version
        * @param seqVersion Sequence version
        */
        public function RichDNASequence(symbolList:SymbolList, name:String = "", circular:Boolean = false, accession:String="", version:int=1, seqVersion:Number=0.0)
        {
            super(symbolList, name, circular, accession, version, seqVersion);
        }
        
        // Properties
        /**
        * List of sequence features
        */
        public final function get features():Vector.<Feature>
        {
            return _features;
        }
        
        // Public Methods
        /**
         * Number of features
         * 
         * @return Number of features
         */
        public function numberOfFeatures():int
        {
            return _features.length;
        }
        
        /**
         * Add feature to current sequence
         * 
         * @param feature Feature to add 
         */
        public function addFeature(feature:Feature):void
        {
            _features.push(feature);
        }
        
        /**
         * Check if feature already belongs to sequence
         * 
         * @param feature Feature to check
         * @return Boolean 
         */
        public function containsFeature(feature:Feature):Boolean
        {
            return _features.indexOf(feature) >= 0;
        }
        
        /**
         * Removes feature from current sequence if it exists. Else throws exception
         * 
         * @throws BioException 
         */
        public function removeFeature(feature:Feature):void
        {
            var index:int = _features.indexOf(feature);
            
            if(index == -1) {
                throw new BioException("Failed to remove feature! Feature doesn't belong to this sequence.");
            }
            
            _features.splice(index, 1);
        }
    }
}