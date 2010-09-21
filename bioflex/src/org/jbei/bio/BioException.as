package org.jbei.bio
{
    /**
    * General exception class for all BioFlex exceptions.
    * 
    * @author Zinovii Dmytriv
    */
    public class BioException extends Error
    {
        // Constructor
        public function BioException(message:*="", id:*=0)
        {
            super(message, id);
        }
    }
}