package com.alisacasino.bingo.utils
{
	import adobe.utils.CustomActions;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.gifts.GiftsModel;
	import com.alisacasino.bingo.models.gifts.IncomingGiftData;
	import de.polygonal.math.PM_PRNG;
	import flash.utils.getTimer;
	
	public class GiftGenerationStrategy
	{
		public static function setGifts(newGiftRequests:Vector.<IncomingGiftData>, allGiftRequests:Vector.<IncomingGiftData>, giftsCashTable:Vector.<int>, tableStartIndex:int = 0):void
		{
			var totalGiftRequestsLength:int = allGiftRequests.length;
			var giftRequestsLength:int = newGiftRequests.length;
			
			if (totalGiftRequestsLength == 0 || giftRequestsLength == 0)
				return;
			
			if (!giftsCashTable)	
				giftsCashTable = new Vector.<int>();
				
			var i:int;
			var index:int;
			var length:int = newGiftRequests.length;
			var incomingGiftData:IncomingGiftData;
			
			for (i = 0; i < length; i++) 
			{
				index = tableStartIndex + allGiftRequests.length - newGiftRequests.length + i;
				newGiftRequests[i].cashBonus = index < giftsCashTable.length ? giftsCashTable[index] : 1;
			}
			
			//var cashGifts:Vector.<int> = new <int>[];
			//var installedFriendsCount:int = FacebookData.instance.bingoInstalledFriends ? FacebookData.instance.bingoInstalledFriends.length : 0;
		}
		
		public static function generateInboxGiftsCashTable(seed:int, totalCount:int, startSpreadingIndex:int = 4):Vector.<int> 
		{
			var table:Vector.<int> = new <int>[];
			
			var maxCashValue:int = getInboxCashByUsersCount(totalCount);
			
			startSpreadingIndex = Math.min(totalCount-1, startSpreadingIndex);
			
			var i:int;
			var cashValue:Number = 0;
			var newCashValue:Number = 0;
			var totalCash:Number = 0;
			var currentCash:int;
			for (i = 1; i <= totalCount; i++) 
			{
				newCashValue = getInboxCashByUsersCount(i);
				
				if (i < totalCount / 3)
				{
					currentCash = Math.ceil(newCashValue - cashValue);
				}
				else if(i < totalCount/2)
				{
					currentCash = Math.round(newCashValue - cashValue);
				}
				else if(i < totalCount)
				{
					currentCash = Math.floor(newCashValue - cashValue);
				}
				else {
					currentCash = Math.max(1, maxCashValue - totalCash);
				}
				
				table.push(currentCash);
				totalCash += currentCash;
				
				cashValue = newCashValue;
			}
			
			table.sort(function(a:int, b:int):int { 
				return b - a; 
			});
			
			var spreadingArray:Array = [];
			while (startSpreadingIndex < table.length) {
				spreadingArray.push(table.splice(startSpreadingIndex, 1)[0]);
			}
			
			var randomizer:PM_PRNG = new PM_PRNG();
			randomizer.seed = seed;
			
			do {
				i = Math.floor(spreadingArray.length * randomizer.nextDouble());
				table.push(spreadingArray.splice(i, 1)[0]);
			} while (spreadingArray.length > 0);
			
			return table;
		}
		
		private static function getInboxCashByUsersCount(count:int):Number {
			return Math.round(Math.pow(10.1 * (count - 1), 3 / 4) + 10);
		}
		
		public static function debugTestGenerateGiftsCashTable():void
		{
			var j:int = getTimer();
			for (var i:int = 1; i < 10; i++ ) 
			{
				var r:int = Math.max(1, Math.random() * int.MAX_VALUE);
				var a:Vector.<int> = GiftGenerationStrategy.generateInboxGiftsCashTable(r, 80, 8);
				//trace(GiftGenerationStrategy.generateGiftsCashTable(r, 80, 5));
				//trace(GiftGenerationStrategy.generateGiftsCashTable(r, 80, 6));
				trace(a);
				
				/*j = 0;
				do {j += a.shift()} while (a.length > 0);
				trace(j);*/
				
				trace('');
			}
			
			trace((getTimer() - j)/1000);
		}
		
		/*public static function generateGift(giftIndex:uint):Object
		{
			var player:Player = Player.current;
			
			var retVal:Object = {ticketsWon: 0, coinsWon: 0, energyWon: 0, keysWon: 0, spinsWon: 0}
			
			
			
			if (giftIndex == 0 && player.cashCount < 50)
			{
				retVal.coinsWon = 100 - player.cashCount;
			}
			else if (giftIndex == 1 && Math.random() > 0.9)
			{
				retVal.spinsWon = 1;
			}
			else
			{
				var rnd:Number = Math.random();
				if (rnd < 0.4)
				{
					if (giftIndex > 30)
					{
						retVal.ticketsWon = 1;
					}
					else if (player.ticketsAntiAccumulationPolicyEnabled || giftIndex > 2)
					{
						retVal.ticketsWon = 1;
					}
					else
					{
						if (rnd > 0.38)
						{
							retVal.ticketsWon = int(Math.random() * 20) + 5;
						}
						else
						{
							retVal.ticketsWon = int(Math.random() * 4) + 1;
						}
					}
				}
				else if (rnd < 0.91)
				{
					if (giftIndex > 30)
					{
						retVal.coinsWon = 1 + int(Math.random()*2);
					}
					else if (player.coinsAntiAccumulationPolicyEnabled || giftIndex > 2)
					{
						retVal.coinsWon = int(Math.random() * 3) + 3;
					}
					else
					{
						retVal.coinsWon = Math.random() * 5 + 5;
					}
				}
				else if (rnd < 0.96)
				{
					if (giftIndex > 30)
					{
						retVal.energyWon = 1;
					}
					else if (player.coinsAntiAccumulationPolicyEnabled || giftIndex > 2)
					{
						retVal.energyWon = 1;
					}
					else
					{
						if (rnd > 0.955)
						{
							retVal.energyWon = int(Math.random() * 5) + 1;
						}
						else
						{
							retVal.energyWon = int(Math.random() * 2) + 1;
						}
					}
				}
				else
				{
					if (giftIndex > 30)
					{
						retVal.keysWon = 1;
					}
					else if (player.coinsAntiAccumulationPolicyEnabled || giftIndex > 2)
					{
						retVal.keysWon = 1;
					}
					else
					{
						if (rnd > 0.99)
						{
							retVal.keysWon = int(Math.random() * 10) + 1;
						}
						else
						{
							retVal.keysWon = int(Math.random() * 2) + 1;
						}
					}
				}
			}
			return retVal;
		}*/
	}
}
