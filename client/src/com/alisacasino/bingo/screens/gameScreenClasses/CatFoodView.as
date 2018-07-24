package com.alisacasino.bingo.screens.gameScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import starling.animation.Transitions;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.TweenHelper;

	public class CatFoodView extends Sprite 
	{
		public static var FOOD_SCALE:Number = 0.80;
		
		public function CatFoodView() 
		{
			super();
			
			foodImage = new Image(AtlasAsset.CommonAtlas.getTexture('cats/trash_01'));
			foodImage.alignPivot();
			foodImage.scale = FOOD_SCALE;//;
			//foodImage.x = shiftX + i % columns * 150 * foodImageScale;
			//foodImage.alpha = 0;
			//foodImage.y = -layoutHelper.stageHeight/2 - foodImage.height/2 + 104;
			touchable = false;
			addChild(foodImage);
		}
		
		private var _foodCount:int;
		
		private var foodImage:Image;
		
		public function setFoodCount(value:int):void
		{
			foodCount = value;
		}
		
		public function set foodCount(value:int):void
		{
			if (value == _foodCount)
				return;
			
			if (value < _foodCount) {
				showFoodDrop(_foodCount-value);
			}
				
			_foodCount = value;
			
			if (_foodCount > 0)
			{
				
			}
			else
			{
				
			}	
			
			refreshHP();
		}
		
		public function get foodCount():int
		{
			return _foodCount;
		}	
		
		private var hpLabel:XTextField;
		
		public function refreshHP():void
		{
			if (_foodCount > 0)
			{
				if (!hpLabel) 
				{
					hpLabel = new XTextField(160 * pxScale, 30 * pxScale, XTextFieldStyle.getWalrus(22).setStroke(0.5), '' );
					hpLabel.alignPivot();
					//hpLabel.x = 75;
					hpLabel.y = 90;
					hpLabel.touchable = false;
				}
				
				//hpLabel.y = isFront ? -130 : 123;
				hpLabel.format.color = _foodCount > 0 ? 0x00E100 : 0xE10000;
				hpLabel.text = 'food:' + _foodCount.toString();
				
				addChild(hpLabel);
			}
			else
			{
				hpLabel.text = '';	
			}	
		}
		
		private function showFoodDrop(value:int):void 
		{
			var image:Image = new Image(AtlasAsset.CommonAtlas.getTexture('cats/fish'));
			image.alignPivot();
			image.scale = 1;
			//foodImage.x = shiftX + i % columns * 150 * foodImageScale;
			image.alpha = 0;
			image.y = -170 * layoutHelper.specialScale;
			touchable = false;
			addChild(image);
			
			TweenHelper.tween(image, 1.2, {transition:Transitions.EASE_OUT, alpha:7, delay:0.99, y: -250 * layoutHelper.specialScale, onComplete:image.removeFromParent});
		}
	}

}