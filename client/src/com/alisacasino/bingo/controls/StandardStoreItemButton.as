package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import starling.display.DisplayObject;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class StandardStoreItemButton extends Sprite
	{
		private const ITEM_FONT_COLOR:uint = 0x3e8a88;
		private const ITEM_FONT_SIZE:Number = 55.0;
		private const PRICE_FONT_COLOR:uint = 0xffffff;
		private const PRICE_FONT_SIZE:Number = 50.0;
		private const PRICE_FONT_STROKE_COLOR:uint = 0x1d6041;
		
		private var mSmallCoinIcon:Image;
		private var mBestDeal:Image;
		
		protected var mBase:XButton;
		protected var mItem:Object;
		protected var mIcon:DisplayObject;
		protected var mValueLabel:XTextField;
		protected var mItemLabel:XTextField;
		protected var mPriceLabel:XTextField;
		protected var mIsPriceInCoins:Boolean;
		protected var mIsBestDeal:Boolean;
		
		protected var mCommonAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		
		public function StandardStoreItemButton()
		{
			mBase = new XButton(XButtonStyle.StandardStoreItemButtonStyle);
			mBase.scaleWhenDown = 1.0;
			mBase.alphaWhenDisabled = 1.0;
			
			mValueLabel = new XTextField(mBase.width * 0.8, mBase.height * 0.16, XTextFieldStyle.StoreItemTextFieldStyle);
			mItemLabel = new XTextField(mBase.width * 0.9, mBase.height * 0.16, XTextFieldStyle.StoreItemTextFieldStyle);
			
			mPriceLabel = new XTextField(mBase.width * 0.9, mBase.height * 0.2, XTextFieldStyle.StorePriceTextFieldStyle);
			
			mBestDeal =  new Image(mCommonAtlas.getTexture("dialogs/store/best_deal"));
			mSmallCoinIcon = new Image(mCommonAtlas.getTexture("dialogs/store/coin_little"));
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addChild(mBase);
			
			addChild(mIcon);
			mIcon.touchable = false;
			mIcon.x = mBase.width / 2 - mIcon.width / 2;
			mIcon.y = 0.76 * mBase.height - mIcon.height;
			
			addChild(mValueLabel);
			mValueLabel.touchable = false;
			mValueLabel.x = mBase.width / 2 - mValueLabel.width / 2;
			mValueLabel.y = mBase.height * 0.10;
			
			addChild(mItemLabel);
			mItemLabel.touchable = false;
			mItemLabel.x = mBase.width / 2 - mItemLabel.width / 2;
			mItemLabel.y = mBase.height * 0.22;
			
			addChild(mPriceLabel);
			mPriceLabel.touchable = false;
			if (mIsPriceInCoins) {
				addChild(mSmallCoinIcon);
				mSmallCoinIcon.touchable = false;
				mSmallCoinIcon.x = mBase.width * 0.05;
				mSmallCoinIcon.y = mBase.height * 0.81;
				mPriceLabel.width = mBase.width * 0.8 - mSmallCoinIcon.width;
				mPriceLabel.x = mBase.width * 0.1 + mSmallCoinIcon.width;
			} else {
				mPriceLabel.x = mBase.width / 2 - mPriceLabel.width / 2;
			}
			mPriceLabel.y = mBase.height * 0.8;
			
			if (mIsBestDeal) {
				addChild(mBestDeal);
				mBestDeal.touchable = false;
				mBestDeal.x = mBase.width / 2 - mBestDeal.width / 2;
				mBestDeal.y = -mBestDeal.height * 0.25;
			}
		}
		
		public function get baseWidth():Number
		{
			return mBase.width;
		}
	}
}