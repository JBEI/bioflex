package org.jbei.bio.sequence.alphabets
{
	import flash.utils.Dictionary;
	
	import org.jbei.bio.sequence.symbols.GapSymbol;
	import org.jbei.bio.sequence.symbols.ISymbol;

	public class AbstractAlphabet implements IAlphabet
	{
		protected var symbolsMap:Dictionary;
		
		protected const _gap:GapSymbol = new GapSymbol("Gap", "-");
		
		// Constructor
		public function AbstractAlphabet()
		{
			initialize();
		}
		
		// Properties
		public function get gap():GapSymbol { return _gap; }
		
		// Public Methods
		public function getSymbols():Vector.<ISymbol>
		{
			if(symbolsMap == null) {
				return null;
			}
			
			var symbols:Vector.<ISymbol> = new Vector.<ISymbol>()
			
			for(var value:String in symbolsMap)
			{
				symbols.push(symbolsMap[value]);
			}
			
			return symbols;
		}
		
		// Protected Methods
		protected function initialize():void
		{
			symbolsMap = new Dictionary(true);
			
			symbolsMap[_gap.value] = _gap;
		}
	}
}