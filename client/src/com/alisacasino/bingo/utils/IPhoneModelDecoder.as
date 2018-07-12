package com.alisacasino.bingo.utils 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class IPhoneModelDecoder 
	{
		private static const models:Object = {
			"iPhone1,1":"iPhone"
			,"iPhone1,2":"iPhone 3G"
			,"iPhone2,1":"iPhone 3GS"
			,"iPhone3,1":"iPhone 4 (GSM)"
			,"iPhone3,3":"iPhone 4 (CDMA)"
			,"iPhone4,1":"iPhone 4S"
			,"iPhone5,1":"iPhone 5 (A1428)"
			,"iPhone5,2":"iPhone 5 (A1429)"
			,"iPhone5,3":"iPhone 5c (A1456/A1532)"
			,"iPhone5,4":"iPhone 5c (A1507/A1516/A1529)"
			,"iPhone6,1":"iPhone 5s (A1433/A1453)"
			,"iPhone6,2":"iPhone 5s (A1457/A1518/A1530)"
			,"iPhone7,1":"iPhone 6 Plus"
			,"iPhone7,2":"iPhone 6"
			,"iPhone8,1":"iPhone 6s"
			,"iPhone8,2":"iPhone 6s Plus"
			,"iPhone8,4":"iPhone SE"
			,"iPhone9,1":"iPhone 7 (A1660/A1779/A1780)"
			,"iPhone9,2":"iPhone 7 Plus (A1661/A1785/A1786)"
			,"iPhone9,3":"iPhone 7 (A1778)"
			,"iPhone9,4":"iPhone 7 Plus (A1784)"
			,"iPad1,1":"iPad"
			,"iPad2,1":"iPad 2 (Wi-Fi)"
			,"iPad2,2":"iPad 2 (GSM)"
			,"iPad2,3":"iPad 2 (CDMA)"
			,"iPad2,4":"iPad 2 (Wi-Fi, revised)"
			,"iPad2,5":"iPad mini (Wi-Fi)"
			,"iPad2,6":"iPad mini (A1454)"
			,"iPad2,7":"iPad mini (A1455)"
			,"iPad3,1":"iPad (3rd gen, Wi-Fi)"
			,"iPad3,2":"iPad (3rd gen, Wi-Fi+LTE Verizon)"
			,"iPad3,3":"iPad (3rd gen, Wi-Fi+LTE AT&T)"
			,"iPad3,4":"iPad (4th gen, Wi-Fi)"
			,"iPad3,5":"iPad (4th gen, A1459)"
			,"iPad3,6":"iPad (4th gen, A1460)"
			,"iPad4,1":"iPad Air (Wi-Fi)"
			,"iPad4,2":"iPad Air (Wi-Fi+LTE)"
			,"iPad4,3":"iPad Air (Rev)"
			,"iPad4,4":"iPad mini 2 (Wi-Fi)"
			,"iPad4,5":"iPad mini 2 (Wi-Fi+LTE)"
			,"iPad4,6":"iPad mini 2 (Rev)"
			,"iPad4,7":"iPad mini 3 (Wi-Fi)"
			,"iPad4,8":"iPad mini 3 (A1600)"
			,"iPad4,9":"iPad mini 3 (A1601)"
			,"iPad5,1":"iPad mini 4 (Wi-Fi)"
			,"iPad5,2":"iPad mini 4 (Wi-Fi+LTE)"
			,"iPad5,3":"iPad Air 2 (Wi-Fi)"
			,"iPad5,4":"iPad Air 2 (Wi-Fi+LTE)"
			,"iPad6,3":"iPad Pro (9.7 inch) (Wi-Fi)"
			,"iPad6,4":"iPad Pro (9.7 inch) (Wi-Fi+LTE)"
			,"iPad6,7":"iPad Pro (12.9 inch, Wi-Fi)"
			,"iPad6,8":"iPad Pro (12.9 inch, Wi-Fi+LTE)"
			,"iPod1,1":"iPod touch"
			,"iPod2,1":"iPod touch (2nd gen)"
			,"iPod3,1":"iPod touch (3rd gen)"
			,"iPod4,1":"iPod touch (4th gen)"
			,"iPod5,1":"iPod touch (5th gen)"
			,"iPod7,1":"iPod touch (6th gen)"
			,"iPad6,11":"iPad 5"
			,"iPad6,12":"iPad 5"
			,"iPad7,1":"iPad Pro (12.9 inch, 2nd gen)"
			,"iPad7,2":"iPad Pro (12.9 inch, 2nd gen)"
			,"iPad7,3":"iPad Pro (10.5 inch)"
			,"iPad7,4": "iPad Pro (10.5 inch)"
			,"iPhone10,1":"iPhone 8"
			,"iPhone10,3":"iPhone 8"
			,"iPhone10,2":"iPhone 8 Plus"
			,"iPhone10,4":"iPhone 8 Plus"
			,"iPhone10,5":"iPhone X"
			,"iPhone10,6":"iPhone X"
		};
		
		public function IPhoneModelDecoder() 
		{
			
		}
		
		public static function decode(modelString:String):String
		{
			if (modelString && models.hasOwnProperty(modelString))
			{
				return models[modelString];
			}
			return modelString;
		}
		
		private static const forced480Models:Array = [
			"iPad1,1"
			,"iPad2,1"
			,"iPad2,2"
			,"iPad2,3"
			,"iPad2,4"
			,"iPad2,5"
			,"iPad2,6"
			,"iPad2,7"
		];
		
		public static function needToForce480(modelString:String):Boolean
		{
			for each (var item:String in forced480Models) 
			{
				if (modelString == item)
				{
					return true;
				}
			}
			return false;
		}
		
		public static function isIPhoneX(modelString:String):Boolean
		{
			return modelString == "iPhone X";
		}
		
		private static const forceDisableFilters:Array = [
		"iPad1,1"
		,"iPad2,1"
		,"iPad2,2"
		,"iPad2,3"
		,"iPad2,4"
		,"iPad2,5"
		,"iPad2,6"
		,"iPad2,7"
		,"iPad3,1"
		,"iPad3,2"
		,"iPad3,3"
		,"iPad3,4"
		,"iPad3,5"
		,"iPad3,6"
		];
		
		
		public static function needToDisableFilters(modelString:String):Boolean
		{
			for each (var item:String in forceDisableFilters) 
			{
				if (modelString == item)
				{
					return true;
				}
			}
			return false;
		}
		
	}

}