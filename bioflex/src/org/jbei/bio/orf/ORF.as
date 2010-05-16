package org.jbei.bio.orf
{
    import org.jbei.bio.sequence.common.StrandType;
    import org.jbei.bio.sequence.common.StrandedAnnotation;
    
    /**
     * @author Zinovii Dmytriv
     */
    public class ORF extends StrandedAnnotation
    {
        private var _frame:int;
        private var _startCodons:Vector.<int>
        
        // Constructor
        public function ORF(start:int=0, end:int=0, strand:int=StrandType.FORWARD, frame:int = 0, startCodons:Vector.<int> = null)
        {
            super(start, end, strand);
            
            _frame = frame;
            _startCodons = startCodons;
        }
        
        // Properties
        public function get frame():int
        {
            return _frame;
        }
        
        public function set frame(value:int):void
        {
            _frame = value;
        }
        
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