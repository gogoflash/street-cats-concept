package com.alisacasino.bingo.screens.lobbyScreenClasses
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.components.AwardImageAssetContainer;
	import com.alisacasino.bingo.components.FadeQuad;
	import com.alisacasino.bingo.controls.CashBar;
	import com.alisacasino.bingo.controls.FullscreenButton;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.controls.XpBar;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.TutorialManager;
	import com.alisacasino.bingo.models.cats.CatModel;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.gameScreenClasses.CatView;
	import com.alisacasino.bingo.screens.gameScreenClasses.ConnectionProblemIndicator;
	import com.alisacasino.bingo.screens.gameScreenClasses.GameUI;
	import com.alisacasino.bingo.screens.profileScreenClasses.ProfileScreen;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.UIUtils;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAUIInteractionEvent;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextFormat;
	import starling.utils.TweenHelper;
	
	
	public class LobbyUI extends FeathersControl
	{
		static public const STATE_FIRST_START:String = "STATE_FIRST_START";
		static public const STATE_INIT:String = "stateInit";
		static public const STATE_LOBBY:String = "stateLobby";
		static public const STATE_TO_GAME:String = "stateToGame";
	
		
		static public const EVENT_FIRST_START_COMPLETE:String = "firstStartComplete";
	
		private const UI_BUTTONS_WIDTH:int = 218;
		private const UI_BUTTONS_TABLET_WIDTH:int = 270;
		
		private var _state:String = STATE_INIT;
		private var _previousState:String; 
		private var skipResize:Boolean;
		
		public var gameScreen:GameScreen;
		
		private var menuButtonTouchQuad:Quad;
		private var menuButton:LobbyMenuButton
		
		public var xpBar:XpBar;
		public var cashBar:CashBar;
	
		public var collectionsButton:LobbyCollectionButton;
		public var tourneyButton:XButton;
		public var rightButton:XButton;
		public var pvpButton:XButton;

		private var hideCallback:Function;
		
	
		public var connectionProblemIndicator:ConnectionProblemIndicator;
		
		
		public var playerCatsViews:Array = [];
	
		private var catViewsContainer:Sprite;
		
		public function LobbyUI(gameScreen:GameScreen, startState:String, hideCallback:Function)
		{
			this.gameScreen = gameScreen;
			_state = startState;
			this.hideCallback = hideCallback;
			
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			sosTrace("LobbyUI set state ", value, ' old state: ', _state);
			
			if (_state != value)
			{
				_previousState = _state;
				
				_state = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			xpBar = new XpBar(true, onXpBarTriggered);
			xpBar.visible = false;
			addChild(xpBar);
			
			menuButton = new LobbyMenuButton(XButtonStyle.LobbyMenuButtonStyle);
			menuButtonTouchQuad = new Quad(130*pxScale, 160*pxScale, 0xFF0000);
			//menuButtonQuad.visible = false;
			menuButtonTouchQuad.alpha = 0;
			menuButtonTouchQuad.y = -50 * pxScale;
			menuButton.addChild(menuButtonTouchQuad);
			menuButton.addEventListener(Event.TRIGGERED, handler_menuClick);
			menuButton.visible = false;
			addChild(menuButton);
			
			cashBar = new CashBar(false, onCashBarTriggered);
			cashBar.visible = false;
			addChild(cashBar);
			
			collectionsButton = new LobbyCollectionButton(XButtonStyle.BlueButtonStyleNew);
			collectionsButton.addEventListener(Event.TRIGGERED, handler_collectionsClick);
			collectionsButton.scale9Grid =new Rectangle(13 , 13, 2, 2)
			//collectionsButton.width = 250 * pxScale;
			collectionsButton.text = 'HEAL CATS';
			collectionsButton.visible = false;
			
			addChild(collectionsButton);
			
			tourneyButton = new XButton(XButtonStyle.BlueButtonStyleNew);
			tourneyButton.scale9Grid = new Rectangle(13 , 13, 2, 2)
			tourneyButton.text = 'PVE 12 FOOD';
			tourneyButton.visible = false;
			tourneyButton.addEventListener(Event.TRIGGERED, tourneyButton_triggeredHandler);
			addChild(tourneyButton);
			
			rightButton = new XButton(XButtonStyle.BlueButtonStyleNew);
			rightButton.scale9Grid = new Rectangle(13 , 13, 2, 2)
			rightButton.text = 'PVE 4 FOOD';
			//rightButton.visible = false;
			rightButton.addEventListener(Event.TRIGGERED, rightButton_triggeredHandler);
			addChild(rightButton);
			
			pvpButton = new XButton(XButtonStyle.BlueButtonStyleNew);
			pvpButton.scale9Grid = new Rectangle(13 , 13, 2, 2)
			pvpButton.text = 'PVP WAIT FOR PLAYER';
			pvpButton.addEventListener(Event.TRIGGERED, pvpButton_triggeredHandler);
			addChild(pvpButton);
			
			connectionProblemIndicator = new ConnectionProblemIndicator();
			addChild(connectionProblemIndicator);
			
			if(layoutHelper.isIPhoneX || Constants.isDevFeaturesEnabled)
				Game.addEventListener(Game.EVENT_ORIENTATION_CHANGED, handler_deviceOrientationChanged);
				
			
			catViewsContainer = new Sprite();
			addChild(catViewsContainer);
				
			var i:int;
			for (i = 0; i < gameManager.playerCats.length; i++) {
				var catView:CatView = new CatView();
				catView.isLeft = true;
				catView.cat = gameManager.playerCats[i];
				catView.refreshHP();
				
				playerCatsViews.push(catView);
				playerCatsViews[i].x = -layoutHelper.stageWidth / 2 - 100;
				catViewsContainer.addChild(playerCatsViews[i]);
			}
			
			showReadyForPvP();
		}
		
		
		
		override protected function draw():void 
		{
			super.draw();
		
			if (isInvalid(INVALIDATION_FLAG_STATE))
			{
				if (state == STATE_FIRST_START)
				{
					resize();
					
					_previousState = STATE_LOBBY;	
					_state = STATE_LOBBY;	
					
					viewsVisible = true;
					
					skipResize = true;
					
					tweenFromFirstStartToLobby(0.9, Transitions.EASE_OUT_BACK, 0.9, 0.5);
				}
				else if (state == STATE_INIT)
				{
					
					_previousState = STATE_LOBBY;	
					_state = STATE_LOBBY;	
				
					viewsVisible = true;
					
					
					var i:int;
					var shiftX:int = -((CatView.WIDTH*pxScale + 50*pxScale) * gameManager.playerCats.length - 50)/2 + CatView.WIDTH/2;
					for (i = 0; i < catViewsContainer.numChildren; i++) 
					{
						Starling.juggler.tween(catViewsContainer.getChildAt(i), 0.3, {delay:(i*0.1) + 0.1, transition:Transitions.EASE_OUT, x:(shiftX + i*(CatView.WIDTH*pxScale + 50*pxScale))});
					}
					
				}
				else if (state == STATE_LOBBY)
				{
					
					tweenJumpUI(12);
					
				}
				else if (state == STATE_TO_GAME)
				{
					
					tweensToGame();
					
					Game.current.gameScreen.closeSideMenu();
				}
				
			}
			
			if (isInvalid(INVALIDATION_FLAG_SIZE)) {
				if (skipResize) {
					skipResize = false;
					return;
				}
				
				resize();	
			}
		}	
		
		private function set viewsVisible(value:Boolean):void
		{
			menuButton.visible = value;
			//xpBar.visible = value;
			cashBar.visible = value;
			collectionsButton.visible = value;
			tourneyButton.visible = value;
			rightButton.visible = value;
			pvpButton.visible = value;
		}
		
		private function tweenFromGameToBuyCards():void
		{
			moveUI( -140);
			
			var startAlpha:Number = 0.2;
			
			xpBar.alpha = startAlpha;
		
			collectionsButton.alpha = startAlpha;
			tourneyButton.alpha = startAlpha;
			
			var complexScale:Number = layoutHelper.independentScaleFromEtalonMin * pxScale;
			var collectionsButtonY:Number = layoutHelper.stageHeight - collectionsButton.height - 20 * complexScale;
			
			var appearTime:Number = 0.35//0.28;
			Starling.juggler.tween(xpBar, appearTime, {transition:Transitions.EASE_OUT, alpha:1, x:xpBarX, y:13*complexScale});
			Starling.juggler.tween(collectionsButton, appearTime, {transition:Transitions.EASE_OUT, alpha:1, x:(17*complexScale + uiCornersShiftX), y:collectionsButtonY});
			Starling.juggler.tween(tourneyButton, appearTime, {transition:Transitions.EASE_OUT, alpha:1, x:(layoutHelper.stageWidth - tourneyButton.width - 17 * complexScale - uiCornersShiftX), y:collectionsButtonY});
			
			menuButton.x = -menuButton.width + menuButtonX * menuButton.scale;
			Starling.juggler.tween(menuButton, 0.23, {transition:Transitions.EASE_OUT, delay:appearTime, x: menuButtonX * menuButton.scale});
		}	
		
		private function tweenFromFirstStartToLobby(delay:Number = 0, transition:String = 'easeOut', uiAppearTime:Number = 0.35, logoAndBonusTweenTime:Number = 0.5):void
		{
			moveUI( -140);
			
			var startAlpha:Number = 0.2;
			
			xpBar.alpha = startAlpha;
			collectionsButton.alpha = startAlpha;
			tourneyButton.alpha = startAlpha;
			
			var complexScale:Number = layoutHelper.independentScaleFromEtalonMin * pxScale;
			
			Starling.juggler.tween(xpBar, uiAppearTime, {delay:delay, transition:transition, alpha:1, x:xpBarX, y:13*complexScale});
			Starling.juggler.tween(collectionsButton, uiAppearTime, {delay:delay, transition:transition, alpha:1, x:(17*complexScale + uiCornersShiftX), y:collectionsButtonY});
			Starling.juggler.tween(tourneyButton, uiAppearTime, {delay:delay, transition:transition, alpha:1, x:(layoutHelper.stageWidth - tourneyButton.width - 17 * complexScale - uiCornersShiftX), y:collectionsButtonY});
			
			menuButton.x = -menuButton.width + menuButtonX * menuButton.scale;
			Starling.juggler.tween(menuButton, 0.23, {transition:transition, delay:(delay + uiAppearTime), x: menuButtonX * menuButton.scale});
			
			
			var i:int;
			var shiftX:int = -((CatView.WIDTH*pxScale + 50*pxScale) * gameManager.playerCats.length - 50)/2 + CatView.WIDTH/2;
			for (i = 0; i < catViewsContainer.numChildren; i++) 
			{
				Starling.juggler.tween(catViewsContainer.getChildAt(i), uiAppearTime, {delay:(i*0.1) + delay, transition:transition, x:(shiftX + i*(CatView.WIDTH*pxScale + 50*pxScale))});
			}
		}	
		
		private function tweensToGame():void
		{
			tweenMoveHideUI(-220, 0.2);
				
			var i:int;
			var shiftX:int = -((CatView.WIDTH*pxScale + 50*pxScale) * gameManager.playerCats.length - 50)/2;
			for (i = 0; i < catViewsContainer.numChildren; i++) 
			{
				Starling.juggler.tween(catViewsContainer.getChildAt(catViewsContainer.numChildren - i - 1), 0.3, {delay:(i*0.05), transition:Transitions.EASE_OUT, x:(layoutHelper.stageWidth/2 + CatView.WIDTH/2 + 80)});
			}
			
			if (hideCallback != null)	
				Starling.juggler.delayCall(hideCallback, 0.8);
		}
		
		private function tweenJumpUI(distance:int = 20):void
		{
			jumpFromScreenCenter(xpBar, distance);
			jumpFromScreenCenter(tourneyButton, distance);
			jumpFromScreenCenter(collectionsButton, distance);
		}	
		
		private function tweenMoveHideUI(distance:int = 20, delay:Number = 0):void
		{
			tweenFromScreenCenter(xpBar, distance, delay);
			tweenFromScreenCenter(tourneyButton, distance, delay);
			tweenFromScreenCenter(collectionsButton, distance, delay);
		}	
		
		private function jumpFromScreenCenter(displayObject:DisplayObject, tweenDistance:int):void
		{
			var newPosition:Point = getTweenFromCenterPosition(displayObject, tweenDistance);
			
			var tweenBackward:Tween = new Tween(displayObject, 0.3, Transitions.EASE_IN);
			var tweenForward:Tween = new Tween(displayObject, 0.25, Transitions.EASE_OUT);
			tweenForward.moveTo(newPosition.x - displayObject.width / 2, newPosition.y - displayObject.height / 2);
			tweenBackward.moveTo(displayObject.x, displayObject.y);
			tweenForward.nextTween = tweenBackward;
			Starling.juggler.add(tweenForward);
		}	
		
		private function tweenFromScreenCenter(displayObject:DisplayObject, tweenDistance:int, delay:Number):void
		{
			var newPosition:Point = getTweenFromCenterPosition(displayObject, tweenDistance);
			Starling.juggler.tween(displayObject, 0.35, {x:(newPosition.x - displayObject.width / 2), y:(newPosition.y - displayObject.height / 2), delay:delay, transition:Transitions.EASE_IN_BACK});
		}	
		
		private function moveUI(distance:int = 20):void
		{
			moveFromCenter(xpBar, distance);
			moveFromCenter(tourneyButton, distance);
			moveFromCenter(collectionsButton, distance);
		}	
		
		private function moveFromCenter(displayObject:DisplayObject, tweenDistance:int):void
		{
			var newPosition:Point = getTweenFromCenterPosition(displayObject, tweenDistance);
			displayObject.x = newPosition.x - displayObject.width / 2;
			displayObject.y = newPosition.y - displayObject.height / 2;
		}	
		
		private function removeView(displayObject:DisplayObject):void
		{
			displayObject.removeFromParent();
			//displayObject.dispose();
		}
		
		
		public function get collectionsButtonY():Number {
			return layoutHelper.stageHeight - collectionsButton.height - 20 * layoutHelper.independentScaleFromEtalonMin * pxScale;
		}
		
		private function get isTabletLayout():Boolean {
			return (layoutHelper.stageWidth / layoutHelper.stageHeight) < 1.52;
		}
		
		private function resize():void
		{
			var globalUIScale:Number = layoutHelper.independentScaleFromEtalonMin;
			var complexScale:Number = globalUIScale * pxScale; 
			var useCanvasExtraScale:Boolean = layoutHelper.useCanvasExtraScale;
			
			xpBar.scale = globalUIScale;
			
			menuButton.scale = globalUIScale;
			
			menuButton.x = menuButtonX * globalUIScale;
			menuButton.y = 17 * complexScale;
			
			xpBar.x = xpBarX;
			xpBar.y = 13*complexScale;
		
		
			cashBar.x = cashBarX;
			cashBar.y = 36 * complexScale;
			cashBar.scale = globalUIScale;
			
			collectionsButton.scale = globalUIScale;
			collectionsButton.x = 17 * complexScale + uiCornersShiftX;
			collectionsButton.y = layoutHelper.stageHeight - collectionsButton.height - 20 * complexScale;
			collectionsButton.width = UI_BUTTONS_WIDTH * complexScale;
			
			tourneyButton.scale = globalUIScale;
			tourneyButton.y = collectionsButton.y;
			tourneyButton.width = UI_BUTTONS_WIDTH * complexScale;
			tourneyButton.x = layoutHelper.stageWidth - tourneyButton.width - 17 * complexScale - uiCornersShiftX;
			
			rightButton.scale = globalUIScale;
			rightButton.y = collectionsButton.y - 90*layoutHelper.specialScale;
			rightButton.width = UI_BUTTONS_WIDTH * complexScale;
			rightButton.x = layoutHelper.stageWidth - rightButton.width - 17 * complexScale - uiCornersShiftX;
			
			pvpButton.scale = globalUIScale;
			pvpButton.y = rightButton.y - 90*layoutHelper.specialScale;
			pvpButton.width = UI_BUTTONS_WIDTH * complexScale;
			pvpButton.x = layoutHelper.stageWidth - pvpButton.width - 17 * complexScale - uiCornersShiftX;
			
			connectionProblemIndicator.scale = globalUIScale;
			connectionProblemIndicator.x = layoutHelper.stageWidth / 2;
			connectionProblemIndicator.y = layoutHelper.stageHeight / 2;
			
			
			catViewsContainer.scale = globalUIScale;
			catViewsContainer.x = layoutHelper.stageWidth / 2;
			catViewsContainer.y = layoutHelper.stageHeight / 2;
			
			
			
		}
	
		private function get cashBarX():Number {
			return layoutHelper.stageWidth - 201 * gameUILayoutScale - uiCornersShiftX;
		}
		
		private function get xpBarX():Number {
			return 74*gameUILayoutScale + uiCornersShiftX + (layoutHelper.useCanvasExtraScale ? (layoutHelper.stageWidth * 0.1 * pxScale * (1 - layoutHelper.canvasExtraScale)) : 0);
		}
		
		private function get uiCornersShiftX():Number {
			return (layoutHelper.isIPhoneX ? 33 : 0) * gameUILayoutScale;
		}
		
		private function get cashBarShiftX():Number {
			return (layoutHelper.isIPhoneX ? 47 : 0) * gameUILayoutScale;
		}
		
		private function handler_collectionsClick(e:Event):void 
		{
			//gameManager.gameMode = GameManager.GAME_MODE_SIMPLE;
			//gameScreen.showGame(false);
			
			var i:int;
			var catView:CatView;
			for (i = 0; i < catViewsContainer.numChildren; i++) {
				catView = catViewsContainer.getChildAt(i) as CatView;
				catView.cat.health = 3;
				catView.refreshHP();
			}
		}
		
		
		private function handler_menuClick(e:Event = null):void
		{
			gameScreen.showSideMenu();
		}
		
		private function getTweenFromCenterPosition(displayObject:DisplayObject, moveDistance:int):Point
		{
			var objectCenterX:int = displayObject.x + displayObject.width / 2;
			var objectCenterY:int = displayObject.y + displayObject.height / 2;
			
			var screenCenterX:int = layoutHelper.stageWidth / 2;
			var screenCenterY:int = layoutHelper.stageHeight / 2;
			
			var distance:Number = Point.distance(new Point(objectCenterX, objectCenterY), new Point(screenCenterX, screenCenterY));
			var sin:Number = (screenCenterY - objectCenterY)/distance;
			var cos:Number = (objectCenterX - screenCenterX)/distance;
			
			var newDistance:Number = distance - moveDistance * pxScale;
			
			return new Point(screenCenterX + newDistance * cos, screenCenterY - newDistance * sin);
		}	
		
		private function onXpBarTriggered():void
		{
			
			if (!DialogsManager.instance.getDialogByClass(ProfileScreen))
				DialogsManager.addDialog(new ProfileScreen());
		}
		
		private function onCashBarTriggered():void
		{
			return;
			
			Player.current.reservedCashCount += 10;
			Player.current.updateCashCount(10, "debug");
			
			Game.connectionManager.sendPlayerUpdateMessage();	
			
			new UpdateLobbyBarsTrueValue(0.5).execute();
		}
		
		private function tourneyButton_triggeredHandler(e:Event):void 
		{
			GameUI.foodCount = 12;
			gameManager.gameMode = GameManager.GAME_MODE_GROUP;
			gameScreen.showGame(false);
			//DialogsManager.addDialog(new LeaderboardDialog());
		}
		
		private function rightButton_triggeredHandler(e:Event):void 
		{
			GameUI.foodCount = 4;
			gameManager.gameMode = GameManager.GAME_MODE_GROUP;
			gameScreen.showGame(false);
			//DialogsManager.addDialog(new LeaderboardDialog());
		}
		
		private function pvpButton_triggeredHandler(e:Event):void 
		{
			if (gameManager.pvpUserReady)
			{
				//gameManager.connectionManager.sendJoin();
				GameUI.foodCount = 4;
				gameManager.gameMode = GameManager.GAME_MODE_PVP;
				gameScreen.showGame(false);
				
				
				
				
			}
			else
			{
				gameManager.connectionManager.sendJoin();
				waitingForPvp = true;
				FadeQuad.show(this, 0.2, 0.6, true);
				showInfoLabel('WAIT FOR ENEMY...');
				
				
				
				if (!cancelButton)
				{
					cancelButton = new XButton(XButtonStyle.BlueButtonStyleNew);
					cancelButton.scale9Grid = new Rectangle(13 , 13, 2, 2)
					cancelButton.text = 'CANCEL';
					cancelButton.alignPivot();
					cancelButton.x = layoutHelper.stageWidth / 2;
					cancelButton.y = layoutHelper.stageHeight - cancelButton.height - 20;
					cancelButton.scale = layoutHelper.independentScaleFromEtalonMin;
					cancelButton.addEventListener(Event.TRIGGERED, cancelButton_triggeredHandler);
					addChild(cancelButton);
				}
			}
			
		/*	if(!gameManager.pvpUserReady)
				return;
				
			GameUI.foodCount = 4;
			gameManager.gameMode = GameManager.GAME_MODE_PVP;
			gameScreen.showGame(false);*/
		}
		
		private function cancelButton_triggeredHandler(e:Event):void 
		{
			gameManager.connectionManager.sendExit();
			hidePvPWaiting();
		}
		
		private function get menuButtonX():int {
			return (-38 + (layoutHelper.isIPhoneX ? 10 : 0)) * pxScale;
		}
		
	
		override public function dispose():void
		{
			if(Game.current && (layoutHelper.isIPhoneX || Constants.isDevFeaturesEnabled))
				Game.removeEventListener(Game.EVENT_ORIENTATION_CHANGED, handler_deviceOrientationChanged);
		
			
			
			super.dispose();
		}
		
		
		private function handler_deviceOrientationChanged(event:Event):void
		{
			if (state == STATE_TO_GAME)
				return;
		}
		
		public var waitingForPvp:Boolean;
		
		public function showReadyForPvP():void
		{
			if (waitingForPvp || FadeQuad.quad)
			{
				hidePvPWaiting();
				
				GameUI.foodCount = 4;
				gameManager.gameMode = GameManager.GAME_MODE_PVP;
				gameScreen.showGame(false);
				
			}
			else
			{
				
			}
			
			waitingForPvp = false;
			
			if(gameManager.pvpUserReady)
				pvpButton.text = 'PVP READY! ID:' + gameManager.connectionManager.gameId.toString();
			else
				pvpButton.text = 'PVP REQUEST';
		}
		
		public function hidePvPWaiting():void
		{
			FadeQuad.hide();
			showInfoLabel(null);
			waitingForPvp = false;
			
			if (cancelButton)
			{
				cancelButton.removeFromParent();
				cancelButton = null;
			}	
		}
		
		private var roundInfoLabel:XTextField;
		public var cancelButton:XButton;
		
		public function showInfoLabel(text:String):void
		{
			if (text)
			{
				if (!roundInfoLabel)
				{
					roundInfoLabel= new XTextField(480*pxScale, 390*pxScale, XTextFieldStyle.houseHolidaySans(70, 0xFFFFFF).setStroke(1), '');
					roundInfoLabel.touchable = false;
					//roundInfoLabel.x = - 50;
					//roundInfoLabel.y = layoutHelper.stageHeight / 2;
					roundInfoLabel.alignPivot();
				}
				
				roundInfoLabel.x = layoutHelper.stageWidth / 2;
				roundInfoLabel.y = layoutHelper.stageHeight / 2;
				roundInfoLabel.scale = 0;
				roundInfoLabel.text = text;
				addChild(roundInfoLabel);
				
				TweenHelper.tween(roundInfoLabel, 0.5, {delay:0.05, transition:Transitions.EASE_OUT_BACK, scale:layoutHelper.independentScaleFromEtalonMin})	
				
			}
			else
			{
				if (roundInfoLabel)
				{
					roundInfoLabel.removeFromParent();
					roundInfoLabel = null;
				}
			}
			
		}
		
	}
}