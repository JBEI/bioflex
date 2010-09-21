package org.jbei.bio.sequence.common
{
    [RemoteClass(alias="org.jbei.bio.sequence.common.StrandedAnnotation")]
    
    /**
    * Annotation with defined read direction.
    * 
    * @see org.jbei.bio.sequence.common.StrandType
    * 
    * @author Zinovii Dmytriv
    */
    public class StrandedAnnotation extends Annotation
    {
        private var _strand:int = StrandType.FORWARD;
        
        // Constructor
        /**
        * Contructor
        * 
        * @param start Annotation start
        * @param end Annotation end
        * @param strand Strand type. @see org.jbei.bio.sequence.common.StrandType
        */
        public function StrandedAnnotation(start:int=0, end:int=0, strand:int = StrandType.FORWARD)
        {
            super(start, end);
            
            _strand = strand;
        }
        
        // Properties
        /**
        * Strand type
        * 
        * @see org.jbei.bio.sequence.common.StrandType
        */
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