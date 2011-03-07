package org.jbei.bio.parsers
{
    public class GenbankKeyword
    {
        private var _keyword:String;
        private var _value:String;
        private var _subKeywords:Vector.<GenbankSubKeyword>;
        
        public function GenbankKeyword()
        {
        }
        
        public function get keyword():String
        {
            return _keyword;
        }
        
        public function set keyword(keyword:String):void
        {
            _keyword = keyword;
        }
        
        public function get value():String
        {
            return _value;
        }
        
        public function set value(value:String):void
        {
            _value = value;
        }
        
        public function get subKeywords():Vector.<GenbankSubKeyword>
        {
            return _subKeywords;
        }
        
        public function set subKeywords(subKeywords:Vector.<GenbankSubKeyword>):void
        {
            _subKeywords = subKeywords;
        }
        
    }
}