package org.jbei.bio.sequence.common
{
    /**
    * General sequence annotation interface.
    * 
    * @author Zinovii Dmytriv
    */
    public interface IAnnotation
    {
        /**
        * Annotation start position 
        */
        function get start():int;
        function set start(value:int):void;
        
        /**
         * Annotation end position 
         */
        function get end():int;
        function set end(value:int):void;
    }
}