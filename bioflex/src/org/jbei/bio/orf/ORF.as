package org.jbei.bio.orf
{
    import org.jbei.bio.sequence.common.StrandType;
    import org.jbei.bio.sequence.common.StrandedAnnotation;
    
    [RemoteClass(alias="org.jbei.bio.orf.ORF")]
    /**
    * Open Read Frame DNA sequence annotation
    * 
    * @author Zinovii Dmytriv
    */
    public class ORF extends StrandedAnnotation
    {
        private var _frame:int;
        private var _startCodons:Vector.<int>
        
        // Constructor
        /**
        * Contructor
        * 
        * @param start Frame start
        * @param end Frame end
        * @param strand Frame strand
        * @param frame Frame frame. Can be 0, 1, 2
        * @param startCodons List of start codons for Open Read Frame.
        */
        public function ORF(start:int=0, end:int=0, strand:int=StrandType.FORWARD, frame:int = 0, startCodons:Vector.<int> = null)
        {
            super(start, end, strand);
            
            _frame = frame;
            _startCodons = startCodons;
        }
        
        // Properties
        /**
        * Frame frame. Can be 0, 1, 2
        */
        public function get frame():int
        {
            return _frame;
        }
        
        public function set frame(value:int):void
        {
            _frame = value;
        }
        
        /**
         * List of startCodons
         */
        public function get startCodons():Vector.<int>
        {
            return _startCodons;
        }
        
        public function set startCodons(value:Vector.<int>):void
        {
            _startCodons = value;
        }
    }
}