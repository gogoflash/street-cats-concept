package com.alisacasino.bingo.utils
{

	public final class StringUtils
	{
		/*public static function getTimeStr(time:int, short:Boolean = false):String
		{
			var d:int =  time / 86400;
			var h:int =  (time - d * 86400) / 3600;
			var m:int =  (time - d * 86400 - h*3600) / 60;
			var s:int =  (time - d * 86400 - h*3600 - m*60);
			
			var str:String;
			if ( d > 0)
			{
				str = "{0}" + getString("day") + " {1}" + getString("hour");
				if(!short)
					str += " {2}" + getString("min");
			}
			else if ( h > 0)
			{
				str = "{1}" + getString("hour") + " {2}" + getString("min");
			}
			else if ( m > 0)
			{
				str = "{2}" + getString("min") + " {3}" + getString("sec");
			}
			else 
			{
				str = "{3}" + getString("sec");
			}
			
			return StringUtil.substitute( str, d, h, m, s);
		}
		
		public static function getTimeFullString(time:int, short:Boolean = false):String
		{
			var d:int =  time / 86400;
			var h:int =  (time - d * 86400) / 3600;
			var m:int =  (time - d * 86400 - h*3600) / 60;
			var s:int =  (time - d * 86400 - h*3600 - m*60);
			
			var str:String;
			if ( d > 0)
			{
				str = "{0} " + getDayString(d);
				
				if(h > 0)
					str +=  " {1} " + getHourString(h);
					
				if(!short && m > 0)
					str += " {2} " + getMinuteString(m);
			}
			else if ( h > 0)
			{
				str = "{1} " + getHourString(h);
				if(m > 0)
					str += " {2} " + getMinuteString(m);
			}
			else if ( m > 0)
			{
				str = "{2} " + getMinuteString(m);
				if(s > 0)
					str += " {3} " + getSecondString(s);
			}
			else 
			{
				str = "{3} " + getSecondString(s);
			}
			
			return StringUtil.substitute( str, d, h, m, s);
		}*/
		
		public static function delimitThousands(number:int, delimiter:String):String
		{
			var text:String = "";
			while (number > 0)
			{
				if (number >= 1000)
				{
					text = delimiter + StringUtils.padWithZeroes(int(number % 1000),3) + text;
				}
				else
				{
					text = int(number % 1000).toString() + text;
				}
				number /= 1000;
			}
			return text;
		}
		
		public static function formatTime(time:int, format:String = "{1}:{2}:{3}", dayToHours:Boolean = false, hoursWithoutZero:Boolean = false, hideHoursWhenZero:Boolean = false):String
		{
			var d:int =  time / 86400;
			var h:int =  (time - d * 86400) / 3600;
			var m:int =  (time - d * 86400 - h*3600) / 60;
			var s:int =  (time - d * 86400 - h*3600 - m*60);
			
			if(dayToHours)
				h += d*24;
			
			if(hideHoursWhenZero && h == 0)
				return substitute("{1}:{2}", d, m>9?m:"0"+m, s>9?s:"0"+s);
			
			return substitute(format, d, (h>9 || hoursWithoutZero) ? h: "0" + h, m>9?m:"0"+m, s>9?s:"0"+s);
		}
		
		/**
		 * @param format:Vector.<String>
		 * [0] - часы
		 * [1] - минуты в случае когда отображаются часы и минуты: 4h 38min
		 * [2] - минуты в случае когда отображаются минуты секунды: 4min 38sec
		 * [3] - секунды в случае когда отображаются минуты секунды: 4min 38sec
		 * [4] - секунды в случае когда отображаются только секунды: 38sec
		 * [5] - разделитель между часами и минутами
		 * [6] - разделитель между минутами и секундами
		 * [7] - префикс для минут. Как правило нолик или пустота. Пример 4h 07min или 4h 7min.
		 * [8] - префикс для секунд. Как правило нолик или пустота. Пример 4m 07sec или 4m 7sec.
		 * 
		 * */
		public static function formatTimeShort(time:int, format:Vector.<String> = null):String
		{
			format = format || (new < String > ['H', 'M', 'M', 'S', 'S', ':',':','0','0']); 
			
			var d:int =  time / 86400;
			var h:int =  (time - d * 86400) / 3600;
			var m:int =  (time - d * 86400 - h*3600) / 60;
			var s:int =  (time - d * 86400 - h*3600 - m*60);
			
			h += d*24;
			
			if (h != 0) {
				return h + format[0] + (m == 0 ? '' : (format[5] + (m>9?m:format[7]+m) + format[1]));
			}
			else if (m != 0) {
				return m + format[2] + (s == 0 ? '' : (format[6] + (s>9?s:format[8]+s) + format[3]));
			}
			
			return s + format[4];
		}
		
		public static function unixTimeToString(seconds:Number):String {
			var d:Date = new Date();
			d.time = seconds * 1000;
			return 'day: ' + d.date + ' time: ' + d.hours + ':' + d.minutes + ':' + d.seconds;
		}
		
		public static function substitute(str:String, ... rest):String
	    {
	        if (str == null) 
				return '';
	        
	        // Replace all of the parameters in the msg string.
	        var len:uint = rest.length;
	        var args:Array;
	        if (len == 1 && rest[0] is Array)
	        {
	            args = rest[0] as Array;
	            len = args.length;
	        }
	        else
	        {
	            args = rest;
	        }
	        
	        for (var i:int = 0; i < len; i++)
	        {
	            str = str.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
	        }
	
	        return str;
	    }
		
		public static function padWithZeroes(num:int, minLength:uint):String
		{
			var str:String = num.toString();
			while (str.length < minLength)
			{
				str = "0" + str;
			}
			return str;
		}
		
		
		public static function getDateString(time:int):String 
		{
			var logDate:Date = new Date();
			logDate.setTime(time * 1000);
			
			return logDate.getFullYear().toString() + '.' + logDate.getMonth().toString() + "." + logDate.getDate().toString() + "_" + padWithZeroes(logDate.getHours(), 2) + "-" + padWithZeroes(logDate.getMinutes(), 2) + "-" + padWithZeroes(logDate.getSeconds(), 2);
		}
		
		public static function numberToNounString(number:int):String 
		{
			if (number < 10)
				return numberToNounStringBeforeTen(number);
			
			switch(number) {
				case 10: return 'ten';
				case 11: return 'eleven';
				case 12: return 'twelve';
				case 13: return 'thirteen';
				case 14: return 'fourteen';
				case 15: return 'fifteen';
				case 16: return 'sixteen';
				case 17: return 'seventeen';
				case 18: return 'eighteen';
				case 19: return 'nineteen';
			}
			
			var string:String;
			switch(Math.floor(number/10)) {
				case 2: string = 'twenty'; break;
				case 3: string = 'thirty'; break;
				case 4: string = 'forty'; break;
				case 5: string = 'fifty'; break;
				case 6: string = 'sixty'; break;
				case 7: string = 'seventy'; break;
				case 8: string = 'eighty'; break;
				case 9: string = 'ninety'; break;
			}
			
			if (number <= 99) 
			{
				var excess:int = number % 10;
				if(excess == 0)
					return string;
				else 
					return string + ' ' + numberToNounStringBeforeTen(number%10, true);
			}
				
			return number.toString();
		}
		
		private static function numberToNounStringBeforeTen(number:int, zeroAsBlank:Boolean = false):String 
		{
			var string:String;
			switch(number) {
				case 0: return zeroAsBlank ? '' : 'zero';
				case 1: return 'one';
				case 2: return 'two';
				case 3: return 'three';
				case 4: return 'four';
				case 5: return 'five';
				case 6: return 'six';
				case 7: return 'seven';
				case 8: return 'eight';
				case 9: return 'nine';
			}
			
			return number.toString();
		}
	}	
}