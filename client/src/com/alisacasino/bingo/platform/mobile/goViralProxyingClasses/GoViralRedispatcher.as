package com.alisacasino.bingo.platform.mobile.goViralProxyingClasses 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class GoViralRedispatcher 
	{
		public static const eventNameList:Array = [
			"feed",
			"graph",
			"message",
			"apprequests",
			"share",
			"gvFbAdIdResponse",
			"gvFbDialogCancelled",
			"gvFbDialogFailed",
			"gvFbDialogFinished",
			"gvFacebookLoggedin",
			"gvFacebookLoggedout",
			"gvFacebookLoginCancelled",
			"gvFacebookLoginFailed",
			"gvSessionPermFailed",
			"gvSessionPermRefreshed",
			"gvPublishPermFailed",
			"gvPublishPermUpdated",
			"gvReadPermFailed",
			"gvReadPermUpdated",
			"gvFbRequestFailed",
			"gvFbRawResponse",
			"gvFacebookSessionInvalidated",
			];
			
		private var redispatchTarget:IEventDispatcher;
		private var originalDispatcher:IEventDispatcher;
		
		public function GoViralRedispatcher(originalDispatcher:IEventDispatcher, redispatchTarget:IEventDispatcher) 
		{
			this.originalDispatcher = originalDispatcher;
			this.redispatchTarget = redispatchTarget;
			setupRedispatch(originalDispatcher);
		}
		
		private function setupRedispatch(originalDispatcher:IEventDispatcher):void 
		{
			for each (var eventNameEntry:String in eventNameList) 
			{
				originalDispatcher.addEventListener(eventNameEntry, redispatchFunction);
			}
		}
		
		private function redispatchFunction(e:Event):void 
		{
			redispatchTarget.dispatchEvent(e.clone());
		}
		
	}

}