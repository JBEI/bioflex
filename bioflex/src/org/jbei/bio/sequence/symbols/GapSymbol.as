package org.jbei.bio.sequence.symbols
{
    /**
     * @author Zinovii Dmytriv
     */
	public class GapSymbol implements ISymbol
	{
		private var _name:String;
		private var _value:String;
		
		// Constructor
		public function GapSymbol(name:String, value:String)
		{
			_name = name;
			_value = value;
		}
		
		// Properties
		public function get name():String
		{
			return _name;
		}
		
		public function get value():String
		{
			return _value;
		}
	}
}