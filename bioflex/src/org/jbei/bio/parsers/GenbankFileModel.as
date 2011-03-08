package org.jbei.bio.parsers
{
    
    /**
    * @author Timothy Ham
    * 
    * A complete description of a Genbank file
    * 
    */
     
    public class GenbankFileModel
    {
        private var _locus:GenbankLocusKeyword;
        private var _origin:GenbankOriginKeyword;
        private var _accession:String;
        private var _version:String;
        private var _keywordsTag:String;
        private var _keywords:Vector.<GenbankKeyword>;
        private var _features:GenbankFeatureKeyword;
        
        public function GenbankFileModel()
        {
            _locus = new GenbankLocusKeyword();
            _origin = new GenbankOriginKeyword();
            _features = new GenbankFeatureKeyword();
            _keywords = new Vector.<GenbankKeyword>();
        }
        
        public function get locus():GenbankLocusKeyword
        {
            return _locus;
        }
        
        public function set locus(locus:GenbankLocusKeyword):void
        {
            _locus = locus;
        }
        
        public function get origin():GenbankOriginKeyword
        {
            return _origin;
        }
        
        public function set origin(origin:GenbankOriginKeyword):void
        {
            _origin = origin;
        }
        
        public function get accession():String 
        {
            if (_accession == null) {
                return locus.locusName;
            } else {
                return _accession;
            }
        }
        
        public function set accession(accession:String):void
        {
            _accession = accession;
        }
        
        public function get version():String
        {
            if (_version == null) {
                return locus.locusName;
            } else {
                return _version;
            }
        }
        
        public function set version(version:String):void
        {
            _version = version;
        }
        
        public function get keywordsTag():String
        {
            if (_keywordsTag == null) {
                return ".";
            } else {
                return _keywordsTag;
            }
        }
        
        public function set keywordsTag(keywordsTag:String):void
        {
            _keywordsTag = keywordsTag;
        }
        
        public function get keywords():Vector.<GenbankKeyword> {
            return _keywords;
        }
        
        public function get features():GenbankFeatureKeyword {
            return _features;
        }
        
        public function set features(features:GenbankFeatureKeyword):void
        {
            _features = features;
        }
    }
}