package com.alisacasino.bingo.screens.resultsUIClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.screens.resultsUIClasses.LeaderboardItemRenderer;
	import com.alisacasino.bingo.models.LiveEventLeaderboardPosition;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage;
	import com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.DelayCallUtils;
	import com.alisacasino.bingo.utils.UIUtils;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.netease.protobuf.UInt64;
	import feathers.controls.List;
	import feathers.controls.supportClasses.ListDataViewPort;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import treefortress.sound.SoundInstance;
	
	public class LeaderboardListView extends FeathersControl
	{
		public static var DEBUG:Boolean = false;
		public var DUMMY_PLAYERS_COUNT:int = 60;
		
		public var DELAY_CALL_SOUND_SFX_LOOP_BUNDLE:String = 'DELAY_CALL_SOUND_SFX_LOOP_BUNDLE';
		
		private var blurFilter:BlurFilter;
		private var playerPlaque:LeaderboardItemRenderer;
		private var list:List;
		private var dataProvider:ListCollection;
		private var starsExplosion:ParticleExplosion;
		
		private var haveEventData:Boolean;
		private var needToLaunchAnimation:Boolean;
		private var animating:Boolean;
		private var playerPositionData:LiveEventLeaderboardPosition;
		private var leaderboardData:LiveEventScoreUpdateOkMessage;
		private var dialogRemoved:Boolean;
		private var playerOldPositionIndex:int;
		private var playerPositionIndex:int;
		private var playerOldRank:int;
		private var playerRank:int;
		
		private var debugQuad:Quad;
		
		private var animateTime:Number;
		private var tweenCompleteFunction:Function;
		private var hideSkipFunction:Function;
		private var isLiftUp:Boolean;
		private var skipAnimation:Boolean;
		
		private var baseWidth:int;
		private var baseHeight:int;
		
		private var watchDogHideSkipId:int = -1;
		
		private var playerOneRankPlaceDifferenceMode:Boolean;
		
		private var userEqualOldPlayerRankPositionData:LiveEventLeaderboardPosition;
		private var loadingAnimation:AnimationContainer;
		
		public function LeaderboardListView(tweenCompleteFunction:Function, hideSkipFunction:Function, baseWidth:int, baseHeight:int) 
		{
			this.tweenCompleteFunction = tweenCompleteFunction;
			this.hideSkipFunction = hideSkipFunction;
			this.baseWidth = baseWidth;
			this.baseHeight = baseHeight;
			
			addEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.useVirtualLayout = true;
			
			list = new List();
			list.layout = listLayout;
			list.itemRendererType = LeaderboardItemRenderer;
			list.touchable = Constants.isDevFeaturesEnabled;
			list.elasticity = 1;
			list.hasElasticEdges = true;
			
			list.setSize(baseWidth, baseHeight);
			
			list.validate();
			
			addChild(list);
			
			
			if (DEBUG) {
				debugQuad = new Quad(1, 1, 0x0000aa);
				debugQuad.alpha = 0.9;
				//addChildAt(debugQuad, 0);
				
				//createDebugData();
			}
			
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE)) 
			{
				if (debugQuad) {
					debugQuad.width = baseWidth;
					debugQuad.height = baseHeight;
				}
			
				list.setSize(baseWidth, baseHeight);
				
				alignPreloaderAnimation();
			}
		}
		
		public function animate():void
		{
			watchDogHideSkipId = Starling.juggler.delayCall(callHideSkip, 8);
			
			removeEventListener(Event.ENTER_FRAME, handler_enterFrameHoldOldPosition);
			
			if (haveEventData)
			{
				launchAnimation();
			}
			else
			{
				needToLaunchAnimation = true;
			}
			
			//setInterval(function():void {list.verticalScrollPosition = 154 }, 3000); 
		}
		
		public function skipAnimate():void
		{
			removeEventListener(Event.ENTER_FRAME, handler_enterFrameHoldOldPosition);
			
			needToLaunchAnimation = false;
			animating = false;	
			
			if (!haveEventData) {
				skipAnimation = true;
			}
			else 
			{
				forceComplete();
			}

			DelayCallUtils.cleanBundle(DELAY_CALL_SOUND_SFX_LOOP_BUNDLE);
			SoundManager.instance.stopSfxLoop(SoundAsset.LeaderboardFrameMoveLoop, 0.2);
		}
		
		public function setData(liveEventScoreUpdateOkMessage:LiveEventScoreUpdateOkMessage):void 
		{
			leaderboardData = liveEventScoreUpdateOkMessage;
			prepareData();
			
			showPreloaderAnimation = !Boolean(leaderboardData);
		}
		
		private function prepareData():void 
		{
			if (animating || haveEventData)
			{
				return;
			}
			
			if (!leaderboardData)
			{
				// зачистка?
				return;
			}
			
			var ranks:Array = [];
			var positionList:Object = {};
			
			var leaderboardPositionMessage:LiveEventLeaderboardPositionMessage;
			var liveEventLeaderboardPosition:LiveEventLeaderboardPosition
			var positionIndex:int;
			
			//debugTracePositions();
			
			// Запихиваем в список себя старого:
			liveEventLeaderboardPosition = new LiveEventLeaderboardPosition(leaderboardData.oldPosition);
			liveEventLeaderboardPosition.hidden = true;
			playerOldRank = liveEventLeaderboardPosition.rank;
			ranks.push(playerOldRank);
			positionList[playerOldRank] = liveEventLeaderboardPosition;
			
			// и себя нового:
			playerPositionData = new LiveEventLeaderboardPosition(leaderboardData.currentPosition);
			playerPositionData.hidden = true;
			playerRank = playerPositionData.rank;
			if (playerOldRank != playerRank) {
				ranks.push(playerRank);
				positionList[playerPositionData.rank] = playerPositionData;
			}
			else {
				trace(' > leaderboard view player dont change rank');
			}
			
			isLiftUp = playerRank < playerOldRank;
			
			playerOneRankPlaceDifferenceMode = Math.abs(playerRank - playerOldRank) == 1;
			
			// Запихиваем в список новых соседей:
			for each (leaderboardPositionMessage in leaderboardData.currentNeighbours) 
			{
				// вместо старого места плеера ставим плеера занявшего это место из нового списка
				if (playerOneRankPlaceDifferenceMode && leaderboardPositionMessage.liveEventRank == playerOldRank) {
					if(ranks.indexOf(playerOldRank) != -1)
						ranks.splice(ranks.indexOf(playerOldRank), 1);
					delete positionList[playerOldRank];
				}
				
				if(leaderboardPositionMessage.liveEventRank in positionList)
					continue;
					
				liveEventLeaderboardPosition = new LiveEventLeaderboardPosition(leaderboardPositionMessage);
				
				ranks.push(liveEventLeaderboardPosition.rank);
				positionList[liveEventLeaderboardPosition.rank] = liveEventLeaderboardPosition;
			}
			
			// Запихиваем в список старых соседей:
			//var isPlayerOldRank:Boolean;
			for each (leaderboardPositionMessage in leaderboardData.oldNeighbours) 
			{
				//isPlayerOldRank = leaderboardPositionMessage.liveEventRank == playerOldRank;
				
				if (/*isLiftUp && */leaderboardPositionMessage.liveEventRank == playerOldRank) {
					liveEventLeaderboardPosition = new LiveEventLeaderboardPosition(leaderboardPositionMessage);
					liveEventLeaderboardPosition.hidden = true;
					positionList[liveEventLeaderboardPosition.rank] = liveEventLeaderboardPosition;
					userEqualOldPlayerRankPositionData = liveEventLeaderboardPosition;
				}
				else {
					if(leaderboardPositionMessage.liveEventRank in positionList)
						continue;
					
					liveEventLeaderboardPosition = new LiveEventLeaderboardPosition(leaderboardPositionMessage);
					ranks.push(liveEventLeaderboardPosition.rank);
					positionList[liveEventLeaderboardPosition.rank] = liveEventLeaderboardPosition;
				}
			}
			
			// Сортируем всех по ранку
			ranks.sort(Array.NUMERIC);
			
			//debugCheckPositionList(positionList);
			
			// Собираем актуальный список:
			dataProvider = new ListCollection(fillData(positionList, ranks, playerOldRank, playerRank, DUMMY_PLAYERS_COUNT));
			list.dataProvider = dataProvider;
			
			// Находим свои позиции:
			playerOldPositionIndex = -1;
			playerPositionIndex = -1;
			
			var i:int;
			var length:int = dataProvider.length;
			for (i = 0; i < length; i++) {
				liveEventLeaderboardPosition = dataProvider.getItemAt(i) as LiveEventLeaderboardPosition;
				if (liveEventLeaderboardPosition.hidden) {
					if (liveEventLeaderboardPosition.rank == playerOldRank && playerOldPositionIndex == -1)
						playerOldPositionIndex = i;
						
					if (liveEventLeaderboardPosition.rank == playerRank && playerPositionIndex == -1)
						playerPositionIndex = i;
				}
			}
			
			// Когда позиция плеера в самом конце внутренний механизм List меняет позицию. Правочный хак: 
			if (playerOldPositionIndex >= (list.dataProvider.length - 1))
				addEventListener(Event.ENTER_FRAME, handler_enterFrameHoldOldPosition);
			
			// сеттим старую позицию плеера: 
			handler_enterFrameHoldOldPosition(null);
			
			var plaqueDataCopy:LiveEventLeaderboardPosition = playerPositionData.copy();
			plaqueDataCopy.hidden = false;
			
			if (!playerPlaque) {
				playerPlaque = new PlayerLeaderboardItemRenderer();
				addChild(playerPlaque);
			}
			
			playerPlaque.index = liveEventLeaderboardPosition.rank;
			playerPlaque.data = plaqueDataCopy;
			//playerPlaque.validate();
			playerPlaque.alignPivot();
			playerPlaque.x = baseWidth / 2;
			playerPlaque.y = baseHeight / 2;
			playerPlaque.touchable = false;
			
			if (playerOldPositionIndex == 0 && playerPositionIndex == 0)
				playerPlaque.y = 0.5 * LeaderboardItemRenderer.ITEM_HEIGHT * pxScale;
			
			haveEventData = true;
			
			if (skipAnimation) {
				forceComplete();
				return;
			}
			
			if (needToLaunchAnimation)
				launchAnimation();
		}
		
		private function fillData(positions:Object, ranks:Array, playerOldRankValue:int=0, playerRankValue:int=0, dummyPlayersCount:int=0):Array
		{
			var i:int;
			var length:int = ranks.length;
			var returnArray:Array = [];
			
			if (length == 0)
				return returnArray;
			
			var rankValue:int;
			var previousRankValue:int = ranks[0];
			var playerOldRankIndex:int;
			var playerRankIndex:int;
			var hasRankBreak:Boolean;
			var rankBreakValue:int;
			for (i = 0; i < length; i++) 
			{
				previousRankValue = i == 0 ? ranks[0] : rankValue;
				rankValue = ranks[i];
				
				rankBreakValue = Math.max(rankBreakValue, Math.abs(rankValue - previousRankValue));
				//trace(rankBreakValue, rankValue - previousRankValue);
				if(rankBreakValue > 1)
					hasRankBreak = true;
					
				returnArray.push(positions[rankValue]);
				
				if(rankValue == playerOldRankValue)
					playerOldRankIndex = i;
				
				if(rankValue == playerRankValue)
					playerRankIndex = i;
			}
			
			/*if (playerRankValue >= playerOldRankValue) {
				// опустились в ранке. 
				isLiftUp = false;
				//return returnArray;
			}*/
			
			if (!hasRankBreak) {
				// поднялись по списку выше и разрыв небольшой
				return returnArray;
			}
			
			// если поднялись по списку выше и при этом слишком большой разрыв вставляем пустышек:
		
			rankBreakValue--;
			var dummyPushCount:int = 0;  Math.min(rankBreakValue, dummyPlayersCount - Math.abs(playerOldRankIndex - playerRankIndex));
			//trace(rankBreakValue);	
			if (playerOldRankValue != playerOldRankValue)
				dummyPushCount = Math.min(rankBreakValue, dummyPlayersCount - Math.abs(playerOldRankIndex - playerRankIndex));
				
			if (dummyPushCount > 0)
			{
				var dummyStartIndex:int = Math.max(0, playerOldRankIndex + (playerRankIndex - playerOldRankIndex ) / 2 - 1);
				var dummyStartRank:int = ranks[dummyStartIndex];
				var dummyStartScore:int = Math.floor((positions[dummyStartRank] as LiveEventLeaderboardPosition).score);
				//trace('>> ', dummyPushCount, dummyStartIndex, dummyStartRank, playerRankIndex , playerOldRankIndex);	
				while (dummyPushCount > 0) 
				{
					var positionData:LiveEventLeaderboardPosition = new LiveEventLeaderboardPosition(null);
					positionData.rank = dummyStartRank + dummyPushCount;
					positionData.score = Math.max(0, dummyStartScore - dummyPushCount);
					
					returnArray.splice(dummyStartIndex + 1, 0, positionData);
					
					dummyPushCount--;
				}
			}
			
			return returnArray;
		}
		
		private function launchAnimation():void
		{
			if (animating || !haveEventData)
				return;
			
			animating = true;
			
			//list.verticalScrollPosition = oldScrollPosition;
			
			var playerPositionDiff:int = Math.abs(playerPositionIndex - playerOldPositionIndex);
			//trace(' > ', playerPositionDiff);
			if (playerPositionDiff <= 2) {
				animateTime = 0.6;
			}
			else if (playerPositionDiff <= 6) {
				animateTime = 0.9;
			}
			else if (playerPositionDiff <= 20) {
				animateTime = 1.5;
			}
			else if (playerPositionDiff <= 50) {
				animateTime = 2;
			}
			else {
				animateTime = 2.5;
			}
			
			if (!isLiftUp) {
				animateTime /= 1.5;
			}
			
			var isPlaceChanged:Boolean = playerOldPositionIndex != playerPositionIndex;
			
			var tweenPlaque_1:Tween = new Tween(playerPlaque, (isLiftUp || !isPlaceChanged) ? 0.07 : 0.2, (isLiftUp || !isPlaceChanged) ? Transitions.EASE_IN : Transitions.EASE_OUT);
			var tweenPlaque_0:Tween = new Tween(playerPlaque, isPlaceChanged ? animateTime : 0.5, isPlaceChanged ? Transitions.LINEAR : Transitions.EASE_IN);
		
			if (isPlaceChanged) 
			{
				tweenPlaque_0.animate('scale', isLiftUp ? 1.1 : 1.05);
			}
			else
			{
				tweenPlaque_0.animate('scale', 1.12);
			}
			
			if (playerPositionIndex == 0) 
				tweenPlaque_0.animate('y', 0.5 * LeaderboardItemRenderer.ITEM_HEIGHT * pxScale);
			
			tweenPlaque_0.nextTween = tweenPlaque_1;
			
			tweenPlaque_1.animate('scale', 1);
			tweenPlaque_1.onComplete = (isLiftUp || !isPlaceChanged) ? shakeUIs : null;
			tweenPlaque_1.onCompleteArgs = [isLiftUp];
			//tweenPlaque_0.onCompleteArgs = (isLiftUp || !isPlaceChanged) ? [0.07) : 0.15];
			tweenPlaque_1.onStart = SoundManager.instance.playSfx;
			tweenPlaque_1.onStartArgs = [SoundAsset.LeaderboardFrameHit];
			
			Starling.juggler.add(tweenPlaque_0);
			
			//Starling.juggler.delayCall(shakeUIs, animateTime + 0.02);
			
			if (playerPositionDiff >= 40)
			{
				blurFilter = new BlurFilter(0, 0, 1);
				list.filter = blurFilter;
				
				var tweenFilter_0:Tween = new Tween(blurFilter, 0.3, Transitions.LINEAR);
				var tweenFilter_1:Tween = new Tween(blurFilter, 0.3, Transitions.LINEAR);
				
				tweenFilter_0.delay = 0.7;
				tweenFilter_0.animate('blurY', 5);
				tweenFilter_0.nextTween = tweenFilter_1;
				
				tweenFilter_1.delay = Math.max(0, animateTime - 1.6);
				tweenFilter_1.animate('blurY', 0);
				tweenFilter_1.onComplete = removeBlurFilter;
				
				Starling.juggler.add(tweenFilter_0);
			}
			
			/*var tweenList:Tween = new Tween(list, 0.1, Transitions.EASE_IN);
			tweenList.animate('verticalScrollPosition', targetScrollPosition);
			tweenList.onComplete = onScrollComplete;
			
			var preTargetPosition:int = targetScrollPosition + (isLiftUp ? (-1) : (1)) * 30 * pxScale * scale;
			Starling.juggler.tween(list, animateTime - 0.15 - tweenList.totalTime, {delay:0.15, verticalScrollPosition:preTargetPosition, nextTween:tweenList, transition:Transitions.EASE_IN_OUT});*/
		
			Starling.juggler.tween(list, animateTime - 0.15, {delay:0.15, verticalScrollPosition:targetScrollPosition, onComplete:onScrollComplete, transition:Transitions.EASE_IN_OUT});
			if(userEqualOldPlayerRankPositionData && userEqualOldPlayerRankPositionData.currentRenderer)
				userEqualOldPlayerRankPositionData.currentRenderer.appearHiddenRenderer(0.42);
			
			if (animateTime > 1) {
				DelayCallUtils.add(Starling.juggler.delayCall(SoundManager.instance.playSfxLoop, 0.5, SoundAsset.LeaderboardFrameMoveLoop, 0.742, 0.1, 0.3), DELAY_CALL_SOUND_SFX_LOOP_BUNDLE);
				DelayCallUtils.add(Starling.juggler.delayCall(SoundManager.instance.stopSfxLoop, animateTime - 0.25, SoundAsset.LeaderboardFrameMoveLoop, 0.04), DELAY_CALL_SOUND_SFX_LOOP_BUNDLE);
			}
			
		}
		
		private function removeBlurFilter():void
		{
			list.filter = null
		}
		
		private function get targetScrollPosition():Number {
			if (playerPositionIndex == 0)
				return 0;
			
			return (playerPositionIndex + 0.5) * LeaderboardItemRenderer.ITEM_HEIGHT * pxScale - list.height / 2;
		}
		
		private function get oldScrollPosition():Number 
		{
			var oldPositionIndex:int = playerOldPositionIndex;
			
			// чтобы скролл выглядел красивее и дырка с соседнего места не была видна прыгаем через 1 место:
			if (playerOneRankPlaceDifferenceMode)
				oldPositionIndex += oldPositionIndex < playerPositionIndex ? -1 : 1;
			
			if (playerOldPositionIndex == 0 && playerPositionIndex == 0)
				oldPositionIndex = 1;
				
			return (oldPositionIndex + 0.5) * LeaderboardItemRenderer.ITEM_HEIGHT * pxScale - list.height / 2;
		}
		
		private function shakeUIs(showStarsExplosion:Boolean, shakeListDelay:Number = 0):void
		{
			if (showStarsExplosion)
			{
				starsExplosion = new ParticleExplosion(AtlasAsset.LoadingAtlas, "misc/white_star", null, 20);
				starsExplosion.setProperties(0, 20*pxScale, 4, -0.03, 0.07, 0, 1);
				starsExplosion.setFineProperties(0.6, 0.8, 0.5, 1.2, 0.5, 2);
				starsExplosion.setEmitDirectionAngleProperties(1, Math.PI, Math.PI);
				//starsExplosion.x = playerPlaque.x + playerPlaque.width/2;
				starsExplosion.y = playerPlaque.y;
				addChildAt(starsExplosion, 0);
				
				starsExplosion.play(170, 30);
				
				starsExplosion = new ParticleExplosion(AtlasAsset.LoadingAtlas, "misc/white_star", null, 20);
				starsExplosion.setProperties(0, 20*pxScale, 4, -0.03, 0.07, 0, 1);
				starsExplosion.setFineProperties(0.6, 0.8, 0.5, 1.2, 0.5, 2);
				starsExplosion.setEmitDirectionAngleProperties(1, 0, Math.PI);
				starsExplosion.x = playerPlaque.x + playerPlaque.width/2;
				starsExplosion.y = playerPlaque.y;
				addChildAt(starsExplosion, 0);
				
				starsExplosion.play(170, 30);
			}
			
			if (tweenCompleteFunction != null)
				tweenCompleteFunction(true);
			
			// твин раздвига рендереров	
			shakeList(18*pxScale, shakeListDelay);
		}
		
		private function shakeList(amplitude:int, delay:Number = 0):void
		{
			var tweenListGap_0:Tween = new Tween(list.layout, 0.1, Transitions.EASE_IN);
			var tweenListGap_1:Tween = new Tween(list.layout, 0.25, Transitions.EASE_OUT_BACK);
			
			tweenListGap_0.delay = delay;
			tweenListGap_0.animate('gap', amplitude);
			tweenListGap_0.nextTween = tweenListGap_1;
			
			tweenListGap_1.animate('gap', 0);
			
			Starling.juggler.add(tweenListGap_0);
			
			
			var tweenScrollPosition_0:Tween = new Tween(list, 0.1, Transitions.EASE_IN);
			var tweenScrollPosition_1:Tween = new Tween(list, 0.25, Transitions.EASE_OUT_BACK);
			
			tweenScrollPosition_0.delay = delay;
			tweenScrollPosition_0.animate('y', -amplitude);
			tweenScrollPosition_0.animate('height', list.height + 2*amplitude);
			tweenScrollPosition_0.animate('verticalScrollPosition', (list.verticalScrollPosition + amplitude*(playerPositionIndex)) - amplitude);
			tweenScrollPosition_0.nextTween = tweenScrollPosition_1;
			
			tweenScrollPosition_1.animate('y', 0);
			tweenScrollPosition_1.animate('height', list.height);
			tweenScrollPosition_1.animate('verticalScrollPosition', list.verticalScrollPosition);
			
			Starling.juggler.add(tweenScrollPosition_0);
			
			
			if (playerPositionIndex == 0) 
			{
				var tweenPlaque_0:Tween = new Tween(playerPlaque, 0.1, Transitions.EASE_IN);
				var tweenPlaque_1:Tween = new Tween(playerPlaque, 0.25, Transitions.EASE_OUT_BACK);
				 
				tweenPlaque_0.animate('y', playerPlaque.y-amplitude);
				tweenPlaque_0.nextTween = tweenPlaque_1;
				
				tweenPlaque_1.animate('y', playerPlaque.y);
				
				Starling.juggler.add(tweenPlaque_0);
			}
			
			//var viewPort:ListDataViewPort = list.viewPort as ListDataViewPort;
		}
		
		private function onScrollComplete():void
		{
			if (dialogRemoved)
				return;
			
			//SoundManager.instance.stopSfxLoop(SoundAsset.LeaderboardFrameMoveLoop, 0.2);
				
				
			callHideSkip();
			
			animating = false;	
			//Starling.juggler.tween(playerPlaque, 0.5, {scale: 1, transition: Transitions.EASE_OUT_BOUNCE, onComplete: onPlaqueBounceComplete});
			
			//SoundManager.instance.playSfx(SoundAsset.SfxLeaderboardPlaqueThump);
		}
		
		private function forceComplete():void 
		{
			removeBlurFilter();
			
			Starling.juggler.removeTweens(playerPlaque);
			Starling.juggler.removeTweens(list);
			
			if (playerPositionIndex == 0) 
				playerPlaque.y = 0.5 * LeaderboardItemRenderer.ITEM_HEIGHT * pxScale;
			
			playerPlaque.scale = 1;
			
			list.verticalScrollPosition = targetScrollPosition;
			
			if (isLiftUp)
				shakeUIs(isLiftUp);
		}
		
		private function callHideSkip():void 
		{
			if (watchDogHideSkipId != -1)
				Starling.juggler.removeByID(watchDogHideSkipId);
				
			if(hideSkipFunction != null)
				hideSkipFunction();	
		}
		
		private function handler_enterFrameHoldOldPosition(e:Event):void 
		{
			list.verticalScrollPosition = oldScrollPosition;
		}
		
		private function handler_removedFromStage(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, handler_enterFrameHoldOldPosition);
			removeEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
		}
		
		public function set showPreloaderAnimation(value:Boolean):void 
		{
			if (value)
			{
				if (!loadingAnimation) {
					loadingAnimation = new AnimationContainer(MovieClipAsset.PackBase);
					loadingAnimation.pivotX = 42 * pxScale;
					loadingAnimation.pivotY = 42 * pxScale;
					loadingAnimation.playTimeline('loading_white', false, true, 24);
					addChild(loadingAnimation);
				}
				alignPreloaderAnimation();
			}
			else
			{
				if (loadingAnimation) {
					loadingAnimation.removeFromParent();
					loadingAnimation = null;
				}
			}
		}
		
		private function alignPreloaderAnimation():void 
		{
			if (loadingAnimation) {
				loadingAnimation.x = (width/2)/scale;
				loadingAnimation.y = (height/2)/scale;
			}
		}
		
		/****************************************************************************************************************************
		 *
		 * Debug
		 * 
		 ****************************************************************************************************************************/
		
		public function debugPlayWidthNewData():void
		{
			createDebugData(10, 10, 50, 0);
			animate();
		}
		
		/*private function createDebugPositionData(playerPositionNew:int):LiveEventLeaderboardPosition
		{
			var positionMessage:LiveEventLeaderboardPositionMessage = new LiveEventLeaderboardPositionMessage();
			positionMessage.liveEventRank = playerPositionNew + 1;
			positionMessage.liveEventScore = UInt64.fromNumber(int(Math.random() * 100));
			positionMessage.player = Game.connectionManager.createPlayerMessageFromPlayer(Player.current);
			
			var position:LiveEventLeaderboardPosition = new LiveEventLeaderboardPosition(positionMessage);
			return position;
		}*/
		
		public function createDebugData(neighborsTotalCount:uint = 60, minRank:int = 50, minOldRank:int = 50, randomizeRank:int = 200, isTopPlayer:Boolean = false):void 
		{
			//createSpecialDebugData2();
			//return;
			
			haveEventData = false;
			animating = false;
			
			leaderboardData = new LiveEventScoreUpdateOkMessage();
			
			leaderboardData.currentNeighbours = debugCreateCurrentNeighbors(neighborsTotalCount/2, Math.random()*randomizeRank + minRank, isTopPlayer ? 0 : (neighborsTotalCount/4) );
			var currentPositionIndex:int = isTopPlayer ? 0 : (neighborsTotalCount/4);
			leaderboardData.currentPosition = leaderboardData.currentNeighbours[currentPositionIndex];
			leaderboardData.currentNeighbours.splice(currentPositionIndex, 1);
			
			leaderboardData.oldNeighbours = debugCreateCurrentNeighbors(neighborsTotalCount/2, Math.random()*randomizeRank + minOldRank, neighborsTotalCount/4);
			var oldPositionIndex:int = neighborsTotalCount / 4;
			leaderboardData.oldPosition = leaderboardData.oldNeighbours[oldPositionIndex];
			leaderboardData.oldNeighbours.splice(oldPositionIndex, 1);
			
			
			//leaderboardData.currentNeighbours = leaderboardData.currentNeighbours.concat(debugCreateCurrentNeighbors(1, 2, 20));
			
			prepareData();
		}
		
		private function debugCreateCurrentNeighbors(count:uint = 20, startPosition:Number = 200, playerIndex:int = 10):Array 
		{
			var positions:Array = [];
			var scoreStart:int = (startPosition+1) * 200;
			var scoreDecrement:int = Math.floor(scoreStart / count);
			for (var i:int = 0; i < count; i++) 
			{
				var positionMessage:LiveEventLeaderboardPositionMessage = new LiveEventLeaderboardPositionMessage();
				var playerMessage:PlayerMessage = new PlayerMessage();
				
				if (i == playerIndex)
				{
					playerMessage = Game.connectionManager.createPlayerMessageFromPlayer(Player.current);
				}
				else
				{
					playerMessage.playerId = UInt64.fromNumber(int(Math.random() * int.MAX_VALUE));
					playerMessage.firstName = playerMessage.playerId.toString(36);
				}
				
				positionMessage.player = playerMessage;
				positionMessage.liveEventRank = startPosition + i;
				positionMessage.liveEventScore = UInt64.fromNumber(scoreStart);
				scoreStart -=  scoreDecrement;
				
				positions.push(positionMessage);
			}
			
			return positions;
		}
		
		private function debugCreateLiveEventLeaderboardPositionMessage(rank:Number = 200, score:int = 10, playerName:String = 'Player fake'):LiveEventLeaderboardPositionMessage  
		{
			var positionMessage:LiveEventLeaderboardPositionMessage = new LiveEventLeaderboardPositionMessage();
			var playerMessage:PlayerMessage = new PlayerMessage();
			
			playerMessage.playerId = UInt64.fromNumber(int(Math.random() * int.MAX_VALUE));
			playerMessage.firstName = playerName;
			
			positionMessage.player = playerMessage;
			positionMessage.liveEventRank = rank;
			positionMessage.liveEventScore = UInt64.fromNumber(score);
			
			return positionMessage;
		}
		
		private function debugTracePositions():void 
		{
			var leaderboardPositionMessage:LiveEventLeaderboardPositionMessage;
			
			trace('me old ', leaderboardData.oldPosition.player.firstName, leaderboardData.oldPosition.liveEventRank, leaderboardData.oldPosition.liveEventScore.toNumber());
			trace('me current ', leaderboardData.currentPosition.player.firstName, leaderboardData.currentPosition.liveEventRank, leaderboardData.currentPosition.liveEventScore.toNumber());
			var minRankInList:int = int.MAX_VALUE;
			var maxRankInList:int = 0;
			for each (leaderboardPositionMessage in leaderboardData.currentNeighbours) 
			{
				trace('current ', leaderboardPositionMessage.player.firstName, leaderboardPositionMessage.liveEventRank, leaderboardPositionMessage.liveEventScore.toNumber());
				if (leaderboardPositionMessage.liveEventRank < minRankInList)
					minRankInList = leaderboardPositionMessage.liveEventRank;
				if (leaderboardPositionMessage.liveEventRank > maxRankInList)
					maxRankInList = leaderboardPositionMessage.liveEventRank;
			}
			
			for each (leaderboardPositionMessage in leaderboardData.oldNeighbours) 
			{
				trace('old ', leaderboardPositionMessage.player.firstName, leaderboardPositionMessage.liveEventRank, leaderboardPositionMessage.liveEventScore.toNumber());
				if (leaderboardPositionMessage.liveEventRank < minRankInList)
					minRankInList = leaderboardPositionMessage.liveEventRank;
				if (leaderboardPositionMessage.liveEventRank > maxRankInList)
					maxRankInList = leaderboardPositionMessage.liveEventRank;
			}
		}
		
		private function debugCheckPositionList(list:Object):void 
		{
			
		}
		
		
		/****************************************************************************************************************************
		 *
		 * Debug special cases
		 * 
		 ****************************************************************************************************************************/
		
		public function createDebugNoChangePositionFirstPlace():void 
		{
			haveEventData = false;
			animating = false;
			
			leaderboardData = new LiveEventScoreUpdateOkMessage();
			
			var newPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(0, 12, 'Debug player');
			var oldPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(0, 11, 'Debug player');
			
			leaderboardData.currentPosition = newPlayerPositionMessage;
			leaderboardData.oldPosition = oldPlayerPositionMessage;
			
			leaderboardData.currentNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(1, 9, 'Debug guest 1'),
				debugCreateLiveEventLeaderboardPositionMessage(2, 9, 'Debug guest 2')
			];
			
			leaderboardData.oldNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(2, 8, 'Debug guest 3')
			];
			
			prepareData();
		} 
		
		public function createDebugNoChangePositionMiddlePlace():void 
		{
			haveEventData = false;
			animating = false;
			
			leaderboardData = new LiveEventScoreUpdateOkMessage();
			
			var newPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(4, 12, 'Debug player');
			var oldPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(4, 11, 'Debug player');
			
			leaderboardData.currentPosition = newPlayerPositionMessage;
			leaderboardData.oldPosition = oldPlayerPositionMessage;
			
			leaderboardData.currentNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(0, 9, 'Debug guest 0'),
				debugCreateLiveEventLeaderboardPositionMessage(1, 9, 'Debug guest 1'),
				debugCreateLiveEventLeaderboardPositionMessage(2, 9, 'Debug guest 2'),
				debugCreateLiveEventLeaderboardPositionMessage(3, 9, 'Debug guest 3')
			];
			
			leaderboardData.oldNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(5, 9, 'Debug guest 5'),
				debugCreateLiveEventLeaderboardPositionMessage(6, 9, 'Debug guest 6'),
				debugCreateLiveEventLeaderboardPositionMessage(7, 9, 'Debug guest 7'),
				debugCreateLiveEventLeaderboardPositionMessage(8, 9, 'Debug guest 8')
			];
			
			prepareData();
		} 
		
		public function createDebugNoChangePositionLastPlace():void 
		{
			haveEventData = false;
			animating = false;
			
			leaderboardData = new LiveEventScoreUpdateOkMessage();
			
			var newPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(4, 12, 'Debug player');
			var oldPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(4, 11, 'Debug player');
			
			leaderboardData.currentPosition = newPlayerPositionMessage;
			leaderboardData.oldPosition = oldPlayerPositionMessage;
			
			leaderboardData.currentNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(0, 9, 'Debug guest 1'),
				debugCreateLiveEventLeaderboardPositionMessage(1, 9, 'Debug guest 2'),
				debugCreateLiveEventLeaderboardPositionMessage(2, 9, 'Debug guest 1'),
				debugCreateLiveEventLeaderboardPositionMessage(3, 9, 'Debug guest 1')
			];
			
			leaderboardData.oldNeighbours = 
			[
				//debugCreateLiveEventLeaderboardPositionMessage(2, 8, 'Debug guest 3')
			];
			
			prepareData();
		} 
		 
		public function createDebugOnePositionChangeUp():void 
		{
			haveEventData = false;
			animating = false;
			
			leaderboardData = new LiveEventScoreUpdateOkMessage();
			
			var newPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(0, 12, 'Debug player');
			var oldPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(1, 11, 'Debug player');
			
			leaderboardData.currentPosition = newPlayerPositionMessage;
			leaderboardData.oldPosition = oldPlayerPositionMessage;
			
			leaderboardData.currentNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(1, 9, 'Debug guest 1')
			];
			
			leaderboardData.oldNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(2, 8, 'Debug guest 2')
			];
			
			prepareData();
		}
		
		public function createDebugOnePositionChangeUp1():void 
		{
			haveEventData = false;
			animating = false;
			
			leaderboardData = new LiveEventScoreUpdateOkMessage();
			
			var newPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(3, 12, 'Debug player');
			var oldPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(4, 11, 'Debug player');
			
			leaderboardData.currentPosition = newPlayerPositionMessage;
			leaderboardData.oldPosition = oldPlayerPositionMessage;
			
			leaderboardData.currentNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(1, 9, 'Debug guest 1'),
				debugCreateLiveEventLeaderboardPositionMessage(2, 9, 'Debug guest 2'),
				debugCreateLiveEventLeaderboardPositionMessage(4, 9, 'Debug guest 3'),
				debugCreateLiveEventLeaderboardPositionMessage(5, 9, 'Debug guest 5')
			];
			
			leaderboardData.oldNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(6, 8, 'Debug guest 6'),
				debugCreateLiveEventLeaderboardPositionMessage(7, 8, 'Debug guest 7')
			];
			
			prepareData();
		}
		
		
		public function createDebugOnePositionChangeUp2():void 
		{
			haveEventData = false;
			animating = false;
			
			leaderboardData = new LiveEventScoreUpdateOkMessage();
			
			var newPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(1, 12, 'Debug player');
			var oldPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(2, 11, 'Debug player');
			
			leaderboardData.currentPosition = newPlayerPositionMessage;
			leaderboardData.oldPosition = oldPlayerPositionMessage;
			
			leaderboardData.currentNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(0, 9, 'Debug guest 0'),
				debugCreateLiveEventLeaderboardPositionMessage(2, 9, 'Debug guest 1'),
			];
			
			leaderboardData.oldNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(1, 8, 'Debug guest 1ok')
			];
			
			prepareData();
		}
		
		
		
		public function createDebugOnePositionChangeDown():void 
		{
			haveEventData = false;
			animating = false;
			
			leaderboardData = new LiveEventScoreUpdateOkMessage();
			
			var newPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(1, 12, 'Debug player');
			var oldPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(0, 11, 'Debug player');
			
			leaderboardData.currentPosition = newPlayerPositionMessage;
			leaderboardData.oldPosition = oldPlayerPositionMessage;
			
			leaderboardData.currentNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(2, 9, 'Debug guest 1'),
				debugCreateLiveEventLeaderboardPositionMessage(0, 8, 'Debug guest 0')
			];
			
			leaderboardData.oldNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(0, 8, 'Debug guest 2')
			];
			
			prepareData();
		}
		
		public function createDebugOnePositionChangeDown1():void 
		{
			haveEventData = false;
			animating = false;
			
			leaderboardData = new LiveEventScoreUpdateOkMessage();
			
			var newPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(4, 11, 'Debug player');
			var oldPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(3, 12, 'Debug player');
			
			leaderboardData.currentPosition = newPlayerPositionMessage;
			leaderboardData.oldPosition = oldPlayerPositionMessage;
			
			leaderboardData.currentNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(1, 9, 'Debug guest 1'),
				debugCreateLiveEventLeaderboardPositionMessage(2, 9, 'Debug guest 2'),
				debugCreateLiveEventLeaderboardPositionMessage(3, 9, 'Debug guest 2'),
				debugCreateLiveEventLeaderboardPositionMessage(4, 9, 'Debug guest 3'),
				debugCreateLiveEventLeaderboardPositionMessage(5, 9, 'Debug guest 5')
			];
			
			leaderboardData.oldNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(6, 8, 'Debug guest 6'),
				debugCreateLiveEventLeaderboardPositionMessage(7, 8, 'Debug guest 7')
			];
			
			prepareData();
		}
		
		public function createDebugOnePositionChangeDown2():void 
		{
			haveEventData = false;
			animating = false;
			
			leaderboardData = new LiveEventScoreUpdateOkMessage();
			
			var newPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(2, 12, 'Debug player');
			var oldPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(1, 11, 'Debug player');
			
			leaderboardData.currentPosition = newPlayerPositionMessage;
			leaderboardData.oldPosition = oldPlayerPositionMessage;
			
			leaderboardData.currentNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(0, 9, 'Debug guest 0'),
				debugCreateLiveEventLeaderboardPositionMessage(1, 9, 'Debug guest 1'),
			];
			
			leaderboardData.oldNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(1, 8, 'Debug guest 1ok')
			];
			
			prepareData();
		}
		
		public function createDebugTwoPositionChangeUp():void 
		{
			haveEventData = false;
			animating = false;
			
			leaderboardData = new LiveEventScoreUpdateOkMessage();
			
			var newPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(0, 12, 'Debug player');
			var oldPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(2, 11, 'Debug player');
			
			leaderboardData.currentPosition = newPlayerPositionMessage;
			leaderboardData.oldPosition = oldPlayerPositionMessage;
			
			leaderboardData.currentNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(1, 9, 'Debug guest 1'),
				debugCreateLiveEventLeaderboardPositionMessage(3, 9, 'Debug guest 3'),
				debugCreateLiveEventLeaderboardPositionMessage(4, 9, 'Debug guest 4')
			];
			
			leaderboardData.oldNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(2, 8, 'Debug guest 2')
			];
			
			prepareData();
		}
		
		
		
		
		
		public function createDebugOnePositionChangeDown3():void 
		{
			haveEventData = false;
			animating = false;
			
			leaderboardData = new LiveEventScoreUpdateOkMessage();
			
			var newPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(180, 120, 'My new player');
			var oldPlayerPositionMessage:LiveEventLeaderboardPositionMessage = debugCreateLiveEventLeaderboardPositionMessage(180, 0, 'My old player');
			
			leaderboardData.currentPosition = newPlayerPositionMessage;
			leaderboardData.oldPosition = oldPlayerPositionMessage;
			
			leaderboardData.currentNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(178, 210, 'Debug guest 178'),
				debugCreateLiveEventLeaderboardPositionMessage(179, 190, 'Debug guest 179'),
				
				debugCreateLiveEventLeaderboardPositionMessage(181, 0, 'Debug guest 181'),
				debugCreateLiveEventLeaderboardPositionMessage(182, 0, 'Debug guest 182')
			];
			
			leaderboardData.oldNeighbours = 
			[
				debugCreateLiveEventLeaderboardPositionMessage(179, 190, 'Old guest 179'),
				debugCreateLiveEventLeaderboardPositionMessage(181, 0, 'Old guest 181')
			];
			
			prepareData();
		}
		
	}
	
}
