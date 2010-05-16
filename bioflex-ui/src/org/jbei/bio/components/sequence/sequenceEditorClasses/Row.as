package org.jbei.bio.components.sequence.sequenceEditorClasses
{
	import flash.geom.Rectangle;
	
    /**
     * @author Zinovii Dmytriv
     */
	public class Row
	{
		private var _metrics:Rectangle;
		private var _sequenceMetrics:Rectangle;
		private var _index:int;
        private var _sequence:String;
        private var _revComSequence:String;
        private var _start:int;
        private var _end:int;
		
		// Constructor
		public function Row(index:int, start:int, end:int, sequence:String, revComSequence:String)
		{
			_index = index;
            _start = start;
            _end = end;
            _sequence = sequence;
            _revComSequence = revComSequence;
		}
		
		// Properties
		public function get index():int
		{
			return _index;
		}
		
		public function get metrics():Rectangle
		{
			return _metrics;
		}
		
		public function set metrics(value:Rectangle):void
		{
			_metrics = value;
		}
		
		public function get sequenceMetrics():Rectangle
		{
			return _sequenceMetrics;
		}
		
		public function set sequenceMetrics(value:Rectangle):void
		{
			_sequenceMetrics = value;
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
        
        public function get sequence():String
        {
            return _sequence;
        }
        
        public function set sequence(value:String):void
        {
            _sequence = value;
        }
        
        public function get revComSequence():String
        {
            return _revComSequence;
        }
        
        public function set revComSequence(value:String):void
        {
            _revComSequence = value;
        }
	}
}