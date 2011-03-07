package org.jbei.bio.parsers
{
    public class GenbankOriginKeyword extends GenbankKeyword
    {
        private var _sequence:String;
        
        public function GenbankOriginKeyword()
        {
            super();
        }
        
        public function get sequence():String
        {
            return _sequence;
        }
        
        public function set sequence(sequence:String):void
        {
            _sequence = sequence;
        }
    }
}