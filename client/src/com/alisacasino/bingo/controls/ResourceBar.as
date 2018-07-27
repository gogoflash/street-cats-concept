package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.sales.SaleType;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.GameManager;
	import starling.core.Starling;
	
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ResourceBar extends Sprite implements IResourceBar
	{
		private var _mgr:GameManager = GameManager.instance;
		private var mAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		protected var mBase:Image;
		protected var mBtn:XButton;
		protected var mLabel:XTextField;
		protected var hidePlusButton:Boolean;
		protected var icon:Image;
		protected var mCriticalValue:uint;
		private var lastCheckCriticalValue:int;
		protected var targetValue:int;
		
		public function ResourceBar(saleType:String = SaleType.NO_SALE, hidePlusButton:Boolean = false)
		{
			this.hidePlusButton = hidePlusButton;
			var scale:Number = pxScale;
			
			mBase = new Image(mAtlas.getTexture("buttons/dark_blue"));
			mBase.scale9Grid = new Rectangle(13 , 13, 2, 2);
			mBase.width = 155 * layoutHelper.specialScale;
			mBase.height = 62 * layoutHelper.specialScale;
			mBtn = new XButton(getPlusButtonStyle(saleType));
			
			mLabel = new XTextField(125 * scale, 50 * scale, XTextFieldStyle.getChateaudeGarage(45), '0');
			mLabel.touchable = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			mBase.useHandCursor = true;
			mBtn.addReactDisplayObject(mBase);
		}
		
		private function getPlusButtonStyle(saleType:String):XButtonStyle
		{
			var style:XButtonStyle = XButtonStyle.BarPlusButtonStyle;
			switch(saleType)
			{
				case SaleType.SUPERSALE:
					style = XButtonStyle.BarPlusSaleButtonStyle;
					break;
				case SaleType.BLACK_FRIDAY:
					style = XButtonStyle.BarPlusSaleButtonStyle;
					break;	
				default:
				case SaleType.NO_SALE:
					break;
			}
			
			return style;
		}
		
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addChild(mBase);
			
			mLabel.pivotX = mLabel.width / 2;
			mLabel.pivotY = mLabel.height / 2;
			mLabel.x = mBase.width * 0.445 + 18;
			mLabel.y = mBase.height * 0.50;
			addChild(mLabel);
			
			icon.scale = 1.25;
			icon.pivotX = icon.width / 2;
			icon.pivotY = icon.height / 2;
			icon.x = mBase.width - 202 * layoutHelper.specialScale + icon.pivotX;
			icon.y = mBase.height / 2 + 15;
			addChild(icon);
			
			mBtn.pivotX = mBtn.width / 2;
			mBtn.pivotY = mBtn.height / 2;
			mBtn.x = -15 * pxScale + mBtn.pivotX;
			mBtn.y = -14 * pxScale + mBtn.pivotY;
			
			if (!hidePlusButton)
			{
				addChild(mBtn);
			}
		}
		
		public function get value():uint
		{
			return mLabel.numValue;
		}

		public function set value(value:uint):void
		{
			if (mLabel.numValue == value)
			{
				return;
			}
			mLabel.numValue = value;
			checkCriticalValue(0);
		}
		
		public function getImageRect(targetSpace:DisplayObject):Rectangle
		{
			return icon.getBounds(targetSpace);
		}
		
		public function animateToValue(newValue:uint, duration:Number=1.0, delay:Number = 0.0):void
		{
			return;
			mLabel.animateToValue(newValue, duration, delay);
			if (newValue <= mCriticalValue) {
				mLabel.textStyle = XTextFieldStyle.ResourceBarRedTextFieldStyle;
			} else {
				mLabel.textStyle = XTextFieldStyle.ResourceBarTextFieldStyle;
			}
		}
		
		public function setNewValue(newValue:uint, animate:Boolean = true, delay:Number = 0.0):void
		{
			if (targetValue == newValue)
				return;
			
			var div:int = newValue - targetValue;
		    targetValue = newValue;	
			
			var duration:Number = getAnimationDuration(div);
				
			Starling.juggler.removeTweens(mLabel);
			//EffectsManager.removeJump(icon);
			EffectsManager.removeJump(mLabel);

			if (animate)
			{
				if(div > 0)
				{
					mLabel.animateToValue(newValue, duration, delay, checkCriticalValue);
				
					var jumpsCount:int = Math.max(5, duration/0.11);
					
					//EffectsManager.jump(icon, jumpsCount, 1, 1.4, 0.07, 0.04, 0.0, 0, 0, 1.8, true, false);
					EffectsManager.jump(mLabel, jumpsCount, 1, 1.3, 0.07, 0.04, 0.0, 0, 0, 2.8, true, false);
				}
				else
				{
					mLabel.animateToValue(newValue, duration, delay, checkCriticalValue);
				}
			}
			else
			{
				value = newValue;
			}
		}
		
		protected function getAnimationDuration(count:int):Number {
			if (count >= 100)
				return 1.8;
			else if (count >= 10)
				return 1;
			else if (count > 0)
				return 0.5;
			
			return 0.5;
		}
		
		protected function checkCriticalValue(div:int = 0):void 
		{
			if (lastCheckCriticalValue == int(mLabel.numValue))
				return;
				
			lastCheckCriticalValue = mLabel.numValue;
			
			//mLabel.textStyle = mLabel.numValue <= mCriticalValue ? XTextFieldStyle.ResourceBarRedTextFieldStyle : XTextFieldStyle.ResourceBarTextFieldStyle;
		}
	}
}