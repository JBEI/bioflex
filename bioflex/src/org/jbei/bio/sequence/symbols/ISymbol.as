package org.jbei.bio.sequence.symbols
{
    /**
     * @author Zinovii Dmytriv
     */
    [RemoteClass(alias="org.jbei.bio.sequence.symbols.ISymbol")]
    public interface ISymbol
    {
        function get name():String;
        function set name(value:String):void;
        function get value():String;
        function set value(value:String):void;
    }
}