package org.jbei.bio.sequence.dna
{
	import org.jbei.bio.sequence.common.IAnnotation;

	public class Feature implements IAnnotation
	{
		private var _name:String;
		private var _type:String;
		private var _start:int;
		private var _end:int;
		private var _strand:int; /* 1 - forward, -1 - backward */
		private var _notes:Vector.<FeatureNote>;
		
		// Constructor
		public function Feature(name:String, start:int, end:int, type:String, strand:int, notes:Vector.<FeatureNote> = null)
		{
			_name = name;
			_start = start;
			_end = end;
			_type = type;
			_strand = strand;
			_notes = notes;
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
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
		
		public function get strand():int
		{
			return _strand;
		}
		
		public function set strand(value:int):void
		{
			_strand = value;
		}
		
		public function get notes():Vector.<FeatureNote>
		{
			return _notes;
		}
		
		public function set notes(value:Vector.<FeatureNote>):void
		{
			_notes = value;
		}
	}
}
