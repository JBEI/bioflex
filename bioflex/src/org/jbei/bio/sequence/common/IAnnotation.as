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
        * Annotation start position. This should be a zero based start, not genbank_start.
        * Still, initial code used inconsistent starts, sometimes genbank, other times not. Try to
        * normalize to zero based half open intervals.
        */
        function get start():int;
        function set start(value:int):void;
        
        /**
         * Annotation end position. This should be zero based half open intervals.
         * Still, initial code used inconsistent ends, sometimes using a zero based closed intervals.
         * Try to normalize to zero based half open intervals.
         */
        function get end():int;
        function set end(value:int):void;
    }
}