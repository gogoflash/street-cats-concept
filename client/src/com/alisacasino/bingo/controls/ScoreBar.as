package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.dialogs.leaderboardDialogClasses.LeaderboardDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.utils.GameManager;
	
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ScoreBar extends Sprite implements IResourceBar
	{
		private var mBase:Image;
		private var mChip:Image;
		private var mLeaderboardsBtn:XButton;
		private var mLabel:XTextField;
		private var mPlayer:Player = Player.current;
		
		public function ScoreBar()
		{
			var scale:Number = pxScale;
			super();
			mBase = new Image(AtlasAsset.CommonAtlas.getTexture("bars/score_base"));
			mChip = new Image(AtlasAsset.CommonAtlas.getTexture("bars/score"));
			mLeaderboardsBtn = new XButton(XButtonStyle.BarLeaderboardsButtonStyle, "Leaderboards");
			mLabel = new XTextField(90*scale, 50*scale, XTextFieldStyle.ResourceBarTextFieldStyle);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			value = mPlayer.currentLiveEventScore;
		}
		
		public function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addChild(mBase);

			mLabel.pivotX = mLabel.width / 2;
			mLabel.pivotY = mLabel.height / 2;
			mLabel.x = mBase.width * 0.53;
			mLabel.y = mBase.height * 0.41;
			addChild(mLabel);
			
			mLeaderboardsBtn.pivotX = mLeaderboardsBtn.width / 2;
			mLeaderboardsBtn.pivotY = mLeaderboardsBtn.height / 2;
			mLeaderboardsBtn.x = mBase.width * 0.54;
			mLeaderboardsBtn.y = mBase.height * 0.9;
			mLeaderboardsBtn.addEventListener(Event.TRIGGERED, onLeaderboardsBtnClick);
			addChild(mLeaderboardsBtn);
			
			mChip.pivotX = mChip.width * 0.56;
			mChip.pivotY = mChip.height / 2;
			mChip.x = 0;
			mChip.y = mBase.height * 0.45;
			addChild(mChip);

			pivotX = width / 2 - mChip.width / 2;
			pivotY = mBase.height / 2;
		}
		
		public function set value(value:uint):void
		{
			mLabel.numValue = value;
		}
		
		public function getImageRect(targetSpace:DisplayObject):Rectangle
		{
			return mChip.getBounds(targetSpace);
		}
		
		public function animateToValue(newValue:uint, duration:Number=1.0, delay:Number = 0.0):void
		{
			mLabel.animateToValue(newValue, duration, delay);
		}
		
		private function onLeaderboardsBtnClick(..._):void
		{
			//var leaderboardsDialog:LeaderboardDialog = new LeaderboardDialog(Room.current.roomType.activeEventID);
			//leaderboardsDialog.requestLeaderboardsAndProbablyShow();
		}


	}
}