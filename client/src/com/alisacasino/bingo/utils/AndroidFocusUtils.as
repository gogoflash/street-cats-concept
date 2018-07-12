package com.alisacasino.bingo.utils 
{
	import com.mesmotronic.ane.AndroidFullScreen;
	import flash.desktop.NativeApplication;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class AndroidFocusUtils extends EventDispatcher
	{
		private var _inFocus:Boolean = true;
		
		public function get inFocus():Boolean 
		{
			return _inFocus;
		}
		
		public function set inFocus(value:Boolean):void 
		{
			if (_inFocus != value)
			{
				_inFocus = value;
				dispatchEventWith(Event.CHANGE);
			}
		}
		
		public function AndroidFocusUtils() 
		{
			var androidFullScreen:AndroidFullScreen = new AndroidFullScreen();
			NativeApplication.nativeApplication.addEventListener(AndroidFullScreen.ANDROID_WINDOW_FOCUS_IN, nativeApplication_androidWindowFocusInHandler);
			NativeApplication.nativeApplication.addEventListener(AndroidFullScreen.ANDROID_WINDOW_FOCUS_OUT, nativeApplication_androidWindowFocusOutHandler);
		}
		
		
		private function nativeApplication_androidWindowFocusOutHandler(e:*):void 
		{
			sosTrace( "MobileInterceptor.nativeApplication_androidWindowFocusOutHandler > e : " + e, SOSLog.WARNING);
			inFocus = false;
		}
		
		private function nativeApplication_androidWindowFocusInHandler(e:*):void 
		{
			sosTrace( "MobileInterceptor.nativeApplication_androidWindowFocusInHandler > e : " + e, SOSLog.WARNING);
			inFocus = true;
		}
		
	}

}