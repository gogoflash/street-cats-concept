package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.chests.ChestPowerupPack;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.offers.OfferItem;
	import com.alisacasino.bingo.models.offers.OfferItemsPack;
	import com.alisacasino.bingo.models.powerups.PowerupModel;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.ModificatorMessage;
	import com.alisacasino.bingo.protocol.ModificatorType;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.store.items.CashStoreItem;
	import com.alisacasino.bingo.store.items.ChestStoreItem;
	import com.alisacasino.bingo.store.items.OfferStoreItem;
	import com.alisacasino.bingo.utils.StringUtils;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNARewardsHelper 
	{
		
		public function DDNARewardsHelper() 
		{
			
		}
		
		static public function createRewardProductsList(sourceItems:Array, powerupsObject:Object = null, collectionName:String = null):Object
		{
			var rewardProducts:Object = { };
			
			var items:Array = [];
			var virtualCurrencies:Array = [];
			for each (var item:* in sourceItems) 
			{
				if (item is CommodityItem)
				{
					addFromCommodityItem(items, virtualCurrencies, item);
				}
				if (item is CommodityItemMessage)
				{
					var cim:CommodityItemMessage = item as CommodityItemMessage;
					if (cim.type == Type.POWERUP)
					{
						items.push({item: {
							itemAmount: cim.quantity,
							itemName: PowerupModel.getPowerupByID(cim.powerupType),
							itemType: "powerup"
						}});
					}
					else if (cim.type == Type.CASH)
					{
						virtualCurrencies.push(createVirtualCurrencyEventObject(cim.type, cim.quantity));
					}
				}
				else if (item is CollectionItem) 
				{
					addCollectionItem(items, item as CollectionItem);
				}
				else if (item is ChestPowerupPack) 
				{
					fillItemsFromPowerupObject(items, (item as ChestPowerupPack).powerupData);
				}
				else if (item is CustomizerItemBase)
				{
					addСustomizerItem(items, item as CustomizerItemBase);
				}
				else if (item is CashStoreItem)
				{
					var csi:CashStoreItem = item as CashStoreItem;
					virtualCurrencies.push(createVirtualCurrencyEventObject(Type.CASH, csi.quantity));
				}
				else if (item is ChestStoreItem)
				{
					items.push({item: {
						itemAmount: 1,
						itemName: "PREMIUM",
						itemType: "chest"
					}});
				}
				else if (item is ModificatorMessage)
				{
					var mm:ModificatorMessage = item as ModificatorMessage;
					items.push( { item: {
						itemAmount: mm.quantity,
						itemName: StringUtils.substitute(getTemplateForBonus(mm), collectionName),
						itemType: "permanentBonus"
					}});
				}
				else if (item is OfferStoreItem)
				{
					addFromOfferStoreItem(items, virtualCurrencies, item as OfferStoreItem);
				}
			}
			
			if (powerupsObject)
			{
				fillItemsFromPowerupObject(items, powerupsObject);
			}
			
			
			if (items.length)
			{
				rewardProducts["items"] = items;
			}
			if (virtualCurrencies.length)
			{
				rewardProducts["virtualCurrencies"] = virtualCurrencies;
			}
			
			return rewardProducts;
		}
		
		static private function getTemplateForBonus(permanentEffect:ModificatorMessage):String
		{
			if (!permanentEffect)
				return "";
			
			switch(permanentEffect.type)
			{
				case ModificatorType.CASH_MOD:
					return "cashBonus.{0}"
					break;
				case ModificatorType.DISCOUNT_MOD:
					return "cardCost.{0}";
					break;
				case ModificatorType.EXP_MOD:
					return "xpBonus.{0}";
					break;
				case ModificatorType.SCORE_MOD:
					return "scoreBonus.{0}";
					break;
			}
			return "";
		}
		
		static public function fillItemsFromPowerupObject(items:Array, powerupData:Object):void 
		{
			for (var key:String in powerupData) 
			{
				items.push({item: {
					itemAmount: int(powerupData[key]),
					itemName: key,
					itemType: "powerup"
				}});
			}
		}
		
		static public function createVirtualCurrencyEventObject(type:int, quantity:uint):Object 
		{
			var typeString:String;
			switch(type)
			{
				case Type.CASH:
					typeString = "cash";
					break;
				case Type.DUST:
					typeString = "dust";
					break;
				default:
					typeString = "unknown";
					break;
			}
			return {virtualCurrency: {
				virtualCurrencyAmount: quantity,
				virtualCurrencyName: typeString,
				virtualCurrencyType: "GRIND"
			}};
		}
		
		static public  function createRealCurrencyEventObject(quantity:Number):Object 
		{
			return {
				realCurrencyAmount : quantity*100, //converting to cents per DDNA requirements
				realCurrencyType : "USD"
			};
		}
	
		private static function addFromOfferStoreItem(items:Array, virtualCurrencies:Array, offerStoreItem:OfferStoreItem):void 
		{
			if (!offerStoreItem || !offerStoreItem.data)
				return;
			
			var offerItemsPack:OfferItemsPack;
			var i:int;
			var j:int;
			var length:int;
			var itemPacks:Array = [];
			
			if (offerStoreItem.data is OfferItemsPack) 
			{
				itemPacks.push(offerStoreItem.data as OfferItemsPack);
			}
			if (offerStoreItem.data is OfferItem) 
			{
				itemPacks = itemPacks.concat((offerStoreItem.data as OfferItem).rewards);
			}
			
			for (i = 0; i < itemPacks.length; i++) 
			{
				offerItemsPack = itemPacks[i] as OfferItemsPack;
				length = offerItemsPack.items.length;
				for (j = 0; j < length; j++) {
					addFromCommodityItem(items, virtualCurrencies, offerItemsPack.items[j] as CommodityItem);
				}
			}
		}
		
		private static function addCollectionItem(items:Array, item:CollectionItem):void 
		{
			if (item) {
				items.push({item: {
					itemAmount: 1,
					itemName: item.name,
					itemType: "collectionItem"
				}});
			}
		}

		private static function addСustomizerItem(items:Array, item:CustomizerItemBase):void 
		{
			if (item) {
				items.push({item: {
					itemAmount: 1,
					itemName: item.name,
					itemType: item.getTypeStringID()
				}});
			}
		}
		
		private static function addFromCommodityItem(items:Array, virtualCurrencies:Array, item:CommodityItem):void 
		{
			if (!item)
				return;
				
			var length:int;
			var i:int;	
			var sourceArray:Array;
			
			switch(item.type)
			{
				case CommodityType.CASH: 
				{
					virtualCurrencies.push(createVirtualCurrencyEventObject(Type.CASH, item.quantity));
					break;
				}
				case CommodityType.POWERUP_CARD: 
				{
					if(item.data && item.data is Object)
						fillItemsFromPowerupObject(items, item.data as Object);
					
					break;
				}
				case CommodityType.POWERUP: 
				{
					items.push({item: {
						itemAmount: item.quantity,
						itemName: String(item.subType),
						itemType: "powerup"
					}});
					
					break;
				}
				case CommodityType.COLLECTION: 
				{
					if (!item.data || !(item.data is Array))
						break;
						
					sourceArray  = item.data as Array;
					length = sourceArray.length;
					for (i = 0; i < length; i++) {
						addCollectionItem(items, sourceArray[i] as CollectionItem);
					}
					
					break;
				}
				case CommodityType.CUSTOMIZER_SET: 
				case CommodityType.CUSTOMIZER: 
				{
					if (!item.data || !(item.data is Array))
						break;
						
					sourceArray = item.data as Array;
					length = sourceArray.length;
					for (i = 0; i < length; i++) {
						addСustomizerItem(items, sourceArray[i] as CustomizerItemBase);
					}
					
					break;
				}
				case CommodityType.SCORE: 
				{
					
					break;
				}
				
				case CommodityType.CHEST: 
				{
					items.push({item: {
						itemAmount: 1,
						itemName: String(item.subType),
						itemType: "chest"
					}});
					break;
				}
				case CommodityType.DUST: 
				{
					virtualCurrencies.push(createVirtualCurrencyEventObject(Type.DUST, item.quantity));
					break;
				}	
				default: 
				{
					sosTrace("CollectCommodityItems: could not find handler for commodity type " + item.type, SOSLog.ERROR);
					break;
				}
			}	
				
		}
		
	}

}