package com.alisacasino.bingo.screens.miniGames
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.components.AlertSignView;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.cardBuy.BuyCardsView;
	import com.alisacasino.bingo.dialogs.scratchCard.ScratchCardWindow;
	import com.alisacasino.bingo.dialogs.slots.SlotsDialog;
	import com.alisacasino.bingo.models.scratchCard.ScratchCardModel;
	import com.alisacasino.bingo.screens.GameScreen;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	
	public class MiniGamesView extends FeathersControl
	{
		static public const STATE_CHOOSE:String = "STATE_CHOOSE";
		static public const STATE_SCRATCH_20:String = "STATE_SCRATCH_20";
		static public const STATE_SCRATCH_50:String = "STATE_SCRATCH_50";
		
		private var buyCardsView:BuyCardsView;
		
		private var _state:String;
		
		private var debugQuad:Quad;
		
		private var slotsButton:Button;
		private var scratchButton:Button;
		private var bonusScratchesIndicator:AlertSignView;
		private var bonusSpinsIndicator:AlertSignView;
		private var slotPreview:AnimationContainer;
		private var container:LayoutGroup;
		
		public function MiniGamesView(buyCardsView:BuyCardsView)
		{
			this.buyCardsView = buyCardsView;
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			if (_state != value) {
				_state = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		override protected function initialize():void 
		{
			super.initialize();
				
			scratchButton = new Button();
			scratchButton.useHandCursor = true;
			scratchButton.defaultSkin = new Image(AtlasAsset.ScratchCardAtlas.getTexture("scratch_logo_50"));
			scratchButton.addEventListener(Event.TRIGGERED, scratch_50_triggeredHandler);
			addChild(scratchButton);
			
			bonusScratchesIndicator = new AlertSignView("");
			bonusScratchesIndicator.touchable = false;
			addChild(bonusScratchesIndicator);
			
			slotPreview = new AnimationContainer(MovieClipAsset.PackCommon, true, true);
			slotPreview.playTimeline('slot_preview', false, true);
			
			slotsButton = new Button();
			slotsButton.setSize(slotPreview.clipWidth * pxScale, slotPreview.clipHeight * pxScale);
			slotsButton.useHandCursor = true;
			slotsButton.defaultSkin = slotPreview;
			slotsButton.addEventListener(Event.TRIGGERED, scratch_20_triggeredHandler);
			addChild(slotsButton);
			
			bonusSpinsIndicator = new AlertSignView("");
			bonusSpinsIndicator.touchable = false;
			addChild(bonusSpinsIndicator);
		}
		
		override protected function feathersControl_addedToStageHandler(event:Event):void 
		{
			super.feathersControl_addedToStageHandler(event);
			
			gameManager.scratchCardModel.addEventListener(Event.CHANGE, scratchCardModel_changeHandler);
			gameManager.slotsModel.addEventListener(Event.CHANGE, slotsModel_changeHandler);
			
			updateBonusMinigamesCount();
		}
		
		private function slotsModel_changeHandler(e:Event):void 
		{
			updateBonusMinigamesCount();
		}
		
		private function scratchCardModel_changeHandler(e:Event):void 
		{
			updateBonusMinigamesCount();
		}
		
		override protected function feathersControl_removedFromStageHandler(event:Event):void 
		{
			super.feathersControl_removedFromStageHandler(event);
			
			gameManager.scratchCardModel.removeEventListener(Event.CHANGE, scratchCardModel_changeHandler);
			gameManager.slotsModel.removeEventListener(Event.CHANGE, slotsModel_changeHandler);
		}
		
		private function scratch_20_triggeredHandler(e:Event):void 
		{
			gameManager.slotsModel.showDialog();
			//DialogsManager.addDialog(new SlotsDialog());
		}
		
		private function scratch_50_triggeredHandler(e:Event):void 
		{
			if (gameManager.scratchCardModel.bonusScratchesLow > 0 && gameManager.scratchCardModel.bonusScratchesHigh <= 0)
			{
				DialogsManager.addDialog(new ScratchCardWindow(ScratchCardModel.X20_CARD_TYPE));
			}
			else
			{
				DialogsManager.addDialog(new ScratchCardWindow(ScratchCardModel.X50_CARD_TYPE));
			}
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE)) {
				resize();
			}
			
			if (isInvalid(INVALIDATION_FLAG_STATE))
			{
				updateBonusMinigamesCount();
			}
		}	
		
		private function updateBonusMinigamesCount():void 
		{
			var bonusScratches:int = gameManager.scratchCardModel.totalBonusScratches;
			bonusScratchesIndicator.visible = bonusScratches > 0;
			bonusScratchesIndicator.text = bonusScratches.toString();
			
			var bonusSpins:int = gameManager.slotsModel.totalBonusSpins;
			bonusSpinsIndicator.visible = bonusSpins > 0;
			bonusSpinsIndicator.text = bonusSpins.toString();
		}
		
		private function resize():void
		{
			var outerScale:Number = gameManager.layoutHelper.independentScaleFromEtalonMin;
			if (debugQuad) {
				debugQuad.width = width;
				debugQuad.height = height;
			}
			
			if (state == STATE_CHOOSE)
			{
				scratchButton.validate();
				slotsButton.validate();
				
				scratchButton.scale = buyCardsView.backgroundScale;
				slotsButton.scale = buyCardsView.backgroundScale;
				
				scratchButton.x = (width - scratchButton.width - slotsButton.width - 64 * pxScale)/2;
				scratchButton.y = 16 * pxScale * slotsButton.scale;
				
				bonusScratchesIndicator.x = scratchButton.x + scratchButton.width - 16 * pxScale * scratchButton.scale;
				bonusScratchesIndicator.y = scratchButton.y + 4 * pxScale * scratchButton.scale;
				bonusScratchesIndicator.scale = scratchButton.scale * 1.2;
				
				slotsButton.x = scratchButton.x + scratchButton.width + 84 * pxScale;
				slotsButton.y = 0 * pxScale * slotsButton.scale;
				
				bonusSpinsIndicator.x = slotsButton.x + slotsButton.width - 0 * pxScale * slotsButton.scale;
				bonusSpinsIndicator.y = slotsButton.y + 19 * pxScale * scratchButton.scale;;
				bonusSpinsIndicator.scale = slotsButton.scale * 1.2;
			}
			else if (state == STATE_SCRATCH_20)
			{
				
			}
			else if (state == STATE_SCRATCH_50)
			{
				
			}	
			
		}
		
		
	}
}