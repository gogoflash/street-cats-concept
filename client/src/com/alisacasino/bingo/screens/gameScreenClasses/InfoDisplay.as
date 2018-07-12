package com.alisacasino.bingo.screens.gameScreenClasses
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.GameManager;
	import feathers.core.FeathersControl;
	import flash.geom.Rectangle;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.DropShadowFilter;
	
	import starling.display.Image;
	import starling.events.Event;
	
	public class InfoDisplay extends FeathersControl
	{
		public static var DEBUG_TAKE_ANYTHING_BY_CLICK:Boolean = false;
		
		private var storedRoundId:String;
		
		private var background:Image;
		private var numBingosLeftLabel:XTextField;
		private var bingosLeftLabel:XTextField;
		private var activePlayersLabel:XTextField;
		private var activeCardsLabel:XTextField;
		private var separatorLine:Quad;
		private var activePlayersImage:Image;
		private var activeCardsImage:Image
		
		private var isTabletLayout:Boolean;
		
		public function InfoDisplay()
		{
			addEventListener(TouchEvent.TOUCH, onTouch);	
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			isTabletLayout = gameManager.layoutHelper.isLargeScreen;
			
			background = new Image(AtlasAsset.CommonAtlas.getTexture("game/blue_alpha_bg"));
			background.scale9Grid = new Rectangle(25 * pxScale, 22 * pxScale, 10 * pxScale, 6 * pxScale);
			addChild(background);
			
			numBingosLeftLabel = new XTextField(90*pxScale, 78*pxScale, XTextFieldStyle.BingosLeftNumberTextFieldStyleTablet);
			numBingosLeftLabel.autoScale = true;
			//numBingosLeftLabel.border = true;
			addChild(numBingosLeftLabel);
			
			bingosLeftLabel = new XTextField(90*pxScale, 38*pxScale, XTextFieldStyle.WalrusWhiteCenter40);
			bingosLeftLabel.autoScale = true;
			//bingosLeftLabel.border = true;
			addChild(bingosLeftLabel);
			
			separatorLine = new Quad(2*pxScale, 2*pxScale);
			addChild(separatorLine);
			
			activePlayersImage = new Image(AtlasAsset.CommonAtlas.getTexture("game/players_icon"));
			addChild(activePlayersImage);
			
			activePlayersLabel = new XTextField(68*pxScale, 38*pxScale, XTextFieldStyle.WalrusWhiteCenter40);
			activePlayersLabel.autoScale = true;
			//activePlayersLabel.border = true;
			addChild(activePlayersLabel);
			
			activeCardsImage = new Image(AtlasAsset.CommonAtlas.getTexture("game/cards_icon"));
			addChild(activeCardsImage);
			
			activeCardsLabel = new XTextField(64*pxScale, 38*pxScale, XTextFieldStyle.WalrusWhiteCenter40);
			activeCardsLabel.autoScale = true;
			//activeCardsLabel.border = true;
			addChild(activeCardsLabel);
			
			resize(true);
			
			if (gameManager.deactivated) 
				Game.addEventListener(Game.ACTIVATED, game_activatedHandler);
			else 
				bingosLeftLabel.text = "BINGOS";
		}
		
		private function game_activatedHandler(e:Event):void
		{
			Game.removeEventListener(Game.ACTIVATED, game_activatedHandler);
			bingosLeftLabel.text = "BINGOS";
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			update();
		}
		
		private function handler_roundOver(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			Game.removeEventListener(ConnectionManager.ROUND_OVER_EVENT, handler_roundOver);
			update();
		}
		
		override protected function draw():void
		{
			super.draw();
		}
		
		public function reset(isStartGame:Boolean):void
		{
			if (isStartGame)
			{
				storedRoundId = Room.current.roundID;
				
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				Game.addEventListener(ConnectionManager.ROUND_OVER_EVENT, handler_roundOver);
				
				update();
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				Game.removeEventListener(ConnectionManager.ROUND_OVER_EVENT, handler_roundOver);
			}
		}
		
		public function update():void
		{
			if (gameManager.deactivated)	
				return;
			
			if (!gameManager.tutorialManager.tutorialFirstLevelPassed || !gameManager.tutorialManager.tutorialLevelsPassed) {
				numBingosLeftLabel.text = gameManager.tutorialManager.tutorLevelBingosLeft.toString();
				activePlayersLabel.text = gameManager.tutorialManager.tutorLevelPlayersCount.toString();
				activeCardsLabel.text = gameManager.tutorialManager.tutorLevelCardsCount.toString();
			}
			
			var room:Room = Room.current;
			if (!room || !numBingosLeftLabel || storedRoundId != room.roundID)
				return;
				
			if (Player.current.isActivePlayer) 
			{
				numBingosLeftLabel.text = room.bingosLeft.toString();
				activePlayersLabel.text = room.playersCount.toString();
				activeCardsLabel.text = room.roundCardsCount.toString();
			}
		}
		
		public function resize(forceResize:Boolean = false):void
		{
			if (isTabletLayout == gameManager.layoutHelper.isLargeScreen && !forceResize)
				return;
				
			isTabletLayout = gameManager.layoutHelper.isLargeScreen;
			
			if (isTabletLayout)
			{
				background.width = 232 * pxScale;
				background.height = 135 * pxScale;
				
				numBingosLeftLabel.x = 16 * pxScale;
				numBingosLeftLabel.y = 11 * pxScale;
				
				bingosLeftLabel.x = 15 * pxScale;
				bingosLeftLabel.y = 71 * pxScale;
				
				separatorLine.width = 2 * pxScale;
				separatorLine.height = 92 * pxScale;
				separatorLine.x = 113 * pxScale;
				separatorLine.y = 17 * pxScale;
				
				activePlayersImage.x = 127 * pxScale;
				activePlayersImage.y = 27* pxScale;
				
				activePlayersLabel.x = 152 * pxScale;
				activePlayersLabel.y = 27 * pxScale;
				
				activeCardsImage.x = 126 * pxScale;
				activeCardsImage.y = 75 * pxScale;
				
				activeCardsLabel.x = 155 * pxScale;
				activeCardsLabel.y = 69 * pxScale;
			}
			else
			{
				background.width = 133 * pxScale;
				background.height = 224 * pxScale;
				
				numBingosLeftLabel.x = (background.width - numBingosLeftLabel.width) / 2 - 2*pxScale;
				numBingosLeftLabel.y = 6 * pxScale;
				
				bingosLeftLabel.x = (background.width - bingosLeftLabel.width) / 2;
				bingosLeftLabel.y = 66 * pxScale;
				
				separatorLine.width = 90 * pxScale;
				separatorLine.height = 2 * pxScale;
				separatorLine.x = (background.width - separatorLine.width) / 2;
				separatorLine.y = 110 * pxScale;
				
				activePlayersImage.x = 23 * pxScale;
				activePlayersImage.y = 124 * pxScale;
				
				activePlayersLabel.x = 50 * pxScale;
				activePlayersLabel.y = 126 * pxScale;
				
				activeCardsImage.x = 23 * pxScale;
				activeCardsImage.y = 171 * pxScale;
				
				activeCardsLabel.x = 50 * pxScale;
				activeCardsLabel.y = 167 * pxScale;
			}
			
			setSizeInternal(background.width, background.height, false);
		}	
		
		public function get originalHeight():Number
		{
			return background.height;
		}
		
		override public function dispose():void {
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			Game.removeEventListener(ConnectionManager.ROUND_OVER_EVENT, handler_roundOver);
			super.dispose();
		}
		
		private function onTouch(event:TouchEvent):void
		{
			if (!DEBUG_TAKE_ANYTHING_BY_CLICK)
				return;
				
			event.stopImmediatePropagation();
		
			var touch:Touch = event.getTouch(this);
			if (touch == null)
				return;
	
			if (touch.phase == TouchPhase.BEGAN) 
			{
				Game.current.gameScreen.gameUI.debugAddPowerUpToCards(Powerup.debugGetRandom());	
			}
		}
	}
}