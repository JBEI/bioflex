package org.jbei.bio.sequence.alphabets
{
	import flash.utils.Dictionary;
	
	import org.jbei.bio.sequence.symbols.ISymbol;

	public class AbstractAlphabet implements IAlphabet
	{
		protected var symbolsMap:Dictionary;
		
		// Constructor
		public function AbstractAlphabet()
		{
			initialize();
		}
		
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
		}
	}
}