package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.utils.GameManager;
	import starling.text.TextFieldAutoSize;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class PlayerBingoedPlate extends Sprite
	{
		private var mGameManager:GameManager = GameManager.instance;
		private var mGameAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		private var mCommonAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		private var mBack:Image;
		private var mQuad:Quad;
		private var mAvatar:XImage;
		private var mCrown:Image;
		private var mName:XTextField;
		private var mCoin:Image;
		private var mTicket:Image;
		private var mScore:Image;
		private var mCoinsWon:XTextField;
		private var mTicketsWon:XTextField;
		private var mScoreWon:XTextField;
		
		private var ticketsWon:int;
		private var scoreWon:int;
		
		private var stringsContainer:Sprite;
		
		public function PlayerBingoedPlate(player:Player, place:int, coinsWon:int, ticketsWon:int, scoreWon:int)
		{
			this.ticketsWon = ticketsWon;
			this.scoreWon = scoreWon;

			if (mGameManager.layoutHelper.isLargeScreen)
				mBack = new Image(mGameAtlas.getTexture("game/players_plate_tablet"));
			else
				mBack = new Image(mGameAtlas.getTexture("game/players_plate"));
			mAvatar = new XImage(mCommonAtlas.getTexture("avatars/"+String(player.playerId%5+1)), player.pictureURL);
			mAvatar.scaleX = mAvatar.scaleY = 0.85;
			mQuad = new Quad(mAvatar.width + 4 * pxScale, mAvatar.height + 4 * pxScale, 0x786055);
			var mNameWidth:Number = mGameManager.layoutHelper.isLargeScreen ? mBack.width * 0.6 : mBack.width;
			mName = new XTextField(mNameWidth, mBack.height * 0.33, XTextFieldStyle.PlayerBingoedTextFieldStyle, player.firstName);
			if (place == 1)
				mCrown = new Image(mGameAtlas.getTexture("game/crown_gold"));
			else if (place == 2)
				mCrown = new Image(mGameAtlas.getTexture("game/crown_silver"));
			else if (place == 3)
				mCrown = new Image(mGameAtlas.getTexture("game/crown_bronse"));
			if (mGameManager.layoutHelper.isLargeScreen) {
				mCoin = new Image(mGameAtlas.getTexture("game/coin_little_tablet"));
				mTicket = new Image(mGameAtlas.getTexture("game/tickets_little"));
				mScore = new Image(mGameAtlas.getTexture("game/score_little"));
				mCoinsWon = new XTextField(mBack.width * 0.25, mBack.height * 0.33, XTextFieldStyle.TicketsCoinsWonTextFieldStyle, String(coinsWon));
				
				stringsContainer = new Sprite();
				
			}
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			addChild(mBack);
			addChild(mQuad);
			addChild(mAvatar);
			addChild(mName);
			if (mGameManager.layoutHelper.isLargeScreen) {
				mQuad.x = mBack.width * 0.08;
				mQuad.y = mBack.height * 0.1;
				mAvatar.x = mBack.width * 0.08 + 2 * pxScale;
				mAvatar.y = mBack.height * 0.1 + 2 * pxScale;
				mName.x = mBack.width * 0.4;
				addChild(mCoin);
				
				addChild(stringsContainer);
				stringsContainer.addChild(mCoinsWon);
				
				if (Room.current.hasActiveEvent) {
					addChild(mScore);
					mScoreWon = new XTextField(mBack.width * 0.25, mBack.height * 0.33, XTextFieldStyle.TicketsCoinsWonTextFieldStyle, String(scoreWon));
					mScoreWon.x = 0.64 * mBack.width;
					mScoreWon.y = 0.52 * mBack.height;
					stringsContainer.addChild(mScoreWon);
				} else {
					addChild(mTicket);
					mTicketsWon = new XTextField(mBack.width * 0.25, mBack.height * 0.33, XTextFieldStyle.TicketsCoinsWonTextFieldStyle, String(ticketsWon));
					mTicketsWon.x = 0.64 * mBack.width;
					mTicketsWon.y = 0.52 * mBack.height;
					stringsContainer.addChild(mTicketsWon);
				}
				
				mCoin.x = 0.5 * mBack.width;
				mCoin.y = 0.34 * mBack.height;
				mTicket.x = 0.5 * mBack.width;
				mTicket.y = 0.6 * mBack.height;
				mScore.x = 0.5 * mBack.width;
				mScore.y = 0.6 * mBack.height;
				mCoinsWon.x = 0.64 * mBack.width;
				mCoinsWon.y = 0.27 * mBack.height;
								
			} else {
				mQuad.x = mBack.width - mQuad.width >> 1;
				mQuad.y = mBack.height * 0.1;
				mAvatar.x = mBack.width - mAvatar.width >> 1;
				mAvatar.y = mBack.height * 0.1 + 2 * pxScale;
				mName.y = mBack.height - mName.height * 0.9;
			}
			if (mCrown) {
				mCrown.x = -0.2 * mCrown.width;
				mCrown.y = -0.2 * mCrown.height;
				addChild(mCrown);
			}
			
			if (stringsContainer)
			{
				//stringsContainer.flatten();
			}
			
			if (mGameManager.layoutHelper.isLargeScreen)
				scaleX = scaleY = 0.75;
				
		}
		
		override public function get width():Number
		{
			return mBack.width * scaleX;
		}
		
		override public function get height():Number
		{
			return mBack.height * scaleY;
		}
	}
}