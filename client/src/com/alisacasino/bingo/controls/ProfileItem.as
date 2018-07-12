package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ProfileItem extends Sprite
	{
		private var mLobbyAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		private var mPlate:Image;
		private var mNameLabel:XTextField;
		private var mValueLabel:XTextField;
		
		public function ProfileItem(name:String, value:uint)
		{
			mPlate = new Image(mLobbyAtlas.getTexture("dialogs/profile/plate"));
			mNameLabel = new XTextField(0.55 * mPlate.width, 0.8 * mPlate.height, XTextFieldStyle.ProfileItemTextFieldStyle, name);
			mValueLabel = new XTextField(0.3 * mPlate.width, 0.8 * mPlate.height, XTextFieldStyle.DialogTextFieldStyle);
			mValueLabel.numValue = value;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			addChild(mPlate);
			addChild(mNameLabel);
			mNameLabel.x = 0.04 * mPlate.width;
			mNameLabel.y = mPlate.height - mNameLabel.height >> 1;
			addChild(mValueLabel);
			mValueLabel.x = 0.63 * mPlate.width;
			mValueLabel.y = mPlate.height - mNameLabel.height >> 1;
		}
	}
}