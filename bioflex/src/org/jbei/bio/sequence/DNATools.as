package org.jbei.bio.sequence
{
	import org.jbei.bio.sequence.alphabets.DNAAlphabet;
	import org.jbei.bio.sequence.common.Sequence;
	import org.jbei.bio.sequence.common.SymbolList;
	import org.jbei.bio.sequence.dna.DNASequence;
	import org.jbei.bio.sequence.symbols.ISymbol;
	import org.jbei.bio.sequence.symbols.IllegalSymbolException;
	import org.jbei.bio.sequence.symbols.NucleotideSymbol;

	public class DNATools
	{
		/* @throws org.jbei.bio.exceptions.IllegalSymbolException */
		public static function createDNA(dnaSequence:String):SymbolList
		{
			var dnaAlphabet:DNAAlphabet = DNAAlphabet.instance;
			
			dnaSequence = dnaSequence.toLowerCase();
			
			var symbolVector:Vector.<ISymbol> = new Vector.<ISymbol>(dnaSequence.length, true);
			for(var i:int = 0; i < dnaSequence.length; i++) {
				var symbol:NucleotideSymbol = dnaAlphabet.symbolByValue(dnaSequence.charAt(i));
				
				if(symbol == null) {
					throw new IllegalSymbolException();
				}
				
				symbolVector[i] = symbol;
			}
			
			return new SymbolList(symbolVector, dnaAlphabet);
		}
		
		/* @throws org.jbei.bio.exceptions.IllegalSymbolException */
		public static function createDNASequence(dnaSequence:String, name:String):Sequence
		{
			return new DNASequence(name, createDNA(dnaSequence));
		}
		
		/* @throws org.jbei.bio.exceptions.IllegalSymbolException */
		public static function complementSymbol(symbol:NucleotideSymbol):NucleotideSymbol
		{
			var dnaAlphabet:DNAAlphabet = DNAAlphabet.instance;
			
			if(symbol == dnaAlphabet.a) {
				return dnaAlphabet.t;
			} else if(symbol == dnaAlphabet.t) {
				return dnaAlphabet.a;
			} else if(symbol == dnaAlphabet.g) {
				return dnaAlphabet.c;
			} else if(symbol == dnaAlphabet.c) {
				return dnaAlphabet.g;
			} else if(symbol == dnaAlphabet.y) {
				return dnaAlphabet.r;
			} else if(symbol == dnaAlphabet.r) {
				return dnaAlphabet.y;
			} else if(symbol == dnaAlphabet.s) {
				return dnaAlphabet.s;
			} else if(symbol == dnaAlphabet.w) {
				return dnaAlphabet.w;
			} else if(symbol == dnaAlphabet.k) {
				return dnaAlphabet.m;
			} else if(symbol == dnaAlphabet.m) {
				return dnaAlphabet.k;
			} else if(symbol == dnaAlphabet.b) {
				return dnaAlphabet.v;
			} else if(symbol == dnaAlphabet.v) {
				return dnaAlphabet.b;
			} else if(symbol == dnaAlphabet.d) {
				return dnaAlphabet.h;
			} else if(symbol == dnaAlphabet.h) {
				return dnaAlphabet.d;
			} else if(symbol == dnaAlphabet.n) {
				return dnaAlphabet.n;
			} else {
				throw new IllegalSymbolException("Failed to find complement for symbol '" + symbol.value + "'");
			}
		}
		
		/* @throws org.jbei.bio.exceptions.IllegalSymbolException */
		public static function complement(symbolList:SymbolList):SymbolList
		{
			var symbols:Vector.<ISymbol> = symbolList.symbols();
			var complementSymbols:Vector.<ISymbol> = new Vector.<ISymbol>(symbols.length, true);
			
			if(symbols.length > 0) {
				for(var i:int = 0; i < symbols.length; i++) {
					complementSymbols[i] = complementSymbol(symbols[i] as NucleotideSymbol);
				}
			}
			
			return new SymbolList(complementSymbols, DNAAlphabet.instance);
		}
		
		/* @throws org.jbei.bio.exceptions.IllegalSymbolException */
		public static function reverseComplement(symbolList:SymbolList):SymbolList
		{
			var symbols:Vector.<ISymbol> = symbolList.symbols();
			var reverseComplementSymbols:Vector.<ISymbol> = new Vector.<ISymbol>(symbols.length, true);
			
			if(symbols.length > 0) {
				var length:int = symbols.length;
				
				for(var i:int = 0; i < length; i++) {
					reverseComplementSymbols[length - i - 1] = complementSymbol(symbols[i] as NucleotideSymbol);
				}
			}
			
			return new SymbolList(reverseComplementSymbols, DNAAlphabet.instance);
		}
	}
}
