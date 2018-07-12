package com.alisacasino.bingo.screens.loadingScreenClasses 
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
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class BenefitsBubble extends Sprite
	{
		private static const textStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		30.0,
			fontColor:		0x392809
		});
		
		private var background:Image;
		
		public function BenefitsBubble() 
		{
			background = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/bubble_body"));
			background.scale9Grid = new Rectangle(72*pxScale,27*pxScale,2*pxScale,5*pxScale)
			background.width = 240 * pxScale;
			background.height = 146 * pxScale;
			background.x = -background.width / 2;
			background.y = -background.height;
			addChild(background);
			
			var bubbleTail:Image = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/bubble_tail"));
			bubbleTail.alignPivot();
			addChild(bubbleTail);
			
			var ticketsImage:Image = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/tickets"));
			ticketsImage.scale = 0.4;
			addBubbleLine(0, "+25", ticketsImage);
			addBubbleLine(1, "Save Progress!");
			addBubbleLine(2, "Extra Security!");
		}
		
		private function addBubbleLine(order:int, text:String, image:Image = null):void 
		{
			var elementX:Number = background.x + 20 * pxScale;
			var baselineY:Number = background.y + 30 * pxScale + 40*pxScale * order;
			
			var checkImage:Image = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/check"));
			checkImage.scale = 0.7;
			checkImage.alignPivot(Align.LEFT);
			checkImage.x = elementX;
			checkImage.y = baselineY;
			addChild(checkImage);
			
			elementX += checkImage.width + 6 * pxScale;
			
			var label:XTextField = new XTextField(100, 20, textStyle, text);
			label.autoScale = false;
			label.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			label.x = elementX;
			label.redraw();
			label.alignPivot(Align.LEFT);
			label.y = baselineY + 0 * pxScale;
			addChild(label);
			
			if (image)
			{
				elementX += label.width + 4 * pxScale;;
				
				image.alignPivot(Align.LEFT);
				image.x = elementX;
				image.y = baselineY;
				addChild(image);
			}
		}
		
	}

}