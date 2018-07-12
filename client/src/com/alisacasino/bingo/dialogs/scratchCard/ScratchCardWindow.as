package com.alisacasino.bingo.dialogs.scratchCard 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.commands.dialogCommands.ShowStore;
	import com.alisacasino.bingo.components.AlertSignView;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.IDialog;
	import com.alisacasino.bingo.dialogs.scratchCard.WinningsPlaque;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.scratchCard.ScratchCardModel;
	import com.alisacasino.bingo.models.scratchCard.ScratchResult;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.UIConstructor;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ScratchCardWindow extends FeathersControl implements IDialog
	{
		public static var WIDTH:uint = 1280;
		public static var HEIGHT:uint = 720;
		
		private const BG_WIDTH:int = 1152 * pxScale;
		private const BG_HEIGHT:int = 546 * pxScale;
		
		static public const SHOWING_WINNINGS:String = "showing_winnings";
		//static public const FINISHED:String = "finished";
		static public const CARD_BOUGHT:String = "cardBought";
		
		static public const STATE_FINISHED:String = "finished";
		
		private var title:ScratchCardTitle;
		
		private var scratchCardBody:ScratchCardBody;
		private var scratchButton:Button;
		private var scratchResult:ScratchResult;
		private var rulesImage:Image;
		
		private var cardBackground:Image;
		private var cardLogo:Image;
		private var cardWinLabel:XTextField;
		private var cardCashButtonLabel:XTextField;
		
		private var _state:String;
		private var isHiding:Boolean;
		private var isShowing:Boolean = true;
		private var closeButton:Button;
		private var type:String;
		private var price:int;
		private var winningsPlaque:WinningsPlaque;
		private var cardContainer:LayoutGroup;
		
		private var card3DContainer:Sprite3D;
		
		private var commitCloseFlag:Boolean;
		private var closeCalled:Boolean;
		
		private var fadeQuad:Quad;
		
		private var isLeftTabSelected:Boolean;
		
		public function ScratchCardWindow(type:String) 
		{
			this.type = type;
			isLeftTabSelected = type == ScratchCardModel.X50_CARD_TYPE;
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			if (_state != value)
			{
				_state = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			if (SoundManager.instance.soundLoadQueue)
				SoundManager.instance.soundLoadQueue.prioritizeScratchCardSounds();
			
			fadeQuad = new Quad(1, 1, 0x0);
			addChild(fadeQuad);
			
			price = gameManager.scratchCardModel.getPricePerScratch(type);
			
			var backgroundImageTexture:Texture;
			var logoImageTexture:Texture;
			var foregroundImageTexture:Texture;
			var rulesImageTexture:Texture;
			var winLabelColor:uint;
			var winningsColor:uint;
			
			if (type == ScratchCardModel.X20_CARD_TYPE )
			{
				backgroundImageTexture = AtlasAsset.ScratchCardAtlas.getTexture("green_background");
				logoImageTexture = AtlasAsset.ScratchCardAtlas.getTexture("big_logo_20x");
				foregroundImageTexture = AtlasAsset.ScratchCardAtlas.getTexture("green_foreground");
				rulesImageTexture = AtlasAsset.ScratchCardAtlas.getTexture("rules_20x");
				winLabelColor = 0xeffe00;
				winningsColor = 0xeffe00;
			}
			else
			{
				backgroundImageTexture = AtlasAsset.ScratchCardAtlas.getTexture("purple_background");
				logoImageTexture = AtlasAsset.ScratchCardAtlas.getTexture("big_logo_50x");
				foregroundImageTexture = AtlasAsset.ScratchCardAtlas.getTexture("purple_foreground");
				rulesImageTexture = AtlasAsset.ScratchCardAtlas.getTexture("rules_50x");
				winLabelColor = 0xea00ff;
				winningsColor = 0xf583ff;
			}
			
			card3DContainer = new Sprite3D();
			addChild(card3DContainer);
			
			cardContainer = new LayoutGroup();
			cardContainer.setSize(BG_WIDTH, BG_HEIGHT);
			cardContainer.alignPivot();
			card3DContainer.addChild(cardContainer);
			
			cardBackground = new Image(backgroundImageTexture);
			cardBackground.scale9Grid = ResizeUtils.getScaledRect(14, 0, 6, 546);
			cardBackground.width = 1152 * pxScale;
			cardBackground.height = 546 * pxScale;
			cardContainer.addChild(cardBackground);
			
			cardLogo = new Image(logoImageTexture);
			cardLogo.x = 16 * pxScale;
			cardLogo.y = 16 * pxScale;
			cardContainer.addChild(cardLogo);
			
			var buttonLabel:XTextField = new XTextField(215 * pxScale, 60 * pxScale, XTextFieldStyle.getWalrus(30, 0x5dff00), "PLAY FOR:");
			buttonLabel.x = 20 * pxScale;
			buttonLabel.y = 368 * pxScale;
			cardContainer.addChild(buttonLabel);
			
			cardWinLabel = new XTextField(330 * pxScale, 60 * pxScale, XTextFieldStyle.getWalrus(30, winLabelColor), "WIN:");
			cardWinLabel.x = 256 * pxScale;
			cardWinLabel.y = 368 * pxScale;
			cardContainer.addChild(cardWinLabel);
			
			scratchButton = new Button();
			//scratchButton.visible = false;
			scratchButton.useHandCursor = true;
			scratchButton.scaleWhenDown = 0.9;
			updateScratchButtonSkin();
			scratchButton.addEventListener(Event.TRIGGERED, scratchButton_triggeredHandler);
			scratchButton.move(22*pxScale, 420*pxScale);
			cardContainer.addChild(scratchButton);
			
			winningsPlaque = new WinningsPlaque(winningsColor);
			winningsPlaque.x = 256 * pxScale;
			winningsPlaque.y = 420 * pxScale;
			cardContainer.addChild(winningsPlaque);
			
			scratchCardBody = new ScratchCardBody(foregroundImageTexture);
			scratchCardBody.x = 598 * pxScale;
			scratchCardBody.y = 17 * pxScale;
			scratchCardBody.addEventListener(Event.TRIGGERED, scratchCardBody_triggeredHandler);
			cardContainer.addChild(scratchCardBody);
			
			rulesImage = new Image(rulesImageTexture);
			rulesImage.alignPivot();
			addChild(rulesImage)
			
			//scratchCardBody.showInvitation();
			
			
			closeButton = UIConstructor.dialogCloseButton(40, 17);
			closeButton.addEventListener(Event.TRIGGERED, handler_closeButton);
			addChild(closeButton);
			
			title = new ScratchCardTitle(callback_cardSwap, isLeftTabSelected);
			//title.y = 20 * pxScale;
			title.setSize(1280 * pxScale, 100 * pxScale);
			title.pivotX = 1280 * pxScale / 2;
			title.pivotY = 100 * pxScale / 2;
			addChild(title);
			
			if (isLeftTabSelected) 
			{
				card3DContainer.rotationX = 0;				
				changeViewToLeftCard();
			}
			else 
			{
				card3DContainer.rotationX = Math.PI;	
				changeViewToRightCard();
			}
			
			gameManager.scratchCardModel.markScratchCardAsShownForPlayer();
			setSizeToStage();
			
			Game.addEventListener(Game.STAGE_RESIZE, stageResizeHandler);
			
			Game.addEventListener(ConnectionManager.ROUND_STARTED_EVENT, handler_roundStarted);
			Game.addEventListener(Game.EVENT_ROUND_START_TIMEOUT, handler_roundStartTimeout);
		}
		
		
			
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_STATE))
			{
				//scratchButton.isEnabled = (state != CARD_BOUGHT) && isEnabled;
				//scratchButton.inProgress = !isEnabled;
				
				if (commitCloseFlag)
					tryCloseDialog();
			}
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				fadeQuad.x = -overWidth - 2;
				fadeQuad.y = -overHeight - 2;
				fadeQuad.width = gameManager.layoutHelper.stageWidth/scale + 4;
				fadeQuad.height = gameManager.layoutHelper.stageHeight/scale + 4;
				
				//cardContainer.move((width / scale) / 2, cardContainerY);
				
				card3DContainer.x = (width / scale) / 2;
				card3DContainer.y = cardContainerY;
				
				title.y = titleY;
				alignTitle()
				
				rulesImage.x = (width / scale)/2;
				rulesImage.y = height/scale + overHeight/2 - 40*pxScale;
				
				closeButton.x = width/scale + overWidth - closeButton.width / 2 + (layoutHelper.isIPhoneX ? 10 : 20) * pxScale;
				closeButton.y = titleY - 20*pxScale/**scale*///-overHeight + 60 * pxScale;
				
				
			}
			
			tweenAppear();
		}
		
		private function tweenAppear():void
		{
			if (!isShowing)
				return;
				
			isShowing = false;
			
			SoundManager.instance.playSfx(SoundAsset.RoundResultsPopup);
			
			var overHeight:int = this.overHeight;
			var overWidth:int = this.overWidth;
			
			fadeQuad.y = -fadeQuad.height - overHeight;
			fadeQuad.alpha = 0;
			Starling.juggler.tween(fadeQuad, 0.23, {y:-overHeight-2, alpha:1});
			
			EffectsManager.scaleJumpAppearBase(closeButton, 1, 0.6, 0.6);
			
			//cardContainer.y = -cardContainer.pivotY - 500 * pxScale;
			//TweenHelper.tween(cardContainer, 0.4, {y:(cardContainerY), scaleX:1, scaleY:1, transition:Transitions.EASE_OUT_BACK});	
			
			card3DContainer.y = -cardContainer.pivotY - 500 * pxScale;
			TweenHelper.tween(card3DContainer, 0.4, {y:(cardContainerY), scaleX:1, scaleY:1, transition:Transitions.EASE_OUT_BACK});	
				
			title.y = -overHeight - title.pivotY - 20 * pxScale;
			Starling.juggler.tween(title, 0.15, {y:titleY, delay:0.35, transition:Transitions.EASE_OUT});
			
			rulesImage.y = height/scale + overHeight + rulesImage.pivotY + 20*pxScale;
			Starling.juggler.tween(rulesImage, 0.15, {y:rulesImageY, delay:0.35, transition:Transitions.EASE_OUT});
			
		}
		
		protected function tweenHide():void
		{
			if (isHiding)
				return;	
				
			isHiding = true;	
			
			Game.removeEventListener(ConnectionManager.ROUND_STARTED_EVENT, handler_roundStarted);
			Game.removeEventListener(Game.EVENT_ROUND_START_TIMEOUT, handler_roundStartTimeout);
			
			fadeQuad.touchable = false;
			Starling.juggler.tween(fadeQuad, 0.23, { delay: 0.07, /*y:(-fadeQuad.height-overHeight),*/ alpha:0, transition:Transitions.EASE_IN });
			
			if (closeButton) {
				Starling.juggler.removeTweens(closeButton);
				closeButton.touchable = false;
				EffectsManager.scaleJumpDisappear(closeButton, 0.4);
			}
			
			//Starling.juggler.tween(cardContainer, 0.25, {y:(-cardContainer.pivotY - overHeight - 50 * pxScale), transition:Transitions.EASE_IN_BACK});
			Starling.juggler.tween(card3DContainer, 0.25, {y:(-cardContainer.pivotY - overHeight - 50 * pxScale), transition:Transitions.EASE_IN_BACK});
			
			Starling.juggler.tween(rulesImage, 0.15, {y:(height/scale + overHeight + 20*pxScale), transition:Transitions.EASE_OUT});
			
			Starling.juggler.tween(title, 0.15, {y:(-overHeight - 20 * pxScale), transition:Transitions.EASE_OUT});
			
			Starling.juggler.delayCall(removeDialog, 0.3);
			
			//removeDialog();
		}
		
		private function callback_cardSwap():void
		{
			if (isHiding)
				return;
			
			title.touchable = true;
			
			if (title.isLeftTabSelected == isLeftTabSelected)
				return;
			
			if (state == CARD_BOUGHT)
			{
				title.touchable = false;
				scratchCardBody.finishScratch();
				
				Starling.juggler.delayCall(callback_cardSwap, 1.3);
				return;
			}	
			
			isLeftTabSelected = title.isLeftTabSelected;
			
			Starling.juggler.removeTweens(card3DContainer);
			Starling.juggler.removeTweens(rulesImage);
				
			if (isLeftTabSelected) 
			{
				TweenHelper.tween(card3DContainer, 0.3, { rotationX:Math.PI/2, transition:Transitions.EASE_IN, onComplete:changeViewToLeftCard} )
					.chain(card3DContainer, 0.4, { rotationX:0, transition:Transitions.EASE_OUT_BACK } );				
			}
			else 
			{
				TweenHelper.tween(card3DContainer, 0.3, { rotationX:Math.PI/2, transition:Transitions.EASE_IN, onComplete:changeViewToRightCard} )
					.chain(card3DContainer, 0.4, { rotationX:Math.PI, transition:Transitions.EASE_OUT_BACK } );	
			}
			
			TweenHelper.tween(rulesImage, 0.3, { scaleY:0, transition:Transitions.EASE_IN_BACK} )
				.chain(rulesImage, 0.4, { scaleY:1, transition:Transitions.EASE_OUT_BACK} );				
		}
		
		private function changeViewToLeftCard():void 
		{
			type = ScratchCardModel.X50_CARD_TYPE;
			price = gameManager.scratchCardModel.getPricePerScratch(type);
			updateScratchButtonSkin();
			
			cardContainer.scaleY = 1;
			
			cardBackground.texture = AtlasAsset.ScratchCardAtlas.getTexture("purple_background");
			//cardBackground.readjustSize();
			
			cardLogo.texture = AtlasAsset.ScratchCardAtlas.getTexture("big_logo_50x");
			cardLogo.readjustSize();
			
			cardWinLabel.format.color = 0xea00ff;
			
			scratchCardBody.scratchOffTexture = AtlasAsset.ScratchCardAtlas.getTexture("purple_foreground");
			
			rulesImage.texture = AtlasAsset.ScratchCardAtlas.getTexture("rules_50x");
			rulesImage.readjustSize();
			
			winningsPlaque.baseColor = 0xf583ff;
			
			
			
			/*winningsPlaque.showGoodLuck();
			scratchCardBody.startGame(scratchResult);*/
		}
		
		private function updateCashButtonText():void 
		{
			if (isBonusScratch)
			{
				cardCashButtonLabel.text = "FREE";
			}
			else
			{
				cardCashButtonLabel.text = price.toString();
			}
		}
		
		private function changeViewToRightCard():void 
		{
			type = ScratchCardModel.X20_CARD_TYPE;
			price = gameManager.scratchCardModel.getPricePerScratch(type);
			updateScratchButtonSkin();
			
			cardContainer.scaleY = -1;
			
			cardBackground.texture = AtlasAsset.ScratchCardAtlas.getTexture("green_background");
			//cardBackground.readjustSize();
			
			cardLogo.texture = AtlasAsset.ScratchCardAtlas.getTexture("big_logo_20x");
			cardLogo.readjustSize();
			
			scratchCardBody.scratchOffTexture = AtlasAsset.ScratchCardAtlas.getTexture("green_foreground");
			
			cardWinLabel.format.color = 0xeffe00;
			
			rulesImage.texture = AtlasAsset.ScratchCardAtlas.getTexture("rules_20x");
			rulesImage.readjustSize();
			
			winningsPlaque.baseColor = 0xeffe00;
			
			
			
			/*winningsPlaque.showGoodLuck();
			scratchCardBody.startGame(scratchResult);*/
		}
		
		
		private function scratchCardBody_triggeredHandler(e:Event):void 
		{
			if (state != CARD_BOUGHT && state != SHOWING_WINNINGS)
			{
				scratchCardBody.noTutorial = true;
				buyScratch(e.data as Point);
			}
		}
		
		protected function createCashButtonSkin(price:Number):DisplayObject
		{
			var container:Sprite = new Sprite();
			
			var background:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture("button"));
			//background.scale9Grid = ResizeUtils.getScaledRect(15, 13, 175, 38);
			//background.width = 215 * pxScale;
			//background.height = 104 * pxScale;
			container.addChild(background);
			
			if (isBonusScratch)
			{
				cardCashButtonLabel = new XTextField(background.width, 100 * pxScale, XTextFieldStyle.getWalrus(52, 0xffffff).addShadow(2, 0x185d00, 1, 6), "");
				cardCashButtonLabel.x = 0;
				cardCashButtonLabel.y = 2 * pxScale;
				container.addChild(cardCashButtonLabel);
			}
			else
			{
				var cashIcon:Image = new Image(AtlasAsset.CommonAtlas.getTexture("bars/cash"));
				cashIcon.scale = 0.9
				cashIcon.alignPivot();
				cashIcon.x = 63 * pxScale;
				cashIcon.y = 50 * pxScale;
				container.addChild(cashIcon);
				
				cardCashButtonLabel = new XTextField(background.width - 36*pxScale, 100 * pxScale, XTextFieldStyle.getWalrus(52, 0xffffff).addShadow(2, 0x185d00, 1, 6), "");
				cardCashButtonLabel.x = 48 * pxScale;
				cardCashButtonLabel.y = 2 * pxScale;
				container.addChild(cardCashButtonLabel);
			}
			
			updateCashButtonText();
			
			return container;
		}
		
		override public function get isEnabled():Boolean 
		{
			return super.isEnabled;
		}
		
		override public function set isEnabled(value:Boolean):void 
		{
			super.isEnabled = value;
			if (scratchCardBody)
			{
				scratchCardBody.isEnabled = value;
			}
		}
		
		private function scratchButton_triggeredHandler(e:Event):void 
		{
			if (state == CARD_BOUGHT)
			{
				scratchButton.isEnabled = false;
				scratchCardBody.finishScratch();
			}
			else
			{
				scratchCardBody.noTutorial = true;
				buyScratch(null, true);
			}
		}
		
		
		private function buyScratch(sourcePoint:Point = null, autoScratch:Boolean = false):void 
		{
			if (isHiding)
				return;
				
				
			var isBonusScratchCached:Boolean = isBonusScratch;
				
			if (Player.current.cashCount < price && !isBonusScratchCached)
			{
				//close();	
				var popupColor:uint = type == ScratchCardModel.X20_CARD_TYPE ? ShowNoMoneyPopup.PURPLE : ShowNoMoneyPopup.GREEN;
				new ShowNoMoneyPopup(popupColor, cardContainer, new Point(scratchCardBody.x + scratchCardBody.width / 2, scratchCardBody.y + 100 * pxScale)).execute();
				return;
			}
			
			scratchResult = gameManager.scratchCardModel.buyScratchCard(type);
			
			startGame();
			if (autoScratch)
			{
				scratchCardBody.autoScratch();
			}
			
			if (!sourcePoint)
			{
				sourcePoint = new Point(layoutHelper.stageWidth - (layoutHelper.stageWidth - cardContainer.width*scale)/2 - 300*pxScale*scale, (layoutHelper.stageHeight - cardContainer.height*scale)/2 + 100*pxScale*scale);
			}
			
			if (!isBonusScratchCached)
			{
				showPriceFloat(sourcePoint, price);
			}
			
			
			state = CARD_BOUGHT;
			dispatchEventWith(CARD_BOUGHT);
		}
		
		private function get isBonusScratch():Boolean
		{
			return gameManager.scratchCardModel.hasBonusScratch(type);
		}
		
		private function showPriceFloat(sourcePoint:Point, price:int):void 
		{
			var container:Sprite = new Sprite();
			container.touchable = false;
			container.scale = cardContainer.scale;
			
			/*var label_0:XTextField = new XTextField(50*pxScale, 100*pxScale, XTextFieldStyle.getWalrus(52, 0xffffff, Align.RIGHT).addStroke(2, 0x0), '-');
			label_0.x = -55 * pxScale;
			label_0.y = -16 * pxScale;
			label_0.redraw();
			container.addChild(label_0);*/
			
			var cashIcon:Image = new Image(AtlasAsset.CommonAtlas.getTexture("bars/cash"));
			cashIcon.scale = 0.9;
			container.addChild(cashIcon);
			
			var label:XTextField = new XTextField(200*pxScale, 100*pxScale, XTextFieldStyle.getWalrus(52, 0xffffff, Align.LEFT).addStroke(2, 0x0), price.toString());
			//label.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			label.x = 70 * pxScale;
			label.y = -16 * pxScale;
			label.helperFormat.nativeTextExtraWidth = 9;
			label.redraw();
			container.addChild(label);
			
			sourcePoint.x = Math.min(sourcePoint.x, layoutHelper.stageWidth - 160*pxScale*cardContainer.scale);
			
			var localStart:Point = globalToLocal(sourcePoint);
			container.x = localStart.x - 60 * pxScale*cardContainer.scale;
			container.y = localStart.y - 80*pxScale*cardContainer.scale;
			addChild(container);
			
			Starling.juggler.tween(container, 2, { "y#":container.y - 100 * pxScale, "alpha#": 0, transition:Transitions.EASE_OUT, onComplete: container.removeFromParent});
		}
		
		private function startGame():void 
		{
			winningsPlaque.showGoodLuck();
			scratchCardBody.startGame(scratchResult);
			scratchCardBody.addEventListener(ScratchCardBody.SCRATCH_FINISHED, scratchCardBody_scratchFinishedHandler);
			scratchCardBody.addEventListener(ScratchCardBody.FINISHED, scratchCardBody_finishedHandler);
		}
		
		private function scratchCardBody_scratchFinishedHandler(e:Event):void 
		{
			Starling.juggler.delayCall(showWinnings, 0.8);
		}
		
		private function showWinnings():void 
		{
			state = SHOWING_WINNINGS;
			winningsPlaque.showWinnings(scratchResult.reward);
			updateScratchButtonSkin();
			scratchButton.isEnabled = true;
		}
		
		private function updateScratchButtonSkin():void 
		{
			scratchButton.defaultSkin = createCashButtonSkin(price);
			scratchButton.validate();
		}
		
		private function scratchCardBody_finishedHandler(e:Event):void 
		{
			//dispatchEventWith(FINISHED);
			state = STATE_FINISHED;
			if (Player.current && Player.current.isActivePlayer)
				close();
		}
		
		override protected function feathersControl_removedFromStageHandler(event:Event):void 
		{
			super.feathersControl_removedFromStageHandler(event);
			Game.removeEventListener(Game.STAGE_RESIZE, stageResizeHandler);
		}
		
		private function stageResizeHandler(e:Event):void 
		{
			setSizeToStage();
		}
		
		private function setSizeToStage():void 
		{
			setSizeInternal(gameManager.layoutHelper.stageWidth, gameManager.layoutHelper.stageHeight, true);
			invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (scratchCardBody)
			{
				scratchCardBody.dispose();
			}
		}
		
		private function handler_roundStartTimeout(event:Event):void 
		{
			if (int(event.data) <= 3 && !commitCloseFlag && (_state == CARD_BOUGHT || _state == SHOWING_WINNINGS)) 
			{
				if (state == CARD_BOUGHT)
				{
					scratchButton.isEnabled = false;
					scratchCardBody.touchable = false;
					scratchCardBody.finishScratch();
				}
			
				commitCloseFlag = true;	
				tryCloseDialog();
			}
		}
		
		private function handler_roundStarted(event:Event):void 
		{
			if (!commitCloseFlag) {
				commitCloseFlag = true;
				tryCloseDialog();
			}
		}
		
		private function tryCloseDialog():void 
		{
			if (Player.current.cards.length == 0 || closeCalled)
				return;
			
			if (_state == STATE_FINISHED || _state == null) 
			{
				closeCalled = true;
				Starling.juggler.delayCall(close, _state == STATE_FINISHED ? 0.5 : 0);
			}
		}
		
		protected function handler_closeButton(e:Event):void
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			close();
		}
		
		public function close():void
		{
			touchable = false;
			
			if (scratchCardBody) {
				scratchCardBody.removeEventListener(ScratchCardBody.SCRATCH_FINISHED, scratchCardBody_scratchFinishedHandler);
				scratchCardBody.removeEventListener(ScratchCardBody.FINISHED, scratchCardBody_finishedHandler);
				scratchCardBody.removeEventListener(Event.TRIGGERED, scratchCardBody_triggeredHandler);
			}
			
			dispatchEventWith(BaseDialog.DIALOG_CLOSED_EVENT);
			tweenHide();
		}	
		
		protected function removeDialog():void 
		{
			removeFromParent();
			dispose();
			//DisposalUtils.destroy(this);
			dispatchEventWith(BaseDialog.DIALOG_REMOVED_EVENT);
		}
		
		private function alignTitle():void
		{
			title.x = (width / scale) / 2;
			//if (!isShowing) 
				//starTitle.y = starTitleY; 
		}
		
		private function get titleY():int
		{
			return -overHeight / 2 + (height/scale - cardContainer.height)/2 -23 * pxScale;
		}

		private function get rulesImageY():int
		{
			return height/scale + overHeight/2 - 40*pxScale;
		}
		
		private function get cardContainerY():int {
			return (height/scale - cardContainer.height/Math.abs(cardContainer.scaleY)) / 2 + cardContainer.pivotY;
		}
		
		private function get overHeight():int
		{
			return (Math.max(0, gameManager.layoutHelper.stageHeight - height) / 2) / scale;
		}
		
		private function get overWidth():int
		{
			return (Math.max(0, gameManager.layoutHelper.stageWidth - width) / 2) / scale;
		}
		
		override public function set scale(value:Number):void 
		{
			super.scale = value;
			invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		override public function get width():Number {
			return WIDTH * pxScale * scale;
		}
		
		override public function get height():Number {
			return HEIGHT * pxScale * scale;
		}
		
		
		/* INTERFACE com.alisacasino.bingo.dialogs.IDialog */
		
		public function get fadeStrength():Number 
		{
			return 0.0;
		}
		
		public function get blockerFade():Boolean 
		{
			return true;
		}
		
		public function get fadeClosable():Boolean 
		{
			return false;
		}
		
		public function get align():String 
		{
			return Align.CENTER;
		}
		
		public function get selfScaled():Boolean 
		{
			return false;
		}
		
		public function get baseScale():Number
		{
			return layoutHelper.independentScaleFromEtalonMin;
		}
		
	}

}