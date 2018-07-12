package com.alisacasino.bingo.dialogs.facebookConnectDialogClasses
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	;

	public class FacebookBenefitsBubble extends Sprite
	{
		private static const textStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		36.0,
			fontColor:		0x5f5f5f
		});
		
		private var background:Image;
		
		public function FacebookBenefitsBubble() 
		{
			background = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/bubble_body"));
			background.scale9Grid = new Rectangle(72 * pxScale, 27 * pxScale, 2 * pxScale, 5 * pxScale);
			background.width = 360 * pxScale;
			background.height = 282 * pxScale;
			addChild(background);
			
			var bubbleTail:Image = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/bubble_tail"));
			bubbleTail.alignPivot();
			bubbleTail.rotation = Math.PI/2;
			bubbleTail.x = -10 * pxScale;
			bubbleTail.y = 100 * pxScale;
			addChild(bubbleTail);
			
			var ticketsImage:Image = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/tickets"));
			ticketsImage.scale = 0.6;
			addBubbleLine(0, "25!", ticketsImage, "Bonus");
			addBubbleLine(1, "Save Your Progress!");
			addBubbleLine(2, "Extra Security!");
			addBubbleLine(3, "Gift Center & Inbox!");
		}
		
		private function addBubbleLine(order:int, text:String, image:Image = null, prefixText:String = ""):void 
		{
			var elementX:Number = background.x + 20 * pxScale;
			var baselineY:Number = background.y + 50 * pxScale + 60*pxScale * order;
			
			var checkImage:Image = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/check"));
			checkImage.scale = 1;
			checkImage.alignPivot(Align.LEFT);
			checkImage.x = elementX;
			checkImage.y = baselineY;
			addChild(checkImage);
			
			elementX += checkImage.width + 6 * pxScale;
			
			if (prefixText && prefixText.length > 0)
			{
				var prefixLabel:XTextField = new XTextField(100, 20, textStyle, prefixText);
				prefixLabel.autoScale = false;
				prefixLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				prefixLabel.x = elementX;
				prefixLabel.redraw();
				prefixLabel.alignPivot(Align.LEFT);
				prefixLabel.y = baselineY + 0 * pxScale;
				addChild(prefixLabel);
				elementX = prefixLabel.x + prefixLabel.width + 2 * pxScale;
			}
			
			if (image)
			{
				image.alignPivot(Align.LEFT);
				image.x = elementX;
				image.y = baselineY;
				addChild(image);
				
				elementX += image.width + 4 * pxScale;
			}
			
			var label:XTextField = new XTextField(100, 20, textStyle, text);
			label.autoScale = false;
			label.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			label.x = elementX;
			label.redraw();
			label.alignPivot(Align.LEFT);
			label.y = baselineY + 0 * pxScale;
			addChild(label);
		}
		
	}
}