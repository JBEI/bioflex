package org.jbei.bio.sequence.common
{
    /**
     * @author Zinovii Dmytriv
     */
    public class Annotation implements IAnnotation
    {
        private var _start:int = 0;
        private var _end:int = 0;
        
        // Constructor
        public function Annotation(start:int = 0, end:int = 0)
        {
            _start = start;
            _end = end;
        }
        
        // Properties
        public function get start():int
        {
            return _start;
        }
        
        public function set start(value:int):void
        {
            _start = value;
        }
        
        public function get end():int
        {
            return _end;
        }
        
        public function set end(value:int):void
        {
            _end = value;
        }
        
        // Public Methods
        public function contains(annotation:Annotation):Boolean
        {
            var result:Boolean = false;
            
            if(_start <= _end) { // segment1 non-circular
                if(annotation.start <= annotation.end) { // segment2 non-circular 
                    result = ((_start <= annotation.start) && (_end >= annotation.end)); 
                }
            } else { // segment1 circular
                if(annotation.start <= annotation.end) { // segment2 non-circular
                    result = ((annotation.end <= _end) || (annotation.start >= _start));
                } else { // segment1 circular
                    result = ((_start <= annotation.start) && (_end >= annotation.end));
                }
            }
            
            return result;
        }
    }
}