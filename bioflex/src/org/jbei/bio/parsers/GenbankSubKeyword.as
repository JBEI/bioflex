package org.jbei.bio.parsers
{
    public class GenbankSubKeyword
    {
        private var _key:String;
        private var _value:String;
        
        public function GenbankSubKeyword()
        {
        }
        
        public function get key():String 
        {
            return _key;
        }
        public function set key(key:String):void
        {
            _key = key;
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