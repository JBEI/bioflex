package org.jbei.bio.sequence.alphabets
{
    import org.jbei.bio.sequence.symbols.GapSymbol;
    import org.jbei.bio.sequence.symbols.ISymbol;
    import org.jbei.bio.sequence.symbols.NucleotideSymbol;

    public class RNAAlphabet extends AbstractAlphabet
    {
        private static var _instance:RNAAlphabet = null;
        
        private const _a:NucleotideSymbol = new NucleotideSymbol("Adenine", "a");
        private const _g:NucleotideSymbol = new NucleotideSymbol("Guanine", "g");
        private const _c:NucleotideSymbol = new NucleotideSymbol("Cytosine", "c");
        private const _u:NucleotideSymbol = new NucleotideSymbol("Uracil", "u");
        private const _m:NucleotideSymbol = new NucleotideSymbol("Ambiguous {'a' or 'c'}", "m", Vector.<ISymbol>([_a, _c]));
        private const _r:NucleotideSymbol = new NucleotideSymbol("Ambiguous {'a' or 'g'}", "r", Vector.<ISymbol>([_a, _g]));
        private const _w:NucleotideSymbol = new NucleotideSymbol("Ambiguous {'a' or 'u'}", "w", Vector.<ISymbol>([_a, _u]));
        private const _s:NucleotideSymbol = new NucleotideSymbol("Ambiguous {'c' or 'g'}", "s", Vector.<ISymbol>([_c, _g]));
        private const _y:NucleotideSymbol = new NucleotideSymbol("Ambiguous {'c' or 'u'}", "y", Vector.<ISymbol>([_c, _u]));
        private const _k:NucleotideSymbol = new NucleotideSymbol("Ambiguous {'g' or 'u'}", "k", Vector.<ISymbol>([_g, _u]));
        private const _v:NucleotideSymbol = new NucleotideSymbol("Ambiguous {'a' or 'c' or 'g'}", "v", Vector.<ISymbol>([_a, _c, _g]));
        private const _h:NucleotideSymbol = new NucleotideSymbol("Ambiguous {'a' or 'c' or 'u'}", "h", Vector.<ISymbol>([_a, _c, _u]));
        private const _d:NucleotideSymbol = new NucleotideSymbol("Ambiguous {'a' or 'g' or 'u'}", "d", Vector.<ISymbol>([_a, _g, _u]));
        private const _b:NucleotideSymbol = new NucleotideSymbol("Ambiguous {'c' or 'g' or 'u'}", "b", Vector.<ISymbol>([_c, _g, _u]));
        private const _n:NucleotideSymbol = new NucleotideSymbol("Ambiguous {'a' or 'u' or 'g' or 'c'}", "n", Vector.<ISymbol>([_a, _c, _g, _u]));
        
        // Public Methods
        public static function get instance():RNAAlphabet
        {
            if(_instance == null) {
                _instance = new RNAAlphabet();
            }
            
            return _instance;
        }
        
        // Properties
        public function get a():NucleotideSymbol { return _a; }
        public function get g():NucleotideSymbol { return _g; }
        public function get c():NucleotideSymbol { return _c; }
        public function get u():NucleotideSymbol { return _u; }
        public function get m():NucleotideSymbol { return _m; }
        public function get r():NucleotideSymbol { return _r; }
        public function get w():NucleotideSymbol { return _w; }
        public function get s():NucleotideSymbol { return _s; }
        public function get y():NucleotideSymbol { return _y; }
        public function get k():NucleotideSymbol { return _k; }
        public function get v():NucleotideSymbol { return _v; }
        public function get h():NucleotideSymbol { return _h; }
        public function get d():NucleotideSymbol { return _d; }
        public function get b():NucleotideSymbol { return _b; }
        public function get n():NucleotideSymbol { return _n; }
        
        // Public Methods
        public function symbolByValue(value:String):NucleotideSymbol
        {
            return symbolsMap[value];
        }
        
        // Protected Methods
        protected override function initialize():void
        {
            super.initialize();
            
            symbolsMap[_a.value] = _a;
            symbolsMap[_u.value] = _u;
            symbolsMap[_g.value] = _g;
            symbolsMap[_c.value] = _c;
            symbolsMap[_m.value] = _m;
            symbolsMap[_r.value] = _r;
            symbolsMap[_w.value] = _w;
            symbolsMap[_s.value] = _s;
            symbolsMap[_y.value] = _y;
            symbolsMap[_k.value] = _k;
            symbolsMap[_v.value] = _v;
            symbolsMap[_h.value] = _h;
            symbolsMap[_d.value] = _d;
            symbolsMap[_b.value] = _b;
            symbolsMap[_n.value] = _n;
        }
    }
}