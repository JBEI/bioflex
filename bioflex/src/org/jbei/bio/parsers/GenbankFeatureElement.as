package org.jbei.bio.parsers
{
    import org.jbei.bio.parsers.GenbankFeatureQualifier;
    
    public class GenbankFeatureElement
    {
        private var _key:String;
        private var _genbankStart:int;
        private var _end:int;
        private var _strand:int;
        private var _featureQualifiers:Vector.<GenbankFeatureQualifier>;
        
        public function GenbankFeatureElement()
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
        
        public function get genbankStart():int
        {
            return _genbankStart;
        }

        public function set genbankStart(genbankStart:int):void
        {
            _genbankStart = genbankStart;
        }

        public function get end():int
        {
            return _end;
        }
        
        public function set end(end:int):void
        {
            _end = end;
        }            
        
        public function get strand():int
        {
            return _strand;
        }
        
        public function set strand(strand:int):void
        {
            _strand = strand;
        }
        
        public function get featureQualifiers():Vector.<GenbankFeatureQualifier>
        {
            return _featureQualifiers;
        }
        
        public function set featureQualifiers(featureQualifiers:Vector.<GenbankFeatureQualifier>):void
        {
            _featureQualifiers = featureQualifiers;
        }
        
    }
}