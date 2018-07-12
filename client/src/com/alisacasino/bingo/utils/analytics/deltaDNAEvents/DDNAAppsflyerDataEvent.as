package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAAppsflyerDataEvent extends DDNAEvent
	{
		public var valid:Boolean;
		private var sourceObject:Object;
		
		public function DDNAAppsflyerDataEvent(data:String) 
		{
			super(["userXP", "userLevel"]);
			addEventType("appsFlyerAttribution");
			
			sourceObject = JSON.parse(data);
			
			if (sourceObject["af_status"])
			{
				parseAsAppsflyer();
			}
			else if (sourceObject["fb_source"])
			{
				parseAsFB();
			}
			else
			{
				parseGeneric();
			}
		}
		
		private function parseGeneric():void 
		{
			if (sourceObject["c"])
			{
				addParamsField("afAttrStatus", "NON-ORGANIC");
				addParamsField("acquisitionChannel", sourceObject["c"]);
				valid = true;
			}
			else if (sourceObject["offer_ref"])
			{
				addParamsField("afAttrStatus", "ORGANIC");
				addParamsField("acquisitionChannel", "Facebook");
				addParamsField("afAttrMediaSource", "freebie");
				addParamsField("afAttrMessage", sourceObject["offer_ref"]);
				valid = true;
			}
			else
			{
				valid = false;
			}
		}
		
		private function parseAsFB():void 
		{
			addParamsField("afAttrStatus", "ORGANIC");
			addParamsField("acquisitionChannel", "Facebook");
			addParamsField("afAttrMediaSource", sourceObject["af_channel"]);
			
			addFieldIfExists("ref", "afAttrMessage");
			addFieldIfExists("app_request_type", "afAttrSub1");
			
			valid = true;
		}

		
		private function parseAsAppsflyer():void 
		{
			if (sourceObject["af_status"] == "Organic")
			{
				addParamsField("acquisitionChannel", "Organic");
			}
			else if (sourceObject["af_channel"] != null)
			{
				addParamsField("acquisitionChannel", sourceObject["af_channel"]);
			}
			else if(sourceObject["campaign"] != null)
			{
				addParamsField("acquisitionChannel", sourceObject["campaign"]);
			}
			else
			{
				valid = false;
				return;
			}
			
			addFieldIfExists("adgroup", "afAttrAdgroupName");
			addFieldIfExists("adgroup_id", "afAttrAdgroupID");
			addFieldIfExists("ad_id", "afAttrAdID");
			addFieldIfExists("adset", "afAttrAdsetName");
			addFieldIfExists("adset_id", "afAttrAdsetID");
			addFieldIfExists("agency", "afAttrAgency");
			
			addFieldIfExists("af_message", "afAttrMessage");
			addFieldIfExists("af_siteid", "afAttrSiteID");
			
			if (sourceObject["af_status"] != null)
			{
				addParamsField("afAttrStatus", String(sourceObject["af_status"]).toUpperCase());
			}
			
			addFieldIfExists("af_sub1", "afAttrSub1");
			addFieldIfExists("af_sub2", "afAttrSub2");
			addFieldIfExists("af_sub3", "afAttrSub3");
			addFieldIfExists("af_sub4", "afAttrSub4");
			addFieldIfExists("af_sub5", "afAttrSub5");
			addFieldIfExists("af_tranid", "afAttrClickID");
			addFieldIfExists("campaign", "afAttrCampaign");
			addFieldIfExists("campaign_id", "afAttrCampaignID");
			addFieldIfExists("click_time", "afAttrClickTime");
			
			if (sourceObject["cost_cents_USD"])
			{
				addParamsField("afAttrCostCurrency", "USD");
				addParamsField("afAttrCostValue", int(sourceObject["cost_cents_USD"]));
				addParamsField("acquisitionCost", int(sourceObject["cost_cents_USD"]));
			}
			
			addFieldIfExists("install_time", "afAttrInstallTime");
			
			if (sourceObject["is_fb"] != null)
			{
				addParamsField("afAttrIsFacebook", Boolean(sourceObject["is_fb"]));
			}
			
			addFieldIfExists("media_source", "afAttrMediaSource");
			
			valid = true;
		}
		
		private function addFieldIfExists(fieldSource:String, fieldDestination:String):void
		{
			if (sourceObject[fieldSource] != null) //writing only non-null fields
			{
				addParamsField(fieldDestination, sourceObject[fieldSource]);
			}
		}
		
	}

}