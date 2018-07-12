package com.alisacasino.bingo.dialogs.facebookConnectDialogClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import feathers.controls.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class FacebookConnectButton extends Button
	{
		private static const textStyle:XTextFieldStyle = new XTextFieldStyle({
				fontSize:		58.0,
				fontColor:		0xffffff,
				strokeSize:		2,
				strokeColor:	0x004b6d
			});
		
		private var textLabel1:XTextField;
		private var textLabel2:XTextField;
		private var ticketImage:Image;
		private var textContainer:Sprite;
		
		public function FacebookConnectButton() 
		{
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			defaultSkin = new Image(AtlasAsset.LoadingAtlas.getTexture("dialogs/buttons/big_blue"));
			downSkin = new Image(AtlasAsset.LoadingAtlas.getTexture("dialogs/buttons/big_blue_on"));
			
			textContainer = new Sprite();
			
			textLabel1 = new XTextField(20, 20, textStyle, "Connect & Get");
			textLabel1.autoScale = false;
			textLabel1.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			textLabel1.redraw();
			textContainer.addChild(textLabel1);
			
			ticketImage = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/tickets"));
			ticketImage.scale = 0.8;
			ticketImage.x = textLabel1.width + 6 * pxScale;
			ticketImage.y = 4 * pxScale;
			textContainer.addChild(ticketImage);
			
			textLabel2 = new XTextField(20, 20, textStyle, "25");
			textLabel2.autoScale = false;
			textLabel2.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			textLabel2.redraw();
			textLabel2.x = ticketImage.x + ticketImage.width + 6 * pxScale;
			textContainer.addChild(textLabel2);
			
			defaultIcon = textContainer;
			
			iconOffsetY = -4 * pxScale;
			iconOffsetX = -4 * pxScale;
		}
		
		override protected function refreshSkin():void 
		{
			super.refreshSkin();
			
			textContainer.scale = (currentState == STATE_DOWN || currentState == STATE_DISABLED) ? 0.94 : 1;
			
			invalidate(INVALIDATION_FLAG_LAYOUT);
		}
		
	}

}