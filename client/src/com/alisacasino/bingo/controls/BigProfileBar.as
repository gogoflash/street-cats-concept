package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.Player;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BigProfileBar extends Sprite
	{
		private var mPlayer:Player = Player.current;
		private var mLobbyAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		private var mCommonAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		private var mBase:Image;
		private var mGlass:Image;
		private var mStar:Image;
		private var mAvatar:XImage;
		private var mAvatarGlass:Image;
		private var mXpLevelLabel:XTextField;
		private var mXpCountLabel:XTextField;
		private var mFillStart:Image;
		private var mFillCenter:Image;
		private var mFillEnd:Image;
		
		public function BigProfileBar()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			mBase = new Image(mLobbyAtlas.getTexture("dialogs/profile/exp_base"));
			addChild(mBase);
			
			mAvatar = new XImage(mCommonAtlas.getTexture("avatars/"+String(mPlayer.playerId%5+1)), Player.getAvatarURL(mPlayer.avatarSource, mPlayer.facebookId, 85*pxScale, 85*pxScale));
			addChild(mAvatar);
			mAvatar.x = mBase.width * 0.085;
			mAvatar.y = mBase.height * 0.22;
			
			mAvatarGlass = new Image(mLobbyAtlas.getTexture("lobby/profile_base_glass"));
			addChild(mAvatarGlass);
			mAvatarGlass.x = mBase.width * 0.085;
			mAvatarGlass.y = mBase.height * 0.21;
			
			mFillStart = new Image(mLobbyAtlas.getTexture("dialogs/profile/fill_start"));
			mFillCenter = new Image(mLobbyAtlas.getTexture("dialogs/profile/fill_mid"));
			mFillCenter.tileGrid = new Rectangle();
			mFillEnd = new Image(mLobbyAtlas.getTexture("dialogs/profile/fill_end"));
			addChild(mFillStart);
			addChild(mFillCenter);
			addChild(mFillEnd);
			
			mXpCountLabel = new XTextField(0.62 * mBase.width, 0.3 * mBase.height, XTextFieldStyle.BigProfileBarTextFieldStyle);
			mXpCountLabel.x = 0.28 * mBase.width;
			mXpCountLabel.y = 0.29 * mBase.height;
			addChild(mXpCountLabel);
			
			mGlass = new Image(mLobbyAtlas.getTexture("dialogs/profile/glass"));
			addChild(mGlass);
			mGlass.x = 0.285 * mBase.width;
			mGlass.y = 0.26 * mBase.height;

			mStar = new Image(mLobbyAtlas.getTexture("dialogs/profile/exp_mini"));
			addChild(mStar);
			mStar.x = mBase.width * 0.265 - mStar.width * 0.5;
			mStar.y = mBase.height * 0.7 - mStar.height * 0.5;
			
			var xpLevelLabelWidth:Number = mStar.width * 0.8;
			var xpLevelLabelHeight:Number = mStar.height * 0.8;
			mXpLevelLabel = new XTextField(xpLevelLabelWidth, xpLevelLabelHeight, XTextFieldStyle.ProfileBarXpLevelTextFieldStyle);
			addChild(mXpLevelLabel);
			mXpLevelLabel.numValue = mPlayer.xpLevel;
			mXpLevelLabel.x = mBase.width * 0.26 - mXpLevelLabel.width * 0.5;
			mXpLevelLabel.y = mBase.height * 0.7 - mXpLevelLabel.height * 0.5;
			
			numValue = mPlayer.xpCount;
		}
		
		private function set numValue(value:Number):void
		{
			var xpLevel:uint = gameManager.gameData.getLevelForXp(value);
			mXpLevelLabel.numValue = xpLevel;
			
			var ratio:Number = 1.0; 
			
			if (xpLevel < gameManager.gameData.maxLevel) {
				var xpCountThisLevel:uint = gameManager.gameData.getXpCountForLevel(xpLevel);
				var xpCountNextLevel:uint = gameManager.gameData.getXpCountForLevel(xpLevel + 1);
				ratio = (value - xpCountThisLevel) / (xpCountNextLevel - xpCountThisLevel);
				mXpCountLabel.text = String(value - xpCountThisLevel) + " / " + String(xpCountNextLevel - xpCountThisLevel); 
			} else {
				mXpCountLabel.text = "Max level";
			}
			
			var maxFillWidth:Number = 0.63 * mBase.width;
			var minFillWidth:Number = mFillStart.width + mFillEnd.width;
			var fillWidth:int = minFillWidth + (maxFillWidth - minFillWidth) * ratio;
			
			mFillStart.x = 0.28 * mBase.width;
			mFillCenter.x = mFillStart.x + mFillStart.width;
			mFillCenter.width = fillWidth - mFillStart.width - mFillEnd.width;
			mFillEnd.x = mFillCenter.x + mFillCenter.width;
			
			mFillStart.y = mFillCenter.y = mFillEnd.y = 0.28 * mBase.height;
		}
	}
}