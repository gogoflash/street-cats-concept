package com.alisacasino.bingo.models.gifts 
{
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.utils.FacebookData;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class IncomingGiftData 
	{
		public var requestID:String;
		public var senderID:String;
		
		public var cancelled:Boolean;
		
		private var _senderFirstName:String = null;
		private var _senderLastName:String = null;
		
		private var isFirstNameLatinCharsValue:int = -1;
		
		public var cashBonus:int;
		
		public function set senderFirstName(value:String):void 
		{
			_senderFirstName = value;
		}
		
		public function get senderFirstName():String 
		{
			if (!_senderFirstName)
			{
				_senderFirstName = FacebookData.instance.getFirstName(senderID, true);
			}
			return _senderFirstName;
		}
		
		public function get senderLastName():String
		{
			if (!_senderLastName)
			{
				_senderLastName = FacebookData.instance.getLastName(senderID, true);
			}
			return _senderLastName;
		}

		public function set senderLastName(value:String):void
		{
			_senderLastName = value;
		}
		
		public function IncomingGiftData(requestID:String, senderID:String) 
		{
			this.senderID = senderID;
			this.requestID = requestID;
		}
		
		public function get isFirstNameLatinChars():Boolean
        {
            if (isFirstNameLatinCharsValue == -1)
                isFirstNameLatinCharsValue = Fonts.allCharsInFont(Fonts.CHATEAU_DE_GARAGE, senderFirstName) ? 1 : 0;
            
            return Boolean(isFirstNameLatinCharsValue);
        }
		
		/* for generating gifts table */
		public function get seed():int
        {
            var value:Number = parseInt(requestID);
			
			if (isNaN(value))
				value = parseInt(senderID);
			
			if (isNaN(value))	
				return 1;
				
			return Math.max(1, value);	
		}		
		
		public function toString():String
		{
			return "IncomingGiftData{requestID=" + String(requestID) + ",senderID=" + String(senderID) + ",cancelled=" + String(cancelled) + ",_senderFirstName=" + String(_senderFirstName) + ",_senderLastName=" + String(_senderLastName) + "}";
		}
	}

}