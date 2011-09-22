package org.jbei.bio.sequence.dna
{
    import flash.net.LocalConnection;
    
    import org.jbei.bio.sequence.common.Location;
    import org.jbei.bio.sequence.common.StrandedAnnotation;

    [RemoteClass(alias="org.jbei.bio.sequence.dna.Feature")]
    /**
    * DNA feature holder.
    * 
    * @author Zinovii Dmytriv
    */
    public class Feature extends StrandedAnnotation
    {
        private var _name:String;
        private var _type:String;
        private var _notes:Vector.<FeatureNote>;
        
        // Constructor
        /**
        * Contructor
        * 
        * @param name Feature name
        * @param start Feature start
        * @param end Feature end
        * @param type Genbank feature type. For example 'promoter'
        * @param strand Feature strand direction
        * @param notes List of additional feature notes
        */
        public function Feature(name:String = "", start:int = 0, end:int = 0, type:String = "", strand:int = 0, notes:Vector.<FeatureNote> = null)
        {
            super(start, end, strand);
            
            _name = name;
            _type = type;
            _notes = notes;
        }
        
        // Properties
        /**
        * Feature name
        */
        public function get name():String
        {
            return _name;
        }
        
        public function set name(value:String):void
        {
            _name = value;
        }
        
        /**
         * Genbank feature type
         */
        public function get type():String
        {
            return _type;
        }
        
        public function set type(value:String):void
        {
            _type = value;
        }
        
        /**
         * List of feature notes
         * 
         * @see org.jbei.bio.sequence.dna.FeatureNote
         */
        public function get notes():Vector.<FeatureNote>
        {
            return _notes;
        }
        
        public function set notes(value:Vector.<FeatureNote>):void
        {
            _notes = value;
        }
        
        // Public Methods
        /**
         * Clone feature object
         */
        public function clone():Feature
        {
            var clonedFeature:Feature = new Feature(_name, start, end, _type, strand);
            
			var clonedLocations:Vector.<Location> = new Vector.<Location>();
			for (var j:int = 0; j < locations.length; j++) {
				clonedLocations.push(new Location(locations[j].start, locations[j].end));
			}
			clonedFeature.locations = clonedLocations;
			
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
