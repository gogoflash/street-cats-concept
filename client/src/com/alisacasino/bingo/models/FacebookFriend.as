package com.alisacasino.bingo.models
{
	import com.alisacasino.bingo.assets.Fonts;
	public class FacebookFriend
	{
		private var mFacebookId:String;
		private var mFirstName:String;
		private var mLastName:String;
		private var mSelected:Boolean;
		private var mGiftsCount:Number;
		private var mIsInvitable:Boolean;
		private var mPictureUrl:String;
		private var mInviteToken:String;
        private var isFirstNameLatinCharsValue:int = -1;
	
		
		public function FacebookFriend(facebookId:String, firstName:String, lastName:String, isInvitable:Boolean = false, pictureUrl:String = null, inviteToken:String = null)
		{
			mFacebookId = facebookId;
			mFirstName = firstName;
			mLastName = lastName;
			mIsInvitable = isInvitable;
			mPictureUrl = pictureUrl;
			mInviteToken = inviteToken;
		}
		
		public function get facebookId():String
		{
			return mFacebookId;
		}
		
		public function get inviteToken():String
		{
			return mInviteToken;
		}

		public function get lastName():String
		{
			return mLastName;
		}
		
		public function get pictureURL():String
		{
			if(mIsInvitable)
				return mPictureUrl;
			if (facebookId != null) {
				return Player.getAvatarURL("", mFacebookId)
			} else
				return null;
		}
		
		public function avatarIndex():int
		{
			if(!mIsInvitable) {
				return Number(mFacebookId)%5 + 1;
			}
			
			var letters:Vector.<String> = new <String>["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
			
			var retVal:int = 0;
			for (var i:int = 0; i < mInviteToken.length; i++) {
				retVal += letters.indexOf(mInviteToken.charAt(i));
			}
			return retVal%5 + 1;
		}
		
		public function get firstName():String
		{
			return mFirstName;
		}
		
		public function get selected():Boolean
		{
			return mSelected;
		}
		
		public function set selected(value:Boolean):void
		{
			mSelected = value;
		}
		
		public function get giftsCount():Number
		{
			return mGiftsCount;
		}
		
		public function set giftsCount(value:Number):void
		{
			mGiftsCount = value;
		}

        public function get isFirstNameLatinChars():Boolean
        {
            if (isFirstNameLatinCharsValue == -1)
                isFirstNameLatinCharsValue = Fonts.allCharsInFont(Fonts.CHATEAU_DE_GARAGE, firstName) ? 1 : 0;
            
            return Boolean(isFirstNameLatinCharsValue);
        }
		
	}
}
