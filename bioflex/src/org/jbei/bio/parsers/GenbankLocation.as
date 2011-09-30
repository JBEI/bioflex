package org.jbei.bio.parsers
{
	public class GenbankLocation
	{
		private var _genbankStart:int;
		private var _end:int;
		
		public function GenbankLocation(genbankStart:int, end:int)
		{
			_genbankStart = genbankStart;
			_end = end;
		}
		
		public function get genbankStart():int
		{
			return _genbankStart;
		}
		
		public function set genbankStart(genbankStart:int):void
		{
			_genbankStart = genbankStart;
		}
		
		public function get end():int
		{
			return _end;
		}
		
		public function set end(end:int):void
		{
			_end = end;
		}
		
	}
}