package org.jbei.bio.sequence.alphabets
{
    import org.jbei.bio.sequence.symbols.GapSymbol;
    import org.jbei.bio.sequence.symbols.ISymbol;

    /**
     * @author Zinovii Dmytriv
     */
    [RemoteClass(alias="org.jbei.bio.sequence.alphabets.IAlphabet")]
    public interface IAlphabet
    {
        function get gap():GapSymbol;
        
        function getSymbols():Vector.<ISymbol>;
    }
}