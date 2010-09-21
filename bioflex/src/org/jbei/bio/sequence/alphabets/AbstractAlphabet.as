package org.jbei.bio.sequence.alphabets
{
    import flash.utils.Dictionary;
    
    import org.jbei.bio.sequence.symbols.GapSymbol;
    import org.jbei.bio.sequence.symbols.ISymbol;

    [RemoteClass(alias="org.jbei.bio.sequence.alphabets.AbstractAlphabet")]
    
    /**
     * Abstract general class for Alphabets.
     * 
     * @author Zinovii Dmytriv
     */
    public class AbstractAlphabet implements IAlphabet
    {
        /**
         * @private
         */
        protected var symbolsMap:Dictionary;
        
        /**
         * @private
         */
        protected const _gap:GapSymbol = new GapSymbol("Gap", "-");
        
        // Constructor
        /**
        * Contructor
        */
        public function AbstractAlphabet()
        {
            initialize();
        }
        
        // Properties
        /**
        * @inheritDoc
        */
        public function get gap():GapSymbol { return _gap; }
        
        // Public Methods
        /**
         * @inheritDoc
         */
        public function getSymbols():Vector.<ISymbol>
        {
            if(symbolsMap == null) {
                return null;
            }
            
            var symbols:Vector.<ISymbol> = new Vector.<ISymbol>()
            
            for(var value:String in symbolsMap)
            {
                symbols.push(symbolsMap[value]);
            }
            
            return symbols;
        }
        
        // Protected Methods
        /**
         * Initializes symbolsMap.
         */
        protected function initialize():void
        {
            symbolsMap = new Dictionary(true);
            
            symbolsMap[_gap.value] = _gap;
        }
        
        // Public Methods
        /**
         * Gets nucleotide symbol by it's string representation.
         * 
         * @param value String representation of the alphabet symbol
         * @return Alphabet symbol
         */
        public function symbolByValue(value:String):ISymbol
        {
            return symbolsMap[value];
        }
    }
}