package org.jbei.bio.orf
{
    import org.jbei.bio.sequence.TranslationUtils;
    import org.jbei.bio.sequence.alphabets.ProteinAlphabet;
    import org.jbei.bio.sequence.common.StrandType;
    import org.jbei.bio.sequence.common.SymbolList;
    import org.jbei.bio.sequence.symbols.GapSymbol;
    import org.jbei.bio.sequence.symbols.ISymbol;
    import org.jbei.bio.sequence.symbols.NucleotideSymbol;
    
    /**
    * Helper class to find Open Read Frames in DNA sequence.
    * 
    * @author Zinovii Dmytriv
    */
    public class ORFFinder
    {
        // Public Methods
        /**
        * Calculates Open Read Frame for DNA sequence and filters it by minimum length. No open read frames shorter then minimum length will be listed.
        * 
        * @param dnaSymbolList DNA sequence.
        * @param minumumLength Frame minimum length. If value is -1 then no minimum length is defined. Default -1.
        * @return List of Open read frames.  
        */
        public static function calculateORFs(dnaSymbolList:SymbolList, minimumLength:int = -1):Vector.<ORF>
        {
            if(! dnaSymbolList || dnaSymbolList.length < 6) {
                return new Vector.<ORF>();
            }
            
            var orfs1:Vector.<ORF> = orfPerFrame(0, dnaSymbolList, minimumLength);
            var orfs2:Vector.<ORF> = orfPerFrame(1, dnaSymbolList, minimumLength);
            var orfs3:Vector.<ORF> = orfPerFrame(2, dnaSymbolList, minimumLength);
            
            return orfs1.concat(orfs2, orfs3);
        }
        
        /**
         * Calculates Open Read Frame for DNA sequence in both directions and filters it by minimum length. No open read frames shorter then minimum length will be listed.
         * 
         * @param forwardSymbolList DNA sequence.
         * @param reverseSymbolList DNA sequence.
         * @param minumumLength Frame minimum length. If value is -1 then no minimum length is defined. Default -1.
         * @return List of Open read frames.  
         */
        public static function calculateORFBothDirections(forwardSymbolList:SymbolList, reverseSymbolList:SymbolList, minimumLength:int = -1):Vector.<ORF>
        {
            if(! forwardSymbolList || forwardSymbolList.length < 6) {
                return new Vector.<ORF>();
            }
            
            var result:Vector.<ORF> = new Vector.<ORF>();
            
            var orfs1Forward:Vector.<ORF> = orfPerFrame(0, forwardSymbolList, minimumLength, StrandType.FORWARD);
            var orfs2Forward:Vector.<ORF> = orfPerFrame(1, forwardSymbolList, minimumLength, StrandType.FORWARD);
            var orfs3Forward:Vector.<ORF> = orfPerFrame(2, forwardSymbolList, minimumLength, StrandType.FORWARD);
            
            var orfs1Reverse:Vector.<ORF> = orfPerFrame(0, reverseSymbolList, minimumLength, StrandType.BACKWARD);
            var orfs2Reverse:Vector.<ORF> = orfPerFrame(1, reverseSymbolList, minimumLength, StrandType.BACKWARD);
            var orfs3Reverse:Vector.<ORF> = orfPerFrame(2, reverseSymbolList, minimumLength, StrandType.BACKWARD);
            
            var reverseCombined:Vector.<ORF> = orfs1Reverse.concat(orfs2Reverse, orfs3Reverse);
            
            var sequenceLength:int = reverseSymbolList.length;
            for(var i:int = 0; i < reverseCombined.length; i++) {
                var orf:ORF = reverseCombined[i] as ORF;
                
                var start:int = sequenceLength - orf.start;
                var end:int = sequenceLength - orf.end;
                
                orf.start = end;
                orf.end = start;
                
                for(var j:int = 0; j < orf.startCodons.length; j++) {
                    orf.startCodons[j] = sequenceLength - orf.startCodons[j] - 1;
                }
                
                orf.startCodons.sort(codonsSort);
            }
            
            return result.concat(orfs1Forward, orfs2Forward, orfs3Forward, reverseCombined);
        }
        
        // Private Methods
        private static function orfPerFrame(frame:int, dnaSymbolList:SymbolList, minimumLength:int = -1, strand:int = 1):Vector.<ORF>
        {
            var orfs:Vector.<ORF> = new Vector.<ORF>();
            var sequenceLength:int = dnaSymbolList.length;
            
            var index:int = frame;
            var startIndex:int = -1;
            var endIndex:int = -1;
            var startCodonIndexes:Vector.<int> = new Vector.<int>();
            var possibleStopCodon:Boolean = false;
            while(true) {
                if(index + 2 >= sequenceLength) { break; }
                
                var n1:ISymbol = dnaSymbolList.symbolAt(index);
                var n2:ISymbol = dnaSymbolList.symbolAt(index + 1);
                var n3:ISymbol = dnaSymbolList.symbolAt(index + 2);
                
                var aaSymbol:ISymbol = TranslationUtils.dnaToProteinSymbol(n1, n2, n3);
                
                possibleStopCodon = false;
                
                if(aaSymbol == ProteinAlphabet.instance.gap && !TranslationUtils.isStartCodon(n1, n2, n3)) {
                    if(evaluatePossibleStop(n1, n2, n3)) {
                        possibleStopCodon = true;
                    }
                }
                
                if(!possibleStopCodon && TranslationUtils.isStartCodon(n1, n2, n3)) {
                    if(startIndex == -1) {
                        startIndex = index;
                    }
                    
                    if(startCodonIndexes == null) {
                        startCodonIndexes = new Vector.<int>();
                    }
                    startCodonIndexes.push(index);
                    
                    index += 3;
                    
                    continue;
                }
                
                if(possibleStopCodon || TranslationUtils.isStopCodon(n1, n2, n3)) {
                    if(startIndex != -1) {
                        endIndex = index + 2;
                        if(minimumLength == -1 || (Math.abs(endIndex - startIndex) + 1 >= minimumLength)) {
                            if(startCodonIndexes == null) {
                                startCodonIndexes = new Vector.<int>();
                            }
                            orfs.push(new ORF(startIndex, endIndex + 1, strand, frame, startCodonIndexes));
                        }
                    }
                    
                    startIndex = -1;
                    endIndex = -1;
                    startCodonIndexes = null;
                    
                    index += 3;
                    
                    continue;
                }
                
                index += 3;
            }
            
            return orfs;
        }
        
        private static function evaluatePossibleStop(nucleotide1:ISymbol, nucleotide2:ISymbol, nucleotide3:ISymbol):Boolean
        {
            if(nucleotide1 is GapSymbol || nucleotide2 is GapSymbol || nucleotide3 is GapSymbol) {
                return true;
            }
            
            var n1:Vector.<ISymbol> = (nucleotide1 as NucleotideSymbol).ambiguousMatches ? (nucleotide1 as NucleotideSymbol).ambiguousMatches : Vector.<ISymbol>([nucleotide1]);
            var n2:Vector.<ISymbol> = (nucleotide2 as NucleotideSymbol).ambiguousMatches ? (nucleotide2 as NucleotideSymbol).ambiguousMatches : Vector.<ISymbol>([nucleotide2]);
            var n3:Vector.<ISymbol> = (nucleotide3 as NucleotideSymbol).ambiguousMatches ? (nucleotide3 as NucleotideSymbol).ambiguousMatches : Vector.<ISymbol>([nucleotide3]);
            
            for(var i1:int = 0; i1 < n1.length; i1++) {
                for(var i2:int = 0; i2 < n2.length; i2++) {
                    for(var i3:int = 0; i3 < n3.length; i3++) {
                        var testCodon:String = n1[i1] + n2[i2] + n3[i3];
                        
                        if(TranslationUtils.isStopCodon(n1[i1], n2[i2], n3[i3])) {
                            return true;
                        }
                    }
                }
            }
            
            return false;
        }
        
        private static function codonsSort(a:int, b:int):Number
        {
            if(a > b) {
                return 1;
            } else if(a < b) {
                return -1;
            } else  {
                return 0;
            }
        }
    }
}