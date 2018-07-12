package com.alisacasino.bingo.screens.lobbyScreenClasses
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.dialogCommands.ChestTakeOutCommand;
	import com.alisacasino.bingo.commands.dialogCommands.ShowStore;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.chests.ChestOpenDialog;
	import com.alisacasino.bingo.dialogs.chests.ChestPartsView;
	import com.alisacasino.bingo.dialogs.chests.ChestTakeOutDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.chests.ChestsData;
import com.alisacasino.bingo.models.notification.PushData;
	import com.alisacasino.bingo.models.universal.Price;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
import com.alisacasino.bingo.utils.GameManager;
import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAChestTimerStartedEvent;

	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	
	public class ChestsView extends FeathersControl
	{
		static public const STATE_INIT:String = "stateInit";
		static public const STATE_LOBBY:String = "stateLobby";
		static public const STATE_BUY_CARDS:String = "stateBuyCards";
		static public const STATE_WAIT_FOR_ROUND:String = "stateWaitForRound";
		static public const STATE_TO_GAME:String = "STATE_TO_GAME";
		
		private const GAP:Number = -5;
		private var _state:String = STATE_INIT;
		private var _previousState:String; 
		
		private var gameScreen:GameScreen;
				
		private var chests:Vector.<ChestSlotView>;
		
		private var chestOpenDialog:ChestOpenDialog;
		
		private var awardChestIcons:Array;
		
		private var appearY:Number = 0;
		
		private var extraScale:Number = 1;
		
		public function ChestsView(gameScreen:GameScreen, startState:String)
		{
			this.gameScreen = gameScreen;
			_state = startState;
			setSizeInternal(layoutHelper.stageWidth, layoutHelper.stageHeight, true);
			awardChestIcons = [];
			
			gameManager.chestsData.addEventListener(ChestsData.EVENT_REMOVE_AWARD_GIVE_OUT_CHEST, handler_removeAwardGiveOutChest);
			gameManager.chestsData.addEventListener(ChestsData.EVENT_CLOSE_CHEST_OPEN_DIALOG, closeChestOpenDialog);
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			if (_state != value)
			{
				_previousState = _state;
				_state = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		public function shakeSlots(slotIndex:int = 0):void
		{
			var length:int = chests.length;
			if (length == 0)
				return;
				
			slotIndex = Math.min(length-1, Math.max(0, slotIndex));
			
			var i:int;
			var chestView:ChestSlotView;
			for (i = slotIndex; i < length; i++) {
				jumpDownChestSlot(chests[i], 0.13, 15*pxScale, (i - slotIndex)*0.05);
			}
			
			for (i = slotIndex-1; i >= 0; i--) {
				jumpDownChestSlot(chests[i], 0.13, 15*pxScale, (slotIndex - i)*0.05);
			}
		}
		
		public function invalidateResize(appearY:Number, extraScale:Number):void
		{
			this.appearY = appearY;
			this.extraScale = extraScale;
			invalidate(INVALIDATION_FLAG_SIZE);	
			//validate();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			chests = new Vector.<ChestSlotView>();
			
			var chestView:ChestSlotView;
			//var startX:Number = chestsX;
			var i:int;
			for (i = 0; i < gameManager.chestsData.chests.length; i++) {
				chestView = new ChestSlotView(i, gameManager.chestsData.chests[i]);
				chestView.pivotX = ChestSlotView.WIDTH*pxScale/2;
				chestView.pivotY = ChestSlotView.HEIGHT*pxScale/2;
				addChild(chestView);
				chests.push(chestView);
			}
			
			addEventListener(Event.TRIGGERED, handler_chestSlotTriggered);
		}
		
		private function get actualScale():Number {
			return gameManager.layoutHelper.independentScaleFromEtalonMin;
		}
		
		private function get chestPivotY():Number {
			return ChestSlotView.HEIGHT*pxScale/2*actualScale * extraScale;
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			var i:int;
			var chestView:ChestSlotView;
			
			if (isInvalid(INVALIDATION_FLAG_SIZE)) 
			{
				var startX:Number = chestsX;
				for (i = 0; i < chests.length; i++) {
					chestView = chests[i];
					chestView.scale = actualScale * extraScale;
					chestView.x = startX + i * (chestView.width + GAP * pxScale * actualScale * extraScale) + chestView.pivotX*chestView.scale;
					if (state == STATE_BUY_CARDS)
						chestView.y = appearY + chestPivotY;
					else
						chestView.y = gameManager.layoutHelper.stageHeight + 25 * pxScale + chestPivotY;
					
					chestView.jumpHelper.scale = chestView.scale;
					//chestView.jumpHelper.setUncenteredJump(chestView.x, appearY, (ChestSlotView.WIDTH * pxScale * chestView.scale)/2, (ChestSlotView.HEIGHT * pxScale * chestView.scale)/2);	
				}
				
				alignChestOpenDialog();
			}
			
			if (isInvalid(INVALIDATION_FLAG_STATE))
			{
				removeAllTweens();
				
				if (state == STATE_INIT)
				{
					//tweensHide();
				}
				else if (state == STATE_LOBBY)
				{
					tweensHide();
					removeAwardChestIcons();
				}
				else if (state == STATE_BUY_CARDS)
				{
					if (_previousState == null) {
						// появление после окна результатов:
						moveHide();
						
						tweensToBuyCards(0.4, 0.15);
						takeOutNewAwardChests();
					}
					else {
						// переход из лобби:
						tweensToBuyCards();
						
						if (gameManager.chestsData.hasNewChests)
							takeOutNewAwardChests();
					}
				}
				else if (state == STATE_WAIT_FOR_ROUND)
				{
					
				}
				else if (state == STATE_TO_GAME)
				{
					tweensHide(0.35, 0.1);
					removeAwardChestIcons();
				}
			}
		}
		
		private function tweensToBuyCards(time:Number = 0.6, delay:Number = 0.4, delayBetween:Number = 0.1):void
		{
			var i:int;
			var chestView:ChestSlotView;
			for (i = 0; i < chests.length; i++) {
				chestView = chests[i];
				chestView.state = ChestSlotView.STATE_BUY_CARDS;
				Starling.juggler.tween(chestView, time, {transition:Transitions.EASE_OUT_BACK, delay:(delay + delayBetween*i), y:(appearY + chestPivotY)});
			}
		}
		
		private function tweensHide(time:Number = 0.6, delay:Number = 0, delayPerChest:Number = 0.1):void
		{
			var i:int;
			var chestView:ChestSlotView;
			for (i = 0; i < chests.length; i++) {
				chestView = chests[i];
				chestView.state = ChestSlotView.STATE_LOBBY;
				Starling.juggler.tween(chestView, time, {transition:Transitions.EASE_IN_BACK, delay:(delay + (chests.length - i - 1)*delayPerChest), y:(gameManager.layoutHelper.stageHeight + 25 * pxScale + chestPivotY)});
			}
		}
		
		private function moveHide():void
		{
			var i:int;
			var chestView:ChestSlotView;
			for (i = 0; i < chests.length; i++) {
				chestView = chests[i];
				chestView.state = ChestSlotView.STATE_LOBBY;
				chestView.y = gameManager.layoutHelper.stageHeight + 25 * pxScale + chestPivotY;
			}
		}
		
		private function showAwardChest(delay:Number, chestSlotView:ChestSlotView):void 
		{
			/*var chestSlotView:ChestSlotView = getEmptySlot(Math.floor((chests.length - 1) / 2));
			
			if (!chestSlotView)
				return;*/
			if (chestSlotView.data.isTakeOuting)
				return;
			
			chestSlotView.data.isTakeOuting = true;
				
			var startX:int = chestSlotView.x;// + chestSlotView.width / 2 + chestSlotView.pivotX;
			var startY:int = 0.42 * gameManager.layoutHelper.stageHeight;
			
			var finishX:int = startX;
			
				
			Starling.juggler.delayCall(showSplash, delay, 0, startX, startY);
		
			var awardChest:ChestPartsView = new ChestPartsView(chestSlotView.data.type, 0.78, null, 0, -14*pxScale);
			//awardChest.alignPivot();
			awardChest.name = chestSlotView.data.index.toString();
			//awardChest.alpha = 0.2;
			awardChest.x = startX;
			awardChest.y = startY;
			awardChest.touchable = false;
			addChild(awardChest);	
			awardChestIcons.push(awardChest);
		
			var finishY:int = appearY + chestPivotY;
			//finishY += -(awardChest.height/2) * chestSlotView.scale + 73 * chestSlotView.scale * pxScale + chestSlotView.data.chestIconShiftY * chestSlotView.scale;
			finishY += 12 * chestSlotView.scale * pxScale + chestSlotView.data.dropChestIconShiftY * chestSlotView.scale;
			
			awardChest.scale = 0;
			
			var tweenChest_0:Tween = new Tween(awardChest, 0.25, Transitions.EASE_OUT_BACK);
			var tweenChest_1:Tween = new Tween(awardChest, 0.2, Transitions.EASE_IN);
			var tweenChest_2:Tween = new Tween(awardChest, 0.08, Transitions.EASE_OUT);
			var tweenChest_3:Tween = new Tween(awardChest, 0.13, Transitions.EASE_OUT_BACK);
			
			tweenChest_0.delay = delay + 0.085;
			tweenChest_0.animate('scale', chestSlotView.scale);
			tweenChest_0.nextTween = tweenChest_1;
			
			tweenChest_1.delay = 0.2;
			tweenChest_1.animate('x', finishX);
			tweenChest_1.animate('y', finishY + 30*pxScale);
			tweenChest_1.animate('scaleX', 0.4 * chestSlotView.scale);
			tweenChest_1.animate('scaleY', 1.9 * chestSlotView.scale);
			tweenChest_1.nextTween = tweenChest_2;
			tweenChest_1.onStart = handleAwardGiveOutChest;
			tweenChest_1.onStartArgs = [chestSlotView];
			tweenChest_1.onComplete = shakeBackgroundAndSlots;
			tweenChest_1.onCompleteArgs = [chestSlotView];
			
			Starling.juggler.delayCall(chestSlotView.showSmokeExplosion, delay + 0.8);
			
			tweenChest_2.animate('y', finishY);
			tweenChest_2.animate('scaleX', 1.26 * chestSlotView.scale);
			tweenChest_2.animate('scaleY', 0.7 * chestSlotView.scale);
			tweenChest_2.nextTween = tweenChest_3;
			
			tweenChest_3.animate('scaleX', chestSlotView.scale);
			tweenChest_3.animate('scaleY', chestSlotView.scale);
			tweenChest_3.onComplete = completeAwardGiveOutChest;
			tweenChest_3.onCompleteArgs = [chestSlotView];
			
			Starling.juggler.add(tweenChest_0);
			
			SoundManager.instance.playSfx(SoundAsset.ChestDropV2, delay + 0.22);
		}
		
		private function shakeBackgroundAndSlots(chestSlotView:ChestSlotView):void
		{
			shakeSlots(chests.indexOf(chestSlotView));
			gameScreen.shakeBackground(ResizeUtils.SHAKE_Y_LINEAR);
		}
		
		private function handleAwardGiveOutChest(chestSlotView:ChestSlotView):void
		{
			if (chestSlotView.data.isNew) {
				chestSlotView.data.isNew = false;
				chestSlotView.data.isTakeOuting = false;
				chestSlotView.forceShowPadlockAndTime(0.2);
			}
		}
		
		private function completeAwardGiveOutChest(chestSlotView:ChestSlotView):void
		{
			chestSlotView.state = ChestSlotView.STATE_NEW_APPEAR;
			chestSlotView.validate();
			
			//chestSlotView.state = ChestSlotView.STATE_ACTIVATE;
			//chestSlotView.validate();
			
			if (!gameManager.tutorialManager.isChestTakeOutStepPassed && chestSlotView.data.openTimestamp > 0) {
				chestSlotView.state = ChestSlotView.STATE_READY;
				gameManager.tutorialManager.completeChestTakeOutStep();
			}
			
			//trace('ChestsView.completeAwardGiveOutChest', chestSlotView.data.index);
		}
		
		private function handler_removeAwardGiveOutChest(event:Event):void
		{
			//trace('handler_removeAwardGiveOutChest ', String(event.data));
			//return;
			var i:int;
			for (i = 0; i < awardChestIcons.length; i++) {
				//trace('remove ', (awardChestIcons[i] as DisplayObject).name , String(event.data));
				if ((awardChestIcons[i] as DisplayObject).name == String(event.data)) {
					(awardChestIcons[i] as DisplayObject).removeFromParent();
					awardChestIcons.splice(i, 1);
					return;
				}
			}
		}	
		
		private function removeAwardChestIcons():void
		{
			var i:int;
			var image:DisplayObject;
			while (i < awardChestIcons.length) {
				image = awardChestIcons[i] as DisplayObject;
				if (image && Starling.juggler.containsTweens(image)) {
					i++;
				}
				else {
					image.removeFromParent();
					awardChestIcons.removeAt(i);
				}
			}
		}
		
		private function showSplash(delay:Number, startX:int, startY:int):void
		{
			var animationContainer:AnimationContainer = new AnimationContainer(MovieClipAsset.PackBase, false, true);
			animationContainer.x = startX;
			animationContainer.y = startY;
			animationContainer.scale = 2;
			addChild(animationContainer);
			
			animationContainer.playTimeline('splash', true, false, 24);
			
			Starling.juggler.tween(animationContainer, 0.1, {transition:Transitions.LINEAR, delay:(delay + 0.25), scale:0, onComplete:removeAnimation, onCompleteArgs:[animationContainer]});
		}
		
		public function takeOutNewAwardChests():void {
			var i:int;
			for (i = 0; i < chests.length; i++) {
				if (chests[i].data.isNew) {
					showAwardChest(0.25, chests[i]);
					//trace('ChestsView.takeOutNewAwardChests ', i);
				}
			}
		}
		
		public function get chestsX():Number {
			return (gameManager.layoutHelper.stageWidth - getWidth()*extraScale)/2;
		}
		
		public function get chestsY():Number {
			return appearY;
		}
		
		public function getWidth(considerExtraScale:Boolean = false):Number {
			return (ChestsData.CHESTS_COUNT * ChestSlotView.WIDTH + (ChestsData.CHESTS_COUNT -1) * GAP) * pxScale * actualScale * (considerExtraScale ? extraScale : 1);
		}
		
		public function getHeight(considerExtraScale:Boolean = false):Number {
			return ChestSlotView.HEIGHT * pxScale * actualScale * (considerExtraScale ? extraScale : 1);
		}
		
		/*private function getEmptySlot(startIndex:int):ChestSlotView
		{
			// поиск в обе стороны от стартового индекса
			var i:int;
			var chestView:ChestSlotView;
			var length:int = chests.length;
			while ((startIndex - i) >=0 || (startIndex + i) < length) {
				if ((startIndex - i) >=0 && chests[startIndex - i].data.type == ChestType.NONE)
					return chests[startIndex - i];
				
				i++;
				
				if ((startIndex + i) < length && chests[startIndex + i].data.type == ChestType.NONE)
					return chests[startIndex + i];
			}
			
			return null;
		}*/
		
		private function handler_chestSlotTriggered(event:Event):void 
		{
			event.stopImmediatePropagation();
			
			if (_state == ChestsView.STATE_TO_GAME || _state == ChestsView.STATE_LOBBY)
				return;
			
			var chestSlotView:ChestSlotView = event.data as ChestSlotView;
			
			if (chestSlotView.data.type == ChestType.NONE) {
				closeChestOpenDialog();
				return;
			}
			
			if (chestSlotView.data.openTimestamp == 0) 
			{
				// диалог открытия:
				showChestOpenDialog(chestSlotView);
			}
			else 
			{
				closeChestOpenDialog();
				
				if (chestSlotView.data.isReadyToOpen) 
				{
					//if (gameManager.tutorialManager.chestFreeOpenId == chestSlotView.data.seed)
						//gameManager.tutorialManager.completeChestFreeOpenStep();
					
					// забрать готовый
					showChestTakeOutDialog(chestSlotView, false);
				}
				else {
					// диалог открытия в режиме покупки:
					showChestOpenDialog(chestSlotView, true);
				}
			}
		}
		
		private function showChestOpenDialog(chestSlotView:ChestSlotView, forMoney:Boolean = false):void
		{
			if (chestOpenDialog && chestOpenDialog.chestSlotView == chestSlotView)
				return;
			
			if(chestOpenDialog)
				chestOpenDialog.close();
				
			chestOpenDialog = new ChestOpenDialog(chestSlotView, forMoney || gameManager.chestsData.hasChestUnderTimeout, callback_chestOpenDialog, 0);
			chestOpenDialog.addEventListener(Event.REMOVED_FROM_STAGE, handler_chestOpenDialogRemovedFromStage);
			DialogsManager.addDialog(chestOpenDialog);
			
			alignChestOpenDialog();
		}
		
		private function alignChestOpenDialog():void
		{
			if (!chestOpenDialog)
				return;
			
			var chestSlotView:ChestSlotView = chestOpenDialog.chestSlotView;	
			var slotPoint:Point = localToGlobal(new Point(chestSlotView.x - chestSlotView.pivotX*chestSlotView.scale, chestSlotView.y - chestSlotView.pivotY*chestSlotView.scale));
			//trace('gg ', slotPoint, chestSlotView.localToGlobal(new Point(chestSlotView.x, chestSlotView.y)), (Game.current.currentScreen as DisplayObjectContainer).localToGlobal(new Point(chestSlotView.x, chestSlotView.y)));
			
			var dialogShiftX:int = slotPoint.x + chestSlotView.width / 2 - gameManager.layoutHelper.stageWidth / 2;
			var tailMaxShiftX:int = chestOpenDialog.backgroundWidth/*ChestOpenDialog.WIDTH*/ * chestOpenDialog.scale * pxScale * 0.34;
			
			var tailShiftX:int;
			if (Math.abs(dialogShiftX) > tailMaxShiftX) 
				tailShiftX = (dialogShiftX >= 0 ? 1 : -1) * tailMaxShiftX;
			else
				tailShiftX = dialogShiftX;
			
			chestOpenDialog.x = gameManager.layoutHelper.stageWidth / 2 + dialogShiftX - tailShiftX;
			chestOpenDialog.y = Math.max(chestOpenDialog.height * 1.1, slotPoint.y + chestSlotView.height * 0.11 - 33 * pxScale * chestOpenDialog.scale);
			
			chestOpenDialog.reposition(tailShiftX/chestOpenDialog.scale);
		}
			
		private function showChestTakeOutDialog(chestSlotView:ChestSlotView, forMoney:Boolean, price:Price = null):void
		{
			new ChestTakeOutCommand(chestSlotView.data, null, chestSlotView, false, forMoney ? ChestTakeOutCommand.RUSHED_SLOT : ChestTakeOutCommand.TIMED_SLOT, price).execute();
		}
		
		private function closeChestOpenDialog(e:Event = null):void
		{
			if (chestOpenDialog)
				chestOpenDialog.close();
		}
		
		private function handler_chestOpenDialogRemovedFromStage(event:Event = null):void
		{
			if (chestOpenDialog && event.target == chestOpenDialog) {
				chestOpenDialog.removeEventListener(Event.REMOVED_FROM_STAGE, handler_chestOpenDialogRemovedFromStage);
				chestOpenDialog = null;
			}
		}
		
		private function callback_chestOpenDialog(chestSlotView:ChestSlotView, forMoney:Boolean):void
		{
			if (forMoney) 
			{
				// show take out dialog
				
				var price:Price;
				if (!checkIfFreeToOpen(chestSlotView.data))
				{
					price = new Price(Type.CASH, chestSlotView.data.getCurrentOpenPrice());
				}
				
				if (purchase(chestSlotView.data)) {

                    chestSlotView.data.forceReady();
					chestSlotView.state = ChestSlotView.STATE_READY;
					
					Starling.juggler.delayCall(showChestTakeOutDialog, 0.25, chestSlotView, true, price);
				}
			}
			else 
			{
				chestSlotView.data.openTimestamp = TimeService.serverTime;
				
				PlatformServices.interceptor.sendLocalNotification(
                        GameManager.instance.pushData.getChestOpenedPush(),
						chestSlotView.data.openTimestamp + chestSlotView.data.openTimeout,
						PushData.PUSH_TITLE,
						0,
						PushData.CHEST_PUSH_ID + chestSlotView.data.id
				);

				var idleHours:int = 2 * 60 * 60;

                PlatformServices.interceptor.sendLocalNotification(
                        GameManager.instance.pushData.getChestOpenedIdlePush(),
                        chestSlotView.data.openTimestamp + chestSlotView.data.openTimeout + idleHours,
                        PushData.PUSH_TITLE,
                        0,
                        PushData.CHEST_PUSH_ID + 10 + chestSlotView.data.id
                );

				
				var isFreeTutorialChest:Boolean = false;
				
				if (!gameManager.tutorialManager.isChestFreeOpenStepPassed)
				{
					gameManager.tutorialManager.chestFreeOpenId = chestSlotView.data.seed;
					isFreeTutorialChest = true;
				}
				
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAChestTimerStartedEvent(chestSlotView.data, chests, isFreeTutorialChest));
					
				//chestSlotView.commitShowBlueAnimation = true;
				chestSlotView.state = ChestSlotView.STATE_ACTIVATE;
				SoundManager.instance.playSfx(SoundAsset.ChestActivate);
				gameManager.chestsData.sendDataToServer();
			}
		}
		
		private function checkIfFreeToOpen(chestData):Boolean
		{
			return gameManager.tutorialManager.chestFreeOpenId == chestData.seed;
		}
		
		private function purchase(chestData:ChestData):Boolean
		{
			if (checkIfFreeToOpen(chestData)) {
				gameManager.tutorialManager.completeChestFreeOpenStep();
				return true;
			}
			
			var chestPrice:int = chestData.getPrice(chestData.remainTime);
			if (Player.current.cashCount < chestPrice) {
				return false;
			}	
			
			Player.current.updateCashCount(-chestPrice, "chestRush:" + ChestsData.chestTypeToString(chestData.type));	
			
			Game.current.currentScreen.cashBar.animateToValue(Player.current.cashCount);
			
			return true;
		}
		
		private function jumpDownChestSlot(view:DisplayObject, time:Number, shiftY:int, delay:Number = 0):void
		{
			var tweenBack:Tween = new Tween(view, time * 0.7, Transitions.EASE_OUT_BACK);
			tweenBack.animate('y', appearY + chestPivotY);
			
			Starling.juggler.tween(view, time * 0.3, {transition:Transitions.EASE_OUT, delay:delay, y:(appearY + shiftY + chestPivotY), nextTween:tweenBack});
		}
		
		/*private function callback_chestTakeOutDialog(chestTakeOutDialog:ChestTakeOutDialog):void
		{
			///new ChestTakeOutCommand(chestTakeOutDialog.chestSlotView.data).execute();
			
			//chestTakeOutDialog.chestSlotView.data.clean();
			//chestSlotView.state = ChestSlotView.STATE_BUY_CARDS;
			
			//chestTakeOutDialog.chestSlotView.invalidate();
			
			//gameManager.chestsData.sendDataToServer();			
			
			//gameScreen.lobbyUI.showCollectionDrops(chestTakeOutDialog.collectionDropItems);
		}*/
		
		private function removeAnimation(animationContainer:AnimationContainer):void
		{
			animationContainer.removeFromParent();
			animationContainer.dispose();
		}
		
		override public function dispose():void 
		{
			gameManager.chestsData.removeEventListener(ChestsData.EVENT_REMOVE_AWARD_GIVE_OUT_CHEST, handler_removeAwardGiveOutChest);
			gameManager.chestsData.removeEventListener(ChestsData.EVENT_CLOSE_CHEST_OPEN_DIALOG, closeChestOpenDialog);
			
			removeEventListener(Event.TRIGGERED, handler_chestSlotTriggered);
			
			removeAllTweens();
			
			while (chests.length > 0) {
				chests.shift().dispose();
			}
			
			super.dispose();
		}
		
		private function removeAllTweens():void
		{	
			var i:int;
			var length:int = chests.length;
			for (i = 0; i < length; i++) {
				Starling.juggler.removeTweens(chests[i]);
			}
		}
		
		public function tutorialClean():void
		{
			var i:int;
			var length:int = chests.length;
			for (i = 0; i < length; i++) {
				chests[i].tutorialStepHideFreeOpenChest();
			}
		}
	}
}