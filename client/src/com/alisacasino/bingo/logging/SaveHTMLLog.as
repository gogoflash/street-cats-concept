package com.alisacasino.bingo.logging 
{
	import com.alisacasino.bingo.models.Player;
	import flash.net.FileReference;
	import flash.system.Capabilities;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SaveHTMLLog
	{
		public function SaveHTMLLog()
		{
		
		}
		
		public function execute():void
		{
			var file:FileReference = new FileReference();
			file.save(getHTMLString(), "bingo_" + getDateString(false) + ".html");
			
			//Message log for load testing server
			//file.save(JSON.stringify(Game.messageLog), "bingo_" + getDateString(false) + ".json");
			
			//var logDate:Date = new Date();
			//file.save(getHTMLString(), "bingo_log_" + logDate.getUTCFullYear() + "-" + padWithZeroes(logDate.getUTCMonth() + 1, 2) + "-" + padWithZeroes(logDate.getUTCDate(), 2) + "_" + padWithZeroes(logDate.getUTCHours(), 2) + "-" + padWithZeroes(logDate.getUTCMinutes(), 2) + ".html");
		}
		
		public static function getHTMLString():String 
		{
			var htmlString:String = '';
			htmlString += (<![CDATA[
			<html>
				<head>
					<style type="text/css">
						* 
						{ 
							font-family: "Courier New"; 
							font-weight: normal; 
							font-size: 12px; 
							margin: 0; 
							padding: 0; 
						}
						
						.item
						{
							border-top: 1px dotted #CCCCCC;
							padding-top: 2px; 
							padding-bottom: 2px;
						}
						
						.CONFIG
						{
							background-color: #99FF99
						}
						
						.ERROR 
						{ 
							background-color: #FFCCCC 
						}
						
						.FATAL 
						{ 
							background-color: #990000;
							color: #FFFFFF;
						}
						
						.WARNING 
						{ 
							background-color: #FFEECC 
						}
						
						.DEBUG 
						{ 
							background-color: #DDEEFF 
						}
						
						.INFO 
						{ 
							background-color: #FFFF99 
						}
						
						.FINER 
						{ 
							background-color: #D4FFAA 
						}
						
					</style>
				</head>
				<body>
				<div style="position:fixed; left: 0; top: 0; width: 100%; background-color: #FFFFFF;">
					<input type="checkbox" name="FATAL" id="FATAL" class="log-checkbox" value=""/> <label for="FATAL">FATAL</label>
					<input type="checkbox" name="ERROR" id="ERROR" class="log-checkbox" value=""/> <label for="ERROR">ERROR</label>
					<input type="checkbox" name="WARNING" id="WARNING" class="log-checkbox" value=""/> <label for="WARNING">WARNING</label>
					<input type="checkbox" name="DEBUG" id="DEBUG" class="log-checkbox" value=""/> <label for="DEBUG">DEBUG</label>
					<input type="checkbox" name="INFO" id="INFO" class="log-checkbox" value=""/> <label for="INFO">INFO</label>
					<input type="checkbox" name="LOG" id="LOG" class="log-checkbox" value=""/> <label for="LOG">LOG</label>
					<input type="checkbox" name="SOCIAL" id="FINER" class="log-checkbox" value=""/> <label for="FINER">SOCIAL</label>
				</div>
				
				

				
				<script type="text/javascript">
					function init_logs() {
						var inputs = document.getElementsByClassName('log-checkbox');
						for (var i = 0; i < inputs.length; i++) 
						{
							inputs[i].checked = true;
							inputs[i].onchange = function() {
								var divs = document.getElementsByClassName(this.id);
								if (this.checked) {
									for(var j = 0; j < divs.length; j++) {
										divs[j].style.display = 'block';
									}
								} else {
									for(var j = 0; j < divs.length; j++) {
										divs[j].style.display = 'none';
									}
								}
							}
						}
					}
					init_logs();
				</script>
				
				<div style="margin-top: 20px">
				
			]]>).toString();
			
			var logMessageNum:int = SOSLog.logMessages.length;
			for (var k:int = 0; k < logMessageNum; k++)
			{
				var item:SOSLogItem = SOSLog.logMessages[k];
				
				var lineClass:String = item.type;
				
				if (lineClass == SOSLog.SYSTEM || lineClass == SOSLog.TRACE)
					lineClass = "LOG";
				
				if (!lineClass)
					lineClass = "LOG";
				
				htmlString += "<div class=\"" + lineClass + " item\">";
				
				htmlString += Number(item.time / 1000).toString() + ":";
				
				var regexp:RegExp = /\n/g;
				var detailLines:Array = item.message.split(regexp);
				for each (var line:String in detailLines)
				{
					var numSpacesInTheBegginingOfLine:int = 0;
					var lineMatch:Array = line.match(/^\s+/);
					if (lineMatch && lineMatch[0])
					{
						numSpacesInTheBegginingOfLine = lineMatch[0].length;
					}
					htmlString += "<div style=\"margin-left:" + String(numSpacesInTheBegginingOfLine * 2) + "em;\">";
					htmlString += line;
					htmlString += "</div>";
				}
				
				htmlString += "</div>";
			}
			
			htmlString += createSignature();
			
			htmlString += "</div></body></html>";
			
			return htmlString;
		}
		
		private static function createSignature():String
		{
			return "<div>" + 
				"Game version: " + gameManager.getVersionString() + "<br/>" + 
				"Player version: " + Capabilities.version + "<br/>" + 
				"Player type: " + Capabilities.playerType + "<br/>" + 
				"Debug player: " + Capabilities.isDebugger.toString() + "<br/>" + 
				"OS: " + Capabilities.os + "<br/>" + 
				"Browser version: " + SystemInfo.getUserAgentString() + "<br/>" + 
				"CPU Architecture: " + Capabilities.cpuArchitecture + "<br/>" + 
				"ATF capability: " + SystemInfo.canUseAtfTextures.toString() + "<br/>" + 
				"Driver info: " + SystemInfo.getDriverInfo(gameManager.stage.stage3Ds[0]) + "<br/>" + 
				"UTC Date: " + getDateString(true) + "<br/>" + 
				'Player id: ' + (Player.current ? Player.current.playerId.toString() : '-') + "<br/>" + 
				"</div>";
		}
		
		private static function padWithZeroes(num:int, minLength:uint):String
		{
			var str:String = num.toString();
			while (str.length < minLength)
			{
				str = "0" + str;
			}
			return str;
		}
		
		public static function getDateString(insertYear:Boolean):String 
		{
			var logDate:Date = new Date();
			var UTCMonthLabels:Array = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"];
			return (insertYear ? (logDate.getUTCFullYear().toString() + "_") : '') + UTCMonthLabels[logDate.getUTCMonth()] + "-" + logDate.getUTCDate().toString() + "_" + padWithZeroes(logDate.getUTCHours(), 2) + "-" + padWithZeroes(logDate.getUTCMinutes(), 2) + "-" + padWithZeroes(logDate.getUTCSeconds(), 2);
		}
		
	
	}

}