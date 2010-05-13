package org.jbei.bio.sequence.alphabets
{
	import org.jbei.bio.sequence.symbols.GapSymbol;
	import org.jbei.bio.sequence.symbols.ISymbol;

	public interface IAlphabet
	{
		function get gap():GapSymbol;
		
		function getSymbols():Vector.<ISymbol>;
	}
}