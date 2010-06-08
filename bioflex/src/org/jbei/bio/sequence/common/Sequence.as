package org.jbei.bio.sequence.common
{
    /**
     * @author Zinovii Dmytriv
     */
    [RemoteClass(alias="org.jbei.bio.sequence.common.Sequence")]
    public class Sequence extends SymbolList
    {
        private var _name:String = "";
        
        // Constructor
        public function Sequence(symbolList:SymbolList = null, name:String = "")
        {
            _name = name;
            
            super(symbolList.symbols(), symbolList.alphabet);
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
    }
}