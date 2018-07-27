package com.alisacasino.bingo.controls 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.Settings;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class EnemyBar extends ResourceBar
	{
		
		private var mAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		private var valueTween:Tween;
		
		private var targetValue:int;
		
		public var deferAnimation:Boolean;
		private var onTriggeredCallback:Function;
		
		public function EnemyBar() 
		{
			super(Settings.instance.saleType, true);
			
			
			icon = new Image(mAtlas.getTexture("cats/fish_red"));
			mCriticalValue = Constants.CRITICAL_VALUE_CASH;
			
			
			//setNewValue(4, false);
			
			
			icon.useHandCursor = true;
			mBtn.addReactDisplayObject(icon);
			mBtn.alpha = 0;
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			super.onAddedToStage(e);
			
			
			mLabel.x = mBase.width * 0.445 + 18;
			mLabel.y = mBase.height * 0.50;
			
			icon.x = mBase.width - 30 * pxScale + icon.pivotX;
			icon.y = mBase.height / 2 + 15;
			
		}
		
	}

}