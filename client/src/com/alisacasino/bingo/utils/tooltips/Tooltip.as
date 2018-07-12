package com.alisacasino.bingo.utils.tooltips 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class Tooltip extends FeathersControl
	{
		public var align:String;
		public var anchor:DisplayObject;
		private var bubbleBackground:Image;
		private var bubbleTail:Image;
		private var hintTextField:XTextField;
		private var bgContainer:Sprite;
		private var text:String;
		public var anchorShift:Point;
		
		public function Tooltip(anchor:DisplayObject, text:String, align:String, anchorShift:Point) 
		{
			this.anchor = anchor;
			this.text = text;
			this.anchorShift = anchorShift;
			this.align = align;
		}
		
		public function moveTailX(shift:Number):void 
		{
			bubbleTail.x += shift;
			if (bubbleTail.x > bgContainer.width - 20 * pxScale)
			{
				bubbleTail.x = bgContainer.width - 20 * pxScale;
			}
			else if (bubbleTail.x < 20 * pxScale)
			{
				bubbleTail.x = 20 * pxScale;
			}
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			bgContainer = new Sprite();
			bgContainer.scale = 0.5;
			addChild(bgContainer);
			bubbleBackground = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/chest/window_white_bg"));
			bubbleBackground.scale9Grid = ResizeUtils.getScaledRect(25, 25, 55, 55);
			//bubbleBackground.scale = 0.1;
			bgContainer.addChild(bubbleBackground);
			
			bubbleTail = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/chest/window_white_corner"));
			bubbleTail.alignPivot();
			bubbleTail.scale = 0.3;
			addChild(bubbleTail);
			
			hintTextField = new XTextField(10, 10, XTextFieldStyle.getChateaudeGarage(21, 0x6a6a6a, Align.LEFT)); 
			hintTextField.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			hintTextField.text = text;
			hintTextField.isHtmlText = true;
			hintTextField.x = 10 * pxScale;
			hintTextField.y = 10 * pxScale;
			addChild(hintTextField);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				hintTextField.redraw();
				
				bubbleBackground.width = (hintTextField.x * 2 + hintTextField.width) * 2;
				bubbleBackground.height = (hintTextField.y * 2 + hintTextField.height) * 2;
				
				switch(align)
				{
					default:
					case Align.TOP:
						bubbleTail.x = bgContainer.width / 2;
						bubbleTail.y = bgContainer.height + bubbleTail.pivotY * bubbleTail.scale - 4 * pxScale;
						setSizeInternal(bgContainer.width, bubbleTail.y + bubbleTail.height/2, false);
						break;
					case Align.BOTTOM:
						bubbleTail.rotation = Math.PI;
						bubbleTail.x = bgContainer.width / 2;
						bubbleTail.y = bubbleTail.pivotY * bubbleTail.scale;
						bgContainer.y += bubbleTail.height - 4 * pxScale;
						hintTextField.y += bubbleTail.height - 4 * pxScale;
						setSizeInternal(bgContainer.width, bgContainer.y + bgContainer.height, false);
						break;
					case Align.RIGHT:
						bubbleTail.rotation = Math.PI / 2;
						bgContainer.x += bubbleTail.width - 4 * pxScale;
						hintTextField.x += bubbleTail.width - 4 * pxScale;
						bubbleTail.x = bubbleTail.pivotY * bubbleTail.scale;
						bubbleTail.y = bgContainer.height / 2;
						setSizeInternal(bgContainer.x + bgContainer.width, bgContainer.height, false);
						break;
					case Align.LEFT:
						bubbleTail.x = bgContainer.width  + bubbleTail.pivotY * bubbleTail.scale - 4 * pxScale;;
						bubbleTail.rotation = -Math.PI / 2;
						setSizeInternal(bubbleTail.x + bubbleTail.width/2 -4*pxScale, bgContainer.height, false);
						break;
				}
				
				
				
			}
		}
		
	}

}