package org.jbei.bio.sequence.dna
{
	import org.jbei.bio.sequence.common.Sequence;
	import org.jbei.bio.sequence.common.SymbolList;

	public class DNASequence extends Sequence
	{
		private var _accession:String;
		private var _version:int;
		private var _seqVersion:Number;
		
		// Constructor
		public function DNASequence(name:String, symbolList:SymbolList, accession:String = "", version:int = 1, seqVersion:Number = 0.0)
		{
			super(name, symbolList);
			
			_accession = accession;
			_version = version;
			_seqVersion = seqVersion;
		}
		
		// Properties
		public function get accession():String
		{
			return _accession;
		}
		
		public function set accession(value:String):void
		{
			_accession = value;
		}
		
		public function get version():int
		{
			return _version;
		}
		
		public function set version(value:int):void
		{
			_version = value;
		}
		
		public function get seqVersion():Number
		{
			return _seqVersion;
		}
		
		public function set seqVersion(value:Number):void
		{
			_seqVersion = value;
		}
	}
}