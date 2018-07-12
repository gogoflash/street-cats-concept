package com.alisacasino.bingo.dialogs.scratchCard
{
	import by.blooddy.crypto.image.palette.IPalette;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.components.AlertSignView;
	import com.alisacasino.bingo.controls.BingoTextFormat;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.utils.JumpWithHintHelper;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.TimeService;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import flash.filters.GlowFilter;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Align;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ScratchCardTitle extends FeathersControl
	{
		private var titleLabel:XTextField;
		private var timerLabel:TextField;
		private var previousValue:String;
		
		private var leftTabLabel:XTextField;
		private var rightTabLabel:XTextField;
		private var swapTabButton:Button;
		
		private var tabSwapCallback:Function;
		
		public var isLeftTabSelected:Boolean;
		
		private var tabLabelsGap:int = 65 * pxScale;
		private var swapButtonImage:Image;
		private var swapButtonTouchQuad:Quad;
		private var swapButtonContent:Sprite;
		private var swapButtonTweenId:uint;
		
		private var freeLowScratchesIndicator:AlertSignView;
		private var freeHighScratchesIndicator:AlertSignView;
		
		public function ScratchCardTitle(tabSwapCallback:Function, isLeftTabSelected:Boolean)
		{
			this.tabSwapCallback = tabSwapCallback;
			this.isLeftTabSelected = isLeftTabSelected;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			titleLabel = new XTextField(840 * pxScale, 64 * pxScale, XTextFieldStyle.BuyCardsTitle);
			titleLabel.touchable = false;
			addChild(titleLabel);
			
			//setDefaultTitle();
			setTabsTitle();
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			showSwapButtonTween(0.9);
		
		}
		
		private function enterFrameHandler(e:Event):void
		{
			//timerLabel.text = StringUtils.formatTime(timeout, "{1}:{2}:{3}", false, false, true);
			if (gameManager.deactivated || !Player.current)
				return;
			
			if (!Player.current.hasCards || !Room.current || isNaN(Room.current.estimatedRoundEnd))
			{
				//setDefaultTitle();
				setTabsTitle();
				titleLabel.visible = false;
				return;
			}
			
			leftTabLabel.visible = false;
			rightTabLabel.visible = false;
			freeLowScratchesIndicator.visible = false;
			freeHighScratchesIndicator.visible = false;
			//swapTabButton.visible = false;
			
			//var roundTimeLeft:Number = Room.current.estimatedRoundEnd - TimeService.serverTimeMs;
			var roundStartsIn:Number = Room.current.roundStartTime - TimeService.serverTimeMs;
			var bingosLeft:int = Room.current.bingosLeft;
			
			titleLabel.visible = true;
			titleLabel.text = "ROUND STARTS IN:";
			
			if (Room.current.roundStartTime != 0 || (Player.current && Player.current.isActivePlayer))
			{
				if (roundStartsIn < 0)
				{
					setRoundStarted();
				}
				else
				{
					var minutesLeft:Number = int(roundStartsIn / 60 / 1000);
					var secondsLeft:Number = int((roundStartsIn / 1000) % 60);
					var secondsString:String = secondsLeft > 9 ? secondsLeft.toString() : "0" + secondsLeft.toString();
					setTimerLabel(minutesLeft.toString() + ":" + secondsString);
				}
			}
			else if (bingosLeft > 0)
			{
				setTimerLabel(bingosLeft + " BINGO" + (bingosLeft > 1 ? "S" : ""));
			}
			else
			{
				setTimerLabel("WAIT...");
			}
		}
		
		private function setRoundStarted():void
		{
			if (gameManager.deactivated)
				return;
			
			titleLabel.text = 'ROUND STARTED!';
			setTimerLabel(null);
			invalidate(INVALIDATION_FLAG_LAYOUT);
		}
		
		private function setDefaultTitle():void
		{
			if (gameManager.deactivated)
				return;
			
			titleLabel.text = 'SCRATCH CARD';
			setTimerLabel(null);
			invalidate(INVALIDATION_FLAG_LAYOUT);
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE) || isInvalid(INVALIDATION_FLAG_LAYOUT))
			{
				alignTitleAndTimerLabel();
			}
		}
		
		private function setTimerLabel(value:String):void
		{
			if (previousValue == value)
				return;
			
			previousValue = value;
			if (value)
			{
				if (!timerLabel)
				{
					var bingoTextFormat:BingoTextFormat = new BingoTextFormat(Fonts.WALRUS_BOLD, titleLabel.format.size, 0xFFFC00, Align.LEFT);
					bingoTextFormat.nativeFilters = [new GlowFilter(0x293036, 1, 4 * pxScale, 4 * pxScale, 12 * pxScale)];
					
					timerLabel = new TextField(400 * pxScale, 64 * pxScale, '12:12:12', bingoTextFormat);
					timerLabel.touchable = false;
					addChild(timerLabel);
				}
				
				timerLabel.text = value;
				alignTitleAndTimerLabel();
			}
			else
			{
				if (timerLabel)
				{
					timerLabel.removeFromParent();
					timerLabel = null;
				}
			}
		}
		
		private function alignTitleAndTimerLabel():void
		{
			if (gameManager.deactivated)
				return;
			
			if (!timerLabel)
			{
				titleLabel.x = (width - titleLabel.width) / 2;
				
				if (leftTabLabel)
				{
					leftTabLabel.x = leftTabLabel.pivotX + (width - leftTabLabel.width - rightTabLabel.width - tabLabelsGap) / 2;
					rightTabLabel.x = rightTabLabel.pivotX + leftTabLabel.x - leftTabLabel.pivotX + leftTabLabel.width + tabLabelsGap + (freeLowScratchesIndicator.visible ? 34 * pxScale : 0);
					swapTabButton.x = leftTabLabel.x - leftTabLabel.pivotX + leftTabLabel.width + tabLabelsGap / 2 - swapButtonTouchQuad.width / 2;
					
					freeLowScratchesIndicator.x = rightTabLabel.x - rightTabLabel.width / 2 + 7 * pxScale;
					freeLowScratchesIndicator.y = rightTabLabel.y - 2 * pxScale;// 14 * pxScale;
					
					freeHighScratchesIndicator.x = leftTabLabel.x - leftTabLabel.width / 2 + 7 * pxScale;
					freeHighScratchesIndicator.y = leftTabLabel.y - 2 * pxScale;//- 14 * pxScale;
				}
				
				return;
			}
			
			swapTabButton.x = tabLabelsGap / 2 + swapButtonTouchQuad.width / 2;
			
			timerLabel.scale = titleLabel.scale;
			timerLabel.y = titleLabel.y;
			timerLabel.pivotY = titleLabel.pivotY;
			
			var titleWidth:Number = (titleLabel.textBounds.width + 240 * pxScale) * titleLabel.scale;
			titleLabel.x = (width - titleWidth) / 2 - titleLabel.textBounds.x * titleLabel.scale;
			
			var timerLabelNewX:Number = titleLabel.x + (titleLabel.textBounds.x + titleLabel.textBounds.width - timerLabel.textBounds.x + 3 * pxScale) * titleLabel.scale;
			
			if (Math.abs(timerLabelNewX - timerLabel.x) > 20)
				timerLabel.x = timerLabelNewX;
		}
		
		private function setTabsTitle():void
		{
			if (gameManager.deactivated)
				return;
			
			if (!leftTabLabel)
			{
				leftTabLabel = new XTextField(500 * pxScale, 64 * pxScale, XTextFieldStyle.getWalrus(42));
				leftTabLabel.isHtmlText = true;
				leftTabLabel.alignPivot();
				leftTabLabel.y = leftTabLabel.pivotY;
				addChild(leftTabLabel);
				var leftTabJumpHelper:JumpWithHintHelper = new JumpWithHintHelper(leftTabLabel, true, true);
				leftTabJumpHelper.setStateCallbacks(null, null, selectLeftTab);
				
				rightTabLabel = new XTextField(500 * pxScale, 64 * pxScale, XTextFieldStyle.getWalrus(42));
				rightTabLabel.isHtmlText = true;
				rightTabLabel.alignPivot();
				rightTabLabel.y = rightTabLabel.pivotY;
				addChild(rightTabLabel);
				var rightTabJumpHelper:JumpWithHintHelper = new JumpWithHintHelper(rightTabLabel, true, true);
				rightTabJumpHelper.setStateCallbacks(null, null, selectRightTab);
				
				swapButtonContent = new Sprite();
				
				swapButtonTouchQuad = new Quad(1, 1);
				swapButtonTouchQuad.width = 150 * pxScale;
				swapButtonTouchQuad.height = 110 * pxScale;
				swapButtonTouchQuad.alpha = 0;
				swapButtonContent.addChild(swapButtonTouchQuad);
				
				swapButtonImage = new Image(AtlasAsset.ScratchCardAtlas.getTexture("change_arrow"));
				swapButtonImage.scale = 1;
				swapButtonImage.pivotX = 29.5 * pxScale;
				swapButtonImage.pivotY = 37 * pxScale;
				swapButtonImage.x = swapButtonTouchQuad.width / 2;
				swapButtonImage.y = swapButtonTouchQuad.height / 2;
				swapButtonImage.alignPivot();
				swapButtonContent.addChild(swapButtonImage);
				
				swapTabButton = new Button();
				swapTabButton.addEventListener(Event.TRIGGERED, handler_swapTriggered);
				swapTabButton.defaultSkin = swapButtonContent;
				swapTabButton.scaleWhenDown = 1;
				swapTabButton.scaleWhenHovering = 1;
				//swapTabButton.validate();
				swapTabButton.useHandCursor = true;
				addChild(swapTabButton);
				swapTabButton.y = 32 * pxScale - swapButtonTouchQuad.height / 2;
				//new JumpWithHintHelper(swapTabButton, true, true);
				
				freeLowScratchesIndicator = new AlertSignView("");
				freeLowScratchesIndicator.touchable = false;
				addChild(freeLowScratchesIndicator);
				
				freeHighScratchesIndicator = new AlertSignView("");
				freeHighScratchesIndicator.touchable = false;
				addChild(freeHighScratchesIndicator);
				
				refreshTabsState();
				refreshIndicatorsState();
			}
			else if (leftTabLabel.visible)
			{
				refreshIndicatorsState();
				return;
			}
			
			leftTabLabel.visible = true;
			rightTabLabel.visible = true;
			swapTabButton.visible = true;
			
			refreshTabsState();
			
			setTimerLabel(null);
			invalidate(INVALIDATION_FLAG_LAYOUT);
		}
		
		private function refreshIndicatorsState():void
		{
			if (freeLowScratchesIndicator.visible && !(gameManager.scratchCardModel.bonusScratchesLow > 0))
			{
				invalidate(INVALIDATION_FLAG_SIZE);
			}
			freeLowScratchesIndicator.visible = gameManager.scratchCardModel.bonusScratchesLow > 0;
			freeLowScratchesIndicator.text = gameManager.scratchCardModel.bonusScratchesLow.toString();
			
			freeHighScratchesIndicator.visible = gameManager.scratchCardModel.bonusScratchesHigh > 0;
			freeHighScratchesIndicator.text = gameManager.scratchCardModel.bonusScratchesHigh.toString();
		}
		
		private function selectLeftTab():void
		{
			if (!isLeftTabSelected)
				handler_swapTriggered(null);
		}
		
		private function selectRightTab():void
		{
			if (isLeftTabSelected)
				handler_swapTriggered(null);
		}
		
		private function refreshTabsState():void
		{
			if (gameManager.deactivated)
				return;
			
			if (isLeftTabSelected)
			{
				leftTabLabel.text = "SCRATCH CARD <font color=\"#B665FF\">50X</font>";
				rightTabLabel.text = "<font color=\"#686868\">SCRATCH CARD 20X</font>";
			}
			else
			{
				leftTabLabel.text = "<font color=\"#686868\">SCRATCH CARD 50X</font>";
				rightTabLabel.text = "SCRATCH CARD <font color=\"#40FF01\">20X</font>";
			}
		}
		
		private function handler_swapTriggered(event:Event):void
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			
			isLeftTabSelected = !isLeftTabSelected;
			
			refreshTabsState();
			
			tabSwapCallback();
			
			showSwapButtonTween(0);
		}
		
		override public function dispose():void
		{
			Starling.juggler.removeByID(swapButtonTweenId);
			super.dispose();
		}
		
		private function showSwapButtonTween(delay:Number = 0):void
		{
			Starling.juggler.removeByID(swapButtonTweenId);
			var r:Number = Math.abs(Math.ceil(swapButtonImage.rotation / (Math.PI * 2)));
			swapButtonTweenId = Starling.juggler.tween(swapButtonImage, 0.8, {delay: delay, rotation: ((r - 1) * Math.PI * 2 - 0.00000000001), transition: Transitions.EASE_IN_OUT, onComplete: showSwapButtonTween, onCompleteArgs: [5]});
		}
	}

}