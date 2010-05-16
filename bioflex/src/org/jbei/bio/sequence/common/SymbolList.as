package org.jbei.bio.sequence.common
{
	import org.jbei.bio.sequence.alphabets.IAlphabet;
	import org.jbei.bio.sequence.symbols.ISymbol;

    /**
     * @author Zinovii Dmytriv
     */
	public class SymbolList
	{
		private var _symbols:Vector.<ISymbol>;
		private var _alphabet:IAlphabet;
		
		// Constructor
		public function SymbolList(symbols:Vector.<ISymbol>, alphabet:IAlphabet)
		{
			_symbols = symbols;
			_alphabet = alphabet;
		}
		
		// Properties
		public function get alphabet():IAlphabet {
			return _alphabet;
		}
		
		public function get length():int {
			return _symbols.length;
		}
		
		// Public Methods
		/* @throws RangeError */
		public function symbolAt(position:int):ISymbol
		{
			return _symbols[position];
		}
		
		/* @throws RangeError */
		public function hasGap():Boolean
		{
			return _symbols.indexOf(_alphabet.gap) > 0;
		}

		public function subList(start:int, end:int):SymbolList
		{
			var subSymbols:Vector.<ISymbol> = _symbols.slice(start, end);
			
			return new SymbolList(subSymbols, alphabet);
		}
		
		public function seqString():String
		{
			var buffer:Array = new Array(_symbols.length);
			
			for(var i:int = 0; i < _symbols.length; i++) {
				buffer[i] = _symbols[i].value.charCodeAt(0);
			}
			
			return String.fromCharCode.apply(null, buffer);
		}
		
		public function clear():void
		{
			_symbols.splice(0, _symbols.length);
		}
		
		public function symbols():Vector.<ISymbol>
		{
			var clonedVector:Vector.<ISymbol> = new Vector.<ISymbol>(_symbols.length, true);
			
			if(_symbols.length > 0) {
				for(var i:int = 0; i < _symbols.length; i++) {
					clonedVector[i] = _symbols[i];
				}
			}
			
			return clonedVector;
		}
		
		public function addSymbols(newSymbols:SymbolList):void
		{
			_symbols.concat(newSymbols.symbols());
		}
		
		/* @throws RangeError */
		public function deleteSymbols(start:int, length:int):void
		{
			var end:int = start + length;
			
			_symbols.splice(start, length);
		}
		
		/* @throws RangeError */
		public function insertSymbols(position:int, newSymbols:SymbolList):void
		{
			_symbols.splice(position, 0, newSymbols.symbols());
		}
	}
}
