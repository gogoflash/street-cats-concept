package com.alisacasino.bingo.screens.sideMenuClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import feathers.controls.BasicButton;
	import feathers.controls.ButtonState;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import starling.display.Image;
	import starling.display.Quad;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class BackToHomeBlock extends BasicButton
	{
		private var backgroundQuad:Quad;
		
		public function BackToHomeBlock() 
		{
			useHandCursor = true;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			var skin:LayoutGroup = new LayoutGroup();
			backgroundQuad = new Quad(852 * pxScale, 72 * pxScale, 0xf600a8);
			//backgroundQuad.alpha = 0.6;
			backgroundQuad.x = -400 * pxScale;
			skin.addChild(backgroundQuad);
			
			var separatorLine:Quad = new Quad(852 * pxScale, 2 * pxScale, 0xcccccc);
			separatorLine.x = -400 * pxScale;
			separatorLine.y = backgroundQuad.height;
			separatorLine.alpha = 0.6;
			skin.addChild(separatorLine);
			
			var iconImage:Image = new Image(AtlasAsset.CommonAtlas.getTexture("side_menu/home"));
			iconImage.alignPivot();
			iconImage.x = 72 * pxScale;
			iconImage.y = 36 * pxScale;
			skin.addChild(iconImage);
			
			var label:XTextField = new XTextField(342 * pxScale, 50 * pxScale, XTextFieldStyle.getWalrus(28, 0xffffff), "BACK TO MAIN");
			label.x = 100 * pxScale;
			label.y = 14 * pxScale;
			skin.addChild(label);
			
			defaultSkin = skin;
			
			skin.setSize(452 * pxScale, 75 * pxScale);
		}
		
		override protected function refreshSkin():void 
		{
			super.refreshSkin();
			
			if (currentState == ButtonState.DOWN)
			{
				//backgroundQuad.color = 0x666666;
			}
			else
			{
				//backgroundQuad.color = 0x0;
			}
		}
		
	}

}