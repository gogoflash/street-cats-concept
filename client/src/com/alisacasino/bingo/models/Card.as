package com.alisacasino.bingo.models
{
	import com.alisacasino.bingo.protocol.CardMessage;
	
	public class Card
	{
		private var mCardId:uint;
		private var mNumbers:Array;
		private var mDaubedNumbers:Array;
		private var mMagicDaubs:Array;
		private var mInstantBingoNumber:uint;
		
		public function Card(m:CardMessage)
		{
			mCardId = m.cardId;
			mNumbers = m.numbers;
			mDaubedNumbers = [];
			mMagicDaubs = [];
			mInstantBingoNumber = 0;
		}
		
		public function get cardId():uint
		{
			return mCardId;
		}
		
		public function get numbers():Array
		{
			return mNumbers;
		}
		
		public function get daubedNumbers():Array
		{
			return mDaubedNumbers;
		}
		
		public function get magicDaubs():Array
		{
			return mMagicDaubs;
		}
		
		public function get instantBingoNumber():uint
		{
			return mInstantBingoNumber;
		}
		
		public function set instantBingoNumber(number:uint):void
		{
			mInstantBingoNumber = number;
		}
	}
}