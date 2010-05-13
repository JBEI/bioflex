package org.jbei.bio.sequence
{
	import flash.utils.Dictionary;
	
	import org.jbei.bio.sequence.alphabets.DNAAlphabet;
	import org.jbei.bio.sequence.alphabets.ProteinAlphabet;
	import org.jbei.bio.sequence.alphabets.RNAAlphabet;
	import org.jbei.bio.sequence.common.SymbolList;
	import org.jbei.bio.sequence.symbols.GapSymbol;
	import org.jbei.bio.sequence.symbols.ISymbol;
	import org.jbei.bio.sequence.symbols.IllegalSymbolException;

	public class TranslationUtils
	{
		private static var dnaAlphabet:DNAAlphabet = DNAAlphabet.instance;
		private static var rnaAlphabet:RNAAlphabet = RNAAlphabet.instance;
		private static var proteinAlphabet:ProteinAlphabet = ProteinAlphabet.instance;
		
		private static var dnaToRNATranslationTable:Dictionary = null;
		private static var rnaToDNATranslationTable:Dictionary = null;
		private static var aminoAcidsTranslationTable:Dictionary = null;
		
		/* @throws org.jbei.bio.exceptions.IllegalSymbolException */
		public static function dnaToRNASymbol(symbol:ISymbol):ISymbol
		{
			initializeDNAToRNATranslationTable();
			
			if(symbol is GapSymbol) {
				return rnaAlphabet.gap;
			}
			
			var newSymbol:ISymbol = dnaToRNATranslationTable[symbol];
			
			if(newSymbol == null) {
				throw new IllegalSymbolException();
			}
			
			return newSymbol;
		}
		
		/* @throws org.jbei.bio.exceptions.IllegalSymbolException */
		public static function rnaToDNASymbol(symbol:ISymbol):ISymbol
		{
			initializeRNAToDNATranslationTable();
			
			if(symbol is GapSymbol) {
				return dnaAlphabet.gap;
			}
			
			var newSymbol:ISymbol = dnaToRNATranslationTable[symbol];
			
			if(newSymbol == null) {
				throw new IllegalSymbolException();
			}
			
			return newSymbol;
		}
		
		/* @throws org.jbei.bio.exceptions.IllegalSymbolException */
		public static function dnaToRNA(symbolList:SymbolList):SymbolList
		{
			var symbols:Vector.<ISymbol> = symbolList.symbols();
			var rnaSymbols:Vector.<ISymbol> = new Vector.<ISymbol>(symbols.length, true);
			
			var length:int = symbols.length;
			
			if(length > 0) {
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
			
			var length:int = symbols.length;
			
			if(length > 0) {
				for(var i:int = 0; i < length; i++) {
					dnaSymbols[i] = rnaToDNASymbol(symbols[i]);
				}
			}
			
			return new SymbolList(dnaSymbols, DNAAlphabet.instance);
		}
		
		public static function rnaToProteinSymbol(nucleotide1:ISymbol, nucleotide2:ISymbol, nucleotide3:ISymbol):ISymbol
		{
			initializeAminoAcidsTranslationTable();
			
			if(nucleotide1 is GapSymbol || nucleotide2 is GapSymbol || nucleotide3 is GapSymbol) {
				return proteinAlphabet.gap;
			}
			
			var triplet:String = nucleotide1.value + nucleotide2.value + nucleotide3.value;
			
			var symbol:ISymbol = aminoAcidsTranslationTable[triplet];
			
			if(symbol == null) {
				return proteinAlphabet.gap;
			}
			
			return symbol;
		}
		
		public static function rnaToProtein(symbolList:SymbolList):SymbolList
		{
			var length:int = symbolList.length - (symbolList.length % 3);
			
			if(length == 0) {
				return new Vector.<ISymbol>();
			}
			
			var proteinSymbols:Vector.<ISymbol> = new Vector.<ISymbol>(length / 3, true);
			
			var symbols:Vector.<ISymbol> = symbolList.symbols();
			
			for(var i:int = 0; i < length; i += 3) {
				proteinSymbols[i / 3] = rnaToProteinSymbol(symbols[i], symbols[i + 1], symbols[i + 2]);
			}
			
			return new SymbolList(proteinSymbols, proteinAlphabet);
		}
		
		private static function initializeAminoAcidsTranslationTable():void
		{
			if(aminoAcidsTranslationTable != null) {
				return;
			}
			
			aminoAcidsTranslationTable = new Dictionary();
			
			aminoAcidsTranslationTable['gcc'] = ProteinAlphabet.instance.alanine;
			aminoAcidsTranslationTable['gca'] = ProteinAlphabet.instance.alanine;
			aminoAcidsTranslationTable['gcg'] = ProteinAlphabet.instance.alanine;
			aminoAcidsTranslationTable['gcu'] = ProteinAlphabet.instance.alanine;
			aminoAcidsTranslationTable['cgc'] = ProteinAlphabet.instance.arginine;
			aminoAcidsTranslationTable['cga'] = ProteinAlphabet.instance.arginine;
			aminoAcidsTranslationTable['cgg'] = ProteinAlphabet.instance.arginine;
			aminoAcidsTranslationTable['aga'] = ProteinAlphabet.instance.arginine;
			aminoAcidsTranslationTable['agg'] = ProteinAlphabet.instance.arginine;
			aminoAcidsTranslationTable['cgu'] = ProteinAlphabet.instance.arginine;
			aminoAcidsTranslationTable['aac'] = ProteinAlphabet.instance.asparagine;
			aminoAcidsTranslationTable['aau'] = ProteinAlphabet.instance.asparagine;
			aminoAcidsTranslationTable['gac'] = ProteinAlphabet.instance.aspartic;
			aminoAcidsTranslationTable['gau'] = ProteinAlphabet.instance.aspartic;
			aminoAcidsTranslationTable['ugu'] = ProteinAlphabet.instance.cysteine;
			aminoAcidsTranslationTable['ugc'] = ProteinAlphabet.instance.cysteine;
			aminoAcidsTranslationTable['gaa'] = ProteinAlphabet.instance.glutamic;
			aminoAcidsTranslationTable['gag'] = ProteinAlphabet.instance.glutamic;
			aminoAcidsTranslationTable['caa'] = ProteinAlphabet.instance.glutamine;
			aminoAcidsTranslationTable['cag'] = ProteinAlphabet.instance.glutamine;
			aminoAcidsTranslationTable['ggc'] = ProteinAlphabet.instance.glycine;
			aminoAcidsTranslationTable['gga'] = ProteinAlphabet.instance.glycine;
			aminoAcidsTranslationTable['ggg'] = ProteinAlphabet.instance.glycine;
			aminoAcidsTranslationTable['ggu'] = ProteinAlphabet.instance.glycine;
			aminoAcidsTranslationTable['cac'] = ProteinAlphabet.instance.histidine;
			aminoAcidsTranslationTable['cau'] = ProteinAlphabet.instance.histidine;
			aminoAcidsTranslationTable['auu'] = ProteinAlphabet.instance.isoleucine;
			aminoAcidsTranslationTable['auc'] = ProteinAlphabet.instance.isoleucine;
			aminoAcidsTranslationTable['aua'] = ProteinAlphabet.instance.isoleucine;
			aminoAcidsTranslationTable['cuu'] = ProteinAlphabet.instance.leucine;
			aminoAcidsTranslationTable['cuc'] = ProteinAlphabet.instance.leucine;
			aminoAcidsTranslationTable['cua'] = ProteinAlphabet.instance.leucine;
			aminoAcidsTranslationTable['cug'] = ProteinAlphabet.instance.leucine;
			aminoAcidsTranslationTable['uua'] = ProteinAlphabet.instance.leucine;
			aminoAcidsTranslationTable['uug'] = ProteinAlphabet.instance.leucine;
			aminoAcidsTranslationTable['aaa'] = ProteinAlphabet.instance.lysine;
			aminoAcidsTranslationTable['aag'] = ProteinAlphabet.instance.lysine;
			aminoAcidsTranslationTable['aug'] = ProteinAlphabet.instance.methionine;
			aminoAcidsTranslationTable['uuu'] = ProteinAlphabet.instance.phenylalanine;
			aminoAcidsTranslationTable['uuc'] = ProteinAlphabet.instance.phenylalanine;
			aminoAcidsTranslationTable['ccc'] = ProteinAlphabet.instance.proline;
			aminoAcidsTranslationTable['cca'] = ProteinAlphabet.instance.proline;
			aminoAcidsTranslationTable['ccg'] = ProteinAlphabet.instance.proline;
			aminoAcidsTranslationTable['ccu'] = ProteinAlphabet.instance.proline;
			aminoAcidsTranslationTable['agc'] = ProteinAlphabet.instance.serine;
			aminoAcidsTranslationTable['ucu'] = ProteinAlphabet.instance.serine;
			aminoAcidsTranslationTable['ucc'] = ProteinAlphabet.instance.serine;
			aminoAcidsTranslationTable['uca'] = ProteinAlphabet.instance.serine;
			aminoAcidsTranslationTable['ucg'] = ProteinAlphabet.instance.serine;
			aminoAcidsTranslationTable['agu'] = ProteinAlphabet.instance.serine;
			aminoAcidsTranslationTable['acc'] = ProteinAlphabet.instance.threonine;
			aminoAcidsTranslationTable['aca'] = ProteinAlphabet.instance.threonine;
			aminoAcidsTranslationTable['acg'] = ProteinAlphabet.instance.threonine;
			aminoAcidsTranslationTable['acu'] = ProteinAlphabet.instance.threonine;
			aminoAcidsTranslationTable['ugg'] = ProteinAlphabet.instance.tryptophan;
			aminoAcidsTranslationTable['uau'] = ProteinAlphabet.instance.tyrosine;
			aminoAcidsTranslationTable['uac'] = ProteinAlphabet.instance.tyrosine;
			aminoAcidsTranslationTable['guu'] = ProteinAlphabet.instance.valine;
			aminoAcidsTranslationTable['guc'] = ProteinAlphabet.instance.valine;
			aminoAcidsTranslationTable['gua'] = ProteinAlphabet.instance.valine;
			aminoAcidsTranslationTable['gug'] = ProteinAlphabet.instance.valine;
		}
		
		private static function initializeDNAToRNATranslationTable():void
		{
			if(dnaToRNATranslationTable != null) {
				return;
			}
			
			dnaToRNATranslationTable = new Dictionary();
			
			dnaToRNATranslationTable[dnaAlphabet.a] = rnaAlphabet.a;
			dnaToRNATranslationTable[dnaAlphabet.t] = rnaAlphabet.u;
			dnaToRNATranslationTable[dnaAlphabet.g] = rnaAlphabet.g;
			dnaToRNATranslationTable[dnaAlphabet.c] = rnaAlphabet.c;
			dnaToRNATranslationTable[dnaAlphabet.y] = rnaAlphabet.y;
			dnaToRNATranslationTable[dnaAlphabet.r] = rnaAlphabet.r;
			dnaToRNATranslationTable[dnaAlphabet.s] = rnaAlphabet.s;
			dnaToRNATranslationTable[dnaAlphabet.w] = rnaAlphabet.w;
			dnaToRNATranslationTable[dnaAlphabet.k] = rnaAlphabet.k;
			dnaToRNATranslationTable[dnaAlphabet.m] = rnaAlphabet.m;
			dnaToRNATranslationTable[dnaAlphabet.b] = rnaAlphabet.b;
			dnaToRNATranslationTable[dnaAlphabet.v] = rnaAlphabet.v;
			dnaToRNATranslationTable[dnaAlphabet.d] = rnaAlphabet.d;
			dnaToRNATranslationTable[dnaAlphabet.h] = rnaAlphabet.h;
			dnaToRNATranslationTable[dnaAlphabet.n] = rnaAlphabet.n;
			dnaToRNATranslationTable[dnaAlphabet.gap] = rnaAlphabet.gap;
		}
		
		private static function initializeRNAToDNATranslationTable():void
		{
			if(rnaToDNATranslationTable != null) {
				return;
			}
			
			rnaToDNATranslationTable = new Dictionary();
			
			rnaToDNATranslationTable[rnaAlphabet.a] = dnaAlphabet.a;
			rnaToDNATranslationTable[rnaAlphabet.u] = dnaAlphabet.t;
			rnaToDNATranslationTable[rnaAlphabet.g] = dnaAlphabet.g;
			rnaToDNATranslationTable[rnaAlphabet.c] = dnaAlphabet.c;
			rnaToDNATranslationTable[rnaAlphabet.y] = dnaAlphabet.y;
			rnaToDNATranslationTable[rnaAlphabet.r] = dnaAlphabet.r;
			rnaToDNATranslationTable[rnaAlphabet.s] = dnaAlphabet.s;
			rnaToDNATranslationTable[rnaAlphabet.w] = dnaAlphabet.w;
			rnaToDNATranslationTable[rnaAlphabet.k] = dnaAlphabet.k;
			rnaToDNATranslationTable[rnaAlphabet.m] = dnaAlphabet.m;
			rnaToDNATranslationTable[rnaAlphabet.b] = dnaAlphabet.b;
			rnaToDNATranslationTable[rnaAlphabet.v] = dnaAlphabet.v;
			rnaToDNATranslationTable[rnaAlphabet.d] = dnaAlphabet.d;
			rnaToDNATranslationTable[rnaAlphabet.h] = dnaAlphabet.h;
			rnaToDNATranslationTable[rnaAlphabet.n] = dnaAlphabet.n;
			rnaToDNATranslationTable[rnaAlphabet.gap] = dnaAlphabet.gap;
		}
	}
}