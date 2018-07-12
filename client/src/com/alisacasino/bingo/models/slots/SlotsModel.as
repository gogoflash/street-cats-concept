package com.alisacasino.bingo.models.slots 
{
	import air.update.states.HSM;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.commands.player.CollectCommodities;
	import com.alisacasino.bingo.commands.player.CollectCommodityItems;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.slots.SlotMachineRewardView;
	import com.alisacasino.bingo.dialogs.slots.SlotsDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.TutorialManager;
	import com.alisacasino.bingo.models.chests.WeightedList;
	import com.alisacasino.bingo.models.powerups.Minigame;
	import com.alisacasino.bingo.models.powerups.Minigame;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.GenericDropDataMessage;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	import com.alisacasino.bingo.protocol.PowerupType;
	import com.alisacasino.bingo.protocol.SlotMachineStatic;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.utils.GAFUtils;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNASlotSpinEvent;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	
	public class SlotsModel extends EventDispatcher 
	{
		public static const SOURCE_ID:String = 'slotMachine';
		
		public var debugDisableFreeSpins:Boolean;
		
		private var imageAsset:ImageAsset;
		
		private var _animationAsset:MovieClipAsset;
		
		private var atlasAsset:AtlasAsset;
		
		private var callback_completeLoadResourses:Function;
		private var completeLoadResoursesParams:Array;
		
		private var loadResourcesCalled:Boolean;
		
		private var _reelRewardsList:Vector.<SlotMachineReward>;
		
		private var commodityItemsByRewardType:Object;
			
		private var rewardsChanceTableBySpinType:Object;
		
		private var freeSpinsCountByStake:Object;
		private var rewardCountByType:Object;
		
		public var betList:Array;
		
		public var cashPayoutsData:Array;
		
		public var itemsPayoutsData:Array;
		
		public var bonusSpinsAccount:Vector.<Minigame>;
		
		public var freeSpinsMinMax:String;
		
		private var _freeSpins:int;
		
		public function SlotsModel() 
		{
			super();
			
			reset();
			
			//debugFillModel();
		}
			
		public function get animationAsset():MovieClipAsset
		{
			if (!_animationAsset)
				_animationAsset = new MovieClipAsset(layoutHelper.isBigAssetMode ? 'heaven_hell_slot' : 'heaven_hell_slot_480');
			return _animationAsset;
		}
		
		public function getCommodityItemByTypeAndStake(type:String, stake:int):CommodityItem 
		{
			var rewardCount:int = type in rewardCountByType ? rewardCountByType[type] : 1;
			if (stake <= 0)
				stake = 1;
				
			switch(type) 
			{
				case SlotMachineRewardType.FREE_SPINS: return CommodityItem.create(CommodityType.SLOT_FREE_SPINS, null, stake in freeSpinsCountByStake ? freeSpinsCountByStake[stake] : 1);
				case SlotMachineRewardType.SUPER_CHEST: return CommodityItem.create(CommodityType.CHEST, ChestType.SUPER.toString(), rewardCount);
				case SlotMachineRewardType.GOLD_CHEST: return CommodityItem.create(CommodityType.CHEST, ChestType.GOLD.toString(), rewardCount);
				case SlotMachineRewardType.INSTABINGO: return CommodityItem.create(CommodityType.POWERUP, Powerup.INSTABINGO, rewardCount);
				case SlotMachineRewardType.THREE_DAUBS: return CommodityItem.create(CommodityType.POWERUP, Powerup.TRIPLE_DAUB, rewardCount);
				case SlotMachineRewardType.DUST: return CommodityItem.create(CommodityType.DUST, null, rewardCount);
				case SlotMachineRewardType.VAULTS: return CommodityItem.create(CommodityType.CASH, null, rewardCount * stake);
				case SlotMachineRewardType.SACKS: return CommodityItem.create(CommodityType.CASH, null, rewardCount * stake);
				case SlotMachineRewardType.CASES: return CommodityItem.create(CommodityType.CASH, null, rewardCount * stake);
				case SlotMachineRewardType.PACKS: return CommodityItem.create(CommodityType.CASH, null, rewardCount * stake);
				case SlotMachineRewardType.CASH_2: return CommodityItem.create(CommodityType.CASH, null, rewardCount * stake);
				case SlotMachineRewardType.CASH_1: return CommodityItem.create(CommodityType.CASH, null, rewardCount * stake);
				case SlotMachineRewardType.NO_WIN: return null;
			}
			
			return null;
		}
		
		public function deserializeStaticData(staticData:StaticDataMessage):void
		{
			reset();
			
			var freeSpinsMin:int;
			var freeSpinsMax:int;
			var genericDropData:Array = staticData.genericDropData;
			for each (var genericDropDataMessage:GenericDropDataMessage in genericDropData) 
			{
				if (genericDropDataMessage.type == "freeSpinsByBet") 
				{
					freeSpinsCountByStake[parseInt(genericDropDataMessage.entry)] = genericDropDataMessage.weight;
					
					if (freeSpinsMin == 0 && freeSpinsMax == 0) {
						freeSpinsMin = genericDropDataMessage.weight;
						freeSpinsMax = genericDropDataMessage.weight;
					}
					else {
						freeSpinsMin = Math.min(genericDropDataMessage.weight, freeSpinsMin);
						freeSpinsMax = Math.max(genericDropDataMessage.weight, freeSpinsMax);
					}
				}
				else if (genericDropDataMessage.type == "slotsWinningsQuantities") {
					rewardCountByType[genericDropDataMessage.entry] = genericDropDataMessage.weight;
				}
			}
			
			freeSpinsMinMax = freeSpinsMin == freeSpinsMax ? freeSpinsMin.toString() : (freeSpinsMin.toString() + '-' + freeSpinsMax.toString());
			
			var slotDataList:Array = 'slotMachineStatic' in staticData ? staticData['slotMachineStatic'] : [];
			var slotsRewardsChanceTable:SlotMachineChanceTable;
			var slotReward:SlotMachineReward;
			var slotsRewardsByStakeList:Object;
			var betCacheList:Object = {};
			for each (var item:SlotMachineStatic in slotDataList) 
			{
				if (item.type in rewardsChanceTableBySpinType) {
					slotsRewardsByStakeList = rewardsChanceTableBySpinType[item.type];
				}
				else {
					slotsRewardsByStakeList = {}
					rewardsChanceTableBySpinType[item.type] = slotsRewardsByStakeList;
				}
				
				if (item.stake in slotsRewardsByStakeList) {
					slotsRewardsChanceTable = slotsRewardsByStakeList[item.stake] as SlotMachineChanceTable;
				}
				else {
					slotsRewardsChanceTable = new SlotMachineChanceTable();
					slotsRewardsChanceTable.stake = item.stake;
					slotsRewardsChanceTable.spinType = item.type;
					slotsRewardsByStakeList[item.stake] = slotsRewardsChanceTable;
					
					if (!(item.stake in betCacheList)) {
						betCacheList[item.stake] = true;
						betList.push(slotsRewardsChanceTable.stake);
					}
				}
				
				slotReward = new SlotMachineReward();
				slotReward.parse(item);
				
				if (item.winningCombo in commodityItemsByRewardType) 
				{
					//slotReward.commodityItem = commodityItemsByRewardType[slotReward.rewardType];
				}
				else 
				{
					commodityItemsByRewardType[slotReward.rewardType] = true//SlotMachineRewardType.getCommodityItemByType(slotReward.rewardType);
					//slotReward.commodityItem = commodityItemsByRewardType[slotReward.rewardType];
					
					if(slotReward.placeOnReel)
						_reelRewardsList.push(slotReward);
						
					if (slotReward.isCashReward)	
						cashPayoutsData.push([slotReward, slotReward.rewardType in rewardCountByType ? rewardCountByType[slotReward.rewardType] : 1]);
					else if(slotReward.rewardType != SlotMachineRewardType.NO_WIN)
						itemsPayoutsData.push([slotReward, slotReward.commodityItem.quantity]);
				}
				
				slotsRewardsChanceTable.weightedList.addWeightedItem(slotReward, slotReward.weight);
			}
			
			
			betList.sort(Array.NUMERIC);
			
			cashPayoutsData.sort(sortCashPayouts);
			
			/*var cashPayoutsData:Array = 
			[
				[CommodityItem.create(CommodityType.CASH, null, 350), 250],
				[CommodityItem.create(CommodityType.CASH, null, 250), 100],
				[CommodityItem.create(CommodityType.CASH, null, 70), 25],
				[CommodityItem.create(CommodityType.CASH, null, 40), 5],
				[CommodityItem.create(CommodityType.CASH, null, 1), 2],
				[CommodityItem.create(CommodityType.CASH, null, 0), 1]
			];
			
			var itemsPayoutsData:Array = 
			[
				[CommodityItem.create(CommodityType.SLOT_FREE_SPINS, null, 1), 10],
				[CommodityItem.create(CommodityType.CHEST, ChestType.SUPER.toString(), 250), 1],
				[CommodityItem.create(CommodityType.CHEST, ChestType.GOLD.toString(), 70), 1],
				[CommodityItem.create(CommodityType.POWERUP, Powerup.INSTABINGO, 40), 5],
				[CommodityItem.create(CommodityType.POWERUP, Powerup.TRIPLE_DAUB, 1), 3],
				[CommodityItem.create(CommodityType.DUST, null, 1), 20]
			];*/
			
		}
		
		public function set freeSpins(value:int):void {
			if (value == _freeSpins)
				return;
			
			_freeSpins = value;
			// store on user data
		}
		
		public function get freeSpins():int {
			return _freeSpins;
		}
		
		private function reset():void 
		{
			bonusSpinsAccount = new Vector.<Minigame>();
			
			rewardsChanceTableBySpinType = {};
			betList = [];
			commodityItemsByRewardType = {};
			freeSpinsCountByStake = {};
			rewardCountByType = {};
			_reelRewardsList = new <SlotMachineReward>[];
			cashPayoutsData = [];
			itemsPayoutsData = [];
		}

		public function showDialog():void
		{
			if (!isResoursesLoaded) {
				LoadingWheel.show();
				loadResources(commitShowDialog);
				return;
			}
			
			commitShowDialog();
		}
		
		public function commitLoadResources():void
		{
			if (loadResourcesCalled)
				return;
				
			loadResourcesCalled = true;
			loadResources(null);
		}
		
		private function commitShowDialog():void
		{
			if (!isResoursesLoaded)
				return;
			
			LoadingWheel.removeIfAny();
			
			SlotsAnimationState.prepareCustomLayers(animationAsset);
				
			DialogsManager.addDialog(new SlotsDialog());
		}	
		
		public function get isResoursesLoaded():Boolean
		{
			if (atlasAsset && !atlasAsset.loaded) 
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
			
			if (atlasAsset && !atlasAsset.loaded) 
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
			
			//injectContainersToAnimations();
				
			if (callback_completeLoadResourses != null) {
				callback_completeLoadResourses.apply(null, completeLoadResoursesParams);
			}
		}
		
		private function loadResoursesError():void 
		{
			LoadingWheel.removeIfAny();
			
			if (callback_completeLoadResourses != null) {
				callback_completeLoadResourses.apply(null, completeLoadResoursesParams);
			}
		}
		
		public function getRewardViews():Vector.<SlotMachineRewardView> 
		{
			var slotMachineRewards:Vector.<SlotMachineRewardView> = new <SlotMachineRewardView>[];
			var i:int;
			var rewardView:SlotMachineRewardView;
			for (i = 0; i < _reelRewardsList.length; i++) {
				rewardView = new SlotMachineRewardView(AtlasAsset.ScratchCardAtlas.getTexture(SlotMachineRewardType.getRewardTexture(_reelRewardsList[i].rewardType)));
				rewardView.reward = _reelRewardsList[i];
				rewardView.alignPivot();
				slotMachineRewards.push(rewardView);
			}
			
			slotMachineRewards.sort(randomizeSortSlotMachineRewards);
			
			return slotMachineRewards;
		}
		
		private function randomizeSortSlotMachineRewards(...args):int {
			return Math.random() > 0.5 ? -1 : 1;
		}
		
		private function sortCashPayouts(a:Array, b:Array):int 
		{ 
			return b[1] - a[1]; 
		}
		
		public function getRandomReward(excludeIds:Array = null):SlotMachineReward
		{
			var i:int;
			var length:int = _reelRewardsList.length;
			var indexes:Array = [];
			for (i = 0; i < length; i++) {
				indexes.push(i);
			}
			
			var index:int = Math.floor(indexes.length * Math.random()); 
			if(!excludeIds)
				return _reelRewardsList[indexes[index]];
			
			excludeIds = excludeIds.slice(0, excludeIds.length);
			
			while (excludeIds.length > 0) 
			{
				if (excludeIds.indexOf(_reelRewardsList[indexes[index]].rewardType) != -1)
				{
					excludeIds.splice(indexes[index], 1);
					indexes.splice(index, 1);
					index = Math.floor(indexes.length * Math.random());
				}	
				else {
					return _reelRewardsList[indexes[index]];
				}
			}
			
			return _reelRewardsList[indexes[index]];
		}
		
		public function useSpin(spinType:String, betIndex:int, acceleratedMode:Boolean, debugSpinResult:SpinResult = null):SpinResult 
		{
			var collectCommodityItems:CollectCommodityItems;
			var commodityItem:CommodityItem;
			var stake:int = betList[betIndex];
			var chanceTableSpinType:String = spinType;
			
			if (debugSpinResult)
			{
				debugSpinResult.spinType = spinType;
				if (debugSpinResult.reward && debugSpinResult.reward.commodityItem) 
				{
					collectCommodityItems = new CollectCommodityItems([debugSpinResult.reward.commodityItem], 'slotMachine', true, false);
					collectCommodityItems.storeChests = true;
					collectCommodityItems.execute();
				}
				
				return debugSpinResult;
			}
			
			
			if (spinType == SpinType.DEFAULT)
			{
				if (Player.current.cashCount < stake) 
				{
					var point:Point = new Point(layoutHelper.stageWidth / 2, layoutHelper.stageHeight / 2);
					var text:String = betList[0] == stake ? "NOT ENOUGHT CASH!" : "NOT ENOUGHT CASH. TRY LOWER THE STAKE!";
					new ShowNoMoneyPopup(ShowNoMoneyPopup.PURPLE, Starling.current.stage, point, text, false, 900).execute();
					return null;
				}
			
				// снять кеш:
				Player.current.updateCashCount(-stake, 'slotMachine');
				Player.current.reservedCashCount -= stake;
			}
			else if (spinType == SpinType.FREE)
			{
				freeSpins -= 1;
			}
			else if (spinType == SpinType.BONUS_MINIGAME)
			{
				var bonusSpinMinigame:Minigame = getBonusSpinMinigame();
				if (!bonusSpinMinigame)
					return null;
				
				var bonusSpinBetindex:int = betList.indexOf(bonusSpinMinigame.getBet());
				stake = bonusSpinBetindex != -1 ? betList[bonusSpinBetindex] : betList[0];
				
				gameManager.slotsModel.removeBonusSpinFromAccount(bonusSpinMinigame);
				
				chanceTableSpinType = SpinType.FREE;
			}
			
			var slotsRewardsChanceTable:SlotMachineChanceTable = rewardsChanceTableBySpinType[chanceTableSpinType][stake] as SlotMachineChanceTable;
			if (!slotsRewardsChanceTable)
				return null;
			
			var result:SpinResult = new SpinResult();
			result.reward = slotsRewardsChanceTable.getResult() || SlotMachineReward.create(SlotMachineRewardType.NO_WIN, null, 0);
			
			//result.reward = slotsRewardsChanceTable.getRewardByType(SlotMachineRewardType.CASES);
			//result.reward = slotsRewardsChanceTable.getRewardByType(SlotMachineRewardType.NO_WIN);
			//result.reward = slotsRewardsChanceTable.getRewardByType(SlotMachineRewardType.FREE_SPINS);
			//result.reward = slotsRewardsChanceTable.getRewardByType(SlotMachineRewardType.CASH_1);
			//if (spinType == SpinType.FREE) 
				//result.reward = slotsRewardsChanceTable.getRewardByType(SlotMachineRewardType.PACKS);
				
			result.spinType = spinType;
			result.spinPattern = SpinPattern.getWeightedSpinPattern();
			//result.spinPattern = SpinPattern.TWISTING;
			
			
			
			TutorialManager.handleSpinResult(stake, tutorSpinCount, result, slotsRewardsChanceTable);
			
			if(debugDisableFreeSpins)
			{
				while (result.reward.rewardType == SlotMachineRewardType.FREE_SPINS) {
					result.reward = slotsRewardsChanceTable.getResult();
				}
			}
			
			// начислить награду
			if (result.reward && result.reward.rewardType != SlotMachineRewardType.NO_WIN && result.reward.commodityItem) 
			{
				collectCommodityItems = new CollectCommodityItems([result.reward.commodityItem], 'slotMachine', true, false);
				collectCommodityItems.storeChests = true;
				collectCommodityItems.execute();
			}
			
			//Game.connectionManager.sendPlayerUpdateMessage();
			
			//gameManager.analyticsManager.sendEvent(new SlotMachineSpinUseEvent(selectedType, result.templateType));
			
			if (spinType == SpinType.DEFAULT && tutorSpinCount <= TutorialManager.SLOT_MACHINE_TUTOR_MAX_SPIN_COUNT)
				tutorSpinCount++;
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNASlotSpinEvent(spinType, stake, tutorSpinCount, result, acceleratedMode))
				
			dispatchEventWith(Event.CHANGE);
			return result;
		}
		
		public function skipTutor():void
		{
			tutorSpinCount = TutorialManager.SLOT_MACHINE_TUTOR_MAX_SPIN_COUNT + 1;
		}
		
		public function set storedBetIndex(index:int):void {
			gameManager.clientDataManager.setValue('slotMachineBetIndex', index);
		}
		
		public function get storedBetIndex():int {
			return gameManager.clientDataManager.getValue('slotMachineBetIndex', 0);
		}
		
		public function set tutorSpinCount(value:int):void {
			gameManager.clientDataManager.setValue('slotMachineTutorSpinCount', value);
		}
		
		public function get tutorSpinCount():int {
			return gameManager.clientDataManager.getValue('slotMachineTutorSpinCount', 0);
		}
		
		public function get hasAnyFreeSpins():Boolean {
			return _freeSpins > 0 || totalBonusSpins > 0;
		}
		
		public function deserializeBonusSpins(account:Array):void 
		{
			bonusSpinsAccount = new Vector.<Minigame>();
			for each (var item:CommodityItemMessage in account) 
			{
				if (item.type == Type.MINIGAME)
				{
					if (item.powerupType == PowerupType.SPIN_5 ||
						item.powerupType == PowerupType.SPIN_10 ||
						item.powerupType == PowerupType.SPIN_25 ||
						item.powerupType == PowerupType.SPIN_50)
					{
						bonusSpinsAccount.push(new Minigame(item.powerupType, item.quantity));
					}
				}
			}
			
			dispatchEventWith(Event.CHANGE);
		}
		
		public function addBonusSpin(minigameDrop:Minigame):void
		{
			for each (var item:Minigame in bonusSpinsAccount) 
			{
				if (item.type == minigameDrop.type)
				{
					item.quantity += minigameDrop.quantity;
					return;
				}
			}
			
			bonusSpinsAccount.push(minigameDrop);
			
			gameManager.connectionManager.sendPlayerUpdateMessage();
		}
		
		public function fillPlayerMessage(playerMessage:PlayerMessage):void 
		{
			for each (var item:Minigame in bonusSpinsAccount) 
			{
				var cim:CommodityItemMessage = new CommodityItemMessage();
				cim.type = Type.MINIGAME;
				cim.powerupType = item.type;
				cim.quantity = item.quantity;
				playerMessage.account.push(cim);
			}
		}
		
		public function removeBonusSpinFromAccount(toPlay:Minigame):void 
		{
			for each (var item:Minigame in bonusSpinsAccount) 
			{
				if (item.type == toPlay.type)
				{
					item.quantity--;
					
					if (item.quantity < 0)
						item.quantity = 0;
				}
			}
			
			gameManager.connectionManager.sendPlayerUpdateMessage();
			
			dispatchEventWith(Event.CHANGE);
		}
		
		public function get totalBonusSpins():int
		{
			var total:int = 0;
			for each (var item:Minigame in bonusSpinsAccount) 
			{
				total += item.quantity;
			}
			return total;
		}
		
		private function getBonusSpinMinigame():Minigame 
		{
			var minigame:Minigame;
			for each (var item:Minigame in bonusSpinsAccount) 
			{
				if (item.quantity <= 0)
					continue;
				
				if (!minigame) {
					minigame = item;
					continue;
				}
				
				if (minigame.type > item.type)
					minigame = item;
			}
			
			return minigame;
		}
		
		/******************************************************************************************************************************
		 * 
		 * DEBUG:
		 * 
		 *******************************************************************************************************************************/
		 
		public function addDebugZeroStake():void
		{
			if (!('0' in rewardsChanceTableBySpinType[SpinType.DEFAULT]))
			{
				debugFillRewardsChanceTable(SpinType.DEFAULT, 1, 0, false);
				debugFillRewardsChanceTable(SpinType.FREE, 1, 0, false, false);
			}
		}
		 
		private function debugFillModel():void
		{
			debugFillRewardsChanceTable(SpinType.DEFAULT, 2, 1);
			debugFillRewardsChanceTable(SpinType.DEFAULT, 5, 2);
			debugFillRewardsChanceTable(SpinType.DEFAULT, 10, 5);
			debugFillRewardsChanceTable(SpinType.DEFAULT, 50, 25);
			debugFillRewardsChanceTable(SpinType.DEFAULT, 100, 50);
			debugFillRewardsChanceTable(SpinType.DEFAULT, 250, 100);
		}
		
		private function debugFillRewardsChanceTable(spinType:String, multiplier:int, stake:int, includeFreeSpins:Boolean = true, addToBetList:Boolean = true):void
		{
			var slotsRewardsChanceTable:SlotMachineChanceTable = new SlotMachineChanceTable();
			slotsRewardsChanceTable.spinType = spinType;
			//slotsRewardsChanceTable.multiplier = multiplier;
			slotsRewardsChanceTable.stake = stake;
			debugFillWeightedList(slotsRewardsChanceTable.weightedList, includeFreeSpins);	
			
			if(!(slotsRewardsChanceTable.spinType in rewardsChanceTableBySpinType))
				rewardsChanceTableBySpinType[slotsRewardsChanceTable.spinType] = {};
				
			rewardsChanceTableBySpinType[slotsRewardsChanceTable.spinType][slotsRewardsChanceTable.stake.toString()] = slotsRewardsChanceTable;
			
			if (addToBetList) {
				betList.push(stake);
				betList.sort(Array.NUMERIC);
			}
		}
		
		private function debugFillWeightedList(weightedList:WeightedList, includeFreeSpins:Boolean = true):void
		{
			var i:int = 1;
			var slotRewards:Array = [];
			slotRewards.push(SlotMachineReward.create(SlotMachineRewardType.CASH_2, CommodityItem.create(CommodityType.CASH, null, 10), 10));
			slotRewards.push(SlotMachineReward.create(SlotMachineRewardType.CASES, CommodityItem.create(CommodityType.CASH, null, 50), 10));
			slotRewards.push(SlotMachineReward.create(SlotMachineRewardType.PACKS, CommodityItem.create(CommodityType.CASH, null, 100), 10));
			slotRewards.push(SlotMachineReward.create(SlotMachineRewardType.SACKS, CommodityItem.create(CommodityType.CASH, null, 300), 10));
			slotRewards.push(SlotMachineReward.create(SlotMachineRewardType.VAULTS, CommodityItem.create(CommodityType.CASH, null, 1000), 10));
			//slotRewards.push(SlotMachineReward.create(i++, CommodityItem.create(CommodityType.CHEST, ChestType.BRONZE.toString(), 1), 10));
			//slotRewards.push(SlotMachineReward.create(i++, CommodityItem.create(CommodityType.CHEST, ChestType.SILVER.toString(), 1), 10));
			slotRewards.push(SlotMachineReward.create(SlotMachineRewardType.GOLD_CHEST, CommodityItem.create(CommodityType.CHEST, ChestType.GOLD.toString(), 1), 10));
			slotRewards.push(SlotMachineReward.create(SlotMachineRewardType.SUPER_CHEST, CommodityItem.create(CommodityType.CHEST, ChestType.SUPER.toString(), 1), 10));
			slotRewards.push(SlotMachineReward.create(SlotMachineRewardType.DUST, CommodityItem.create(CommodityType.DUST, null, 1), 10));
			slotRewards.push(SlotMachineReward.create(SlotMachineRewardType.INSTABINGO, CommodityItem.create(CommodityType.POWERUP, Powerup.INSTABINGO, 1), 10));
			slotRewards.push(SlotMachineReward.create(SlotMachineRewardType.THREE_DAUBS, CommodityItem.create(CommodityType.POWERUP, Powerup.TRIPLE_DAUB, 1), 10));
			
			if(includeFreeSpins)
				slotRewards.push(SlotMachineReward.create(SlotMachineRewardType.FREE_SPINS, CommodityItem.create(CommodityType.SLOT_FREE_SPINS, null, 3), 10));
			
			var slotReward:SlotMachineReward;
			while (slotRewards.length > 0) 
			{
				slotReward = slotRewards.shift() as SlotMachineReward;
				weightedList.addWeightedItem(slotReward, slotReward.weight);
				
				if (!(slotReward.rewardType in commodityItemsByRewardType)) {
					commodityItemsByRewardType[slotReward.rewardType] = slotReward.commodityItem;
					_reelRewardsList.push(slotReward);
				}
			}
		}
		
		/*public function getSlotRewardByType(type:String):SlotMachineReward 
		{
			return type in commodityItemsByRewardType ? (commodityItemsByRewardType[type] as SlotMachineReward) : null;
		}*/
		
		
		
		
		
		
		
		
		
		
		
		
		
	}

}