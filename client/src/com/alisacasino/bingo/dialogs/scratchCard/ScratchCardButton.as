package com.alisacasino.bingo.dialogs.scratchCard
{
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.controls.customButtons.AnimatedGreenButton;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.utils.Constants;
	import feathers.controls.BasicButton;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ScratchCardButton extends BasicButton
	{
		private static const textStyle:XTextFieldStyle = new XTextFieldStyle({fontSize: 70.0, fontColor: 0x054200, strokeSize: 2, strokeColor: 0xeeeeee});
		
		private var firstLabel:XTextField;
		private var ticketIcon:Image;
		private var secondLabel:XTextField;
		private var paymentContainer:Sprite;
		
		private var _price:int = 0;
		
		public function get price():int
		{
			return _price;
		}
		
		public function set price(value:int):void
		{
			if (_price != value)
			{
				_price = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		private var _inProgress:Boolean;
		
		public function get inProgress():Boolean 
		{
			return _inProgress;
		}
		
		public function set inProgress(value:Boolean):void 
		{
			if (_inProgress != value)
			{
				_inProgress = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		public function ScratchCardButton()
		{
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			paymentContainer = new Sprite();
			addChild(paymentContainer);
			
			firstLabel = new XTextField(10, 10, textStyle, Constants.SCRATCH_CARD_PAYMENT_FIRST_PART);
			firstLabel.autoScale = false;
			firstLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			paymentContainer.addChild(firstLabel);
			
			ticketIcon = new Image(CommodityItem.getCommodityItemTexture(CommodityType.TICKET));
			ticketIcon.y = 8 * pxScale;
			ticketIcon.scale = 0.8;
			paymentContainer.addChild(ticketIcon);
			
			secondLabel = new XTextField(10, 10, textStyle, "");
			secondLabel.autoScale = false;
			secondLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			paymentContainer.addChild(secondLabel);
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				secondLabel.text = price.toString();
				invalidate(INVALIDATION_FLAG_SIZE);
			}
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				firstLabel.redraw();
				ticketIcon.x = firstLabel.width + 10 * pxScale;
				secondLabel.x = ticketIcon.x + ticketIcon.width + 2 * pxScale;
				secondLabel.redraw();
				
				var paymentInfoWidth:Number = secondLabel.x + secondLabel.width;
				
				paymentContainer.scale = (actualWidth - 60 * pxScale) / paymentInfoWidth;
				paymentContainer.alignPivot();
				paymentContainer.x = actualWidth / 2 - 3*pxScale;
				paymentContainer.y = actualHeight / 2 - 3*pxScale;
			}
			
			if (isInvalid(INVALIDATION_FLAG_STATE))
			{
				text = inProgress ? Constants.SCRATCH_CARD_BUTTON_GAME_STARTED : Constants.SCRATCH_CARD_BUTTON_DOWN_TEXT;
				textLabel.visible = !isEnabled;
				paymentContainer.visible = isEnabled;
			}
		}
	
	}

}