package org.jbei.bio.sequence.symbols
{
	public class AminoAcidSymbol implements ISymbol
	{
		private var _name:String;
		private var _value:String;
		private var _threeLettersName:String;
		
		public function AminoAcidSymbol(name:String, threeLettersName:String, value:String)
		{
			_name = name;
			_value = value;
			_threeLettersName = threeLettersName;
		}
		
		// ISymbol implementation
		public function get name():String
		{
			return _name;
		}
		
		public function get threeLettersName():String
		{
			return _threeLettersName;
		}
		
		public function get value():String
		{
			return _value;
		}
	}
}