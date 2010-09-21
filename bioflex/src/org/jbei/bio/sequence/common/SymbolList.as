package org.jbei.bio.sequence.common
{
    import org.jbei.bio.sequence.alphabets.IAlphabet;
    import org.jbei.bio.sequence.symbols.ISymbol;

    [RemoteClass(alias="org.jbei.bio.sequence.common.SymbolList")]
    
    /**
    * Main class for all sequence in the library.
    * 
    * @author Zinovii Dmytriv
    */
    public class SymbolList
    {
        private var _symbols:Vector.<ISymbol>;
        private var _alphabet:IAlphabet;
        
        // Constructor
        /**
        * Contructor
        * 
        * @param symbols List of symbols to create sequence from
        * @param alphabet Sequence alphabet that defines sequence type
        */
        public function SymbolList(symbols:Vector.<ISymbol> = null, alphabet:IAlphabet = null)
        {
            _symbols = symbols;
            _alphabet = alphabet;
        }
        
        // Properties
        /**
        * Current sequence alphabet
        */
        public function get alphabet():IAlphabet {
            return _alphabet;
        }
        
        /**
        * This method used only for serialization/deserialization
        * 
        * @private
        */
        public function set alphabet(value:IAlphabet):void {
            _alphabet = value;
        }
        
        /**
         * List of sequence symbols
         */
        public function get symbols():Vector.<ISymbol> {
            return _symbols;
        }
        
        /**
         * This method used only for serialization/deserialization
         * 
         * @private
         */
        public function set symbols(value:Vector.<ISymbol>):void {
            _symbols = value;
        }
        
        /**
        * Sequence length
        */
        public function get length():int {
            return _symbols.length;
        }
        
        // Public Methods
        /**
        * Get symbol at position.
        * 
        * @param position Position to get symbol at
        * @return Symbol
        * @throws RangeError 
        */
        public function symbolAt(position:int):ISymbol
        {
            return _symbols[position];
        }
        
        /**
        * Checks if sequence has gap.
        */
        public function hasGap():Boolean
        {
            return _symbols.indexOf(_alphabet.gap) > 0;
        }
        
        /**
        * Makes sublist of symbols. Notice that end position is not inluded.
        * 
        * @param start Start position - included
        * @param end end position - not included
        */
        public function subList(start:int, end:int):SymbolList
        {
            var subSymbols:Vector.<ISymbol> = _symbols.slice(start, end);
            
            return new SymbolList(subSymbols, alphabet);
        }
        
        /**
        * 
        * Translates current sequence into string.
        */
        public function seqString():String
        {
            var buffer:Array = new Array(_symbols.length);
            
            for(var i:int = 0; i < _symbols.length; i++) {
                buffer[i] = _symbols[i].value.charCodeAt(0);
            }
            
            return String.fromCharCode.apply(null, buffer);
        }
        
        /**
        * Clears sequence.
        */
        public function clear():void
        {
            _symbols.splice(0, _symbols.length);
        }
        
        /**
         * Add one symbol to end of the sequence.
         * 
         * @param newSymbol Symbol to add
         */
        public function addSymbols(newSymbols:SymbolList):void
        {
            _symbols = _symbols.concat(newSymbols.symbols);
        }
        
        /**
        * Deletes symbols in range.
        * 
        * @param start Range start
        * @param end Range end (not included)
        */
        public function deleteSymbols(start:int, length:int):void
        {
            var end:int = start + length;
            
            _symbols.splice(start, length);
        }
        
        /**
         * Inserts list of symbols at defined position.
         * 
         * @param position Position to insert list of symbols at
         * @param newSymbols List of symbols to insert
         */
        public function insertSymbols(position:int, newSymbols:SymbolList):void
        {
            // Wasn't able to do this due to Adobe BUG!
            // _symbols.splice(position, 0, newSymbols);
            
            /*for(var i:int = 0; i < newSymbols.length; i++) {
                _symbols.splice(position + i, 0, newSymbols.symbolAt(i));
            }*/
            
            _symbols = _symbols.slice(0, position).concat(newSymbols.symbols).concat(_symbols.slice(position));
        }
    }
}
