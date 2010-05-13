package org.jbei.bio.sequence
{
	import org.jbei.bio.sequence.alphabets.DNAAlphabet;
	import org.jbei.bio.sequence.alphabets.RNAAlphabet;
	import org.jbei.bio.sequence.common.SymbolList;
	import org.jbei.bio.sequence.symbols.ISymbol;
	import org.jbei.bio.sequence.symbols.IllegalSymbolException;

	public class TranslationUtils
	{
		private static var dnaAlphabet:DNAAlphabet = DNAAlphabet.instance;
		private static var rnaAlphabet:RNAAlphabet = RNAAlphabet.instance;
		
		/* @throws org.jbei.bio.exceptions.IllegalSymbolException */
		public static function dnaToRNASymbol(symbol:ISymbol):ISymbol
		{
			var dnaAlphabet:DNAAlphabet = DNAAlphabet.instance;
			var rnaAlphabet:RNAAlphabet = RNAAlphabet.instance;
			
			switch(symbol) {
				case dnaAlphabet.a:
					return rnaAlphabet.a;
				case dnaAlphabet.t:
					return rnaAlphabet.u;
				case dnaAlphabet.g:
					return rnaAlphabet.g;
				case dnaAlphabet.c:
					return rnaAlphabet.c;
				case dnaAlphabet.y:
					return rnaAlphabet.y;
				case dnaAlphabet.r:
					return rnaAlphabet.r;
				case dnaAlphabet.s:
					return rnaAlphabet.s;
				case dnaAlphabet.w:
					return rnaAlphabet.w;
				case dnaAlphabet.k:
					return rnaAlphabet.k;
				case dnaAlphabet.m:
					return rnaAlphabet.m;
				case dnaAlphabet.b:
					return rnaAlphabet.b;
				case dnaAlphabet.v:
					return rnaAlphabet.v;
				case dnaAlphabet.d:
					return rnaAlphabet.d;
				case dnaAlphabet.h:
					return rnaAlphabet.h;
				case dnaAlphabet.n:
					return rnaAlphabet.n;
				case dnaAlphabet.gap:
					return rnaAlphabet.gap;
				default:
					throw new IllegalSymbolException("Failed to find rna symbol for '" + symbol.value + "'");
			}
		}
		
		/* @throws org.jbei.bio.exceptions.IllegalSymbolException */
		public static function rnaToDNASymbol(symbol:ISymbol):ISymbol
		{
			var rnaAlphabet:RNAAlphabet = RNAAlphabet.instance;
			var dnaAlphabet:DNAAlphabet = DNAAlphabet.instance;
			
			switch(symbol) {
				case rnaAlphabet.a:
					return dnaAlphabet.a;
				case rnaAlphabet.u:
					return dnaAlphabet.t;
				case rnaAlphabet.g:
					return dnaAlphabet.g;
				case rnaAlphabet.c:
					return dnaAlphabet.c;
				case rnaAlphabet.y:
					return dnaAlphabet.y;
				case rnaAlphabet.r:
					return dnaAlphabet.r;
				case rnaAlphabet.s:
					return dnaAlphabet.s;
				case rnaAlphabet.w:
					return dnaAlphabet.w;
				case rnaAlphabet.k:
					return dnaAlphabet.k;
				case rnaAlphabet.m:
					return dnaAlphabet.m;
				case rnaAlphabet.b:
					return dnaAlphabet.b;
				case rnaAlphabet.v:
					return dnaAlphabet.v;
				case rnaAlphabet.d:
					return dnaAlphabet.d;
				case rnaAlphabet.h:
					return dnaAlphabet.h;
				case rnaAlphabet.n:
					return dnaAlphabet.n;
				default:
					throw new IllegalSymbolException("Failed to find rna symbol for '" + symbol.value + "'");
			}
		}
		
		/* @throws org.jbei.bio.exceptions.IllegalSymbolException */
		public static function dnaToRNA(symbolList:SymbolList):SymbolList
		{
			var symbols:Vector.<ISymbol> = symbolList.symbols();
			var rnaSymbols:Vector.<ISymbol> = new Vector.<ISymbol>(symbols.length, true);
			
			var dnaAlphabet:DNAAlphabet = DNAAlphabet.instance;
			
			if(symbols.length > 0) {
				var length:int = symbols.length;
				
				for(var i:int = 0; i < length; i++) {
					rnaSymbols[i] = dnaToRNASymbol(symbols[i]);
				}
			}
			
			return new SymbolList(rnaSymbols, RNAAlphabet.instance);
		}
		
		/* @throws org.jbei.bio.exceptions.IllegalSymbolException */
		public static function rnaToDNA(symbolList:SymbolList):SymbolList
		{
			var symbols:Vector.<ISymbol> = symbolList.symbols();
			var dnaSymbols:Vector.<ISymbol> = new Vector.<ISymbol>(symbols.length, true);
			
			var rnaAlphabet:RNAAlphabet = RNAAlphabet.instance;
			
			if(symbols.length > 0) {
				var length:int = symbols.length;
				
				for(var i:int = 0; i < length; i++) {
					dnaSymbols[i] = rnaToDNASymbol(symbols[i]);
				}
			}
			
			return new SymbolList(dnaSymbols, DNAAlphabet.instance);
		}
	}
}