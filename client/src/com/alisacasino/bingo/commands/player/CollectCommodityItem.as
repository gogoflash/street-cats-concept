package com.alisacasino.bingo.commands.player 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.controls.CoinsLootAnimation;
	import com.alisacasino.bingo.controls.EnergyLootAnimation;
	import com.alisacasino.bingo.controls.IResourceBar;
	import com.alisacasino.bingo.controls.KeysLootAnimation;
	import com.alisacasino.bingo.controls.LootAnimation;
	import com.alisacasino.bingo.controls.ResourceBar;
	import com.alisacasino.bingo.controls.TicketsLootAnimation;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.powerups.PowerupDropTable;
	import com.alisacasino.bingo.models.slots.SpinType;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.screens.IScreen;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CollectCommodityItem extends CommandBase
	{
		public var animationDuration:Number = 1.0;
		public var animationDelay:Number = 0;
		public var animationParent:DisplayObjectContainer;
		
		private var commodityItem:CommodityItem;
		private var animateFrom:Point;
		private var source:String;
		private var powerupDropTable:PowerupDropTable;
		
		public var doNotSendPlayerUpdate:Boolean;
		private var updateLobbyBars:Boolean;
		private var lobbyBarsUpdateDelay:Number = 0;
		public var powerupDropResult:Object;
		
		public function CollectCommodityItem(commodityItem:CommodityItem, source:String, powerupDropTable:PowerupDropTable = null, updateLobbyBars:Boolean = true, lobbyBarsUpdateDelay:Number = 0) 
		{
			this.powerupDropTable = powerupDropTable;
			this.source = source;
			this.commodityItem = commodityItem;
			this.updateLobbyBars = updateLobbyBars;
			this.lobbyBarsUpdateDelay = lobbyBarsUpdateDelay;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			//var targetBar:IResourceBar;
			//var currentScreen:IScreen = Game.current.currentScreen;
			var player:Player = Player.current;
			var resultCommodityQuantity:int;
			//var animationClass:Class;
			
			switch(commodityItem.type)
			{
				
				case CommodityType.CASH:
					//targetBar = currentScreen ? currentScreen.cashBar : null;
					player.updateCashCount(commodityItem.quantity, source);
					resultCommodityQuantity = player.cashCount;
					player.reservedCashCount += commodityItem.quantity; 
					//animationClass = CoinsLootAnimation;
					break;
				case CommodityType.SCORE:
					//targetBar = currentScreen ? currentScreen.scoreBar : null;
					resultCommodityQuantity = player.currentLiveEventScore += commodityItem.quantity;
					break;
				case CommodityType.POWERUP:
					powerupDropResult = gameManager.powerupModel.addPowerupsFromDrop(commodityItem.quantity, powerupDropTable, source);
					resultCommodityQuantity = gameManager.powerupModel.powerupsTotal;
					gameManager.powerupModel.reservedPowerupsCount += commodityItem.quantity;
					break;
				default:
					sosTrace("Could not find handler for commodity type " + commodityItem.type, SOSLog.ERROR);
					break;
			}
			
			if (!doNotSendPlayerUpdate)
			{
				Game.connectionManager.sendPlayerUpdateMessage();
			}
			
			//animate(targetBar, currentScreen, resultCommodityQuantity, animationClass);
			
			if (updateLobbyBars)
				new UpdateLobbyBarsTrueValue(lobbyBarsUpdateDelay).execute();
			
			Starling.current.juggler.delayCall(finish, animationDuration);
		}
		
		/*private function animate(targetBar:IResourceBar, currentScreen:IScreen, resultCommodityQuantity:int, animationClass:Class):void 
		{
			if (targetBar)
			{
				targetBar.animateToValue(resultCommodityQuantity, animationDuration + 0.2, animationDelay + 0.3);
				
				if (animateFrom && animationClass)
				{
					if (!animationParent)
					{
						animationParent = currentScreen as DisplayObjectContainer;
					}
					
					var screenSourceXY:Point = animationParent.globalToLocal(animateFrom);
					var targetRect:Rectangle = targetBar.getImageRect(animationParent);
					var animationParams:Object = { };
					animationParams["fromX"] = screenSourceXY.x;
					animationParams["fromY"] = screenSourceXY.y;
					animationParams["toX"] = targetRect.x + targetRect.width / 2;
					animationParams["toY"] = targetRect.y + targetRect.height / 2;
					animationParams["delay"] =  animationDelay;
					animationParams["duration"] = animationDuration;
					var animation:LootAnimation = new animationClass(animationParams);
					animationParent.addChild(animation);
				}
			}
		}*/
		
	}

}