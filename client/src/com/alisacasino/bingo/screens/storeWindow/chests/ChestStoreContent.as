package com.alisacasino.bingo.screens.storeWindow.chests 
{
	import adobe.utils.CustomActions;
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
	public class ChestStoreContent extends FeathersControl
	{
		static public const SHOW_NO_MONEY:String = "showNoMoney";
		
		private var storeWindow:StoreScreen;
		private var blisterPack:BlisterPowerupPack;
		private var tubePack:TubePowerupPack;
		private var cardPack:CardPowerupPack;
		private var animationDelay:Number;
		private var inventoryBackground:Image;
		private var chestPanel:ChestPanel;
		private var descriptionPanel:DescriptionPanel;
		internal var commonInventory:CommonInventory;
		internal var magicInventory:MagicInventory;
		internal var rareInventory:RareInventory;
		internal var animationLayer:Sprite;
		
		public function ChestStoreContent(storeWindow:StoreScreen, animationDelay:Number) 
		{
			this.animationDelay = animationDelay;
			this.storeWindow = storeWindow;
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
			
			chestPanel = new ChestPanel();
			chestPanel.x = 20*pxScale;
			chestPanel.y = 20*pxScale;
			//addChild(chestPanel);
			
			descriptionPanel = new DescriptionPanel();
			descriptionPanel.x = 396 * pxScale;
			descriptionPanel.y = 20 * pxScale;
			
			if (animationDelay > 0)
			{
				Starling.juggler.delayCall(addChildren, animationDelay);
			}
			else
			{
				addChildren();
			}
		}
		
		private function addChildren():void 
		{
			
			chestPanel.animateAppearance(0.24);
			addChild(descriptionPanel);
			descriptionPanel.animateAppearance(0.27);
			addChild(chestPanel);
		}
		
	}

}