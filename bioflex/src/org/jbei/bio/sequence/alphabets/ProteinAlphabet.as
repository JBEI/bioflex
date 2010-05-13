package org.jbei.bio.sequence.alphabets
{
	import org.jbei.bio.sequence.symbols.AminoAcidSymbol;
	import org.jbei.bio.sequence.symbols.GapSymbol;

	public class ProteinAlphabet extends AbstractAlphabet
	{
		private static var _instance:ProteinAlphabet = null;
		
		private const _a:AminoAcidSymbol = new AminoAcidSymbol('Alanine', 'Ala', 'A');
		private const _r:AminoAcidSymbol = new AminoAcidSymbol('Arginine', 'Arg', 'R');
		private const _n:AminoAcidSymbol = new AminoAcidSymbol('Asparagine', 'Asn', 'N');
		private const _d:AminoAcidSymbol = new AminoAcidSymbol('Aspartic acid', 'Asp', 'D');
		private const _c:AminoAcidSymbol = new AminoAcidSymbol('Cysteine', 'Cys', 'C');
		private const _e:AminoAcidSymbol = new AminoAcidSymbol('Glutamic acid', 'Glu', 'E');
		private const _q:AminoAcidSymbol = new AminoAcidSymbol('Glutamine', 'Gln', 'Q');
		private const _g:AminoAcidSymbol = new AminoAcidSymbol('Glycine', 'Gly', 'G');
		private const _h:AminoAcidSymbol = new AminoAcidSymbol('Histidine', 'His', 'H');
		private const _i:AminoAcidSymbol = new AminoAcidSymbol('Isoleucine ', 'Ile', 'I');
		private const _l:AminoAcidSymbol = new AminoAcidSymbol('Leucine', 'Leu', 'L');
		private const _k:AminoAcidSymbol = new AminoAcidSymbol('Lysine', 'Lys', 'K');
		private const _m:AminoAcidSymbol = new AminoAcidSymbol('Methionine', 'Met', 'M');
		private const _f:AminoAcidSymbol = new AminoAcidSymbol('Phenylalanine', 'Phe', 'F');
		private const _p:AminoAcidSymbol = new AminoAcidSymbol('Proline', 'Pro', 'P');
		private const _s:AminoAcidSymbol = new AminoAcidSymbol('Serine', 'Ser', 'S');
		private const _t:AminoAcidSymbol = new AminoAcidSymbol('Threonine', 'Thr', 'T');
		private const _w:AminoAcidSymbol = new AminoAcidSymbol('Tryptophan', 'Try', 'W');
		private const _y:AminoAcidSymbol = new AminoAcidSymbol('Tyrosine', 'Tyr', 'Y');
		private const _v:AminoAcidSymbol = new AminoAcidSymbol('Valine ', 'Val', 'V');
		
		// Public Methods
		public static function get instance():ProteinAlphabet
		{
			if(_instance == null) {
				_instance = new ProteinAlphabet();
			}
			
			return _instance;
		}
		
		// Properties
		public function get a():AminoAcidSymbol { return _a; }
		public function get r():AminoAcidSymbol { return _r; }
		public function get n():AminoAcidSymbol { return _n; }
		public function get d():AminoAcidSymbol { return _d; }
		public function get c():AminoAcidSymbol { return _c; }
		public function get e():AminoAcidSymbol { return _e; }
		public function get q():AminoAcidSymbol { return _q; }
		public function get g():AminoAcidSymbol { return _g; }
		public function get h():AminoAcidSymbol { return _h; }
		public function get i():AminoAcidSymbol { return _i; }
		public function get l():AminoAcidSymbol { return _l; }
		public function get k():AminoAcidSymbol { return _k; }
		public function get m():AminoAcidSymbol { return _m; }
		public function get f():AminoAcidSymbol { return _f; }
		public function get p():AminoAcidSymbol { return _p; }
		public function get s():AminoAcidSymbol { return _s; }
		public function get t():AminoAcidSymbol { return _t; }
		public function get w():AminoAcidSymbol { return _w; }
		public function get y():AminoAcidSymbol { return _y; }
		public function get v():AminoAcidSymbol { return _v; }
		
		public function get alanine():AminoAcidSymbol { return _a; }
		public function get arginine():AminoAcidSymbol { return _r; }
		public function get asparagine():AminoAcidSymbol { return _n; }
		public function get aspartic():AminoAcidSymbol { return _d; }
		public function get cysteine():AminoAcidSymbol { return _c; }
		public function get glutamic():AminoAcidSymbol { return _e; }
		public function get glutamine():AminoAcidSymbol { return _q; }
		public function get glycine():AminoAcidSymbol { return _g; }
		public function get histidine():AminoAcidSymbol { return _h; }
		public function get isoleucine():AminoAcidSymbol { return _i; }
		public function get leucine():AminoAcidSymbol { return _l; }
		public function get lysine():AminoAcidSymbol { return _k; }
		public function get methionine():AminoAcidSymbol { return _m; }
		public function get phenylalanine():AminoAcidSymbol { return _f; }
		public function get proline():AminoAcidSymbol { return _p; }
		public function get serine():AminoAcidSymbol { return _s; }
		public function get threonine():AminoAcidSymbol { return _t; }
		public function get tryptophan():AminoAcidSymbol { return _w; }
		public function get tyrosine():AminoAcidSymbol { return _y; }
		public function get valine():AminoAcidSymbol { return _v; }
		
		// Public Methods
		public function symbolByValue(value:String):AminoAcidSymbol
		{
			return symbolsMap[value];
		}
		
		// Protected Methods
		protected override function initialize():void
		{
			super.initialize();
			
			symbolsMap[_a.value] = _a;
			symbolsMap[_r.value] = _r;
			symbolsMap[_n.value] = _n;
			symbolsMap[_d.value] = _d;
			symbolsMap[_c.value] = _c;
			symbolsMap[_e.value] = _e;
			symbolsMap[_q.value] = _q;
			symbolsMap[_g.value] = _g;
			symbolsMap[_h.value] = _h;
			symbolsMap[_i.value] = _i;
			symbolsMap[_l.value] = _l;
			symbolsMap[_k.value] = _k;
			symbolsMap[_m.value] = _m;
			symbolsMap[_f.value] = _f;
			symbolsMap[_p.value] = _p;
			symbolsMap[_s.value] = _s;
			symbolsMap[_t.value] = _t;
			symbolsMap[_w.value] = _w;
			symbolsMap[_y.value] = _y;
			symbolsMap[_v.value] = _v;
		}
	}
}