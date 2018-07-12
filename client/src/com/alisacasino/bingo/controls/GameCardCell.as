package com.alisacasino.bingo.controls
{
	import by.blooddy.crypto.image.palette.IPalette;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.assets.loading.GAFClipWrapper;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.components.effects.SquareTweenLines;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.game.DaubStreakData;
	import com.alisacasino.bingo.models.powerups.Minigame;
	import com.alisacasino.bingo.models.powerups.Minigame;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.powerups.PowerupDropTweenStyle;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.models.roomClasses.RoomType;
	import com.alisacasino.bingo.protocol.PowerupType;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.gameScreenClasses.CellDaubEffect;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.UIUtils;
	import com.alisacasino.bingo.utils.tweens.BezierTween;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	import starling.animation.Tween;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;
	import starling.utils.TweenHelper;
	
	import flash.geom.Rectangle;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GameCardCell
	{
		private var mSoundManager:SoundManager = SoundManager.instance;
		private var mRoom:Room = Room.current;
		public var index:int;
		public var horisontalIndex:int;
		public var verticalIndex:int;
		private var _number:uint;
		private var cellWidth:int;
		private var cellHeight:int;
		private var centerX:Number;
		private var centerY:Number;
		private var numberShiftX:int;
		private var numberShiftY:int;
		public var numberLabel:XTextField;
		private var dropDownImage:Image;
		private var dropDownShadow:Image;
		private var isTopCell:Boolean;
		
		private var _marked:Boolean;
		private var _daubed:Boolean;
		
		public var activePowerup:String;
		public var minigameDrop:Minigame;
		public var powerupQuantity:int;
		public var powerupString:String;
		
		private var daubHintAnimation:AnimationContainer;
		
		private var x2daubFlame:X2DaubFlame;
		
		private var gameCard:GameCard;
		public var position:Point;
		private var powerupImage:Image;
		private var powerupImageGray:Image;
		
		private var x2FinishTimestamp:uint;
		
		private var blinkMarkedCount:int;
		
		public function GameCardCell(index:int, number:uint, gameCard:GameCard, position:Point, cellWidth:Number, cellHeight:Number, numberShiftX:int, numberShiftY:int)
		{
			this.index = index;
			_number = number;
			this.gameCard = gameCard;
			this.position = position;
			this.cellWidth = cellWidth;
			this.cellHeight = cellHeight;
			this.numberShiftX = numberShiftX;
			this.numberShiftY = numberShiftY;
			
			if (index >= 12)
				index++;
		
			horisontalIndex = index % 5;
			verticalIndex = Math.floor(index / 5);
			
			isTopCell = verticalIndex == 0;
			
			centerX = position.x + cellWidth / 2;
			centerY = position.y + cellHeight / 2;
		}
		
		public function createCellNumber(disposePrevious:Boolean, markedStyle:Boolean):void
		{
			if (disposePrevious && numberLabel) {
				numberLabel.removeFromParent();
				numberLabel.dispose();
				numberLabel = null;
			}
			
			if (numberLabel)
				return;
				
			numberLabel = new XTextField(cellWidth, cellHeight, markedStyle ? gameManager.skinningData.dauberSkin.markedCellTextStyle : gameManager.skinningData.cardSkin.cellTextStyle, String(_number));
		//XTextFieldStyle.CardNumberMarkedTextFieldStyle XTextFieldStyle.CardNumberTextFieldStyle
			//numberLabel.redraw();
			numberLabel.batchable = true;
			//numberLabel.border = true;;
			numberLabel.alignPivot();
			numberLabel.x = numberLabelPositionX;
			numberLabel.y = numberLabelPositionY;
			//numberLabel.visible = false;
			gameCard.cellLayerTextFields.addChild(numberLabel);
		}	
		
		public function get number():uint
		{
			return _number;
		}
		
		public function get numberLabelPositionX():Number {
			return position.x + cellWidth / 2 + numberShiftX;
		}
		
		public function get numberLabelPositionY():Number {
			return position.y + cellHeight / 2 + numberShiftY;
		}
		
		public function get marked():Boolean
		{
			return _marked;
		}
		
		public function set marked(value:Boolean):void
		{
			if (_marked == value)
				return;
			
			_marked = value;
			
			blinkMarkedCount = 0;
			
			createCellNumber(true, _marked);
			gameCard.refreshDaubMark(this, _marked);
		}
		
		public function disableMarked():void
		{
			if (!_marked)
				return;
			
			//_marked = false;
			
			blinkMarkedCount = 4;
			
			Starling.juggler.delayCall(blinkMarked, 0.8, 0.13);
			//blinkMarked(0.9);
		}
		
		private function blinkMarked(delay:Number):void 
		{
			if(blinkMarkedCount-- > 0)
				Starling.juggler.delayCall(blinkMarked, delay, 0.13);
			else 
				_marked = false;
				
			var markedStyle:Boolean = blinkMarkedCount % 2 == 0;
			
			createCellNumber(true, markedStyle);
			gameCard.refreshDaubMark(this, markedStyle, false);
		}
		
		public function get daubed():Boolean
		{
			return _daubed;
		}
		
		public function set daubed(value:Boolean):void
		{
			_daubed = value;
		}

		public function setCellSize(position:Point, cellWidth:Number, cellHeight:Number, numberShiftX:int, numberShiftY:int):void
		{
			this.position = position;
			this.cellWidth = cellWidth;
			this.cellHeight = cellHeight;
			
			numberLabel.width = cellWidth;
			numberLabel.height = cellHeight;
			numberLabel.alignPivot();
			
			centerX = position.x + cellWidth / 2;
			centerY = position.y + cellHeight / 2;
			
			numberLabel.x = centerX + numberShiftX;
			numberLabel.y = centerY + numberShiftY;
			
			if (powerupImage) {
				powerupImage.x = centerX;
				powerupImage.y = centerY;
			}
			
			if (dropDownImage) {
				dropDownImage.x = centerX;
				dropDownImage.y = centerY;
			}
			
			if (daubHintAnimation) {
				daubHintAnimation.x = position.x + (cellWidth - (129.7*pxScale) >> 1) + 2*pxScale;
				daubHintAnimation.y = position.y + (cellHeight - (130.15*pxScale) >> 1) + 2*pxScale;
			}
			
			if (x2daubFlame) {
				//x2daubFlame.x = position.x + (cellWidth - (x2daubFlame.width*pxScale) >> 1) + 2*pxScale;
				//x2daubFlame.y = position.y + (cellHeight - (x2daubFlame.height*pxScale) >> 1) + 2*pxScale;
			}
		}
		
		public function daub():void
		{
			_daubed = true;
			removeDaubHintAnimation();
			
			if (activePowerup)
			{
				if (activePowerup == Powerup.X2)
				{
					playX2PowerupCollection();
				}
				else if (activePowerup != Powerup.INSTABINGO)
				{
					playPowerupCollection();
				}
			}
			else 
			{
				CellDaubEffect.showCurrent(gameCard.cellLayerAnimations, isX2Active, centerX, centerY);
				popText("+" + gameManager.gameData.daubXP * gameCard.gameScreenController.getX2Multiplier(gameCard.index) + " XP", isX2Active ? XTextFieldStyle.CellDaubFlyUpXP_X2 : gameManager.skinningData.dauberSkin.cellDaubFlyUpXPStyle, 0.06);
				
				if (Room.DAUB_STREAKS_ENABLED) 
					showDaubStreak();
			}
		}
		
		private function showDaubStreak():void 
		{
			var daubStreakData:DaubStreakData = Room.current.daubStreakData;
			if (daubStreakData)
			{
				if (daubStreakData.needToGiveOutPoints)
				{
					popText(Room.current.daubStreak + " daub streak" , daubStreakData.textStyle, 0.16, 0, daubStreakData.textYShift * pxScale);
					popText("+" + daubStreakData.pointsBonus + " score" , daubStreakData.textStyle, 0.26, 0, daubStreakData.textYShift * pxScale*2);
				}
				else
				{
					popText(Room.current.daubStreak + " daub streak", daubStreakData.textStyle, 0.06, 0, daubStreakData.textYShift * pxScale);
				}
			}
		}
		
		private function playPowerupCollection():void 
		{
			if (!powerupImage)
				return;			
			
			if (powerupImageGray) {
				Starling.juggler.removeTweens(powerupImageGray);
				powerupImageGray.removeFromParent(true);
				powerupImageGray = null;	
			}
				
			Starling.juggler.removeTweens(powerupImage);
			powerupImage.scale = 1;
			
			
			SoundManager.instance.playSfx(SoundAsset.PowerUpClaimV3, 0.52, 0, 1, 0, true);			
				
			powerupImage.texture = AtlasAsset.CommonAtlas.getTexture(Powerup.getCellTexture(activePowerup));
				
			var tween_0:Tween = new Tween(powerupImage, 0.07, Transitions.LINEAR);
			var tween_1:Tween = new Tween(powerupImage, 0.13, Transitions.EASE_OUT);
			var tween_2:Tween = new Tween(powerupImage, 0.13, Transitions.EASE_IN);
			var tween_3:Tween = new Tween(powerupImage, 0.1, Transitions.EASE_OUT);
			var tween_4:Tween = new Tween(powerupImage, 0.1, Transitions.EASE_OUT_BACK);
			var tween_5:Tween = new Tween(powerupImage, 0.14, Transitions.EASE_OUT);
			var tween_6:Tween = new Tween(powerupImage, 0.09, Transitions.EASE_IN);
			
			tween_0.delay = 0.18;
			tween_0.animate('scaleX', 0.35);
			tween_0.animate('scaleY', 1.7);
			tween_0.animate('alpha', 1); 
			tween_0.onStart = preparePowerupImageToFlyUp;
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', 1.16);
			tween_1.animate('scaleY', 1.16);
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scaleX', 0.5);
			tween_2.animate('scaleY', 1.68);
			tween_2.nextTween = tween_3;
			
			tween_3.animate('scaleX', 1.45);
			tween_3.animate('scaleY', 0.7);
			tween_3.nextTween = tween_4;
		
			tween_4.animate('scaleX', 1);
			tween_4.animate('scaleY', 1);
			tween_4.nextTween = tween_5;
			
			tween_5.delay = 0.55;
			tween_5.animate('scale', 1.24);
			tween_5.nextTween = tween_6;
			
			tween_6.animate('scale', 0);
			tween_6.onComplete = removePowerupImage;
			
			Starling.juggler.add(tween_0);
			
			
			var tweenY_0:Tween = new Tween(powerupImage, 0.25, Transitions.EASE_IN_OUT);
			var tweenY_1:Tween = new Tween(powerupImage, 0.25, Transitions.EASE_OUT_BACK);
			
			tweenY_0.delay = tween_0.delay;
			tweenY_0.animate('y', powerupImage.y - cellHeight*(isTopCell ? 0.83 : 1));
			tweenY_0.nextTween = tweenY_1;
			
			tweenY_1.animate('y', powerupImage.y);
			
			Starling.juggler.add(tweenY_0);
			
			
			var textFieldStyle:XTextFieldStyle;
			var prefix:String = '+';
			switch(activePowerup)
			{
				case Powerup.CASH:
					textFieldStyle = XTextFieldStyle.CellFlyUpCash;
					powerupString = ' Cash';
					break;
				case Powerup.SCORE:
					textFieldStyle = XTextFieldStyle.CellFlyUpScore;
					powerupString = powerupQuantity > 1 ? ' Points' : ' Point';
					break;
				case Powerup.XP:
					textFieldStyle = XTextFieldStyle.CellFlyUpXP;
					powerupString = ' XP';
					break;
				case Powerup.X2:
					textFieldStyle = XTextFieldStyle.CellFlyUp2X;
					powerupString = ' 2X payouts';
					break;
				case Powerup.MINIGAME:
					if (gameCard.gameScreenController.getX2Multiplier(gameCard.index) > 1)
					{
						powerupQuantity = Math.ceil(minigameDrop.quantity / 2) * 2;
					}
					powerupQuantity = minigameDrop.quantity;
					powerupString = " " + minigameDrop.getDropString();
					textFieldStyle = getMinigameDropTextStyle(minigameDrop.type);
					break;	
				default :
					textFieldStyle = XTextFieldStyle.CellFlyUpXP;
			}
			
			if(powerupQuantity > 0)
				popText(prefix + (powerupQuantity * gameCard.gameScreenController.getX2Multiplier(gameCard.index)).toString() + powerupString.toUpperCase() || '', textFieldStyle, 0.7);
			else if(powerupString)
				popText(prefix + powerupString.toUpperCase(), textFieldStyle, 0.7);
		}
		
		private function getMinigameDropTextStyle(minigameType:int):XTextFieldStyle 
		{
			switch(minigameType)
			{
				case PowerupType.SCRATCH_LOW: return XTextFieldStyle.getWalrus(32, 0xBAFF00).addShadow(1.2, 0x257000).addStroke(0.25, 0x257000);
				case PowerupType.SCRATCH_HIGH: return XTextFieldStyle.getWalrus(32, 0xE3B8FF).addShadow(1.2, 0x4D018D).addStroke(0.25, 0x4D018D);
				case PowerupType.SPIN_5: 
				case PowerupType.SPIN_10:
				case PowerupType.SPIN_25:
				case PowerupType.SPIN_50: return XTextFieldStyle.getWalrus(32, 0xFFF600).addShadow(1.2, 0xD00019).addStroke(0.25, 0xD00019);
			}
			
			sosTrace("Could not find style for minigame type " + minigameType, SOSLog.ERROR);
			return XTextFieldStyle.getWalrus(32, 0xFFFFFF).addShadow(1.2, 0xc70009).addStroke(0.25, 0xc70009);
		}
		
		public function popText(text:String, textFieldStyle:XTextFieldStyle, delay:Number = 0, shiftX:int=0, shiftY:int =0):void
		{
			var label:XTextField = new XTextField(290*pxScale, 50*pxScale, textFieldStyle);
			//label.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			//label.redraw();
			label.helperFormat.nativeTextExtraWidth = 9; 
			label.text = text;//"+10XP";
			label.alignPivot();
			//label.border = true;
			label.batchable = true;
			label.x = position.x + cellWidth/2 + shiftX;
			label.y = position.y + cellHeight*0.05 + shiftY;
			label.touchable = false;
			
			label.scaleX = 1;
			label.scaleY = 0.0;
			
			var tween_0:Tween = new Tween(label, 0.15, Transitions.EASE_OUT_BACK);
			var tween_1:Tween = new Tween(label, 0.1, Transitions.EASE_OUT);
			var tween_2:Tween = new Tween(label, 0.07, Transitions.EASE_IN);
			
			tween_0.delay = delay;
			tween_0.animate('scaleY', 1);
			tween_0.nextTween = tween_1;
			tween_0.onStart = gameCard.topLayerAnimations.addChild;
			tween_0.onStartArgs = [label];
			
			tween_1.delay = 0.6;
			tween_1.animate('scaleX', 1.08);
			tween_1.animate('scaleY', 1.35);
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scaleX', 0.6);
			tween_2.animate('scaleY', 0);
			tween_2.onComplete = removeView;
			tween_2.onCompleteArgs = [label];
		
			Starling.juggler.add(tween_0);
			
			Starling.juggler.tween(label, tween_1.delay + tween_1.totalTime + tween_2.totalTime, {transition:Transitions.LINEAR, delay:delay, y:(label.y - 28*gameCard.scale)});
		}
		
		private function preparePowerupImageToFlyUp():void{ 
			if (powerupImage) {
				gameCard.topLayerAnimations.addChild(powerupImage); 
				powerupImage.alpha = 0;  
				powerupImage.y -= cellHeight * 0.45; 
			}
		};
		
		private function removeView(view:DisplayObject):void
		{
			view.removeFromParent();
		}
		
		private function removePowerupImage():void
		{
			if (powerupImage) {
				powerupImage.removeFromParent();
				powerupImage = null;
			}
		}
		
		public function playDaubHintAnimation():void
		{
			if (!daubHintAnimation) {
				daubHintAnimation = new AnimationContainer(MovieClipAsset.PackBase);
				daubHintAnimation.dispatchOnCompleteTimeline = true;
				gameCard.cellLayerAnimations.addChild(daubHintAnimation);
				//daubHintAnimation.pivotX = daubHintAnimation.width / 2;
				//daubHintAnimation.pivotY = daubHintAnimation.height / 2;
				daubHintAnimation.x = position.x + (cellWidth - (129.7*pxScale) >> 1) + 2*pxScale; //129.7
				daubHintAnimation.y = position.y + (cellHeight - (130.15*pxScale) >> 1) + 2*pxScale; // 130.15
				daubHintAnimation.repeatCount = gameManager.gameHintsManager.cellAnimationRepeatCount;
				daubHintAnimation.alpha = gameManager.gameHintsManager.cellHintAlpha; //1 - (Player.current.gamesCount - 8) * 0.2;
				//trace('hgfg ', gameManager.gameHintsManager.cellHintAlpha, gameManager.gameHintsManager.cellAnimationRepeatCount);
				daubHintAnimation.addEventListener(Event.COMPLETE, handler_daubHintAnimationComplete);
				daubHintAnimation.stop();
			}
			else {
				daubHintAnimation.stop();
			}
			
			
			//daubHintAnimation.blendMode = BlendMode.ADD;
			//Starling.juggler.tween(daubHintAnimation, 0.8, {transition:Transitions.EASE_IN, delay:0.2, repeatCount:0, reverse:true, scale:5});
			
			DaubHintAnimationSynchronizer.registerDaubHintSynchroneTarget(daubHintAnimation);
			//daubHintAnimation.play();
		}
		
		public function removeDaubHintAnimation():void
		{
			handler_daubHintAnimationComplete(null);
		}
		
		
		private function handler_daubHintAnimationComplete(e:Event):void
		{
			if (!daubHintAnimation)
				return;
				
			DaubHintAnimationSynchronizer.unRegisterDaubHintSynchroneSource(daubHintAnimation);	
			daubHintAnimation.removeEventListener(Event.COMPLETE, handler_daubHintAnimationComplete);
			daubHintAnimation.stop();
			daubHintAnimation.removeFromParent();
			daubHintAnimation = null;
		}
		
		/*public function get hasPowerup():Boolean
		{
			return activePowerup != null && activePowerup.length > 0;
		}*/
		
		public function addMagicDaub():void
		{
			if (activePowerup)
				return;
			
			activePowerup = Powerup.DAUB;
			_daubed = true;
			_marked = true;
		
			removeDaubHintAnimation();
				
			playDropDownAppear(gameManager.skinningData.dauberSkin.getTexture(isX2Active ? 'magicdaub_2x' : 'magicdaub'));
		}
		
		public function addInstantBingo(holdUpDelay:Number, tweenStyle:String):void
		{
			if (activePowerup)
				return;
			
			activePowerup = Powerup.INSTABINGO;
			addPowerupIcon(activePowerup, holdUpDelay, tweenStyle);
		}
		
		public function addPoints(holdUpDelay:Number, tweenStyle:String):void 
		{
			activePowerup = Powerup.SCORE;
			powerupQuantity = gameManager.gameData.pointPowerupQuantity;
			addPowerupIcon(activePowerup, holdUpDelay, tweenStyle);
		}
		
		public function addX2(holdUpDelay:Number, tweenStyle:String):void 
		{
			if (activePowerup)
				return;
			
			activePowerup = Powerup.X2;
			addPowerupIcon(activePowerup, holdUpDelay, tweenStyle);
			//playDropDownAppear(Powerup.getCellTexture(activePowerup), true);
		}
		
		public function addCash(holdUpDelay:Number, tweenStyle:String):void 
		{
			if (activePowerup)
				return;
			
			activePowerup = Powerup.CASH;
			powerupQuantity = gameManager.gameData.cashPowerupQuantity;
			addPowerupIcon(activePowerup, holdUpDelay, tweenStyle);
		}
		
		public function addXP(holdUpDelay:Number, tweenStyle:String):void 
		{
			if (activePowerup)
				return;
			
			activePowerup = Powerup.XP;
			powerupQuantity = gameManager.gameData.xpPowerupQuantity;
			addPowerupIcon(activePowerup, holdUpDelay, tweenStyle);
		}
		
		public function addMinigame(holdUpDelay:Number, tweenStyle:String, minigameDrop:Minigame):void 
		{
			if (activePowerup)
				return;
			
			activePowerup = Powerup.MINIGAME;
			this.minigameDrop = minigameDrop;
			
			addPowerupIcon(activePowerup, holdUpDelay, tweenStyle);
		}
		
		private function addPowerupIcon(powerup:String, holdUpDelay:Number, tweenStyle:String):void 
		{
			var animate:Boolean = gameCard.isCardInViewArea && !gameCard.isUnderBadBingoTimeout;
			var powerUpAlpha:Number = powerup == Powerup.XP ? 0.23 : 0.3;
			var texture:Texture = AtlasAsset.CommonAtlas.getTexture(Powerup.getCellTexture(powerup, !animate));
			
			if (!powerupImage)
				powerupImage = new Image(texture);
			else
				powerupImage.texture = texture;
			
			powerupImage.alignPivot();
			powerupImage.x = position.x + cellWidth / 2;
			powerupImage.y = position.y + cellHeight / 2;
			
			if (animate) 
			{
				if (tweenStyle == PowerupDropTweenStyle.STAKES)
					playPowerupAppearSpinning(powerupImage, powerUpAlpha, powerup != Powerup.INSTABINGO, holdUpDelay);
				else	
					playPowerupAppear(powerupImage, powerUpAlpha, powerup != Powerup.INSTABINGO, holdUpDelay);
			}
			else 
			{
				powerupImage.alpha = powerUpAlpha;
				powerupImage.scale = 1;
				gameCard.cellLayerIcons.addChild(powerupImage);
			}
		}
		
		private function playPowerupAppear(item:Image, alpha:Number = 0.3, addFilters:Boolean = true, holdUpDelay:Number = 0):void
		{
			//SoundManager.instance.playSfx(SoundAsset.PowerUpDropV3, 0.4, 0, 1, 0, true);		
			
			gameCard.topLayerAnimations.addChild(item);
			item.scale = 0.72;
			
			var tween_0:Tween = new Tween(item, 0.1, Transitions.EASE_IN);
			var tween_1:Tween = new Tween(item, 0.15, Transitions.EASE_OUT);
			var tween_2:Tween = new Tween(item, 0.23, Transitions.EASE_IN);
			var tween_3:Tween = new Tween(item, 0.03, Transitions.LINEAR);
			var tween_4:Tween = new Tween(item, 0.06, Transitions.EASE_OUT_BACK);
			var tween_5:Tween = new Tween(item, 0.1, Transitions.EASE_IN);
			//var tween_6:Tween = new Tween(item, 0.15, Transitions.LINEAR);
			
			//tween_0.delay = 0.18;
			tween_0.animate('scaleX', 1.63);
			tween_0.animate('scaleY', 2.45);
			
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', 1.97);
			tween_1.animate('scaleY', 1.97);
			tween_1.nextTween = tween_2;
		
			tween_2.delay = holdUpDelay;
			tween_2.animate('scaleX', 0.91);
			tween_2.animate('scaleY', 0.91);
			tween_2.onStart = SoundManager.instance.playSfx;
			tween_2.onStartArgs = [SoundAsset.PowerUpDropV3, 0.0, 0, 1, 0, false];
			tween_2.onComplete = shakeUIs;
			tween_2.onCompleteArgs = [true, 0];
			tween_2.nextTween = tween_3;
			
			tween_3.animate('scaleX', 1.39);
			tween_3.animate('scaleY', 0.73);
			tween_3.nextTween = tween_4;
		
			tween_4.animate('scaleX', 0.69);
			tween_4.animate('scaleY', 1.61);
			tween_4.nextTween = tween_5;
			
			tween_5.animate('scaleX', gameCard.scale);
			tween_5.animate('scaleY', gameCard.scale);
			tween_5.onComplete = completePowerupAppear;
			tween_5.onCompleteArgs = [item, alpha, true];
			//tween_5.nextTween = tween_6;
			
			//tween_6.animate('alpha', alpha);
			
			Starling.juggler.add(tween_0);
		}
		
		public function completePowerupAppear(item:Image, alpha:Number, animateFilters:Boolean, setPosition:Boolean = false):void 
		{
			if (setPosition) {
				item.x = position.x + cellWidth / 2;
				item.y = position.y + cellHeight / 2;
			}
			
			item.scale = 1;
			gameCard.cellLayerIcons.addChild(item);
			
			if (animateFilters) 
			{
				powerupImageGray = new Image(AtlasAsset.CommonAtlas.getTexture(Powerup.getCellTexture(activePowerup, true)));
				powerupImageGray.x = item.x;
				powerupImageGray.y = item.y;
				powerupImageGray.alpha = 0;
				powerupImageGray.pivotX = item.pivotX;
				powerupImageGray.pivotY = item.pivotY;
				gameCard.cellLayerIcons.addChild(powerupImageGray);
			
				Starling.juggler.tween(powerupImageGray, 1.2, {transition:Transitions.LINEAR, alpha:alpha});
				TweenHelper.tween(item, 0.15, {transition:Transitions.LINEAR, alpha:alpha}).chain(item, 1.05, {transition:Transitions.LINEAR, alpha:0, onComplete:completePowerTextureToGray, onCompleteArgs:[item, powerupImageGray, alpha]});
			}
			else {
				item.texture = AtlasAsset.CommonAtlas.getTexture(Powerup.getCellTexture(activePowerup, true));
				item.alpha = alpha;
			}
		}
		
		private function completePowerTextureToGray(icon:Image, iconGray:Image, alpha:Number):void 
		{
			icon.texture = iconGray.texture;
			icon.alpha = alpha;
			iconGray.texture = null;
			iconGray.removeFromParent(true);
			powerupImageGray = null;
		}
		
		private function playPowerupAppearSpinning(item:Image, alpha:Number = 0.3, addFilters:Boolean = true, holdUpDelay:Number = 0):void
		{
			Game.current.gameScreen.gameUI.topLayer.addChild(item);
			//gameCard.topLayerAnimations.addChild(item);
			var k:int = gameCard.index % 2;
			item.scale = 0.15*gameCard.scale;
			item.x = layoutHelper.stageWidth*(0.39 + k*0.11 + 0.11*Math.random()); //0.219*Math.random());
			item.y = layoutHelper.stageHeight*(0.36 + 0.125*Math.random());
			item.rotation = Math.random() * Math.PI * 2;
			var clockwise:Boolean = item.rotation > Math.PI;
			
			var startPoint:Point = new Point(item.x, item.y);
			var finishPoint:Point = gameCard.localToGlobal(new Point(position.x + (cellWidth >> 1), position.y + (cellHeight >> 1)));
			var distance:Number = Point.distance(startPoint, finishPoint);
			var normalizedFinishPoint:Point = new Point(finishPoint.x - item.x, finishPoint.y - item.y);
			var directionAngle:Number = Math.abs(Math.atan2( -1, 0) - Math.atan2(normalizedFinishPoint.y, normalizedFinishPoint.x));
			var tweenToFinishTime:Number = Math.max(0.35, distance / (540*pxScale));
			//trace('directionAngle', directionAngle * 180 / Math.PI, distance, tweenToFinishTime/2);	

			var isCurveTrack:Boolean = (distance < 120*pxScale) || ((finishPoint.x - item.x) > -50*pxScale);
			
			var interpolateRatio:Number = isCurveTrack ? 0.25 : 0.5;
			var bezierPointsDistanceRatio:Number = 1 - interpolateRatio;
			
			var middlePoint:Point = Point.interpolate(new Point(item.x, item.y), finishPoint, interpolateRatio);
			
			var bezierPoints_1:Vector.<Point>;
			var bezierPoints_2:Vector.<Point>;
			
			if (isCurveTrack) 
			{
				var middleBezierPoint:Point = Point.polar(bezierPointsDistanceRatio*distance, directionAngle + Math.PI).add(middlePoint);
				var helperBezierPointPreMiddle:Point = Point.polar(bezierPointsDistanceRatio*distance, directionAngle + Math.PI - Math.PI/4).add(middlePoint);
				var helperBezierPointAfterMiddle:Point = Point.polar(bezierPointsDistanceRatio*distance, directionAngle + Math.PI + Math.PI/4).add(middlePoint);
				
				bezierPoints_1 = new <Point>[startPoint, helperBezierPointPreMiddle, middleBezierPoint];
				bezierPoints_2 = new <Point>[middleBezierPoint, helperBezierPointAfterMiddle, finishPoint];
			}
			else 
			{
				bezierPoints_1 = new <Point>[startPoint, startPoint, middlePoint];
				bezierPoints_2 = new <Point>[middlePoint, finishPoint, finishPoint];
			}
			
			//Game.current.gameScreen.addChild(UIUtils.drawQuad('questsEdge', middlePoint.x + pp.x, middlePoint.y + pp.y, 10, 10, 0.8));
		
			var tween_1:BezierTween = new BezierTween(item, tweenToFinishTime/2, bezierPoints_1, BezierTween.SPEED_DEFAULT, BezierTween.ACCURACY_FINE, Transitions.LINEAR);
			var tween_2:BezierTween = new BezierTween(item, tweenToFinishTime/2, bezierPoints_2 , BezierTween.SPEED_DEFAULT, BezierTween.ACCURACY_FINE, Transitions.LINEAR);
			var tween_3:Tween = new Tween(item, 0.03, Transitions.LINEAR);
			var tween_4:Tween = new Tween(item, 0.06, Transitions.EASE_OUT_BACK);
			var tween_5:Tween = new Tween(item, 0.1, Transitions.EASE_IN);
			
			//tween_0.delay = 0.18;
			tween_1.animate('scale', (2.35 + Math.random())*gameCard.scale);
			tween_1.animate('rotation', clockwise ? ((2*Math.PI - item.rotation)/2 + item.rotation) : (item.rotation/2));
			tween_1.nextTween = tween_2;
			
			tween_2.delay = holdUpDelay;
			tween_2.animate('x', finishPoint.x);
			tween_2.animate('y', finishPoint.y);
			tween_2.animate('scaleX', 0.91*gameCard.scale);
			tween_2.animate('scaleY', 0.91*gameCard.scale);
			tween_2.animate('rotation', clockwise ? (2*Math.PI) : (0));
			//tween_2.onStart = SoundManager.instance.playSfx;
			//tween_2.onStartArgs = [SoundAsset.PowerUpDropV3, 0.0, 0, 1, 0, false];
			tween_2.onComplete = shakeUIs;
			tween_2.onCompleteArgs = [true, 0];
			tween_2.nextTween = tween_3;
			
			tween_3.animate('scaleX', 1.39*gameCard.scale);
			tween_3.animate('scaleY', 0.73*gameCard.scale);
			tween_3.nextTween = tween_4;
		
			tween_4.animate('scaleX', 0.69*gameCard.scale);
			tween_4.animate('scaleY', 1.41*gameCard.scale);
			tween_4.nextTween = tween_5;
			
			tween_5.animate('scaleX', gameCard.scale);
			tween_5.animate('scaleY', gameCard.scale);
			tween_5.animate('alpha', alpha);
			tween_5.onComplete = completePowerupAppear;
			tween_5.onCompleteArgs = [item, alpha, true, true];
			
			Starling.juggler.add(tween_1);
		}
		
		private function shakeUIs(showSquareTweenLines:Boolean = false, cardShakeStrength:int = 0):void 
		{
			Game.current.gameScreen.gameUI.gameUIPanel.jumpUI();
			Game.current.gameScreen.shakeBackground(ResizeUtils.SHAKE_X_Y_SHRINK);
			
			gameCard.tweenShake(0, cardShakeStrength);
			
			if (showSquareTweenLines)
				new SquareTweenLines(gameCard.cellLayerBottom, position.x + cellWidth / 2, position.y + cellHeight / 2, cellWidth, cellHeight, 12 * pxScale, cellHeight / 2, 0.27, 0.4);	
			
			//gameCard.tweenCellsJumpApart(horisontalIndex, verticalIndex);
		}
		
		private function playDropDownAppear(texture:Texture, collectAsPowerUp:Boolean = false):void
		{
			var finishPoint:Point = gameCard.localToGlobal(new Point(position.x + (cellWidth >> 1), position.y + (cellHeight >> 1)));
			
			dropDownImage = new Image(texture);
			dropDownImage.alignPivot();
			
			var animate:Boolean = gameCard.isCardInViewArea && !gameCard.isUnderBadBingoTimeout;
			if (!animate) 
			{
				dropDownImage.x = position.x + (cellWidth >> 1);
				dropDownImage.y = position.y + (cellHeight >> 1);
				gameCard.cellLayerTextFields.addChild(dropDownImage);
				
				if(collectAsPowerUp)
					moveDropDownImageToPowerupImage();
				
				return;
			}
			
			var startX:int = finishPoint.x - pxScale * gameCard.scale * 270//pxScale * gameCard.scale * (300 - Math.random() * 600);
			var startY:int = finishPoint.y - pxScale * gameCard.scale * 190//pxScale * gameCard.scale * (300 - Math.random() * 600);
			
			dropDownShadow = new Image(AtlasAsset.CommonAtlas.getTexture('powerup/powerup_shadow_0'));
			dropDownShadow.alignPivot();
			dropDownShadow.x = finishPoint.x + pxScale * gameCard.scale * (150 - Math.random() * 300);
			dropDownShadow.y = gameManager.layoutHelper.stageHeight;
			dropDownShadow.alpha = 0;
			dropDownShadow.scale = 3;
			Game.current.gameScreen.gameUI.topLayer.addChildAt(dropDownShadow, 0);
			Starling.juggler.tween(dropDownShadow, 0.45, {transition:Transitions.LINEAR, x:finishPoint.x, y:finishPoint.y, scale:0.5, alpha:7, onComplete:removeDropDownShadow});
			
			dropDownImage.x = startX;
			dropDownImage.y = startY;
			dropDownImage.alpha = 0;
			dropDownImage.scale = 5.3;
			dropDownImage.rotation = -36 * Math.PI / 180;
			Game.current.gameScreen.gameUI.topLayer.addChild(dropDownImage);
			
			var tween_0:Tween = new Tween(dropDownImage, 0.42, Transitions.EASE_IN);
			var tween_1:Tween = new Tween(dropDownImage, 0.07, Transitions.EASE_OUT);
			var tween_2:Tween = new Tween(dropDownImage, 0.07, Transitions.EASE_OUT);
			var tween_3:Tween = new Tween(dropDownImage, 0.07, Transitions.EASE_IN);
			var tween_4:Tween = new Tween(dropDownImage, 0.1, Transitions.EASE_OUT_BACK);
			
			//tween_0.delay = delay;
			tween_0.animate('x', finishPoint.x);
			tween_0.animate('y', finishPoint.y);
			tween_0.animate('scale', 0.84);
			tween_0.animate('rotation', 0);
			tween_0.animate('alpha', 6);
			tween_0.onComplete = shakeUIs;
			tween_0.onCompleteArgs = [false, 1];
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', 1.88);
			tween_1.animate('scaleY', 1.26);
			tween_1.onStart = rechildDropDownImage;
			tween_1.onStartArgs = [position.x + (cellWidth >> 1), position.y + (cellHeight >> 1)];
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scaleX', 0.9);
			tween_2.animate('scaleY', 1.47);
			tween_2.nextTween = tween_3;
		
			tween_3.animate('scaleX', 1.15);
			tween_3.animate('scaleY', 0.82);
			tween_3.nextTween = tween_4;
			
			tween_4.animate('scaleX', 1);
			tween_4.animate('scaleY', 1);
			if(collectAsPowerUp)
				tween_4.onComplete = moveDropDownImageToPowerupImage;
			
			Starling.juggler.add(tween_0);
			
			SoundManager.instance.playSfx(SoundAsset.PowerUpDoubleDaubV4, 0, 0, 0.7, 0, true);
		}
	
		private function rechildDropDownImage(x:Number, y:Number):void
		{
			if (dropDownImage) {
				gameCard.cellLayerTextFields.addChild(dropDownImage);
				dropDownImage.x = x;
				dropDownImage.y = y;
			}
		}
		
		private function removeDropDownShadow():void
		{
			if (dropDownShadow) {
				dropDownShadow.removeFromParent();
				dropDownShadow = null;
			}
		}
		
		private function moveDropDownImageToPowerupImage():void
		{
			if (dropDownImage) {
				powerupImage = dropDownImage;
				dropDownImage = null;
			}
		}
		
		private function playX2PowerupCollection():void 
		{
			numberLabel.visible = false;
			
			removePowerupImage();
			
			if (x2daubFlame) {
				Starling.juggler.removeTweens(x2daubFlame);
				removeX2DaubFlame();
			}
			
			x2daubFlame = new X2DaubFlame();
			x2daubFlame.x = position.x + cellWidth / 2;
			x2daubFlame.y = position.y + cellHeight / 2;
			gameCard.topLayerAnimations.addChild(x2daubFlame);
			
			//Game.current.gameScreen.frontLayer.addChild(x2daubFlame);
			//var finishPoint:Point = gameCard.localToGlobal(new Point(position.x + cellWidth / 2, position.y + cellHeight / 2));
			//x2daubFlame.x = finishPoint.x;
			//x2daubFlame.y = finishPoint.y;
			
			// каждый селл имеет свой личный конец его же активации
			x2FinishTimestamp = gameCard.gameScreenController.getX2FinishTime(gameCard.index);
			
			if(!gameCard.hasEventListener(Event.ENTER_FRAME, handler_x2EnterFrame))
				gameCard.addEventListener(Event.ENTER_FRAME, handler_x2EnterFrame);
		}
		
		private function handler_x2EnterFrame(e:Event):void
		{
			var timeout:int = x2FinishTimestamp - getTimer();
				
			if (timeout <= 0) 
			{
				numberLabel.visible = true;
				
				gameCard.removeEventListener(Event.ENTER_FRAME, handler_x2EnterFrame);
				
				Starling.juggler.tween(x2daubFlame, 0.2, {alpha:0, onComplete:removeX2DaubFlame});
				
				removeX2DaubFlame();
				
				return;
			}
			
			x2daubFlame.animationScale = 0.6 + 0.4*(timeout / gameManager.gameData.x2TimeMs);
		}
	
		public function changeStyleTextures(toX2:Boolean):void 
		{
			if (activePowerup == Powerup.DAUB)
			{
				var texture:Texture = gameManager.skinningData.dauberSkin.getTexture(toX2 ? 'magicdaub_2x' : 'magicdaub');
				
				if(dropDownImage)
				{
					dropDownImage.texture = texture;
					dropDownImage.alignPivot();
				}
				
				if (powerupImage)
				{
					powerupImage.texture = texture;
					powerupImage.alignPivot();
				}
			}
		}
			
		private function removeX2DaubFlame():void {
			if (x2daubFlame) {
				//x2Animation.stop();
				x2daubFlame.removeFromParent();
				x2daubFlame = null;
			}
		}	
		
		private function get isX2Active():Boolean {
			return gameCard.gameScreenController.isX2Active(gameCard.index);
		}
		
		public function x2Clean():void {
			x2FinishTimestamp = 0;
		}	
		
		public function refreshSkinTextures():void
		{
			if (activePowerup == Powerup.DAUB)
			{
				var texture:Texture = gameManager.skinningData.dauberSkin.getTexture(gameCard.gameScreenController.isX2Active(gameCard.index) ? 'magicdaub_2x' : 'magicdaub');
				
				if(dropDownImage)
				{
					dropDownImage.texture = texture;
					dropDownImage.alignPivot();
				}
				
				if (powerupImage)
				{
					powerupImage.texture = texture;
					powerupImage.alignPivot();
				}
			}
			else 
			{
				createCellNumber(true, _marked);
			}
			
			if (x2daubFlame)
				x2daubFlame.refreshSkinTextures();
		}
		
		public function showStreakBreak():void 
		{
			popText("Daub streak break", XTextFieldStyle.CellFlyUpCash, 0.06, 0, -18 * pxScale);
		}
	}
}

import com.alisacasino.bingo.assets.AnimationContainer;
import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.assets.MovieClipAsset;
import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.TweenHelper;

class X2DaubFlame extends Sprite 
{
	private var x2Animation:AnimationContainer;
	private var titleImage:Image;
	
	public function X2DaubFlame() 
	{
		x2Animation = new AnimationContainer(MovieClipAsset.PackBase);
		addChild(x2Animation);
		x2Animation.pivotX = 82*pxScale;
		x2Animation.pivotY = 82 * pxScale;
		x2Animation.scale = 0.73;
		x2Animation.rotation = (50 * Math.PI) / 180;
		x2Animation.playTimeline('2xflame', false, true);
		TweenHelper.tween(x2Animation, 0.07, {scale:1.53}).chain(x2Animation, 0.3, {scale:1, transition:Transitions.EASE_OUT});
		
		titleImage = new Image(gameManager.skinningData.cardSkinX2.getTexture("title"));
		titleImage.alignPivot();
		titleImage.scale = 0.722;
		titleImage.alpha = 0;
		//image.y = 39*pxScale;
		addChild(titleImage);
		
		TweenHelper.tween(titleImage, 0.06, {alpha:10, delay:0.1, scale:0.9, rotation:0.0873}).chain(titleImage, 0.15, {scale:0.722, rotation:0, transition:Transitions.EASE_OUT_BACK});
	}
	
	public function set animationScale(value:Number):void 
	{
		if(!Starling.juggler.containsTweens(x2Animation))
			x2Animation.scale = value;
	}
	
	public function refreshSkinTextures():void
	{
		Starling.juggler.removeTweens(titleImage);
		titleImage.texture = gameManager.skinningData.cardSkinX2.getTexture("title");
		titleImage.alignPivot();
		titleImage.scale = 0.722;
		titleImage.rotation = 0;
		titleImage.alpha = 1;
	}
}