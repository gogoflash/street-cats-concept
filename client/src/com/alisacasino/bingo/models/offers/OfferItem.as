package com.alisacasino.bingo.models.offers 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.commands.player.CollectCommodities;
	import com.alisacasino.bingo.commands.player.CollectCommodityItems;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.dialogs.CommodityTakeOutDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.ValueDataTable;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.store.items.OfferStoreItem;
	import com.alisacasino.bingo.utils.StringUtils;
	import flash.geom.Rectangle;
	import starling.events.EventDispatcher;
	
	public class OfferItem extends EventDispatcher
	{
		public static var EVENT_PACK_PURCHASED_CHANGE:String = 'EVENT_PACK_PURCHASED_CHANGE';
		
		public function OfferItem() 
		{
			_rewards = [];
		}
		
		public var id:String;
		
		public var title:String;
		
		public var titleAlternative:String;
		
		public var type:String;
		
		public var order:int;
		
		public var image:String;
		
		public var animation:String;
		
		public var customIcon:String;
		
		
		public var start:uint;
		
		public var finish:uint;
		
		public var duration:uint;
		
		public var cooldown:int;
		
		public var lastOfferTimeout:int;
		
		public var cooldownOnPurchase:int;
		
		
		public var oldPrice:Number = 0;
		
		private var _salePercents:Number = 0;
		
		
		public var purchaseMaxCount:int;
		
		public var showsAmount:uint;
		
		public var showTimer:Boolean;
		
		public var instantShowDialog:Boolean;
		
		public var presentationMode:uint;
		
		public var showTotalDialog:Boolean;
		
		
		
		private var _storeItem:OfferStoreItem;
		
		private var _rewards:Array;
		
		private var _cashIconTypeTable:ValueDataTable;
		
		private var _badgeTypeTable:ValueDataTable;
		
		private var _purchaseTouchRect:Rectangle;
		
		/********************************************************************************************************************************
		* 
		* triggers
		* 
		********************************************************************************************************************************/
		
		public var minLevel:int;
		
		public var maxLevel:int;
		
		public var minLtv:int;
		
		public var maxLtv:int;
		
		public var minCash:int;
		
		public var maxCash:int;
		
		public var lastPayment:int;
		
		public var lastVisit:int;
		
		public var userIds:Array;
		
		public var roundLossCount:int;
	
		/********************************************************************************************************************************
		* 
		* 
		* 
		********************************************************************************************************************************/
		
		public var dialogShowed:Boolean;
		private var _imageAsset:ImageAsset;
		private var _animationAsset:MovieClipAsset;
		private var _iconImageAsset:ImageAsset;
		
		private var callback_completeLoadResourses:Function;
		private var completeLoadResoursesParams:Array;
		
		public var enabled:Boolean;
		public var isDebug:Boolean;
		
		public function parse(data:Object):void
		{
			if(!data)
				return;
			
			enabled = data['enabled'];
			id = data['id'];
			type = data['type'];
			title = data['title'] || '';
			titleAlternative = data['titleAlternative'] || '';
			image = data['image'];
			animation = data['animation'];
			customIcon = 'customIcon' in data ? data['customIcon'] : null;
			start = data['start'];
			finish = replaceUint(data['finish'], 0, uint.MAX_VALUE);
			order = data['order'];	
			duration = replaceInt(data['duration'], 0, int.MAX_VALUE);
			lastOfferTimeout = data['lastOfferTimeout'];
			cooldown = int(data['cooldown']);
			cooldownOnPurchase = int(data['cooldownOnPurchase']); 
			showTimer = data['showTimer'];
			showTotalDialog = data['showTotalDialog'];
			userIds = parseToArray(data['userIds']);
			
			purchaseMaxCount = data['purchaseMaxCount'];
			showsAmount = data['showsAmount'];
			
			presentationMode = data['presentationMode'];
			//presentationMode = OfferPresentationMode.BADGE_LOBBY | OfferPresentationMode.BADGE_STORE_BTN;
			
			oldPrice = 'oldPrice' in data ? Math.max(0, parseFloat(data['oldPrice'])) : 0;
			_salePercents = 'salePercents' in data ? Math.max(0, int(data['salePercents'])) : 0;	
			
			_cashIconTypeTable = CashIconType.parseFromString(data['cashIconTable']);
			_badgeTypeTable = OfferBadgeType.parseFromString(data['badgeColorTable']);
			
			minLevel = data['minLevel'];
			maxLevel = replaceInt(data['maxLevel'], 0, int.MAX_VALUE);
				
			minLtv = data['minLtv'];
			maxLtv = replaceInt(data['maxLtv'], 0, int.MAX_VALUE);
				
			minCash = data['minCash'];
			maxCash = replaceInt(data['maxCash'], 0, int.MAX_VALUE);
			
			lastPayment	= data['lastPayment'];
			lastVisit = data['lastVisit'];
			
			roundLossCount = data['roundLossCount'];
			
			if(duration <= 0)
				duration = finish - start;
			else
				duration = Math.min(duration, finish - start);
			
			_storeItem = new OfferStoreItem();
			_storeItem.parse(data);
			_storeItem.data = this;
			
			if ('touchRect' in data && data['touchRect'] != '') {
				var touchRectRaw:Array = String(data['touchRect']).split(',');
				if(touchRectRaw.length > 3)
					_purchaseTouchRect = new Rectangle(parseInt(touchRectRaw[0])*pxScale, parseInt(touchRectRaw[1])*pxScale, parseInt(touchRectRaw[2])*pxScale, parseInt(touchRectRaw[3])*pxScale);
			}
			
			parseRewards('rewards' in data ? data['rewards'] : null);
		}
		
		public function parseRewards(raw:Object):OfferItem 
		{
			if(!raw)
				return this;
				
			_rewards = [];	
			
			var itemPackRaw:Object;
			var itemPack:OfferItemsPack;
			for each(itemPackRaw in raw)
			{
				itemPack = new OfferItemsPack();
				itemPack.parse(itemPackRaw);
				itemPack.offerItem = this;
				
				_rewards.push(itemPack);
			}	
			
			return this;
		}
		
		/*public function refreshItemsPackPurchaseProgresses():void
		{
			var itemsPack:OfferItemsPack;
			for each(itemsPack in _rewards) 
			{
				if(itemsPack.offerItem)
					itemsPack.setPurchaseProgressQuiet(gameManager.offerManager.getFromClientData(itemsPack.offerItem.id, itemsPack.storeItem.itemId, false).);
			}
		}*/
		
		public function get rewards():Array
		{
			return _rewards;
		}
		
		public function get salePercents():Number
		{
			return _salePercents;
		}
		
		public function get combinedSalePercents():Number
		{
			var itemsPack:OfferItemsPack;
			var maxPackPercent:Number = 0;
			for each(itemsPack in _rewards) 
			{
				if (itemsPack.percent > 0) 
				{
					if(itemsPack.storeItem && !gameManager.offerManager.getFromClientData(itemsPack.offerItem.id, itemsPack.storeItem.itemId, false))
						maxPackPercent = Math.max(itemsPack.percent, maxPackPercent);
				}
			}
			
			if (maxPackPercent > 0)
				return maxPackPercent;
				
			return _salePercents;
		}
		
		public function get storeItem():OfferStoreItem
		{
			return _storeItem;
		}
		
		public function get imageAsset():ImageAsset 
		{
			if (!_imageAsset && image && image != '') {
				_imageAsset = new ImageAsset(image);
			}
			
			return _imageAsset;
		}
		
		public function get animationAsset():MovieClipAsset
		{
			if (!_animationAsset && animation && animation != '' && animation != 'none') {
				_animationAsset = new MovieClipAsset(animation);
			}
			
			return _animationAsset;
		}
		
		public static function get atlasAsset():AtlasAsset
		{
			return AtlasAsset.ScratchCardAtlas;
		}
		
		public function get iconImageAsset():ImageAsset 
		{
			if (!_iconImageAsset && customIcon != null && customIcon != '') {
				_iconImageAsset = new ImageAsset(customIcon);
			}
			
			return _iconImageAsset;
		}
		
		public function get isResoursesLoaded():Boolean
		{
			if (!atlasAsset.loaded) 
				return false;
			
			if (imageAsset && !imageAsset.loaded)	
				return false;
				
			if (animationAsset && !animationAsset.loaded)	
				return false;	
				
			return true;	
		}
		
		public function loadResources(onComplete:Function, ...params):void
		{
			callback_completeLoadResourses = onComplete;
			completeLoadResoursesParams = params;
			
			if (!atlasAsset.loaded) 
				atlasAsset.load(completeLoadResourses, loadResoursesError);
			
			if (imageAsset && !imageAsset.loaded)	
				imageAsset.load(completeLoadResourses, loadResoursesError);
				
			if (animationAsset && !animationAsset.loaded)	
				animationAsset.load(completeLoadResourses, loadResoursesError);
		}
		
		private function completeLoadResourses():void 
		{
			if (!isResoursesLoaded)
				return;
			
			if (callback_completeLoadResourses != null) {
				callback_completeLoadResourses.apply(null, completeLoadResoursesParams);
			}
		}
		
		private function loadResoursesError():void 
		{
			if (callback_completeLoadResourses != null) {
				callback_completeLoadResourses.apply(null, completeLoadResoursesParams);
			}
		}
		
		public function rewardsString(delimeter:String = ' '):String 
		{
			var string:String = '';
			var itemsPack:Array;
			var item:CommodityItem;
			
			for each(itemsPack in _rewards) 
			{
				for each(item in itemsPack)
				{
					string += item.type + " " + (item.subType || '') + " " + item.quantity + delimeter;
				}
				
				string += '\n';
			}
			
			return string;
		}
		
		public function getCommoditiesRewards(storeItemId:String = null):Array
		{
			var commoditiesList:Array = [];
			var itemsPack:OfferItemsPack;
			var item:CommodityItem;
			
			for each(itemsPack in _rewards) 
			{
				if (itemsPack.storeItem && storeItemId != null && storeItemId != '' && storeItemId != itemsPack.storeItem.itemId)
					continue;
					
				for each(item in itemsPack.items) {
					commoditiesList.push(item);
				}
			}
			
			return commoditiesList;
		}
	
		public function get cashIconTypeTable():ValueDataTable 
		{
			if (!_cashIconTypeTable) {
				_cashIconTypeTable = CashIconType.defaultTable;
			}
			
			return _cashIconTypeTable;
		}
		
		public function get badgeTypeTable():ValueDataTable 
		{
			if (!_badgeTypeTable) {
				_badgeTypeTable = OfferBadgeType.defaultTable;
			}
			
			return _badgeTypeTable;
		}
		
		public function get purchaseTouchRect():Rectangle
		{
			return _purchaseTouchRect;
		}
		
		private function parseToArray(value:String):Array {
			if (!value)
				return null;
			
			return value.split(',');	
		}
		
		private function replaceInt(value:int, replaceValueCondition:int, replaceValue:int):int {
			return value == replaceValueCondition ? replaceValue : value; 
		}
		
		private function replaceUint(value:uint, replaceValueCondition:uint, replaceValue:uint):uint {
			return value == replaceValueCondition ? replaceValue : value; 
		}
		
		public function toString():String 
		{
			var string:String = id + ' , ' + type + ' , ' + title + '\n';
			string += ', order: ' + order;
			string += ', start: ' + StringUtils.formatTime(start, "{1}:{2}:{3}", false, true, true);
			string += ', finish: ' + StringUtils.formatTime(finish, "{1}:{2}:{3}", false, true, true);
			string += ', duration: ' + StringUtils.formatTime(duration, "{1}:{2}:{3}", false, true, true);
			string += ', cooldown: ' + StringUtils.formatTime(cooldown, "{1}:{2}:{3}", false, true, true) + '\n';
			string += ', lastOfferTimeout: ' + StringUtils.formatTime(lastOfferTimeout, "{1}:{2}:{3}", false, true, true);
			string += ', cooldownOnPurchase: ' + StringUtils.formatTime(cooldownOnPurchase, "{1}:{2}:{3}", false, true, true) + '\n';
			string += ', image: ' + image;
			string += ', animation: ' + animation + '\n';
			string += ', oldPrice: ' + oldPrice ;
			string += ', salePercents: ' + salePercents + '\n';
			string += ', purchaseMaxCount: ' + purchaseMaxCount;
			string += ', showsAmount: ' + showsAmount;
			string += ', showTimer: ' + showTimer;
			string += ', showTotalDialog: ' + showTotalDialog + '\n';
			string += ', price: ' + _storeItem.price.price.toString();
			string += ', isFree: ' + _storeItem.price.isFree.toString();
			string += ', storeItemId: ' + _storeItem.itemId + '\n';
			string += ', minLevel: ' + minLevel;
			string += ', maxLevel: ' + maxLevel;
			string += ', minLtv: ' + minLtv;
			string += ', maxLtv: ' + maxLtv;
			string += ', minCash: ' + minCash;
			string += ', maxCash: ' + maxCash + '\n';
			string += ', lastPayment: ' + lastPayment;
			string += ', lastVisit: ' + lastVisit;
			string += ', userIds: ' + userIds;
			string += ', roundLossCount: ' + roundLossCount;
			
			return string;
		}
	}

}

		
		
	