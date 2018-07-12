package com.alisacasino.bingo.dialogs.leaderboardDialogClasses
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.components.MultiCharsLabel;
	import com.alisacasino.bingo.controls.XImage;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.LiveEventLeaderboardPosition;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.tournament.LeagueData;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.misc.TextureMaskStyle;
	import feathers.controls.ImageLoader;
	import feathers.core.FeathersControl;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.TokenList;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class LeaderboardItemRenderer extends FeathersControl implements IListItemRenderer
	{
		protected var _liveEventLeaderboardPosition:LiveEventLeaderboardPosition;
		private var avatarBackground:Quad;
		private var avatar:XImage;
		private var nameLabel:MultiCharsLabel;
		private var scoreLabel:XTextField;
		
		public static const ITEM_WIDTH:Number = 738 * pxScale;
		public static const ITEM_HEIGHT:Number = 81 * pxScale;
		
		public static const AVATAR_WIDTH:int = 74;
		public static const AVATAR_HEIGHT:int = 74;
		
		private var _owner:List;
		private var _index:int = -1;
		private var rankLabel:XTextField;
		private var xpLabel:XTextField;
		private var xpBackground:Image;
		private var scoreIcon:Image;
		private var ownPlaque:Image;
		private var rankMarker:Image;
		protected var container:Sprite;
		protected var arrowImage:Image;
		private var setAvatarLoadTimeout:int;
		private var avatarSetDelayCallId:int;
		
		private var avatarImage:ImageLoader;
		private var avatarMask:Quad;
		private var dummyTexture:Texture;
		
		public function LeaderboardItemRenderer()
		{
			super();
			width = ITEM_WIDTH;
			height = ITEM_HEIGHT;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			
			
			container = new Sprite();
			addChild(container);
			
			var background:Image = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/cell"));
			background.scale9Grid = ResizeUtils.getScaledRect(22, 22, 6, 4);
			background.x = -7 * pxScale;
			background.y = -4 * pxScale;
			background.width = ITEM_WIDTH - background.x + 9 * pxScale;
			background.height = ITEM_HEIGHT - background.y + 10 * pxScale;
			container.addChild(background);
			
			rankLabel = new XTextField(120 * pxScale, 60 * pxScale, XTextFieldStyle.LeaderboardRankStandard);
			rankLabel.x = 24*pxScale;
			rankLabel.y = 11*pxScale;
			rankLabel.autoScale = true;
			container.addChild(rankLabel);
			
			rankMarker = new Image(AtlasAsset.getEmptyTexture());
			container.addChild(rankMarker);
			
			avatarBackground = new Quad(80 * pxScale, 80 * pxScale, 0xffffff);
			avatarBackground.x = 142 * pxScale;
			avatarBackground.y = 0.5 * pxScale;
			container.addChild(avatarBackground);
			
			/*avatar = new XImage(AtlasAsset.CommonAtlas.getTexture("avatars/1"));
			avatar.width = 74*pxScale;
			avatar.height = 74*pxScale;
			avatar.x = avatarBackground.x + 3*pxScale;
			avatar.y = avatarBackground.y + 3*pxScale;
			container.addChild(avatar);*/
			
			avatarImage = new ImageLoader();
			avatarImage.loadingTexture = AtlasAsset.CommonAtlas.getTexture("avatars/1");
			avatarImage.addEventListener("complete", handler_avatarLoaded);
			avatarImage.addEventListener(IOErrorEvent.IO_ERROR, handler_avatarLoadedError);
			avatarImage.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handler_avatarLoadedError);
			avatarImage.x = avatarBackground.x + 3*pxScale;
			avatarImage.y = avatarBackground.y + 3 * pxScale;
			container.addChild(avatarImage);
			
			avatarMask = new Quad(1,1)
			avatarImage.mask = avatarMask;
			
			xpBackground = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/xp_small"));
			xpBackground.alignPivot();
			xpBackground.x = 251 * pxScale;
			xpBackground.y = 41 * pxScale;
			container.addChild(xpBackground);
			
			xpLabel = new XTextField(51 * pxScale, 26 * pxScale, XTextFieldStyle.LeaderboardXp,	gameManager.deactivated ? '' : Player.current.xpLevel.toString());
			xpLabel.autoScale = true;
			xpLabel.redraw();
			xpLabel.alignPivot(Align.CENTER, Align.CENTER);
			xpLabel.x = xpBackground.x;
			xpLabel.y = xpBackground.y + 1 * pxScale;
			container.addChild(xpLabel);
		
			nameLabel = new MultiCharsLabel(XTextFieldStyle.LeaderboardsPlayerName, 286 * pxScale, 60 * pxScale);
			nameLabel.textField.x = 288 * pxScale;
			nameLabel.textField.y = 13 * pxScale;
			//nameLabel.debugTest(false);
			container.addChild(nameLabel.textField);
			
			scoreIcon = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/point_small"));
			scoreIcon.alignPivot();
			scoreIcon.x = 590 * pxScale;
			scoreIcon.y = 39 * pxScale;
			container.addChild(scoreIcon);
			
			scoreLabel = new XTextField(106 * pxScale, 48 * pxScale, XTextFieldStyle.getChateaudeGarage(28, 0xc900d6));
			scoreLabel.autoScale = true;
			container.addChild(scoreLabel);
			scoreLabel.x = 615 * pxScale;
			scoreLabel.y = 17 * pxScale;
			//scoreLabel.border = true;
			
			alignAvatarForNoAvatar();
		}
		
		protected function commitData():void
		{
			//container.visible  = !_liveEventLeaderboardPosition.hidden;
			
			dummyTexture = AtlasAsset.CommonAtlas.getTexture("avatars/" + String(index % 5 + 1));
			
			var needToShowOwnPlaque:Boolean = _liveEventLeaderboardPosition.playerId == Player.current.playerId;
			
			avatarImage.source = dummyTexture;
			avatarImage.loadingTexture = dummyTexture;
			if (_liveEventLeaderboardPosition.hasAvatarSources)
			{
				Starling.juggler.removeByID(avatarSetDelayCallId);
				setAvatarImage();
			}
			else
			{
				Starling.juggler.removeByID(avatarSetDelayCallId);
				avatarImage.source  = AtlasAsset.CommonAtlas.getTexture("avatars/" + String(index % 5 + 1));
				alignAvatarForNoAvatar();
			}
			
			if(Constants.isDevFeaturesEnabled)
				nameLabel.setStyle(_liveEventLeaderboardPosition.isBot ? XTextFieldStyle.LeaderboardsBotName : XTextFieldStyle.LeaderboardsPlayerName);
			
			nameLabel.text = _liveEventLeaderboardPosition.fullUserName;
			xpLabel.text = _liveEventLeaderboardPosition.xpLevel.toString();
			
			var rankMarkerTexture:Texture = AtlasAsset.getEmptyTexture();
			var rankMarkerShift:int = 0;
			switch(_liveEventLeaderboardPosition.league)
			{
				case "1st":
					rankMarkerTexture = AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/place_1");
					rankMarkerShift = -14 * pxScale;
					rankLabel.textStyle = XTextFieldStyle.LeaderboardRankFirst;
					break;
				case "2nd":
					rankMarkerTexture = AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/place_2");
					rankMarkerShift = -14 * pxScale;
					rankLabel.textStyle = XTextFieldStyle.LeaderboardRankSecond;
					break;
				case "3rd":
					rankMarkerTexture = AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/place_3");
					rankMarkerShift = -14 * pxScale;
					rankLabel.textStyle = XTextFieldStyle.LeaderboardRankThird;
					break;
				case "gold":
					rankMarkerTexture = AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/gold_league");
					rankLabel.textStyle = XTextFieldStyle.LeaderboardRankStandard;
					break;
				case "silver":
					rankMarkerTexture = AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/silver_league");
					rankLabel.textStyle = XTextFieldStyle.LeaderboardRankStandard;
					break;
				case "bronze":
					rankMarkerTexture = AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/bronze_league");
					rankLabel.textStyle = XTextFieldStyle.LeaderboardRankStandard;
					break;
				default: {
					rankLabel.textStyle = XTextFieldStyle.LeaderboardRankStandard;
				}
			}
			
			rankMarker.texture = rankMarkerTexture;
			rankMarker.readjustSize();
			rankMarker.x = rankMarkerShift;
			rankMarker.y = rankMarkerShift;
			
			if (needToShowOwnPlaque)
			{
				if (!ownPlaque)
				{
					ownPlaque = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/player_marker"));
					ownPlaque.alignPivot();
					ownPlaque.x = -58 * pxScale;
					ownPlaque.y = 42 * pxScale;
				}
				addChild(ownPlaque);
			}
			else
			{
				if (ownPlaque)
					ownPlaque.removeFromParent();
			}
			
			
			rankLabel.text = _liveEventLeaderboardPosition.rank.toString();
			scoreLabel.numValue = _liveEventLeaderboardPosition.score;
			//scoreLabel.numValue = Math.random() > 0.5 ? int(700000 + 20000000 * Math.random()) : 50000 * Math.random();
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				commitData();
			}
		}
		
		public function get data():Object
		{
			return _liveEventLeaderboardPosition;
		}
		
		public function set data(value:Object):void
		{
			if (_liveEventLeaderboardPosition != value)
			{
				if (_liveEventLeaderboardPosition)
				{
					removePositionDataListeners(_liveEventLeaderboardPosition);
				}
				
				_liveEventLeaderboardPosition = value as LiveEventLeaderboardPosition;
				
				if (_liveEventLeaderboardPosition)
				{
					addPositionDataListeners(_liveEventLeaderboardPosition);
					invalidate(INVALIDATION_FLAG_DATA);
				}
			}
		}
		
		
		private function setAvatarImage():void 
		{
			var avatartUrl:String;
			if(_liveEventLeaderboardPosition)
				avatartUrl = Player.getAvatarURL(_liveEventLeaderboardPosition.avatarUrl, _liveEventLeaderboardPosition.facebookId, 85 * pxScale, 85 * pxScale);
			
			if (!avatarImage || avatarImage.source == avatartUrl)
				return;
			
			if ((getTimer() - setAvatarLoadTimeout) >= 500) {
				avatarImage.source = avatartUrl;
				setAvatarLoadTimeout = getTimer();
				alignAvatarForNoAvatar();
			}
			else {
				avatarImage.source = dummyTexture;
				alignAvatarForNoAvatar();
				avatarSetDelayCallId = Starling.juggler.delayCall(setAvatarImage, 0.51);
			}
		}
		
		private function handler_avatarLoaded(event:*):void 
		{
			if (avatarImage.isLoaded && (avatarImage.source is String)) 
			{
				Starling.juggler.delayCall(alignAvatar, 0.017); // без задержки вернет нулевые width, height
			}
		}
		
		private function alignAvatar():void 
		{
			var minScale:Number = Math.max(AVATAR_WIDTH * pxScale / avatarImage.originalSourceWidth, AVATAR_HEIGHT * pxScale / avatarImage.originalSourceHeight);
			avatarImage.scale = minScale;
			
			var avatarShiftX:Number = (AVATAR_WIDTH * pxScale - avatarImage.width) / 2;
			var avatarShiftY:Number = (AVATAR_HEIGHT * pxScale - avatarImage.height) / 2;
			
			avatarMask.width = (AVATAR_WIDTH * pxScale) / minScale;
			avatarMask.height = (AVATAR_HEIGHT * pxScale) / minScale;
			//trace(avatarShiftX, avatarShiftY, minScale);
			avatarMask.x = -avatarShiftX/minScale;
			avatarMask.y = -avatarShiftY/minScale;
			
			avatarImage.x = avatarBackground.x + 3*pxScale + avatarShiftX;
			avatarImage.y = avatarBackground.y + 3*pxScale + avatarShiftY;
		}
		
		private function alignAvatarForNoAvatar():void 
		{
			avatarImage.scale = 1;
			avatarMask.width = AVATAR_WIDTH * pxScale / avatarImage.scale;
			avatarMask.height = AVATAR_HEIGHT * pxScale / avatarImage.scale;
			avatarImage.x = avatarBackground.x + 3*pxScale;
			avatarImage.y = avatarBackground.y + 3 * pxScale;
			avatarMask.x = 0;
			avatarMask.y = 0;
		}
		
		protected function removePositionDataListeners(liveEventLeaderboardPosition:LiveEventLeaderboardPosition):void
		{
			liveEventLeaderboardPosition.removeEventListener(Event.CHANGE, liveEventLeaderboardPosition_changeHandler);
		}
		
		protected function addPositionDataListeners(liveEventLeaderboardPosition:LiveEventLeaderboardPosition):void 
		{
			liveEventLeaderboardPosition.addEventListener(Event.CHANGE, liveEventLeaderboardPosition_changeHandler);
		}
		
		private function liveEventLeaderboardPosition_changeHandler(e:Event):void 
		{
			invalidate(INVALIDATION_FLAG_DATA);
			validate();
		}
		
		private function handler_avatarLoadedError(event:*):void {
			// TODO: some reload tries
			//SOSLog.add('LeaderboardItemRenderer.handler_avatarLoadedError', event);
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		
		public function get owner():List
		{
			return _owner;
		}
		
		public function set owner(value:List):void
		{
			_owner = value;
		}
		
		public function get isSelected():Boolean
		{
			return false;
		}
		
		public function set isSelected(value:Boolean):void
		{
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (_liveEventLeaderboardPosition)
			{
				removePositionDataListeners(_liveEventLeaderboardPosition);
			}
		}
		
		protected var _factoryID:String;

		public function get factoryID():String {
			return _factoryID;
		}

		public function set factoryID(value:String):void {
			_factoryID = value;
		}
	}
}