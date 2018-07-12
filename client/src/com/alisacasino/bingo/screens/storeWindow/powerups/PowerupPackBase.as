package com.alisacasino.bingo.screens.storeWindow.powerups 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.commands.dialogCommands.ShowStore;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.powerups.PowerupDropTable;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.store.items.PowerupPackStoreItem;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAStoreItemTransactionEvent;
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import starling.animation.Transitions;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class PowerupPackBase extends FeathersControl
	{
		private var priceType:int;
		private var button:Button;
		public var powerupPackStoreItem:PowerupPackStoreItem;
		protected var baseWidth:Number;
		protected var baseHeight:Number;
		
		protected var price:Number;
		
		protected var commonQuantity:int = 0;
		protected var magicQuantity:int = 0;
		protected var rareQuantity:int = 0;
		
		protected var cardsTotal:int = 0;
		
		public function PowerupPackBase(powerupPackStoreItem:PowerupPackStoreItem) 
		{
			this.powerupPackStoreItem = powerupPackStoreItem;
			
			baseWidth = 252 * pxScale;
			baseHeight = 294 * pxScale;
			
			magicQuantity = powerupPackStoreItem.magicQuantity;
			commonQuantity = powerupPackStoreItem.normalQuantity;
			rareQuantity = powerupPackStoreItem.rareQuantity;
			price = powerupPackStoreItem.price;
			priceType = powerupPackStoreItem.priceType;
			
			if(commonQuantity > 0)
				cardsTotal++;
			if(magicQuantity > 0)
				cardsTotal++;
			if(rareQuantity > 0)
				cardsTotal++;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			var background:Image = new Image(AtlasAsset.CommonAtlas.getTexture("store/grey_background_white_frame"));
			background.scale9Grid = ResizeUtils.getScaledRect(28, 23, 2, 2);
			background.width = baseWidth;
			background.height = baseHeight;
			addChild(background);
			
			var invisButton:BasicButton = new BasicButton();
			var quad:Quad = new Quad(baseWidth, baseHeight);
			quad.alpha = 0;
			invisButton.defaultSkin = quad;
			invisButton.addEventListener(Event.TRIGGERED, invisButton_triggeredHandler);
			addChild(invisButton);
			
			button = new Button();
			button.scaleWhenDown = 0.9;
			button.useHandCursor = true;
			button.defaultSkin = createButtonSkin();
			button.validate();
			button.alignPivot();
			button.x = baseWidth / 2;
			button.y = background.height - 90 * pxScale + button.pivotY;
			button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			addChild(button);
			
			createIcons();
		}
		
		private function invisButton_triggeredHandler(e:Event):void 
		{
			initiatePurchase();
		}
		
		private function createButtonSkin():DisplayObject
		{
			if (priceType == Type.REAL)
			{
				return createUSDButtonSkin();
			}
			else
			{
				return createCashButtonSkin();
			}
		}
		
		private function button_triggeredHandler(e:Event):void 
		{
			initiatePurchase();
		}
		
		private function initiatePurchase():void 
		{
			if (priceType == Type.REAL)
			{
				if (!powerupPackStoreItem)
				{
					sosTrace("No store item", SOSLog.ERROR);
				}
				else 
				{
					LoadingWheel.show();
					PlatformServices.store.purchaseItem(powerupPackStoreItem);
				}
			}
			else
			{
				if (Player.current)
				{
					if (Player.current.cashCount < price)
					{
						dispatchEventWith(PowerupsStoreContent.SHOW_NO_MONEY);
						return;
					}
					Player.current.updateCashCount(-price, "powerupPackPurchase");
					var powerupList:Object = completePurchase();
					gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreItemTransactionEvent(powerupPackStoreItem, powerupList));
				}
			}
		}
		
		protected function createIcons():void 
		{
			
		}
		
		protected function createCashButtonSkin():DisplayObject
		{
			var container:Sprite = new Sprite();
			
			var background:Image = new Image(AtlasAsset.CommonAtlas.getTexture("buttons/green_base"));
			background.scale9Grid = ResizeUtils.getScaledRect(15, 13, 175, 38);
			background.width = 203 * pxScale;
			background.height = 64 * pxScale;
			container.addChild(background);
			
			var cashIcon:Image = new Image(AtlasAsset.CommonAtlas.getTexture("store/cash_price_icon"));
			cashIcon.x = 30 * pxScale;
			cashIcon.y = 8 * pxScale;
			container.addChild(cashIcon);
			
			var buttonLabel:XTextField = new XTextField(background.width - 36*pxScale, 40 * pxScale, XTextFieldStyle.getWalrus(32, 0xffffff).addShadow(1, 0x185d00, 1, 4), price.toString());
			buttonLabel.x = 36 * pxScale;
			buttonLabel.y = 12 * pxScale;
			container.addChild(buttonLabel);
			
			return container;
			
		}
		
		protected function createUSDButtonSkin():DisplayObject
		{
			var container:Sprite = new Sprite();
			
			var background:Image = new Image(AtlasAsset.CommonAtlas.getTexture("buttons/green_base"));
			background.scale9Grid = ResizeUtils.getScaledRect(15, 13, 175, 38);
			background.width = 230 * pxScale;
			background.height = 64 * pxScale;
			container.addChild(background);
			
			var buttonLabel:XTextField = new XTextField(background.width, 40 * pxScale, XTextFieldStyle.getWalrus(32, 0xffffff).addShadow(1, 0x185d00, 1, 4), price.toFixed(2) + " USD");
			//buttonLabel.x = 24 * pxScale;
			buttonLabel.y = 12 * pxScale;
			container.addChild(buttonLabel);
			
			return container;
			
		}
		
		public function completePurchase(purchasedPowerupList:Object = null):Object
		{
			if (!purchasedPowerupList)
			{
				purchasedPowerupList = gameManager.powerupModel.addPowerupsFromPack(powerupPackStoreItem);
				gameManager.powerupModel.reservedPowerupsCount = powerupPackStoreItem.totalQuantity;
			}
			//purchasedPowerupList[Powerup.INSTABINGO] = 2;
			//purchasedPowerupList[Powerup.TRIPLE_DAUB] = 2;
			dispatchEventWith(Event.COMPLETE, false, purchasedPowerupList);
			animateBuy();
			return purchasedPowerupList;
		}
		
		public function animateBuy():void
		{
			
		}
		
		public function getNormalSourcePoint():Point
		{
			return new Point(0, 0);
		}
		
		public function getMagicSourcePoint():Point
		{
			return new Point(0, 0);
		}
		
		public function getRareSourcePoint():Point
		{
			return new Point(0, 0);
		}
		
		public function getNormalRarityDelay():Number
		{
			return 0;
		}
		
		public function getMagicRarityDelay():Number
		{
			return 0.1;
		}
		
		public function getRareRarityDelay():Number
		{
			return 0.2;
		}
		
		public function animateAppearance(delay:Number):void 
		{
			makePopTween(button, delay + 0.1);
		}
		
		protected function makePopTween(target:DisplayObject, delay:Number):void
		{
			target.scale = 0;
			TweenHelper.tween(target, 0.3, { delay: delay, scale: 1.2, transition: Transitions.EASE_OUT } )
				.chain(target, 0.2, { scale: 1, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
		}
		
	}

}