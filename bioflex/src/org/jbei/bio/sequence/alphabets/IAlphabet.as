package org.jbei.bio.sequence.alphabets
{
    import org.jbei.bio.sequence.symbols.GapSymbol;
    import org.jbei.bio.sequence.symbols.ISymbol;

    [RemoteClass(alias="org.jbei.bio.sequence.alphabets.IAlphabet")]
    /**
     * General interface for all Alphabets.
     * 
     * @author Zinovii Dmytriv
     */
    public interface IAlphabet
    {
        /**
        * Gap symbol property. Each alphabet has it's own gap symbol.
        * 
        * @return Gap symbol
        **/
        function get gap():GapSymbol;
        
        /**
        * List of all alphabet symbols.
        * 
        * @return List of symbols in alphabet
        * */
        function getSymbols():Vector.<ISymbol>;
    }
}