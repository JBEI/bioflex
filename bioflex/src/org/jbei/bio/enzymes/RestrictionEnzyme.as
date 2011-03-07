package org.jbei.bio.enzymes
{
    [RemoteClass(alias="org.jbei.bio.sequence.dna.RestrictionEnzyme")]
    
    /**
    * Restriction Enzyme holder.
    * 
    * @author Zinovii Dmytriv
    */
    public class RestrictionEnzyme
    {
        private var _name:String;
        private var _site:String;
        private var _cutType:int;
        private var _forwardRegex:String;
        private var _reverseRegex:String;
        private var _dsForward:int;
        private var _dsReverse:int;
        private var _usForward:int;
        private var _usReverse:int;
        
        // Constructor
        /**
        * Contructor
        * 
        * @param name Enzyme name
        * @param site Enzyme site
        * @param cutType Downstream or Upstream cut type. Values 0 - downstream or 1 - upstream
        * @param forwardRegex Forward regular expression
        * @param reverseRegex Reverse regular expression
        * @param dsForward Downstream 3" strand cut position
        * @param dsReverse Downstream 5" strand cut position
        * @param usForward Upstream 3" strand cut position
        * @param usReverse Upstream 5" strand cut position
        */
        public function RestrictionEnzyme(name:String = "", site:String = "", cutType:int = 0, forwardRegex:String = "", reverseRegex:String = "", dsForward:int = 0, dsReverse:int = 0, usForward:int = 0, usReverse:int = 0)
        {
            _name = name;
            _site = site;
            _cutType = cutType;
            _forwardRegex = forwardRegex;
            _reverseRegex = reverseRegex;
            _dsForward = dsForward;
            _dsReverse = dsReverse;
            _usForward = usForward;
            _usReverse = usReverse;
        }
        
        // Properties
        /**
        * Enzyme name
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
         * Enzyme site
         */
        public function get site():String
        {
            return _site;
        }
        
        public function set site(value:String):void    
        {
            _site = value;
        }
        
        /**
         * Downstream or Upstream cut type. Values 0 - downstream or 1 - upstream. Default 0.
         */
        public function get cutType():int
        {
            return _cutType;
        }
        
        public function set cutType(value:int):void    
        {
            _cutType = value;
        }
        
        /**
        * Forward regular expression
        */
        public function get forwardRegex():String
        {
            return _forwardRegex;
        }
        
        public function set forwardRegex(value:String):void    
        {
            _forwardRegex = value;
        }
        
        /**
         * Reverse regular expression
         */
        public function get reverseRegex():String
        {
            return _reverseRegex;
        }
        
        public function set reverseRegex(value:String):void    
        {
            _reverseRegex = value;
        }
        
        /**
         * Downstream 3" strand cut position
         */
        public function get dsForward():int
        {
            return _dsForward;
        }
        
        public function set dsForward(value:int):void    
        {
            _dsForward = value;
        }
        
        /**
         * Downstream 5" strand cut position
         */
        public function get dsReverse():int
        {
            return _dsReverse;
        }
        
        public function set dsReverse(value:int):void    
        {
                _dsReverse = value;
        }
        
        /**
         * Upstream 3" strand cut position
         */
        public function get usForward():int
        {
            return _usForward;
        }
        
        public function set usForward(value:int):void    
        {
            _usForward = value;
        }
        
        /**
         * Upstream 5" strand cut position
         */
        public function get usReverse():int
        {
            return _usReverse;
        }
        
        public function set usReverse(value:int):void    
        {
            _usReverse = value;
        }
        
        // Public Methods
        /**
        * Checks if enzyme is palindromical
        */
        public function isPalindromic():Boolean
        {
            //GTGCAG = CTGCAC
            return _forwardRegex == _reverseRegex;
        }
        
        public function toString():String
        {
            return "RestrictionEnzyme: " + _name;
        
        }
    }
}