package com.alisacasino.bingo.screens 
{
	import com.alisacasino.bingo.controls.CashBar;
	import com.alisacasino.bingo.controls.EnergyBar;
	import com.alisacasino.bingo.controls.CoinsBar;
	import com.alisacasino.bingo.controls.XpBar;
	import com.alisacasino.bingo.controls.ScoreBar;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ScreenBase extends Sprite implements IScreen
	{
		
		public function ScreenBase() 
		{
			
		}
		
		public function onBackButtonPressed():void 
		{
			
		}
		
		public function get requiredAssets():Array 
		{
			return [];
		}
		
		public function get scoreBar():ScoreBar 
		{
			return null;
		}
		
		public function get xpBar():XpBar 
		{
			return null;
		}
		
		public function get cashBar():CashBar 
		{
			return null;
		}
		
		public function get energyBar():EnergyBar 
		{
			return null;
		}
		
		public function resize():void 
		{
			
		}
		
	}

}