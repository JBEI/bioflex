package org.jbei.bio.sequence.common
{
    [RemoteClass(alias="org.jbei.bio.sequence.common.Sequence")]
    
    /**
    * Sequence with name.
    * 
    * @author Zinovii Dmytriv
    */
    public class Sequence extends SymbolList
    {
        private var _name:String = "";
        
        // Constructor
        /**
        * Contructor
        * 
        * @param symbolList Sequence symbol list
        * @param name Sequence name
        */
        public function Sequence(symbolList:SymbolList = null, name:String = "")
        {
            _name = name;
            
            super(symbolList.symbols, symbolList.alphabet);
        }
        
        // Properties
        /**
        * Sequence name
        */
        public function get name():String
        {
            return _name;
        }
        
        public function set name(value:String):void
        {
            _name = value;
        }
    }
}