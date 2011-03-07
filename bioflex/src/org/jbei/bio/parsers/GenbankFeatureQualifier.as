package org.jbei.bio.parsers
{
    public class GenbankFeatureQualifier
    {
        private var _name:String;
        private var _value:String;
        private var _quoted:Boolean;
        
        public function GenbankFeatureQualifier()
        {
        }
        
        public function get name():String
        {
            return _name;
        }

        public function set name(name:String):void
        {
            _name = name;
        }
        
        public function get value():String
        {
            return _value;
        }
        public function set value(value:String):void
        {
            _value = value;
        }
        
        public function get quoted():Boolean
        {
            return _quoted;
        }
        public function set quoted(quoted:Boolean):void
        {
            _quoted = quoted;
        }
        
    }
}