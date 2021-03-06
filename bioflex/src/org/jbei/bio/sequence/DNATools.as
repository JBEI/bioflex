package org.jbei.bio.sequence
{
    import org.jbei.bio.sequence.alphabets.DNAAlphabet;
    import org.jbei.bio.sequence.common.Sequence;
    import org.jbei.bio.sequence.common.SymbolList;
    import org.jbei.bio.sequence.dna.DNASequence;
    import org.jbei.bio.sequence.symbols.ISymbol;
    import org.jbei.bio.sequence.symbols.IllegalSymbolException;

    /**
    * DNA tools. Main class used to create DNA sequence.
    * 
    * @author Zinovii Dmytriv
    */
    public class DNATools
    {
        /**
        * Create DNA sequence from string. 
        * 
        * @param dnaSequence Sequence string that is going to be translated into DNA sequence
        * @return DNA Sequence
        */
        public static function createDNA(dnaSequence:String):SymbolList
        {
            var dnaAlphabet:DNAAlphabet = DNAAlphabet.instance;
            
            dnaSequence = dnaSequence.toLowerCase();
            
            var symbolVector:Vector.<ISymbol> = new Vector.<ISymbol>();
            for(var i:int = 0; i < dnaSequence.length; i++) {
                var symbol:ISymbol = dnaAlphabet.symbolByValue(dnaSequence.charAt(i));
                
                if(symbol == null) {
                    throw new IllegalSymbolException();
                }
                
                symbolVector.push(symbol);
            }
            
            return new SymbolList(symbolVector, dnaAlphabet);
        }
        
        /**
         * Create DNA sequence from string with specific name. 
         * 
         * @param name Sequence name
         * @param dnaSequence Sequence string that is going to be translated into DNA sequence
         * @return DNA Sequence
         * @throws org.jbei.bio.exceptions.IllegalSymbolException 
         */
        public static function createDNASequence(name:String, dnaSequence:String):DNASequence
        {
            return new DNASequence(createDNA(dnaSequence), name);
        }
        
        /**
         * Calculates complement symbol for another DNA symbol. 
         * 
         * @param symbol DNA symbol
         * @return Complement DNA symbol
         * @throws org.jbei.bio.exceptions.IllegalSymbolException 
         */
        public static function complementSymbol(symbol:ISymbol):ISymbol
        {
            var dnaAlphabet:DNAAlphabet = DNAAlphabet.instance;
            
            switch(symbol.value) {
                case dnaAlphabet.a.value:
                    return dnaAlphabet.t;
                case dnaAlphabet.t.value:
                    return dnaAlphabet.a;
                case dnaAlphabet.g.value:
                    return dnaAlphabet.c;
                case dnaAlphabet.c.value:
                    return dnaAlphabet.g;
                case dnaAlphabet.y.value:
                    return dnaAlphabet.r;
                case dnaAlphabet.r.value:
                    return dnaAlphabet.y;
                case dnaAlphabet.s.value:
                    return dnaAlphabet.s;
                case dnaAlphabet.w.value:
                    return dnaAlphabet.w;
                case dnaAlphabet.k.value:
                    return dnaAlphabet.m;
                case dnaAlphabet.m.value:
                    return dnaAlphabet.k;
                case dnaAlphabet.b.value:
                    return dnaAlphabet.v;
                case dnaAlphabet.v.value:
                    return dnaAlphabet.b;
                case dnaAlphabet.d.value:
                    return dnaAlphabet.h;
                case dnaAlphabet.h.value:
                    return dnaAlphabet.d;
                case dnaAlphabet.n.value:
                    return dnaAlphabet.n;
                case dnaAlphabet.gap.value:
                    return dnaAlphabet.gap;
                default:
                    throw new IllegalSymbolException("Failed to find complement for symbol '" + symbol.value + "'");
            }
        }
        
        /**
        * Build complement DNA sequence for given DNA sequence. 
        *  
        * @throws org.jbei.bio.exceptions.IllegalSymbolException
        * @param symbolList DNA sequence
        * @return Complement DNA sequence 
        */
        public static function complement(symbolList:SymbolList):SymbolList
        {
            var symbols:Vector.<ISymbol> = symbolList.symbols;
            var complementSymbols:Vector.<ISymbol> = new Vector.<ISymbol>();
            
            if(symbols.length > 0) {
                for(var i:int = 0; i < symbols.length; i++) {
                    complementSymbols.push(complementSymbol(symbols[i]));
                }
            }
            
            return new SymbolList(complementSymbols, DNAAlphabet.instance);
        }
        
        /**
         * Build reverse complement DNA sequence for given DNA sequence. 
         *  
         * @throws org.jbei.bio.exceptions.IllegalSymbolException
         * @param symbolList DNA sequence
         * @return Reverse complement DNA sequence 
         */
        public static function reverseComplement(symbolList:SymbolList):SymbolList
        {
            var symbols:Vector.<ISymbol> = symbolList.symbols;
            var reverseComplementSymbols:Vector.<ISymbol> = new Vector.<ISymbol>();
            
            if(symbols.length > 0) {
                var length:int = symbols.length;
                
                for(var i:int = length; i > 0; i--) {
                    reverseComplementSymbols.push(complementSymbol(symbols[i - 1]));
                }
            }
            
            return new SymbolList(reverseComplementSymbols, DNAAlphabet.instance);
        }
    }
}
