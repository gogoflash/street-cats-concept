package com.alisacasino.bingo.screens
{
	import com.alisacasino.bingo.controls.CashBar;
	import com.alisacasino.bingo.controls.CoinsBar;
	import com.alisacasino.bingo.controls.EnergyBar;
	import com.alisacasino.bingo.controls.ScoreBar;
	import com.alisacasino.bingo.controls.XpBar;
	import com.alisacasino.bingo.resize.IResizable;

	public interface IScreen extends IResizable
	{
		function onBackButtonPressed():void;
		
		function get requiredAssets():Array;
	}
}