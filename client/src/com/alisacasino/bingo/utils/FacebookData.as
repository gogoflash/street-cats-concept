package com.alisacasino.bingo.utils
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.models.FacebookFriend;
	import com.alisacasino.bingo.models.FacebookIdAndTimestamp;
	import com.alisacasino.bingo.models.gifts.GiftsModel;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.GiftedPlayerMessage;
	import com.alisacasino.bingo.protocol.InvitedPlayerMessage;
	import com.alisacasino.bingo.protocol.SignInOkMessage;
	import flash.events.IOErrorEvent;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import org.as3commons.collections.Set;
	
	public class FacebookData
	{
		private static var sInstance:FacebookData;
		
		private var mUniqueInvitedPlayers:Vector.<FacebookIdAndTimestamp>;
		private var mAlreadyInvitedTokens:Vector.<String>;
		private var mUniqueGiftedPlayers:Vector.<FacebookIdAndTimestamp>;
		
		private var _inviteableFriends:Vector.<FacebookFriend>;
		
		
		private var mBingoInstalledFriends:Vector.<FacebookFriend>;
		private var mBingoInstalledFriendsWithoutFullQueue:Vector.<FacebookFriend>;
		private var mPublishedVisitedRoomTypeNames:Vector.<String>;
		private var _allActualFriends:Vector.<FacebookFriend>;
		
		private var _inviteSharingPosted:Boolean = false;
		private var inviteSharingPostedTime:Number = 0;
		
		public function get allActualFriends():Vector.<FacebookFriend> 
		{
			return _allActualFriends;
		}
		
		public static function get instance():FacebookData
		{
			if (sInstance == null) {
				sInstance = new FacebookData();
			}
			return sInstance;
		}
		
		public function clearAndInit():void
		{
			clear();
			initPublishedVisitedRoomTypeNames();
			initInvitableFriendsList();
			initBingoInstalledFriendsList();
		}
		
		private function initPublishedVisitedRoomTypeNames():void
		{
			mPublishedVisitedRoomTypeNames = new Vector.<String>();
		}
		
		private function initInvitableFriendsList():void
		{
			try {
				var loader : URLLoader = new URLLoader();
				var request : URLRequest = new URLRequest("https://graph.facebook.com/v2.7/me/invitable_friends" +
					"?access_token=" + PlatformServices.facebookManager.accessToken + "&method=GET&fields=id,first_name,picture,installed&limit=5000");
				
				request.method = URLRequestMethod.GET;
				loader.addEventListener(Event.COMPLETE, onComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.load(request);
				
				function onComplete (event:Event):void 
				{
					loader.removeEventListener(Event.COMPLETE, onComplete);
					loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				
					var friendList:Vector.<FacebookFriend> = new Vector.<FacebookFriend>();
			
					var response:Object = JSON.parse(event.target.data);
					
					for each (var friend:Object in response.data) {
						var facebookFriend:FacebookFriend = new FacebookFriend(
								null,
								friend.first_name,
								friend.last_name,
								true,
								friend.picture.data.url,
								friend.id
						);

						friendList.push(facebookFriend);
					}
					
					_inviteableFriends = friendList;
					PlatformServices.facebookManager.join();
				}
				
				function onIOError(event:IOErrorEvent):void 
				{
					loader.removeEventListener(Event.COMPLETE, onComplete);
					loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
					
					sosTrace('FacebookData initInvitableFriendsList IO error: ', event);
					_inviteableFriends = new Vector.<FacebookFriend>();
					PlatformServices.facebookManager.join();
				}
				
			} catch (e:Error) {
				trace(e);
				Game.connectionManager.sendClientMessage(e.getStackTrace());
			}
		}
		
		private function initBingoInstalledFriendsList():void
		{
			try {
				var loader : URLLoader = new URLLoader();
				var request : URLRequest = new URLRequest("https://graph.facebook.com/v2.7/me/friends" +
					"?access_token=" + PlatformServices.facebookManager.accessToken + "&method=GET&fields=id,first_name,picture,installed&limit=5000");
				
				request.method = URLRequestMethod.GET;
				loader.addEventListener(Event.COMPLETE, onComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.load(request);
				
				function onComplete (event:Event):void 
				{
					loader.removeEventListener(Event.COMPLETE, onComplete);
					loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
					
					var allFriends:Vector.<FacebookFriend> = new Vector.<FacebookFriend>();
					var bingoInstalledFriends:Vector.<FacebookFriend> = new Vector.<FacebookFriend>();
					
					var response:Object = JSON.parse(event.target.data);
					
					for each (var friend:Object in response.data) {
						var facebookFriend:FacebookFriend = new FacebookFriend(
								friend.id,
								friend.first_name,
								friend.last_name
						);
						allFriends.push(facebookFriend);
						if(friend.hasOwnProperty("installed") && friend.installed == true) {
							bingoInstalledFriends.push(facebookFriend);
						}
					}
					
					_allActualFriends = allFriends;
					
					mBingoInstalledFriends = bingoInstalledFriends;
					PlatformServices.facebookManager.join();
				}
				
				function onIOError(event:IOErrorEvent):void 
				{
					loader.removeEventListener(Event.COMPLETE, onComplete);
					loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
					
					sosTrace('FacebookData initBingoInstalledFriendsList IO error: ', event);
					_allActualFriends = new Vector.<FacebookFriend>();
					mBingoInstalledFriends = new Vector.<FacebookFriend>();
					PlatformServices.facebookManager.join();
				}
				
			} catch (e:Error) {
				trace(e);
				Game.connectionManager.sendClientMessage(e.getStackTrace());
			}
		}
		
		public function getFirstName(facebookId:String, useAll:Boolean = false):String
		{
			var source:Vector.<FacebookFriend> = useAll ? _allActualFriends : mBingoInstalledFriends;
			for each(var friend:FacebookFriend in source) {
				if(friend.facebookId == facebookId) {
					return friend.firstName;
				}
			}
			return "Your friend";
		}

		public function getLastName(facebookId:String, useAll:Boolean = false):String
		{
			var source:Vector.<FacebookFriend> = useAll ? _allActualFriends : mBingoInstalledFriends;
			for each(var friend:FacebookFriend in source) {
				if(friend.facebookId == facebookId) {
					return friend.lastName;
				}
			}
			return "";
		}
		
		public function parseSignInMessage(message:SignInOkMessage):void {
			
			mAlreadyInvitedTokens = new Vector.<String>;
			
			mUniqueInvitedPlayers = new Vector.<FacebookIdAndTimestamp>();
			for each(var invitedPlayer:InvitedPlayerMessage in message.invitedPlayers){
				mUniqueInvitedPlayers.push(new FacebookIdAndTimestamp(invitedPlayer.invitedFacebookIdString, invitedPlayer.inviteTimestamp.toNumber()));
			}
				
			mUniqueGiftedPlayers = new Vector.<FacebookIdAndTimestamp>();
			for each(var giftedPlayer:GiftedPlayerMessage in message.giftedPlayers) {
				mUniqueGiftedPlayers.push(
					new FacebookIdAndTimestamp(giftedPlayer.receiverFacebookIdString, giftedPlayer.giftTimestamp.toNumber(), giftedPlayer.giftsCount)
				);
				
				if(GiftsModel.SOSTRACE_LOGGING_ENABLE)
					sosTrace('mUniqueGiftedPlayer ', giftedPlayer.receiverFacebookIdString, giftedPlayer.giftTimestamp.toNumber(), giftedPlayer.giftsCount);
			}

			// message.fullQueueFacebookIdsString - это друзя, у которых и так много подарков
			
			var fullQueueFacebookIds:Set = new Set();
			for each(var fbId:String in message.fullQueueFacebookIdsString) {
				fullQueueFacebookIds.add(fbId);
				
				if(GiftsModel.SOSTRACE_LOGGING_ENABLE)
					sosTrace('fullQueueFacebookIds.push ', fbId);
			}
			
			populateFriendsWithoutFullQueue(fullQueueFacebookIds);
		}
		
		private function populateFriendsWithoutFullQueue(fullQueueFacebookIds:Set):void{
			
			mBingoInstalledFriendsWithoutFullQueue = new Vector.<FacebookFriend>();
			for each (var friend:FacebookFriend in mBingoInstalledFriends) {
				if (!fullQueueFacebookIds.has(friend.facebookId)) {
					mBingoInstalledFriendsWithoutFullQueue.push(friend);
					
					if(GiftsModel.SOSTRACE_LOGGING_ENABLE)
						sosTrace('mBingoInstalledFriendsWithoutFullQueue.push ', friend.facebookId, friend.firstName);
				}
			}
		}
		
		public function clear():void
		{
			_inviteableFriends = null;
			mBingoInstalledFriends = null;
			mPublishedVisitedRoomTypeNames = null;
			_inviteSharingPosted = false;
		}
		
		public function isInitialized():Boolean {
			if(_inviteableFriends == null || mBingoInstalledFriends == null || inviteableFriends == null) {
				return false;
			}
			
			return true;
		}
		
		public function get alreadyInvitedTokens():Vector.<String>
		{
			return mAlreadyInvitedTokens;
		}
		
		public function get uniqueInvitedPlayers():Vector.<FacebookIdAndTimestamp>
		{
			return mUniqueInvitedPlayers;
		}
		
		public function get uniqueGiftedPlayers():Vector.<FacebookIdAndTimestamp>
		{
			return mUniqueGiftedPlayers;
		}
		
		public function get inviteableFriends():Vector.<FacebookFriend>
		{
			return _inviteableFriends;
		}
		
		public function get bingoInstalledFriends():Vector.<FacebookFriend>
		{
			return mBingoInstalledFriends;
		}
		
		public function get bingoInstalledFriendsWithoutFullQueue():Vector.<FacebookFriend>
		{
			return mBingoInstalledFriendsWithoutFullQueue;
		}
		
		public function get publishedVisitedRoomTypeNames():Vector.<String>
		{
			return mPublishedVisitedRoomTypeNames;
		}
		
        public function isNoAppFriendAlreadyInvited(inviteToken:String):Boolean
        {
            if (!alreadyInvitedTokens)
                return false;
                
            return alreadyInvitedTokens.indexOf(inviteToken) != -1;
        }
       
		public function get hasAnyFriends():Boolean {
			
			if (mBingoInstalledFriends && mBingoInstalledFriends.length > 0)
				return true;
				
			if (_inviteableFriends && _inviteableFriends.length > 0)
				return true;
				
			return false;
		}
		
		public function get inviteSharingPosted():Boolean
		{
			if ((TimeService.serverTime - inviteSharingPostedTime) > 8 * 60 * 60)
				_inviteSharingPosted = false;
			
			//trace('> ', TimeService.serverTime - inviteSharingPostedTime, _inviteSharingPosted);
				
			return _inviteSharingPosted;
		}
		
		public function set inviteSharingPosted(value:Boolean):void
		{
			_inviteSharingPosted = value;
			if (value)
				inviteSharingPostedTime = TimeService.serverTime;
		}
		
        public function debugInjectFakeFriends(noAppCount:int, hasAppCount:int = 0):void
        {
            if (!_inviteableFriends) {
                mBingoInstalledFriends = new Vector.<FacebookFriend>();
                _inviteableFriends = new Vector.<FacebookFriend>();
            }
            
			if(noAppCount)
				debugInjectFriends(_inviteableFriends, noAppCount);
			
			if (hasAppCount) {
				debugInjectFriends(mBingoInstalledFriends, hasAppCount);
				populateFriendsWithoutFullQueue(new Set());
			}
		} 
		
		public function debugInjectFriends(source:Vector.<FacebookFriend>, count:int):void
		{
			var i:int;
			var facebookFriend:FacebookFriend;
			for (i = 0; i < count; i++ ) 
			{
				var pic:String;
				if (Math.random() > 0.2) {
					if (Math.random() > 0.5)
						pic = "https://scontent.xx.fbcdn.net/v/t1.0-1/s100x100/417878_101265670081904_850807070_n.jpg?oh=b13f514c74be2dad76f2ef116f4a5147&oe=586F0B8B";
					else
						pic = "https://scontent.xx.fbcdn.net/v/t1.0-1/p100x100/1044220_1378324389053440_129558414_n.jpg?oh=9a2365a3d1ba00a7aada5dde6edb0212&oe=587EE6AE"; 
				}
				else {
					pic = null;
				}
				
				
				var firstName:String = FacebookData.debugGetStringUserName();
				
				//firstName = 'Я Васисуалий';
				//firstName = 'Я В';
				//firstName = 'I Vasisualii';
				//firstName = ' Васисуалииыааы Васисуалий а ';
				facebookFriend = new FacebookFriend(null, firstName, 'Awesome', false, pic, 'debugHasApp_' + i);
				//facebookFriend = new FacebookFriend(null, 'Васисуалий', false, pic, 'debugHasApp_' + i);
				//facebookFriend = new FacebookFriend(null, 'bи', false, pic, 'debugHasApp_' + i);
				
				source.push(facebookFriend);
			}
		}
		
		public static function debugGetStringUserName(userRandomChars:Boolean = false, useLatinCharset:Boolean = true):String
		{
			var firstName:String = '';
			
			if (userRandomChars) {
				var randomLength:int = 3 + 17 * Math.random();
				var charset:String = /*Math.random() > 0.5*/useLatinCharset ? Fonts.CHATEAU_DE_GARAGE_FONT_CHARSET : Fonts.DEBUG_CYRILLIC_CHARSET;
				while (randomLength-- > 0) {
					firstName += charset.charAt(Math.floor(Math.random()*charset.length)); 
				}
			}
			else {
				var names:Array = [
				"Алексей", "Сергей", "Федор", "Вероника", "Наталья", 'Диана', 'Васисуалий', 
				//'Марк Мопедович', 'Принцеса Амидала', "Длинннноеиммяяяяяя", "Лопасть Изменяемого Шага", "Рулон Обоев", "Забег Дебилов", "Марафон изгоев", "Коровка Говорит Муууууууууу",
				"Konstantin", "Donna", "Diana", "Barbara", "Holly",
				"Ashot", "Ekaterina", "Maria", "Margarita", "Хом", "Maria Moconini", "Very long name Very long name Very long name "
				];
				firstName = names[Math.floor(Math.random() * names.length)]; 
			}
			
			return firstName;
		}
		
		
	}
}
