package com.alisacasino.bingo.screens.storeWindow.powerups 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.screens.storeWindow.powerups.BlisterPowerupPack;
	import com.alisacasino.bingo.screens.storeWindow.powerups.CardPowerupPack;
	import com.alisacasino.bingo.screens.storeWindow.powerups.CommonInventory;
	import com.alisacasino.bingo.screens.storeWindow.powerups.MagicInventory;
	import com.alisacasino.bingo.screens.storeWindow.powerups.PowerupBuyAnimator;
	import com.alisacasino.bingo.screens.storeWindow.powerups.RareInventory;
	import com.alisacasino.bingo.screens.storeWindow.powerups.TubePowerupPack;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.store.items.PowerupPackStoreItem;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class PowerupsStoreContent extends FeathersControl
	{
		static public const SHOW_NO_MONEY:String = "showNoMoney";
		
		private var storeWindow:StoreScreen;
		private var powerupBuyAnimator:PowerupBuyAnimator;
		private var blisterPack:BlisterPowerupPack;
		private var tubePack:TubePowerupPack;
		private var cardPack:CardPowerupPack;
		private var animationDelay:Number;
		private var inventoryBackground:Image;
		internal var commonInventory:CommonInventory;
		internal var magicInventory:MagicInventory;
		internal var rareInventory:RareInventory;
		internal var animationLayer:Sprite;
		
		public function PowerupsStoreContent(storeWindow:StoreScreen, animationDelay:Number) 
		{
			this.animationDelay = animationDelay;
			this.storeWindow = storeWindow;
			powerupBuyAnimator = new PowerupBuyAnimator(this);
		}
		
		public function showBuyAnimation(item:IStoreItem, purchasedPowerups:Object):void 
		{
			if (item == blisterPack.powerupPackStoreItem)
				blisterPack.completePurchase(purchasedPowerups);
			else if (item == cardPack.powerupPackStoreItem)
				cardPack.completePurchase(purchasedPowerups);
			else if (item == tubePack.powerupPackStoreItem)
				tubePack.completePurchase(purchasedPowerups);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			inventoryBackground = new Image(AtlasAsset.CommonAtlas.getTexture("store/grey_background_white_frame"));
			inventoryBackground.scale9Grid = ResizeUtils.getScaledRect(28, 23, 2, 2);
			inventoryBackground.x = 8 * pxScale;
			inventoryBackground.y = 8 * pxScale;
			inventoryBackground.width = 407 * pxScale;
			inventoryBackground.height = 580 * pxScale;
			
			commonInventory = new CommonInventory();
			commonInventory.x = 25 * pxScale;
			commonInventory.y = 22 * pxScale;
			
			magicInventory = new MagicInventory();
			magicInventory.x = 25 * pxScale;
			magicInventory.y = 208 * pxScale;
			
			
			rareInventory = new RareInventory();
			rareInventory.x = 25 * pxScale;
			rareInventory.y = 394 * pxScale;
			
			var tubePackData:PowerupPackStoreItem = gameManager.storeData.powerupItems[0];
			if (tubePackData)
			{
				tubePack = new TubePowerupPack(tubePackData);
				tubePack.addEventListener(Event.COMPLETE, tubePack_completeHandler);
				tubePack.addEventListener(SHOW_NO_MONEY, showNoMoneyHandler);
				tubePack.x = 408 * pxScale;
				tubePack.y = 8 * pxScale;
			}
			
			
			var cardPackData:PowerupPackStoreItem = gameManager.storeData.powerupItems[1];
			if (cardPackData)
			{
				cardPack = new CardPowerupPack(cardPackData);
				cardPack.addEventListener(Event.COMPLETE, cardPack_completeHandler);
				cardPack.addEventListener(SHOW_NO_MONEY, showNoMoneyHandler);
				cardPack.x = 657 * pxScale;
				cardPack.y = 8 * pxScale;
			}
			
			var blisterPackData:PowerupPackStoreItem = gameManager.storeData.powerupItems[2];
			if (blisterPackData)
			{
				blisterPack = new BlisterPowerupPack(blisterPackData);
				blisterPack.x = 408 * pxScale;
				blisterPack.y = 296 * pxScale;
				blisterPack.addEventListener(Event.COMPLETE, blisterPack_completeHandler);
			}
			
			animationLayer = new Sprite();
			
			
			if (animationDelay > 0)
			{
				Starling.juggler.delayCall(addChildren, animationDelay);
			}
			else
			{
				addChildren();
			}
		}
		
		private function showNoMoneyHandler(e:Event):void 
		{
			new ShowNoMoneyPopup(ShowNoMoneyPopup.PURPLE, this, new Point(660 * pxScale, 50 * pxScale)).execute();
		}
		
		private function addChildren():void 
		{
			addChild(inventoryBackground);
			addChild(commonInventory);
			commonInventory.animateAppearance(0.24);
			addChild(magicInventory);
			magicInventory.animateAppearance(0.27);
			addChild(rareInventory);
			rareInventory.animateAppearance(0.3);
			addChild(tubePack);
			tubePack.animateAppearance(0.1);
			addChild(cardPack);
			cardPack.animateAppearance(0.19);
			addChild(blisterPack);
			blisterPack.animateAppearance(0.05);
			addChild(animationLayer);
		}
		
		private function blisterPack_completeHandler(e:Event):void 
		{
			//storeWindow.handlePowerupPurchaseComplete();
			powerupBuyAnimator.animate(blisterPack, e.data);
		}
		
		private function cardPack_completeHandler(e:Event):void 
		{
			storeWindow.handlePowerupPurchaseComplete();
			powerupBuyAnimator.animate(cardPack, e.data);
		}
		
		private function tubePack_completeHandler(e:Event):void 
		{
			storeWindow.handlePowerupPurchaseComplete();
			powerupBuyAnimator.animate(tubePack, e.data);
		}
		
	}

}