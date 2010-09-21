package org.jbei.bio.sequence.symbols
{
    [RemoteClass(alias="org.jbei.bio.sequence.symbols.GapSymbol")]
    /**
    * General class for gap symbols.
    * 
    * @author Zinovii Dmytriv
    */
    public class GapSymbol implements ISymbol
    {
        private var _name:String;
        private var _value:String;
        
        // Constructor
        /**
        * Contructor
        * 
        * @param name Gap symbol name
        * @param value Gap symbol string value
        */
        public function GapSymbol(name:String = "", value:String = "")
        {
            _name = name;
            _value = value;
        }
        
        // Properties
        /**
        * @inheritDoc
        */
        public function get name():String
        {
            return _name;
        }
        
        public function set name(value:String):void
        {
            _name = value;
        }
        
        /**
         * @inheritDoc
         */
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