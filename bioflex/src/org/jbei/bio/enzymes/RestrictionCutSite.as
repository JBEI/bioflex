package org.jbei.bio.enzymes
{
    import org.jbei.bio.sequence.common.StrandedAnnotation;
    
    /**
    * Restriction cut site.
    * 
    * @author Zinovii Dmytriv
    */
    public class RestrictionCutSite extends StrandedAnnotation
    {
        private var _restrictionEnzyme:RestrictionEnzyme;
        private var _numCuts:int = 0;
        
        // Constructor
        /**
        * Contructor
        * 
        * @param start Cut site start
        * @param end Cut site end
        * @param strand Cut site strand
        * @param restrictionEnzyme Restriction Enzyme this cut site was created with
        */
        public function RestrictionCutSite(start:int, end:int, strand:int, restrictionEnzyme:RestrictionEnzyme)
        {
            super(start, end, strand);
            
            _restrictionEnzyme = restrictionEnzyme;
        }
        
        // Properties
        /**
        * Restriction Enzyme this cut site was created with
        */
        public function get restrictionEnzyme():RestrictionEnzyme
        {
            return _restrictionEnzyme;
        }
        
        public function set restrictionEnzyme(value:RestrictionEnzyme):void
        {
            _restrictionEnzyme = value;
        }
        
        /**
         * Number of cuts this cutsite cuts sequence
         */
        public function get numCuts():int
        {
            return _numCuts;
        }
        
        public function set numCuts(value:int):void
        {
            _numCuts = value;
        }
    }
}