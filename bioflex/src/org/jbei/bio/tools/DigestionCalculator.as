package org.jbei.bio.tools
{
    import flash.utils.Dictionary;
    
    import org.jbei.bio.enzymes.RestrictionCutSite;
    import org.jbei.bio.enzymes.RestrictionEnzyme;
    import org.jbei.bio.enzymes.RestrictionEnzymeMapper;
    import org.jbei.bio.sequence.dna.DNASequence;
    import org.jbei.bio.sequence.dna.DigestionFragment;
    
    /**
    * Digestion calculator.
    * */
    public class DigestionCalculator
    {
        /**
        * Calculates position where enzyme cuts sequence and lists digestion fragments.
        * 
        * @param dnaSequence DNA sequence to digest.
        * @param enzymes List of enzymes that participates in digestion.
        * 
        * @return List of digestion fragments
        * */
        public static function digestSequence(dnaSequence:DNASequence, enzymes:Vector.<RestrictionEnzyme>):Vector.<DigestionFragment>
        {
            var reSitesMap:Dictionary = RestrictionEnzymeMapper.cutSequence(enzymes, dnaSequence);
            var reSitesList:Vector.<RestrictionCutSite> = new Vector.<RestrictionCutSite>;
            for each (var sites:Vector.<RestrictionCutSite> in reSitesMap) {
                while (sites.length>0) {
                    reSitesList.push(sites.pop());
                }
            }
            reSitesList.sort(sortByStart);

            var fragments:Vector.<DigestionFragment> = new Vector.<DigestionFragment>;
			
            if (reSitesList.length == 0) {
                return fragments;
            }
			
            for (var i:int = 0; i<reSitesList.length-1; i++) {
                var fragStart:int = reSitesList[i].start;
                var fragEnd:int = reSitesList[i+1].end;
                var fragLength:int = fragEnd - fragStart;
                if (fragLength <= 0) { //happens if wrapping around from end to beginning (for circular dna)
                    fragLength += dnaSequence.length;
                    //note: this will still not catch the case where site i+1 wraps around to the 
                    //beginning of the dna sequence and the two cut sites overlap (thus site i+1 has 
                    //an end smaller than the end of site i, but greater than the start of site i)
                    //this situation is probably not desirable in practice anyway
                }
                
                var fragment:DigestionFragment = new DigestionFragment(fragStart, fragEnd, fragLength, reSitesList[i].restrictionEnzyme, reSitesList[i+1].restrictionEnzyme);
                fragments.push(fragment);
            }
            
            if (dnaSequence.circular) {
                //the fragment that wraps around from the end to the beginning
                var fragLength:int = reSitesList[0].end - reSitesList[reSitesList.length-1].start + dnaSequence.length;
                if (reSitesList.length == 1 && reSitesList[0].end < reSitesList[0].start) {
                    //in the case where there is only one site and the site wraps around from end to beginning
                    fragLength += dnaSequence.length;
                }
                fragment = new DigestionFragment(reSitesList[reSitesList.length-1].start, reSitesList[0].end, fragLength, reSitesList[reSitesList.length-1].restrictionEnzyme, reSitesList[0].restrictionEnzyme);
                fragments.push(fragment);
            } else { //linear case
                //the fragment from the beginning of the sequence to the first digestion site
                fragment = new DigestionFragment(0, reSitesList[0].end, reSitesList[0].end, null, reSitesList[0].restrictionEnzyme);
                fragments.push(fragment);
                //the fragment from the last digestion site to the end of the sequence
                fragment = new DigestionFragment(reSitesList[reSitesList.length-1].start, dnaSequence.length, dnaSequence.length - reSitesList[reSitesList.length-1].start, reSitesList[reSitesList.length-1].restrictionEnzyme, null);
                fragments.push(fragment);
            }

            return fragments;
        }
        
        private static function sortByStart(x:RestrictionCutSite, y:RestrictionCutSite):Number
        {
            if (x.start < y.start) {
                return -1;
            } else if (x.start > y.start) {
                return 1;
            } else {
                return 0;
            }
        }
    }
}