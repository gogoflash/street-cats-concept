package com.alisacasino.bingo.screens.gameScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import starling.display.Image;
	import starling.display.Sprite;

	public class CatFoodView extends Sprite 
	{
		public function CatFoodView() 
		{
			super();
			
			foodImage = new Image(AtlasAsset.CommonAtlas.getTexture('cats/fish_chest'));
			foodImage.alignPivot();
//			foodImage.scale = foodImageScale;
			//foodImage.x = shiftX + i % columns * 150 * foodImageScale;
			//foodImage.alpha = 0;
			//foodImage.y = -layoutHelper.stageHeight/2 - foodImage.height/2 + 104;
			touchable = false;
			addChild(foodImage);
		}
		
		private var _foodCount:int;
		
		private var foodImage:Image;
		
		public function set foodCount(value:int):void
		{
			if (value == _foodCount)
				return;
				
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
					hpLabel = new XTextField(160 * pxScale, 30 * pxScale, XTextFieldStyle.getWalrus(18).setStroke(0.5), '' );
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
	}

}