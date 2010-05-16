package org.jbei.bio.sequence.symbols
{
    /**
     * @author Zinovii Dmytriv
     */
    public class NucleotideSymbol implements ISymbol
    {
        private var _name:String;
        private var _value:String;
        private var _ambiguousMatches:Vector.<ISymbol>;
        
        // Constructor
        public function NucleotideSymbol(name:String, value:String, ambiguousMatches:Vector.<ISymbol> = null)
        {
            _name = name;
            _value = value;
            _ambiguousMatches = ambiguousMatches;
        }
        
        // ISymbol implementation
        public function get name():String
        {
            return _name;
        }
        
        public function get value():String
        {
            return _value;
        }
        
        public function get ambiguousMatches():Vector.<ISymbol>
        {
            return _ambiguousMatches; 
        }
    }
}
