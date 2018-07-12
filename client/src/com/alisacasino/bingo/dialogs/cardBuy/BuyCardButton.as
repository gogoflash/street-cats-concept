package com.alisacasino.bingo.dialogs.cardBuy
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.controls.InvisibleButton;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.game.StakeData;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.JumpWithHintHelper;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import flash.geom.Rectangle;
	import starling.animation.Tween;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	
	import starling.display.DisplayObject;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BuyCardButton extends FeathersControl
	{
		static public const WIDTH:int = 219;
		static public const HEIGHT:int = 250;
		
		static public const STATE_LOBBY:String = "stateLobby";
		static public const STATE_BUY:String = "stateBuy";
		static public const STATE_PRE_GAME:String = "statePreGame";
		
		private var _state:String = STATE_LOBBY;
		
		private var checkmark:Image;
		private var _selected:Boolean;
		
		private var clickInterceptor:InvisibleButton;
		private var priceButton:Button;
		
		private var background:Image;
		private var catIcon:Image;
		private var numberLabel:XTextField;
		private var _index:int;
		
		private var padlockStartTweenAngle:int;
		private var unlockLevel:int;
		private var grayBg:Image;
		private var padlock:Image;
		private var unlockTopLabel:XTextField;
		private var unlockBottomLabel:XTextField;
		
		private var buttonContent:Sprite;
		private var buttonBg:Image;
		private var buttonCashIcon:Image;
		private var buttonTextField:XTextField;
		
		private var priceValueIntAnimatorTweenId:uint;
		
		private var cardStakeBanner:CardStakeBanner;
		
		private var _stakeData:StakeData;
		
		private var jumpHelper:JumpWithHintHelper;
		
		public function get stakeData():StakeData 
		{
			return _stakeData;
		}
		
		public function set stakeData(value:StakeData):void 
		{
			if (_stakeData != value)
			{
				_stakeData = value;
				
				cardStakeBanner.stakeData = _stakeData;
				updatePrice(true);
			}
		}
		
		public function BuyCardButton(index:uint)
		{
			_index = index;
			
			setSizeInternal((WIDTH + 30)*pxScale, HEIGHT*pxScale, false);
			//initialize();
		}
		
		override protected function feathersControl_addedToStageHandler(event:Event):void 
		{
			super.feathersControl_addedToStageHandler(event);
			Game.addEventListener(Game.COLLECTION_EFFECTS_UPDATED, collectionEffectsUpdatedHandler);
		}
		
		override protected function feathersControl_removedFromStageHandler(event:Event):void 
		{
			super.feathersControl_removedFromStageHandler(event);
			Game.removeEventListener(Game.COLLECTION_EFFECTS_UPDATED, collectionEffectsUpdatedHandler);
		}
		
		private function collectionEffectsUpdatedHandler(e:Event):void 
		{
			updatePrice();
			//priceButton.text = getPrice().toString();
		}
		
		private function updatePrice(animated:Boolean = false):void 
		{
			var newPriceValue:int = getPrice();
			if (!animated) {
				buttonTextField.text = newPriceValue.toString();
				return;
			}
		
			Starling.juggler.removeTweens(buttonTextField);
			
			var oldPriceValue:int = int(buttonTextField.text);
			
			priceValueIntAnimatorTweenId = EffectsManager.animateIntHelper(oldPriceValue, newPriceValue, setProgressLabel, 0.6);
			
			if (newPriceValue > oldPriceValue) {
				//EffectsManager.jump(buttonCashIcon, jumpsCount, 0.886, 0.886, 0.07, 0.04, 0.0, 0, 0, 1.8, true, false);
				EffectsManager.jump(buttonTextField, 5, 1, 1.0, 0.07, 0.04, 0.0, 0, 0, 2.8, true, false);
			}
		}
		
		public function setProgressLabel(value:int):void {
			buttonTextField.text = value.toString();
		}
		
		public function setUnlockProperties(unlockLevel:int, padlockStartTweenAngle:int):void
		{
			this.unlockLevel = unlockLevel;
			this.padlockStartTweenAngle = padlockStartTweenAngle;
		}
		
		override public function get width():Number
		{
			return WIDTH*pxScale*scale;
		}
		
		override protected function initialize():void 
		{
			background = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/card"));
			addChild(background);
			
			catIcon = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/cat_icon_white"));
			catIcon.x = 86 * pxScale;
			catIcon.y = 77 * pxScale;
			addChild(catIcon);
			
			pivotX = background.width / 2;
			pivotY = background.height / 2;
			
			numberLabel = new XTextField(76 * pxScale, 89 * pxScale, XTextFieldStyle.White70C, (index + 1).toString());
			numberLabel.alignPivot();
			numberLabel.pixelSnapping = false;
			numberLabel.x = numberLabelX;
			numberLabel.y = 111 * pxScale;
			numberLabel.visible = false;
			numberLabel.alpha = 0;
			addChild(numberLabel);
			
			cardStakeBanner = new CardStakeBanner(index);
			cardStakeBanner.stakeData = Room.current.stakeData;
			addChild(cardStakeBanner);
			
			clickInterceptor = new InvisibleButton(internalWidth, height);
			clickInterceptor.addEventListener(Event.TRIGGERED, clickInterceptor_triggeredHandler);
			clickInterceptor.useHandCursor = true;
			addChild(clickInterceptor);
			
			buttonContent = new Sprite();
			
			buttonBg = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/card_cash"));
			buttonContent.addChild(buttonBg);
			
			buttonCashIcon = new Image(AtlasAsset.CommonAtlas.getTexture("bars/cash"));
			buttonCashIcon.alignPivot();
			buttonCashIcon.x = buttonCashIcon.pivotX;
			buttonCashIcon.y = buttonCashIcon.pivotY - 2*pxScale;
			buttonCashIcon.scale = 0.83//0.886;
			buttonContent.addChild(buttonCashIcon);
			
			buttonTextField = new XTextField(WIDTH * pxScale, 40 * pxScale, XTextFieldStyle.BuyCardCash, "");
			buttonTextField.helperFormat.nativeTextExtraWidth = 10 * pxScale;
			buttonTextField.pixelSnapping = false;
			updatePrice();
			buttonTextField.touchable = false;
			//buttonTextField.x = (buttonBg.width - buttonTextField.textBounds.width) / 2 - buttonTextField.textBounds.x + 25*pxScale;
			//buttonTextField.y = (buttonBg.height - buttonTextField.textBounds.height) / 2 - buttonTextField.textBounds.y + 3*pxScale;
			buttonContent.addChild(buttonTextField);
			
			priceButton = new Button();
			priceButton.scaleWhenDown = 0.93;
			priceButton.useHandCursor = true;
			priceButton.defaultSkin = buttonContent;
			priceButton.validate();
			priceButton.addEventListener(Event.TRIGGERED, priceButton_triggeredHandler);
			priceButton.touchable = false;
			addChild(priceButton);
			priceButton.x = 42 * pxScale;
			priceButton.y = 162 * pxScale;
			priceButton.alpha = 0;
			
			jumpHelper = new JumpWithHintHelper(this, true, true);
		}
		
		override public function set scale(value:Number):void 
		{
			super.scale = value;
			jumpHelper.scale = value;
		}
		
		public function get index():uint 
		{
			return _index;
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			//sosTrace( "BuyCardsPlate.set > state : " + value );
			if (_state != value)
			{
				_state = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		override protected function draw():void 
		{
			if (isInvalid(INVALIDATION_FLAG_STATE))
			{
				if (state == STATE_LOBBY)
				{
					jumpHelper.setEnabled(false);
					
					showSelected(false);
					Starling.juggler.tween(numberLabel, 0.5, {transition:Transitions.EASE_IN, alpha:0});
					Starling.juggler.tween(catIcon, 0.5, {transition:Transitions.EASE_IN, alpha:1});
					Starling.juggler.tween(priceButton, 0.5, {transition:Transitions.EASE_IN, alpha:0});
					
					if (isLockedByLevel && padlock) {
						background.filter = null;
						Starling.juggler.removeTweens(padlock);
						Starling.juggler.tween(padlock, 0.4, { transition:Transitions.EASE_IN, delay:0.2, alpha:0, onUpdate:updateLockedViewsAlpha});
						Starling.juggler.tween(padlock, 0.3, { delay:0.3, rotation:(-padlockStartTweenAngle * Math.PI/ 180), transition:Transitions.EASE_OUT});
					}
					
					cardStakeBanner.setDefaultStake();
				}
				else if (state == STATE_BUY)
				{
					showSelected(false);
					
					Starling.juggler.tween(numberLabel, 0.4, {transition:Transitions.EASE_IN, delay:0.3, alpha:1});
					Starling.juggler.tween(catIcon, 0.4, {transition:Transitions.EASE_IN, delay:0.3, alpha:0});
					
					if (isLockedByLevel) 
					{
						createLockedByLevelViews();
		
						Starling.juggler.tween(padlock, 0.4, {transition:Transitions.EASE_IN, delay:0.3, alpha:1, onUpdate:updateLockedViewsAlpha, onComplete:jumpHelper.setEnabled, onCompleteArgs:[true]});
					
						var padlockRotation:Number = padlockStartTweenAngle * Math.PI/ 180;
						Starling.juggler.tween(padlock, 0.4, { delay:0.1, rotation:padlockRotation, transition:Transitions.EASE_OUT, onComplete:tweenRotatePadlock, onCompleteArgs:[0.4, -padlockRotation*0.6]});
					}
					else 
					{
						Starling.juggler.tween(priceButton, 0.4, {transition:Transitions.EASE_IN, delay:0.3, alpha:1, onComplete:jumpHelper.setEnabled, onCompleteArgs:[true]});
					}
					Starling.juggler.delayCall(setStakeToBanner, 0.8);
				}
				else if (state == STATE_PRE_GAME)
				{
					jumpHelper.setEnabled(true);
					
					if (_selected) {
						showSelected(true);
					}
					else
					{
						cardStakeBanner.setDefaultStake();
					}
				}
			}	
			//priceButton.price = priceInTickets;
		}
		
		private function setStakeToBanner():void 
		{
			if (!isLockedByLevel)
			{
				cardStakeBanner.stakeData = Room.current.stakeData;
			}
		}
		
		private function showSelected(value:Boolean):void 
		{
			if (value)
			{
				if (priceValueIntAnimatorTweenId > 0) 
				{
					Starling.juggler.removeByID(priceValueIntAnimatorTweenId);
					priceValueIntAnimatorTweenId = 0;
					
					EffectsManager.removeJump(buttonTextField);
				}	
				
				if (numberLabel.visible)
				{
					background.texture = AtlasAsset.CommonAtlas.getTexture("buy_cards/card_green");
					numberLabel.visible = false;
					
					buttonBg.texture = AtlasAsset.CommonAtlas.getTexture("buy_cards/green_bg");
					
					buttonTextField.textStyle = XTextFieldStyle.BuyCardSelected;
					buttonTextField.text = (index + 1).toString() + ' CARD' + (index > 0 ? 'S' : '');
					buttonTextField.alignPivot(Align.LEFT, Align.TOP);
					
					//priceButton.touchable = false;
				}
				
				buttonBg.readjustSize();
				buttonBg.scale9Grid = ResizeUtils.getScaledRect(6, 6, 2, 2);
				buttonBg.width = 174 * pxScale;
				buttonBg.height = 52 * pxScale;
				buttonBg.x = 0;
				buttonBg.y = 0;
				
				buttonCashIcon.visible = false;
				
				buttonTextField.x = (174 * pxScale - buttonTextField.textBounds.width) / 2 - buttonTextField.textBounds.x + 2 * pxScale;
				buttonTextField.y = (52 * pxScale - buttonTextField.textBounds.height) / 2 - buttonTextField.textBounds.y + 2 * pxScale;
				
				priceButton.x = (background.width - 174 * pxScale) / 2 + 0.3*pxScale;
				priceButton.y = 175 * pxScale;
			}
			else
			{
				if (!numberLabel.visible)
				{
					background.texture = AtlasAsset.CommonAtlas.getTexture("buy_cards/card");
					numberLabel.visible = true;
					
					buttonBg.texture = AtlasAsset.CommonAtlas.getTexture("buy_cards/gray_bg");
				
					buttonTextField.textStyle = XTextFieldStyle.BuyCardCash;
					buttonTextField.alignPivot();
					updatePrice();
					
					//priceButton.touchable = true;
				}
				
				priceButton.x = 37 * pxScale;
				priceButton.y = 162 * pxScale;
				priceButton.alpha = 0;
				
				buttonBg.scale9Grid = ResizeUtils.getScaledRect(27, 0, 2, 0);
				buttonBg.readjustSize();
				buttonBg.width = 129 * pxScale;
				buttonBg.height = 47 * pxScale;
				buttonBg.x = 17 * pxScale;
				buttonBg.y = 9 * pxScale;
				
				buttonCashIcon.visible = true;
				
				buttonTextField.x = buttonTextField.pivotX + (buttonBg.width - buttonTextField.textBounds.width) / 2 - buttonTextField.textBounds.x + 37*pxScale;
				buttonTextField.y = buttonTextField.pivotY + (buttonBg.height - buttonTextField.textBounds.height) / 2 - buttonTextField.textBounds.y + 11 * pxScale;
			}
			
			showCheckmark(value);
		}
		
		public function getPrice():Number
		{
			return gameManager.tournamentData.getCardCost(index + 1);
		}
		
		private function clickInterceptor_triggeredHandler(e:Event):void 
		{
			e.stopImmediatePropagation();
			
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, 0.7, 0, true);
			handleClick();
		}
		
		private function priceButton_triggeredHandler(e:Event):void 
		{
			e.stopImmediatePropagation();
			handleClick();
		}
		
		private function handleClick():void 
		{
			if (isLockedByLevel) {
				
				if (padlock) {
					Starling.juggler.removeTweens(padlock);
					
					var cickAmplitude:Number = (13 + 10*Math.random()) * Math.PI/ 180;
					Starling.juggler.tween(padlock, 0.1, {rotation:cickAmplitude, transition:Transitions.EASE_OUT, onComplete:tweenRotatePadlock, onCompleteArgs:[0.4, -cickAmplitude*0.8]});
				}
				
				return;
			}
			
			dispatchEventWith(Event.TRIGGERED, true, index);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (_selected == value)
				return;
			
			_selected = value;
		}
		
		public function showCheckmark(value:Boolean):void
		{
			if(value) 
			{
				if(!checkmark) {
					checkmark = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/checkmark"));
					checkmark.x = 58 * pxScale;
					checkmark.y = 55 * pxScale;
					checkmark.alpha = 0.0;
					checkmark.scaleY = 0.0;
					addChild(checkmark);
				}
				
				Starling.juggler.tween(checkmark, 0.3, {
					transition: Transitions.EASE_OUT_BACK,
					alpha: 1.0,
					scaleY: 1.0
				});
			}
			else 
			{
				Starling.juggler.removeTweens(checkmark);
				if(checkmark) {
					checkmark.removeFromParent();
					checkmark = null;
				}
			}
		}
		
		public function set enabled(value:Boolean):void
		{
			if (value) {
				alpha = 1.0;
				clickInterceptor.visible = true;
			} else {
				alpha = selected ? 1.0 : 0.7;
				clickInterceptor.visible = false;
			}
			//priceButton.isEnabled = value;
		}
		
		private function createLockedByLevelViews():void 
		{
			if (!padlock) 
			{
				var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
				colorMatrixFilter.adjustSaturation(-1);
				numberLabel.filter = colorMatrixFilter;
				
				grayBg = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/gray_bg"));
				grayBg.touchable = false;
				grayBg.scale9Grid = new Rectangle(27 * pxScale, 0, 2 * pxScale, 0);
				grayBg.width = 157*pxScale;
				grayBg.x = (internalWidth - grayBg.width)/2;
				grayBg.y = 171 * pxScale;
				grayBg.alpha = 0.0;
				addChild(grayBg);
				
				padlock = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/gray_padlock"));
				//padlock.scale = 1.55;
				padlock.pivotX = 1.55*16*pxScale;
				padlock.pivotY = 1.55*7*pxScale;
				padlock.x = 202 * pxScale;
				padlock.y = 12 * pxScale;
				padlock.touchable = false;
				padlock.alpha = 0.0;
				addChild(padlock);
				
				unlockTopLabel = new XTextField(internalWidth, 45 * pxScale, XTextFieldStyle.getWalrus(23, 0xffe400).setShadow(1.2));
				unlockTopLabel.touchable = false;
				unlockTopLabel.text = 'Unlocks at';
				unlockTopLabel.pixelSnapping = false;
				unlockTopLabel.y = 137 * pxScale;
				unlockTopLabel.alpha = 0;
				addChild(unlockTopLabel);
				
				unlockBottomLabel = new XTextField(internalWidth, 45 * pxScale, XTextFieldStyle.getWalrus(33, 0xffffff).setShadow(1.2));
				unlockBottomLabel.touchable = false;
				unlockBottomLabel.text = "Level "+ unlockLevel.toString();
				unlockBottomLabel.pixelSnapping = false;
				unlockBottomLabel.y = 174 * pxScale;
				unlockBottomLabel.alpha = 0;
				addChild(unlockBottomLabel);
			}
			
			background.filter = new ColorMatrixFilter();
		}
		
		private function updateLockedViewsAlpha():void {
			if (!padlock)
				return;
			
			if(background.filter)	
				(background.filter as ColorMatrixFilter).adjustSaturation(-padlock.alpha);	
				
			grayBg.alpha = padlock.alpha;
			unlockTopLabel.alpha = padlock.alpha;
			unlockBottomLabel.alpha = padlock.alpha;
		}
		
		public function get isLockedByLevel():Boolean {
			if (unlockLevel <= 0)
				return false;
				
			return gameManager.gameData.getLevelForXp(Player.current ? Player.current.xpCount : 0) < unlockLevel;
		}
		
		private function tweenRotatePadlock(time:Number, rotation:Number, transitionIn:String = null):void 
		{
			if (Math.abs(rotation) < ((0.45 * Math.PI) / 180)) {
				Starling.juggler.tween(padlock, time/2, { rotation:0, transition:Transitions.EASE_IN});
			}
			else 
			{
				var tween:Tween = new Tween(padlock, time / 2, Transitions.EASE_OUT);
				tween.animate('rotation', rotation);
				tween.onComplete = tweenRotatePadlock;
				tween.onCompleteArgs = [time * 0.9, -rotation * 0.8];
				
				Starling.juggler.tween(padlock, time/2, { rotation:0, transition:(transitionIn || Transitions.EASE_IN), nextTween:tween});
			}
		}
		
		private function get internalWidth():Number
		{
			return WIDTH*pxScale;
		}
		
		private function get numberLabelX():Number {
			switch(index) {
				case 0: return 108 * pxScale;
				case 1: return 110 * pxScale;
				case 2: return 110 * pxScale;
				case 3: return 108 * pxScale;
			}
			return 108 * pxScale;
		}
	}
}
