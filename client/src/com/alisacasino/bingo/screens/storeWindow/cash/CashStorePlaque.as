package com.alisacasino.bingo.screens.storeWindow.cash 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.store.items.CashStoreItem;
	import com.alisacasino.bingo.store.items.CashStoreItem;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.StringUtils;
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CashStorePlaque extends FeathersControl
	{
		private var _icon:Texture;
		
		public function get icon():Texture 
		{
			return _icon;
		}
		
		public function set icon(value:Texture):void 
		{
			if (_icon != value)
			{
				_icon = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		/*
		private var _itemID:String;
		
		public function get itemID():String 
		{
			return _itemID;
		}
		
		public function set itemID(value:String):void 
		{
			if (_itemID != value)
			{
				_itemID = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		private var _cashQuantity:int;
		
		public function get cashQuantity():int 
		{
			return _cashQuantity;
		}
		
		public function set cashQuantity(value:int):void 
		{
			if (_cashQuantity != value)
			{
				_cashQuantity = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		private var _price:Number = 0;
		
		public function get price():Number 
		{
			return _price;
		}
		
		public function set price(value:Number):void 
		{
			if (_price != value)
			{
				_price = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}*/
		
		private var _storeItem:CashStoreItem;
		
		public function get storeItem():CashStoreItem 
		{
			return _storeItem;
		}
		
		public function set storeItem(value:CashStoreItem):void 
		{
			if (_storeItem != value)
			{
				_storeItem = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		private var contentBackground:Image;
		private var background:Image;
		private var cashLabel:XTextField;
		private var button:Button;
		private var buttonLabel:XTextField;
		private var iconContainer:Image;
		
		private var saleOldCashBackground:Image;
		private var saleCashLabel:XTextField;
		private var oldCashStroke:Image;
		
		private var saleBadge:Image;
		private var saleBadgeTopLabel:XTextField;
		private var saleBadgeBottomLabel:XTextField;
		private var saleBadgeWidth:int = 144;

		public function CashStorePlaque() 
		{
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			background = new Image(getBackgroundTexture());
			background.scale9Grid = getBackgroundScale9Grid();
			addChild(background);
			
			contentBackground = new Image(getContentBackground());
			contentBackground.scale9Grid = getContentBackgroundScale9Grid();
			addChild(contentBackground);
			
			cashLabel = new XTextField(getElementWidth(), 34 * pxScale, XTextFieldStyle.getWalrus(40, getCashLabelColor()), "");
			cashLabel.autoScale = true;
			cashLabel.y = 9 * pxScale;
			addChild(cashLabel);
			
			var invisButton:BasicButton = new BasicButton();
			var quad:Quad = new Quad(getElementWidth(), getElementHeight());
			quad.alpha = 0;
			invisButton.defaultSkin = quad;
			invisButton.addEventListener(Event.TRIGGERED, invisButton_triggeredHandler);
			addChild(invisButton);
			
			button = new Button();
			button.scaleWhenDown = 0.9;
			button.useHandCursor = true;
			button.defaultSkin = createButtonSkin();
			button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			addChild(button);
			
			iconContainer = new Image(null);
			iconContainer.touchable = false;
			addChild(iconContainer);
			
			setSizeInternal(getElementWidth(), getElementHeight(), false);
		}
		
		public function animateAppearance(delay:Number):void 
		{
			makePopTween(button, delay);
			makePopTween(iconContainer, delay + 0.1);
			
			cashLabel.alpha = 0;
			TweenHelper.tween(cashLabel, 0.4, { delay: delay, alpha:1, transition:Transitions.EASE_OUT } );
			
			
			if (saleCashLabel)
				makePopTween(saleCashLabel, delay);
				
			if (oldCashStroke) {
				oldCashStroke.alpha = 0;
				TweenHelper.tween(oldCashStroke, 0.4, { delay: delay, alpha:1, transition:Transitions.EASE_OUT } );
			}
			
			if (saleBadge) {
				saleBadge.width = 0;
				TweenHelper.tween(saleBadge, 0.2, { delay:(delay + 0.3), width:saleBadgeWidth * 1.2 * pxScale, transition: Transitions.EASE_OUT } )
					.chain(saleBadge, 0.15, { width:saleBadgeWidth * pxScale, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
			}
				
			if(saleBadgeTopLabel)
				makePopTween(saleBadgeTopLabel, delay + 0.3);
				
			if(saleBadgeBottomLabel)
				makePopTween(saleBadgeBottomLabel, delay + 0.3);
		}
		
		protected function makePopTween(target:DisplayObject, delay:Number):void
		{
			target.scale = 0;
			TweenHelper.tween(target, 0.2, { delay: delay, scale: 1.2, transition: Transitions.EASE_OUT } )
				.chain(target, 0.15, { scale: 1, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
		}
		
		
		private function invisButton_triggeredHandler(e:Event):void 
		{
			initiatePurchase();
		}
		
		private function initiatePurchase():void 
		{
			if (!storeItem)
			{
				sosTrace("No store item", SOSLog.ERROR);
			}
			else 
			{
				LoadingWheel.show();
				PlatformServices.store.purchaseItem(storeItem);
			}
		}
		
		private function button_triggeredHandler(e:Event):void 
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			initiatePurchase();
		}
		
		protected function getCashLabelColor():uint
		{
			return 0xc5edfd;
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				commitData();
			}
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				resizeAndRearrange();
			}
		}
		
		private function commitData():void 
		{
			if (!storeItem) 
			{
				cashLabel.text = "no store item";
				buttonLabel.text = "USD";
				return;
			}
			
			iconContainer.texture = icon;
			iconContainer.readjustSize();
			
			cashLabel.text = StringUtils.delimitThousands(storeItem.quantity, ",") + " CASH";
			
			buttonLabel.text = storeItem.price.toFixed(2) + " USD";
			
			handleSaleMode();
		}
		
		private function resizeAndRearrange():void 
		{
			background.width = width;
			background.height = height;
			
			contentBackground.x = 4 * pxScale;
			contentBackground.y = 43 * pxScale;
			contentBackground.width = width - contentBackground.x * 2;
			contentBackground.height = height - contentBackground.y - 4 * pxScale;
			
			iconContainer.alignPivot();
			iconContainer.x = width / 2;
			iconContainer.y = height / 2 + 0 * pxScale - iconContainer.height*0.05;
			
			button.validate();
			button.alignPivot();
			button.x = width / 2;
			button.y = height - 69 * pxScale + button.pivotY;
			
			if (saleCashLabel)
			{
				cashLabel.y = 36 * pxScale;
				oldCashStroke.y = cashLabel.y + cashLabel.height/2 - 4 * pxScale;
			}
			else
			{
				cashLabel.y = 9 * pxScale;
			}
			
			alignBadge();
		}
		
		private function createButtonSkin():Sprite
		{
			var container:Sprite = new Sprite();
			
			var background:Image = new Image(AtlasAsset.CommonAtlas.getTexture("buttons/green_base"));
			background.scale9Grid = ResizeUtils.getScaledRect(15, 13, 175, 38);
			background.width = 205 * pxScale;
			background.height = 58 * pxScale;
			container.addChild(background);
			
			buttonLabel = new XTextField(background.width, 32 * pxScale, XTextFieldStyle.getWalrus(27, 0xffffff).addShadow(1, 0x087315, 1, 4));
			buttonLabel.y = 13 * pxScale;
			container.addChild(buttonLabel);
			
			return container;
		}
		
		protected function getElementWidth():Number
		{
			return 100*pxScale;
		}
		
		protected function getElementHeight():Number
		{
			return 100*pxScale;
		}
		
		protected function getBackgroundScale9Grid():Rectangle 
		{
			return ResizeUtils.getScaledRect(18, 18, 2, 2);
		}
		
		protected function getContentBackgroundScale9Grid():Rectangle
		{
			return ResizeUtils.getScaledRect(18, 18, 2, 2);
		}
		
		protected function getBackgroundTexture():Texture
		{
			throw new Error("Must be overridden in subclasses");
			return null;
		}
		
		protected function getContentBackground():Texture
		{
			throw new Error("Must be overridden in subclasses");
		}
		
		protected function handleSaleMode():void 
		{
			if (_storeItem && (_storeItem.hasSale || _storeItem.showSaleBadge))
			{
				if (!saleCashLabel)
				{
					saleOldCashBackground = new Image(getBackgroundTexture());
					saleOldCashBackground.scale9Grid = getBackgroundScale9Grid();
					saleOldCashBackground.width = 195 * pxScale;
					saleOldCashBackground.height = 41 * pxScale;
					saleOldCashBackground.y = 26*pxScale;
					saleOldCashBackground.x = (width - saleOldCashBackground.width) / 2;
					addChild(saleOldCashBackground);
					
					addChild(cashLabel);
					
					saleCashLabel = new XTextField(getElementWidth(), 42 * pxScale, XTextFieldStyle.getWalrus(31, 0xFFE400).setShadow(), StringUtils.delimitThousands(_storeItem.quantity, ",") + " CASH");
					saleCashLabel.autoScale = true;
					saleCashLabel.alignPivot();
					saleCashLabel.x = saleCashLabel.pivotX;
					saleCashLabel.y = 2 * pxScale + saleCashLabel.pivotY;
					addChild(saleCashLabel);
					
					oldCashStroke = new Image(AtlasAsset.CommonAtlas.getTexture('store/stroke_red'));
					oldCashStroke.scale9Grid = ResizeUtils.getScaledRect(3, 0, 1, 0);
					addChild(oldCashStroke);
				}
				else
				{
					saleCashLabel.text = StringUtils.delimitThousands(_storeItem.quantity, ",") + " CASH";
				}
				
				cashLabel.text = StringUtils.delimitThousands(storeItem.oldQuantiy, ",") + " CASH";
				//cashLabel.redraw();
				
				oldCashStroke.width = cashLabel.textBounds.width + 17 * pxScale;
				oldCashStroke.x = (width - oldCashStroke.width) / 2;
				
				if(_storeItem.percentBonus > 0)
					showBadge(_storeItem.badgeTexture, _storeItem.percentBonus.toString() + "%", 'MORE');
				else
					removeBadge();
			}
			else
			{
				if (saleCashLabel)
				{
					saleCashLabel.removeFromParent();
					saleCashLabel = null;
					
					saleOldCashBackground.removeFromParent();
					saleOldCashBackground = null;
					
					oldCashStroke.removeFromParent();
					oldCashStroke = null;
				}	
				
				removeBadge();
			}
			
		}
		
		protected function showBadge(texture:String, topText:String, bottomText:String):void 
		{
			if (!saleBadge)
			{
				saleBadge = new Image(AtlasAsset.CommonAtlas.getTexture(texture));
				saleBadge.scale9Grid = ResizeUtils.getScaledRect(35, 0, 1, 0);
				saleBadge.width = saleBadgeWidth * pxScale;
				saleBadge.alignPivot(Align.RIGHT, Align.CENTER);
				//saleBadge.pivotX = 51 * pxScale;
				//saleBadge.pivotY = saleBadge.height/2;
				addChild(saleBadge);
				
				saleBadgeTopLabel = new XTextField(saleBadge.width, 48 * pxScale, XTextFieldStyle.getWalrus(41, 0xFFFFFF).setShadow(1.15, 0x2E2E2E, 1, 90, 2, 1), topText);
				saleBadgeTopLabel.alignPivot();
				addChild(saleBadgeTopLabel);
				
				saleBadgeBottomLabel = new XTextField(saleBadge.width, 36 * pxScale, XTextFieldStyle.getWalrus(27, 0xFFFFFF).setShadow(1.15, 0x2E2E2E, 1, 90, 2, 1), bottomText);
				saleBadgeBottomLabel.alignPivot();
				addChild(saleBadgeBottomLabel);
			}
			else
			{
				saleBadge.texture = AtlasAsset.CommonAtlas.getTexture(texture);
				saleBadge.readjustSize();
				
				saleBadgeTopLabel.text = topText;
				saleBadgeBottomLabel.text = bottomText;
			}
		}	
		
		protected function alignBadge():void 
		{
			if (!saleBadge)
				return;
			
			saleBadge.x = background.x + background.width - saleBadge.texture.frameWidth + 7*pxScale + saleBadge.pivotX;
			saleBadge.y = 76*pxScale + saleBadge.pivotY;
			
			saleBadgeTopLabel.x = saleBadgeTopLabel.pivotX + saleBadge.x - saleBadge.pivotX + 8 * pxScale - saleBadgeWidth*pxScale + saleBadge.texture.frameWidth;
			saleBadgeTopLabel.y = saleBadgeTopLabel.pivotY + saleBadge.y - saleBadge.pivotY + 2 * pxScale;
			
			saleBadgeBottomLabel.x = saleBadgeBottomLabel.pivotX + saleBadge.x - saleBadge.pivotX + 13 * pxScale - saleBadgeWidth*pxScale + saleBadge.texture.frameWidth;
			saleBadgeBottomLabel.y = saleBadgeBottomLabel.pivotY + saleBadge.y - saleBadge.pivotY + 39 * pxScale;
		}
		
		protected function removeBadge():void 
		{
			if (saleBadge) 
			{
				saleBadge.removeFromParent();
				saleBadge = null;
				
				saleBadgeTopLabel.removeFromParent();
				saleBadgeTopLabel = null;
				
				saleBadgeBottomLabel.removeFromParent();
				saleBadgeBottomLabel = null;
			}
		}	
		
		
	}

}