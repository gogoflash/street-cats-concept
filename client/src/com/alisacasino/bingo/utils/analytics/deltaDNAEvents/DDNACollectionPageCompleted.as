package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.collections.CollectionPage;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.Type;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNACollectionPageCompleted extends DDNAEvent
	{
		
		public function DDNACollectionPageCompleted(collectionPage:CollectionPage, powerupDropResult:Object) 
		{
			addEventType("collectionPageCompleted");
			addParamsField("collectionPageNum", collectionPage.index);
			addParamsField("collectionName", collectionPage.collection.name);
			addParamsField("reward", createRewardObject("collectionPageReward", filterPowerups(collectionPage.prizes).concat(collectionPage.permanentEffects), powerupDropResult, collectionPage.name));
		}
		
		private function filterPowerups(prizes:Array):Array 
		{
			var result:Array = [];
			for each (var item:CommodityItemMessage in prizes) 
			{
				if (item.type == Type.POWERUP)
					continue;
				result.push(item);
			}
			return result;
		}
		
	}

}