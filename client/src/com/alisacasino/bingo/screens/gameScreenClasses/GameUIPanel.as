package com.alisacasino.bingo.screens.gameScreenClasses
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.controls.BallsBar;
	import com.alisacasino.bingo.screens.gameScreenClasses.InfoDisplay;
	import com.alisacasino.bingo.controls.Minimap;
	import com.alisacasino.bingo.controls.NumbersTable;
	import com.alisacasino.bingo.screens.gameScreenClasses.PowerupDisplay;
	import com.alisacasino.bingo.screens.gameScreenClasses.WinnersPane;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.PlayerBingoedMessage;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameUIPanel extends FeathersControl
	{
		static public const STATE_GAME:String = "STATE_GAME";
		static public const STATE_TO_RESULTS:String = "STATE_TO_RESULTS";
		static public const STATE_TO_LOBBY:String = "STATE_TO_LOBBY";
		
		private var _state:String;
		private var _previousState:String; 
		
		private var player:Player = Player.current;
		public var gameUI:GameUI;
		private var _leftUIsWidth:Number = 0;
		private var _rightUIsWidth:Number = 0;
	
		private var menuButton:XButton;
		
		public var cardScrollButton:XButton;
		
		private var isTabletLayout:Boolean;
		
		public function GameUIPanel(gameUI:GameUI, startState:String = null)
		{
			this.gameUI = gameUI;
			_state = startState;
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
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
			
			isTabletLayout = gameManager.layoutHelper.isLargeScreen;
			
			
			menuButton = new XButton(XButtonStyle.LobbyMenuButtonStyle);
			menuButton.width = 105 * layoutHelper.specialScale;
			menuButton.height = 90 * layoutHelper.specialScale;
			var menuButtonQuad:Quad = new Quad(135, 160, 0xFF0000);
			menuButtonQuad.alpha = 0.0;
			menuButtonQuad.y = -50 * pxScale;
			menuButton.x = -menuButton.width;
			menuButton.addChild(menuButtonQuad);
			menuButton.addEventListener(Event.TRIGGERED, menuButton_triggeredHandler);
			addChild(menuButton);
	
			
			cardScrollButton = new XButton(XButtonStyle.BlueButtonStyleNew);
			cardScrollButton.scale9Grid = new Rectangle(13 , 13, 2, 2)
			cardScrollButton.width = 80*layoutHelper.specialScale;
			cardScrollButton.useHandCursor = true;
			cardScrollButton.text = 'SPY';
			cardScrollButton.alignPivot();
			cardScrollButton.addEventListener(Event.TRIGGERED, cardScrollButton_triggeredHandler);
			//cardScrollButton.defaultSkin = new Image(AtlasAsset.CommonAtlas.getTexture("game/card_scroll_button"));
			addChild(cardScrollButton);
			
		
			
			resize();
			moveHideUI(Room.current.numbers.length > 0);
			
			if(layoutHelper.isIPhoneX || Constants.isDevFeaturesEnabled)
				Game.addEventListener(Game.EVENT_ORIENTATION_CHANGED, handler_deviceOrientationChanged);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE)) {
				resize();
			}
			
			if (isInvalid(INVALIDATION_FLAG_STATE))
			{
				if (state == null)
				{
					//tweensToGame();
				}
				else if (state == STATE_GAME)
				{
					reset(true);
					
					moveHideUI(true);
					
					tweensAppear();
				}
				else if (state == STATE_TO_RESULTS)
				{
					reset();
					tweensDisappear();
				}
			}
		}	
		
		private function tweensAppear():void
		{
			alpha = 1;
			
			var delayBase:Number = 0.8;
			var baseDuration:Number = 0.2;
			
			Starling.juggler.tween(menuButton, baseDuration, { delay: delayBase + 0.2, x: menuButtonX, transition: Transitions.EASE_OUT } );
			Starling.juggler.tween(cardScrollButton, baseDuration, { delay: delayBase + 0.3, "x#": getCardScrollButtonX(), transition: Transitions.EASE_OUT_BACK } );
		}
		
		private function tweensDisappear():void
		{
			Starling.juggler.tween(this, 0.05, {"alpha":0, transition:Transitions.LINEAR, onComplete:completeDisappear});
		}
		
		private function completeDisappear():void
		{
			gameUI.removeChild(this);
		}
		
		private function moveHideUI(hideBallsBarThroughY:Boolean):void
		{
			var gap:int = 10 * gameUILayoutScale;
			
			menuButton.x = -menuButton.width - gap;
			
			cardScrollButton.x = width + gap + cardScrollButton.pivotX;
		}
		
		
		
		private function menuButton_triggeredHandler(e:Event):void
		{
			Game.current.gameScreen.showSideMenu();
		}
		
		
		private function cardScrollButton_triggeredHandler(e:Event):void 
		{
			gameUI.enemyRolesShowed = !gameUI.enemyRolesShowed;
			gameUI.showEnemyRoles();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		public function addBall(number:uint, animate:Boolean = true):void
		{
			
		}
		
		public function roundOverHandle():void
		{
			
		}
		
		public function addWinner(message:PlayerBingoedMessage, animate:Boolean = true):void
		{
			
		}
		
		public function advancePowerup():void
		{
			
		}
		
		private function resize():void
		{
			isTabletLayout = gameManager.layoutHelper.isLargeScreen;
			//trace('GameUIPanel isTabletLayout', isTabletLayout );	
			
			sosTrace( "GameUIPanel.resize", layoutHelper.isIPhoneXOrientationLeft, layoutHelper.isIPhoneX, PlatformServices.interceptor.deviceOrientation, SOSLog.DEBUG);
			
			if (alpha == 0 || !parent)
				return;
			
			//if (animating)
				//return;
				
			sosTrace( "GameUIPanel.resize continue", SOSLog.DEBUG);	
			
	
			menuButton.y = 11* layoutHelper.specialScale
			
			cardScrollButton.scale = gameManager.layoutHelper.independentScaleFromEtalonMin;
				//cardScrollButton.validate();
			cardScrollButton.x = getCardScrollButtonX();
			cardScrollButton.y = cardScrollButton.pivotY + 10 * layoutHelper.specialScale;
		}
		
		public function jumpUI(maxScale:Number = 1.05):void
		{
			var tweenBackward:Tween = new Tween(this, 0.23, Transitions.EASE_OUT_BACK);
			var tweenForward:Tween = new Tween(this, 0.04, Transitions.EASE_IN);
			
			tweenForward.animate('scale', 1.05);
			tweenForward.animate('x', (width - width * maxScale)/2);
			tweenForward.animate('y', (height - height * maxScale) / 2);
			tweenForward.nextTween = tweenBackward;
			
			tweenBackward.animate('scale', 1);
			tweenBackward.animate('x', 0);
			tweenBackward.animate('y', 0);
			
			Starling.juggler.add(tweenForward);
		}
		
		
		private function reset(isStartGame:Boolean = false):void
		{
			
		}
		
		public function set scrollButtonEnabled(value:Boolean):void
		{
			
		}
		
		public function setCardScrollButtonStyle(toBottom:Boolean):void 
		{
			
		}
		
		public function alignCardScrollButton():void 
		{
			
		}
		
		public function enableControls():void 
		{
			
		}
		
		public function addWinnerHistory():void 
		{
			
		}
		
		private function getCardScrollButtonX():Number
		{
			return width - 45 * layoutHelper.specialScale//cardScrollButton.width + cardScrollButton.pivotX - 10 * layoutHelper.independentScaleFromEtalonMin;
		}
		
		override public function dispose():void
		{
			if(Game.current && (layoutHelper.isIPhoneX || Constants.isDevFeaturesEnabled))
				Game.removeEventListener(Game.EVENT_ORIENTATION_CHANGED, handler_deviceOrientationChanged);
				
			super.dispose();
		}
		
		private function handler_deviceOrientationChanged(event:Event):void
		{
		
			Starling.juggler.removeTweens(menuButton);
		
		}
	
		
		private function get menuButtonX():Number
		{
			return -40 * pxScale;
		}
		
	}
}