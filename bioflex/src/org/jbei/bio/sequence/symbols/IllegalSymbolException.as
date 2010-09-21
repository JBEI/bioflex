package org.jbei.bio.sequence.symbols
{
    /**
    * Illegal symbol exception.
    * 
    * @author Zinovii Dmytriv
    */
    public class IllegalSymbolException extends Error
    {
        // Constructor
        /**
        * Contructor
        */
        public function IllegalSymbolException(message:*="", id:*=0)
        {
            super(message, id);
        }
    }
}