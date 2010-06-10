package org.jbei.bio.sequence.symbols
{
    /**
     * @author Zinovii Dmytriv
     */
    [RemoteClass(alias="org.jbei.bio.sequence.symbols.NucleotideSymbol")]
    public class NucleotideSymbol implements ISymbol
    {
        private var _name:String;
        private var _value:String;
        private var _ambiguousMatches:Vector.<ISymbol>;
        
        // Constructor
        public function NucleotideSymbol(name:String = "", value:String = "", ambiguousMatches:Vector.<ISymbol> = null)
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
        
        public function set name(value:String):void
        {
            _name = value;
        }
        
        public function get value():String
        {
            return _value;
        }
        
        public function set value(value:String):void
        {
            _value = value;
        }
        
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
