package org.jbei.bio.sequence.dna
{
    [RemoteClass(alias="org.jbei.bio.sequence.dna.FeatureNote")]
    
    /**
    * Feature note holder.
    * 
    * @see org.jbei.bio.sequence.dna.FeatureNote
    * 
    * @author Zinovii Dmytriv
    */
    public class FeatureNote
    {
        private var _name:String;
        private var _value:String;
        private var _quoted:Boolean;
        
        // Constructor
        /**
        * Contructor
        * 
        * @param name Note name
        * @param value Note value
        */
        public function FeatureNote(name:String = "", value:String = "", quoted:Boolean = false)
        {
            _name = name;
            _value = value;
            _quoted = quoted;
        }
        
        // Properties
        /**
        * Note name
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
         * Note value
         */
        public function get value():String
        {
            return _value;
        }
        
        public function set value(data:String):void
        {
            _value = data;
        }
        
        public function get quoted():Boolean
        {
            return _quoted;
        }
        
        public function set quoted(quoted:Boolean):void
        {
            _quoted = quoted;
        }
        
        // Public Methods
        /**
         * Clone feature note
         */
        public function clone():FeatureNote
        {
            return new FeatureNote(_name, _value);
        }
    }
}