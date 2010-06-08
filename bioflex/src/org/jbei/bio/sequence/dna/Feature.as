package org.jbei.bio.sequence.dna
{
    import org.jbei.bio.sequence.common.StrandedAnnotation;

    /**
     * @author Zinovii Dmytriv
     */
    public class Feature extends StrandedAnnotation
    {
        // Static Constants
        public static const POSITIVE:int = 1;
        public static const NEGATIVE:int = -1;
        public static const UNKNOWN:int = 0;
        
        private var _name:String;
        private var _type:String;
        private var _notes:Vector.<FeatureNote>;
        
        // Constructor
        public function Feature(name:String = "", start:int = 0, end:int = 0, type:String = "", strand:int = 0, notes:Vector.<FeatureNote> = null)
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
        
        // Public Methods
        public function clone():Feature
        {
            var clonedFeature:Feature = new Feature(_name, start, end, _type, strand);
            
            if(_notes && _notes.length > 0) {
                var clonedNotes:Vector.<FeatureNote> = new Vector.<FeatureNote>();
                
                for(var i:int = 0; i < _notes.length; i++) {
                    clonedNotes.push((_notes[i] as FeatureNote).clone());
                }
                
                clonedFeature._notes = clonedNotes;
            }
            
            return clonedFeature;
        }
    }
}
