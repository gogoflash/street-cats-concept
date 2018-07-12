package com.alisacasino.bingo.screens.gameScreenClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.components.FadeQuad;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.controls.BingoAnimation;
	import com.alisacasino.bingo.controls.GameCard;
	import com.alisacasino.bingo.controls.ReadyGo;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Card;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.TutorialManager;
	import com.alisacasino.bingo.models.cats.CatModel;
	import com.alisacasino.bingo.models.cats.CatRole;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.protocol.PlayerBingoedMessage;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.utils.DelayCallUtils;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.JumpWithHintHelper;
	import com.alisacasino.bingo.utils.caurina.transitions.properties.DisplayShortcuts;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class GameUI extends FeathersControl
	{
		private var gameScreen:GameScreen;
		private var innerQuad:Quad;
		private var outerQuad:Quad;
		public var gameCardsView:GameCardsViewNew;
		public var gameUIPanel:GameUIPanel;
		public var topLayer:Sprite;
		
		
		private var startButton:XButton;
		
		private const DELAY_CALL_GAME_UI_BUNDLE:String = 'DELAY_CALL_GAME_UI_BUNDLE';
		static public const READY_GO_COMPLETE:String = "readyGoComplete";
		
		private var playerCatViewsContainer:Sprite;
		private var enemyCatViewsContainer:Sprite;
		private var foodViewsContainer:Sprite;
		
		public var playerCatsViews:Array = [];
		public var enemyCatsViews:Array = [];
		
		public static var foodCount:int;
		
		private var charV:XTextField;
		private var charS:XTextField;
		
		private var roundInfoLabel:XTextField;
		
		private var foodTaken:Boolean;
		
		private var enemyStepPriority:Boolean;
		
		private var particleEffect:ParticleExplosion;
		
		public function GameUI(gameScreen:GameScreen) 
		{
			this.gameScreen = gameScreen;
			outerQuad = new Quad(1, 1, 0xFF0000);

			innerQuad = new Quad(1, 1, 0xffffff);
			
			topLayer = new Sprite();
			topLayer.touchable = false;
			
			
		}
		
		
		override protected function initialize():void 
		{
			super.initialize();
			
			gameUIPanel = new GameUIPanel(this);
			gameUIPanel.setSize(width, height);
			//gameUIPanel.visible = false;
			addChild(gameUIPanel);
			
			
			
			enemyCatViewsContainer = new Sprite();
			addChild(enemyCatViewsContainer);
			
			foodViewsContainer = new Sprite();
			addChild(foodViewsContainer)
			
			charV = new XTextField(130*pxScale, 190*pxScale, XTextFieldStyle.houseHolidaySans(170, 0xE11700).setStroke(4), 'V');
			charV.touchable = false;
			charV.helperFormat.nativeTextExtraHeight = 22;
			charV.helperFormat.nativeTextExtraWidth = 32;
			charV.x = - 50;
			charV.y = layoutHelper.stageHeight / 2;
			charV.alignPivot();
			addChild(charV);
			
			
			charS = new XTextField(130*pxScale, 190*pxScale, XTextFieldStyle.houseHolidaySans(170, 0xE11700).setStroke(4), 'S');
			charS.touchable = false;
			charS.helperFormat.nativeTextExtraHeight = 22;
			charS.helperFormat.nativeTextExtraWidth = 32;
			charS.x = layoutHelper.stageWidth + 50;
			charS.y = layoutHelper.stageHeight / 2;
			charS.alignPivot();
			addChild(charS);
			
			playerCatViewsContainer = new Sprite();
			addChild(playerCatViewsContainer);
			
			startButton = new XButton(XButtonStyle.BlueButtonStyle);
			startButton.scale9Grid = new Rectangle(25 * pxScale, 0, 35 * pxScale, startButton.upState.height);
			startButton.text = 'START!';
			startButton.alignPivot();
			//startButton.visible = false;
			startButton.addEventListener(Event.TRIGGERED, startButton_triggeredHandler);
			addChild(startButton);
			
			addChild(topLayer);
			
			
			roundInfoLabel= new XTextField(480*pxScale, 390*pxScale, XTextFieldStyle.houseHolidaySans(50, 0xFFFFFF).setStroke(1), '');
			roundInfoLabel.touchable = false;
			roundInfoLabel.x = - 50;
			roundInfoLabel.y = layoutHelper.stageHeight / 2;
			roundInfoLabel.alignPivot();
			
			var colors:Vector.<uint> = new <uint>[0xFFFFFF];
			particleEffect = new ParticleExplosion(AtlasAsset.CommonAtlas, new <String>["effects/smoke_1", "effects/smoke_0"], colors);
			particleEffect.x = layoutHelper.stageWidth / 2;
			particleEffect.y = layoutHelper.stageHeight / 2;
			particleEffect.setProperties(0, 90 * pxScale, +0.01, 0.028, 0.01, 0, 0.7, true);
			particleEffect.setFineProperties(0.6, 0.0, 0.0, 0);
			//particleEffect.setAccelerationProperties(-0.02);
			particleEffect.lifetime = 500;
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			outerQuad.width = width;
			outerQuad.height = height;
			
			innerQuad.x = 2;
			innerQuad.y = 2;
			
			innerQuad.width = width - 4;
			innerQuad.height = height - 4;
			
			gameUIPanel.setSize(width, height);
			gameUIPanel.invalidate(INVALIDATION_FLAG_SIZE);
			
			enemyCatViewsContainer.scale = layoutHelper.independentScaleFromEtalonMin * 0.85;
			enemyCatViewsContainer.x = layoutHelper.stageWidth / 2;
			enemyCatViewsContainer.y = layoutHelper.stageHeight / 2 - 30;
			
			foodViewsContainer.x = layoutHelper.stageWidth / 2;
			foodViewsContainer.y = layoutHelper.stageHeight / 2 + 90;
			
			playerCatViewsContainer.scale = layoutHelper.independentScaleFromEtalonMin;
			playerCatViewsContainer.x = layoutHelper.stageWidth / 2;
			playerCatViewsContainer.y = layoutHelper.stageHeight / 2 + 225;
			
			charV.y = layoutHelper.stageHeight / 2 + 80;
			
			charS.y = layoutHelper.stageHeight / 2 + 80;
			
			
		}
		
		public function show(showReadyGo:Boolean):void 
		{
			invalidate();
			validate();
			
			clean();
			
			enemyStepPriority = Math.random() > 0.5;
			
			addChildAt(gameUIPanel, 0);
			gameUIPanel.state = GameUIPanel.STATE_GAME;
			gameUIPanel.enableControls();
			gameUIPanel.invalidate(INVALIDATION_FLAG_SIZE);
			
			if (showReadyGo)
			{
				//new ReadyGo().show(this, 0.7);
				
				
			}
			else {
				
				
				//Game.current.gameScreen.gameScreenController.dropScores(Room.current.stakeData.scorePowerupsDropped, Player.current.cards.length > 2 ? 1.45 : 1.05);
			}
			
			
			
			charV.x = - 50;
			charV.alpha = 1;
			
			charS.alpha = 1;
			charS.x = layoutHelper.stageWidth + 50;
			
			
			Starling.juggler.tween(charV, 0.5, {delay:1.0, transition:Transitions.EASE_OUT_BACK, x:layoutHelper.stageWidth / 2 - 30});
			Starling.juggler.tween(charS, 0.5, {delay:1.0, transition:Transitions.EASE_OUT_BACK, x:layoutHelper.stageWidth / 2 + 30});
			
			startButton.scale = 1;
			startButton.alpha = 1;
			startButton.y = layoutHelper.stageHeight - startButton.height/2 - 30; 
			startButton.x = layoutHelper.stageWidth + startButton.width + 50; 
			Starling.juggler.tween(startButton, 0.3, {delay:0.6, transition:Transitions.EASE_OUT, x:(layoutHelper.stageWidth - startButton.width/2 - 30)});
			
			
			TutorialManager.fillCats(gameManager.enemyCats);
			TutorialManager.refreshCatTargets(gameManager.enemyCats, gameManager.playerCats);
			
			//foodCount = 12//2 + Math.round(Math.random()*4);
			takeFood();
			
			
			playerCatsViews.splice(0, playerCatsViews.length);
			enemyCatsViews.splice(0, enemyCatsViews.length);
			
			while(playerCatViewsContainer.numChildren > 0) {
				playerCatViewsContainer.removeChildAt(0);
			}
			
			while(enemyCatViewsContainer.numChildren > 0) {
				enemyCatViewsContainer.removeChildAt(0);
			}
			
			var i:int;
			var catView:CatView;
			for (i = 0; i < gameManager.playerCats.length; i++) 
			{
				catView = new CatView();
				catView.controlsEnabled = true;
				catView.cat = gameManager.playerCats[i];
				catView.cat.active = true;
				
				if (catView.cat.role == CatRole.FIGHTER || catView.cat.role == CatRole.DEFENDER) {
					catView.cat.targetCat = (gameManager.enemyCats[i] as CatModel).id;
				}
				else
				{
					catView.cat.targetCat = -1;
				}
				
				catView.showRoleImage(catView.cat.role);
				
				playerCatsViews.push(catView);
				playerCatsViews[i].x = +layoutHelper.stageWidth / 2 + CatView.WIDTH/2;
				playerCatViewsContainer.addChild(playerCatsViews[i]);
				
				catView.addEventListener(CatView.EVENT_TRIGGERED, handler_playerCatTriggered);
			}
			
			
			for (i = 0; i < gameManager.enemyCats.length; i++) 
			{
				catView = new CatView();
				catView.isFront = true;
				catView.controlsEnabled = true;
				catView.cat = gameManager.enemyCats[i];
				catView.cat.active = true;
				enemyCatsViews.push(catView);
				enemyCatsViews[i].x = -layoutHelper.stageWidth / 2 - CatView.WIDTH/2 - 160;
				enemyCatViewsContainer.addChild(enemyCatsViews[i]);
				
				catView.addEventListener(CatView.EVENT_TRIGGERED, handler_enemyCatTriggered);
			}
			
			var shiftX:int = -((CatView.WIDTH*pxScale + 50*pxScale) * gameManager.playerCats.length - 50)/2 + CatView.WIDTH/2;
			for (i = 0; i < playerCatViewsContainer.numChildren; i++) 
			{
				Starling.juggler.tween(playerCatViewsContainer.getChildAt(i), 0.3, {delay:(i*0.1) + 0.5, transition:Transitions.EASE_OUT, x:(shiftX + i*(CatView.WIDTH*pxScale + 50*pxScale))});
			}
			
			for (i = 0; i < enemyCatViewsContainer.numChildren; i++) 
			{
				Starling.juggler.tween(enemyCatViewsContainer.getChildAt(i), 0.3, {delay:(i*0.1) + 1.3, transition:Transitions.EASE_OUT_BACK, x:(shiftX + i*(CatView.WIDTH*pxScale + 50*pxScale))});
			}
			
			
			refreshEnemyTargetMarks();
			
		}
		
		private var selectedPlayerCat:CatView;
		
		private function handler_playerCatTriggered(event:Event):void 
		{
			var catView:CatView = event.target as CatView;
			catView.cat.role = CatRole.getNext(catView.cat.role);
			catView.showRoleImage(catView.cat.role);
			
			selectedPlayerCat = catView;
			
			var i:int;
			for (i = 0; i < playerCatsViews.length; i++) 
			{
				(playerCatsViews[i] as CatView).showSelected = false;
			}
			
			selectedPlayerCat.showSelected = true;
			
			var enemyCatView:CatView;
			if (catView.cat.role == CatRole.FIGHTER) 
			{
				enemyCatViewsContainer.touchable = true;
				
				if (catView.cat.targetCat == -1) 
				{
					enemyCatView = getEnemyCatWithoutFightMarks();
					if(enemyCatView)
						catView.cat.targetCat = enemyCatView.cat.id;
					else
						catView.cat.targetCat = -1;
				}
				
			}
			else if (catView.cat.role == CatRole.DEFENDER) 
			{
				enemyCatViewsContainer.touchable = true;
				
				if (catView.cat.targetCat == -1) 
				{
					enemyCatView = getEnemyCatWithoutDefenderMarks();
					if(enemyCatView)
						catView.cat.targetCat = enemyCatView.cat.id;
					else
						catView.cat.targetCat = -1;
				}
				
			}
			else {
				catView.cat.targetCat = -1;
				enemyCatViewsContainer.touchable = false;
			}
			
			refreshEnemyTargetMarks();
		}
		
		private function handler_enemyCatTriggered(event:Event):void 
		{
			if (!selectedPlayerCat)
				return;
			
			if ((selectedPlayerCat.cat.role != CatRole.FIGHTER) && (selectedPlayerCat.cat.role != CatRole.DEFENDER))	
				return;
				
			var catView:CatView = event.target as CatView;
			catView.cat.role = CatRole.getNext(catView.cat.role);
			//catView.refreshRole();
			
			if (catView.cat.health > 0) 
			{
				selectedPlayerCat.cat.targetCat = catView.cat.id;
			}
			else
			{
			//	selectedPlayerCat.cat.targetCat = -1;
			}
			
			refreshEnemyTargetMarks();
		}
		
		private function getEnemyCatWithoutFightMarks():CatView 
		{
			var i:int;
			var catView:CatView;
			var activeEnemyCats:Array = [];
			for (i = 0; i < enemyCatsViews.length; i++) 
			{
				catView = enemyCatsViews[i] as CatView;
				if (catView.cat.health > 0)
				{
					if(catView.fightMarks == 0)
						return catView;
						
					activeEnemyCats.push(catView);	
				}		
			}
			
			return activeEnemyCats.length > 0 ? activeEnemyCats[0] : null;
		}
		
		private function getEnemyCatWithoutDefenderMarks():CatView 
		{
			var i:int;
			var catView:CatView;
			var activeEnemyCats:Array = [];
			for (i = 0; i < enemyCatsViews.length; i++) 
			{
				catView = enemyCatsViews[i] as CatView;
				if (catView.cat.health > 0)
				{
					if(catView.defenderMarks == 0)
						return catView;
						
					activeEnemyCats.push(catView);	
				}		
			}
			
			return activeEnemyCats.length > 0 ? activeEnemyCats[0] : null;
		}
		
		private function refreshEnemyTargetMarks():void 
		{
			var i:int;
			var j:int;
			var catView:CatView;
			var playerCatView:CatView;
			var marksCount:int;
			var defenderMarksCount:int;
			for (i = 0; i < enemyCatsViews.length; i++) 
			{
				catView = enemyCatsViews[i] as CatView;
				marksCount = 0;
				defenderMarksCount = 0;
				for (j = 0; j < playerCatsViews.length; j++) 
				{
					playerCatView = playerCatsViews[j] as CatView;
					
					if (playerCatView.cat.role == CatRole.FIGHTER && playerCatView.cat.targetCat == catView.cat.id) 
						marksCount++;
					
					if (playerCatView.cat.role == CatRole.DEFENDER && playerCatView.cat.targetCat == catView.cat.id) 
						defenderMarksCount++;
				}
				
				catView.fightMarks = marksCount;
				catView.defenderMarks = defenderMarksCount;
			}
		}
		
		private function dispatchReadyGoComplete():void 
		{
			dispatchEventWith(READY_GO_COMPLETE);
		}
		
		public function hide():void 
		{
			if (gameUIPanel) {
				//gameUIPanel.reset();
				gameUIPanel.state = GameUIPanel.STATE_TO_RESULTS;
				//gameUIPanel.visible = false;
			}
			
			hideVSandStartButton();
			
			var i:int;
			for (i = 0; i < playerCatViewsContainer.numChildren; i++) 
			{
				Starling.juggler.tween(playerCatViewsContainer.getChildAt(i), 0.4, {delay:(i*0.05) + 0.2, transition:Transitions.EASE_OUT, x:(-layoutHelper.stageWidth/2 -CatView.WIDTH*pxScale - 80)});
			}
			
			
			for (i = 0; i < enemyCatViewsContainer.numChildren; i++) 
			{
				Starling.juggler.tween(enemyCatViewsContainer.getChildAt(i), 0.4, {delay:(i*0.05) + 0.3, transition:Transitions.EASE_OUT_BACK, x:(layoutHelper.stageWidth/2 +CatView.WIDTH*pxScale + 110)});
			}
			
			
			var foodImage:Image;
			for (i = 0; i < foodViewsContainer.numChildren; i++) 
			{
				foodImage = foodViewsContainer.getChildAt(i) as Image;
				Starling.juggler.tween(foodImage, 0.2, {delay:(i*0.05), alpha:0, transition:Transitions.EASE_OUT, y:(foodImage.y - 100)});
			}
		}
		
		
		private function startButton_triggeredHandler(e:Event):void 
		{
			// start fight
		
			enemyCatViewsContainer.touchable = false;
			playerCatViewsContainer.touchable = false;
			
			hideVSandStartButton();
			
			var i:int;
			
			for (i = 0; i < playerCatsViews.length; i++) 
			{
				(playerCatsViews[i] as CatView).showSelected = false;
			}
			
				
			
			Starling.juggler.delayCall(nextFightAction, 1.8);
		}
		
		private function takeFood():void
		{
			var i:int;
			if (foodTaken)
				return;
			
			var columns:int = 4;	
			var foodImageScale:Number = 0.7;
			var foodImage:Image;
			var shiftX:int = (-150 * Math.min(foodCount, columns-1) * foodImageScale)/2 /*- (172 * foodImageScale) / 2*/;
			for (i = 0; i < foodCount; i++) 
			{
				foodImage = new Image(AtlasAsset.CommonAtlas.getTexture('cats/fish_chest'));
				foodImage.alignPivot();
				foodImage.scale = foodImageScale;
				foodImage.x = shiftX + i % columns * 150 * foodImageScale;
				foodImage.alpha = 0;
				foodImage.y = -layoutHelper.stageHeight/2 - foodImage.height/2 + 104;
				foodImage.touchable = false;
					
				foodViewsContainer.addChild(foodImage);
				
				Starling.juggler.tween(foodImage, 0.5, {delay:(i*0.02) + 0.3, alpha:20, transition:Transitions.EASE_OUT_BACK, y:(Math.floor(i/columns)*95* foodImageScale)});
			}
			
			foodTaken = true;
			
		}
		
		private function hideVSandStartButton():void 
		{
			Starling.juggler.tween(charV, 0.4, {transition:Transitions.EASE_OUT, x:charV.x - 50, alpha:0});
			Starling.juggler.tween(charS, 0.4, {transition:Transitions.EASE_OUT, x:charV.x + 50, alpha:0});
			
			EffectsManager.scaleJumpDisappear(startButton);
		}
		
		public function nextFightAction():void 
		{
			var timeToNextAction:Number = 5;
			
			enemyStepPriority = !enemyStepPriority;
			
			if (handleFighters(enemyStepPriority)) {
				delayCallNextFightAction(timeToNextAction);
				return;
			}
				
			if (handleFighters(!enemyStepPriority)) {
				delayCallNextFightAction(timeToNextAction);
				return;
			}
			
			if (handleHarvesters(enemyStepPriority)) {
				delayCallNextFightAction(timeToNextAction);
				return;
			}
			
			if (handleHarvesters(!enemyStepPriority)) {
				delayCallNextFightAction(timeToNextAction);
				return;
			}
			
			if (foodViewsContainer.numChildren <= 0)
			{
				gameScreen.backToLobby();
				return;
			}
			
			
			if(!getAnyActiveRoundCats(playerCatsViews) && !getAnyActiveRoundCats(enemyCatsViews))
			{
				gameScreen.backToLobby();
				return;
			}
			
			showNewStage();
		}
		
		private function delayCallNextFightAction(time:Number):void 
		{
			Starling.juggler.delayCall(nextFightAction, time);
		}
		
		private function handleFighters(enemyTeamIsFirst:Boolean):Boolean 
		{
			var catView_1:CatView;
			var catView_2:CatView;
			
			var firstTeamCatViews:Array;
			var secondTeamCatViews:Array;
			
			if (enemyTeamIsFirst) {
				firstTeamCatViews = enemyCatsViews;
				secondTeamCatViews = playerCatsViews;
			}
			else {
				firstTeamCatViews = playerCatsViews;
				secondTeamCatViews = enemyCatsViews;
			}
			
			// FIGHTER
			catView_1 = getCatByRole(firstTeamCatViews, CatRole.FIGHTER);
			if (catView_1) 
			{
				catView_2 = getCatByRole(secondTeamCatViews, CatRole.FIGHTER, catView_1.cat.id);
				
				if (catView_2 && (catView_1.cat.targetCat == catView_2.cat.id)) 
				{
					// сталкиваются лбами:
					showCatAction(catView_1, CatRole.FIGHTER, catView_2, CatRole.FIGHTER, true);
					catView_1.cat.active = false;
					catView_2.cat.active = false;
					return true;
				}
				else
				{
					// свободный боец. есть ли на него ловец
					catView_2 = getCatByRole(secondTeamCatViews, CatRole.DEFENDER);
					if (catView_2) 
					{
						showCatAction(catView_1, CatRole.FIGHTER, catView_2, CatRole.DEFENDER);
						catView_1.cat.active = false;
						catView_2.cat.active = false;
					}
					else
					{
						// идем свободно мочить кота:
						catView_2 = getCatById(secondTeamCatViews, catView_1.cat.targetCat);
						showCatAction(catView_1, CatRole.FIGHTER, catView_2, catView_2.cat.role);
						catView_1.cat.active = false;
						catView_2.cat.active = false;
					}
					return true;
				}
			}
			
			return false;
		}
		
		
		
		private function handleHarvesters(enemyTeamIsFirst:Boolean):Boolean 
		{
			var catView_1:CatView;
			var catView_2:CatView;
			
			if (foodViewsContainer.numChildren <= 0)
				return false;
			
			catView_1 = getCatByRole(enemyTeamIsFirst ? enemyCatsViews : playerCatsViews, CatRole.HARVESTER);
			if (catView_1) 
			{
				catView_2 = getCatByRole(enemyTeamIsFirst ? playerCatsViews : enemyCatsViews, CatRole.HARVESTER);
				if (catView_2)
				{
					// если есть сборщики по обе стороны сталкиваем их лбами:
					showCatAction(catView_1, CatRole.HARVESTER, catView_2, CatRole.HARVESTER);
					catView_1.cat.active = false;
					catView_2.cat.active = false;
				}
				else
				{
					showCatHarverst(catView_1, Math.floor(foodViewsContainer.numChildren * Math.random()));
					catView_1.cat.active = false;
					harvestFood(1);
				}
					
				return true;	
				
			}
			return false;
		}
		
		private function showNewStage():void 
		{
			enemyCatViewsContainer.touchable = true;
			playerCatViewsContainer.touchable = true;
			
			EffectsManager.scaleJumpAppearBase(startButton, 1);
			
			TutorialManager.refreshCatTargets(gameManager.enemyCats, gameManager.playerCats);
			
			var i:int;
			var catView:CatView;
			for (i = 0; i < playerCatsViews.length; i++) 
			{
				catView = playerCatsViews[i] as CatView;
				catView.cat.active = true;
				catView.alpha = 1;
				
				if (catView.cat.role == CatRole.FIGHTER) {
					catView.cat.targetCat = (gameManager.enemyCats[i] as CatModel).id;
				}
				else
				{
					catView.cat.targetCat = -1;
				}
				
				catView.showRoleImage(catView.cat.role);
			}
			
			for (i = 0; i < enemyCatsViews.length; i++) {
				catView = enemyCatsViews[i] as CatView;
				catView.cat.active = true;
				catView.alpha = 1;
				//catView
			}
			
			
			
			
			roundInfoLabel.x = layoutHelper.stageWidth / 2;
			roundInfoLabel.y = layoutHelper.stageHeight / 2;
			roundInfoLabel.scale = 0;
			roundInfoLabel.text = 'NEXT ROUND!\nPREPARE YOUR CATS!';
			
			FadeQuad.show(topLayer, 0.2, 0.8, false, null);
			
			topLayer.addChild(roundInfoLabel);
			
			TweenHelper.tween(roundInfoLabel, 0.5, {delay:0.3, transition:Transitions.EASE_OUT_BACK, scale:layoutHelper.independentScaleFromEtalonMin}).
				chain(roundInfoLabel, 0.3, {delay:1.5, transition:Transitions.EASE_OUT, scale:0, onStart:FadeQuad.hide});	
				
			
			showEnemyRoles();
			
			refreshEnemyTargetMarks();
		}
		
		private function showCatAction(catView_1:CatView, role_1:String, catView_2:CatView, role_2:String, sameTargets:Boolean = false):void
		{
			// Чтобы тот кто мордой на нас всегда был слева:
			if (!catView_1.isFront) 
			{
				var storedCat:CatView = catView_1;
				var storedRole:String = role_1;
				
				catView_1 = catView_2;
				role_1 = role_2;
				
				catView_2 = storedCat;
				role_2 = storedRole;
			}
			
			FadeQuad.show(topLayer, 0.2, 0.7, false, null);
			
			var helperPoint:Point;
			
			helperPoint = catView_1.parent.localToGlobal(new Point(catView_1.x, catView_1.y));
			catView_1.refreshStoreds();
			catView_1.x = helperPoint.x;
			catView_1.y = helperPoint.y;
			catView_1.scale = catView_1.parent.scale;
			catView_1.storedX_0 = catView_1.x;
			catView_1.storedY_0 = catView_1.y;
			topLayer.addChild(catView_1);
			
			helperPoint = catView_2.parent.localToGlobal(new Point(catView_2.x, catView_2.y));
			catView_2.refreshStoreds();
			catView_2.x = helperPoint.x;
			catView_2.y = helperPoint.y;
			catView_2.scale = catView_2.parent.scale;
			catView_2.scale = catView_2.parent.scale;
			catView_2.storedX_0 = catView_2.x;
			catView_2.storedY_0 = catView_2.y;
			//catView_2.x = catView_2.x + catView_2.parent.x;
			//catView_2.y = catView_2.y + catView_2.parent.y;
			topLayer.addChild(catView_2);
			
			catView_1.showRoleImage(null);
			catView_1.fightMarks = 0;
			
			catView_2.showRoleImage(null);
			catView_2.fightMarks = 0;
			
			TweenHelper.tween(catView_1, 0.4, {delay:0.3, transition:Transitions.EASE_OUT, scale:1.3, x:(layoutHelper.stageWidth / 2 - CatView.WIDTH / 2 - 30), y:(layoutHelper.stageHeight / 2 - 50)}).
				chain(catView_1, 2.5, {delay:0, transition:Transitions.EASE_OUT, y:(layoutHelper.stageHeight / 2 + 50), onStart:catView_1.showRoleAction, onStartArgs:[(catView_1.cat.active && catView_1.cat.health > 0) ? role_1 : null, catView_1.isFront, true], onComplete:catView_1.showRoleAction, onCompleteArgs:[null]}).
				chain(catView_1, 0.4, {scale:catView_1.storedScale, alpha:0.5, transition:Transitions.EASE_OUT, x:catView_1.storedX_0, y:catView_1.storedY_0, onComplete:childCatAtHomeLayer, onCompleteArgs:[catView_1], onStart:FadeQuad.hide});
			
				
			TweenHelper.tween(catView_2, 0.4, {delay:0.3, transition:Transitions.EASE_OUT, scale:1.3, x:(layoutHelper.stageWidth / 2 + CatView.WIDTH / 2 + 30), y:(layoutHelper.stageHeight / 2 + 50)}).
				chain(catView_2, 2.5, {delay:0, transition:Transitions.EASE_OUT, y:(layoutHelper.stageHeight / 2 - 50), onStart:catView_2.showRoleAction, onStartArgs:[(catView_2.cat.active && catView_2.cat.health > 0) ? role_2 : null, catView_2.isFront, true], onComplete:catView_2.showRoleAction, onCompleteArgs:[null]}).
				chain(catView_2, 0.4, {scale:catView_2.storedScale, alpha:0.5, transition:Transitions.EASE_OUT, x:catView_2.storedX_0, y:catView_2.storedY_0, onComplete:childCatAtHomeLayer, onCompleteArgs:[catView_2]});	
			
				
			
			topLayer.addChild(particleEffect);
			//particleEffect.play(150, 20, 15);
			//particleEffect.play(3000, 70, 0);	
				
			Starling.juggler.delayCall(particleEffect.play, 0.7, 2200, 70, 0);
			
			//Starling.juggler.tween(catView_1, 0.4, {delay:2.3, transition:Transitions.EASE_OUT_BACK, x:(layoutHelper.stageWidth / 2 - CatView.WIDTH / 2 + 0), y:(layoutHelper.stageHeight / 2)});
			//Starling.juggler.tween(catView_2, 0.4, {delay:2.3, transition:Transitions.EASE_OUT_BACK, x:(layoutHelper.stageWidth/2 + CatView.WIDTH/2 + 0), y:(layoutHelper.stageHeight/2)});
			
			if (role_1 == role_2) 
			{
				if (role_1 == CatRole.FIGHTER)
				{
					if (catView_1.cat.targetCat == catView_2.cat.id && catView_2.cat.targetCat == catView_1.cat.id)
					{
						
					}
					else if (catView_1.cat.targetCat == catView_2.cat.id)
					{
						catView_2.cat.health -= 1;
					}
					else if (catView_2.cat.targetCat == catView_1.cat.id)
					{
						catView_1.cat.health -= 1;
					}
				}
				
				//catView_1
			}
			else 
			{
				if (role_1 == CatRole.FIGHTER)
				{
					if (role_2 == CatRole.DEFENDER)
						catView_1.cat.health -= 1;
					else if (role_2 == CatRole.HARVESTER)
						catView_2.cat.health -= 1;
				}
				else if (role_2 == CatRole.FIGHTER)
				{
					if (role_1 == CatRole.DEFENDER)
						catView_2.cat.health -= 1;
					else if (role_1 == CatRole.HARVESTER)
						catView_1.cat.health -= 1;
				}
			}
		}
		
		private function childCatAtHomeLayer(catView:CatView):void
		{
			catView.storedParent.addChild(catView);
			catView.x = catView.storedX;
			catView.y = catView.storedY;
			catView.scale = 1;
			
			//FadeQuad.hide();
			
		}
		
		private function showCatHarverst(catView_1:CatView, foodIndex:int):void
		{
			FadeQuad.show(topLayer, 0.2, 0.7, false, null);
			
			var helperPoint:Point;
			
			helperPoint = catView_1.parent.localToGlobal(new Point(catView_1.x, catView_1.y));
			catView_1.refreshStoreds();
			catView_1.x = helperPoint.x;
			catView_1.y = helperPoint.y;
			catView_1.scale = catView_1.parent.scale;
			catView_1.storedX_0 = catView_1.x;
			catView_1.storedY_0 = catView_1.y;
			topLayer.addChild(catView_1);
			
			var foodImage:Image = foodViewsContainer.getChildAt(foodIndex) as Image;
			helperPoint = foodImage.parent.localToGlobal(new Point(foodImage.x, foodImage.y));
			foodImage.x = helperPoint.x;
			foodImage.y = helperPoint.y;
			foodImage.scale = foodImage.parent.scale;
			topLayer.addChild(foodImage);
			
			catView_1.showRoleImage(null);
			catView_1.fightMarks = 0;
			
			
			var x_1_left:int = (layoutHelper.stageWidth / 2 - CatView.WIDTH / 2 - 40);
			var y_1_left:int = (layoutHelper.stageHeight / 2 - 50);
			//var y_2_left:int = (layoutHelper.stageHeight / 2 + 50);
		
			
			var x_1_right:int = (layoutHelper.stageWidth / 2 + CatView.WIDTH / 2 + 40);
			var y_1_right:int = (layoutHelper.stageHeight / 2 + 50);
			//var y_2_right:int = (layoutHelper.stageHeight / 2 - 50);
			
			
			TweenHelper.tween(catView_1, 0.4, {delay:0.3, transition:Transitions.EASE_OUT, scale:1.3, x:x_1_left, y:y_1_left}).
				chain(catView_1, 2.0, {delay:0, transition:Transitions.EASE_OUT, y:(layoutHelper.stageHeight / 2 + 50), onStart:catView_1.showRoleAction, onStartArgs:[catView_1.cat.role, true], onComplete:catView_1.showRoleAction, onCompleteArgs:[null]}).
				chain(catView_1, 0.4, {scale:catView_1.storedScale, alpha:0.5, transition:Transitions.EASE_OUT, x:catView_1.storedX_0, y:catView_1.storedY_0, onComplete:childCatAtHomeLayer, onCompleteArgs:[catView_1], onStart:FadeQuad.hide});
				
			TweenHelper.tween(foodImage, 0.4, {delay:0.3, transition:Transitions.EASE_OUT, scale:1.3, x:x_1_right, y:y_1_right}).
				chain(foodImage, 2.0, {delay:0, transition:Transitions.EASE_OUT, y:(layoutHelper.stageHeight / 2 - 50)}).
				chain(foodImage, 0.4, {alpha:0, transition:Transitions.EASE_OUT, y:(layoutHelper.stageHeight / 2 - 150), onComplete:foodImage.removeFromParent});	
		}
		
		private function harvestFood(count:int):void
		{
			Player.current.reservedCashCount += count;
			Player.current.updateCashCount(count, "debug");
			
			Game.connectionManager.sendPlayerUpdateMessage();	
			
			new UpdateLobbyBarsTrueValue(0.5).execute();
		}
		
		
		private function getCatByRole(array:Array, role:String, targetCat:int = -1):CatView 
		{
			var i:int;
			var catView:CatView;
			for (i = 0; i < array.length; i++) 
			{
				catView = array[i] as CatView;
				
				if (!catView.cat.active || catView.cat.health <= 0)
					continue;
					
				if (catView.cat.role == role) 
				{
					if(targetCat == -1 || (targetCat != -1 && targetCat == catView.cat.targetCat))
						return catView;
						
				}
			}
			
			return null;
		}
		
		private function getCatById(array:Array, id:int):CatView 
		{
			var i:int;
			var catView:CatView;
			for (i = 0; i < array.length; i++) 
			{
				catView = array[i] as CatView;
				
				if (catView.cat.id == id)
					return catView;
					
			}
			
			return null;
		}
		
		private function getAnyActiveRoundCats(array:Array):Boolean
		{
			var i:int;
			var catView:CatView;
			for (i = 0; i < array.length; i++) 
			{
				catView = array[i] as CatView;
				
				if (catView.cat.health > 0/* && catView.cat.role != CatRole.DEFENDER*/)
					return true;
			}
			
			return false;
		}
		
		
		
		public var enemyRolesShowed:Boolean;
		
		public function showEnemyRoles():void 
		{
			var i:int;
			var catView:CatView;
	
			
			for (i = 0; i < enemyCatsViews.length; i++) 
			{
				catView = enemyCatsViews[i] as CatView;
				catView.showRoleImage(enemyRolesShowed ? catView.cat.role : null);
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function getBrightnessMatrix(value:Number):Vector.<Number> {
			return new <Number> [	
				value, 0, 0, 0, 0,
				0, value, 0, 0, 0,
				0, 0, value, 0, 0,
				0, 0, 0, 1, 0
			]
		}
		
		
		
		public function roundOverHandle():void 
		{
		
		}
		
		public function showBingo(cardId:uint):void 
		{
			
		}
		
		public function showBadBingo(cardId:uint):void 
		{
		
		}
		
		public function addWinner(playerBingoedMessage:PlayerBingoedMessage):void 
		{
		
		}
		
		public function addBall(number:uint):void 
		{
			
		}
		
		public function advancePowerup():void 
		{
			
		}
		
		public function addPowerupToCards(powerup:String, tweenStyle:String):void 
		{
		
		}
		
		
		
		public function scrollCards():void
		{
		
		}
			
		public function forceFinishBingoAnimations():void
		{
		
		}
		
		public function get hasBingoAnimations():Boolean
		{
			return false;
		}
		
		private function showBingoAnimation(gameCard:GameCard):void
		{
			
		}
		
	
		private function clean():void 
		{
			DelayCallUtils.cleanBundle(DELAY_CALL_GAME_UI_BUNDLE);
			
			while (foodViewsContainer.numChildren > 0) 
			{
				foodViewsContainer.removeChildAt(0);
			}
			
			
			while (foodViewsContainer.numChildren > 0) 
			{
				foodViewsContainer.removeChildAt(0);
			}
			
			enemyCatViewsContainer.touchable = true;
			playerCatViewsContainer.touchable = true;
			
			foodTaken = false;
			
			//playerCatViewsContainer.scale =  layoutHelper.independentScaleFromEtalonMin;
			//playerCatViewsContainer.x = layoutHelper.stageWidth / 2;
			//playerCatViewsContainer.y = layoutHelper.stageHeight / 2;
			
			gameManager.chestsData.closeOpenAndTakeOutDialogs(0.5);
		}
		
		public function getCardByCardModel(card:Card):GameCard
		{
			if (!gameCardsView)
				return null;
				
			return gameCardsView.getCardByCardModel(card);
		}
		
		public function tutorialStepShowPowerupBall():void 
		{
			
		}
		
		public function tutorialStepHidePowerupBall():void 
		{
			
		}
		
		public function debugShowBingoOnRandomCard():void 
		{
			
		}
		
		public function debugAddPowerUpToCards(powerup:String = null):void 
		{
			
		}
	}

}