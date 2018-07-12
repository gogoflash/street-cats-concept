package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.dialogs.storeDialogs.StoreMultiIconDisplay;
	import com.alisacasino.bingo.models.sales.SaleType;
	import com.alisacasino.bingo.utils.Settings;
	import starling.display.DisplayObject;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	;
	
	public class LargeStoreItemButton extends Sprite
	{
		private var saleMarkup:Boolean;
		protected var mBase:XButton;
		protected var mItem:Object;
		protected var mLeftIcon:Image;
		protected var bonusPercentBadge:Image;
		protected var mLeftValueLabel:XTextField;
		protected var mLeftResourceLabel:XTextField;
		protected var mBonusAmountLabel:XTextField;
		protected var mPercentLabel:XTextField;
		protected var mFreeLabel:XTextField;
		protected var mIcon:StoreMultiIconDisplay;
		protected var mValueLabel:XTextField;
		protected var mResourceLabel:XTextField;
		protected var mBuyBtn:XButton;
		protected var mMostPopularBadge:Image;
		protected var mBestValueBadge:Image;
		protected var mIsMostPopular:Boolean;
		protected var mIsBestValue:Boolean;

		public function LargeStoreItemButton()
		{
			mBase = new XButton(XButtonStyle.LargeStoreItemButtonStyle);
			mBase.scaleWhenDown = 1.0;
			mBase.alphaWhenDisabled = 1.0;
			
			
			
			var percentBadgeTextureName:String = getPercentBadgeTexture(); 
			bonusPercentBadge = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/store/" + percentBadgeTextureName));
			
			mLeftValueLabel = new XTextField(0.1*mBase.width, 0.5*mBase.height, XTextFieldStyle.LargeStoreItemTextFieldStyle);
			
			mLeftResourceLabel = new XTextField(0.1 * mBase.width, 0.35 * mBase.height, XTextFieldStyle.LargeStoreItemTextFieldStyle);
			
			saleMarkup = SaleType.anySaleActive(Settings.instance.saleType);
			
			mBonusAmountLabel = new XTextField(saleMarkup ? 0.15 * mBase.width : 0.1 * mBase.width, 0.66 * mBase.height, getLabelStyle());
			mPercentLabel = new XTextField(0.045*mBase.width, 0.42*mBase.height, getLabelStyle(), "%");
			mFreeLabel = new XTextField(0.055*mBase.width, 0.35*mBase.height, getLabelStyle(), "FREE");
			
			mValueLabel = new XTextField(0.15*mBase.width, 0.6*mBase.height, XTextFieldStyle.LargeStoreItemHighlightedTextFieldStyle);
			mResourceLabel = new XTextField(0.15*mBase.width, 0.37*mBase.height, XTextFieldStyle.LargeStoreItemHighlightedTextFieldStyle);
			mLeftValueLabel.touchable = mLeftResourceLabel.touchable = mBonusAmountLabel.touchable = 
				mPercentLabel.touchable = mFreeLabel.touchable = mValueLabel.touchable = mResourceLabel.touchable = false;
			
			mBuyBtn = new XButton(XButtonStyle.LargeStoreBuyButtonStyle);
			
			mMostPopularBadge = new Image(getMostPopularTexture());
			mBestValueBadge = new Image(getBestValueTexture());
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function getBestValueTexture():Texture 
		{
			var textureName:String = "dialogs/store/best_value";
			
			switch(Settings.instance.saleType)
			{
				case SaleType.BLACK_FRIDAY:
					textureName= "dialogs/store/best_value_purple";
					break;
				default:
				case SaleType.SUPERSALE:
				case SaleType.NO_SALE:
					break;
			}
			
			return AtlasAsset.CommonAtlas.getTexture(textureName);
		}
		
		private function getMostPopularTexture():Texture
		{
			var textureName:String = "dialogs/store/most_popular";
			
			switch(Settings.instance.saleType)
			{
				case SaleType.BLACK_FRIDAY:
					textureName= "dialogs/store/most_popular_green";
					break;
				default:
				case SaleType.SUPERSALE:
				case SaleType.NO_SALE:
					break;
			}
			
			return AtlasAsset.CommonAtlas.getTexture(textureName);
		}
		
		private function getLabelStyle():XTextFieldStyle 
		{
			var labelStyle:XTextFieldStyle = XTextFieldStyle.LargeStoreItemBonusTextFieldStyle;
			
			switch(Settings.instance.saleType)
			{
				case SaleType.SUPERSALE:
					labelStyle = XTextFieldStyle.LargeStoreItemHighlightedBonusTextFieldStyle;
					break;
				case SaleType.BLACK_FRIDAY:
					labelStyle = XTextFieldStyle.LargeStoreBlackFridayTextFieldStyle;
					break;
				default:
				case SaleType.NO_SALE:
					break;
			}
			
			return labelStyle;
		}
		
		private function getPercentBadgeTexture():String
		{
			var badgeTexture:String = "standard_badge";
			
			switch(Settings.instance.saleType)
			{
				case SaleType.SUPERSALE:
					badgeTexture = "sale_badge";
					break;
				case SaleType.BLACK_FRIDAY:
					badgeTexture = "black_friday_badge";
					break;
				default:
				case SaleType.NO_SALE:
					break;
			}
			
			return badgeTexture;
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addChild(mBase);
			
			addChild(bonusPercentBadge);
			var badgeBaseX:Number = saleMarkup ? 316 : 306;
			bonusPercentBadge.x = badgeBaseX * pxScale - bonusPercentBadge.width / 2;
			bonusPercentBadge.y = 6 * pxScale;
			
			addChild(mLeftIcon);
			mLeftIcon.touchable = false;
			mLeftIcon.x = 0.1 * mBase.width - 0.5 * mLeftIcon.width;
			mLeftIcon.y = 0.73 * mBase.height - mLeftIcon.height >> 1;
			
			addChild(mLeftValueLabel);
			mLeftValueLabel.x = 0.13 * mBase.width;
			mLeftValueLabel.y = 0.04 * mBase.height;

			addChild(mLeftResourceLabel);
			mLeftResourceLabel.x = 0.13 * mBase.width;
			mLeftResourceLabel.y = 0.33 * mBase.height;
			
			addChild(mBonusAmountLabel);
			mBonusAmountLabel.format.horizontalAlign = Align.RIGHT;
			mBonusAmountLabel.x = saleMarkup ? 0.23 * mBase.width : 0.25 * mBase.width;
			mBonusAmountLabel.y = 0.04 * mBase.height;
			
			addChild(mPercentLabel);
			mPercentLabel.x = saleMarkup ? 0.375 * mBase.width : 0.345 * mBase.width;
			mPercentLabel.y = 0.08 * mBase.height;
			
			addChild(mFreeLabel);
			mFreeLabel.x = saleMarkup ? 0.38 * mBase.width : 0.35 * mBase.width;
			mFreeLabel.y = 0.33 * mBase.height;
			
			addChild(mIcon);
			mIcon.validate();
			mIcon.touchable = false;
			mIcon.x = saleMarkup ? (0.52 * mBase.width) : (0.51 * mBase.width);
			mIcon.y = 0.38 * mBase.height + mIcon.height/2;
			
			addChild(mValueLabel);
			mValueLabel.x = saleMarkup ? 0.59 * mBase.width : 0.58 * mBase.width;
			mValueLabel.y = -0.03 * mBase.height;
			
			addChild(mResourceLabel);
			mResourceLabel.x = saleMarkup ? 0.59 * mBase.width : 0.58 * mBase.width;
			mResourceLabel.y = 0.35 * mBase.height;
			
			addChild(mBuyBtn);
			mBuyBtn.x = mBase.width * 0.965 - mBuyBtn.width;
			mBuyBtn.y = 0.72 * mBase.height - mBuyBtn.height >> 1;
			
			if (mIsBestValue) {
				addChild(mBestValueBadge);
				mBestValueBadge.x = -0.12 * mBase.width;
				mBestValueBadge.y = 0.05*mBase.height;
			} else if (mIsMostPopular) {
				addChild(mMostPopularBadge);
				mMostPopularBadge.x = -0.12 * mBase.width;
				mMostPopularBadge.y = 0.05*mBase.height;
			}
		}
		
		public function get baseWidth():Number
		{
			return mBase.width;
		}
	}
}