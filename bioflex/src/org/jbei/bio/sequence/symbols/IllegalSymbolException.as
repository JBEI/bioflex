package org.jbei.bio.sequence.symbols
{
	public class IllegalSymbolException extends Error
	{
		// Constructor
		public function IllegalSymbolException(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}