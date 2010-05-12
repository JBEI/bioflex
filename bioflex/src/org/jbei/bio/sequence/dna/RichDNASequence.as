package org.jbei.bio.sequence.dna
{
	import org.jbei.bio.BioException;
	import org.jbei.bio.sequence.common.SymbolList;

	public class RichDNASequence extends DNASequence
	{
		private var _features:Vector.<Feature> = new Vector.<Feature>();
		
		// Constructor
		public function RichDNASequence(name:String, symbolList:SymbolList, accession:String="", version:int=1, seqVersion:Number=0.0)
		{
			super(name, symbolList, accession, version, seqVersion);
		}
		
		// Properties
		public final function get features():Vector.<Feature>
		{
			return _features;
		}
		
		// Public Methods
		public function numberOfFeatures():int
		{
			return _features.length;
		}
		
		public function addFeature(feature:Feature):void
		{
			_features.push(feature);
		}
		
		public function containsFeature(feature:Feature):Boolean
		{
			return _features.indexOf(feature) >= 0;
		}
		
		/* @throws BioException */
		public function removeFeature(feature:Feature):void
		{
			var index:int = _features.indexOf(feature);
			
			if(index == -1) {
				throw new BioException("Failed to remove feature! Feature doesn't belong to this sequence.");
			}
			
			_features.splice(index, 1);
		}
	}
}