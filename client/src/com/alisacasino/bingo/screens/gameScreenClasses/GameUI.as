package com.alisacasino.bingo.screens.gameScreenClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.components.DottedLine;
	import com.alisacasino.bingo.components.FadeQuad;
	import com.alisacasino.bingo.components.FrameAnimator;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.controls.BingoAnimation;
	import com.alisacasino.bingo.controls.CashBar;
	import com.alisacasino.bingo.controls.CoinsBar;
	import com.alisacasino.bingo.controls.EnemyBar;
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
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.JumpWithHintHelper;
	import com.alisacasino.bingo.utils.ServerConnection;
	import com.alisacasino.bingo.utils.caurina.transitions.properties.DisplayShortcuts;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.utils.Align;
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
		private var arrowsContainer:Sprite;
		
		public var playerCatsViews:Array = [];
		public var enemyCatsViews:Array = [];
		
		public var playerActionHelpersViews:Array = [];
		
		public static var foodCount:int;
		
		private var charV:XTextField;
		private var charS:XTextField;
		
		private var roundInfoLabel:XTextField;
		
		private var roundResultsLabel:XTextField;
		
		private var foodTaken:Boolean;
		
		private var enemyStepPriority:Boolean;
		
		private var particleEffect:ParticleExplosion;
		
		private var attackImage:Image;
		private var defenceImage:Image;
		
		private var targetGlow:Image;
		private var targetImage:Image;
		private var targetAnim:FrameAnimator;
		
		
		private var foodCoverImage:Image;
		private var denencePoints:Vector.<Point>
	
		
		public var exitGameSent:Boolean;
		
		public var playerBar:CashBar;
		public var foodInfo:FoodInfo;
		public var enemyBar:EnemyBar;
		
		public function GameUI(gameScreen:GameScreen) 
		{
			this.gameScreen = gameScreen;
			outerQuad = new Quad(1, 1, 0xFF0000);

			innerQuad = new Quad(1, 1, 0xffffff);
			
			topLayer = new Sprite();
			topLayer.touchable = false;
			
			denencePoints  = new <Point>[];
			denencePoints[0] = new Point( -110 /** layoutHelper.specialScale*/, 30 /** layoutHelper.specialScale*/);
			denencePoints[1] = new Point( -50 /** layoutHelper.specialScale*/, 20 /** layoutHelper.specialScale*/);
			denencePoints[2] = new Point(-60/**layoutHelper.specialScale*/, 100/**layoutHelper.specialScale*/);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			gameUIPanel = new GameUIPanel(this);
			gameUIPanel.setSize(width, height);
			//gameUIPanel.visible = false;
			addChild(gameUIPanel);
			
			
			
			foodViewsContainer = new Sprite();
			addChild(foodViewsContainer);
			
			enemyCatViewsContainer = new Sprite();
			addChild(enemyCatViewsContainer);
			
			arrowsContainer = new Sprite();
			arrowsContainer.touchable = false;
			
			
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
			
			startButton = new XButton(XButtonStyle.getStyle(AtlasAsset.CommonAtlas, 'buttons/fight_btn', 'buttons/fight_btn'));
			//startButton.scale9Grid = new Rectangle(25 * pxScale, 0, 35 * pxScale, startButton.upState.height);
			//startButton.text = 'START!';
			startButton.alignPivot();
			//startButton.scale = ;
			startButton.addEventListener(Event.TRIGGERED, startButton_triggeredHandler);
			addChild(startButton);
			
		
			
			
			roundInfoLabel= new XTextField(480*pxScale, 390*pxScale, XTextFieldStyle.houseHolidaySans(70, 0xFFFFFF).setStroke(1), '');
			roundInfoLabel.touchable = false;
			roundInfoLabel.x = - 50;
			roundInfoLabel.y = layoutHelper.stageHeight / 2;
			roundInfoLabel.alignPivot();
			
			roundResultsLabel= new XTextField(480*pxScale*layoutHelper.specialScale, 40*pxScale*layoutHelper.specialScale, XTextFieldStyle.houseHolidaySans(30*layoutHelper.specialScale, 0xFFFFFF).setStroke(1), '');
			roundResultsLabel.touchable = false;
			roundResultsLabel.x = layoutHelper.stageWidth / 2;
			roundResultsLabel.isHtmlText = true;
			
			//roundResultsLabel.y = //layoutHelper.stageHeight / 2;
			roundResultsLabel.alignPivot(Align.CENTER, Align.TOP);
			
			
			
			var colors:Vector.<uint> = new <uint>[0xFFFFFF];
			particleEffect = new ParticleExplosion(AtlasAsset.CommonAtlas, new <String>["effects/smoke_1", "effects/smoke_0"], colors);
			particleEffect.x = layoutHelper.stageWidth / 2;
			particleEffect.y = layoutHelper.stageHeight / 2;
			particleEffect.setProperties(0, 50 * pxScale, +0.01, 0.028, 0.01, 0, 0.7, true);
			particleEffect.setFineProperties(0.6, 0.0, 0.0, 0);
			//particleEffect.setAccelerationProperties(-0.02);
			particleEffect.lifetime = 500;
			
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, handler_touch);
			
			
			attackImage = new Image(AtlasAsset.CommonAtlas.getTexture('cats/attack_bg'));
			attackImage.alignPivot();
			attackImage.alpha = 0;
			attackImage.touchable = false;
			//addChild(attackImage);
			
			defenceImage = new Image(AtlasAsset.CommonAtlas.getTexture('cats/defence_bg'));
			defenceImage.alignPivot();
			//defenceImage.alpha = 0;
			defenceImage.touchable = false;
			
			
			targetImage = new Image(AtlasAsset.CommonAtlas.getTexture('cats/target_bg'));
			targetImage.alignPivot();
			targetImage.alpha = 0;
			targetImage.touchable = false;
			
			targetGlow = new Image(AtlasAsset.CommonAtlas.getTexture('cats/cursor_glow_full'));
			targetGlow.alignPivot();
			targetGlow.alpha = 0;
			targetGlow.touchable = false;
			
			
			foodCoverImage = new Image(AtlasAsset.CommonAtlas.getTexture('cats/trash_02'));
			foodCoverImage.alignPivot();
			foodCoverImage.scale = layoutHelper.specialScale * CatFoodView.FOOD_SCALE;
			foodCoverImage.touchable = false;
			foodCoverImage.visible = false;
			addChild(foodCoverImage);
			
			Starling.juggler.tween(targetImage, 2.8, {rotation:Math.PI*2, repeatCount:0, transition:Transitions.LINEAR});	
			
			addChild(arrowsContainer);
			
			addChild(topLayer);
			
			addChild(roundResultsLabel);
			
			targetAnim = FrameAnimator.getCursorAnimator();
			targetAnim.touchable = false;
			//var ggg:Number = pxScale;
			//1+1
			
			
			playerBar = new CashBar(false);
			playerBar.touchable = false;
			playerBar.custom = true;
			addChild(playerBar);
			
			enemyBar = new EnemyBar();
			enemyBar.touchable = false;
			addChild(enemyBar);
			
			foodInfo = new FoodInfo();
			addChild(foodInfo);
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
			
			enemyCatViewsContainer.scale = layoutHelper.independentScaleFromEtalonMin;// * 0.85;
			enemyCatViewsContainer.x = layoutHelper.stageWidth / 2;
			enemyCatViewsContainer.y = layoutHelper.stageHeight / 2// - 180*layoutHelper.specialScale;
			
			foodViewsContainer.x = layoutHelper.stageWidth / 2;
			foodViewsContainer.y = layoutHelper.stageHeight / 2 + 0;
			
			playerCatViewsContainer.scale = layoutHelper.independentScaleFromEtalonMin;
			playerCatViewsContainer.x = layoutHelper.stageWidth / 2;
			playerCatViewsContainer.y = layoutHelper.stageHeight / 2// + 225*layoutHelper.specialScale;
			
			charV.y = layoutHelper.stageHeight / 2 + 80;
			
			charS.y = layoutHelper.stageHeight / 2 + 80;
			
			
			foodCoverImage.x = layoutHelper.stageWidth / 2 + 28/**layoutHelper.specialScale*/;
			foodCoverImage.y = layoutHelper.stageHeight / 2 - 52/**layoutHelper.specialScale*/;
			
			//var asd:Number = layoutHelper.independentScaleFromEtalonMin;
			
			attackImage.scale = layoutHelper.independentScaleFromEtalonMin;
			defenceImage.scale = layoutHelper.independentScaleFromEtalonMin;
			
			if(gameUIPanel.cardScrollButton)
				gameUIPanel.cardScrollButton.visible = gameManager.gameMode != GameManager.GAME_MODE_PVP;
				
				
			playerBar.scale = (layoutHelper.independentScaleFromEtalonMin) * (layoutHelper.canvasLayoutMode ? 1 : 0.7);	
			enemyBar.scale = layoutHelper.independentScaleFromEtalonMin * (layoutHelper.canvasLayoutMode ? 1 : 0.7);	;
			playerBar.x = layoutHelper.stageWidth / 2 - playerBar.width - 0;
			enemyBar.x = layoutHelper.stageWidth / 2 + 43*layoutHelper.specialScale;
			playerBar.y = enemyBar.y = 22*layoutHelper.specialScale;
			
			foodInfo.scale = layoutHelper.independentScaleFromEtalonMin * (layoutHelper.canvasLayoutMode ? 1 : 0.7);	;	
			foodInfo.x = layoutHelper.stageWidth / 2;
			foodInfo.y = 46*layoutHelper.specialScale;
			
			roundResultsLabel.y = 80*layoutHelper.specialScale;
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
			
			roundResultsLabel.visible = true;
			
			/*charV.x = - 50;
			charV.alpha = 1;
			
			charS.alpha = 1;
			charS.x = layoutHelper.stageWidth + 50;
			
			
			Starling.juggler.tween(charV, 0.5, {delay:1.0, transition:Transitions.EASE_OUT_BACK, x:layoutHelper.stageWidth / 2 - 30});
			Starling.juggler.tween(charS, 0.5, {delay:1.0, transition:Transitions.EASE_OUT_BACK, x:layoutHelper.stageWidth / 2 + 30});
			
			Starling.juggler.tween(charV, 0.4, {delay:1.8, transition:Transitions.EASE_OUT, x:charV.x - 50, alpha:0});
			Starling.juggler.tween(charS, 0.4, {delay:1.8, transition:Transitions.EASE_OUT, x:charV.x + 50, alpha:0});*/
			
			
			startButton.scale = layoutHelper.specialScale;
			startButton.alpha = 1;
			startButton.y = layoutHelper.stageHeight + startButton.height/2 + 30/**layoutHelper.independentScaleFromEtalonMin*/; 
			startButton.x = layoutHelper.stageWidth/2// + startButton.width + 50*layoutHelper.independentScaleFromEtalonMin; 
			Starling.juggler.tween(startButton, 0.3, {delay:0.6, transition:Transitions.EASE_OUT, y:(layoutHelper.stageHeight - startButton.height/2 - 30/**layoutHelper.specialScale*/)});
			
			
			TutorialManager.fillCats(gameManager.enemyCats, true, 1);
			
			if (gameManager.gameMode != GameManager.GAME_MODE_PVP)
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
			var length:int;
			var catView:CatView;
			for (i = 0; i < gameManager.playerCats.length; i++) 
			{
				catView = new CatView();
				catView.index = i;
				catView.controlsEnabled = true;
				catView.isLeft = true;
				catView.cat = gameManager.playerCats[i];
				catView.cat.active = true;
				
				if (catView.cat.role == CatRole.FIGHTER || catView.cat.role == CatRole.DEFENDER) {
					catView.cat.targetCat = (gameManager.enemyCats[i] as CatModel).id;
				}
				else
				{
					catView.cat.targetCat = -1;
				}
				
				//catView.showRoleImage(catView.cat.role);
				if (catView.cat.role != CatRole.DEFENDER) 
					handleCatViewStateByRole(catView);
				
				playerCatsViews.push(catView);
				playerCatsViews[i].x = -layoutHelper.stageWidth / 2 - (CatView.WIDTH*layoutHelper.specialScale)/2 - 100*layoutHelper.specialScale;
				playerCatViewsContainer.addChild(playerCatsViews[i]);
				
				catView.addEventListener(CatView.EVENT_TRIGGERED, handler_playerCatTriggered);
				catView.addEventListener(CatView.EVENT_MOUSE_DOWN, handler_playerCatMouseDown);
				catView.addEventListener(CatView.EVENT_MOUSE_UP, handler_playerCatMouseUp);
			}
			
			
			for (i = 0; i < gameManager.enemyCats.length; i++) 
			{
				catView = new CatView();
				catView.index = i;
				catView.controlsEnabled = true;
				catView.cat = gameManager.enemyCats[i];
				catView.cat.active = true;
				enemyCatsViews.push(catView);
				enemyCatsViews[i].x = +layoutHelper.stageWidth / 2 + (CatView.WIDTH*layoutHelper.specialScale)/2 + 100*layoutHelper.specialScale;
				enemyCatViewsContainer.addChild(enemyCatsViews[i]);
				
				catView.addEventListener(CatView.EVENT_TRIGGERED, handler_enemyCatTriggered);
			}
			
			var catGap:int = 50;
			var shiftX:int = -((CatView.WIDTH * pxScale + catGap*pxScale) * gameManager.playerCats.length - catGap * layoutHelper.independentScaleFromEtalonMin) / 2 + CatView.WIDTH / 2;
			var shiftY:int = -((CatView.HEIGHT * pxScale + catGap * pxScale) * gameManager.playerCats.length - catGap * layoutHelper.independentScaleFromEtalonMin) / 2 + CatView.HEIGHT / 2;
			length = playerCatViewsContainer.numChildren;
			for (i = 0; i < length; i++) 
			{
				var onComp:Function;
				var onCompArgs:Array;
				
				catView = playerCatViewsContainer.getChildAt(i) as CatView;
				catView.basePosition.setTo( -getCatX(i), (shiftY + i * (CatView.HEIGHT * pxScale + catGap * pxScale)));
				
				if (catView.cat.role == CatRole.DEFENDER) {
					onComp = handleCatViewStateByRole;
					onCompArgs = [catView];
				}
				
				Starling.juggler.tween(catView, 0.3, {delay:(i * 0.1) + 0.5, transition:Transitions.EASE_OUT, y:catView.basePosition.y, x:catView.basePosition.x, scale:getCatScale(i), onComplete:onComp, onCompleteArgs:onCompArgs});
			}
			
			length = enemyCatViewsContainer.numChildren;
			for (i = 0; i < length; i++) 
			{
				catView = enemyCatViewsContainer.getChildAt(i) as CatView;
				catView.basePosition.setTo(getCatX(i), (shiftY + i*(CatView.HEIGHT*pxScale + catGap*pxScale)));
				Starling.juggler.tween(enemyCatViewsContainer.getChildAt(i), 0.3, {delay:(i*0.1) + 1.3, transition:Transitions.EASE_OUT_BACK, y:catView.basePosition.y, x:catView.basePosition.x, scale:getCatScale(i)});
			}
			
			var dottedLine:DottedLine;
			while (playerActionHelpersViews.length < playerCatsViews.length) 
			{
				dottedLine = new DottedLine();
				playerActionHelpersViews.push(dottedLine);
				arrowsContainer.addChild(dottedLine);
			}
			
			Starling.juggler.delayCall(refreshEnemyTargetMarks, 2);
			
			Starling.juggler.delayCall(function():void {foodCoverImage.visible = true}, 0.7);
			
			
			playerBar.visible = true;
			enemyBar.visible = true;
			foodInfo.visible = true;
		}
		
		private function handleCatViewStateByRole(catView:CatView):void 
		{
			if (catView.cat.role == CatRole.NONE) 
			{
				setCatState(catView, CatView.STATE_IDLE);
				//catView.setState(CatView.STATE_IDLE);
			}
			else if (catView.cat.role == CatRole.FIGHTER) 
			{
				setCatState(catView, CatView.STATE_ANGRY);
				//catView.setState(CatView.STATE_ANGRY);
			}
			else if (catView.cat.role == CatRole.HARVESTER) 
			{
				setCatState(catView, CatView.STATE_HUNGRY);
				//catView.setState(CatView.STATE_HUNGRY);
			}
			else if (catView.cat.role == CatRole.DEFENDER) 
			{
				setCatState(catView, CatView.STATE_DEFENCE);
				//var defenderPoint:Point = getFreeDefenderSlot();
				//TweenHelper.tween(catView, getPathTime(defenderPoint.x, defenderPoint.y, catView.x, catView.y), {delay:0.0, x:defenderPoint.x, y:defenderPoint.y, onStart:catView.setState, scale:(getCatScale(1, catView.scale)), onStartArgs:[CatView.STATE_WALK], onComplete:catView.setState, onCompleteArgs:[CatView.STATE_DEFENCE, false, false, 1]})
			}
		}
		
		private function setCatState(catView:CatView, state:String):void 
		{
			//catView.setState(state);
			var time:Number = 2;
			if (state == CatView.STATE_DEFENCE)
			{
				var catList:Array = catView.cat.isPlayer ? playerCatsViews : enemyCatsViews;
				
				/*var i:int;
				var helperCatView:CatView;
				var freeDefencePositions:Array = [];
				
				for (i = 0; i < denencePoints.length; i++) 
				{
					freeDefencePositions.push(i);
				}
				
				for (i = 0; i < catList.length; i++) 
				{
					helperCatView = catList[i] as CatView;
					if (helperCatView.defenderPositionId != -1 && freeDefencePositions.indexOf(helperCatView.defenderPositionId) != -1) 
						freeDefencePositions.splice(freeDefencePositions.indexOf(helperCatView.defenderPositionId), 1);
				}*/
				
				
				var defenderPositionId:int = catView.index;//freeDefencePositions.length > 0 ? freeDefencePositions[0] : -1;
				var defenderPoint:Point = defenderPositionId != -1 ? denencePoints[defenderPositionId].clone() : ( new Point());
				
				if (!catView.isLeft)
					defenderPoint.x = -(defenderPoint.x - 23);
				
				catView.defenderPositionId = defenderPositionId;
				time = getPathTime(defenderPoint.x, defenderPoint.y, catView.x, catView.y, 200);
				TweenHelper.tween(catView, time, {delay:0.0, x:defenderPoint.x, y:defenderPoint.y, onStart:catView.setState, scale:(getCatScale(1, 1)), onStartArgs:[CatView.STATE_WALK], onComplete:catView.setState, onCompleteArgs:[CatView.STATE_DEFENCE, false, false, catView.defenderPositionId]})
				
				Starling.juggler.delayCall(refreshEnemyTargetMarks, time + 0.01);
			}
			else 
			{
				if (catView.defenderPositionId != -1) 
				{
					time = getPathTime(catView.basePosition.x, catView.basePosition.y, catView.x, catView.y, 200)
					TweenHelper.tween(catView, time, {delay:0.0, x:catView.basePosition.x, y:catView.basePosition.y, onStart:catView.setState, scale:(getCatScale(catView.index, 1)), onStartArgs:[CatView.STATE_WALK, true], onComplete:catView.setState, onCompleteArgs:[state]});
					catView.defenderPositionId = -1;
					
					Starling.juggler.delayCall(refreshEnemyTargetMarks, time + 0.01);
				}
				else
				{
					catView.setState(state);
				}
			}
		}
		
		private function getFreeDefenderSlot():Point 
		{
			return new Point(-30*layoutHelper.specialScale, 0);
		}
		
		
		
		private function getCatX(index:int):int 
		{
			if (gameManager.CAT_SLOTS_MAX == 3)
			{
				switch(index) {
					case 0: return 130 //* layoutHelper.specialScale;
					case 1: return 250 //* layoutHelper.specialScale;
					case 2: return 170 //* layoutHelper.specialScale;
				}
			}
			
			if (gameManager.CAT_SLOTS_MAX == 2)
			{
				switch(index) {
					case 0: return 170 //* layoutHelper.specialScale;
					case 2: return 210 //* layoutHelper.specialScale;
				}
			}
			
			if (gameManager.CAT_SLOTS_MAX == 1)
			{
				return 250 //* layoutHelper.specialScale;
			}
			
			return 0;
		}
		
		private function getCatScale(index:int, catBaseScale:Number = 1):Number
		{
			return catBaseScale - (gameManager.CAT_SLOTS_MAX - index - 1) * (0.1*catBaseScale);
		}
		
		private var selectedPlayerCat:CatView;
		
		private var actionTouchCat:CatView;
		
		private function handler_playerCatMouseDown(event:Event):void 
		{
			var catView:CatView = event.target as CatView;
			
			if (catView.cat.health <= 0)
				return;
			
			
			FadeQuad.show(topLayer, 0.2, 0.8, false, null);
			
			if (!actionTouchCat)
			{
				actionTouchCat = catView;
				
				/*var helperPoint:Point;
				helperPoint = actionTouchCat.parent.localToGlobal(new Point(actionTouchCat.x, actionTouchCat.y));
				actionTouchCat.refreshStoreds();
				actionTouchCat.x = helperPoint.x;
				actionTouchCat.y = helperPoint.y;
				actionTouchCat.scale = actionTouchCat.parent.scale;
				actionTouchCat.storedX_0 = actionTouchCat.x;
				actionTouchCat.storedY_0 = actionTouchCat.y;*/
				
				//trace('>ss', actionTouchCat.storedX, actionTouchCat.storedY, actionTouchCat.storedX_0, actionTouchCat.storedY_0);
				
				//Starling.juggler.tween(targetImage, 0.3, {alpha:1, transition:Transitions.LINEAR});
				
				
				targetAnim.gotoAndPlay(CatView.CURSOR_ANIM, 0, false, -1, 7);
				Starling.juggler.tween(targetAnim, 0.3, {alpha:1, transition:Transitions.LINEAR});	
				
				
				topLayer.addChild(foodViewsContainer);
				topLayer.addChild(foodCoverImage);
				
				topLayer.addChild(enemyCatViewsContainer);
				topLayer.addChild(playerCatViewsContainer);
				
				
				topLayer.addChild(arrowsContainer);
				//topLayer.addChild(actionTouchCat);
				addChild(roundResultsLabel);
				
				
		
				targetGlow.scale = layoutHelper.specialScale;
				topLayer.addChild(targetGlow);
				
				targetImage.scale = layoutHelper.specialScale;
				topLayer.addChild(targetImage);
				
				
				targetAnim.scale = layoutHelper.specialScale;
				topLayer.addChild(targetAnim);
			}
			
			addEventListener(Event.ENTER_FRAME, hanler_enterFrame);
		}
		
		private function handler_playerCatMouseUp(event:Event):void 
		{
			return;
			/*var catView:CatView = event.target as CatView;
			
			if (actionTouchCat)
			{
				catView.refreshStoreds();
				
				
				TweenHelper.tween(catView, 0.2, {delay:0.0, transition:Transitions.EASE_OUT, x:catView.storedX_0, y:catView.storedY_0, onComplete:childCatAtHomeLayer, onCompleteArgs:[catView]});	
				
				handleCatViewStateByRole(actionTouchCat);
				
				actionTouchCat = null;
				
				if (true) {
					
				}
				else {
					
				}
				
				
			}
			
			FadeQuad.hide(0.2);
			
			removeEventListener(Event.ENTER_FRAME, hanler_enterFrame);*/
		}
		
		private var helpersActive:Boolean;
		private var lastHelperView:DisplayObject;
		
		protected function hanler_enterFrame(event:Event):void
		{
			var helperPoint:Point;
			
			/*if (actionTouchCat) {
				actionTouchCat.x = Starling.current.nativeStage.mouseX;
				actionTouchCat.y = Starling.current.nativeStage.mouseY;
			}*/
			
			targetImage.x = Starling.current.nativeStage.mouseX;
			targetImage.y = Starling.current.nativeStage.mouseY;
			
		
			
			var i:int;
			var catView:CatView;
		
			var currentPlayerCatPoint:Point = new Point(targetImage.x, targetImage.y);
			var hasHelpersTouch:Boolean;
			for (i = 0; i < enemyCatsViews.length; i++) 
			{
				catView = enemyCatsViews[i] as CatView;
				helperPoint = catView.parent.localToGlobal(new Point(catView.x, catView.y));
				
				//trace('UUUU ', i, Point.distance(helperPoint,currentPlayerCatPoint));
				//break;
				
				if (helpersActive)
				{
					if (Point.distance(new Point(attackImage.x, attackImage.y), currentPlayerCatPoint) < 90*layoutHelper.independentScaleFromEtalonMin)
					{
						
						actionTouchCat.cat.role = CatRole.FIGHTER;
						//actionTouchCat.showRoleImage(actionTouchCat.cat.role);
						hasHelpersTouch = true;
						
						
						if (lastHelperView != attackImage) {
							lastHelperView = attackImage;
							EffectsManager.jump(attackImage, 2, layoutHelper.independentScaleFromEtalonMin, layoutHelper.independentScaleFromEtalonMin*1.13, 0.07, 0.07, 0.08, 0, 0, 0.8, true);
						}
						
						//targetAnim.x = helperPoint.x;
						//targetAnim.y = helperPoint.y + 60*layoutHelper.specialScale;
					}
					else if (Point.distance(new Point(defenceImage.x, defenceImage.y), currentPlayerCatPoint) < 90*layoutHelper.independentScaleFromEtalonMin)
					{
						
						actionTouchCat.cat.role = CatRole.DEFENDER;
						//actionTouchCat.showRoleImage(actionTouchCat.cat.role);
						hasHelpersTouch = true;
						//handleCatViewStateByRole(actionTouchCat);
						
						if (lastHelperView != defenceImage) {
							lastHelperView = defenceImage;
							EffectsManager.jump(defenceImage, 2, layoutHelper.independentScaleFromEtalonMin, layoutHelper.independentScaleFromEtalonMin*1.13, 0.07, 0.07, 0.08, 0, 0, 0.8, true);
						}
						
						//targetAnim.x = helperPoint.x;
						//targetAnim.y = helperPoint.y + 60*layoutHelper.specialScale;
					}
					else {
						hasHelpersTouch = false;
						lastHelperView = null;
						
						//targetAnim.x = Starling.current.nativeStage.mouseX;
						//targetAnim.y = Starling.current.nativeStage.mouseY;
					}
					
				}
				else
				{
					hasHelpersTouch = false;
					lastHelperView = null;
				}
				
				if (Point.distance(helperPoint, new Point(targetImage.x, targetImage.y)) < 90*layoutHelper.independentScaleFromEtalonMin)
				{
					actionTouchCat.cat.targetCat = catView.cat.id;
					showEnemyActionHelpers(catView, helperPoint);
					
					showTargetCursor(new Point(helperPoint.x, helperPoint.y + 60 /** layoutHelper.specialScale*/), true);
					
					return;
				}
				else if(hasHelpersTouch || (helpersActive && Point.distance(helperPoint, new Point(targetImage.x, targetImage.y)) < 90*layoutHelper.independentScaleFromEtalonMin))
				{
					if (!helpersActive) {
						showTargetCursor(null, false);
						
					}
					
					return;
				}
				else if (!helpersActive) {
					showTargetCursor(null, false);
				}
				
				//actionTouchCat.refreshStoreds();
				//actionTouchCat.x = helperPoint.x;
				//actionTouchCat.y = helperPoint.y;
				//actionTouchCat.scale = actionTouchCat.parent.scale;
				
			}
			
			
			var foodView:CatFoodView;
			for (i = 0; i < foodViewsContainer.numChildren; i++) 
			{
				foodView = foodViewsContainer.getChildAt(i) as CatFoodView;
				
				helperPoint = foodView.parent.localToGlobal(new Point(foodView.x, foodView.y));
				
				if (Point.distance(helperPoint, new Point(targetImage.x, targetImage.y)) < 99*layoutHelper.independentScaleFromEtalonMin)
				{
					if (lastHelperView != foodView) {
						lastHelperView = foodView;
						EffectsManager.jump(foodView, 2, layoutHelper.specialScale, layoutHelper.specialScale*1.13, 0.07, 0.07, 0.08, 0, 0, 0.8, true);
					}
					
					actionTouchCat.cat.targetCat = -1;
					actionTouchCat.cat.role = CatRole.HARVESTER;
					//actionTouchCat.showRoleImage(actionTouchCat.cat.role);
					//handleCatViewStateByRole(actionTouchCat);
					
					showTargetCursor(new Point(helperPoint.x, helperPoint.y + 60 /** layoutHelper.specialScale*/), false);
					
					return;
				}
			}
			
			/*trace(' asd as', targetAnim.x, targetAnim.y);
			targetGlow.x = targetAnim.x;
			targetGlow.y = targetAnim.y - 60*layoutHelper.specialScale;
			topLayer.addChildAt(targetGlow, 0);  */
			
			hideEnemyActionHelpers();
			
			helpersActive = false;		
		}
		
		private function showTargetCursor(point:Point = null, showTargetGlow:Boolean = false ):void 
		{
			
			targetAnim.x = point ? point.x : Starling.current.nativeStage.mouseX;
			targetAnim.y = point ? point.y : Starling.current.nativeStage.mouseY;
			
			var childIndex:int = (FadeQuad.quad && FadeQuad.quad.parent) ? (topLayer.getChildIndex(FadeQuad.quad) + 1) : 1;
			if (childIndex < 0)
				childIndex = 0;
			
			//trace('kjhgf',childIndex);	
				
			if (!point)
				topLayer.addChild(targetAnim);
			else
				topLayer.addChildAt(targetAnim, childIndex);  
				
				
			topLayer.addChildAt(targetGlow, childIndex);  	
			targetGlow.x = targetAnim.x;
			targetGlow.y = targetAnim.y - 60/**layoutHelper.specialScale*/;	
				
			if(showTargetGlow) 	
				Starling.juggler.tween(targetGlow, 0.3, {alpha:1, transition:Transitions.LINEAR});
			else
				Starling.juggler.tween(targetGlow, 0.3, {alpha:0, transition:Transitions.LINEAR});
		}
		
		private function hideEnemyActionHelpers():void 
		{
			Starling.juggler.removeTweens(attackImage);
			TweenHelper.tween(attackImage, 0.1, {alpha:0, transition:Transitions.EASE_OUT});	
			
			Starling.juggler.removeTweens(defenceImage);
			TweenHelper.tween(defenceImage, 0.1, {alpha:0, transition:Transitions.EASE_OUT});	
		}
		
		private function showEnemyActionHelpers(catView:CatView, helperPoint:Point):void 
		{
			if (helpersActive) 
			{
				if (!Starling.juggler.containsTweens(attackImage)) {
					attackImage.x = helperPoint.x + 80*layoutHelper.independentScaleFromEtalonMin;
					attackImage.y = helperPoint.y - 110 * layoutHelper.independentScaleFromEtalonMin;
					defenceImage.x = helperPoint.x - 80*layoutHelper.independentScaleFromEtalonMin;
					defenceImage.y = helperPoint.y - 110*layoutHelper.independentScaleFromEtalonMin;
				}
				return;
			}
			
			helpersActive = true;	
				
			Starling.juggler.removeTweens(attackImage);
			TweenHelper.tween(attackImage, 0.1, {alpha:1, transition:Transitions.EASE_OUT});	
			
			attackImage.x = helperPoint.x + 80*layoutHelper.independentScaleFromEtalonMin;
			attackImage.y = helperPoint.y - 110*layoutHelper.independentScaleFromEtalonMin;
			topLayer.addChildAt(attackImage, topLayer.getChildIndex(targetImage) -1);
			
			Starling.juggler.removeTweens(defenceImage);
			TweenHelper.tween(defenceImage, 0.1, {alpha:1, transition:Transitions.EASE_OUT});	
			
			defenceImage.x = helperPoint.x - 80*layoutHelper.independentScaleFromEtalonMin;
			defenceImage.y = helperPoint.y - 110*layoutHelper.independentScaleFromEtalonMin;
			topLayer.addChildAt(defenceImage, topLayer.getChildIndex(targetImage)-1);
			
			
			
		}
		
			
		
		private function handler_touch(event:TouchEvent): void 
		{
		
			const touch:Touch = event.getTouch(Starling.current.stage);
			if (touch && touch.phase==TouchPhase.ENDED) 
			{
				
				if (actionTouchCat)
				{
					//TweenHelper.tween(actionTouchCat, 0.2, {delay:0.0, transition:Transitions.EASE_OUT, x:actionTouchCat.storedX_0, y:actionTouchCat.storedY_0, onComplete:childCatAtHomeLayer, onCompleteArgs:[actionTouchCat]});	
					
					refreshEnemyTargetMarks();
					//childCatAtHomeLayer(actionTouchCat);
				
					handleCatViewStateByRole(actionTouchCat);
					
					actionTouchCat = null;
					
					if (true) 
					{
						
					}
					else 
					{
						
					}
					
					TweenHelper.tween(targetImage, 0.4, {delay:0.0, transition:Transitions.EASE_OUT, alpha:0});	
					targetAnim.gotoAndStop(CatView.CURSOR_ANIM);
					TweenHelper.tween(targetAnim, 0.4, {delay:0.0, transition:Transitions.EASE_OUT, alpha:0});	
					TweenHelper.tween(targetGlow, 0.4, {delay:0.0, transition:Transitions.EASE_OUT, alpha:0});	
					
					FadeQuad.hide(0.2);
					removeEventListener(Event.ENTER_FRAME, hanler_enterFrame);
					
					hideEnemyActionHelpers();
					
			
					
					addChild(foodViewsContainer);
					addChild(playerCatViewsContainer);
					addChild(enemyCatViewsContainer);
					addChild(foodCoverImage);
					addChild(arrowsContainer);
					addChild(topLayer);
					addChild(roundResultsLabel);
					
					
				}
			}
			
			
			
			
		}
		
		private function handler_playerCatTriggered(event:Event):void 
		{
			return;
			
			/*var catView:CatView = event.target as CatView;
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
			
			refreshEnemyTargetMarks();*/
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
			/*for (i = 0; i < enemyCatsViews.length; i++) 
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
			*/
			
		
			
			var dottedLine:DottedLine;
			var startPoint:Point;
			var finishPoint:Point;
			for (i = 0; i < playerCatsViews.length; i++) 
			{
				playerCatView = playerCatsViews[i] as CatView;
				dottedLine = playerActionHelpersViews[i] as DottedLine;
				if (playerCatView.cat.active && playerCatView.cat.role == CatRole.FIGHTER || playerCatView.cat.role == CatRole.DEFENDER) 
				{
					catView = getCatById(enemyCatsViews, playerCatView.cat.targetCat);
					
					if (catView) 
					{
						startPoint = playerCatView.parent.localToGlobal(new Point(playerCatView.x, playerCatView.y));
						finishPoint = catView.parent.localToGlobal(new Point(catView.x, catView.y));
						//finishPoint.y += CatView.HEIGHT / 4;
						
						//dottedLine.x = finishPoint.x;
						//dottedLine.y = finishPoint.y;
						
						
						dottedLine.up = startPoint.x < finishPoint.x;//startPoint.y < finishPoint.y;
						
						//if(Math.abs(startPoint.x - finishPoint.x) > 40*layoutHelper.independentScaleFromEtalonMin)
							//finishPoint.x += (dottedLine.up ? 1 : -1)*CatView.WIDTH / 4;
						
						dottedLine.rect = new Rectangle(startPoint.x, startPoint.y, Math.abs(finishPoint.x-startPoint.x), finishPoint.y - startPoint.y);
					}
					else
					{
						dottedLine.rect = null;
					}
				}
				else if (playerCatView.cat.active && playerCatView.cat.role == CatRole.HARVESTER) 
				{
					var foodImage:CatFoodView = foodViewsContainer.getChildAt(0) as CatFoodView;
					
					startPoint = playerCatView.parent.localToGlobal(new Point(playerCatView.x, playerCatView.y));
					finishPoint = foodImage.parent.localToGlobal(new Point(foodImage.x, foodImage.y));
					//finishPoint.y += CatView.HEIGHT / 4;
					
					dottedLine.up = startPoint.x < finishPoint.x;
					
					//if(Math.abs(startPoint.x - finishPoint.x) > 40*layoutHelper.independentScaleFromEtalonMin)
						//finishPoint.x += (dottedLine.up ? 1 : -1)*CatView.WIDTH / 4;
					
					dottedLine.rect = new Rectangle(startPoint.x, startPoint.y, Math.abs(finishPoint.x-startPoint.x), finishPoint.y - startPoint.y);
				}
				else
				{
					dottedLine.rect = null;
				}
			
			}
		}
		
		private function dispatchReadyGoComplete():void 
		{
			dispatchEventWith(READY_GO_COMPLETE);
		}
		
		public var isHided:Boolean;
		
		public function hide():void 
		{
			isHided = true;
			
			if (gameUIPanel) {
				//gameUIPanel.reset();
				gameUIPanel.state = GameUIPanel.STATE_TO_RESULTS;
				//gameUIPanel.visible = false;
			}
			
			hideVSandStartButton();
			
			var i:int;
			var catView:CatView;
			for (i = 0; i < playerCatViewsContainer.numChildren; i++) 
			{
				catView = playerCatViewsContainer.getChildAt(i) as CatView;
				catView.defenderPositionId = -1;
				Starling.juggler.removeTweens(catView);
				Starling.juggler.tween(catView, 0.4, {delay:(i*0.05) + 0.2, transition:Transitions.EASE_OUT, x:(-layoutHelper.stageWidth/2 -CatView.WIDTH*pxScale - 80*layoutHelper.independentScaleFromEtalonMin)});
			}
			
			
			for (i = 0; i < enemyCatViewsContainer.numChildren; i++) 
			{
				catView = enemyCatViewsContainer.getChildAt(i) as CatView;
				catView.defenderPositionId = -1;
				Starling.juggler.removeTweens(catView);
				Starling.juggler.tween(catView, 0.4, {delay:(i*0.05) + 0.3, transition:Transitions.EASE_OUT_BACK, x:(layoutHelper.stageWidth/2 +CatView.WIDTH*pxScale + 110*layoutHelper.independentScaleFromEtalonMin)});
			}
			
			
			var foodImage:CatFoodView;
			for (i = 0; i < foodViewsContainer.numChildren; i++) 
			{
				foodImage = foodViewsContainer.getChildAt(i) as CatFoodView;
				Starling.juggler.tween(foodImage, 0.2, {delay:(i*0.05), alpha:0, transition:Transitions.EASE_OUT, y:(foodImage.y - 100)});
			}
			
			var dottedLine:DottedLine;
			for (i = 0; i < playerActionHelpersViews.length; i++) 
			{
				dottedLine = playerActionHelpersViews[i] as DottedLine;
				dottedLine.rect = null;
			}	
			
			FadeQuad.hide();
			
			roundResultsLabel.visible = false;
			
			foodCoverImage.visible = false;
			
			playerBar.visible =false;
			enemyBar.visible =false;
			foodInfo.visible =false;
		}
		
		
		private function startButton_triggeredHandler(e:Event):void 
		{
			gameManager.playerCatsSetted = true;
			
			if (gameManager.gameMode == GameManager.GAME_MODE_PVP)
			{
				// отправляем своих котов и блокируем юи
				
				var json:Object = {
				   id: 0,
				   session: gameManager.connectionManager.sessionId,
				   name: "round",
				   payload: 
				   {
					   playerId:Player.current.playerId,
					   gameId:gameManager.connectionManager.gameId,
					   pets:gameManager.catsModel.serializePlayerCats()
				   } 
				}
			
				ServerConnection.current.sendMessageNew(json);
				
				tryStartPvPRound();
			}
			else
			{
				gameManager.pvpEnemySetted = true;
				tryStartPvPRound();
			}
		}
		
		private function takeFood():void
		{
			var i:int;
			if (foodTaken)
				return;
			
			var columns:int = 4;	
			
			var foodImage:CatFoodView;
			var shiftX:int = 0//(-150 * Math.min(foodCount, columns-1) * layoutHelper.specialScale)/2;
			for (i = 0; i < /*foodCount*/1; i++) 
			{
				foodImage = new CatFoodView();
				foodImage.foodCount = foodCount;
				foodImage.scale = layoutHelper.specialScale;
				foodImage.x = shiftX + i % columns * 150 /** layoutHelper.specialScale*/;
				foodImage.alpha = 0;
				foodImage.y = -layoutHelper.stageHeight/2 - foodImage.height/2 + 104/**layoutHelper.independentScaleFromEtalonMin*/;
				foodImage.touchable = false;
					
				foodViewsContainer.addChild(foodImage);
				
				Starling.juggler.tween(foodImage, 0.5, {delay:(i*0.02) + 0.3, alpha:20, transition:Transitions.EASE_OUT_BACK, y:(Math.floor(i/columns)*95/** layoutHelper.specialScale*/)});
			}
			
			foodTaken = true;
			
		}
		
		private function hideVSandStartButton():void 
		{
			//Starling.juggler.tween(charV, 0.4, {transition:Transitions.EASE_OUT, x:charV.x - 50, alpha:0});
			//Starling.juggler.tween(charS, 0.4, {transition:Transitions.EASE_OUT, x:charV.x + 50, alpha:0});
			
			if(startButton.scale != 0)
				EffectsManager.scaleJumpDisappear(startButton);
		}
		
		public function nextFightAction():void 
		{
			if (isHided)
				return;
			
			var timeToNextAction:Number = 0.05;
			var actionTime:Number = 0;
			
			enemyStepPriority = !enemyStepPriority;
			
			
			actionTime = handleFighters(enemyStepPriority);
			if (actionTime > 0) {
				delayCallNextFightAction(actionTime + timeToNextAction);
				refreshEnemyTargetMarks();
				return;
			}
				
			actionTime = handleFighters(!enemyStepPriority);
			if (actionTime > 0) {
				delayCallNextFightAction(actionTime + timeToNextAction);
				refreshEnemyTargetMarks();
				return;
			}
			
			
			var foodView:CatFoodView = foodViewsContainer.numChildren > 0 ? (foodViewsContainer.getChildAt(0) as CatFoodView) : null;
			if (!foodView || foodView.foodCount <= 0)
			{
				initiateFightFinish();
				//gameScreen.backToLobby();
				return;
			}
			
			
			actionTime = handleHarvesters(enemyStepPriority);
			if (actionTime > 0) {
				delayCallNextFightAction(actionTime + timeToNextAction);
				refreshEnemyTargetMarks();
				return;
			}
			
			actionTime = handleHarvesters(!enemyStepPriority);
			if (actionTime > 0) {
				delayCallNextFightAction(actionTime + timeToNextAction);
				refreshEnemyTargetMarks();
				return;
			}
			
			
			
			if(!getAnyActiveRoundCats(playerCatsViews) && !getAnyActiveRoundCats(enemyCatsViews))
			{
				initiateFightFinish();
				//gameScreen.backToLobby();
				return;
			}
			
			Starling.juggler.delayCall(showNewStage, actionTime + timeToNextAction);
			//showNewStage();
		}
		
		private function initiateFightFinish():void 
		{
			roundInfoLabel.x = layoutHelper.stageWidth / 2;
			roundInfoLabel.y = layoutHelper.stageHeight / 2;
			roundInfoLabel.scale = 0;
			if(playerFish == enemyFish)
				roundInfoLabel.text = 'NO WINNERS! EQUAL SCORE!';
			else
				roundInfoLabel.text = playerFish > enemyFish ? 'YOU WIN!' : 'YOU LOOSE!';
			
			FadeQuad.show(topLayer, 0.2, 0.8, false, null);
			
			topLayer.addChild(roundInfoLabel);
			
			
			sendExitGame();
			
			TweenHelper.tween(roundInfoLabel, 0.5, {delay:0.3, transition:Transitions.EASE_OUT_BACK, scale:layoutHelper.independentScaleFromEtalonMin}).
				chain(roundInfoLabel, 0.3, {delay:1.5, transition:Transitions.EASE_OUT, scale:0, onStart:FadeQuad.hide, onComplete:gameScreen.backToLobby});	
				
		}
		
		
		public function sendExitGame():void 
		{
			if (exitGameSent)
				return;
			
			exitGameSent = true;	
				
			if (gameManager.gameMode == GameManager.GAME_MODE_PVP)
			{
				// я сделал метод exitGame, параметры gameId, playerId (edited)
				
				gameManager.connectionManager.sendExit();
			}
		}
		
		private function delayCallNextFightAction(time:Number):void 
		{
			Starling.juggler.delayCall(nextFightAction, time);
		}
		
		private function handleFighters(enemyTeamIsFirst:Boolean):Number
		{
			var actionTime:Number = 0;
			
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
					actionTime = showCatAction(catView_1, CatRole.FIGHTER, catView_2, CatRole.FIGHTER, true);
					catView_1.cat.active = false;
					catView_2.cat.active = false;
					return actionTime;
				}
				else
				{
					
					// свободный боец. есть ли на него конкретный защитник:
					catView_2 = getCatByRole(secondTeamCatViews, CatRole.DEFENDER, catView_1.cat.id);
					if (catView_2) 
					{
						actionTime = showCatAction(catView_1, CatRole.FIGHTER, catView_2, CatRole.DEFENDER);
						catView_1.cat.active = false;
						//catView_2.cat.active = false;
						
						return actionTime;
					}
					else
					{
						// идем свободно мочить кота:
						catView_2 = getCatById(secondTeamCatViews, catView_1.cat.targetCat);
						if (catView_2 && catView_2.cat.health > 0 /*&& catView_2.cat.active*/) 
						{
							actionTime = showCatAction(catView_1, CatRole.FIGHTER, catView_2, catView_2.cat.role);
							catView_1.cat.active = false;
							
							if(catView_2.cat.active)
								catView_2.cat.active = (catView_2.cat.role == CatRole.DEFENDER) || (catView_2.cat.role == CatRole.FIGHTER);
							
							return actionTime;
						}
					}
				}
			}
			
			return 0;
		}
		
		
		
		private function handleHarvesters(enemyTeamIsFirst:Boolean):Number
		{
			var actionTime:Number = 0;
			
			var catView_1:CatView;
			var catView_2:CatView;
			
			
			var foodView:CatFoodView = foodViewsContainer.numChildren > 0 ? (foodViewsContainer.getChildAt(0) as CatFoodView) : null;
			if (!foodView || foodView.foodCount <= 0)
				return 0;
			
			catView_1 = getCatByRole(enemyTeamIsFirst ? enemyCatsViews : playerCatsViews, CatRole.HARVESTER);
			if (catView_1) 
			{
				catView_2 = getCatByRole(enemyTeamIsFirst ? playerCatsViews : enemyCatsViews, CatRole.HARVESTER);
				if (catView_2)
				{
					// если есть сборщики по обе стороны сталкиваем их лбами:
					actionTime = showCatAction(catView_1, CatRole.HARVESTER, catView_2, CatRole.HARVESTER);
					catView_1.cat.active = false;
					catView_2.cat.active = false;
				}
				else
				{
					actionTime = showCatHarverst(catView_1, Math.floor(foodViewsContainer.numChildren * Math.random()));
					catView_1.cat.active = false;
					
					if (playerCatsViews.indexOf(catView_1) != -1) 
					{
						harvestFood(1);
						playerFish++;
					}
					if (enemyCatsViews.indexOf(catView_1) != -1) 
					{
						enemyFish++;
					}
					Starling.juggler.delayCall(refreshResultsLabel, 2);
					
				}
					
				return actionTime;	
				
			}
			
			return 0;
		}
		
		private function showNewStage():void 
		{
			gameManager.playerCatsSetted = false;
			gameManager.pvpEnemySetted = false;
			
			enemyCatViewsContainer.touchable = true;
			playerCatViewsContainer.touchable = true;
			
			EffectsManager.scaleJumpAppearBase(startButton, layoutHelper.specialScale);
			
			
			if (gameManager.gameMode != GameManager.GAME_MODE_PVP)
				TutorialManager.refreshCatTargets(gameManager.enemyCats, gameManager.playerCats);
			
				
				
			var i:int;
			var catView:CatView;
			for (i = 0; i < playerCatsViews.length; i++) 
			{
				catView = playerCatsViews[i] as CatView;
				catView.cat.active = true;
				catView.alpha = 1;
				catView.fishVisible = false;
				
				/*if (catView.cat.role == CatRole.FIGHTER) {
					catView.cat.targetCat = (gameManager.enemyCats[i] as CatModel).id;
				}
				else
				{
					catView.cat.targetCat = -1;
				}*/
				
				//catView.showRoleImage(catView.cat.role);
				
				if(catView.cat.health > 0)
					handleCatViewStateByRole(catView);
				else
					catView.setState(CatView.STATE_DEAD);
			}
			
			for (i = 0; i < enemyCatsViews.length; i++) 
			{
				catView = enemyCatsViews[i] as CatView;
				catView.cat.active = true;
				catView.alpha = 1;
				catView.fishVisible = false;
				
				
				if (catView.cat.health <= 0) {
					setCatState(catView, CatView.STATE_DEAD);
				}
				else 
				{
					setCatState(catView, CatView.STATE_IDLE);
				}	
			}
			
			
			
			
			roundInfoLabel.x = layoutHelper.stageWidth / 2;
			roundInfoLabel.y = layoutHelper.stageHeight / 2;
			roundInfoLabel.scale = 0;
			roundInfoLabel.text = 'NEXT ROUND!\nPREPARE YOUR CATS!';
			
			FadeQuad.show(topLayer, 0.2, 0.8, false, null);
			
			addChild(topLayer);
			topLayer.addChild(roundInfoLabel);
			
			TweenHelper.tween(roundInfoLabel, 0.5, {delay:0.3, transition:Transitions.EASE_OUT_BACK, scale:layoutHelper.independentScaleFromEtalonMin}).
				chain(roundInfoLabel, 0.3, {delay:1.5, transition:Transitions.EASE_OUT, scale:0, onStart:FadeQuad.hide});	
				
			
			showEnemyRoles();
			
			refreshEnemyTargetMarks();
			
			refreshResultsLabel();
		}
		
		private function showCatAction(catView_1:CatView, role_1:String, catView_2:CatView, role_2:String, sameTargets:Boolean = false):Number
		{
			var actionTime:Number = 0;
			var actionTime_1:Number = 0;
			var actionTime_2:Number = 0;
			
			// Чтобы тот кто мордой на нас всегда был слева:
			/*if (!catView_1.isLeft) 
			{
				var storedCat:CatView = catView_1;
				var storedRole:String = role_1;
				
				catView_1 = catView_2;
				role_1 = role_2;
				
				catView_2 = storedCat;
				role_2 = storedRole;
			}*/
			
			//FadeQuad.show(topLayer, 0.2, 0.7, false, null);
			var point_0:Point;
			var point_1:Point;
			
			var time_0:Number = 0;
			var time_1:Number = 0;
			var time_2:Number = 0;
			
			
			var helperPoint:Point;
			var meetPoint:Point;
			
			var foodImage:CatFoodView = foodViewsContainer.getChildAt(0) as CatFoodView;
			var foodPoint:Point = foodImage.parent.localToGlobal(new Point(foodImage.x, foodImage.y));
			
			helperPoint = catView_1.parent.localToGlobal(new Point(catView_1.x, catView_1.y));
			catView_1.refreshStoreds();
			catView_1.x = helperPoint.x;
			catView_1.y = helperPoint.y;
			catView_1.scale = getCatScale(catView_1.index, catView_1.parent.scale);//catView_1.parent.scale;
			catView_1.storedX_0 = catView_1.x;
			catView_1.storedY_0 = catView_1.y;
			topLayer.addChild(catView_1);
			
			helperPoint = catView_2.parent.localToGlobal(new Point(catView_2.x, catView_2.y));
			catView_2.refreshStoreds();
			catView_2.x = helperPoint.x;
			catView_2.y = helperPoint.y;
			catView_2.scale = getCatScale(catView_2.index, catView_2.parent.scale);
			catView_2.storedX_0 = catView_2.x;
			catView_2.storedY_0 = catView_2.y;
			//catView_2.x = catView_2.x + catView_2.parent.x;
			//catView_2.y = catView_2.y + catView_2.parent.y;
			topLayer.addChild(catView_2);
			
			catView_1.showRoleImage(null);
			catView_1.fightMarks = 0;
			
			catView_2.showRoleImage(null);
			catView_2.fightMarks = 0;
			
			
			//catView_1.setState(CatView.STATE_WALK);
			//catView_2.setState(CatView.STATE_WALK);
			
			if (catView_1.index == 0)
				meetPoint = new Point(layoutHelper.stageWidth / 2, layoutHelper.stageHeight / 2 - 100/**layoutHelper.specialScale*/);
			else
				meetPoint = new Point(layoutHelper.stageWidth / 2, layoutHelper.stageHeight / 2 + 100 /** layoutHelper.specialScale*/);
					
					
			var catCoef_1:int = catView_1.isLeft ? ( -1) : 1;
			var catCoef_2:int = catView_2.isLeft ? (-1) : 1;
				
			if (role_1 == role_2 && role_1 == CatRole.FIGHTER) 
			{
				point_0 = new Point((meetPoint.x + catCoef_1*70*layoutHelper.specialScale), meetPoint.y);
				time_0 = getPathTime(catView_1.x, catView_1.y, point_0.x, point_0.y);
				TweenHelper.tween(catView_1, time_0, {delay:0.3, x:point_0.x, y:point_0.y, onStart:catView_1.setState, onStartArgs:[CatView.STATE_WALK], onComplete:catView_1.setState, onCompleteArgs:[CatView.STATE_FIGHT_STANDOFF]}).
					chain(catView_1, time_0, {delay:1.3, x:catView_1.storedX_0, y:catView_1.storedY_0, onComplete:childCatAtHomeLayer, onCompleteArgs:[catView_1, CatView.STATE_IDLE], onStart:catView_1.setState, onStartArgs:[CatView.STATE_WALK, true]});
					
				TweenHelper.tween(catView_2, time_0, {delay:0.3, x:(meetPoint.x + catCoef_2*70*layoutHelper.specialScale), y:meetPoint.y, onStart:catView_2.setState, onStartArgs:[CatView.STATE_WALK], onComplete:catView_2.setState, onCompleteArgs:[CatView.STATE_FIGHT_STANDOFF]}).
					chain(catView_2, time_0, {delay:1.3, x:catView_2.storedX_0, y:catView_2.storedY_0, onComplete:childCatAtHomeLayer, onCompleteArgs:[catView_2, CatView.STATE_IDLE], onStart:catView_2.setState, onStartArgs:[CatView.STATE_WALK, true]});	
					
				actionTime = time_0*2 + 0.3 + 1.3;
			}
			else if (role_1 == role_2 && role_1 == CatRole.HARVESTER) 
			{
				addChild(foodCoverImage);
				
				foodPoint = new Point(foodPoint.x-36*layoutHelper.specialScale, foodPoint.y - 115*layoutHelper.specialScale);
				
				point_0 = new Point((foodPoint.x + (catView_1.isLeft ? -14 : 117)*layoutHelper.specialScale), foodPoint.y);
				time_0 = getPathTime(catView_1.x, catView_1.y, point_0.x, point_0.y);
				TweenHelper.tween(catView_1, time_0, {delay:0.3, transition:Transitions.LINEAR, x:point_0.x, y:point_0.y, onStart:catView_1.setState, onStartArgs:[CatView.STATE_WALK], onComplete:catView_1.setState, onCompleteArgs:[CatView.STATE_HARVEST_STANDOFF]}).
					chain(catView_1, time_0, {delay:1.5, transition:Transitions.LINEAR, x:catView_1.storedX_0, y:catView_1.storedY_0, onComplete:childCatAtHomeLayer, onCompleteArgs:[catView_1], onStart:catView_1.setState, onStartArgs:[CatView.STATE_WALK, true]});
					
				point_0 = new Point((foodPoint.x + (catView_2.isLeft ? -14 : 117)*layoutHelper.specialScale), foodPoint.y);
				TweenHelper.tween(catView_2, time_0, {delay:0.3, transition:Transitions.LINEAR, x:point_0.x, y:point_0.y, onStart:catView_2.setState, onStartArgs:[CatView.STATE_WALK], onComplete:catView_2.setState, onCompleteArgs:[CatView.STATE_HARVEST_STANDOFF]}).
					chain(catView_2, time_0, {delay:1.5, transition:Transitions.LINEAR, x:catView_2.storedX_0, y:catView_2.storedY_0, onComplete:childCatAtHomeLayer, onCompleteArgs:[catView_2], onStart:catView_2.setState, onStartArgs:[CatView.STATE_WALK, true]});	
			
				actionTime = time_0*2 + 0.3 + 1.5;
			}
			else
			{
				if (role_1 == CatRole.FIGHTER) 
				{
					if (role_2 == CatRole.HARVESTER) 
					{
						foodPoint = new Point(foodPoint.x - 36 * layoutHelper.specialScale, foodPoint.y - 115 * layoutHelper.specialScale);
						meetPoint = new Point(foodPoint.x, foodPoint.y + (catView_2.index == 0 ? (-40) : 170)*layoutHelper.specialScale);
					
						point_0 = new Point(foodPoint.x + (catView_2.isLeft ? -14 : 100) * layoutHelper.specialScale, foodPoint.y);
						time_0 = getPathTime(catView_2.x, catView_2.y, point_0.x, point_0.y);
						time_1 = getPathTime(point_0.x, point_0.y, point_0.x, meetPoint.y);
						
						TweenHelper.tween(catView_2, time_0, {delay:0.0, x:point_0.x, y:foodPoint.y, onStart:catView_2.setState, scale:(getCatScale(1, catView_2.storedParent.scale)), onStartArgs:[CatView.STATE_WALK], onComplete:foodImage.showFoodDrop, onCompleteArgs:[1]}).
							chain(catView_2, 1.0, {delay:0.0, onStart:catView_2.setState, onStartArgs:[CatView.STATE_HARVEST]}).
							chain(catView_2, time_1, {delay:0.0, /*x:meetPoint.x,*/ y:meetPoint.y, onStart:catView_2.setState, onStartArgs:[CatView.STATE_WALK_HARVEST]}).
							chain(catView_2, 1.0, {delay:0.0, onStart:catView_2.setState, onStartArgs:[CatView.STATE_DAMAGE]/*, onComplete:foodImage.setFoodCount, onCompleteArgs:[foodImage.foodCount]*/}).
							chain(catView_2, getPathTime(point_0.x, meetPoint.y, catView_2.storedX_0, catView_2.storedY_0), {delay:0.0, x:catView_2.storedX_0, y:catView_2.storedY_0, scale:(getCatScale(catView_2.index, catView_2.storedParent.scale)), onComplete:childCatAtHomeLayer, onCompleteArgs:[catView_2, CatView.STATE_DEAD], onStart:catView_2.setState, onStartArgs:[CatView.STATE_CONFUSE]})//.
							//chain(catView_2, 0.1, {delay:0.0, onStart:catView_2.setState, onStartArgs:[CatView.STATE_DEAD]})
						
						actionTime_2 = time_0 + 1.0 + time_1 + 1.0 + getPathTime(point_0.x, meetPoint.y, catView_2.storedX_0, catView_2.storedY_0);	
							
						point_0 = new Point(foodPoint.x + (catView_1.isLeft ? 0 : (100*layoutHelper.specialScale))*layoutHelper.specialScale, meetPoint.y);
						time_2 = getPathTime(catView_1.x, catView_1.y, point_0.x, point_0.y);
						
						TweenHelper.tween(catView_1, time_2, {delay:Math.max(0, time_0 + 1 + time_1 - time_2), x:point_0.x, y:point_0.y, scale:(getCatScale(1, catView_1.storedParent.scale)), onComplete:catView_1.setState, onCompleteArgs:[CatView.STATE_FIGHT], onStart:catView_1.setState, onStartArgs:[CatView.STATE_WALK]}).
							chain(catView_1, getPathTime(point_0.x, point_0.y, catView_1.storedX_0, catView_1.storedY_0), {delay:0.6, x:catView_1.storedX_0, y:catView_1.storedY_0, scale:(getCatScale(catView_1.index, catView_1.storedParent.scale)), onStart:catView_1.setState, onStartArgs:[CatView.STATE_WALK, true], onComplete:childCatAtHomeLayer, onCompleteArgs:[catView_1, CatView.STATE_IDLE]})
						
						actionTime_1 = time_2 + Math.max(0, time_0 + 1 + time_1 - time_2) + 0.6 + getPathTime(point_0.x, point_0.y, catView_1.storedX_0, catView_1.storedY_0);
						
							
						Starling.juggler.delayCall(catView_1.refreshHP, 2.3);
						Starling.juggler.delayCall(catView_2.refreshHP, time_0 + 1 + time_1 + 0.2);	
						
						
						actionTime = Math.max(actionTime_1, actionTime_2);
					}
					if (role_2 == CatRole.DEFENDER) 
					{
						point_0 = new Point(meetPoint.x + (catView_1.isLeft ? -60 : 60) * layoutHelper.specialScale, meetPoint.y);
						time_0 = getPathTime(catView_1.x, catView_1.y, point_0.x, point_0.y);
						
						TweenHelper.tween(catView_1, time_0, {x:point_0.x, y:point_0.y, scale:(getCatScale(1, catView_1.storedParent.scale)), onComplete:catView_1.setState, onCompleteArgs:[CatView.STATE_DAMAGE], onStart:catView_1.setState, onStartArgs:[CatView.STATE_WALK]}).
							chain(catView_1, getPathTime(point_0.x, point_0.y, catView_1.storedX_0, catView_1.storedY_0), {delay:0.6, x:catView_1.storedX_0, y:catView_1.storedY_0, scale:(getCatScale(catView_1.index, catView_1.storedParent.scale)), onStart:catView_1.setState, onStartArgs:[CatView.STATE_CONFUSE, true], onComplete:childCatAtHomeLayer, onCompleteArgs:[catView_1, CatView.STATE_DEAD]})
						
						actionTime_1 = 	time_0 + 0.6 + getPathTime(point_0.x, point_0.y, catView_1.storedX_0, catView_1.storedY_0);
							
						
						point_0 = new Point(meetPoint.x + (catView_2.isLeft ? -60 : 60) * layoutHelper.specialScale, meetPoint.y);
						time_1 = getPathTime(catView_2.x, catView_2.y, point_0.x, point_0.y);
						
						if (time_1 > time_0)
							time_1 = getPathTime(catView_2.x, catView_2.y, point_0.x, point_0.y, 200);
						
						TweenHelper.tween(catView_2, time_1, {delay:Math.max(0, time_0 - time_1), x:point_0.x, y:point_0.y, scale:(getCatScale(1, catView_2.storedParent.scale)), onComplete:catView_2.setState, onCompleteArgs:[CatView.STATE_FIGHT], onStart:catView_2.setState, onStartArgs:[CatView.STATE_WALK]}).
							chain(catView_2, getPathTime(point_0.x, point_0.y, catView_2.storedX_0, catView_2.storedY_0), {delay:0.6, x:catView_2.storedX_0, y:catView_2.storedY_0, scale:(getCatScale(catView_2.index, catView_2.storedParent.scale)), onStart:catView_2.setState, onStartArgs:[CatView.STATE_WALK, true], onComplete:childCatAtHomeLayer, onCompleteArgs:[catView_2, CatView.STATE_DEFENCE, catView_2.defenderPositionId]})
							
						actionTime_2 = 	time_1 + Math.max(0, time_0 - time_1) + 0.6 + getPathTime(point_0.x, point_0.y, catView_2.storedX_0, catView_2.storedY_0);
							
						Starling.juggler.delayCall(catView_1.refreshHP, time_0);
						Starling.juggler.delayCall(catView_2.refreshHP, time_0);	
						
						
						actionTime = Math.max(actionTime_1, actionTime_2);
					}
				}
				else
				{
					TweenHelper.tween(catView_1, 1.4, {delay:0.3, transition:Transitions.LINEAR, x:(meetPoint.x - 45*layoutHelper.specialScale), y:meetPoint.y, onComplete:catView_1.setState, onCompleteArgs:[CatRole.getStateByRole(role_1), true]}).
						chain(catView_1, 1.5, {delay:0, transition:Transitions.EASE_OUT, onComplete:catView_1.setState, onCompleteArgs:[CatView.STATE_WALK]}).
						chain(catView_1, 1.4, {transition:Transitions.LINEAR, x:catView_1.storedX_0, y:catView_1.storedY_0, onComplete:childCatAtHomeLayer, onCompleteArgs:[catView_1], onStart:FadeQuad.hide});
				
					TweenHelper.tween(catView_2, 1.4, {delay:0.3, transition:Transitions.LINEAR, x:(meetPoint.x + 50*layoutHelper.specialScale), y:meetPoint.y, onComplete:catView_2.setState, onCompleteArgs:[CatRole.getStateByRole(role_2)]}).
						chain(catView_2, 1.5, {delay:0, transition:Transitions.EASE_OUT}).
						chain(catView_2, 0.4, {transition:Transitions.LINEAR, x:catView_2.storedX_0, y:catView_2.storedY_0, onComplete:childCatAtHomeLayer, onCompleteArgs:[catView_2]});	
			
					actionTime = 0.3 + 1.4 + 1.4 + 1.5;	
						
					Starling.juggler.delayCall(catView_1.refreshHP, 2.3);
					Starling.juggler.delayCall(catView_2.refreshHP, 2.3);		
				}
				
			}
				
				
			particleEffect.x = meetPoint.x;
			particleEffect.y = meetPoint.y;
			//topLayer.addChild(particleEffect);
			//Starling.juggler.delayCall(particleEffect.play, 1.7, 1000, 70, 0);
			
			
			
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
			
			return actionTime;
		}
		
		private function getPathTime(startX:int, startY:int, finishX:int, finishY:int, speed:Number = 100):Number
		{
			speed *= layoutHelper.specialScale;
			return Point.distance(new Point(startX, startY), new Point(finishX, finishY))/speed;
		}
		
		private function showCatHarverst(catView_1:CatView, foodIndex:int):Number
		{
			//FadeQuad.show(topLayer, 0.2, 0.7, false, null);
			var actionTime:Number = 0;
			
			var helperPoint:Point;
			
			helperPoint = catView_1.parent.localToGlobal(new Point(catView_1.x, catView_1.y));
			catView_1.refreshStoreds();
			catView_1.x = helperPoint.x;
			catView_1.y = helperPoint.y;
			catView_1.scale = catView_1.parent.scale;
			catView_1.storedX_0 = catView_1.x;
			catView_1.storedY_0 = catView_1.y;
			topLayer.addChild(catView_1);
			
			addChild(foodCoverImage);
			
			var foodImage:CatFoodView = foodViewsContainer.getChildAt(foodIndex) as CatFoodView;
			
			catView_1.showRoleImage(null);
			catView_1.fightMarks = 0;
			
			var foodPoint:Point = foodImage.parent.localToGlobal(new Point(foodImage.x, foodImage.y));
			foodPoint = new Point(foodPoint.x-36*layoutHelper.specialScale, foodPoint.y - 115*layoutHelper.specialScale);
			
			catView_1.setState(CatView.STATE_WALK);
			
			
			var targetPoint:Point =  new Point((foodPoint.x + (catView_1.isLeft ? -14 : 100)*layoutHelper.specialScale), foodPoint.y);
			var timeToFood:Number = getPathTime(catView_1.x, catView_1.y, targetPoint.x, targetPoint.y, 100);
			
			TweenHelper.tween(catView_1, timeToFood, {delay:0.3, transition:Transitions.LINEAR, scale:getCatScale(1, catView_1.storedParent.scale), x:targetPoint.x, y:targetPoint.y, onComplete:foodImage.setFoodCount, onCompleteArgs:[foodImage.foodCount - 1]}).
				chain(catView_1, 1.4, {delay:0.0, transition:Transitions.LINEAR, onStart:catView_1.setState, onStartArgs:[CatView.STATE_HARVEST]}).
				chain(catView_1, timeToFood, {delay:0.0, scale:(getCatScale(catView_1.index, catView_1.storedParent.scale)), transition:Transitions.LINEAR, x:catView_1.storedX_0, y:catView_1.storedY_0, onComplete:childCatAtHomeLayer, onCompleteArgs:[catView_1], onStart:catView_1.setState, onStartArgs:[CatView.STATE_WALK_HARVEST, true]});
			
				
			actionTime = 0.3 + timeToFood + 1.4 + timeToFood;
			
			return actionTime;
		}
		
		private function harvestFood(count:int):void
		{
			Player.current.reservedCashCount += count;
			Player.current.updateCashCount(count, "debug");
			
			Game.connectionManager.sendPlayerUpdateMessage();	
			
			new UpdateLobbyBarsTrueValue(0.5).execute();
		}
		
		private function childCatAtHomeLayer(catView:CatView, catState:String = 'STATE_IDLE', frame:int = 0):void
		{
			catView.storedParent.addChild(catView);
			catView.x = catView.storedX;
			catView.y = catView.storedY;
			catView.scale = catView.storedScale;
			
			catView.setState(catState, false, false, frame);
			
			//FadeQuad.hide();
			refreshEnemyTargetMarks();
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
		
		private var playerFish:int;
		private var enemyFish:int;
		
		public function tryStartPvPRound():void
		{
			var i:int;
			var catView:CatView;
			
			if (gameManager.playerCatsSetted)
			{
				hideVSandStartButton();
				enemyCatViewsContainer.touchable = false;
				playerCatViewsContainer.touchable = false;

				for (i = 0; i < playerCatsViews.length; i++) 
				{
					(playerCatsViews[i] as CatView).showSelected = false;
				}
			}
			else
			{
				refreshResultsLabel();
				return;
			}
			
			
			if (gameManager.pvpEnemySetted)
			{
				for (i = 0; i < enemyCatsViews.length; i++) 
				{
					catView = enemyCatsViews[i] as CatView;
					
					if (catView.cat.health > 0) 
						handleCatViewStateByRole(catView);
				}
				
				Starling.juggler.delayCall(nextFightAction, 2.2);
			}
			else
			{
				refreshResultsLabel();
				return;
			}
			
			
			refreshResultsLabel();
		}
		
		private function refreshResultsLabel():void 
		{
			if (gameManager.gameMode == GameManager.GAME_MODE_PVP)
			{
				if (gameManager.pvpEnemySetted && gameManager.playerCatsSetted)
				{
					roundResultsLabel.text = ""//"<font color='#ffffff'> Player fish: " + playerFish.toString() + ',</font> Enemy fish:' + enemyFish.toString();
				}
				else if (gameManager.playerCatsSetted)
				{
					roundResultsLabel.text = "Wait for enemy start ...";
				}
				else if (gameManager.pvpEnemySetted)
				{
					roundResultsLabel.text = "Enemy ready and wait for you";
				}
				else
				{
					roundResultsLabel.text = "wait";
				}
			}
			else
			{
				roundResultsLabel.text = ""//"<font color='#ffffff'> Player fish: " + playerFish.toString() + ',</font> Enemy fish:' + enemyFish.toString();
			}
			
			
			playerBar.setNewValue(playerFish);
			enemyBar.setNewValue(enemyFish);
			
			var foodView:CatFoodView = foodViewsContainer.numChildren > 0 ? (foodViewsContainer.getChildAt(0) as CatFoodView) : null;
			foodInfo.setValue(foodView ? foodView.foodCount : 0);
			
		
		}
		
		
		public function handleExit(text:String):void 
		{
			var i:int;
			var catView:CatView;
			for (i = 0; i < playerCatViewsContainer.numChildren; i++) 
			{
				catView = playerCatViewsContainer.getChildAt(i) as CatView;
				catView.defenderPositionId = -1;
				catView.cat.active = false;
				Starling.juggler.removeTweens(catView);
			}
			
			for (i = 0; i < enemyCatViewsContainer.numChildren; i++) 
			{
				catView = enemyCatViewsContainer.getChildAt(i) as CatView;
				catView.defenderPositionId = -1;
				catView.cat.active = false;
				Starling.juggler.removeTweens(catView);
			}
			
			
			FadeQuad.show(topLayer, 0.2, 0.8, false, null);
			
			//Starling.juggler.delayCall(particleEffect.play, 1.7, 1000, 70, 0);
			
			
			roundInfoLabel.x = layoutHelper.stageWidth / 2;
			roundInfoLabel.y = layoutHelper.stageHeight / 2;
			roundInfoLabel.scale = 0;
			roundInfoLabel.text = text;
			
			FadeQuad.show(topLayer, 0.2, 0.8, false, null);
			
			addChild(topLayer);
			topLayer.addChild(roundInfoLabel);
			
			TweenHelper.tween(roundInfoLabel, 0.5, {delay:0.3, transition:Transitions.EASE_OUT_BACK, scale:layoutHelper.independentScaleFromEtalonMin}).
				chain(roundInfoLabel, 0.3, {delay:3, transition:Transitions.EASE_OUT, scale:0, onStart:FadeQuad.hide, onComplete:gameScreen.backToLobby});		
			
				
				
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
			exitGameSent = false;
			isHided = false;
			
			playerFish = 0;
			enemyFish = 0;
			refreshResultsLabel();
			
			DelayCallUtils.cleanBundle(DELAY_CALL_GAME_UI_BUNDLE);
			
			gameManager.playerCatsSetted = false;
			gameManager.pvpEnemySetted = false;
			
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
import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import flash.geom.Rectangle;
import starling.display.Image;
import starling.display.Sprite;

class FoodInfo extends Sprite {
	
	public function FoodInfo ()
	{
		var mBase:Image = new Image(AtlasAsset.CommonAtlas.getTexture("buttons/dark_blue"));
		mBase.scale9Grid = new Rectangle(13 , 13, 2, 2);
		mBase.width = 100*layoutHelper.specialScale;
		mBase.height = 100*layoutHelper.specialScale;
		mBase.pivotX = 13;
		mBase.pivotY = 13;
		addChild(mBase);
		
		var foodImage:Image = new Image(AtlasAsset.CommonAtlas.getTexture('cats/trash_01'));
		foodImage.alignPivot();
		foodImage.scale = 0.33;
		//foodImage.x = shiftX + i % columns * 150 * foodImageScale;
		//foodImage.alpha = 0;
		foodImage.y = -23*layoutHelper.specialScale;
		touchable = false;
		addChild(foodImage);
		
		var foodCoverImage:Image = new Image(AtlasAsset.CommonAtlas.getTexture('cats/trash_02'));
		foodCoverImage.alignPivot();
		foodCoverImage.scale = 0.33;
		foodCoverImage.touchable = false;
		foodCoverImage.y = -48*layoutHelper.specialScale;
		addChild(foodCoverImage);
		
		roundResultsLabel = new XTextField(100*pxScale*layoutHelper.specialScale, 60*pxScale*layoutHelper.specialScale, XTextFieldStyle.houseHolidaySans(50*layoutHelper.specialScale, 0xFFFFFF), '');
		roundResultsLabel.touchable = false;
		roundResultsLabel.y = 30*layoutHelper.specialScale;
		roundResultsLabel.alignPivot();
		addChild(roundResultsLabel);	
	}
	
	public var roundResultsLabel: XTextField;
	
	public function setValue(value:int):void
	{
		roundResultsLabel.text = value.toString();
	}
}