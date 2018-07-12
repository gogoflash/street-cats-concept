package com.alisacasino.bingo.utils
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AssetsManager;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.ClaimBonusDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.InviteFriendsDialog;
	import com.alisacasino.bingo.dialogs.SendGiftsDialog;
	import com.alisacasino.bingo.dialogs.inbox.InboxDialog;
	import com.alisacasino.bingo.models.FacebookFriend;
	import com.alisacasino.bingo.models.FacebookIdAndTimestamp;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.gifts.GiftsModel;
	import com.alisacasino.bingo.models.gifts.IncomingGiftData;
	import com.alisacasino.bingo.platform.IFacebookManager;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.platform.mobile.FacebookDialogResponse;
	import com.alisacasino.bingo.protocol.ClaimOfferOkMessage;
	import com.milkmangames.nativeextensions.events.GVFacebookEvent;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.models.FacebookFriend;
	import com.alisacasino.bingo.platform.mobile.FacebookDialogResponse;
	
	public class FriendsManager
	{
		public static var DEBUG_MODE:Boolean = false;
		
		public static const DIALOG_MODE_FROM_SIDE_MENU:uint = 0;
		public static const DIALOG_MODE_GET_FREE_CASH:uint = 1;
		
		static public const SINGLE_REQUEST_ID_LIMIT:int = 50;
		
		private static var sFriendsManager:FriendsManager;
		
		private var mFacebookManager:IFacebookManager = PlatformServices.facebookManager;
		private var mGameManager:GameManager = GameManager.instance;
		private var mFacebookData:FacebookData = FacebookData.instance;
		private var _cachedAvailableForInvite:int;
		
		public function get cachedAvailableForInvite():int 
		{
			return _cachedAvailableForInvite;
		}
		
		public static function get instance():FriendsManager
		{
			if (sFriendsManager == null)
			{
				sFriendsManager = new FriendsManager();
			}
			return sFriendsManager;
		}
		
		public function showInviteFriendsDialog(mode:uint, mandatory:Boolean, onClose:Function = null):void
		{
            if (!mFacebookManager.isConnected && !DEBUG_MODE)
			{
				if (onClose != null) onClose();
				return;
			}
			
            if (!mandatory && getAllFriendsEligibleForInvite().length == 0 && !DEBUG_MODE)
			{
				if (onClose != null) onClose();
				return;
			}
			
			var assetsToLoad:Array = [AtlasAsset.LoadingAtlas];
			AssetsManager.instance.loadAssetsIfNeeded(assetsToLoad, function(... _):void
			{
				LoadingWheel.removeIfAny();
				
				var inviteFriendsDialog:InviteFriendsDialog = new InviteFriendsDialog(mode);
				if (onClose != null)
				{
					inviteFriendsDialog.addEventListener(BaseDialog.DIALOG_CLOSED_EVENT, onClose);
				}
				DialogsManager.addDialog(inviteFriendsDialog);
			});
		}
		
		public function showSendGiftsDialog(onClose:Function = null, mandatory:Boolean = true):void
		{
			if (!mFacebookManager.isConnected && !GiftsModel.DEBUG_MODE)
			{
				if (onClose)
				{
					onClose();
				}
				return;
			}
			
			if (!mandatory && getAllFriendsEligibleForGift().length == 0)
			{
				if (onClose)
				{
					onClose();
				}
				return;
			}
			
			var assetsToLoad:Array = [AtlasAsset.LoadingAtlas];
			AssetsManager.instance.loadAssetsIfNeeded(assetsToLoad, function(... _):void
			{
				LoadingWheel.removeIfAny();
				
				var dialog:SendGiftsDialog = new SendGiftsDialog();
				DialogsManager.addDialog(dialog);
				if (onClose)
				{
					dialog.addEventListener(BaseDialog.DIALOG_CLOSED_EVENT, onClose);
				}
			});
		}
		
		public function showInboxDialog(onClose:Function):void
		{
			LoadingWheel.removeIfAny();

			if (DialogsManager.instance.getDialogByClass(InboxDialog))
				return;
			
			var dialog:InboxDialog = new InboxDialog();
			DialogsManager.addDialog( dialog );
			dialog.addEventListener(BaseDialog.DIALOG_CLOSED_EVENT, onClose);
		}
		
		public function inviteFriends(callback:Function = null):void
		{
			const MAX_INVITEES_PER_SEND:int = 50;
			var inviteTokens:Vector.<String> = getFriendInviteTokens(MAX_INVITEES_PER_SEND);
			
			if (inviteTokens.length == 0) {
				if(callback != null)
					callback();
					
				return;	
			}
			
			socialRequestFaceBookDialog(inviteTokens.join(","), Constants.INVITE_FACEBOOK_MESSAGE,
				function(response:FacebookDialogResponse):void
				{
					if (!response.isEmpty)
					{
						Game.connectionManager.sendInviteMessage(response);
						merge(mFacebookData.uniqueInvitedPlayers, response.userIds);
						for each (var token:String in inviteTokens) 						{
							mFacebookData.alreadyInvitedTokens.push(token);
						}
						Player.current.invitesSentCount = mFacebookData.uniqueInvitedPlayers.length;
						Game.connectionManager.sendPlayerUpdateMessage();
					}					
					
					if (response.isEmpty/* || !response.responseStatusOk*/) {
				
						if(callback != null)
							callback();
						
						return;
					}
					
					inviteFriends(callback);
				}
			);
		}


		public function sendGiftsToFriends(callback:Function, callbackArgs:Array, idList:Vector.<String> = null, useFacebookRequest:Boolean = true):void
		{
			const MAX_IDS_PER_SEND:int = 50;
			
			if (!idList || idList.length == 0) {
				if(callback != null)
					callback.apply(this, callbackArgs);
				return;		
			}
			
			if (!useFacebookRequest) 
			{
				var responseStub:FacebookDialogResponse = FacebookDialogResponse.create(idList);
				Game.connectionManager.sendGiftMessage(responseStub);
				
				if(mFacebookData.uniqueGiftedPlayers)
					merge(mFacebookData.uniqueGiftedPlayers, responseStub.userIds);
					
				if(callback != null)
					callback.apply(this, callbackArgs);
					
				return;
			}
			
			var idsToSend:Vector.<String> = idList.splice(0, Math.min(idList.length, MAX_IDS_PER_SEND));
			var ids:String = idsToSend.join(",");
			
			if (GiftsModel.SOSTRACE_LOGGING_ENABLE)
				sosTrace('sendGiftsToFriends idList', ids, SOSLog.DEBUG);
				
			socialRequestFaceBookDialog(ids, Constants.GIFT_FACEBOOK_MESSAGE, 
				function(response:FacebookDialogResponse):void
				{
					if (GiftsModel.SOSTRACE_LOGGING_ENABLE)
						sosTrace('sendGiftsToFriends dialog status: ', response.isEmpty, response.responseStatusOk, SOSLog.DEBUG);
					
					if (!response.isEmpty)
					{
						if (GiftsModel.SOSTRACE_LOGGING_ENABLE)
							sosTrace('sendGiftsToFriends fb response ids: ', response.userIds , SOSLog.DEBUG);
						
						Game.connectionManager.sendGiftMessage(response);
						merge(mFacebookData.uniqueGiftedPlayers, response.userIds);
					}
					
					if (response.isEmpty/* || !response.responseStatusOk*/) {
				
						if(callback != null)
							callback.apply(this, callbackArgs);
						
						return;
					}
					
					sendGiftsToFriends(callback, callbackArgs, idList);
				}
			);
		}
		
		public function selectOrDeselectAllPlayersAvailableForInvite(select:Boolean):void
		{
			selectOrDeselectAll(getAllFriendsEligibleForInvite(), select);
		}
		
		public function selectOrDeselectAllPlayersAvailableForGift(select:Boolean):void
		{
			selectOrDeselectAll(getAllFriendsEligibleForGift(), select);
		}
		
		public function get isAllInviteFriendsDeselected():Boolean
		{
			return isAllDeselected(getAllFriendsEligibleForInvite());
		}
		
		public function get isAllForGiftsFriendsDeselected():Boolean
		{
			return isAllDeselected(getAllFriendsEligibleForGift());
		}
		
		private static function isAllDeselected(friends:Vector.<FacebookFriend>):Boolean
		{
			for each (var f:FacebookFriend in friends) {
				if (f.selected)
					return false;
			}
			return true;
		}
		
		private static function selectOrDeselectAll(friends:Vector.<FacebookFriend>, select:Boolean):void
		{
			for each (var f:FacebookFriend in friends)
			{
				f.selected = select;
			}
		}
		
		public function countAvailableForInvite():int
		{
			var count:int = 0;
			
			for each (var friend:FacebookFriend in mFacebookData.inviteableFriends)
			{
				if (!mFacebookData.isNoAppFriendAlreadyInvited(friend.inviteToken))
				{
					count++;
				}
			}
			
			_cachedAvailableForInvite = count;
			
			return count;
		}
		
		//TODO Separate getting and sorting available for invite friends. Cache results and invalidate cache when new friend data arrives.
		public function getAllFriendsEligibleForInvite():Vector.<FacebookFriend>
		{
			var retVal:Vector.<FacebookFriend> = new Vector.<FacebookFriend>();
			
			for each (var friend:FacebookFriend in mFacebookData.inviteableFriends)
			{
				if (!mFacebookData.isNoAppFriendAlreadyInvited(friend.inviteToken))
				{
					retVal.push(friend);
				}
			}
			
			_cachedAvailableForInvite = retVal.length;
			
			retVal.sort(function(facebookFriend1:FacebookFriend, facebookFriend2:FacebookFriend):Number
			{
				if (facebookFriend1.firstName < facebookFriend2.firstName)
				{
					return -1;
				}
				else if (facebookFriend1.firstName > facebookFriend2.firstName)
				{
					return 1;
				}
				else
				{
					return 0;
				}
			});
			
			return retVal;
		}
		
		public function getAllFriendsEligibleForGift():Vector.<FacebookFriend>
		{
			var retVal:Vector.<FacebookFriend> = new Vector.<FacebookFriend>();
			
			for each (var friend:FacebookFriend in mFacebookData.bingoInstalledFriendsWithoutFullQueue)
			{
				if (isGoodForGiftInternal(friend))
				{
					retVal.push(friend);
				}
			}
			
			retVal.sort(function(facebookFriend1:FacebookFriend, facebookFriend2:FacebookFriend):Number
			{
				if (facebookFriend1.giftsCount > facebookFriend2.giftsCount)
				{
					return -1;
				}
				else if (facebookFriend1.giftsCount < facebookFriend2.giftsCount)
				{
					return 1;
				}
				else
				{
					if (facebookFriend1.firstName < facebookFriend2.firstName)
					{
						return -1;
					}
					else if (facebookFriend1.firstName > facebookFriend2.firstName)
					{
						return 1;
					}
					else
					{
						return 0;
					}
				}
			});
			
			return retVal;
		}
		
		private function socialRequestFaceBookDialog(commaSeparatedIds:String, message:String, callback:Function):void
		{
			var params:Object = new Object();
			params.to = commaSeparatedIds;
			params.message = message;
			mFacebookManager.dialog("apprequests", params, function(argum:Object):void
			{
				var responseObject:FacebookDialogResponse = new FacebookDialogResponse();
				if (PlatformServices.isMobile)
				{
					if (argum.type == GVFacebookEvent.FB_DIALOG_FINISHED && argum.hasOwnProperty("data"))
						responseObject.parse(argum.data);
					
					responseObject.responseStatusOk = argum.type == GVFacebookEvent.FB_DIALOG_FINISHED;
				}
				else
				{
					responseObject.parse(argum);
				}
				callback(responseObject);
			});
		}
		
		private static function merge(mergeTo:Vector.<FacebookIdAndTimestamp>, newFbIds:Array /* String */):void
		{
			for each (var fbId:String in newFbIds)
			{
				var found:Boolean = false;
				for each (var fbIdAndTs:FacebookIdAndTimestamp in mergeTo)
				{
					if (fbIdAndTs.facebookId == fbId)
					{
						fbIdAndTs.timestamp = Game.connectionManager.currentServerTime;
						found = true;
						break;
					}
				}
				if (!found)
				{
					mergeTo.push(new FacebookIdAndTimestamp(fbId, Game.connectionManager.currentServerTime));
				}
			}
		}
		
		public function isGoodForGift(facebookId:String, checkInstallState:Boolean = true):Boolean
		{
			return isGoodForGiftInternal(new FacebookFriend(facebookId, null, null), checkInstallState);
		}
		
		private function isGoodForGiftInternal(friend:FacebookFriend, checkIfUserInstalledBingo:Boolean = false):Boolean
		{
			if (checkIfUserInstalledBingo)
			{
				var foundInBingoInstalled:Boolean = false;
				for each (var bingoInstalledFriend:FacebookFriend in mFacebookData.bingoInstalledFriendsWithoutFullQueue)
				{
					if (bingoInstalledFriend.facebookId == friend.facebookId)
					{
						foundInBingoInstalled = true;
						break;
					}
				}
				if (foundInBingoInstalled == false)
				{
					return false;
				}
			}
			
			for each (var facebookIdAndTimestamp:FacebookIdAndTimestamp in mFacebookData.uniqueGiftedPlayers)
			{
				if (facebookIdAndTimestamp.facebookId == friend.facebookId)
				{
					friend.giftsCount = facebookIdAndTimestamp.giftsCount;
					var curTime:Number = Game.connectionManager.currentServerTime;
					var giftTimestamp:Number = facebookIdAndTimestamp.timestamp;
					
					if (GiftsModel.SOSTRACE_LOGGING_ENABLE)
						sosTrace('isGoodForGiftInternal ', friend.facebookId, curTime - giftTimestamp > gameManager.giftsModel.giftMessageLifetime, curTime - giftTimestamp, gameManager.giftsModel.giftMessageLifetime);
					
					return (curTime - giftTimestamp > gameManager.giftsModel.giftMessageLifetime);
				}
			}
		
			if (GiftsModel.SOSTRACE_LOGGING_ENABLE)
				sosTrace('isGoodForGiftInternal not found friend in uniqueGiftedPlayers', friend.facebookId, SOSLog.DEBUG);
			
			friend.giftsCount = 0;
			return true;
		}
		
		private function getFriendInviteTokens(count:int):Vector.<String> 
		{
			var inviteableFriends:Vector.<FacebookFriend> = getAllFriendsEligibleForInvite();
			
			var inviteTokens:Vector.<String> = new Vector.<String>; 
			var friend:FacebookFriend;
			var length:int;
			for each (friend in inviteableFriends)
			{
				if (friend.selected)
				{
					length = inviteTokens.push(friend.inviteToken);
					if (length >= count)
						break;
				}
			}
			
			return inviteTokens;
		}
	}
}
