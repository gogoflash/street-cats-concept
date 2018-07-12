package com.alisacasino.bingo.screens.gameScreenClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.components.MultiCharsLabel;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.scratchCard.itemLayerClasses.ScratchItemRenderer;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.PlayerBingoedMessage;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.misc.TextureMaskStyle;
	import feathers.controls.ImageLoader;
	import feathers.core.FeathersControl;
	import feathers.layout.HorizontalAlign;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import starling.events.Event;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Canvas;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.Align;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class WinnerPlate extends FeathersControl
	{
		/*static public const FIRST_PLACE:String = "firstPlace";
		static public const SECOND_PLACE:String = "secondPlace";
		static public const THIRD_PLACE:String = "thirdPlace";
		static public const COMMON:String = "common";
		static public const LAST_PLATE:String = "lastPlate";*/
		
		public static const WINNER_SHOW_TIMEOUT:int = 1700;
		
		public static const AVATAR_WIDTH:int = 105;
		public static const AVATAR_HEIGHT:int = 97;
		
		public var index:int;
		
		public var initialized:Boolean;
		
		public var needToAnimate:Boolean;
		
		private var appearCalled:Boolean;
		
		private var _winnerData:PlayerBingoedMessage;
		
		private var isTabletLayout:Boolean;
		
		private var noAvatarBgColor:uint;
		
		private var isLoaded:Boolean;
		private var blockShowAvatar:Boolean;
		
		private var avatarContainer:Sprite;
		private var avatarBg:Image;
		private var avatarImage:ImageLoader;
		private var catIcon:Image;
		
		private var placeTextField:XTextField;
		private var nameTextField:MultiCharsLabel;
		
		private var corner:Image;
		private var crown:Image;
		
		private var avatarFrame:Image;
		
		private var cornerTexture:String;
		private var crownTexture:String;
		private var nameTextColor:int;
		private var nameTextStyle:XTextFieldStyle;
		
		private var delayedShowNextWinnerId:int;
		
		private var delayedNextWinnerData:PlayerBingoedMessage;
		private var lastWinnerShowTime:int;
		
		public function WinnerPlate(index:int) 
		{
			this.index = index;
			noAvatarBgColor = WinnersPane.NO_AVATAR_BASE_COLOR;//WinnersPane.noAvatarBgColor;
		}
		
		public function get winnerData():PlayerBingoedMessage 
		{
			return _winnerData || delayedNextWinnerData;
		}
		
		public function set winnerData(value:PlayerBingoedMessage):void 
		{
			if (_winnerData == value)
				return;
			
			var timeout:int = WINNER_SHOW_TIMEOUT - (getTimer() - lastWinnerShowTime);
			//trace(' >> time ', timeout);
			if (timeout < 0) 
			{
				delayedNextWinnerData = null;
				removeDelayedShowNextWinner();
				internalSetNewWinnerData(value);
			}
			else
			{
				delayedNextWinnerData = value;
				delayedShowNextWinnerId = Starling.juggler.delayCall(tryShowNextWinner, timeout/1000 + 0.01);
			}
		}
		
		public function internalSetNewWinnerData(value:PlayerBingoedMessage):void 
		{
			if (_winnerData == value)
				return;
			
			lastWinnerShowTime = getTimer();
			
			_winnerData = value;
			
			needToAnimate = _winnerData != null;
			
			isLoaded = false;
			blockShowAvatar = true;
			
			noAvatarBgColor = WinnersPane.noAvatarBgColor;
			
			if (_winnerData) 
			{
				switch(_winnerData.place) {
					case 1: {
						cornerTexture = "winners_pane/corner_gold";
						crownTexture = "winners_pane/crown_gold";
						nameTextColor = 0xefdd13;
						nameTextStyle = XTextFieldStyle.WinnerPlayerNameYellow;
						SoundManager.instance.playSfx(SoundAsset.AvatarsChangeX1, 0, 0, 0.35, 0, true);
						break;
					}
					case 2: {
						cornerTexture = "winners_pane/corner_silver";
						crownTexture = "winners_pane/crown_silver";
						nameTextColor = 0xc4eafb;
						nameTextStyle = XTextFieldStyle.WinnerPlayerNameSilver;
						SoundManager.instance.playSfx(SoundAsset.AvatarsChangeX2, 0, 0, 0.35, 0, true);
						break;
					}
					case 3: {
						cornerTexture = "winners_pane/corner_bronze";
						crownTexture = "winners_pane/crown_bronze";
						nameTextColor = 0xf3a74b;
						nameTextStyle = XTextFieldStyle.WinnerPlayerNameBronze;
						SoundManager.instance.playSfx(SoundAsset.AvatarsChangeX3, 0, 0, 0.35, 0, true);
						break;
					}
					case 4: {
						SoundManager.instance.playSfx(SoundAsset.AvatarsChangeX4, 0, 0, 0.35, 0, true);
						nameTextStyle = XTextFieldStyle.WinnerPlayerNameWhite;
					}
					default: {
						cornerTexture = null;
						crownTexture = null;
						nameTextColor = 0xFFFFFF;
						nameTextStyle = XTextFieldStyle.WinnerPlayerNameWhite;
						SoundManager.instance.playSfx(SoundAsset.AvatarsChangeX5, 0, 0, 0.35, 0, true);
						break;
					}
				}
				
				//trace(' setted > ', winnerData.player.firstName, winnerData.place);	
			}
			else
			{
				crownTexture = null;
				cornerTexture = null;
				nameTextColor = 0xFFFFFF;
				nameTextStyle = XTextFieldStyle.WinnerPlayerNameWhite;
			}

			if (Constants.isDevFeaturesEnabled && winnerData.player && winnerData.player.hasAvatar)
				nameTextStyle = XTextFieldStyle.WinnerBotName;
			
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			isTabletLayout = gameManager.layoutHelper.isLargeScreen;
			
			avatarContainer = new Sprite();
			addChild(avatarContainer);
			
			avatarBg = new Image(AtlasAsset.CommonAtlas.getTexture("winners_pane/avatar_mask"));
			avatarBg.x = 2* pxScale;
			avatarBg.y = 2 * pxScale;
			avatarBg.alpha = 0.6;
			avatarBg.color = noAvatarBgColor;
			avatarContainer.addChild(avatarBg);
			
			catIcon = new Image(AtlasAsset.CommonAtlas.getTexture("winners_pane/alisa_logo"));
			catIcon.x = 17 * pxScale;
			catIcon.y = 18 * pxScale;
			avatarContainer.addChild(catIcon);
			
			avatarFrame = new Image(AtlasAsset.CommonAtlas.getTexture("winners_pane/avatar_frame"));
			avatarContainer.addChild(avatarFrame);
		
			avatarContainer.x = -avatarFrame.width;
			
			initialized = true;
		}
		
		override protected function draw():void 
		{
			super.draw();
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				commitData();
			}
		}
		
		private function commitData():void 
		{
			if (gameManager.deactivated) {
				Game.addEventListener(Game.ACTIVATED, handler_gameActivated);
				return;
			}
			
			if (!winnerData)
			{
				return;
			}
			
			if (winnerData.player.hasFacebookIdString || winnerData.player.hasAvatar)
			{
				if (!avatarImage)
				{
					avatarImage = new ImageLoader();
					avatarImage.addEventListener(flash.events.Event.COMPLETE, handler_avatarLoaded);
					avatarImage.addEventListener(IOErrorEvent.IO_ERROR, handler_avatarLoaded);
					avatarImage.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handler_avatarLoaded);
					avatarImage.x = 2* pxScale;
					avatarImage.y = 2 * pxScale;
					
					/*avatarImage.addEventListener(starling.events.Event.COMPLETE, function(event:*):void {trace('Event.COMPLETE')}); 
					avatarImage.addEventListener(starling.events.Event.IO_ERROR, function(event:*):void {trace('Event.IO_ERROR')});
					avatarImage.addEventListener(starling.events.Event.SECURITY_ERROR, function(event:*):void {trace('Event.SECURITY_ERROR')});*/
					
					
					//avatarImage.source = AtlasAsset.CommonAtlas.getTexture("winners_pane/avatar_mask");
					//avatarImage.alpha = 0.65;
					//avatarImage.color = noAvatarBgColor;
					avatarContainer.addChildAt(avatarImage, avatarContainer.getChildIndex(avatarBg) + 1);
				}
				
				avatarBg.visible = true;
				catIcon.visible = true;
				avatarImage.visible = false;
				//avatarImage.loadingTexture = AtlasAsset.CommonAtlas.getTexture("winners_pane/avatar_mask");
				
				var sourceUrl:String = Player.getAvatarURL(Player.getAlternativeAvatarURL(winnerData.player), winnerData.player.facebookIdString, AVATAR_WIDTH * pxScale, AVATAR_HEIGHT * pxScale);
				
				if (avatarImage.source == sourceUrl) 
					avatarImage.source = null;
				
				avatarImage.source  = sourceUrl;
			}
			else
			{
				if (avatarImage)
				{
					avatarImage.source = null;
					avatarImage.visible = false;
				}
				
				avatarBg.visible = true;
				catIcon.visible = true;
			}
			
			if (!appearCalled)
			{
				return;
			}
			
			if (needToAnimate)
			{
				animateWinnerAppearance();
			}
			else
			{
				avatarBg.color = noAvatarBgColor;
				
				tweenAppearAvatarContainer(0);
			
				if (winnerData.place < 4)
				{
					addCrown(true);
					addCorner(true);
				}
				else
				{
					addPlace(true);
				}
				
				addName(true);
				
				if (placeTextField)
					placeTextField.text = winnerData.place.toString();
				
				/*if (nameTextField)
					nameTextField.text = winnerData.player.firstName;*/
			}
		}
		
		public function tweenAppear(delay:Number):void
		{
			if (_winnerData) {
				validate();
				animateWinnerAppearance(delay, false);
			}
			else {
				tweenAppearAvatarContainer(0.3, delay);
			}
			
			appearCalled = true;
		}
		
		public function reset():void 
		{
			appearCalled = false;
			_winnerData = null;
			delayedNextWinnerData = null;
			
			if (!initialized)
				return;
			
			avatarBg.color = WinnersPane.NO_AVATAR_BASE_COLOR;
			avatarBg.alpha = 0.6;
			avatarBg.visible = true;
			catIcon.visible = true;
				
			Starling.juggler.removeTweens(avatarContainer);
			
			removeDelayedShowNextWinner();
			
			if (avatarImage) {
				avatarImage.visible = false;
				avatarImage.source = null;
			}
			
			if (placeTextField) {
				Starling.juggler.removeTweens(placeTextField);
				placeTextField.removeFromParent(true);
				placeTextField = null;
			}
			
			if (nameTextField) {
				Starling.juggler.removeTweens(nameTextField.textField);
				nameTextField.clean(true);
				nameTextField = null;
			}
			
			if (corner) {
				Starling.juggler.removeTweens(corner);
				corner.removeFromParent();
				corner = null;
			}
			
			if (crown) {
				Starling.juggler.removeTweens(crown);
				crown.removeFromParent();
				crown = null;
			}
			
			avatarContainer.x = -avatarFrame.width;
		}
		
		private function animateWinnerAppearance(delay:Number = 0, tweenContainerBack:Boolean = true):void 
		{
			blockShowAvatar = true;
			//avatarContainer.x = -avatarFrame.width;
			//addChild(avatarContainer);
		
			Starling.juggler.removeTweens(avatarContainer);
			
			if(tweenContainerBack)
				Starling.juggler.tween(avatarContainer, 0.25, {delay:delay, x:-avatarFrame.width, transition:Transitions.EASE_IN_BACK, onComplete:makeAvatarVisible});
			else
				makeAvatarVisible();
				
			tweenAppearAvatarContainer(0.25, delay + 0.3);
		
			if (winnerData.place < 4)
			{
				addCrown(false, delay + 0.40);
				addCorner(false, delay + 0.5);
			}
			else
			{
				if (placeTextField) {
					Starling.juggler.removeTweens(placeTextField);
					Starling.juggler.tween(placeTextField, 0.15, {scale:0, delay:delay, transition:Transitions.EASE_IN_BACK, onComplete:addPlace, onCompleteArgs:[false, 0.3 + delay]});
				}
				else {
					addPlace(false, delay + 0.5);	
				}
			}
			
			if (nameTextField) {
				Starling.juggler.removeTweens(nameTextField.textField);
				Starling.juggler.tween(nameTextField.textField, 0.2, {delay:(delay + 0.08), x:-nameTextField.textField.width, transition:Transitions.EASE_IN_BACK, onComplete:addName, onCompleteArgs:[false, 0.1 + delay]});
			}
			else {
				addName(false, delay + 0.45);
			}
		}
		
		private function tweenAppearAvatarContainer(time:Number, delay:Number = 0):void 
		{
			if (time == 0)
			{
				avatarContainer.x = containerX;
				//addChild(avatarContainer);
			}
			else
			{
				//Starling.juggler.removeTweens(avatarContainer);
				Starling.juggler.tween(avatarContainer, time, { delay:delay, "x#": containerX, transition:Transitions.EASE_OUT_BACK});
			}
		}
		
		private function tryShowNextWinner():void 
		{
			delayedShowNextWinnerId = 0;
			//trace(' >> tryShowNextWinner ');
			if (delayedNextWinnerData)
				internalSetNewWinnerData(delayedNextWinnerData);
			
			delayedNextWinnerData = null;	
		}	
		
		private function addPlace(skipTween:Boolean = false, delay:Number = 0):void 
		{
			if (!winnerData || gameManager.deactivated)
				return;
				
			if (!placeTextField) {
				placeTextField = new XTextField(60* pxScale, 38* pxScale, XTextFieldStyle.getWalrus(29).addStroke(1, 0x0), winnerData.place.toString());
				//placeTextField.autoScale = true;
				//placeTextField.border = true;
				placeTextField.scale = 0;
				placeTextField.batchable = true;
				addChild(placeTextField);
			}
			else {
				placeTextField.text = winnerData.place.toString();
			}
			
			placeTextField.redraw();
			placeTextField.alignPivot();
			placeTextField.x = containerX + 90 * pxScale;
			placeTextField.y = 22 * pxScale;
			
			if (!skipTween)
			{
				placeTextField.scale = 0;
				Starling.juggler.tween(placeTextField, 0.2, {delay:delay, scale:1, transition:Transitions.EASE_OUT_BACK } );
			}
		}
		
		private function addName(skipTween:Boolean = false, delay:Number = 0):void 
		{
			if (!winnerData || gameManager.deactivated)
				return;
				
			if (!nameTextField)	{
				nameTextField = new MultiCharsLabel(nameTextStyle || XTextFieldStyle.WinnerPlayerNameWhite, 120 * pxScale, 25 * pxScale, winnerData.player.firstName); 
				nameTextField.textField.batchable = true;
				//nameTextField.debugTest();
				addChild(nameTextField.textField);
			}
			else {
				nameTextField.setStyle(nameTextStyle || XTextFieldStyle.WinnerPlayerNameWhite);
				nameTextField.text = winnerData.player.firstName;
			}
			
			nameTextField.textField.redraw();
			nameTextField.textField.y = 76 * pxScale;
			
			if (skipTween)
			{
				nameTextField.textField.x = containerX - 9 * pxScale;
			}
			else
			{
				nameTextField.textField.x = -nameTextField.textField.width;
				Starling.juggler.tween(nameTextField.textField, 0.2, {delay:delay, "x#":(containerX - 9*pxScale), transition:Transitions.EASE_OUT_BACK } );
			}
		}
		
		private function addCorner(skipTween:Boolean = false, delay:Number = 0):void 
		{
			if (!winnerData || corner || !cornerTexture)
				return;
			
			corner = new Image(AtlasAsset.CommonAtlas.getTexture(cornerTexture));
			corner.alignPivot(Align.RIGHT, Align.TOP);
			addChildAt(corner, crown ? getChildIndex(crown) : numChildren);
			
			corner.x = containerX + 109 * pxScale;
			//corner.y =  * pxScale;
			
			if (!skipTween)
			{
				corner.scale = 0;
				Starling.juggler.tween(corner, 0.05, { delay:delay, "scale#":1,  transition:Transitions.LINEAR } );
			}
		}
		
		private function addCrown(skipTween:Boolean = false, delay:Number = 0):void 
		{
			if (!winnerData || crown || !crownTexture)
				return;
			
			crown = new Image(AtlasAsset.CommonAtlas.getTexture(crownTexture));
			crown.alignPivot(Align.LEFT, Align.BOTTOM);
			
			addChild(crown);
			
			if (skipTween)
			{
				crown.x = crownX;
				crown.y = 29 * pxScale;
				crown.alpha = 1;
				crown.scale = 1;
			}
			else
			{
				crown.alpha = 0;
				crown.scale = 0.5;
				crown.x = containerX + 88 * pxScale;
				crown.y = 23 * pxScale;
				Starling.juggler.tween(crown, 0.1, { delay:delay, alpha:8, "x#": (containerX + 90 * pxScale), "y#":18 * pxScale, "scale#":1.3, transition:Transitions.LINEAR } );
				Starling.juggler.tween(crown, 0.1, { delay:(delay + 0.1), "x#":crownX, "y#":29 * pxScale, "scale#": 1, transition:Transitions.LINEAR } );
			}
			
		}
		
		private function updateValues():void 
		{
			if (winnerData && winnerData.player)
			{
				if (placeTextField) {
					placeTextField.text = winnerData.place.toString();
				}
				
				if (nameTextField) {
					nameTextField.setStyle(nameTextStyle || XTextFieldStyle.WinnerPlayerNameWhite);
					nameTextField.text = winnerData.player.firstName;
					nameTextField.textField.redraw();
				}
				
				if (crown) {
					crown.texture = AtlasAsset.CommonAtlas.getTexture(crownTexture);
					crown.readjustSize();
					crown.alignPivot(Align.LEFT, Align.BOTTOM);
				}
				
					
				if (winnerData.player.hasFacebookIdString || winnerData.player.hasAvatar)
				{
					
				}
				else
				{
					avatarBg.visible = true;
					catIcon.visible = true;
				}
					
				blockShowAvatar = false;	
				appearCalled = true;
				handler_avatarLoaded(null);
			}
			else
			{
				
			}
		}
		
		public function resize(animateTime:Number = 0.05):void 
		{
			isTabletLayout = gameManager.layoutHelper.isLargeScreen;
			
			updateValues();
			
			if (_winnerData)
			{
				if (placeTextField) {
					Starling.juggler.removeTweens(placeTextField);
					placeTextField.scale = 1;
					Starling.juggler.tween(placeTextField, animateTime, {x:(containerX + 90 * pxScale), transition:Transitions.EASE_OUT} );
				}
				
				if (nameTextField) {
					Starling.juggler.removeTweens(nameTextField.textField);
					Starling.juggler.tween(nameTextField.textField, animateTime, {x:(containerX - 9 * pxScale), transition:Transitions.EASE_OUT} );
				}
				
				if (corner) {
					Starling.juggler.removeTweens(corner);
					Starling.juggler.tween(corner, animateTime, {x:(containerX + 109 * pxScale), scale:1, transition:Transitions.EASE_OUT} );
				}
				
				if (crown) {
					Starling.juggler.removeTweens(crown);
					Starling.juggler.tween(crown, animateTime, {x:crownX, y:29 * pxScale, scale:1, alpha:1, transition:Transitions.EASE_OUT} );
				}
			}
			else
			{
				if (placeTextField) {
					Starling.juggler.removeTweens(placeTextField);
					placeTextField.scale = 0;
					placeTextField.x = containerX + 90 * pxScale;
				}
				
				if (nameTextField) {
					Starling.juggler.removeTweens(nameTextField.textField);
					nameTextField.textField.x = -nameTextField.textField.width;
				}
				
				if (corner) {
					Starling.juggler.removeTweens(corner);
					corner.removeFromParent();
					corner = null;
				}
				
				if (crown) {
					Starling.juggler.removeTweens(crown);
					crown.removeFromParent();
					crown = null;
				}
			}
		
			Starling.juggler.removeTweens(avatarContainer);
			Starling.juggler.tween(avatarContainer, animateTime, {x:(appearCalled ? containerX : -avatarFrame.width), transition:Transitions.EASE_OUT} );
		}
		
		private function handler_avatarLoaded(event:*):void 
		{
			if (avatarImage && avatarImage.isLoaded && (avatarImage.source is String)) 
			{
				isLoaded = true;
				
				if (!blockShowAvatar) 
					Starling.juggler.delayCall(makeAvatarVisible, 0.017); // без задержки вернет нулевые width, height
			}
		}
		
		private function makeAvatarVisible():void 
		{
			if (!winnerData || !winnerData.player || !avatarImage) 
			{
				avatarBg.color = noAvatarBgColor;
				avatarBg.alpha = 0.6;
				blockShowAvatar = false;	
				
				return;
			}
			
			if (winnerData.player.hasFacebookIdString)
			{
				avatarBg.color = WinnersPane.NO_AVATAR_BASE_COLOR;
				avatarBg.alpha = 0.6;
			}
			else 
			{
				avatarBg.color = noAvatarBgColor;
				avatarBg.alpha = 0.6;
			}
			
			blockShowAvatar = false;	
			
			if (!isLoaded) 
				return;
			
			//trace(' > ', index, "avatarBg.visible = false", winnerData.player.firstName);	
				
			avatarBg.visible = false;	
			avatarImage.visible = true;
			
			var avatarShiftX:Number = (AVATAR_WIDTH * pxScale - avatarImage.width) / 2;
			var avatarShiftY:Number = (AVATAR_HEIGHT*pxScale - avatarImage.height)/2;
			
			avatarImage.x = 2 * pxScale + avatarShiftX;
			avatarImage.y = 2 * pxScale + avatarShiftY;
				
			//avatarImage.color = 0xFFFFFF;
				
			var mask:Image = new Image(AtlasAsset.CommonAtlas.getTexture("winners_pane/avatar_mask"));
			mask.style = new TextureMaskStyle();
			avatarImage.mask = mask;
			
			mask.x = -avatarShiftX;
			mask.y = -avatarShiftY;
			//avatarImage.alpha = 1;
			
			catIcon.visible = false;

		}
		
		private function get containerX():Number 
		{
			sosTrace( "WinnerPlate.containerX", (_winnerData && _winnerData.player) ? _winnerData.player.firstName : 'no name', layoutHelper.isIPhoneXOrientationLeft, layoutHelper.isIPhoneX, PlatformServices.interceptor.deviceOrientation, SOSLog.DEBUG);
			
			var shiftX:Number = layoutHelper.isIPhoneXOrientationLeft ? 36 : 0;
			return ((isTabletLayout ? 51 : 32) + shiftX) * pxScale;
		}
		
		private function get crownX():Number 
		{
			return containerX + 82 * pxScale;
		}	
		
		public function destroy():void 
		{
			Game.removeEventListener(Game.ACTIVATED, handler_gameActivated);
			
			reset();
			
			if (avatarImage) {
				avatarImage.removeEventListener(flash.events.Event.COMPLETE, handler_avatarLoaded);
				avatarImage.removeEventListener(IOErrorEvent.IO_ERROR, handler_avatarLoaded);
				avatarImage.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handler_avatarLoaded);
			}
		}
		
		public function deviceOrientationChanged():void
		{
			sosTrace( "WinnerPlate.deviceOrientationChanged", (_winnerData && _winnerData.player) ? _winnerData.player.firstName : 'no name', layoutHelper.isIPhoneXOrientationLeft, layoutHelper.isIPhoneX, PlatformServices.interceptor.deviceOrientation, SOSLog.DEBUG);
			resize(0.2);
		}
		
		private function removeDelayedShowNextWinner():void 
		{
			if (delayedShowNextWinnerId > 0) {
				Starling.juggler.removeByID(delayedShowNextWinnerId);
				delayedShowNextWinnerId = 0;
			}
		}
		
		private function handler_gameActivated(e:*):void 
		{
			Game.removeEventListener(Game.ACTIVATED, handler_gameActivated);
			commitData();
		}	
		
		override public function dispose():void 
		{
			if(Game.current)
				Game.removeEventListener(Game.ACTIVATED, handler_gameActivated);
		}
		
	}

}