package com.alisacasino.bingo.screens.sideMenuClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.controls.ButtonState;
	import feathers.controls.LayoutGroup;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class OptionButton extends BasicButton
	{
		private var backgroundQuad:Quad;
		private var iconTexture:Texture;
		private var labelText:String;
		protected var skin:LayoutGroup;
		
		private var countBg:Image;
		private var countLabel:XTextField;
		
		public function OptionButton(iconTexture:Texture, labelText:String) 
		{
			this.labelText = labelText;
			this.iconTexture = iconTexture;
			
			useHandCursor = true;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			skin = new LayoutGroup();
			backgroundQuad = new Quad(852 * pxScale, 77 * pxScale, 0x0);
			backgroundQuad.alpha = 0.6;
			backgroundQuad.x = -400 * pxScale;
			skin.addChild(backgroundQuad);
			
			var separatorLine:Quad = new Quad(852 * pxScale, 2 * pxScale, 0xcccccc);
			separatorLine.x = -400 * pxScale;
			separatorLine.y = backgroundQuad.height;
			separatorLine.alpha = 0.6;
			skin.addChild(separatorLine);
			
			var iconImage:Image = new Image(iconTexture);
			iconImage.alignPivot();
			iconImage.x = 72 * pxScale;
			iconImage.y = 36 * pxScale;
			skin.addChild(iconImage);
			
			var label:XTextField = new XTextField(342 * pxScale, 50 * pxScale, XTextFieldStyle.getWalrus(28, 0xffffff), labelText);
			label.x = 100 * pxScale;
			label.y = 14 * pxScale;
			skin.addChild(label);
			
			defaultSkin = skin;
			
			skin.setSize(452 * pxScale, 77 * pxScale);
		}
		
		override protected function refreshSkin():void 
		{
			super.refreshSkin();
			
			if (currentState == ButtonState.DOWN)
			{
				backgroundQuad.color = 0x666666;
			}
			else
			{
				backgroundQuad.color = 0x0;
			}
		}
		
		public function set labelCount(value:int):void 
		{
			if (value > 0)
			{
				if (!countBg) 
				{
					countBg = new Image(AtlasAsset.CommonAtlas.getTexture('icons/red_circle'));
					//countBg.alignPivot();
					countBg.x = 387 * pxScale;
					countBg.y = 16 * pxScale;
					skin.addChild(countBg);
					
					countLabel = new XTextField(countBg.width, countBg.height, XTextFieldStyle.getWalrus(27, 0xffffff), value.toString());
					countLabel.x = countBg.x - 0.5 * pxScale;
					countLabel.y = countBg.y + 1.5 * pxScale;
					//countLabel.border = true
					skin.addChild(countLabel);
				}
				else {
					countLabel.text = value.toString();
				}
			}
			else
			{
				if (countBg) {
					countBg.removeFromParent();
					countBg  = null;
					
					countLabel.removeFromParent(true);
					countLabel = null;
				}
			}
		}
	}

}