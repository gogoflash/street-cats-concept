package com.alisacasino.bingo.utils
{
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	public class DelayCallUtils
	{
		private static var bundles:Object = {};
		
		public function DelayCallUtils() {
			
		}
		
		public static function add(id:uint, bundle:String = 'common'):void
		{
			if (!(bundle in bundles))
				bundles[bundle] = [id];
			else
				(bundles[bundle] as Array).push(id);
		}
		
		public static function cleanBundle(bundle:String):void
		{
			if (bundle in bundles)
			{
				var bundleArray:Array = bundles[bundle] as Array;
				while (bundleArray.length > 0) {
					Starling.juggler.removeByID(bundleArray.shift());
				}
				
				delete bundles[bundle];
			}
		}
		
		public static function cleanAll():void
		{
			var bundle:Array;
			for each(bundle in bundles)
			{
				while (bundle.length > 0) {
					Starling.juggler.removeByID(bundle.shift());
				}
			}
			bundles = {};
		}
	}
}