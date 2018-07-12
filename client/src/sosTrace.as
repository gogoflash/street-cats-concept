package
{
	import com.alisacasino.bingo.utils.Constants;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public function sosTrace(...arguments):void
	{
		if (!Constants.isDevFeaturesEnabled && !Constants.isLocalBuild && !Constants.enableProdLogging)
			return;
		
		var string:String = '';
		var argument:*;
		
		var validKeys:/*String*/Array = [SOSLog.SYSTEM, SOSLog.INFO, SOSLog.ERROR, SOSLog.DEBUG, SOSLog.WARNING, SOSLog.TRACE, SOSLog.FATAL, SOSLog.FINER];
		
		var key:String = "SYSTEM";
		var lastArg:* = arguments[arguments.length - 1];
		if (lastArg && lastArg is String)
		{
			for each (var validKey:String in validKeys)
			{
				if (validKey == lastArg)
				{
					key = arguments.pop();
					break;
				}
			}
		}
		
		const length:uint = arguments.length;
		for (var i:int = 0; i < length; i++)
		{
			argument = arguments[i];
			if (argument == null)
			{
				string += null;
			}
			else if (typeof(argument) == 'object')
			{
				if (Object(argument).hasOwnProperty("toString"))
				{
					string += "\n" + argument.toString() + "\n";
				}
				else
				{
					string += '\n';
					string += "[" + getQualifiedClassName(argument) + "]";
					string += '\n' + SOSLog.objectToString(argument) + '\n';
					string += "[/" + getQualifiedClassName(argument) + "]";
				}
				
			}
			else
			{
				string += argument;
				if (i < arguments.length - 1)
				{
					string += ', ';
				}
			}
		}
		
		SOSLog.add(string, key);
	}
}
