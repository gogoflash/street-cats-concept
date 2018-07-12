package com.alisacasino.bingo.screens.gameScreenClasses
{
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.protocol.PlayerBingoedMessage;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	import com.alisacasino.bingo.resize.IResizable;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.DelayCallUtils;
	import com.alisacasino.bingo.utils.GameManager;
	import com.netease.protobuf.UInt64;
	import feathers.core.FeathersControl;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class WinnersPane extends FeathersControl
	{
		public static var DELAY_CALLS_BUNDLE:String = 'tutorial_winners_bundle';
		
		public static var NO_AVATAR_BG_COLORS:Array = [0x469900, 0x0058BF, 0xC519A1, 0xDE7800, 0x6700BF];
		public static var NO_AVATAR_BASE_COLOR:uint = 0x00325e//0x00315E;
		
		public static var MOBILE_CAPACITY:uint = 4;
		
		public static var EXPECTED_RENDERER_HEIGHT:uint = 100;
		public static var EXPECTED_RENDERER_GAP:uint = 4;
		
		public static var noAvatarBgColorIndex:int;
		
		private var appearCalled:Boolean;
		private var _blockAddNewWinners:Boolean;
		
		private var capacity:int;
		private var winnersCount:int;
		
		private var winnerPlates:Vector.<WinnerPlate>;
		private var lastSettedPlateIndex:int = 0;
		private var startNonPlacePlateIndex:int = 0;
		
		public function WinnersPane()
		{
			winnerPlates = new Vector.<WinnerPlate>();
			noAvatarBgColorIndex = Math.floor(Math.random() * WinnersPane.NO_AVATAR_BG_COLORS.length);
		}
		
		public function set blockAddNewWinners(value:Boolean):void {
			_blockAddNewWinners = value;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			for (var i:int = 0; i < MOBILE_CAPACITY; i++) 
			{
				var plate:WinnerPlate = new WinnerPlate(i);
				plate.y = (EXPECTED_RENDERER_HEIGHT + EXPECTED_RENDERER_GAP) * i * pxScale;
				addChild(plate);
				
				winnerPlates.push(plate);
			}
		}
		
		public function appear(baseDelay:Number):void 
		{
			_blockAddNewWinners = false;
			appearCalled = true;
			for (var i:int = 0; i < winnerPlates.length; i++) 
			{
				//if(!winnerPlates[i].winnerData)
					winnerPlates[i].tweenAppear(baseDelay + i * 0.05);
			}
		}
		
		public function addWinnerFromPlayerBingoedMessage(message:PlayerBingoedMessage, animate:Boolean = true):void 
		{
			if (_blockAddNewWinners)
				return;
				
			//trace(' next winner ', message.place, message.player.firstName);
			//sosTrace('next winner ', message.place, message.player.firstName);
			
			var plate:WinnerPlate;
			if (lastSettedPlateIndex >= winnerPlates.length)
				lastSettedPlateIndex = winnerPlates.length - 1; //Math.min(winnerPlates.length-1, startNonPlacePlateIndex);
			
			plate = winnerPlates[lastSettedPlateIndex];
			
			if (!plate.winnerData) {
				plate.winnerData = message;
				
				if (plate.winnerData.place <= MOBILE_CAPACITY)
					startNonPlacePlateIndex = Math.max(lastSettedPlateIndex, startNonPlacePlateIndex);
			}
			else  {
				plate.winnerData = message;
			}
				
			lastSettedPlateIndex++;
			
			if (!animate)
			{
				plate.needToAnimate = false;
			}
			
			winnersCount++;
		}
		
		public function reset(isStartGame:Boolean = false):void 
		{
			winnersCount = 0;
			appearCalled = false;
			lastSettedPlateIndex = 0;
			startNonPlacePlateIndex = 0;
			_blockAddNewWinners = !isStartGame;
			
			for each (var item:WinnerPlate in winnerPlates) {
				item.reset();
			}
		}
		
		public function resize():void 
		{
			var i:int;
			var length:int = winnerPlates.length;
			for (i = 0; i < length; i++) {
				winnerPlates[i].resize();
			}
			
			var plate:WinnerPlate;
			var maxCapacity:int;
			var EXPECTED_RENDERER_HEIGHT_AND_GAP:int = EXPECTED_RENDERER_HEIGHT + EXPECTED_RENDERER_GAP;
			if (true/*gameManager.layoutHelper.isLargeScreen*/)
			{
				maxCapacity = Math.max(MOBILE_CAPACITY, (gameManager.layoutHelper.stageHeight - y - EXPECTED_RENDERER_GAP) / (EXPECTED_RENDERER_HEIGHT_AND_GAP * pxScale * scale));
				//maxCapacity++
				while(winnerPlates.length < maxCapacity) 
				{
					plate = new WinnerPlate(winnerPlates.length);
					plate.y = EXPECTED_RENDERER_HEIGHT_AND_GAP * winnerPlates.length * pxScale;
					addChild(plate);
					winnerPlates.push(plate);
					if(appearCalled)
						plate.tweenAppear(0);
				}
				
				// додаунскейливаем, если не помещаемся:
				var recalculatedScale:Number = (gameManager.layoutHelper.stageHeight - y - EXPECTED_RENDERER_GAP)/(EXPECTED_RENDERER_HEIGHT_AND_GAP * pxScale * scale * maxCapacity);
				//trace('recalculatedScale', recalculatedScale);
				scale = scale * Math.min(1, recalculatedScale);
			}
			/*else
			{
				maxCapacity = MOBILE_CAPACITY;
			}*/
			
			while(winnerPlates.length > maxCapacity) 
			{
				plate = winnerPlates.pop();
				plate.removeFromParent();
				plate.destroy();
			}
			
			length = winnerPlates.length;
			var shiftY:int = (gameManager.layoutHelper.stageHeight - y - EXPECTED_RENDERER_HEIGHT_AND_GAP * pxScale * scale * length - EXPECTED_RENDERER_GAP)/2;
			for (i = 0; i < length; i++) {
				winnerPlates[i].y = shiftY + EXPECTED_RENDERER_HEIGHT_AND_GAP * i * pxScale;
			}
		}
		
		public static function get noAvatarBgColor():uint
		{
			if (noAvatarBgColorIndex >= NO_AVATAR_BG_COLORS.length)
				noAvatarBgColorIndex = 0;
				
			return NO_AVATAR_BG_COLORS[noAvatarBgColorIndex++];
		}
		
		public function addTutorialPlayer(delay:Number, playerBingoedMessage:PlayerBingoedMessage, facebookId:String = null, userNickName:String = null, avatarUrl:String = null):void 
		{
			if (delay <= 0) 
				tutorialAddPlayer(playerBingoedMessage, facebookId, userNickName, avatarUrl);
			else 
				DelayCallUtils.add(Starling.juggler.delayCall(tutorialAddPlayer, delay, playerBingoedMessage, facebookId, userNickName, avatarUrl), DELAY_CALLS_BUNDLE);
		}
		
		private function tutorialAddPlayer(playerBingoedMessage:PlayerBingoedMessage, facebookID:String, userNickName:String, avatarUrl:String = null):void
		{
			if (!playerBingoedMessage) 
			{
				playerBingoedMessage = new PlayerBingoedMessage();
				
				var playerMessage:PlayerMessage = new PlayerMessage();
				playerMessage.playerId = UInt64.fromNumber(1125);
				playerMessage.facebookIdString = facebookID;
				playerMessage.firstName = userNickName || facebookID;
				playerMessage.avatar = avatarUrl;
				
				playerBingoedMessage.coinsEarned = Math.random() * 100;
				playerBingoedMessage.ticketsEarned = Math.random() * 100;
				playerBingoedMessage.scoresEarned = Math.random() * 100;
				playerBingoedMessage.player = playerMessage;
			}
			
			playerBingoedMessage.place = winnersCount + 1;
			addWinnerFromPlayerBingoedMessage(playerBingoedMessage);
		}
		
		public function deviceOrientationChanged():void
		{
			for each (var item:WinnerPlate in winnerPlates) {
				item.deviceOrientationChanged();
			}
		}
		
		/********************************************************************************************************
		 * 
		 * DEBUG
		 * 
		 * *****************************************************************************************************/
		
		private var debugInterval:uint;
		
		public function debugAddPlayer():void {
			var msg:PlayerBingoedMessage = debugGetPlayerBingoedMessage(winnersCount%2 == 0, winnersCount + 1);
			addWinnerFromPlayerBingoedMessage(msg);
			/*addWinnerFromPlayerBingoedMessage(msg);
			addWinnerFromPlayerBingoedMessage(msg);
			addWinnerFromPlayerBingoedMessage(msg);
			addWinnerFromPlayerBingoedMessage(msg);*/
		}
		
		public static function debugGetPlayerBingoedMessage(hasFacebookID:Boolean = true, place:int = 1):PlayerBingoedMessage 
		{
			var msg:PlayerBingoedMessage = new PlayerBingoedMessage();
			msg.place = place;
			
			var playerMessage:PlayerMessage = new PlayerMessage();
			playerMessage.playerId = UInt64.fromNumber(1125);
			
			if (hasFacebookID) {
				playerMessage.facebookIdString = debugFbUsers[Math.floor(debugFbUsers.length * Math.random())]; // 'lifestreamcos';
				playerMessage.firstName = "fbUser " + msg.place.toString();
				trace('debugGetPlayerBingoedMessage', playerMessage.facebookIdString, playerMessage.firstName);
			}
			else {
				playerMessage.firstName = "noFbUser " + msg.place.toString();
			}
			
			msg.coinsEarned = Math.random() * 100;
			msg.ticketsEarned = Math.random() * 100;
			msg.scoresEarned = Math.random() * 100;
			
			msg.player = playerMessage;
			return msg;
		}
		
		public function debugAddPlayers():void {
			
			//reset();
			
			clearInterval(debugInterval);
			debugInterval = setInterval(function():void 
			{
				
				//if (winnersCount >= capacity) {
					//return;
				//}
				
				//if (winnersCount > 8)
					//return;
				
				var msg:PlayerBingoedMessage = debugGetPlayerBingoedMessage(winnersCount%2 == 0, winnersCount + 1);
				addWinnerFromPlayerBingoedMessage(msg);
				
			}, 740);
			
		}
		
		private static var debugFbUsers:Array = [
			'lifestreamcos',
			'kubanzheldormash',
			'212881995497403',
			'291711741036535',
			'cafesiren',
			'425495904128135',
			'1785802438299679',
			'100005954131753'
		]
	}
}