package com.alisacasino.bingo.screens.questsScreenClasses 
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.components.AlertSignView;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.models.quests.QuestModel;
	import com.alisacasino.bingo.models.quests.questItems.QuestBase;
	import com.alisacasino.bingo.utils.EffectsManager;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class QuestBadgeView extends Sprite 
	{
		private var animation:AnimationContainer;
		//private var alertImage:Image;
		private var alertSignView:AlertSignView;
		private var isShowing:Boolean;
		private var isHiding:Boolean = true;
		
		public function QuestBadgeView() 
		{
			super();
			
			animation = new AnimationContainer(MovieClipAsset.PackCommon, false, true, 'quest_tablet');
			animation.pivotX = 120 * pxScale;
			animation.pivotY = 150 * pxScale;
			animation.x = animation.pivotX;
			animation.y = animation.pivotY;
			//animation.playTimeline('quest_tablet');
			//animation.stgoToAndStop(0);
			addChild(animation);
			
			addEventListener(TouchEvent.TOUCH, handler_touch);
			gameManager.questModel.addEventListener(QuestModel.CLEAN_RESERVED_PROGRESS, handler_reservedProgressChange);
			gameManager.questModel.addEventListener(QuestModel.QUEST_COMPLETE, handler_questComplete);
		}
	
		public function show(delay:Number):void
		{
			isHiding = false;
			
			if (isShowing) {
				if(!alertSignView || (alertSignView && !Starling.juggler.containsTweens(alertSignView)))
					handleAlarmSign(0.2);
				return;
			}
			
			handleAlarmSign(1.2);
		
			isShowing = true;	
			
			Starling.juggler.removeTweens(this);
			Starling.juggler.delayCall(internalShow, delay);
			
			gameManager.questModel.cleanReservedProgress(delay + 0.8);
		}
		
		public function hide(delay:Number):void
		{
			isShowing = false;
			
			setAlertSign(null, 0);
			
			if (isHiding)
				return;
		
			isHiding = true;	
			
			Starling.juggler.removeTweens(this);
			Starling.juggler.delayCall(internalHide, delay);
		}
		
		private function internalShow():void {
			//animation.goToAndPlay(0);
			animation.reverse = false;
			animation.play()//Timeline('quest_tablet');
			
		}
		
		private function internalHide():void {
			animation.reverse = true;
			animation.play()//Timeline('quest_tablet');
			
		}
		
		private function handler_touch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if (touch == null)
				return;

			if (touch.phase == TouchPhase.ENDED) 
			{
				//sosTrace("QuestBadge.handler_touch 1");
				if(!DialogsManager.instance.getDialogByClass(QuestsScreen))
					DialogsManager.addDialog(new QuestsScreen());	
			}
		}
		
		private function handleAlarmSign(delay:Number = 0):void 
		{
			var activeQuests:Vector.<QuestBase> = gameManager.questModel.activeQuests;
			var quest:QuestBase;
			var signText:String;
			var completedCount:int;
			for each (quest in activeQuests) 
			{
				if (quest.isCompleted(false)) {
					completedCount++;
				}
				else if (quest.expired) {
					signText = '!';
				}
			}
			
			if(completedCount > 0)
				signText = completedCount.toString();
			
			setAlertSign(signText, delay);
		}
		
		private function setAlertSign(value:String, delay:Number = 0):void 
		{
			if (value != null && value != '') 
			{
				if (!alertSignView) {
					alertSignView = new AlertSignView(value);
					alertSignView.x = 88 * pxScale;
					alertSignView.y = 106 * pxScale;
					alertSignView.touchable = false;
					addChild(alertSignView);
					EffectsManager.scaleJump(alertSignView, 0.8, true, delay);
				}
				else {
					Starling.juggler.removeTweens(alertSignView);
					alertSignView.scale = 1;
					alertSignView.text = value;
				}
			}
			else 
			{
				if (alertSignView) {
					Starling.juggler.removeTweens(alertSignView);
					EffectsManager.scaleJumpDisappear(alertSignView, 0.6, delay, removeAlertSign);
				}
			}
		}
		
		private function removeAlertSign():void {
			if (alertSignView) {
				alertSignView.removeFromParent();
				alertSignView = null;
			}
		}
		
		private function handler_reservedProgressChange(event:Event):void 
		{
			if (!isShowing || isHiding)
				return;
				
			EffectsManager.removeJump(animation);
			EffectsManager.jump(animation, int(event.data), 1, 1.1, 0.07, 0.04, 0.0, 0, 0, 1.8, true, false);
			
			//if(alertSignView)
				//EffectsManager.jump(alertSignView, 10, 1, 1.1, 0.07, 0.04, 0.0, 0, 0, 1.8, true, false);
		}
		
		private function handler_questComplete(e:Event):void 
		{
			if (!isHiding)
				handleAlarmSign(0.5);
		}
		
		public function get isReadyForJumping():Boolean {
			trace(isShowing && !isHiding && !animation.currentClip.inPlay, animation.currentClip.inPlay);
			return isShowing && !isHiding && !animation.currentClip.inPlay;
		}
		
		override public function dispose():void 
		{
			removeEventListener(TouchEvent.TOUCH, handler_touch);
			
			gameManager.questModel.removeEventListener(QuestModel.CLEAN_RESERVED_PROGRESS, handler_reservedProgressChange);
			gameManager.questModel.removeEventListener(QuestModel.QUEST_COMPLETE, handler_questComplete);
			
			super.dispose();
		}
	}
}
