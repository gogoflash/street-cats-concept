package com.alisacasino.bingo.models.quests.questItems 
{
	import com.alisacasino.bingo.models.game.StakeData;
	import com.alisacasino.bingo.models.quests.IQuestNotifier;
	import com.alisacasino.bingo.models.quests.QuestModel;
	import com.alisacasino.bingo.models.quests.QuestObjective;
	import com.alisacasino.bingo.models.quests.QuestStyle;
	import com.alisacasino.bingo.models.quests.QuestType;
	import com.alisacasino.bingo.models.quests.QuestTypeSettings;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.ObjectiveType;
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.ICardData;
	import com.alisacasino.bingo.utils.AbsoluteVersion;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAQuestCompletedEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAQuestProgressUpdateEvent;
	import com.alisacasino.bingo.utils.clientData.ClientDataManager;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class QuestBase extends EventDispatcher implements IQuestItem
	{
		private var completionEventSent:Boolean;
		public var objectiveType:String;
		public var id:int;
		
		public var type:String;
		public var tier:uint;
		
		public var duration:int; //in seconds
		public var durationMs:Number;
		
		public var timeStart:int;
		public var styleHash:String;
		public var rewardClaimed:Boolean;
		public var skipped:Boolean;
		public var rendererAction:String;
		
		
		public var weight:int;
		public var minLevel:int = -1;
		public var maxLevel:int = -1;
		public var minLtv:int = -1;
		public var maxLtv:int = -1;
		public var minCash:int = -1;
		public var maxCash:int = -1;
		public var minPowerups:int = -1;
		public var maxPowerups:int = -1;
		public var minClientVersion:Number = 0;
		public var reward:CommodityItem;
		public var options:Array;
		
		public var showTotalDialog:Boolean// = true;
		
		public var enabled:Boolean;
		public var isDebug:Boolean;
		
		protected var _progress:int;
		protected var _reservedProgress:int;
		protected var _style:QuestStyle;
		
				
		protected var _goal:int;
		
		public function get goal():int 
		{
			return _goal;
		}
		
		public function isCompleted(considerReservedProgress:Boolean):Boolean
		{
			if (considerReservedProgress)
				return ((_progress - reservedProgress) >= goal) && goal > 0;
				
			return _progress >= goal && goal > 0;
		}
		
		public function get skipPrice():int
		{
			return getQuestTypeSettings().getPrice();
		}
		
		public function QuestBase() 
		{
		}
		
		public function reset():void 
		{
			_progress = 0;
			timeStart = 0;
			styleHash = null;
			rewardClaimed = false;
			skipped = false;
			_reservedProgress = 0;
			_style = null;
		}
		
		public function updateProgress(value:int, updateReserved:Boolean = true):void
		{
			var notCompletedBefore:Boolean = getProgress() < goal;
			
			if (value > 0 && notCompletedBefore)
			{
				gameManager.questModel.reservedProgress += value;
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAQuestProgressUpdateEvent(this));
			}
			
				
			_progress += value;
			
			if (updateReserved)
				_reservedProgress += value;
			
			dispatchEventWith(Event.CHANGE);
			
			if (_progress >= goal && goal > 0)
			{
				gameManager.questModel.dispatchEventWith(QuestModel.QUEST_COMPLETE, false, this);
				if (notCompletedBefore && !completionEventSent)
				{
					gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAQuestCompletedEvent(this));
					completionEventSent = true;
				}
			}
		}
		
		/*public function get progressRatio():Number
		{
			return Math.min(1, _progress/goal);
		}*/

		/*public function get progressString():String
		{
			return _progress.toString() + '/' + goal.toString();
		}*/
		
		public function setInitialProgress():void
		{
			_progress = 0;
		}
		
		public function getProgress():int
		{
			return _progress;
		}
		
		public function get reservedProgress():int {
			return _reservedProgress;
		}
		
		public function cleanReservedProgress():void {
			_reservedProgress = 0;
		}
		
		public function get expired():Boolean
		{
			return timeStart > 0 ? ((timeStart + duration) <= TimeService.serverTime) : false;
		}
		
		public function cardBurned(card:ICardData, quantity:int):void
		{
			
		}
		
		public function cardCollected(card:ICardData):void
		{
			
		}
		
		public function cashCollected(quantity:int, source:String):void
		{
			
		}
		
		public function powerupClaimedFromCard(powerup:String):void 
		{
			
		}
		
		public function powerupUsed(powerup:String):void
		{
			
		}
		
		public function chestOpened(type:int, rewards:Array):void
		{
			
		}
		
		public function bingoClaimed(x2Active:Boolean, placeInRound:int, bingoPatterns:Vector.<String>, stakeData:StakeData):void 
		{
			
		}
		
		public function scoreEarned(score:int, stakeData:StakeData):void
		{
			
		}
		
		public function daubRegistered(number:int):void
		{
			
		}
		
		public function daubStreakProgress(streak:int):void
		{
			
		}
		
		public function roundStart(numCards:int, stakeData:StakeData):void
		{
			
		}
		
		public function roundEnd(numCards:int, stakeData:StakeData):void
		{
			
		}
		
		public function get style():QuestStyle 
		{
			return _style;
		}
		
		public function set style(value:QuestStyle):void
		{
			_style = value;
			styleHash = value ? value.hash : null;
		}
		
		public function get targetString():String
		{
			return QuestObjective.getTargetStringByType(objectiveType, goal, style.textColor, options);
		}		
		
		protected function setGoal(goal:int):void 
		{
			_goal = goal;
			updateProgress(0);
			
			//_color == 0
		}
		
		public function get isTutor():Boolean
		{
			return weight == 666666666;
		}
		
		public function getDescription():String
		{
			return "Unknown";
		}
		
		public function deserialize(item:QuestDataMessage):void 
		{
			id = item.id;
			type = item.type;
			objectiveType = item.objectiveType;
			tier = item.tier;
			_goal = item.goal;
			duration = item.duration;
			durationMs = duration * 1000;
			weight = item.weight;
			showTotalDialog = item.showTotalDialog;
			enabled = item.enabled;
			minLevel = item.hasMinLevel ? item.minLevel : -1;
			maxLevel = item.hasMaxLevel ? item.maxLevel : -1;
			minLtv = item.hasMinLtv? item.minLtv: -1;
			maxLtv = item.hasMaxLtv? item.maxLtv: -1;
			minCash = item.hasMinCash? item.minCash: -1;
			maxCash = item.hasMaxCash? item.maxCash : -1;
			minPowerups = item.hasMinPowerups ? item.minPowerups : -1;
			maxPowerups = item.hasMaxPowerups ? item.maxPowerups : -1;
			
			reward = new CommodityItem(item.rewardType, int(Math.random() * 90 + 1));
			reward.subType = item.rewardSubtype;
			reward.quantity = item.rewardQuantity;
			
			minClientVersion = AbsoluteVersion.fromString(item.hasMinClientVersion ? item.minClientVersion : '0');
			
			options = parseOptions(item.options);
		}
		
		protected function parseOptions(value:String):Array {
			if (value == null || value == '')
				return [];
				
			return value.split(',');
		}
		
		public function get currentDuration():int {
			//return Math.min(quest.duration, TimeService.serverTime - quest.timeStart);
			return TimeService.serverTime - timeStart;
		}
		
		public function get currrentTimeout():int {
			return Math.max(0, timeStart + duration - TimeService.serverTime);
		}
		
		public function getQuestTypeSettings():QuestTypeSettings
		{
			return gameManager.questModel.getQuestTypeSettings(type);
		}
		
		public function deserializeSavedState(questStateRaw:Object):void 
		{
			timeStart = questStateRaw["timeStart"];
			
			_progress = parseInt(questStateRaw["progress"]);

			style = QuestStyle.getByHash(String(questStateRaw["styleHash"]));
			
			getQuestTypeSettings().tier = int(questStateRaw["skipTier"]);
			getQuestTypeSettings().passedQuestsCount = int(questStateRaw["passedQuestsCount"]);
			
			completionEventSent = Boolean(questStateRaw["completionEventSent"]);
			
			if (type == QuestType.DAILY_QUEST) 
			{
				duration = Math.min(Math.ceil(gameManager.tournamentData.endsAt / 1000) - timeStart, Math.ceil(gameManager.tournamentData.duration / 1000));
			}
		}
		
		public function serializeSavedState():Object
		{
			var result:Object = { };
			result["staticId"] = id;
			result["progress"] = getProgress();
			result["timeStart"] = timeStart;
			result["styleHash"] = styleHash;
			result["skipTier"] = getQuestTypeSettings().tier;
			result["completionEventSent"] = completionEventSent;
			result["passedQuestsCount"] = (getQuestTypeSettings().maxQuestsPerPeriod > 0 ? getQuestTypeSettings().passedQuestsCount : 0);
			
			return result;
		}
	}

}