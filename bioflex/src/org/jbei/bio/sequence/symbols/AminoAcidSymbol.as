package org.jbei.bio.sequence.symbols
{
    [RemoteClass(alias="org.jbei.bio.sequence.symbols.AminoAcidSymbol")]
    
    /**
    * Amino acid symbol used for building protein sequences. The main customer of the class is <code>ProteinAlphabet</code> class.
    * 
    * @see org.jbei.bio.sequence.alphabets.ProteinAlphabet
    * @author Zinovii Dmytriv
    */
    public class AminoAcidSymbol implements ISymbol
    {
        private var _name:String;
        private var _value:String;
        private var _threeLettersName:String;
        
        /**
        * Contructor
        * 
        * @param name Symbol full name
        * @param threeLettersName Three letter symbol abbreviation
        * @param value One letter symbol value
        */
        public function AminoAcidSymbol(name:String = "", threeLettersName:String = "", value:String = "")
        {
            _name = name;
            _value = value;
            _threeLettersName = threeLettersName;
        }
        
        // ISymbol implementation
        /**
        * Full amino acid name
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
         * Three letters protein symbol abbreviation.
         */
        public function get threeLettersName():String
        {
            return _threeLettersName;
        }
        
        public function set threeLettersName(value:String):void
        {
            _threeLettersName = value;
        }
        
        /**
         * One letter aminoacid value
         */
        public function get value():String
        {
            return _value;
        }
        
        public function set value(value:String):void
        {
            _value = value;
        }
    }
}