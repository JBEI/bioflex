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
        private var _keywords:Vector.<GenbankKeyword> = new Vector.<GenbankKeyword>();
        private var _features:GenbankFeatureKeyword;
        
        public function GenbankFileModel()
        {
            _locus = new GenbankLocusKeyword();
            _origin = new GenbankOriginKeyword();
            _features = new GenbankFeatureKeyword();
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