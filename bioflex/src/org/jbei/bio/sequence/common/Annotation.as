package org.jbei.bio.sequence.common
{
    [RemoteClass(alias="org.jbei.bio.sequence.common.Annotation")]
    /**
    * General annotation class.
    * 
    * @author Zinovii Dmytriv
    */
    public class Annotation implements IAnnotation
    {
        private var _start:int = 0;
        private var _end:int = 0;
        
        // Constructor
        /**
        * Contructor
        */
        public function Annotation(start:int = 0, end:int = 0)
        {
            _start = start;
            _end = end;
        }
        
        // Properties
        /**
        * @inheritDoc
        */
        public function get start():int
        {
            return _start;
        }
        
        public function set start(value:int):void
        {
            _start = value;
        }
        
        /**
         * @inheritDoc
         */
        public function get end():int
        {
            return _end;
        }
        
        public function set end(value:int):void
        {
            _end = value;
        }
        
        // Public Methods
        /**
        * Calculates if this annotation contains another annotation.
        * 
        * @param annotation Annotation to check against
        */
        public function contains(annotation:Annotation):Boolean
        {
            var result:Boolean = false;
            
            if(_start <= _end) { // annotation1 non-circular
                if(annotation.start <= annotation.end) { // annotation2 non-circular 
                    result = ((_start <= annotation.start) && (_end >= annotation.end)); 
                }
            } else { // annotation1 circular
                if(annotation.start <= annotation.end) { // annotation2 non-circular
                    result = ((annotation.end <= _end) || (annotation.start >= _start));
                } else { // annotation1 circular
                    result = ((_start <= annotation.start) && (_end >= annotation.end));
                }
            }
            
            return result;
        }
    }
}