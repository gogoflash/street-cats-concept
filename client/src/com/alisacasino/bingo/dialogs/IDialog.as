package com.alisacasino.bingo.dialogs 
{
	public interface IDialog
	{
		function get fadeStrength():Number;
		function get blockerFade():Boolean;
		function get fadeClosable():Boolean;
		function get align():String;
		function get selfScaled():Boolean;
		function get baseScale():Number;
		
		function close():void;
	}
}