package org.jbei.bio.sequence.common
{
    /**
     * @author Zinovii Dmytriv
     */
    [RemoteClass(alias="org.jbei.bio.sequence.common.StrandedAnnotation")]
    public class StrandedAnnotation extends Annotation
    {
        private var _strand:int = StrandType.FORWARD;
        
        // Constructor
        public function StrandedAnnotation(start:int=0, end:int=0, strand:int = StrandType.FORWARD)
        {
            super(start, end);
            
            _strand = strand;
        }
        
        // Properties
        public function get strand():int
        {
            return _strand;
        }
        
        public function set strand(value:int):void
        {
            _strand = value;
        }
    }
}