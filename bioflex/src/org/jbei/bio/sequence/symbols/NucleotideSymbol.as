package org.jbei.bio.sequence.symbols
{
    [RemoteClass(alias="org.jbei.bio.sequence.symbols.NucleotideSymbol")]
    /**
    * Nucleotide symbol used for building DNA and RNA sequences. The main customers of the class are <code>DNAAlphabet</code> and <code>RNAAlphabet</code>-s.
    * 
    * @see org.jbei.bio.sequence.alphabets.DNAAlphabet
    * @see org.jbei.bio.sequence.alphabets.RNAAlphabet
    * @author Zinovii Dmytriv
    */
    public class NucleotideSymbol implements ISymbol
    {
        private var _name:String;
        private var _value:String;
        private var _ambiguousMatches:Vector.<ISymbol>;
        
        /**
         * Contructor
         * 
         * @param name Symbol full name
         * @param value One letter symbol value
         * @param ambiguousMatches List of ambiguos matches for this symbol. For example nucleotide symbol 'M' can by either 'A' or 'C', so abiguous matches are {'A', 'C'}
         */
        public function NucleotideSymbol(name:String = "", value:String = "", ambiguousMatches:Vector.<ISymbol> = null)
        {
            _name = name;
            _value = value;
            _ambiguousMatches = ambiguousMatches;
        }
        
        // ISymbol implementation
        /**
         * Full nucleotide name
         */
        public function get name():String
        {
            return _name;
        }
        
        public function set name(value:String):void
        {
            _name = value;
        }
        
        /**
         * Nucleotide name
         */
        public function get value():String
        {
            return _value;
        }
        
        public function set value(value:String):void
        {
            _value = value;
        }
        
        /**
         * Vector of ambiguos matches
         */
        public function get ambiguousMatches():Vector.<ISymbol>
        {
            return _ambiguousMatches; 
        }
        
        public function set ambiguousMatches(value:Vector.<ISymbol>):void
        {
            _ambiguousMatches = value;
        }
    }
}
