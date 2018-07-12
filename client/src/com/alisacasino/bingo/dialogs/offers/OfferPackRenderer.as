package com.alisacasino.bingo.dialogs.offers 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.controls.DoubleTitlesButtonContent;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.offers.CardAlignProperties;
	import com.alisacasino.bingo.models.offers.CashIconType;
	import com.alisacasino.bingo.models.offers.OfferItem;
	import com.alisacasino.bingo.models.offers.OfferItemsPack;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAStoreItemTransactionEvent;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;
	import starling.utils.TweenHelper;
	
	public class OfferPackRenderer extends FeathersControl 
	{
		public static var BACKGROUND_SHORT_FAT	:uint = 1;
		public static var BACKGROUND_SHORT_SLIM	:uint = 2;
		public static var BACKGROUND_TALL_SLIM	:uint = 3;
		
		public static const EVENT_BUY_PACK:String = 'EVENT_BUY_PACK';
		
		private static var BACKGROUND_SHORT_SLIM_SCALE:Number = 0.8;
		
		public function OfferPackRenderer(itemsPack:OfferItemsPack, backgroundType:int, isPurchased:Boolean = false) 
		{
			_itemsPack = itemsPack;
			this.backgroundType = backgroundType;
			_isPurchased = isPurchased;
			super();
		}
		
		private const TITLE_CARDS_SET:String = 'TITLE_CARDS_SET';
		
		private var backgroundType:int;
		private var _itemsPack:OfferItemsPack;
		private var backgroundContainer:Sprite;
		private var background:Image;
		private var bottomButton:Button;
		private var labelTop:XTextField;
		private var labelBottom:XTextField;
		
		private var saleBadgeView:SaleBadgeView;
		
		private var rewardRenderers:Array;
		private var rewardRenderersSortedByY:Array;
		
		private var commodityType:String;
		
		private var storedWidth:Number;
		private var storedHeight:Number;
		private var hasBigCashImage:Boolean;
		
		private var _isPurchased:Boolean;
		private var checkMark:Image;
		
		public function set isPurchased(value:Boolean):void
		{
			if (_isPurchased == value)
				return;
				
			_isPurchased = value;
				
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get isPurchased():Boolean 
		{
			return _isPurchased;
		}
		
		public function get itemsPack():OfferItemsPack {
			return _itemsPack;
		}
		
		override public function get width():Number 
		{
			if (isNaN(storedWidth)) 
			{
				if(backgroundType == BACKGROUND_SHORT_FAT) 
					storedWidth = 269 * pxScale;
				else if (backgroundType == BACKGROUND_SHORT_SLIM) 
					storedWidth = 208 * pxScale;
				else if(backgroundType == BACKGROUND_TALL_SLIM) 
					storedWidth = 232 * pxScale;
			}
			return storedWidth;
		}
		
		override public function get height():Number {
			
			if (isNaN(storedHeight)) 
			{
				if(backgroundType == BACKGROUND_TALL_SLIM) 
					storedHeight = 482 * pxScale;
				else
					storedHeight = 384 * pxScale;
			}
			return storedHeight;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
		
			backgroundContainer = new Sprite();
			addChild(backgroundContainer);
			
			background = new Image(OfferItem.atlasAsset.getTexture(backgroundType == BACKGROUND_SHORT_FAT ? 'offers/pack_bg' : 'offers/pack_bg_thin'));
			
			if (backgroundType == BACKGROUND_SHORT_SLIM) {
				backgroundContainer.scale = BACKGROUND_SHORT_SLIM_SCALE;
				background.scale9Grid = ResizeUtils.getScaledRect(115, 0, 2, 0);
				background.width = (1 / backgroundContainer.scale) * width;
			}
			
			//background.alignPivot();
			background.x = -background.width / 2;
			background.y = -background.height/2;
			backgroundContainer.addChild(background);
			
			handlePurchasedViews(false);
			
			if (_itemsPack.percent > 0)
			{
				saleBadgeView = new SaleBadgeView(SaleBadgeView.TYPE_BIG_BORDERED, _itemsPack.offerItem.badgeTypeTable, _itemsPack.percent);
				addChild(saleBadgeView);
				saleBadgeView.x = width / 2 - 24 * pxScale;
				saleBadgeView.y = -height / 2 + 31 * pxScale;
				//saleBadgeView.showJump(1000, 0, 4000);
			}
			
			//setSizeInternal(WIDTH * pxScale, HEIGHT * pxScale, false);
		}
	
		override protected function draw():void 
		{
			super.draw();
			
			if(!_itemsPack)
			{
				return;
			}
			
			var i:int;
			var rewardItem:CommodityItem;
			var rewardView:OfferRewardView;
			var length:int = _itemsPack.items.length;

			if (!rewardRenderers) 
			{
				rewardRenderers = [];
				rewardRenderersSortedByY = [];
				for (i = 0; i < length; i++) 
				{
					rewardItem = _itemsPack.items[i] as CommodityItem;
					rewardView = new OfferRewardView(rewardItem, _itemsPack.offerItem.cashIconTypeTable, length >= 3); 
					addChild(rewardView);
					rewardRenderers.push(rewardView);
					rewardRenderersSortedByY.push(rewardView);
					
					//trace((rewardView.item.type == CommodityType.CASH) && CashIconType.isBigImage(_itemsPack.offerItem.cashIconTypeTable.getData(rewardView.item.quantity)))
					hasBigCashImage ||= ((rewardView.item.type == CommodityType.CASH) && CashIconType.isBigImage(_itemsPack.offerItem.cashIconTypeTable.getData(rewardView.item.quantity)));
					
					if (i==0) 
						commodityType = rewardItem.type;
					else if (commodityType && commodityType != rewardItem.type)
						commodityType = TITLE_CARDS_SET;
				}
			}
			
			var bottomTitleString:String;
			if (hasBigCashImage)
			{
				if (backgroundType != BACKGROUND_TALL_SLIM && length > 1)
					bottomTitleString = null;
				else if (length <= 1)
					bottomTitleString = commodityType;
				else
					bottomTitleString = TITLE_CARDS_SET;
			}
			else
			{
				bottomTitleString = commodityType;
			}
			
			handleTypeTitle(bottomTitleString);// hasBigCashImage ? (length <= 1 ? commodityType : TITLE_CARDS_SET) : commodityType);
			
			alignRewards();
	
			handlePurchasedViews(true);
			
			
			//if (isInvalid(INVALIDATION_FLAG_SIZE)) 
				//resize();
				
			//tweenAppear();
		}
				
		private function alignRewards(alignConsiderBigImage:Boolean = true):void
		{
			var i:int;
			var rewardView:OfferRewardView;
			var length:int = rewardRenderers.length;
			var cashIconType:int;
			var rotationAlignedImages:int = alignConsiderBigImage ? length : (length/* - 1*/);
			var cardAlignProperties:CardAlignProperties;
			var cardAlignPropertiesList:Array = gameManager.offerManager.getRewardsAlignProperties(rotationAlignedImages, alignConsiderBigImage, backgroundType == BACKGROUND_SHORT_SLIM);
			var j:int;
			for (i = 0; i < length; i++) 
			{
				rewardView = rewardRenderers[i] as OfferRewardView;
				//trace(i, alignConsiderBigImage, rewardView.item.type);
				
				if (rewardView.item.type == CommodityType.CASH)
				{
					cashIconType = _itemsPack.offerItem.cashIconTypeTable.getData(rewardView.item.quantity);
					if (CashIconType.isBigImage(cashIconType)) 
					{
						if (alignConsiderBigImage) {
							rewardView.x = 0;
							rewardView.y = 0;
							if(length > 1)
								alignRewards(false);
							addChild(rewardView);
							break;
						}
						else {
							rewardView.y = 85*pxScale;
							continue;
						}
					}
				}
				
				cardAlignProperties = cardAlignPropertiesList.length > 0 ? cardAlignPropertiesList[Math.min(j++, cardAlignPropertiesList.length-1)] : null;
				
				if (cardAlignProperties) {
					rewardView.x = cardAlignProperties.x * pxScale;
					rewardView.y = cardAlignProperties.y * pxScale;
					if (length >= 3 && commodityType == TITLE_CARDS_SET && (!_itemsPack.storeItem || _itemsPack.storeItem.price.price <= 0))
						rewardView.y -= 17 * pxScale;
					rewardView.rotation = cardAlignProperties.rotationRadian;
				}
			}
			
			rewardRenderersSortedByY.sortOn('y', Array.DESCENDING);
			
			if (checkMark)
				addChild(checkMark);
				
			if (saleBadgeView)
				addChild(saleBadgeView);
				
			if (bottomButton)
				addChild(bottomButton);
		}
		
		private function handleTypeTitle(commodityType:String):void
		{
			if (_itemsPack.storeItem)
				return;
			
			//!commodityType	
				
			//var topText:String;
			
			switch(commodityType) 
			{
				case CommodityType.CASH:
				{
					labelTop = new XTextField(width, 82*pxScale, XTextFieldStyle.getWalrus(50), "CASH");
					labelTop.y = height/2 - 44*pxScale;
					break;
				}
				case CommodityType.COLLECTION :
				{
					labelTop = new XTextField(width, 82*pxScale, XTextFieldStyle.getWalrus(29), "COLLECTION");
					labelTop.y = height/2 - 65*pxScale;
					
					labelBottom = new XTextField(width, 70*pxScale, XTextFieldStyle.getWalrus(55), "CARDS");
					labelBottom.y = labelTop.y + 37*pxScale;
					break;
				}
				case CommodityType.POWERUP_CARD:
				{
					labelTop = new XTextField(width, 82*pxScale, XTextFieldStyle.getWalrus(30), "POWER-UPS");
					labelTop.y = height/2 - 43*pxScale;
					break;
				}
				case CommodityType.POWERUP:
				{
					labelTop = new XTextField(width, 82*pxScale, XTextFieldStyle.getWalrus(30), "POWER-UPS");
					labelTop.y = height/2 - 43*pxScale;
					break;
				}
				case CommodityType.CUSTOMIZER:
				{
					labelTop = new XTextField(width, 50*pxScale, XTextFieldStyle.getWalrus(20), "CUSTOMIZATION");
					labelTop.y = height/2 - 66*pxScale;
					
					labelBottom = new XTextField(width, 70*pxScale, XTextFieldStyle.getWalrus(57), "ITEMS");
					labelBottom.y = labelTop.y + 36*pxScale;
					break;
				}
				case CommodityType.CHEST:
				{
					
					break;
				}
				case TITLE_CARDS_SET:
				{
					labelTop = new XTextField(width, 82*pxScale, XTextFieldStyle.getWalrus(27), "SET OF");
					labelTop.y = height/2 - 67*pxScale;
					
					labelBottom = new XTextField(width, 70*pxScale, XTextFieldStyle.getWalrus(50), "CARDS");
					labelBottom.y = labelTop.y + 35*pxScale;
					break;
				}
			}
			
			if (labelTop) {
				//labelTop.border = true;
				labelTop.alignPivot();
				addChild(labelTop);
			}
			
			if (labelBottom) {
				//labelBottom.border = true;
				labelBottom.alignPivot();
				addChild(labelBottom);
			}
		}
		
		private function handler_bottomButton(e:Event):void
		{
			if (!_itemsPack.storeItem)
				return;
			
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);	
				
			if (_itemsPack.storeItem.price.priceType == Type.REAL)
			{
				_itemsPack.purchaseProgress = OfferItemsPack.PURCHASE_PROGRESS_WAIT;
				LoadingWheel.show();
				PlatformServices.store.purchaseItem(_itemsPack.storeItem);
			}
			else if (_itemsPack.storeItem.price.priceType == Type.CASH)
			{
				if (Player.current.cashCount < _itemsPack.storeItem.price.price)
				{
					new ShowNoMoneyPopup(ShowNoMoneyPopup.PURPLE, this, new Point(bottomButton.x, bottomButton.y)).execute();
					return;
				}
				
				Player.current.updateCashCount(-_itemsPack.storeItem.price.price, "offer:" + _itemsPack.offerItem.type);
				
				gameManager.offerManager.claimBoughtOffer(_itemsPack.storeItem);
				
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreItemTransactionEvent(_itemsPack.storeItem));
			}
			else if (_itemsPack.storeItem.price.isFree) 
			{
				gameManager.offerManager.claimBoughtOffer(_itemsPack.storeItem);
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreItemTransactionEvent(_itemsPack.storeItem));
			}
			
			dispatchEventWith(EVENT_BUY_PACK, true);
		}
		
		public function tweenAppear(delay:Number):void
		{
			if (bottomButton) {
				EffectsManager.scaleJumpAppearBase(bottomButton, 1, 0.750, delay + 0.25, 0.9);
			}
			
			if (saleBadgeView) {
				saleBadgeView.showAppear(delay + 0.5);
				if(!_isPurchased)
					saleBadgeView.showJump((delay + 0.5) * 1000 + 1500, 0, 4000); 
			}
			
			
			var i:int;
			var rewardView:OfferRewardView;
			var length:int = rewardRenderersSortedByY.length;
			for (i = 0; i < length; i++) 
			{
				rewardView = rewardRenderersSortedByY[i] as OfferRewardView;
				//rewardView.visible = false;
				//rewardView.y = cardAlignProperties.y * pxScale;
				tweenDropDown(rewardView, -100*pxScale, -150*pxScale*i, delay + 0.17 + i*0);
			}
		}
		
		public function tweenHide(delay:Number):void
		{
			if (bottomButton) {
				EffectsManager.scaleJumpDisappear(bottomButton, 0.3, delay);
			}
			
			if (saleBadgeView) {
				saleBadgeView.stopJump();
				EffectsManager.scaleJumpDisappear(saleBadgeView, 0.3, delay);
			}
		}
		
		private function handlePurchasedViews(animate:Boolean, delay:Number = 0):void 
		{
			if (!_itemsPack.storeItem)
				return;
			
			if (_isPurchased)
			{
				if (!labelTop && !checkMark) 
				{
					labelTop = new XTextField(width, 48*pxScale, XTextFieldStyle.getWalrus(34), "Purchased");
					labelTop.alignPivot();
					labelTop.y = height / 2 - 43 * pxScale;
					labelTop.x = 0;
					addChild(labelTop);
					
					checkMark = new Image(OfferItem.atlasAsset.getTexture('offers/checkmark'));
					checkMark.alignPivot();
					checkMark.x = 87*pxScale;
					checkMark.y = background.height / 2 - 112*pxScale;
					addChild(checkMark);
				}
				
				if (animate) 
				{
					labelTop.scaleY = 0;
					checkMark.scaleY = 0;
					
					EffectsManager.scaleJumpAppearElastic(labelTop, 1, 0.5, delay + 0.4);
					EffectsManager.scaleJumpAppearElastic(checkMark, 1, 0.6, delay + 0.5);
					
					if(bottomButton)
						EffectsManager.scaleJumpDisappear(bottomButton, 0.3, delay + 0.1, removeBottomButton);
					
					EffectsManager.flashToGrayscale(background, 1)	
					
					if(saleBadgeView)
						EffectsManager.flashToGrayscale(saleBadgeView, 1);	
				}
				else
				{
					removeBottomButton();
					EffectsManager.flashToGrayscale(background)	
				}
				
				if(saleBadgeView)
					saleBadgeView.stopJump();
				
				var i:int;
				var length:int = rewardRenderersSortedByY ? rewardRenderersSortedByY.length : 0;
				for (i = 0; i < length; i++) 
				{
					EffectsManager.flashToGrayscale(rewardRenderersSortedByY[i], animate ? 1 : 0);
				}
			}
			else
			{
				if (!bottomButton) {
					bottomButton = new Button();
					bottomButton.addEventListener(Event.TRIGGERED, handler_bottomButton);
					addChild(bottomButton);
					bottomButton.scaleWhenDown = 0.93;
					bottomButton.useHandCursor = true;
					
					if (_itemsPack.storeItem.price.priceType == Type.REAL) 
						bottomButton.defaultSkin = DoubleTitlesButtonContent.createBuyButtonContent(_itemsPack.storeItem.price.price.toString() + ' USD');
					else if (_itemsPack.storeItem.price.priceType == Type.CASH) 
						bottomButton.defaultSkin =  DoubleTitlesButtonContent.createBuyButtonContent(null, AtlasAsset.CommonAtlas.getTexture("store/cash_price_icon"), _itemsPack.storeItem.price.price.toString(), 5);
					else if(_itemsPack.storeItem.price.isFree) 
						bottomButton.defaultSkin = DoubleTitlesButtonContent.createBuyButtonContent('FREE!');
					
					bottomButton.validate();
					bottomButton.alignPivot();
					bottomButton.y = height / 2 - bottomButton.height / 2 - 12 * pxScale;
				}
			}
		}
		
		private function removeBottomButton():void {
			if (bottomButton) {
				bottomButton.removeFromParent();
				bottomButton = null;
			}
		}
		
		public function tweenJump(delay:Number):void
		{
			if (bottomButton)
				tweenJumpView(bottomButton, 10 * pxScale, 0);
				
			var i:int;
			var length:int = rewardRenderersSortedByY ? rewardRenderersSortedByY.length : 0;
			for (i = 0; i < length; i++) {
				tweenJumpView(rewardRenderersSortedByY[i], (5 + i*3)*pxScale, 0.03 + i * 0.03);
			}	
			
			if (saleBadgeView)
				tweenJumpView(saleBadgeView, 10 * pxScale, 0.0);
		}	
		
		private function tweenJumpView(view:DisplayObject, shiftY:int, delay:Number = 0):void 
		{
			TweenHelper.tween(view, 0.06, {y:(view.y + shiftY), delay:delay}).chain(view, 0.08, {y:view.y});
		}
		
		private function tweenDropDown(view:DisplayObject, baseShiftY:int, shiftY:int, delay:Number = 0):void 
		{
			var velocity:Number = baseShiftY / 0.07;
			var tween_0:Tween = new Tween(view, 0.07 + shiftY/velocity, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(view, 0.03, Transitions.EASE_OUT);
			var tween_2:Tween = new Tween(view, 1.0, Transitions.EASE_OUT_ELASTIC);
			
			tween_0.delay = delay;
			tween_0.animate('y', view.y);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('y', view.y + 25*pxScale);
			tween_1.animate('scaleX', 1.1);
			tween_1.animate('scaleY', 0.95);
			tween_1.nextTween = tween_2;
			
			tween_2.animate('y', view.y);
			tween_2.animate('scaleX', 1);
			tween_2.animate('scaleY', 1);
			
			view.y = baseShiftY + shiftY;
			
			Starling.juggler.add(tween_0);
		}
		
	}
}


		
		
		