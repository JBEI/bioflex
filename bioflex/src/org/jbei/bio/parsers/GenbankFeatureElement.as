package org.jbei.bio.parsers
{
    import org.jbei.bio.parsers.GenbankFeatureQualifier;
    
    public class GenbankFeatureElement
    {
        private var _key:String;
        private var _strand:int;
        private var _featureQualifiers:Vector.<GenbankFeatureQualifier>;
        private var _featureLocations:Vector.<GenbankLocation>;
		
        public function GenbankFeatureElement()
        {
            _featureQualifiers = new Vector.<GenbankFeatureQualifier>();
        }
        
        public function get key():String
        {
            return _key;
        }
        
        public function set key(key:String):void
        {
            _key = key;
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
        
		public function get featureLocations():Vector.<GenbankLocation>
		{
			return _featureLocations;
		}
		
		public function set featureLocations(featureLocations:Vector.<GenbankLocation>):void
		{
			_featureLocations = featureLocations;
		}
    }
}