package 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	
	public function get gameUILayoutScale():Number
	{
		return layoutHelper.pxScale * layoutHelper.independentScaleFromEtalonMin//scaleFromEtalonMin;
	}

}