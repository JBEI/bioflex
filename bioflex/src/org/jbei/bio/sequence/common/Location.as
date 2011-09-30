package org.jbei.bio.sequence.common
{
	/**
	* Feature location
	* 
	* @author Timothy Ham
	*/
	public class Location
	{
		private var _start:int = 0;
		private var _end:int = 0;

		//Constructor
		public function Location(start:int = 0, end:int = 0)
		{
			_start = start;
			_end = end;
		}

		public function get start():int
		{
			return _start;
		}
        
		public function set start(value:int):void
		{
			_start = value;
		}
        
		public function get end():int
		{
			return _end;
		}
        
		public function set end(value:int):void
    	{
			_end = value;
		}

		public function clone():Location
		{
			return new Location(_start, _end);
		}
        
		public function get length():int
		{
			return Math.abs(_end - _start);
		}
	}
}