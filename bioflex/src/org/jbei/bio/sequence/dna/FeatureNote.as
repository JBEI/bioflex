package org.jbei.bio.sequence.dna
{
    /**
     * @author Zinovii Dmytriv
     */
    [RemoteClass(alias="org.jbei.bio.sequence.dna.FeatureNote")]
    public class FeatureNote
    {
        private var _name:String;
        private var _value:String;
        
        // Constructor
        public function FeatureNote(name:String = "", value:String = "")
        {
            _name = name;
            _value = value;
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
        
        public function get value():String
        {
            return _value;
        }
        
        public function set value(data:String):void
        {
            _value = data;
        }
        
        // Public Methods
        public function clone():FeatureNote
        {
            return new FeatureNote(_name, _value);
        }
    }
}