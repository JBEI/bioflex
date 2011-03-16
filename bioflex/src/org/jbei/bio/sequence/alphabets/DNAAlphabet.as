package org.jbei.bio.sequence.alphabets
{
    import org.jbei.bio.BioException;
    import org.jbei.bio.sequence.symbols.GapSymbol;
    import org.jbei.bio.sequence.symbols.ISymbol;
    import org.jbei.bio.sequence.symbols.NucleotideSymbol;
    
    [RemoteClass(alias="org.jbei.bio.sequence.alphabets.DNAAlphabet")]
    /**
     * DNA alphabet. Most general aplhabet to build DNA sequences.
     * 
     * This class used to be a singleton. However, when pasting a flex object from the clipboard,
     * from a different browser tab, the flash player will call the constructor internally, to
     * create object copies. Thus, the constructor must be allowed to be called, without 
     * requiring to use Instance. To work around this limitation, we wrap a real signleton class
     * from this class.
     * 
     * @see org.jbei.bio.sequence.symbols.NucleotideSymbol
     * @author Zinovii Dmytriv
     * @author Timothy Ham
     */
    public class DNAAlphabet extends AbstractAlphabet
    {
        private static var _hiddenInstance:DNAAlphabetSingleton = DNAAlphabetSingleton.instance;
        
        // Contructor
        /**
         * Constructor
         */
        public function DNAAlphabet() 
        {
            super();
        }
        
        // Public Methods
        /**
        * This class used to be a singleton, but no longer. See documentation above.
        */
        public static function get instance():DNAAlphabet
        {
            return new DNAAlphabet();
        }
        
        // Properties
        
        public function get a():NucleotideSymbol { return _hiddenInstance.a; }
        public function get g():NucleotideSymbol { return _hiddenInstance.g; }
        public function get c():NucleotideSymbol { return _hiddenInstance.c; }
        public function get t():NucleotideSymbol { return _hiddenInstance.t; }
        public function get m():NucleotideSymbol { return _hiddenInstance.m; }
        public function get r():NucleotideSymbol { return _hiddenInstance.r; }
        public function get w():NucleotideSymbol { return _hiddenInstance.w; }
        public function get s():NucleotideSymbol { return _hiddenInstance.s; }
        public function get y():NucleotideSymbol { return _hiddenInstance.y; }
        public function get k():NucleotideSymbol { return _hiddenInstance.k; }
        public function get v():NucleotideSymbol { return _hiddenInstance.v; }
        public function get h():NucleotideSymbol { return _hiddenInstance.h; }
        public function get d():NucleotideSymbol { return _hiddenInstance.d; }
        public function get b():NucleotideSymbol { return _hiddenInstance.b; }
        public function get n():NucleotideSymbol { return _hiddenInstance.n; }
        
        // Protected Methods
        /**
        * @inheritDoc
        */
        protected override function initialize():void
        {
            super.initialize();
            
            symbolsMap[_hiddenInstance.a.value] = _hiddenInstance.a;
            symbolsMap[_hiddenInstance.t.value] = _hiddenInstance.t;
            symbolsMap[_hiddenInstance.g.value] = _hiddenInstance.g;
            symbolsMap[_hiddenInstance.c.value] = _hiddenInstance.c;
            symbolsMap[_hiddenInstance.m.value] = _hiddenInstance.m;
            symbolsMap[_hiddenInstance.r.value] = _hiddenInstance.r;
            symbolsMap[_hiddenInstance.w.value] = _hiddenInstance.w;
            symbolsMap[_hiddenInstance.s.value] = _hiddenInstance.s;
            symbolsMap[_hiddenInstance.y.value] = _hiddenInstance.y;
            symbolsMap[_hiddenInstance.k.value] = _hiddenInstance.k;
            symbolsMap[_hiddenInstance.v.value] = _hiddenInstance.v;
            symbolsMap[_hiddenInstance.h.value] = _hiddenInstance.h;
            symbolsMap[_hiddenInstance.d.value] = _hiddenInstance.d;
            symbolsMap[_hiddenInstance.b.value] = _hiddenInstance.b;
            symbolsMap[_hiddenInstance.n.value] = _hiddenInstance.n;
        }
    }
}