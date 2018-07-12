package com.alisacasino.bingo.dialogs.scratchCard.messageContainerClasses 
{
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.utils.Constants;
	import feathers.core.FeathersControl;
	import starling.utils.Align;
	;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class PromptMessage extends FeathersControl
	{
		private var label:XTextField;
		
		public function PromptMessage() 
		{
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			label = new XTextField(100, 100, XTextFieldStyle.getWalrus(50).addStroke(1, 0x0), Constants.SCRATCH_CARD_PROMPT);
			label.autoScale = false;
			label.format.verticalAlign = Align.CENTER;
			addChild(label);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				label.width = actualWidth;
				label.height = actualHeight - 40 * pxScale;
				label.redraw();
			}
		}
		
	}

}