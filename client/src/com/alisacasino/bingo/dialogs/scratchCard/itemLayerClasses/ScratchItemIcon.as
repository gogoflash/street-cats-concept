package com.alisacasino.bingo.dialogs.scratchCard.itemLayerClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.scratchCard.ScratchItem;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ScratchItemIcon extends Sprite
	{
		public function ScratchItemIcon() 
		{
			var quad:Quad = new Quad(50, 50);
			addChild(quad);
		}
		
		public function setContent(itemType:String, winningType:String, iconRepeat:int):void 
		{
			removeChildren();
			
			/*
			switch(itemType)
			{
				case ScratchItem.TYPE_COMMODITY:
					setCommodityItemIcon(winningType, iconRepeat);
					break;
				case ScratchItem.TYPE_SPECIAL_TOP_PRIZE:
					setSpecialIcon(AtlasAsset.ScratchCardAtlas.getTexture("top_prize_icon"));
					break;
			}*/
		}
		
		private function setSpecialIcon(texture:Texture):void 
		{
			var image:Image = new Image(texture);
			addChild(image);
		}
		
		
		private function setCommodityItemIcon(winningType:String, iconRepeat:int):void 
		{
			var numIcons:int = iconRepeat;
			
			var texture:Texture = CommodityItem.getCommodityItemTexture(winningType);
			var textureWidth:Number = texture.width;
			
			var imageScale:Number = 0.9 - iconRepeat * 0.1;
			var gap:Number = 14 * pxScale * imageScale;
			
			var shiftX:Number = 2 * pxScale;
			if (winningType == CommodityType.ENERGY)
			{
				shiftX = 6 * pxScale;
			}
			var shiftY:Number = 2 * pxScale;
			
			for (var i:int = 0; i < numIcons; i++) 
			{
				var image:Image = new Image(texture);
				image.scale = imageScale;
				image.x = gap * i + shiftX;
				image.y = gap * i + shiftY;
				addChildAt(image, 0);
			}
		}
		
	}

}