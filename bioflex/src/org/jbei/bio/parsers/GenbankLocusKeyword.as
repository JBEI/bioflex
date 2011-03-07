package org.jbei.bio.parsers
{
    public class GenbankLocusKeyword extends GenbankKeyword
    {
        
        private var _locusName:String;
        private var _strandType:String;
        private var _sequenceLength:String;
        private var _naType:String;
        private var _linear:Boolean;
        private var _divisionCode:String;
        private var _date:Date;
        
        public function GenbankLocusKeyword()
        {
            super();
        }
        
        public function get locusName():String
        {
            return _locusName;
        }
        
        public function set locusName(locusName:String):void
        {
            _locusName = locusName;
        }
        
        public function get strandType():String
        {
            return _strandType;
        }
        
        public function set strandType(strandType:String):void
        {
            _strandType = strandType;
        }
        
        public function get sequenceLength():String
        {
            return _sequenceLength;
        }
        
        public function set sequenceLength(length:String):void
        {
            _sequenceLength = length;
        }
        
        public function get naType():String
        {
            return _naType;
        }
        
        public function set naType(naType:String):void
        {
            _naType = naType;
        }
        
        public function get linear():Boolean
        {
            return _linear;
        }
        
        public function set linear(linear:Boolean):void
        {
            _linear = linear;
        }
        
    
        public function get divisionCode():String
        {
            return _divisionCode;
        }
        
        public function set divisionCode(divisionCode:String):void
        {
            _divisionCode = divisionCode;
        }
        
        public function get date():Date
        {
            return _date;
        }
        
        public function set date(date:Date):void
        {
            _date = date;
        }
        
    }
}