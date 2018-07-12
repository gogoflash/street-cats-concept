package com.alisacasino.bingo.platform 
{
	import avmplus.getQualifiedClassName;
	import by.blooddy.crypto.image.JPEGEncoder;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.social.PostTournamentPhoto;
	import com.alisacasino.bingo.models.collections.CollectionPage;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.ScreenshotUtils;
	import com.jonas.net.Multipart;
	import com.leeburrows.encoders.AsyncJPGEncoder;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class FacebookManagerBase 
	{
		
		public function FacebookManagerBase() 
		{
			
		}
		
		public function get accessToken():String
		{
			throw new Error("accessToken getter method must be overridden in subclasses", SOSLog.FATAL);
			return null;
		}
			
		public function get isConnected():Boolean
		{
			throw new Error("isConnected getter method must be overridden in subclasses", SOSLog.FATAL);
			return false;
		}
		
		public function publishScratchCardTopPrizeStory():void
		{
			if(!isConnected) {
				return;
			}
			
			publishOpengraphStoryViaHttpPost("prize", "scratch_card_top_prize", true);
		}
		
		public function shareTrophy(collectionPage:CollectionPage):void
		{
			var multipart:Multipart = new Multipart("https://graph.facebook.com/v2.10/me/feed" +
					"?access_token=" + accessToken);
					
			var message:String = 'WOW! Just look at this trophy I got in Arena Bingo! Collect cards and get your trophies, too!';
			
			multipart.addField("message", message);
			multipart.addField("link", collectionPage.opengraphURL);
			
			var loader : URLLoader = new URLLoader();
			var request : URLRequest = multipart.request;
			loader.load(request);
		}
		
		public function share(opengraphURL:String, message:String = null):void
		{
			var multipart:Multipart = new Multipart("https://graph.facebook.com/v2.10/me/feed" +
					"?access_token=" + accessToken);
			
			if(message)
				multipart.addField("message", message);
				
			multipart.addField("link", opengraphURL);
			
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
			var request : URLRequest = multipart.request;
			loader.load(request);
		}
		
		protected function publishOpengraphStoryViaHttpPost(type:String, name:String, explicitlyShared:Boolean=false):void
		{
			try {
				var loader : URLLoader = new URLLoader();
				loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
				var request : URLRequest;
				
				if(type == "room") {
					request = new URLRequest("https://graph.facebook.com/v2.7/me/alisabingo:visit" +
						"?access_token=" + accessToken + "&method=POST&room=" +
						Constants.OPENGRAPH_ROOMS_DIRECTORY + name + ".html");
					
				} else if (type == "item") {
					request = new URLRequest("https://graph.facebook.com/v2.7/me/alisabingo:find" +
						"?access_token=" + accessToken + "&method=POST&collectible=" +
						name + 
						(explicitlyShared ? "&fb:explicitly_shared=true" : ""));
					
				} else if (type == "objective") {
					request = new URLRequest("https://graph.facebook.com/v2.7/me/alisabingo:complete" +
						"?access_token=" + accessToken + "&method=POST&objective=" +
						Constants.OPENGRAPH_OBJECTIVES_DIRECTORY + name + ".html");
				} 
				else if (type == "prize")
				{
					request = new URLRequest("https://graph.facebook.com/v2.7/me/alisabingo:win" +
						"?access_token=" + accessToken + "&method=POST&prize=" +
						Constants.OPENGRAPH_PRIZE_DIRECTORY + name + ".html" +
						(explicitlyShared ? "&fb:explicitly_shared=true" : ""));
				}
				
				request.method = URLRequestMethod.POST;
				loader.load(request);
			} catch (e:Error) {
				trace(e);
				Game.connectionManager.sendClientMessage(e.getStackTrace());
			}
		}
		
		public function publishEventPrizeStory():void
		{
			if(!isConnected) {
				return;
			}
			
			publishOpengraphStoryViaHttpPost("prize", "event_prize", true);
		}
		
		public function postTournamentPhoto(callback:Function, place:uint):void 
		{
			new PostTournamentPhoto(accessToken, place).execute(callback, callback);
		}
		
		public function publishRareChestStory():void
		{
			if(!isConnected) {
				return;
			}
			
			publishOpengraphStoryViaHttpPost("prize", "rare_chest", true);
		}
		
		private function loader_ioErrorHandler(e:IOErrorEvent):void 
		{
			sosTrace( getQualifiedClassName(this) + ".loader_ioErrorHandler > e : " + e, SOSLog.ERROR);
		}
		
		public function getAppID():String
		{
			return Constants.isDevBuild ? Constants.FACEBOOK_APP_ID_DEV : Constants.FACEBOOK_APP_ID;
		}
		
	}

}