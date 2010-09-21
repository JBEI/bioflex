package org.jbei.bio.sequence.symbols
{
    [RemoteClass(alias="org.jbei.bio.sequence.symbols.ISymbol")]
    
    /**
    * General interface for all symbol classes.
    * 
    * @author Zinovii Dmytriv
    */
    public interface ISymbol
    {
        /**
        * Symbol name
        */
        function get name():String;
        function set name(value:String):void;
        
        /**
         * Symbol value
         */
        function get value():String;
        function set value(value:String):void;
    }
}