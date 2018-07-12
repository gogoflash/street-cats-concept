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
	public class InvitationMessage extends FeathersControl
	{
		
		private static const textStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		50.0,
			fontColor:		0xf0f3f4,
			strokeColor:	0x4c6c76,
			strokeSize:		2
		});
		private var label:XTextField;
		
		public function InvitationMessage() 
		{
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			label = new XTextField(100, 100, textStyle, Constants.SCRATCH_CARD_INVITATION);
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
				label.height = actualHeight;
			}
		}
		
	}


}