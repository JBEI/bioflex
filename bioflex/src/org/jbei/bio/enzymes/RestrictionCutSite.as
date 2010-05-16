package org.jbei.bio.enzymes
{
	import org.jbei.bio.sequence.common.StrandedAnnotation;
	
    /**
     * @author Zinovii Dmytriv
     */
	public class RestrictionCutSite extends StrandedAnnotation
	{
		private var _restrictionEnzyme:RestrictionEnzyme;
		
		// Constructor
		public function RestrictionCutSite(start:int, end:int, strand:int, restrictionEnzyme:RestrictionEnzyme)
		{
			super(start, end, strand);
			
			_restrictionEnzyme = restrictionEnzyme;
		}
		
		// Properties
		public function get restrictionEnzyme():RestrictionEnzyme
		{
			return _restrictionEnzyme;
		}
		
		public function set restrictionEnzyme(value:RestrictionEnzyme):void
		{
			_restrictionEnzyme = value;
		}
	}
}