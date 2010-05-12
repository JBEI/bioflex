package org.jbei.bio.sequence.common
{
	public class Sequence extends SymbolList
	{
		private var _name:String = "";
		
		// Constructor
		public function Sequence(name:String, symbolList:SymbolList)
		{
			_name = name;
			
			super(symbolList.symbols(), symbolList.alphabet);
		}
		
		// Properties
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
	}
}