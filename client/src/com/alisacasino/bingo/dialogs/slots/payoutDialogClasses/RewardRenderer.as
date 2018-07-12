package com.alisacasino.bingo.dialogs.slots.payoutDialogClasses 
{
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import starling.display.Sprite;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class RewardRenderer extends Sprite
	{
		private static var quantityStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		56.0,
			fontColor:		0x007171,
			strokeSize:		2,
			strokeColor:	0xFFFFFF,
			hAlign:			Align.CENTER
		});
		
		private static var typeStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		30.0,
			fontColor:		0x007171,
			strokeSize:		2,
			strokeColor:	0xFFFFFF,
			hAlign:			Align.CENTER
		});
		
		private var _reward:CommodityItem;
		
		public function get reward():CommodityItem 
		{
			return _reward;
		}
		
		public function set reward(value:CommodityItem):void 
		{
			if (_reward != value)
			{
				_reward = value;
				updateLabels();
			}
		}
		
		private var quantityLabel:XTextField;
		private var typeLabel:XTextField;
		
		public function RewardRenderer() 
		{
			
			typeLabel = new XTextField(1, 1, typeStyle, "");
			typeLabel.autoScale = false;
			typeLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			typeLabel.y = 50 * pxScale;
			addChild(typeLabel);
			
			quantityLabel = new XTextField(1, 1, quantityStyle, "");
			quantityLabel.autoScale = false;
			quantityLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			addChild(quantityLabel);
		}
		
		private function updateLabels():void 
		{
			if (!_reward)
				return;
			
			quantityLabel.text = _reward.quantity.toString();
			quantityLabel.redraw();
			quantityLabel.pivotX = quantityLabel.width / 2;
			
			typeLabel.text = getTypeText(_reward.type);
			typeLabel.redraw();
			typeLabel.pivotX = typeLabel.width / 2;
		}
		
		private function getTypeText(type:String):String
		{
			var text:String = "";
			switch(type)
			{
				case CommodityType.CASH:
					text = "coins";
					break;
				case CommodityType.ENERGY:
					text = "energy";
					break;
				case CommodityType.KEY:
					text = "keys";
					break;
				case CommodityType.TICKET:
					text = "tickets";
					break;
			}
			
			return text;
		}
		
	}

}