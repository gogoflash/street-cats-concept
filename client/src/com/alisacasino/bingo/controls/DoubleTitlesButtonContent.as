package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import flash.geom.Rectangle;
	import starling.textures.Texture;

	import starling.display.Image;
	import starling.display.Sprite;
	
	public class DoubleTitlesButtonContent extends Sprite
	{
		public var background:Image;
		public var label1:XTextField;
		public var label2:XTextField;
		public var icon:Image;
		
		private var gap:int;
		private var shiftAllX:int;
		private var shiftIconX:int;
		private var shiftLabelsY:int;
		private var shiftIconY:int;
		
		private var roughness:Number = 4 * pxScale;
		private var lastContentX:Number = -99999;
		
		public function DoubleTitlesButtonContent(background:Image, 
												text1:String, 
												text1Style:XTextFieldStyle, 
												iconTexture:Texture = null, 
												text2:String = null, 
												text2Style:XTextFieldStyle = null, 
												gap:int = 0,
												shiftAllX:int = 0,
												shiftIconX:int = 0,
												shiftLabelsY:int = 0,
												shiftIconY:int = 0)
		{
			
			this.gap = gap;
			this.shiftAllX = shiftAllX;
			this.shiftIconX = shiftIconX;
			this.shiftLabelsY = shiftLabelsY;
			this.shiftIconY = shiftIconY;
			
			this.background = background;
			addChild(background);
			
			if (text1 && text1 != '') {
				label1 = new XTextField(background.width, background.height, text1Style, text1);
				label1.y = shiftLabelsY*pxScale;
				//label1.border = true;
				addChild(label1);
			}
			
			if (iconTexture) {
				icon = new Image(iconTexture);
				//icon.scale = 0.8;
				icon.alignPivot();
				icon.y = background.height / 2 + shiftIconY*pxScale;
				addChild(icon);
			}
			
			if (text2 && text2 != '') {
				label2 = new XTextField(background.width, background.height, text2Style, text2);
				label2.y = shiftLabelsY*pxScale;
				//label2.border = true;
				addChild(label2);
			}
			
			align();
		}
		
		public function align():void 
		{
			if (gameManager.deactivated)
				return;
				
			var newContentX:Number;
				
			if (label1 && icon && label2) 
			{
				newContentX = (background.width - label1.textBounds.width - icon.width - label2.textBounds.width - 2*gap*pxScale) / 2 - label1.textBounds.x + shiftAllX*pxScale;
				if (Math.abs(newContentX - lastContentX) < roughness)
					return;
					
				lastContentX = newContentX;
					
				label1.x = newContentX;
				icon.x = label1.x + label1.textBounds.x + label1.textBounds.width + icon.pivotX + gap*pxScale + shiftIconX*pxScale;
				label2.x = icon.x + icon.pivotX - label2.textBounds.x + gap*pxScale;
			}
			else if (label1 && icon) 
			{
				newContentX = (background.width - icon.width - label1.textBounds.width - gap*pxScale) / 2 - label1.textBounds.x + shiftAllX*pxScale;
				if (Math.abs(newContentX - lastContentX) < roughness)
					return;
					
				lastContentX = newContentX;
				
				label1.x = newContentX;
				icon.x = label1.x + label1.textBounds.x + label1.textBounds.width + icon.pivotX + gap*pxScale + shiftIconX*pxScale;
			}
			else if (icon && label2) 
			{
				newContentX = (background.width - icon.width - label2.textBounds.width - gap*pxScale) / 2 + shiftAllX*pxScale;
				if (Math.abs(newContentX - lastContentX) < roughness)
					return;
					
				lastContentX = newContentX;
				
				icon.x = newContentX + icon.pivotX;
				label2.x = icon.x + icon.pivotX - label2.textBounds.x + gap*pxScale;
			}
			else if (label1 && label2) 
			{
				// TODO IF NEED
			}
			else if (icon) 
			{
				// TODO IF NEED
			}
			else if(label1 || label2) {
				var textfield:XTextField = label1 || label2;
				textfield.x = (background.width - textfield.textBounds.width) / 2 - label1.textBounds.x + shiftAllX*pxScale;
			}
		}
		
		override public function get width():Number {
			return background.width;
		}
		
		override public function get height():Number {
			return background.height;
		}
		
		public static function createBuyForCashButtonContent(text1:String, icon:Texture = null, text2:String = null, gap:int = 0, width:Number = NaN, shiftAllX:int = -2, fontSize1:int = 0, fontSize2:int = 0):DoubleTitlesButtonContent
		{
			var background:Image = new Image(AtlasAsset.CommonAtlas.getTexture("buttons/green_base_contoured"));
			background.scale9Grid = ResizeUtils.getScaledRect(96, 0, 12, 0);
			background.width = isNaN(width) ? (233 * pxScale) : width;
			return new DoubleTitlesButtonContent(background, text1, XTextFieldStyle.getWalrus(fontSize1 != 0 ? fontSize1 : 21, 0xFFFFFF).setShadow(1.4, 0x087315), icon, text2, XTextFieldStyle.getWalrus(fontSize2 != 0 ? fontSize2 : 30, 0xFFFFFF).setShadow(1.4, 0x087315), gap, shiftAllX, 3, 0, 1);
		}
		
		public static function createBuyButtonContent(text1:String, icon:Texture = null, text2:String = null, gap:int = 0, width:Number = NaN, shiftAllX:int = -2):DoubleTitlesButtonContent
		{
			var background:Image = new Image(AtlasAsset.CommonAtlas.getTexture("buttons/green_base"));
			//background.scale9Grid = ResizeUtils.getScaledRect(96, 0, 12, 0);
			//background.width = isNaN(width) ? (233 * pxScale) : width;
			
			return new DoubleTitlesButtonContent(background, text1, XTextFieldStyle.OfferPackBuyForRealButton, icon, text2, XTextFieldStyle.OfferPackBuyForRealButton, gap, shiftAllX, 3, 0, 1);
		}
		
	}
}
