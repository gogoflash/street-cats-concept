package com.alisacasino.bingo.models.game 
{
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DaubStreakData 
	{
		public var textYShift:Number;
		public var pointsBonus:int;
		public var textStyle:XTextFieldStyle;
		
		public function get needToGiveOutPoints():Boolean
		{
			return pointsBonus > 0;
		}
		
		public function DaubStreakData(textStyle:XTextFieldStyle, pointsBonus:int, textYShift:Number) 
		{
			this.textYShift = textYShift;
			this.pointsBonus = pointsBonus;
			this.textStyle = textStyle;
		}
		
	}

}