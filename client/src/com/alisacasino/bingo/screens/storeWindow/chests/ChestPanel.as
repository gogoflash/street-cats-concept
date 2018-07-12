package com.alisacasino.bingo.screens.storeWindow.chests 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.commands.player.ClaimBoughtChest;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.IDialog;
	import com.alisacasino.bingo.dialogs.chests.ChestPartsView;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.chests.ChestsData;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.screens.storeWindow.powerups.PowerupsStoreContent;
	import com.alisacasino.bingo.store.items.ChestStoreItem;
	import com.alisacasino.bingo.utils.UIUtils;
	import com.alisacasino.bingo.utils.analytics.AnalyticsManager;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAStoreItemTransactionEvent;
	import com.alisacasino.bingo.utils.analytics.events.AnalyticsEvent;
	import com.alisacasino.bingo.utils.analytics.events.BuyInGameItemEvent;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ChestPanel extends FeathersControl
	{
		
		private var background:Image;
		private var contentBackground:Image;
		private var titleLabel:XTextField;
		private var chestView:ChestPartsView;
		private var button:Button;
		private var buttonLabel:XTextField;
		private var chestStoreItem:ChestStoreItem;
		
		protected var backgroundTexture:Texture;
		protected var contentBackgroundTexture:Texture;
		
		public function ChestPanel() 
		{
			width = 370 * pxScale;
			height = 552 * pxScale;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			chestStoreItem = gameManager.getChestItem();
			if (!chestStoreItem)
				return;
			
			background = new Image(AtlasAsset.CommonAtlas.getTexture("store/dark_green_background"));
			//background = new Image(AtlasAsset.CommonAtlas.getTexture("store/light_purple_background"));
			background.scale9Grid = ResizeUtils.getScaledRect(18, 18, 2, 2);
			//background.color = 0xFFC014;
			background.width = 354 * pxScale;
			background.height = 552 * pxScale;
			addChild(background);
			
			contentBackground = new Image(AtlasAsset.CommonAtlas.getTexture("store/light_green_background"));
			//contentBackground = new Image(AtlasAsset.CommonAtlas.getTexture("store/light_purple_background")); 
			contentBackground.scale9Grid = ResizeUtils.getScaledRect(18, 18, 2, 2);
			//contentBackground.color = 0x000000;
			contentBackground.x = 4 * pxScale;
			contentBackground.y = 54 * pxScale;
			contentBackground.width = background.width - contentBackground.x * 2;
			contentBackground.height = background.height - contentBackground.y - 4 * pxScale;
			addChild(contentBackground);
			
			titleLabel = new XTextField(background.width, 36 * pxScale, XTextFieldStyle.getWalrus(28, 0x6cff00), "SUPER CHEST");
			titleLabel.y = 10 * pxScale;
			addChild(titleLabel);
			
			chestView = new ChestPartsView(ChestType.PREMIUM, 1, null, 0, -28 * pxScale);
			chestView.x = background.width / 2;
			chestView.scaleX = 0.76;
			chestView.scaleY = 1.2;
			chestView.y = -70 * pxScale;
			chestView.alpha = 0;
			addChild(chestView)
			
			button = new Button();
			button.scaleWhenDown = 0.9;
			button.useHandCursor = true;
			button.defaultSkin = createButtonSkin();
			button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			button.validate();
			button.alignPivot();
			addChild(button);
			
			if (!gameManager.chestsData.isAvailableFreePremiumChestByLevel) 
			{
				createLockPanel();
				button.visible = false;
			}
			else
			{
				button.visible = true;
				
				if (!gameManager.chestsData.freeChestClaimed)
				{	
					buttonLabel.text = "FREE";
					
				}
				else
				{
					if (priceType == Type.REAL)
						buttonLabel.text = chestStoreItem.price.toFixed(2) + " USD";
					else 
						buttonLabel.text = chestStoreItem.price.toString();
				}
			}
		}
		
		private function showChestDropTweens(delay:Number):void 
		{
			var tween_1:Tween = new Tween(chestView, 0.25, Transitions.EASE_IN);
			var tween_2:Tween = new Tween(chestView, 0.14, Transitions.EASE_OUT);
			var tween_3:Tween = new Tween(chestView, 0.4, Transitions.EASE_OUT_BACK);
			
			tween_1.delay = delay;
			tween_1.animate('alpha', 3);
			tween_1.animate('y', 300 * pxScale);
			tween_1.onComplete = chestView.showSuperChestShine;
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scaleX', 1.12);
			tween_2.animate('scaleY', 0.92);
			tween_2.animate('y', 250 * pxScale);
			tween_2.nextTween = tween_3;
			//tween_2.onComplete = chestView.showSuperChestShine;
			
			tween_3.animate('scaleX', 1);
			tween_3.animate('scaleY', 1);
			tween_3.animate('y', 280 * pxScale);
			
			Starling.juggler.add(tween_1);
		}
		
		private function createLockPanel():void 
		{
			var sprite:Sprite = new Sprite();
			sprite.touchable = false;
			addChild(sprite);
			
			contentBackground.x = 4 * pxScale;
			contentBackground.y = 54 * pxScale;
			
			var panelBackground:Image = new Image(AtlasAsset.CommonAtlas.getTexture("store/light_purple_background"));
			panelBackground.scale9Grid = ResizeUtils.getScaledRect(18, 18, 2, 2);
			panelBackground.x = 4 * pxScale;
			panelBackground.y = 54 * pxScale;
			panelBackground.width = 260*pxScale;
			panelBackground.height = 100*pxScale;
			sprite.addChild(panelBackground);
			
			var unlockTopLabel:XTextField = new XTextField(panelBackground.width, 45 * pxScale, XTextFieldStyle.getWalrus(23, 0xffe400).setShadow(1.2));
			unlockTopLabel.touchable = false;
			unlockTopLabel.text = 'Unlocks at';
			unlockTopLabel.x = 38 * pxScale;
			unlockTopLabel.y = 63 * pxScale;
			sprite.addChild(unlockTopLabel);
			
			var unlockBottomLabel:XTextField = new XTextField(panelBackground.width, 45 * pxScale, XTextFieldStyle.getWalrus(33, 0xffffff).setShadow(1.2));
			unlockBottomLabel.touchable = false;
			unlockBottomLabel.text = "Level "+ ChestsData.STORE_CHEST_UNLOCK_LEVEL.toString();
			unlockBottomLabel.x = unlockTopLabel.x;
			unlockBottomLabel.y = unlockTopLabel.y + 37 * pxScale;
			sprite.addChild(unlockBottomLabel);
			
			var padlock:Image = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/gray_padlock"));
			padlock.pivotX = 1.55*16*pxScale;
			padlock.pivotY = 1.55*7*pxScale;
			padlock.x = 52 * pxScale;
			padlock.y = 80 * pxScale;//panelBackground.height / 2; //230 * pxScale;
			sprite.addChild(padlock);
			
			sprite.x = contentBackground.x + (contentBackground.width - panelBackground.width) / 2 - 4 * pxScale;
			sprite.y = contentBackground.y + contentBackground.height - panelBackground.height - 90 * pxScale;
		}
		
		private function button_triggeredHandler(e:Event):void 
		{
			if (!gameManager.chestsData.freeChestClaimed)
			{
				gameManager.chestsData.freeChestClaimed = true;
				
				new ClaimBoughtChest(true).execute();
				
				return;
			}
			if (!chestStoreItem)
			{
				sosTrace("No store item", SOSLog.ERROR);
			}
			else 
			{
				initiatePurchase();
			}
		}
		
		private function initiatePurchase():void 
		{
			if (chestStoreItem.priceType == Type.REAL)
			{
				LoadingWheel.show();
				PlatformServices.store.purchaseItem(chestStoreItem);
			}
			else
			{
				if (Player.current)
				{
					if (Player.current.cashCount < chestStoreItem.price)
					{
						new ShowNoMoneyPopup(ShowNoMoneyPopup.PURPLE, this, new Point(button.x, button.y)).execute();
						return;
					}
					Player.current.updateCashCount(-chestStoreItem.price, "chestPurchase");
					completePurchase();
					
					gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreItemTransactionEvent(chestStoreItem));
				}
			}
		}
		
		private function completePurchase():void 
		{
			new ClaimBoughtChest(false).execute();
		}
		
		public function animateAppearance(delay:Number):void 
		{
			if (!isInitialized)
				initializeNow();
			
			if (!titleLabel)	
				return;
			
			titleLabel.alpha = 0;
			TweenHelper.tween(titleLabel, 0.4, { delay: delay + 0.2, alpha:1, transition:Transitions.EASE_OUT } );
			
			UIUtils.makePopTween(button, delay);
			//UIUtils.makePopTween(chestView, delay + 0.24);
			
			showChestDropTweens(0);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (!titleLabel)
				return;
			
			button.x = width / 2;
			button.y = height - 120 * pxScale + button.pivotY;
		}
		
		
		private function createButtonSkin():DisplayObject
		{
			if (priceType == Type.CASH && gameManager.chestsData.freeChestClaimed)
			{
				return createCashButtonSkin();
			}
			return createUSDButtonSkin();
		}
		
		protected function createCashButtonSkin():DisplayObject
		{
			var container:Sprite = new Sprite();
			
			var background:Image = new Image(AtlasAsset.CommonAtlas.getTexture("buttons/green_base"));
			background.scale9Grid = ResizeUtils.getScaledRect(15, 13, 175, 38);
			background.width = 230 * pxScale;
			background.height = 64 * pxScale;
			container.addChild(background);
			
			var cashIcon:Image = new Image(AtlasAsset.CommonAtlas.getTexture("store/cash_price_icon"));
			cashIcon.x = 30 * pxScale;
			cashIcon.y = 8 * pxScale;
			container.addChild(cashIcon);
			
			buttonLabel = new XTextField(background.width - 36*pxScale, 40 * pxScale, XTextFieldStyle.getWalrus(32, 0xffffff).addShadow(1, 0x185d00, 1, 4), "");
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
			
			buttonLabel = new XTextField(background.width, 40 * pxScale, XTextFieldStyle.getWalrus(32, 0xffffff).addShadow(1, 0x185d00, 1, 4), "");
			//buttonLabel.x = 24 * pxScale;
			buttonLabel.y = 12 * pxScale;
			container.addChild(buttonLabel);
			
			return container;
			
		}
		
		private function get price():Number
		{
			return chestStoreItem ? chestStoreItem.price : 0;
		}
		
		private function get priceType():int
		{
			return chestStoreItem ? chestStoreItem.priceType : Type.REAL;
		}
		
		override public function dispose():void
		{
			if (chestView) {
				Starling.juggler.removeTweens(chestView);
			}
			super.dispose();
		}
	}

}