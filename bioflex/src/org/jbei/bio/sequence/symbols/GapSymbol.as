package org.jbei.bio.sequence.symbols
{
    /**
     * @author Zinovii Dmytriv
     */
    [RemoteClass(alias="org.jbei.bio.sequence.symbols.GapSymbol")]
    public class GapSymbol implements ISymbol
    {
        private var _name:String;
        private var _value:String;
        
        // Constructor
        public function GapSymbol(name:String = "", value:String = "")
        {
            _name = name;
            _value = value;
        }
        
        // Properties
        public function get name():String
        {
            return _name;
        }
        
        public function set name(value:String):void
        {
            _name = value;
        }
        
        public function get value():String
        {
            return _value;
        }
        
        public function set value(value:String):void
        {
            _value = value;
        }
    }
}