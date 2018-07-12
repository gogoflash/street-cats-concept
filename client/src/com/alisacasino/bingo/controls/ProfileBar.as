package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.dialogs.ProfileDialog;
	import com.alisacasino.bingo.models.Player;
	import starling.textures.Texture;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ProfileBar extends Sprite
	{
		private var mPlayer:Player;
		private var mLobbyAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		private var mCommonAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		private var mBase:Image;
		private var mBtn:XButton;
		private var mGlass:Image;
		private var mStar:Image;
		private var mAvatar:XImage;
		private var mXpLevelLabel:XTextField;
		
		public function ProfileBar()
		{
			mPlayer = Player.current;
			
			var name:String = "unknown";
			var xpLevel:int = 1;
			var playerID:int = 0;
			var pictureURL:String = null;
			
			if (mPlayer)
			{
				name = mPlayer.firstName;
				xpLevel = mPlayer.xpLevel;
				playerID = mPlayer.playerId;
				pictureURL = Player.getAvatarURL(mPlayer.avatarSource, mPlayer.facebookId);
			}
			else
			{
				sosTrace("No current player, profile bar created with default values", SOSLog.WARNING);
			}
			
			mBase = new Image(mLobbyAtlas.getTexture("lobby/profile_base"));
			mGlass = new Image(mLobbyAtlas.getTexture("lobby/profile_base_glass"));
			mBtn = new XButton(XButtonStyle.ProfileButtonStyle, name);
			mStar = new Image(mLobbyAtlas.getTexture("lobby/exp_mini"));
			var xpLevelLabelWidth:Number = mStar.width * 0.8;
			var xpLevelLabelHeight:Number = mStar.height * 0.8;
			mXpLevelLabel = new XTextField(xpLevelLabelWidth, xpLevelLabelHeight, XTextFieldStyle.ProfileBarXpLevelTextFieldStyle);
			mXpLevelLabel.numValue = xpLevel;
			var defaultTexture:Texture = mCommonAtlas.getTexture("avatars/" + String(playerID % 5 + 1));
			if (!defaultTexture)
			{
				defaultTexture = AtlasAsset.getEmptyTexture();
			}
			mAvatar = new XImage(defaultTexture, pictureURL);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			mBtn.addEventListener(Event.TRIGGERED, showProfileDialog);
		}
		
		private function onAddedToStage(e:Event):void
		{
			addChild(mBase);
			addChild(mAvatar);
			addChild(mGlass);
			addChild(mStar);
			addChild(mXpLevelLabel);
			addChild(mBtn);
			
			mBtn.pivotX = mBtn.width / 2;
			mBtn.pivotY = mBtn.height / 2;
			mBtn.x = mBase.width * 0.66;
			mBtn.y = mBase.height * 0.4;
			
			mAvatar.pivotX = mAvatar.width / 2;
			mAvatar.pivotY = mAvatar.height / 2;
			
			mAvatar.x = mBase.width * 0.175;
			mAvatar.y = mBase.height * 0.44;
			
			mGlass.pivotX = mGlass.width / 2;
			mGlass.pivotY = mGlass.height / 2;
			mGlass.x = mBase.width * 0.16;
			mGlass.y = mBase.height * 0.42;
			
			mStar.pivotX = mStar.width / 2;
			mStar.pivotY = mStar.height / 2;
			mStar.x = mBase.width * 0.35;
			mStar.y = mBase.height * 0.83;
			
			mXpLevelLabel.pivotX = mXpLevelLabel.width / 2;
			mXpLevelLabel.pivotY = mXpLevelLabel.height / 2;
			mXpLevelLabel.x = mBase.width * 0.34;
			mXpLevelLabel.y = mStar.y;
			
			pivotX = width / 2;
			pivotY = height / 2;
		}
		
		private function showProfileDialog(e:Event):void
		{
			new ProfileDialog().show();
		}
	}
}