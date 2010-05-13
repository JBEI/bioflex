package org.jbei.bio.sequence.dna
{
	import org.jbei.bio.sequence.common.StrandedAnnotation;

	public class Feature extends StrandedAnnotation
	{
		private var _name:String;
		private var _type:String;
		private var _notes:Vector.<FeatureNote>;
		
		// Constructor
		public function Feature(name:String, start:int, end:int, type:String, strand:int, notes:Vector.<FeatureNote> = null)
		{
			super(start, end, strand);
			
			_name = name;
			_type = type;
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
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
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
