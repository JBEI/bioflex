package org.jbei.bio.parsers
{
    public class GenbankFeatureKeyword extends GenbankKeyword
    {
        private var _features:Vector.<GenbankFeatureElement>;
        
        public function get features():Vector.<GenbankFeatureElement>
        {
            return _features;
        }
        
        public function set features(features:Vector.<GenbankFeatureElement>):void
        {
            _features = features;
        }
        
        public function GenbankFeatureKeyword()
        {
            super();
            _features = new Vector.<GenbankFeatureElement>();
        }
    }
}