package com.alisacasino.bingo.models
{
	public class FacebookIdAndTimestamp
	{
		private var mFacebookId:String;
		private var mTimestamp:Number;
		private var mGiftsCount:Number;
		
		public function FacebookIdAndTimestamp(facebookId:String, timestamp:Number, giftsCount:Number = 0)
		{
			mFacebookId = facebookId;
			mTimestamp = timestamp;
			mGiftsCount = giftsCount;
		}
		
		public function get facebookId():String
		{
			return mFacebookId;
		}
		
		public function get timestamp():Number
		{
			return mTimestamp;
		}
		
		public function set timestamp(value:Number):void
		{
			mTimestamp = value;
		}
		
		public function get giftsCount():Number
		{
			return mGiftsCount;
		}
	}
}
