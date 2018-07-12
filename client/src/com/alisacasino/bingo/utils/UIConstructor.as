package com.alisacasino.bingo.utils 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import feathers.controls.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	public class UIConstructor 
	{
		public function UIConstructor()  {
		}
		
		public static function dialogCloseButton(touchAreaPaddingHorisontal:int = 60, touchAreaPaddingVertical:int = 30, customTexture:Texture = null):Button 
		{
			var closeImage:Image = new Image(customTexture || AtlasAsset.LoadingAtlas.getTexture("dialogs/buttons/close"));
			var quadTouchArea:Quad = new Quad(1, 1, 0xB800B8);
			
			quadTouchArea.alpha = 0.0;
			quadTouchArea.width = closeImage.texture.frameWidth + 2 * touchAreaPaddingHorisontal * pxScale;
			quadTouchArea.height = closeImage.texture.frameHeight + 2 * touchAreaPaddingVertical * pxScale;
			closeImage.x = (quadTouchArea.width - closeImage.texture.frameWidth)/2;
			closeImage.y = (quadTouchArea.height - closeImage.texture.frameHeight) / 2;
			
			var closeButtonSkin:Sprite = new Sprite();
			closeButtonSkin.addChild(quadTouchArea);
			closeButtonSkin.addChild(closeImage);
			
			var closeButton:Button = new Button();
			closeButton.defaultSkin = closeButtonSkin;
			closeButton.validate();
			closeButton.alignPivot();
			closeButton.scaleWhenDown = 0.9;
			closeButton.useHandCursor = true;
			
			return closeButton;
		}
		
	}

}