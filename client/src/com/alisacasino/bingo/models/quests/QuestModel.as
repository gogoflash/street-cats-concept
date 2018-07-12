package com.alisacasino.bingo.models.quests 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.commands.player.CollectCommodityItems;
	import com.alisacasino.bingo.controls.cardPatternHint.CardPattern;
	import com.alisacasino.bingo.dialogs.CommodityTakeOutDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.logging.SaveHTMLLog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.WeightedList;
	import com.alisacasino.bingo.models.game.StakeData;
	import com.alisacasino.bingo.models.offers.CashIconType;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.quests.questItems.BurnNCards;
	import com.alisacasino.bingo.models.quests.questItems.ClaimNPowerups;
	import com.alisacasino.bingo.models.quests.questItems.CollectNBingosInRound;
	import com.alisacasino.bingo.models.quests.questItems.CollectNBingosQuest;
	import com.alisacasino.bingo.models.quests.questItems.CollectNCards;
	import com.alisacasino.bingo.models.quests.questItems.CollectNPoints;
	import com.alisacasino.bingo.models.quests.questItems.NDaubStreaks;
	import com.alisacasino.bingo.models.quests.questItems.NDaubs;
	import com.alisacasino.bingo.models.quests.questItems.ObtainNCashFromChest;
	import com.alisacasino.bingo.models.quests.questItems.ObtainNCustomizersFromChest;
	import com.alisacasino.bingo.models.quests.questItems.ObtainNPowerupsFromChest;
	import com.alisacasino.bingo.models.quests.questItems.OpenNChests;
	import com.alisacasino.bingo.models.quests.questItems.PlayNGames;
	import com.alisacasino.bingo.models.quests.questItems.QuestBase;
	import com.alisacasino.bingo.models.quests.questItems.UseNPowerups;
	import com.alisacasino.bingo.models.quests.questItems.WinNCashInScratchCard;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.models.universal.ValueDataTable;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.ICardData;
	import com.alisacasino.bingo.screens.questsScreenClasses.QuestRenderer;
	import com.alisacasino.bingo.screens.questsScreenClasses.QuestsScreen;
	import com.alisacasino.bingo.utils.AbsoluteVersion;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAQuestAddedEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAQuestClaimedEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAQuestBaseEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAQuestSkippedEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAQuestTimeoutEvent;
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import flash.system.System;
	import flash.utils.Timer;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class QuestModel extends EventDispatcher implements IQuestNotifier
	{
		public static var DEBUG_MODE:Boolean = false;
		
		public static const EVENT_UPDATE:String = "EVENT_QUEST_MODEL_CHANGE";
		
		public static const CLEAN_RESERVED_PROGRESS:String = "CLEAN_RESERVED_PROGRESS";
		
		public static const QUEST_COMPLETE:String = "QUEST_COMPLETE";
		
		//static public const NEW_QUEST:String = "newQuest";
		
		public static const KEY_HINT_SKIP_SHOWS_COUNT:String = "key_hint_skip_shows_count";
		public static const SHOW_HINT_SKIP_MAX_COUNT:int = 0;
		private const DAILY_BACK_IMAGE_MAX_INDEX:int = 30;
		
		public var isFirstStart:Boolean;
		public var minLevel:int = int.MAX_VALUE;
		
		private var questClassByType:Object;
		
		public var activeQuests:Vector.<QuestBase>;
		
		private var _cashAwardTextureTable:ValueDataTable;
		
		private var nearestChangeTimer:Timer;
		private var nearestChangeTime:int;
		
		public var allQuests:Vector.<QuestBase>;
		public var allQuestsById:Object;
		
		private var passedQuestsByTypeIds:Object;
		
		private var dailyQuests:Vector.<QuestBase>;
		private var eventQuests:Vector.<QuestBase>;
		private var bonusQuests:Vector.<QuestBase>;
		
		public var actualQuestsObjectives:Object;
		private var questsSettingsByType:Object;
		
		private var removedQuestStyles:Array = [];
		
		private var tierLimits:Object;
		
		private var _tutorQuest:QuestBase;
		private var tutorQuestCompleted:Boolean;
		
		public static var debugBgColorsList:Object = {};
		public static var debugBgColorsIndex:Object = {};
		public static var debugProgressColorsList:Object = {};
		public static var debugProgressColorsIndex:Object = {};
		
		private var _dailyBackImageAsset:ImageAsset;
		private var dailyBackImageIndex:int;
		
		private var _reservedProgress:int;
		private var cleanReservedProgressId:int = -1;
		
		public function QuestModel() 
		{
			questClassByType = { };
			
			tierLimits = { };
			tierLimits[QuestType.DAILY_QUEST] = 0;
			tierLimits[QuestType.EVENT_QUEST] = 0;
			tierLimits[QuestType.BONUS_QUEST] = 0;
			
			createTypeMatchTable();
			allQuests = new Vector.<QuestBase>();
			allQuestsById = {};
			passedQuestsByTypeIds = {};
			
			activeQuests = new Vector.<QuestBase>();
			dailyQuests = new Vector.<QuestBase>();
			eventQuests = new Vector.<QuestBase>();
			bonusQuests = new Vector.<QuestBase>();
			actualQuestsObjectives = {};
			
			questsSettingsByType = {};
			
			QuestStyle.init();
			
			changeDailyBackImageIndex();
			
			DialogsManager.instance.addEventListener(DialogsManager.EVENT_REMOVE, handler_removeDialog);
		}
		
		public function refreshQuests(removeExpiredQuests:Boolean = false, forceSaveState:Boolean = false):void 
		{
			var hasChanges:Boolean;

			if (isFirstStart)
				return;
			
			var questsScreen:QuestsScreen = DialogsManager.instance.getDialogByClass(QuestsScreen) as QuestsScreen;
			if (questsScreen)
				removeExpiredQuests = questsScreen.canRemoveExpiredQuests;
			
			hasChanges = clearExpiredQuests(removeExpiredQuests) || hasChanges;
			
			hasChanges = tryAddNewQuest(QuestType.DAILY_QUEST, 0) || hasChanges;
			hasChanges = tryAddNewQuest(QuestType.EVENT_QUEST, 0) || hasChanges;
			hasChanges = tryAddNewQuest(QuestType.BONUS_QUEST, 0) || hasChanges;
			
			removedQuestStyles = [];
			
			if (hasChanges || forceSaveState) {
				saveQuestsState();
				
				if(hasChanges)
					dispatchEventWith(EVENT_UPDATE);
			}
			
			setNearestChangeTimer();
		}
		
		private function tryAddNewQuest(type:String, requestTier:int):Boolean
		{
			if (getActiveQuestByType(type))
				return false;
			
			var questTypeSettings:QuestTypeSettings = getQuestTypeSettings(type);
			if(questTypeSettings.maxQuestsPerPeriod > 0 && questTypeSettings.passedQuestsCount >= questTypeSettings.maxQuestsPerPeriod)
				return true;
				
				
			var weightedList:WeightedList = getQuestsWeightedList(type, requestTier, true);
			
			// сначала пробуем почистить список уже пройденных квестов этого типа:
			if (weightedList.weights.length == 0) {
				//trace('зачистка списка пройденных', passedQuestsByTypeIds[type]);
				passedQuestsByTypeIds[type] = [];
				weightedList = getQuestsWeightedList(type, requestTier, true);
			}	
			
			// потом радикально после зачистки списка пройденных не учитывать цели соседних:
			if (weightedList.weights.length == 0)
				weightedList = getQuestsWeightedList(type, requestTier, false);
			
			if (weightedList.totalWeight > 0)
			{
				var quest:QuestBase = weightedList.getRandomDrop() as QuestBase;
				
				if (!tutorQuestCompleted && _tutorQuest && _tutorQuest.type == type)
					quest = _tutorQuest;
				
				quest.reset();
				
				if (type == QuestType.DAILY_QUEST)
				{
					quest.timeStart = TimeService.serverTime + 1;
					var tourneyFinishTimestamp:int = Math.ceil(gameManager.tournamentData.endsAt / 1000);
					
					if (TimeService.serverTime >= tourneyFinishTimestamp)
						quest.duration = Math.max(60, Math.ceil(gameManager.tournamentData.duration / 1000)); 
					else 					
						quest.duration = tourneyFinishTimestamp - quest.timeStart;
				}
				else
				{
					quest.timeStart = TimeService.serverTime;
				}
				//trace(' >> 1 ', quest.type, quest.targetString);
				quest.setInitialProgress();
				
				activateQuest(quest, true);
				
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAQuestAddedEvent(quest));
				
				return true;
			}
			
			sosTrace("No matching quests");
			return true;
		}
		
		private function getQuestsWeightedList(type:String, requestTier:int, excludeOtherQuestSameTargets:Boolean):WeightedList
		{
			var weightedList:WeightedList = new WeightedList();
			var previouslyQuestObjectives:Object = {};
			
			//trace('now in previously: ___________________ ', excludeOtherQuestSameTargets);	
			if (excludeOtherQuestSameTargets) {
				for each(var questObjective:String in actualQuestsObjectives) {
					previouslyQuestObjectives[questObjective] = true;
					//		trace('>> ', questObjective);
				}
			}
			
			//trace('quests weighted list: ___________________ ', type, excludeOtherQuestSameTargets);		
			var questTypeSettings:QuestTypeSettings = getQuestTypeSettings(type);
			var passedQuestsById:Array;
			if (questTypeSettings && !questTypeSettings.randomObjectiveSelect)
				passedQuestsById = passedQuestsByTypeIds[type] as Array;
			
			var questList:Vector.<QuestBase> = getQuestListByType(type);
			var passedQuestsIds:Array = type in passedQuestsByTypeIds ? (passedQuestsByTypeIds[type] as Array) : [];
			for each (var item:QuestBase in questList) 
			{
				if (passedQuestsIds.indexOf(item.id.toString()) != -1)
					continue;
					
				if (!item.enabled || !checkQuestViable(item))
					continue;
					
				if (excludeOtherQuestSameTargets && item.objectiveType in previouslyQuestObjectives)
					continue;	
				
				if (passedQuestsById && passedQuestsById.indexOf(item.id) != -1)
					continue;
					
				weightedList.addWeightedItem(item, item.weight);
				
				//trace('>> ', item.goal, item.objectiveType);
			}
			
			return weightedList;
		}
		
		private function checkQuestViable(item:QuestBase):Boolean
		{
			var player:Player = Player.current;
			if (!player)
				return false;
			
			if (item.minLevel != -1 && player.xpLevel < item.minLevel)
				return false;
			
			if (item.maxLevel != -1 && player.xpLevel > item.maxLevel)
				return false;
			
			if (item.minLtv != -1 && player.lifetimeValue < item.minLtv)
				return false;
			
			if (item.maxLtv != -1 && player.lifetimeValue > item.maxLtv)
				return false;
				
			if (item.minCash != -1 && player.cashCount < item.minCash)
				return false;
			
			if (item.maxCash != -1 && player.cashCount > item.maxCash)
				return false;
			
			if (item.minPowerups != -1 && gameManager.powerupModel.powerupsTotal < item.minPowerups)
				return false;
			
			if (item.maxPowerups != -1 && gameManager.powerupModel.powerupsTotal > item.maxPowerups)
				return false;
			
			return true;
		}
		
		private function getQuestListByType(type:String):Vector.<QuestBase>
		{
			switch(type)
			{
				case QuestType.DAILY_QUEST: return dailyQuests;
				case QuestType.BONUS_QUEST: return bonusQuests;
				case QuestType.EVENT_QUEST: return eventQuests;
			}
			sosTrace("Quest list requested with invalid type", SOSLog.ERROR);
			return new Vector.<QuestBase>;
		}
		
		public function getActiveQuestByType(type:String):QuestBase
		{
			for each (var item:QuestBase in activeQuests) 
			{
				if (item.type == type)
					return item;
			}
			
			return null;
		}
		
		public function cleanQuestRendererActions():void
		{
			for each (var item:QuestBase in activeQuests) 
			{
				item.rendererAction = null;
			}
		}
		
		public function get tutorQuest():QuestBase
		{
			return _tutorQuest;
		}
		
		/*private function clearQuestAndRenew(quest:QuestBase, timeout:Boolean):void 
		{
			var oldType:String = quest.type;
			var requestTier:int = 0;
			if (oldType == QuestType.DAILY_QUEST)
			{
				requestTier = timeout ? 0 : quest.tier + 1;
				if (requestTier > tierLimits[QuestType.DAILY_QUEST])
				{
					//dailyQuestRenewTime = getNextDayStart();
				}
			}
			tryAddNewQuest(oldType, requestTier);
		}*/
		
		/*private function getNextDayStart():Number
		{
			var dayLengthSeconds:Number = 24 * 60 * 60;
			//TODO: Till the end of the day
			var dayStartSeconds:Number = Math.floor(TimeService.serverTime / dayLengthSeconds);
			var dayEndSeconds:Number = dayStartSeconds + dayLengthSeconds;
			return dayEndSeconds // * 1000;
		}*/
		
		private function createTypeMatchTable():void 
		{
			questClassByType[QuestObjective.N_BINGO_IN_ROUND] = CollectNBingosInRound;
			questClassByType[QuestObjective.COLLECT_N_BINGOS] = CollectNBingosQuest;
			questClassByType[QuestObjective.CLAIM_N_POWERUPS] = ClaimNPowerups;
			questClassByType[QuestObjective.USE_N_POWERUPS] = UseNPowerups;
			questClassByType[QuestObjective.OPEN_N_CHESTS] = OpenNChests;
			questClassByType[QuestObjective.N_DAUBS] = NDaubs;
			questClassByType[QuestObjective.N_DAUB_STREAKS] = NDaubStreaks;
			questClassByType[QuestObjective.COLLECT_N_POINTS] = CollectNPoints;
			questClassByType[QuestObjective.PLAY_N_GAMES] = PlayNGames;
			questClassByType[QuestObjective.BURN_N_CARDS] = BurnNCards;
			questClassByType[QuestObjective.COLLECT_N_CARDS] = CollectNCards;
			questClassByType[QuestObjective.WIN_N_CASH_IN_SCRATCH_CARD] = WinNCashInScratchCard;
			questClassByType[QuestObjective.OBTAIN_N_CASH_FROM_CHEST] = ObtainNCashFromChest;
			questClassByType[QuestObjective.OBTAIN_N_POWERUPS_FROM_CHEST] = ObtainNPowerupsFromChest;
			questClassByType[QuestObjective.OBTAIN_N_CUSTOMIZERS_FROM_CHEST] = ObtainNCustomizersFromChest;
		}
		
		
		public function deserializeStaticData(staticData:StaticDataMessage):void
		{
			reset();
			
			var questList:Array = 'quests' in staticData ? staticData['quests'] : [];
			//var uniqueObjectives:Array = [];
			
			var questsSettings:Array = 'questsSettings' in staticData ? staticData['questsSettings'] : [];
			var questSettingsRaw:Object;
			var questTypeSettings:QuestTypeSettings;
			for each(questSettingsRaw in questsSettings) {
				questTypeSettings = new QuestTypeSettings(questSettingsRaw);
				if(questTypeSettings.type != null)
					questsSettingsByType[questTypeSettings.type] = questTypeSettings;
			}
			
			/*questsSettingsByType[QuestType.EVENT_QUEST] = new QuestTypeSettings({type:QuestType.EVENT_QUEST, skipMinPrice:25, skipMaxPrice:250, skipPriceStep:25, randomObjectiveSelect:true});
			questsSettingsByType[QuestType.BONUS_QUEST] = new QuestTypeSettings({type:QuestType.BONUS_QUEST, skipMinPrice:5, skipMaxPrice:50, skipPriceStep:5, randomObjectiveSelect:true});
			questsSettingsByType[QuestType.DAILY_QUEST] = new QuestTypeSettings({type:QuestType.DAILY_QUEST, maxQuestsPerPeriod:2, randomObjectiveSelect:false});*/
			
			
			//questList = questList.concat(getDebugQuestsDataLikeAReal());
			//questList = getDebugQuestsData();
			//questList = getDebugQuestsDataConcrete();
			//questList = questList.concat(getDebugQuestsDataConcrete(6));
			
			var clientVersion:Number = AbsoluteVersion.fromString(gameManager.getVersionString());
			
			for each (var item:QuestDataMessage in questList) 
			{
				var objectiveType:String = item.objectiveType;
				if (!questClassByType.hasOwnProperty(objectiveType))
					continue;
				
				/*
				if (uniqueObjectives.indexOf(objectiveType) == -1)
				{
					uniqueObjectives.push(objectiveType);
				}
				*/
				
				var questClass:Class = questClassByType[objectiveType] as Class;
				if (!questClass)
					continue;
				
				var quest:QuestBase = new questClass() as QuestBase;
				if (!quest)
					continue;
				
				quest.deserialize(item);
				
				if ('debug' in item && item['debug'] == true)
					quest.isDebug = true;
				
				allQuests.push(quest);
				allQuestsById[quest.id] = quest;
				
				if (clientVersion < quest.minClientVersion)
					continue;
				
				minLevel = Math.min(quest.minLevel, minLevel);
				
				if (quest.isTutor) {
					_tutorQuest	= quest;
					continue;
				}
				
				tierLimits[quest.type] = int(Math.max(quest.tier, tierLimits[quest.type]));
				
				switch(quest.type)
				{
					case QuestType.DAILY_QUEST:
						dailyQuests.push(quest);
						break;
					case QuestType.EVENT_QUEST:
						eventQuests.push(quest);
						break;
					case QuestType.BONUS_QUEST:
						bonusQuests.push(quest);
						break;
				}
			}
			
			//minLevel = 7;
		}
		
		public function init():void
		{
			clearActiveQuests();
			
			var questStateRaw:Object = gameManager.clientDataManager.getValue("questState", null);
			deserializeQuestState(questStateRaw);
			
			if(gameManager.tournamentData.tournamentResultToShow)
				dropDailyQuestPassedCount();
				
			isFirstStart = questStateRaw == null;
			
			refreshQuests();
		}
		
		private function reset():void 
		{
			clearActiveQuests();
			
			allQuests.length = 0;
			allQuestsById = {};
			
			dailyQuests.length = 0;
			eventQuests.length = 0;
			bonusQuests.length = 0;

			tierLimits = { };
			tierLimits[QuestType.DAILY_QUEST] = 0;
			tierLimits[QuestType.EVENT_QUEST] = 0;
			tierLimits[QuestType.BONUS_QUEST] = 0;
			
			actualQuestsObjectives = {};
			questsSettingsByType = {};
			passedQuestsByTypeIds = {};
		}
		
		private function deserializeQuestState(questState:Object):void
		{
			if (!questState)
				return;
				
			if (questState.hasOwnProperty("quests"))
			{
				var quests:Array = questState["quests"];
				if (quests)
				{
					for each (var item:Object in quests) 
					{
						activateQuest(readStateData(item), false, false);
					}
				}
			}
			
			tutorQuestCompleted = "tutorQuestCompleted" ? Boolean(questState["tutorQuestCompleted"]) : false;
			passedQuestsByTypeIds = "passedQuestsByTypeIds" in questState ? (questState["passedQuestsByTypeIds"] as Object) : {};
		}
		
		private function readStateData(questStateRaw:Object):QuestBase 
		{
			if (!questStateRaw || !(questStateRaw["staticId"] in allQuestsById))
				return null;
			
			var quest:QuestBase = allQuestsById[questStateRaw["staticId"]] as QuestBase;
			quest.reset();
			quest.deserializeSavedState(questStateRaw);
			
			/*if ((quest.timeStart + quest.duration) >= TimeService.serverTime && !quest.isCompleted(false))
				return null;*/
			
			return quest;
		}
		
		public function saveQuestsState():void
		{
			var questStateRaw:Object = {};
			var quests:Array = [];
			var questRaw:Object;
			var questsTypeSettings:QuestTypeSettings;
			for each (var quest:QuestBase in activeQuests) 
			{
				questRaw = quest.serializeSavedState();
				
				quests.push(questRaw);
			}
			
			questStateRaw["quests"] = quests;
			questStateRaw["tutorQuestCompleted"] = tutorQuestCompleted;
			questStateRaw['passedQuestsByTypeIds'] = passedQuestsByTypeIds;
			
			gameManager.clientDataManager.setValue("questState", questStateRaw, true);
		}
			
		public function claimQuestReward(quest:QuestBase):void
		{
			if (!quest || !quest.reward)
				return;
			
			var collectCommodityItemsCommand:CollectCommodityItems = new CollectCommodityItems([quest.reward], "quest", true, false);
			collectCommodityItemsCommand.execute();
			
			if (quest.reward.type == CommodityType.CHEST || quest.showTotalDialog)
			{
				var questsScreen:QuestsScreen = DialogsManager.instance.getDialogByClass(QuestsScreen) as QuestsScreen;
				if (questsScreen) {
					questsScreen.callShowReservedDropsOnClose = false;
					questsScreen.close();
				}
				
				if(quest.reward.type != CommodityType.CHEST)
					DialogsManager.addDialog(new CommodityTakeOutDialog([quest.reward], true, 1), true);	
			}
			
			quest.rewardClaimed = true;
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAQuestClaimedEvent(quest));
			//new DDNAQuestEvent(DDNAQuestEvent.CLAIM, quest.type, quest.id, quest.currentDuration, quest.currrentTimeout));
			
			var questTypeSettings:QuestTypeSettings = quest.getQuestTypeSettings();
			questTypeSettings.tier = 0;
			if(questTypeSettings.maxQuestsPerPeriod > 0 && !quest.isTutor)
				questTypeSettings.passedQuestsCount++;
				
			if (quest.isTutor)
				tutorQuestCompleted = true;
			
			pushQuestToPassedIdsList(questTypeSettings, quest);	
				
			refreshQuests(true);
		}
		
		private function pushQuestToPassedIdsList(questTypeSettings:QuestTypeSettings, quest:QuestBase):void 
		{
			if (!questTypeSettings || !quest) 
				return;
			
			if (!questTypeSettings.randomObjectiveSelect) {
				var passedQuestsIds:Array;
				if (quest.type in passedQuestsByTypeIds) {
					passedQuestsIds = passedQuestsByTypeIds[quest.type] as Array;
				}
				else {
					passedQuestsIds = [];
					passedQuestsByTypeIds[quest.type] = passedQuestsIds;
				}
				
				passedQuestsIds.push(quest.id);
			}	
		}
		
		public function skipQuest(quest:QuestBase):void
		{
			if (!quest || quest.expired)
				return;
		
			var cashPrice:int = quest.skipPrice;	
			Player.current.updateCashCount(-cashPrice, "questSkip");
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAQuestSkippedEvent(quest));
			
			var questTypeSettings:QuestTypeSettings = getQuestTypeSettings(quest.type);
			questTypeSettings.tier++;
			pushQuestToPassedIdsList(questTypeSettings, quest);		
				
			quest.skipped = true;
			refreshQuests();
		}
		
		public function getQuestTypeSettings(type:String):QuestTypeSettings 
		{
			if (!type)
				return new QuestTypeSettings(null);
			
			if (type in questsSettingsByType)
				return questsSettingsByType[type] as QuestTypeSettings;
				
			var questsTypeSettings:QuestTypeSettings = new QuestTypeSettings(null);
			questsSettingsByType[type] = questsTypeSettings;
			
			return questsTypeSettings;
		}
		
		public function get cashAwardTextureTable():ValueDataTable
		{
			if (!_cashAwardTextureTable)
				_cashAwardTextureTable = new ValueDataTable({
					50:CashIconType.CARD_2, 
					100:CashIconType.CARD_4, 
					200:CashIconType.CASE, 
					500:CashIconType.BAG, 
					1000:CashIconType.SAFE
				});
				
			return _cashAwardTextureTable;	
		}
		
		private function passToActive(functionName:String, ...rest):void 
		{
			for each (var item:QuestBase in activeQuests) 
			{
				(item[functionName] as Function).apply(item, rest);
			}
		}
		
		public function bingoClaimed(x2Active:Boolean, placeInRound:int, bingoPatterns:Vector.<String>, stakeData:StakeData):void
		{
			passToActive("bingoClaimed", x2Active, placeInRound, bingoPatterns, stakeData);
		}
		
		public function powerupClaimedFromCard(powerup:String):void
		{
			passToActive("powerupClaimedFromCard", powerup);
		}
		
		public function cardBurned(card:ICardData, quantity:int):void 
		{
			passToActive("cardBurned", card, quantity);
		}
		
		public function cardCollected(card:ICardData):void 
		{
			passToActive("cardCollected", card);
		}
		
		public function cashCollected(quantity:int, source:String):void 
		{
			passToActive("cashCollected",quantity,source);
		}
		
		public function powerupUsed(powerup:String):void 
		{
			passToActive("powerupUsed", powerup);
		}
		
		public function chestOpened(type:int, rewards:Array):void 
		{
			// выкручиваемся из ситуации когда PREMIUM и SUPER выглядят для юзера одинаково
			if (type == ChestType.PREMIUM)
				type = ChestType.SUPER;
			
			passToActive("chestOpened", type, rewards);
		}
		
		public function scoreEarned(score:int, stakeData:StakeData):void 
		{
			passToActive("scoreEarned", score, stakeData);
		}
		
		public function daubRegistered(number:int):void 
		{
			passToActive("daubRegistered", number);
		}
		
		public function daubStreakProgress(streak:int):void 
		{
			passToActive("daubStreakProgress", streak);
		}
		
		public function roundStart(numCards:int, stakeData:StakeData):void 
		{
			passToActive("roundStart", numCards, stakeData);
		}
		
		public function roundEnd(numCards:int, stakeData:StakeData):void 
		{
			passToActive("roundEnd", numCards, stakeData);
		}
		
		public function activateQuest(questToActivate:QuestBase, deactivateActiveSameType:Boolean = false, updateStyle:Boolean = true):void 
		{
			if (!questToActivate)
				return;
			
			if (deactivateActiveSameType)
				deactivateQuestByType(questToActivate.type);
				
			questToActivate.addEventListener(Event.CHANGE, item_changeHandler);
			//questToActivate.addEventListener(Event.COMPLETE, item_completeHandler);
			if(updateStyle)
				updateQuestStyle(questToActivate);
			
			activeQuests.push(questToActivate);
			
			actualQuestsObjectives[questToActivate.type] = questToActivate.objectiveType;
		}
		
		public function createQuestStyles():void
		{
			var item:QuestBase;
			var usedQuestsStyles:Array = [];
			for (var i:int = 0; i < activeQuests.length; i++) 
			{
				item = activeQuests[i];
				if(!item.style)
					updateQuestStyle(item);
			}
		}
		
		public function updateQuestStyle(quest:QuestBase):void
		{
			var item:QuestBase;
			var usedQuestsStyles:Array = removedQuestStyles;
			for (var i:int = 0; i < activeQuests.length; i++) 
			{
				item = activeQuests[i];
				if(item != quest && item.style)
					usedQuestsStyles.push(item.style.backgroundColor);
			}
			
			if (quest.isTutor) 
				quest.style = QuestStyle.getRandomAmongBackgroundColors(QuestStyle.YELLOW, QuestStyle.GREEN);
			else
				quest.style = QuestStyle.getRandomWidthNewBackgroundColor(usedQuestsStyles);
				
			//removedQuestStyles = [];
		}
		
		public function deactivateQuestByType(type:String):void 
		{
			var item:QuestBase;
			for (var i:int = 0; i < activeQuests.length; i++) 
			{
				item = activeQuests[i];
				if (item.type == type) 
				{
					deactivateQuest(item);
					activeQuests.removeAt(i);
					return;
				}
			}
		}
		
		private function clearActiveQuests():void 
		{
			for each (var item:QuestBase in activeQuests) 
			{
				deactivateQuest(item);
			}
			activeQuests.length = 0;
		}
		
		private function deactivateQuest(quest:QuestBase):void {
			quest.removeEventListener(Event.CHANGE, item_changeHandler);
		}
		
		private function item_changeHandler(e:Event):void 
		{
			saveQuestsState();
		}
		
		public function clearExpiredQuests(removeExpiredQuests:Boolean):Boolean
		{
			var quest:QuestBase;
			var i:int = 0;
			var hasChanges:Boolean;
			var isCompleted:Boolean;
			var questTypeSettings:QuestTypeSettings;
			while (i < activeQuests.length) 
			{
				quest = activeQuests[i];
				isCompleted = quest.isCompleted(false);
				questTypeSettings = quest.getQuestTypeSettings();
				
				if (quest.type == QuestType.DAILY_QUEST && quest.expired)
					questTypeSettings.passedQuestsCount = 0;
				
				if (!isCompleted && quest.skipped) 
				{
					quest.rendererAction = QuestRenderer.ACTION_SKIPPED;
					activeQuests.splice(i, 1);
					
					if(quest.style)
						removedQuestStyles.push(quest.style.backgroundColor);
					
					deactivateQuest(quest);
					hasChanges = true;
					//trace('clear ', quest.type, quest.id, 'ACTION_SKIPPED');
				}
				if (!isCompleted && quest.expired) 
				{
					if (removeExpiredQuests) 
					{
						gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAQuestTimeoutEvent(quest));
						quest.rendererAction = QuestRenderer.ACTION_EXPIRED;
						activeQuests.splice(i, 1);
						if(quest.style)
							removedQuestStyles.push(quest.style.backgroundColor);
					}
					else {
						i++;
					}
					
					questTypeSettings.tier = 0;
			
					//if(questTypeSettings.maxQuestsPerPeriod > 0)
						//questTypeSettings.passedQuestsCount++;
					
					pushQuestToPassedIdsList(questTypeSettings, quest);	
						
					deactivateQuest(quest);
					hasChanges = true;
					//trace('clear ', quest.type, quest.id, 'ACTION_EXPIRED');
				}
				else if (isCompleted && quest.rewardClaimed) 
				{
					quest.rendererAction = QuestRenderer.ACTION_CLAIMED;
					deactivateQuest(quest);
					activeQuests.splice(i, 1);
					if(quest.style)
						removedQuestStyles.push(quest.style.backgroundColor);
					hasChanges = true;
					//trace('clear ', quest.type, quest.id, 'ACTION_CLAIMED');
				}
				else {
					i++;
				}
			}
			
			return hasChanges;
		}
		
		private function setNearestChangeTimer(refreshNearestChangeTime:Boolean = true):void 
		{
			if(refreshNearestChangeTime)
				nearestChangeTime = getNearestChangeTime();
			
			var changeTimeout:uint;
			if(nearestChangeTime >= int.MAX_VALUE || nearestChangeTime == 0)
				changeTimeout = 10 * 60;
			else
				changeTimeout = Math.max(uint(nearestChangeTime - TimeService.serverTime), 1);
			
			sosTrace('Quest.setNearestChangeTimer ', changeTimeout, refreshNearestChangeTime, '|', nearestChangeTime - TimeService.serverTime);
			//trace('setNearestChangeTimer ', changeTimeout, nearestChangeTime, refreshNearestChangeTime);
			
			if(changeTimeout > 0)
			{
				if(!nearestChangeTimer) {
					nearestChangeTimer = new Timer(1000, 1);
					nearestChangeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handler_nearestChangeTimer);
				}
				
				nearestChangeTimer.reset();
				nearestChangeTimer.repeatCount = Math.ceil(changeTimeout/2); 
				nearestChangeTimer.start();
			}
			else
			{
				if(nearestChangeTimer) 
				{
					nearestChangeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, handler_nearestChangeTimer);
					nearestChangeTimer.stop();
					nearestChangeTimer = null;
				}
			}
		}
		
		private function handler_nearestChangeTimer(e:TimerEvent):void 
		{
			//sosTrace('handler_nearestChangeTimer.', TimeService.serverTime, nearestChangeTime);
			if(TimeService.serverTime >= nearestChangeTime) {
				//trace('handler_nearestChangeTimer CALL REFRESH')//, TimeService.serverTime, nearestChangeTime);
				nearestChangeTime = 0;
				refreshQuests();
			}
			else {
				setNearestChangeTimer(false);
			}
		}
		
		private function getNearestChangeTime():int 
		{
			var quest:QuestBase;
			var minTime:int = int.MAX_VALUE;
			var serverTime:int = TimeService.serverTime;
			
			for each(quest in activeQuests) 
			{
				if(quest.isCompleted(false) || quest.duration == 0)
					continue;
				
				minTime = Math.min(minTime, quest.timeStart + quest.duration);
			}
			
			return minTime;
		}	
		
		public function get dailyBackImageAsset():ImageAsset 
		{
			var url:String = 'miscellaneous/quest_back_' + dailyBackImageIndex.toString() + '.png';
			if (!_dailyBackImageAsset || _dailyBackImageAsset.url != url) {
				if (_dailyBackImageAsset)
					_dailyBackImageAsset.purge();
					
				_dailyBackImageAsset = new ImageAsset('miscellaneous/quest_back_' + dailyBackImageIndex.toString() + '.png');
			}
			
			return _dailyBackImageAsset;
		}
		
		public function loadCurrentDailyBackImageAsset():void
		{
			if (dailyBackImageAsset && !dailyBackImageAsset.loaded && !dailyBackImageAsset.loading)
				dailyBackImageAsset.load(null, null);
		}
		
		public function changeDailyBackImageIndex():void
		{
			dailyBackImageIndex = Math.floor(Math.random() * (DAILY_BACK_IMAGE_MAX_INDEX + 1));
		}
		
		public function unloadDailyBackImageAsset():void
		{
			if (_dailyBackImageAsset) {
				_dailyBackImageAsset.purge();
				_dailyBackImageAsset = null;
			}
		}
		
		
		public function set reservedProgress(value:int):void {
			_reservedProgress = value;
		}
		
		public function get reservedProgress():int {
			return _reservedProgress;
		}
		
		public function cleanReservedProgress(delay:Number = 0):void 
		{
			if (_reservedProgress == 0)
				return;
				
			if (cleanReservedProgressId != -1) {
				Starling.juggler.removeByID(cleanReservedProgressId);
				cleanReservedProgressId = -1;
			}
			
			if (delay == 0) 
			{
				//if (DialogsManager.activeDialog || (Game.current.gameScreen && Game.current.gameScreen.lobbyUI && Game.current.gameScreen.lobbyUI.questsBadge && !Game.current.gameScreen.lobbyUI.questsBadge.isReadyForJumping))
					//return;
				
				dispatchEventWith(CLEAN_RESERVED_PROGRESS, false, Math.min(10, Math.max(3, _reservedProgress)));
				_reservedProgress = 0;
			}
			else {
				cleanReservedProgressId = Starling.juggler.delayCall(cleanReservedProgress, delay, 0);
			}
		}
		
		private function handler_removeDialog(event:Event):void 
		{
			cleanReservedProgress(0.5);
		}
		
		public function get isAnyQuestExpired():Boolean
		{
			var quest:QuestBase;
			for each (quest in activeQuests) {
				if (quest.expired && !quest.isCompleted(false))
					return true;
			}
			
			return false;
		}
		
		public function dropDailyQuestPassedCount():void
		{
			var questTypeSettings:QuestTypeSettings = getQuestTypeSettings(QuestType.DAILY_QUEST);
			questTypeSettings.passedQuestsCount = 0;
			refreshQuests(true, true);
		}
		
		/********************************************************************************************************************************
		* 
		* DEBUG:
		* 
		********************************************************************************************************************************/
				
		private function getDebugQuestsData():Array
		{
			var rawResults:Array = [];
			
			var commonDuration:int = 16;
			
			
			questsSettingsByType[QuestType.DAILY_QUEST] = new QuestTypeSettings({type:QuestType.DAILY_QUEST, maxQuestsPerPeriod:0, randomObjectiveSelect:true});
			
			
			/*rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.PLAY_N_GAMES, [], 4, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.SCORE, 10));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.PLAY_N_GAMES, [2], 4, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.TRIPLE_DAUB, 10));*/
			
			//rawResults.push(debugCreateQuestMessagePack(['D', '0', 'B'], QuestObjective.N_DAUB_STREAKS, [2], 4, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.DAUB, 10));
			//rawResults.push(debugCreateQuestMessagePack(['D', '0', 'B'], QuestObjective.COLLECT_N_POINTS, [], 100, 0, 100, CommodityType.CUSTOMIZER, CustomizationType.CARD, 2));
			
			
			//rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.OPEN_N_CHESTS, [ChestType.SILVER], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.DOUBLE_DAUB, 10));
			
			//rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.N_DAUBS, [], 10, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.DOUBLE_DAUB, 10));
			//rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.N_DAUBS, ["number", 8], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.INSTABINGO, 10));
			
			//rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.CLAIM_N_POWERUPS, ["powerup", 'x2'], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 400));
			//rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.CLAIM_N_POWERUPS, ["rarity", Powerup.RARITY_RARE], 3, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 400));
			//rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.N_BINGO_IN_ROUND, [3], 7, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.CASH, 10));
			
			
			//rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.BURN_N_CARDS, [BurnNCards.CUSTOMIZER], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.DUST, null, 30));
			//rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.BURN_N_CARDS, [BurnNCards.COLLECTION], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 100));
			//rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.BURN_N_CARDS, [BurnNCards.ANY], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 100));
			
			//rawResults.push(debugCreateQuestMessagePack(['D', '0', 'B'], QuestObjective.COLLECT_N_CARDS, [CollectNCards.CUSTOMIZER], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.COLLECTION, CardType.NORMAL, 2));
			//rawResults.push(debugCreateQuestMessagePack(['D', '0', 'B'], QuestObjective.COLLECT_N_CARDS, [CollectNCards.COLLECTION], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP_CARD, Powerup.RARITY_RARE, 2));
			
			//rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.WIN_N_CASH_IN_SCRACTH_CARD, [10], 100, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.SCORE, 10));
			
			
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.BURN_N_CARDS, [BurnNCards.CUSTOMIZER], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.DUST, null, 30));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.BURN_N_CARDS, [BurnNCards.COLLECTION], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 100));
			
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.CLAIM_N_POWERUPS, [], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 340));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.CLAIM_N_POWERUPS, [], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 400));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.CLAIM_N_POWERUPS, [], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 1800));
			
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.COLLECT_N_BINGOS, [], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 2500));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.COLLECT_N_BINGOS, ["top", 3], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CHEST, ChestType.BRONZE, 1));
			rawResults.push(debugCreateQuestMessagePack(['D', '0', 'B'], QuestObjective.COLLECT_N_BINGOS, ["top", 1], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CHEST, ChestType.SILVER, 1));
			rawResults.push(debugCreateQuestMessagePack(['D', '0', 'B'], QuestObjective.COLLECT_N_BINGOS, ["pattern", "diagonal"], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CHEST, ChestType.GOLD, 1));
			rawResults.push(debugCreateQuestMessagePack(['D', '0', 'B'], QuestObjective.COLLECT_N_BINGOS, ["x2"], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CHEST, ChestType.SUPER, 1));
			
			rawResults.push(debugCreateQuestMessagePack(['D', '0', 'B'], QuestObjective.COLLECT_N_CARDS, [CollectNCards.CUSTOMIZER], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.COLLECTION, CardType.NORMAL, 2));
			rawResults.push(debugCreateQuestMessagePack(['D', '0', 'B'], QuestObjective.COLLECT_N_CARDS, [CollectNCards.COLLECTION], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP_CARD, Powerup.RARITY_RARE, 2));
			
			rawResults.push(debugCreateQuestMessagePack(['D', '0', 'B'], QuestObjective.COLLECT_N_POINTS, [], 100, 0, 100, CommodityType.CUSTOMIZER, CustomizationType.CARD, 2));
			
			rawResults.push(debugCreateQuestMessagePack(['D', '0', 'B'], QuestObjective.N_BINGO_IN_ROUND, [2], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.CASH, 10));
			
			//rawResults.push(debugCreateQuestMessagePack(['D', '0', 'B'], QuestObjective.N_DAUB_STREAKS, [2], 4, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.DAUB, 10));
			
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.N_DAUBS, [], 10, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.DOUBLE_DAUB, 10));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.N_DAUBS, [8], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.INSTABINGO, 10));
			
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.OBTAIN_N_CASH_FROM_CHEST, [], 100, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.SCORE, 10));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.OBTAIN_N_CASH_FROM_CHEST, [ChestType.SILVER], 100, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.TRIPLE_DAUB, 10));
			
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.OBTAIN_N_CUSTOMIZERS_FROM_CHEST, [], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.X2, 10));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.OBTAIN_N_CUSTOMIZERS_FROM_CHEST, [ChestType.SUPER], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.XP, 10));
			
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.OBTAIN_N_POWERUPS_FROM_CHEST, [], 10, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.DUST, null, 1));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.OBTAIN_N_POWERUPS_FROM_CHEST, [ChestType.BRONZE], 10, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.DUST, null, 1));
			
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.OPEN_N_CHESTS, [], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.DOUBLE_DAUB, 10));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.OPEN_N_CHESTS, [ChestType.SILVER], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.INSTABINGO, 10));
			
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.PLAY_N_GAMES, [], 4, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.SCORE, 10));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.PLAY_N_GAMES, [2], 4, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.TRIPLE_DAUB, 10));
			
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.USE_N_POWERUPS, [], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.SCORE, 10));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.USE_N_POWERUPS, ["rarity", Powerup.RARITY_MAGIC], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.SCORE, 10));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.USE_N_POWERUPS, ["powerup", Powerup.DAUB], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.SCORE, 10));
			
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.WIN_N_CASH_IN_SCRATCH_CARD, [], 100, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.SCORE, 10));

			
			var result:Array = [];
			for each (var item:Array in rawResults) 
			{
				result = result.concat(item);
			}
			
			return result;
		}
		
		private function getDebugQuestsDataConcrete(minLevel:int = 0):Array
		{
			var rawResults:Array = [];
			var commonDuration:int = 1116;
			
			/*questsSettingsByType[QuestType.EVENT_QUEST] = new QuestTypeSettings({type:QuestType.EVENT_QUEST, skipMinPrice:25, skipMaxPrice:250, skipPriceStep:25, randomObjectiveSelect:false});
			questsSettingsByType[QuestType.BONUS_QUEST] = new QuestTypeSettings({type:QuestType.BONUS_QUEST, skipMinPrice:5, skipMaxPrice:50, skipPriceStep:5, randomObjectiveSelect:false});
			questsSettingsByType[QuestType.DAILY_QUEST] = new QuestTypeSettings({type:QuestType.DAILY_QUEST, maxQuestsPerPeriod:0, randomObjectiveSelect:false});*/
			
			
			
			// diff customizer drops settings
			/*rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.OPEN_N_CHESTS, [ChestType.SILVER], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CUSTOMIZER_SET, 110, 3));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.OPEN_N_CHESTS, [ChestType.SILVER], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CUSTOMIZER, 'maya_set_dauber', 1));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.OPEN_N_CHESTS, [ChestType.SILVER], 3, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CUSTOMIZER, CustomizationType.CARD, 1));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.OPEN_N_CHESTS, [ChestType.SILVER], 4, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.DUST, null, 10));*/
			
			// diff targets:
			/*rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.OPEN_N_CHESTS, [ChestType.SILVER], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.DOUBLE_DAUB, 10));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.N_DAUBS, [], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.DOUBLE_DAUB, 10));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.COLLECT_N_POINTS, [], 3, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.INSTABINGO, 10));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.CLAIM_N_POWERUPS, ["powerup", 'x2'], 4, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 400));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.N_BINGO_IN_ROUND, [], 5, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 400));*/
			
			/*rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.OPEN_N_CHESTS, [ChestType.SILVER], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.DOUBLE_DAUB, 10));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.N_DAUBS, [], 10, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.DOUBLE_DAUB, 10));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.N_DAUBS, ["number", 8], 2, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.INSTABINGO, 10));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.CLAIM_N_POWERUPS, ["powerup", 'x2'], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 400));*/
			
			
			
			//rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.PLAY_N_GAMES, [], 200, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 300));
			
			// 
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.PLAY_N_GAMES, ["card_boost", 2], 3, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 300, true, 10, false, minLevel));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.COLLECT_N_BINGOS, ["card_boost", 3], 4, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 300, true, 10, false, minLevel));
			rawResults.push(debugCreateQuestMessagePack(['D', 'E', 'B'], QuestObjective.COLLECT_N_POINTS, ["card_boost", 5], 150, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 300, true, 10, false, minLevel));
			
			
			var result:Array = [];
			for each (var item:Array in rawResults) 
			{
				result = result.concat(item);
			}
			
			return result;
		}
		
		private function getDebugQuestsDataLikeAReal():Array
		{
			var rawResults:Array = [];
			
			var commonDuration:int = 7;
			
			//Event Quests:

			//- Play *200* Rounds  (Reward: 300 Cash)
			rawResults.push(debugCreateQuestMessagePack(['E'], QuestObjective.PLAY_N_GAMES, [], 200, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 300));
			//- Get *100* Bingos  (Reward: 500 Cash)
			rawResults.push(debugCreateQuestMessagePack(['E'], QuestObjective.COLLECT_N_BINGOS, [], 100, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 500));
			//- Open *100* Chests  (Reward: 1000 Cash)
			rawResults.push(debugCreateQuestMessagePack(['E'], QuestObjective.OPEN_N_CHESTS, [], 100, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 1000));
			//- Open *50* Bronze/Silver/Gold Chests   (Reward: 50 normal/magic/rare Power-Ups соответсвенно)
			rawResults.push(debugCreateQuestMessagePack(['E'], QuestObjective.OPEN_N_CHESTS, [ChestType.BRONZE], 50, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.DAUB, 50));
			rawResults.push(debugCreateQuestMessagePack(['E'], QuestObjective.OPEN_N_CHESTS, [ChestType.SILVER], 50, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.X2, 50));
			rawResults.push(debugCreateQuestMessagePack(['E'], QuestObjective.OPEN_N_CHESTS, [ChestType.GOLD], 50, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.INSTABINGO, 50));
			//- Make *1000* Daubs  (Reward: 10 InstaBingo)
			rawResults.push(debugCreateQuestMessagePack(['E'], QuestObjective.N_DAUBS, [], 1000, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.INSTABINGO, 10));
			//- Attain *50000* Score  (Reward: Super Chest)
			rawResults.push(debugCreateQuestMessagePack(['E'], QuestObjective.COLLECT_N_POINTS, [], 50000, 0, 100, CommodityType.CHEST, ChestType.SUPER, 1));

			//Daily Quests:

			//- Win *1st/2nd/3rd Place* in a Round  (Reward: Gold Chest/Silver/Bronze Chest)
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.COLLECT_N_BINGOS, ["top", 1], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CHEST, ChestType.GOLD, 1));
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.COLLECT_N_BINGOS, ["top", 2], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CHEST, ChestType.SILVER, 1));
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.COLLECT_N_BINGOS, ["top", 3], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CHEST, ChestType.BRONZE, 1));
			//- Play *25* Four Card Rounds   (Reward: 5 Triple Daub Power-ups)
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.PLAY_N_GAMES, [4], 25, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.TRIPLE_DAUB, 5));
			//- Get *5 Vertical/Horizontal/Diagonal line/Four Corners* Bingo  (Reward:  silver/silver/gold/super chest )
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.COLLECT_N_BINGOS, ["pattern", CardPattern.COLUMN], 5, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CHEST, ChestType.SILVER, 1));
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.COLLECT_N_BINGOS, ["pattern", CardPattern.ROWS], 5, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CHEST, ChestType.SILVER, 1));
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.COLLECT_N_BINGOS, ["pattern", CardPattern.DIAGONAL], 5, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CHEST, ChestType.GOLD, 1));
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.COLLECT_N_BINGOS, ["pattern", CardPattern.FOUR_CORNERS], 5, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CHEST, ChestType.SUPER, 1));
			//- Achieve *2/3/4 Bingos* in One Round  (Reward: 50/100/200 Cash)
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.N_BINGO_IN_ROUND, [2], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 50));
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.N_BINGO_IN_ROUND, [3], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 100));
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.N_BINGO_IN_ROUND, [4], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 200));
			//- Daub *Number 42* Five Times   (Reward: 42 Dust)
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.N_DAUBS, ["number", 42], 5, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.DUST, null, 42, true, 10, true));
			//- Use *20/50* Power-ups   (Reward: 2/5 Collectible Items) 
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.USE_N_POWERUPS, [], 20, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.COLLECTION, CardType.NORMAL, 2, true, 10, true));
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.USE_N_POWERUPS, [], 50, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.COLLECTION, CardType.NORMAL, 5, true, 10, true));
			//- Earn *500 Cash* from Chests   (Reward: Super Chest) 
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.OBTAIN_N_CASH_FROM_CHEST, [], 500, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CHEST, ChestType.SUPER, 1));
			//- Earn *1000 Cash* from Super Chests  (Reward: 10 Rare Power-Ups) 
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.OBTAIN_N_CASH_FROM_CHEST, [ChestType.SUPER], 1000, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP_CARD, Powerup.RARITY_RARE, 10));
			//- Gain *50 Power-ups* from Chests  (Reward: 10 power-up 2X) 
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.OBTAIN_N_POWERUPS_FROM_CHEST, [], 50, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.X2, 10));
			//- Gain *50 Power-ups* from Super Chests   (Reward: 250 Cash)
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.OBTAIN_N_POWERUPS_FROM_CHEST, [ChestType.SUPER], 50, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 250));
			
			
			
			//Bonus Quests:

			//- Get *a Bingo* while *2X* is activated (Reward: 10 Rare Power-Ups)
			rawResults.push(debugCreateQuestMessagePack(['B'], QuestObjective.COLLECT_N_BINGOS, ["x2"], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.POWERUP, Powerup.TRIPLE_DAUB, 10));
			//- Gain *3 Inventory* Items (Reward: 150 Cash) 
			rawResults.push(debugCreateQuestMessagePack(['B'], QuestObjective.COLLECT_N_CARDS, [CollectNCards.CUSTOMIZER], 3, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 150));
			//- Gain *10 Collectible* Cards (Reward: 100 Cash) 
			rawResults.push(debugCreateQuestMessagePack(['B'], QuestObjective.COLLECT_N_CARDS, [CollectNCards.COLLECTION], 10, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 100));
			//- Use *10/20 Rare* Power-ups (Reward: 1/2 Customization Items) 
			rawResults.push(debugCreateQuestMessagePack(['B'], QuestObjective.USE_N_POWERUPS, ["rarity", Powerup.RARITY_RARE], 10, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CUSTOMIZER, CustomizationType.CARD, 1, true, 10, true));
			rawResults.push(debugCreateQuestMessagePack(['B'], QuestObjective.USE_N_POWERUPS, ["rarity", Powerup.RARITY_RARE], 20, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CUSTOMIZER, CustomizationType.DAUB_ICON, 2, true, 10, true));
			//- Collect *10 Bonuses* from Cards (Reward: 50 Cash) - bonus
			rawResults.push(debugCreateQuestMessagePack(['B'], QuestObjective.CLAIM_N_POWERUPS, [], 10, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 50));
			rawResults.push(debugCreateQuestMessagePack(['B'], QuestObjective.CLAIM_N_POWERUPS, ["powerup", Powerup.XP], 5, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 150));
			rawResults.push(debugCreateQuestMessagePack(['B'], QuestObjective.CLAIM_N_POWERUPS, ["rarity", Powerup.RARITY_RARE], 5, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 250));
			//- Get *150 or more* Cash from one Scratch (Reward: 150 Cash) 
			rawResults.push(debugCreateQuestMessagePack(['B'], QuestObjective.WIN_N_CASH_IN_SCRATCH_CARD, [150], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 150));
			rawResults.push(debugCreateQuestMessagePack(['B'], QuestObjective.WIN_N_CASH_IN_SCRATCH_CARD, [], 150, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CASH, null, 100));
			//- Burn *10* of Anything (Reward: 1 Customization Items)
			rawResults.push(debugCreateQuestMessagePack(['B'], QuestObjective.BURN_N_CARDS, [], 10, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CUSTOMIZER, CustomizationType.VOICEOVER, 1, true, 10, true));
			//- Burn *5 Inventory* Items (Reward: 1 Customization Items)
			rawResults.push(debugCreateQuestMessagePack(['B'], QuestObjective.BURN_N_CARDS, [BurnNCards.CUSTOMIZER], 5, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CUSTOMIZER, CustomizationType.CARD, 1, true, 10, true));
			//- Burn *10 Collectible* Cards (Reward: 2 Collectible Items) (edited)
			rawResults.push(debugCreateQuestMessagePack(['B'], QuestObjective.BURN_N_CARDS, [BurnNCards.COLLECTION], 10, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.COLLECTION, CardType.NORMAL, 2, true, 10, true));
			
			// Tutor daily quest:
			rawResults.push(debugCreateQuestMessagePack(['D'], QuestObjective.PLAY_N_GAMES, [], 1, 0, (commonDuration != 0 ? commonDuration : 30), CommodityType.CHEST, ChestType.GOLD, 1, true, 666666666));
			
			var result:Array = [];
			for each (var item:Array in rawResults) 
			{
				result = result.concat(item);
			}
			
			return result;
		}
		
		private static var debugSerialQuestId:uint = 400000000;
		
		private function debugCreateQuestMessagePack(to:Array, objective:String, options:Array, goal:uint, tier:uint, duration:uint, rewardType:String, rewardSubtype:*, rewardQuantity:int, debug:Boolean = true, weight:int = 10, showTotalDialog:Boolean = false, minLevel:int = 0):Array
		{
			var pack:Array = [];
			var type:String;
			while (to.length > 0) 
			{
				type = to.shift();
				var questMessage:QuestDataMessage = new QuestDataMessage();
				
				questMessage.objectiveType = objective;
				questMessage.id = debugSerialQuestId++;
				questMessage.goal = goal;
				questMessage.tier = tier;
				questMessage.duration = duration;
				questMessage.options = options.join(',');
				questMessage.rewardType = rewardType;
				questMessage.rewardSubtype = String(rewardSubtype);
				questMessage.rewardQuantity = rewardQuantity;
				questMessage.weight = weight;
				questMessage.showTotalDialog = showTotalDialog;
				questMessage.enabled = true;
				questMessage.minLevel = minLevel;
				(questMessage as Object)['debug'] = debug;
				
				switch(type) 
				{
					case 'D': {
						questMessage.type = QuestType.DAILY_QUEST; 
						break;
					}
					case 'E': {
						questMessage.type = QuestType.EVENT_QUEST; 
						questMessage.duration = 60 * 60 * 49//Math.random() > 0.5 ? (60 * 60 * 24) : (60 * 60 * 49);
						break;
					}
					case 'B': {
						questMessage.type = QuestType.BONUS_QUEST; 
						//questMessage.duration = 60 * 60 * 2 //Math.random() > 0.5 ? (60 * 60) : (60*60 + Math.random()*60 * 60 * 3);
						break;
					}
					
					default : continue;
				}
				
				pack.push(questMessage);
			}
			return pack;
		}
		
		/*private function createQuestMessageFromArray(item:Array, type:String, reward:Array, debug:Boolean = false):QuestDataMessage
		{
			var questMessage:QuestDataMessage = new QuestDataMessage();
			questMessage.type = type;
			questMessage.objectiveType = item[0];
			questMessage.id = item[1];
			questMessage.goal = item[2];
			questMessage.tier = int(Math.random() * 3);
			questMessage.duration = 5 * 60;//Math.random() * 120 + 120;
			questMessage.options = item.slice(3).join(',');
			questMessage.rewardType = reward[0];
			questMessage.rewardSubtype = reward[1];
			questMessage.rewardQuantity = int(reward[2]);
			(questMessage as Object)['debug'] = debug;
			return questMessage;
		}*/
		
		public function debugGetQuestsByType(type:String = '', nullItemTitle:String = ''):Array
		{
			var list:Array = [];
			var quest:QuestBase;
			
			//var parsedFromServerOffers:Array = [];
			var localDebugQuests:Array = [];
			
			for each(quest in allQuests) 
			{
				if (quest.type != type)
					continue;
					
				if (quest.isDebug)
					localDebugQuests.push({text:quest.id + ': ' + quest.objectiveType + ' ' + quest.goal.toString(), object:quest});
				else
					list.push({text:quest.id + ': ' + quest.objectiveType, object:quest});
			}
			
			/*for each(quest in disabledQuestsById) 
			{
				if (quest.isDebug)
					localDebugQuests.push({text:quest.id + ': ' + quest.objectiveType, object:quest});
				else
					list.push({text:quest.id + ': ' + quest.objectiveType, object:quest});
			}*/
			
			list = list.concat(localDebugQuests);
			
			/*list.sort(function(a:Object, b:Object):int 
			{ 
				if (a.object.isDebug)
				{
					return 1;
				}
				if (b.object.isDebug)
				{
					return -1;
				}
				else
				{
					if (a.object.enabled)
						return -1;
					else if (b.object.enabled)
						return 1;
					else
						return 0;
				}
				
				return 0;
			});*/
					
			list.unshift({text:nullItemTitle, object:type});
			
			return list;
		}
		
		public function toClipboardDebugColors():void 
		{
			var string:String = 'quest colors:\n';
			
			if (QuestType.EVENT_QUEST in debugBgColorsList) {
				string += 'EVENT bg: 0x' + ((debugBgColorsList[QuestType.EVENT_QUEST] as Array)[debugBgColorsIndex[QuestType.EVENT_QUEST]] as uint).toString(16);
				if (QuestType.EVENT_QUEST in debugProgressColorsList) 
					string += ' progress: 0x' + ((debugProgressColorsList[QuestType.EVENT_QUEST] as Array)[debugProgressColorsIndex[QuestType.EVENT_QUEST]] as uint).toString(16);
					
				string += '\n';
			}
			
			if (QuestType.DAILY_QUEST in debugBgColorsList) {
				string += 'DAILY bg: 0x' + ((debugBgColorsList[QuestType.DAILY_QUEST] as Array)[debugBgColorsIndex[QuestType.DAILY_QUEST]] as uint).toString(16);
				if (QuestType.DAILY_QUEST in debugProgressColorsList) 
					string += ' progress: 0x' + ((debugProgressColorsList[QuestType.DAILY_QUEST] as Array)[debugProgressColorsIndex[QuestType.DAILY_QUEST]] as uint).toString(16);
					
				string += '\n';
			}
			
			if (QuestType.BONUS_QUEST in debugBgColorsList) {
				string += 'BONUS bg: 0x' + ((debugBgColorsList[QuestType.BONUS_QUEST] as Array)[debugBgColorsIndex[QuestType.BONUS_QUEST]] as uint).toString(16);
				if (QuestType.BONUS_QUEST in debugProgressColorsList) 
					string += ' progress: 0x' + ((debugProgressColorsList[QuestType.BONUS_QUEST] as Array)[debugProgressColorsIndex[QuestType.BONUS_QUEST]] as uint).toString(16);
					
				string += '\n';
			}
		
			//var file:FileReference = new FileReference();
			//file.save(string, "quests_" + SaveHTMLLog.getDateString(false) + ".txt");
			
			System.setClipboard(string);
		}
	}
}
