package com.alisacasino.bingo.dialogs.scratchCard
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.player.CollectCommodityItem;
	import com.alisacasino.bingo.dialogs.scratchCard.messageContainerClasses.MessageContainer;
	import com.alisacasino.bingo.models.scratchCard.ScratchItem;
	import com.alisacasino.bingo.models.scratchCard.ScratchResult;
	import com.alisacasino.bingo.models.universal.CommoditySource;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.analytics.events.CommodityAddedEvent;
	import com.alisacasino.bingo.utils.analytics.events.ScratchCardResultEvent;
	import com.alisacasino.bingo.utils.sharedObjects.SharedObjectManager;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import starling.animation.IAnimatable;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ScratchCardBody extends FeathersControl
	{
		static public const SHOW_PROMPT_LIMIT:int = 3;
		
		static public const FINISHED:String = "finished";
		static public const SCRATCH_FINISHED:String = "scratchFinished";
		public var noTutorial:Boolean;
		
		static private const STATE_WAITING_FOR_INVITATION:String = "stateWaitingForInvitation";
		static private const STATE_WAITING_FOR_PURCHASE:String = "stateWaitingForPurchase";
		static private const STATE_IN_PROGRESS:String = "stateInProgress";
		static private const STATE_FINISHED:String = "stateInProgress";
		
		private var scratchResult:ScratchResult;
		private var scratchLayer:ScratchLayer;
		private var itemLayer:ItemLayer;
		private var messageContainer:MessageContainer;
		private var state:String;
		private var showPromptOnTouch:Boolean;
		private var promptCall:uint;
		private var _scratchOffTexture:Texture;
		private var resetAlphaID:int = -1;
		
		public function ScratchCardBody(scratchOffTexture:Texture)
		{
			_scratchOffTexture = scratchOffTexture;
		}
		
		public function set scratchOffTexture(value:Texture):void
		{
			if (_scratchOffTexture == value)
				return;
				
			_scratchOffTexture = value;	
			scratchLayer.scratchLayerTexture = _scratchOffTexture;
		}
		
		public function get scratchOffTexture():Texture
		{
			return _scratchOffTexture;
		}		
		
		override protected function initialize():void
		{
			super.initialize();
			
			var background:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture("scratch_background"));
			background.x = 2*pxScale;
			background.y = 1 * pxScale;
			background.width = background.texture.frameWidth - 1*pxScale;
			background.height = background.texture.frameHeight - 1*pxScale;
			addChild(background);
			
			width = background.width;
			height = background.height;
			
			//background.x = background.width * 0.005 / 2;
			//background.scale = 0.995; // Prevents some ugly pixel mixing on the bottom right edge
			
			
			itemLayer = new ItemLayer();
			itemLayer.x = 8 * pxScale
			itemLayer.y = 8 * pxScale
			itemLayer.setSize(width - itemLayer.x * 1.5, height - itemLayer.y * 2);
			addChild(itemLayer);
			
			scratchLayer = new ScratchLayer(scratchOffTexture);
			scratchLayer.isEnabled = false;
			scratchLayer.addEventListener(Event.TRIGGERED, scratchLayer_triggeredHandler);
			addChild(scratchLayer);
			
			scratchLayer.addEventListener(TouchEvent.TOUCH, scratchLayer_touchHandler);
			
			messageContainer = new MessageContainer();
			messageContainer.setSize(width, height);
			addChild(messageContainer);
			messageContainer.showTutorial();
		}
		
		private function scratchLayer_touchHandler(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(scratchLayer);
			if (!touch)
				return;
			
			if (touch.phase == TouchPhase.HOVER)
				return;
			
			if (showPromptOnTouch && false)
			{
				messageContainer.showPrompt();
				showPromptOnTouch = false;
			}
			else
			{
				if (touch.phase == TouchPhase.BEGAN)
				{
					dispatchEventWith(Event.TRIGGERED, false, new Point(touch.globalX, touch.globalY));
				}
			}
		}
		
		public function showInvitation():void
		{
			if (!isInitialized)
				initializeNow();
			
			messageContainer.showInvitationMessage();
			state = STATE_WAITING_FOR_INVITATION;
			showPromptOnTouch = true;
		}
		
		public function showPromptIfNeeded():void
		{
			var promptShown:int = SharedObjectManager.instance.getSharedProperty("scratchCardPromptShown", 0);
			if (promptShown >= SHOW_PROMPT_LIMIT)
			{
				messageContainer.hideAllMessages();
				showPromptOnTouch = true;
			}
			else
			{
				messageContainer.showPrompt();
				promptShown++;
				SharedObjectManager.instance.setSharedProperty("scratchCardPromptShown", promptShown);
			}
		}
		
		private function startFinishAnimation():void
		{
			Starling.juggler.tween(scratchLayer, 0.5, {"alpha#": 0, onComplete: onScratchFinishAlphaComplete});
		}
		
		private function onScratchFinishAlphaComplete():void
		{
			scratchLayer.isEnabled = false;
			
			
			if (scratchResult.primeItem.winningQuantity == 0)
			{
				SoundManager.instance.playSfx(SoundAsset.SfxScratchCardTryAgain, 0, 0, 0.55);
				Starling.juggler.delayCall(showTryAgain, 0.1);
			}
			else
			{
				showWinnings();
			}
			
		}
		
		private function showTryAgain():void
		{
			resetAlpha();
			
			messageContainer.showTryAgainMessage();
			
			clearPromptCall();
			promptCall = Starling.juggler.delayCall(setShowPromptOnTouch, 1, true);
			
			finish();
		}
		
		private function clearPromptCall():void 
		{
			if (promptCall != 0)
			{
				Starling.juggler.removeByID(promptCall);
				promptCall = 0;
			}
		}
		
		private function setShowPromptOnTouch(value:Boolean = false):void 
		{
			showPromptOnTouch ||= value;
		}
		
		private function showWinnings():void
		{
			
			itemLayer.highlightWinnings(scratchResult.primeItem);
			
			showNormalWin();
	
			new CollectCommodityItem(scratchResult.reward, CommoditySource.SOURCE_SCRATCH_CARD + ':' + scratchResult.cardType).execute();
			gameManager.analyticsManager.sendEvent(new ScratchCardResultEvent(scratchResult.primeItem.winningQuantity, scratchResult.primeItem.multiplier));
		}
		
		private function showNormalWin():void 
		{
			Starling.juggler.delayCall(playWinSfx, 0.2);
			Starling.juggler.delayCall(showGoldPlaque, 0.18);
		}
		
		private function playWinSfx():void 
		{
			SoundManager.instance.playSfx(SoundAsset.SfxScratchCardWin, 0, 0, 0.55);
		}
		
		private function showGoldPlaque():void
		{
			/*
			if (!goldPlaque)
			{
				goldPlaque = new GoldPlaqueContainer();
				goldPlaque.setSize(width, height);
			}
			addChild(goldPlaque);
			goldPlaque.show(scratchResult.reward, 1.3, onGoldPlaqueHide);
			*/
			Starling.juggler.delayCall(resetAlpha, 3.3);
			Starling.juggler.delayCall(onGoldPlaqueHide, 3.6);
		}
		
		private function onGoldPlaqueHide():void
		{
			resetForNextGame();
			messageContainer.showTryAgainMessage();
		}
		
		private function resetForNextGame():void 
		{
			showPromptOnTouch = true;
			finish();
		}
		
		private function finish():void
		{
			state = STATE_FINISHED;
			dispatchEventWith(FINISHED);
		}
		
		override public function dispose():void
		{
			scratchLayer.dispose();
			
			messageContainer.dispose();
			
			super.dispose();
		}
		
		public function startGame(scratchResult:ScratchResult):void
		{
			this.scratchResult = scratchResult;
			
			Starling.juggler.removeDelayedCalls(resetAlpha);
			Starling.juggler.removeDelayedCalls(playWinSfx);
			Starling.juggler.removeDelayedCalls(showGoldPlaque);
			Starling.juggler.removeDelayedCalls(onGoldPlaqueHide);
			
			showPromptOnTouch = false;
			clearPromptCall();
			
			if (state == STATE_FINISHED)
			{
				resetAlpha(updateItemsAndEnableLayer);
			}
			else
			{
				updateItemsAndEnableLayer();
			}
		}
		
		private function updateItemsAndEnableLayer():void
		{
			if (resetAlphaID != -1)
			{
				Starling.juggler.removeByID(resetAlphaID);
				resetAlphaID = -1;
			}
			
			state = STATE_IN_PROGRESS;
			
			itemLayer.scratchResult = scratchResult;
			
			scratchLayer.addEventListener(ScratchLayer.FINISHED, scratchLayer_finishedHandler);
			scratchLayer.isEnabled = true;
			
			if (noTutorial)
			{
				messageContainer.hideAllMessages();
			}
			else
			{
				messageContainer.showTutorial();
				scratchLayer.addEventListener(Event.TRIGGERED, scratchLayer_triggeredHandler);
			}
		}
		
		public function scratchLayer_triggeredHandler(e:Event):void
		{
			messageContainer.hideTutorial();
		}
		
		public function autoScratch():void 
		{
			resetAlpha(updateItemsAndEnableLayer, 0);
			scratchLayer.autoScratch();
			messageContainer.hideAllMessages();
			scratchLayer.isEnabled = false;
		}
		
		public function finishScratch():void 
		{
			scratchLayer.finishAutoScratch();
		}
		
		private function resetAlpha(onComplete:Function = null, time:Number = 0.2):void
		{
			scratchLayer.reset();
			if (time == 0.)
			{
				Starling.juggler.removeTweens(scratchLayer);
				scratchLayer.alpha = 1;
				onComplete();
			}
			else
			{
				if (resetAlphaID != -1)
				{
					Starling.juggler.removeByID(resetAlphaID);
				}
				resetAlphaID = Starling.juggler.tween(scratchLayer, time, {"alpha#": 1, transition: Transitions.EASE_IN, onComplete: onComplete});
			}
		}
		
		private function scratchLayer_finishedHandler(e:Event):void
		{
			startFinishAnimation();
			dispatchEventWith(SCRATCH_FINISHED);
			scratchLayer.removeEventListener(ScratchLayer.FINISHED, scratchLayer_finishedHandler);
		}
		
		override protected function draw():void
		{
			super.draw();
		}
	}

}