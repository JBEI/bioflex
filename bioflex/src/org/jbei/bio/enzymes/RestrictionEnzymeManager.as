package org.jbei.bio.enzymes
{
    import mx.core.ByteArrayAsset;

    /**
     * @author Zinovii Dmytriv
     */
    public class RestrictionEnzymeManager
    {
        [Embed("assets/rebase.xml", mimeType="application/octet-stream")]
        private static var RebaseEnzymesXML:Class;
        
        [Embed("assets/common.xml", mimeType="application/octet-stream")]
        private static var CommonEnzymesXML:Class;
        
        private static var _instance:RestrictionEnzymeManager = null;
        
        private var commonRestrictionEnzymes:Vector.<RestrictionEnzyme> = null;
        private var rebaseRestrictionEnzymes:Vector.<RestrictionEnzyme> = null;
        
        // Constructor
        public function RestrictionEnzymeManager()
        {
        }
        
        // Properties
        public static function get instance():RestrictionEnzymeManager
        {
            if(_instance == null) {
                _instance = new RestrictionEnzymeManager();
            }
            
            return _instance;
        }
        
        // Public Methods
        public function getCommonRestrictionEnzymes():Vector.<RestrictionEnzyme>
        {
            if(commonRestrictionEnzymes != null) {
                return commonRestrictionEnzymes;
            }
            
            var ba:ByteArrayAsset = ByteArrayAsset(new CommonEnzymesXML());
            var enzymesXML:XML = new XML(ba.readUTFBytes(ba.length));
            
            commonRestrictionEnzymes = parseEnzymesXML(enzymesXML);
            
            return commonRestrictionEnzymes;
        }
        
        public function getRebaseRestrictionEnzymes():Vector.<RestrictionEnzyme>
        {
            if(rebaseRestrictionEnzymes != null) {
                return rebaseRestrictionEnzymes;
            }
            
            var ba:ByteArrayAsset = ByteArrayAsset(new RebaseEnzymesXML());
            var enzymesXML:XML = new XML(ba.readUTFBytes(ba.length));
            
            rebaseRestrictionEnzymes = parseEnzymesXML(enzymesXML);
            
            return rebaseRestrictionEnzymes;
        }
        
        // Private Methods
        private function parseEnzymesXML(enzymesXML:XML):Vector.<RestrictionEnzyme>
        {
            var enzymes:Vector.<RestrictionEnzyme> = new Vector.<RestrictionEnzyme>();
            
            for each (var enzymeXML:XML in enzymesXML.e) {
                var name:String = enzymeXML.n;
                var site:String = enzymeXML.s;
                
                var forwardRegex:String = enzymeXML.fr;
                forwardRegex = forwardRegex.toLowerCase();
                
                var reverseRegex:String = enzymeXML.rr;
                reverseRegex = reverseRegex.toLowerCase();
                
                var cutType:String = enzymeXML.c;
                
                var re:RestrictionEnzyme = new RestrictionEnzyme(name, site, cutType == "0" ? 0 : 1, forwardRegex, reverseRegex, -1, -1, -1, -1);
                
                if(enzymeXML.ds != null && enzymeXML.ds.toString() != "") {
                    re.dsForward = enzymeXML.ds.df
                    re.dsReverse = enzymeXML.ds.dr;
                }
                
                if(enzymeXML.us != null && enzymeXML.us.toString() != "") {
                    re.usForward = enzymeXML.us.uf
                    re.usReverse = enzymeXML.us.ur;
                }
                
                enzymes.push(re);
            }
            
            return enzymes;
        }
    }
}
