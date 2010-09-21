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
                var fragment:DigestionFragment = new DigestionFragment(reSitesList[i].start, reSitesList[i+1].end, reSitesList[i+1].end-reSitesList[i].start, reSitesList[i].restrictionEnzyme, reSitesList[i+1].restrictionEnzyme);
                fragments.push(fragment);
            }
            if (dnaSequence.circular) {
                var fragLength:int = reSitesList[0].end - reSitesList[reSitesList.length-1].start + dnaSequence.length;
                fragment = new DigestionFragment(reSitesList[reSitesList.length-1].start, reSitesList[0].end, fragLength, reSitesList[reSitesList.length-1].restrictionEnzyme, reSitesList[0].restrictionEnzyme);
                fragments.push(fragment);
            } else {
                fragment = new DigestionFragment(0, reSitesList[0].end, reSitesList[0].end, null, reSitesList[0].restrictionEnzyme);
                fragments.push(fragment);
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