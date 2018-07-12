package com.alisacasino.bingo.screens.sideMenuClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.RateDialogManager;
	import feathers.controls.BasicButton;
	import feathers.controls.ButtonState;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class RateUsBlock extends BasicButton
	{
		private var backgroundQuad:Quad;
		
		public function RateUsBlock() 
		{
			useHandCursor = true;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			var skin:LayoutGroup = new LayoutGroup();
			backgroundQuad = new Quad(852 * pxScale, 75 * pxScale, 0x0);
			backgroundQuad.alpha = 0.6;
			backgroundQuad.x = -400 * pxScale;
			skin.addChild(backgroundQuad);
			
			var yellowBackground:Quad = new Quad(628 * pxScale, 75 * pxScale, 0xffde00);
			yellowBackground.x = -400 * pxScale;
			skin.addChild(yellowBackground);
			
			var starsImage:Image = new Image(AtlasAsset.CommonAtlas.getTexture("side_menu/star"));
			starsImage.tileGrid = new Rectangle();
			starsImage.scaleX = 5;
			starsImage.alignPivot();
			starsImage.x = 340 * pxScale;
			starsImage.y = 36 * pxScale;
			skin.addChild(starsImage);
			
			var label:XTextField = new XTextField(228 * pxScale, 50 * pxScale, XTextFieldStyle.getWalrus(34, 0x0), "RATE US!");
			//label.x = 100 * pxScale;
			label.y = 14 * pxScale;
			skin.addChild(label);
			
			defaultSkin = skin;
			
			skin.setSize(425 * pxScale, 75 * pxScale);
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
		
	}

}