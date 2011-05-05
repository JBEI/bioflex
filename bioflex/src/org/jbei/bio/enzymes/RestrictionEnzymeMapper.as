package org.jbei.bio.enzymes
{
    import flash.utils.Dictionary;
    
    import org.jbei.bio.sequence.common.StrandType;
    import org.jbei.bio.sequence.common.SymbolList;

    /**
    * Restriction Enzymes cutter. Finds restriction enzyme sites in DNA sequence.
    * 
    * @see org.jbei.bio.enzymes.RestrictionEnzyme
    * @see org.jbei.bio.enzymes.RestrictionCutSite
    * 
    * @author Zinovii Dmytriv
    */
    public class RestrictionEnzymeMapper
    {
        /**
        * Cut sequence by list of restriction enzymes.
        * 
        * @param restrictionEnzymes List of restriction enzymes to cut sequence with
        * @param symbolList DNA sequence
        * @return Dictionary/Map where RestrictionEnzyme object is a key and List(Vector) of RestrictionCutSite is a value.
        * 
        * @see org.jbei.bio.enzymes.RestrictionCutSite
        */
        public static function cutSequence(restrictionEnzymes:Vector.<RestrictionEnzyme>, symbolList:SymbolList):Dictionary /* [RestrictionEnzyme] = Vector(RestrictionCutSite) */
        {
            var reCuts:Dictionary = new Dictionary();
            
            for(var i:int = 0; i < restrictionEnzymes.length; i++) {
                var re:RestrictionEnzyme = restrictionEnzymes[i] as RestrictionEnzyme;
                
                reCuts[re] = cutSequenceByRestrictionEnzyme(re, symbolList);
            }
            
            return reCuts;
        }
        
        /**
         * Cut sequence with one restriction enzyme.
         * 
         * @param restrictionEnzyme Restriction enzyme to cut sequence with
         * @param symbolList DNA sequence
         * @return List of RestrictionCutSite-s
         * 
         * @see org.jbei.bio.enzymes.RestrictionCutSite
         */
        public static function cutSequenceByRestrictionEnzyme(restrictionEnzyme:RestrictionEnzyme, sequenceSymbolList:SymbolList):Vector.<RestrictionCutSite> /* of RestrictionCutSite */
        {
            var restrictionCutSites:Vector.<RestrictionCutSite> = new Vector.<RestrictionCutSite>();
            
            var forwardRegExpPattern:RegExp = new RegExp(restrictionEnzyme.forwardRegex.toLowerCase(), "g");
            var reverseRegExpPattern:RegExp = new RegExp(restrictionEnzyme.reverseRegex.toLowerCase(), "g");
            
            var reLength:int = restrictionEnzyme.site.length;
            if(restrictionEnzyme.site.length != restrictionEnzyme.dsForward + restrictionEnzyme.dsReverse) {
                reLength = restrictionEnzyme.dsForward;
            }
            
            var sequence:String = sequenceSymbolList.seqString();
            var seqLength:int = sequence.length;
            
            var match:Object = forwardRegExpPattern.exec(sequence);
            while (match != null) {
                if(match.index >= seqLength) { break; } // break when cut site start is more then seq length, because it means it's duplicate
                
                if(seqLength <= match.index + reLength - 1) { break; } // sequence is too short
                
                var restrictionCutSite:RestrictionCutSite = new RestrictionCutSite(match.index, match.index + reLength, StrandType.FORWARD, restrictionEnzyme);
                
                restrictionCutSites.push(restrictionCutSite);
                
                match = forwardRegExpPattern.exec(sequence);
            }
            
            if(! restrictionEnzyme.isPalindromic()) {
                var match2:Object = reverseRegExpPattern.exec(sequence);
                while (match2 != null) {
                    if(match2.index >= seqLength) { break; } // break when cut site start is more then seq length, because it means it's duplicate
                    
                    if(seqLength <= match2.index + reLength - 1) { break; } // sequence is too short
                    
                    var restrictionCutSite2:RestrictionCutSite = new RestrictionCutSite(match2.index, match2.index + reLength, StrandType.BACKWARD, restrictionEnzyme);
                    
                    restrictionCutSites.push(restrictionCutSite2);
                    
                    match2 = reverseRegExpPattern.exec(sequence);
                }
            }
            
            return restrictionCutSites;
        }
    }
}