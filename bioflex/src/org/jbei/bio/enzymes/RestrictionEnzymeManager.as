package org.jbei.bio.enzymes
{
    import mx.core.ByteArrayAsset;
    
    import org.jbei.bio.BioException;

    /**
    * Restriction Enzymes loader.
    * 
    * This is singleton class. To get instance use instance property: <code>RestrictionEnzymeManager.instance</code>.
    * 
    * <pre>
    * Usage:
    * 
    * To get most commonly used restriction enzymes use getCommonRestrictionEnzymes() method:
    * <code>RestrictionEnzymeManager.instance.getCommonRestrictionEnzymes()<code>
    * 
    * To get all REBASE restriction enzymes use getCommonRestrictionEnzymes() method:
    * <code>RestrictionEnzymeManager.instance.getRebaseRestrictionEnzymes()<code>
    * </pre>
    * 
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
        /**
        * Contructor
        * 
        * This is singleton class. Don't use contructor to get instance of the class. Call RestrictionEnzymeManager.instance
        */
        public function RestrictionEnzymeManager()
        {
            if(_instance) {
                throw new BioException("This is singleton class. To get instance use instance property: RestrictionEnzymeManager.instance");
            }
        }
        
        // Properties
        /**
        * Singleton instance property. Use this property to get instance of the RestrictionEnzymeManager class
        */
        public static function get instance():RestrictionEnzymeManager
        {
            if(_instance == null) {
                _instance = new RestrictionEnzymeManager();
            }
            
            return _instance;
        }
        
        // Public Methods
        /**
        * Get list of the most commonly used restriction enzymes. 
        * 
        * @return List of most common enzymes 
        */
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
        
        /**
         * Get list of all REBASE database restriction enzymes.
         * 
         * @return List of all enzymes from REBASE database 
         */
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
