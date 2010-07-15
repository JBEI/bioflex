package org.jbei.bio.sequence.dna
{
    import org.jbei.bio.enzymes.RestrictionEnzyme;

    [RemoteClass(alias="org.jbei.bio.sequence.dna.DigestionFragment")]
    public class DigestionFragment
    {
        private var _start:int;
        private var _end:int;
        private var _length:int;
        private var _startRE:RestrictionEnzyme;
        private var _endRE:RestrictionEnzyme;
        
        public function DigestionFragment(start:int = 0, end:int = 0, length:int = 0, startRE:RestrictionEnzyme = null, endRE:RestrictionEnzyme = null)
        {
            _start = start;
            _end = end;
            _length = length;
            _startRE = startRE;
            _endRE = endRE;
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
        
        public function get length():int
        {
            return _length;
        }
        
        public function set length(value:int):void
        {
            _length = value;
        }
        
        public function get startRE():RestrictionEnzyme
        {
            return _startRE;
        }
        
        public function set startRE(value:RestrictionEnzyme):void
        {
            _startRE = value;
        }
        
        public function get endRE():RestrictionEnzyme
        {
            return _endRE;
        }
        
        public function set endRE(value:RestrictionEnzyme):void
        {
            _endRE = value;
        }
    }
}