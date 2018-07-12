package com.alisacasino.bingo.platform.mobile.goViralProxyingClasses 
{
	import com.milkmangames.nativeextensions.GVFacebookAppEvent;
	import com.milkmangames.nativeextensions.GVTwitterDispatcher;
	import flash.utils.ByteArray;
	import com.milkmangames.nativeextensions.GVMailDispatcher;
	import com.milkmangames.nativeextensions.GVFacebookDispatcher;
	import flash.display.BitmapData;
	import com.milkmangames.nativeextensions.GVShareDispatcher;
	import com.milkmangames.nativeextensions.GoViral;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class GoViralProxy extends EventDispatcher 
	{
		private static var _implementation:IGoViralImplementation;
		
		public static function getImplementation():IGoViralImplementation
		{
			if (!_implementation)
			{
				_implementation = new GoViralSWCMirror();
			}
			
			return _implementation;
		}
		
		static public function isSupported():Boolean
		{
			return true;
		}
		
		static public function create():void
		{
			getImplementation().create();
		}
		
		
	}

}