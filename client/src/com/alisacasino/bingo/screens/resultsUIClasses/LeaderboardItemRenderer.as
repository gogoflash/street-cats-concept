package com.alisacasino.bingo.screens.resultsUIClasses
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.components.MultiCharsLabel;
	import com.alisacasino.bingo.controls.XImage;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.LiveEventLeaderboardPosition;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.utils.GameManager;
	import feathers.controls.ImageLoader;
	import feathers.core.FeathersControl;
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
		protected var background:DisplayObject;
		protected var _liveEventLeaderboardPosition:LiveEventLeaderboardPosition;
		private var avatarBackground:Quad;
		private var avatar:XImage;
		private var nameLabel:MultiCharsLabel;
		private var scoreLabel:XTextField;
		
		public static const ITEM_WIDTH:Number = 626;
		public static const ITEM_HEIGHT:Number = 77;
		
		public static const AVATAR_WIDTH:int = 70;
		public static const AVATAR_HEIGHT:int = 70;
		
		private var _owner:List;
		private var _index:int = -1;
		private var rankLabel:XTextField;
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
			width = ITEM_WIDTH*pxScale;
			height = ITEM_HEIGHT*pxScale;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			container = new Sprite();
			addChild(container);
			
			createBackground();
			
			
			//avatarBackground = new Quad(70 * pxScale, 70 * pxScale, 0xffffff);
			//avatarBackground.x = 126 * pxScale;
			//avatarBackground.y = 3 * pxScale;
			//container.addChild(avatarBackground);
			
			/*avatar = new XImage(AtlasAsset.CommonAtlas.getTexture("avatars/1"));
			avatar.width = avatarBackground.width;
			avatar.height = avatarBackground.height;
			avatar.x = avatarBackground.x;
			avatar.y = avatarBackground.y;
			container.addChild(avatar);*/
			
			avatarImage = new ImageLoader();
			avatarImage.addEventListener("complete", handler_avatarLoaded);
			//avatarImage.addEventListener(IOErrorEvent.IO_ERROR, handler_avatarLoaded);
			//avatarImage.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handler_avatarLoaded);
			container.addChild(avatarImage);
			
			avatarMask = new Quad(1,1)
			avatarImage.mask = avatarMask;
			
			nameLabel = new MultiCharsLabel(XTextFieldStyle.getChateaudeGarage(27, 0xffffff, Align.LEFT), 220 * pxScale, 60 * pxScale);
			nameLabel.textField.x = 214 * pxScale;
			nameLabel.textField.y = 11 * pxScale;
			container.addChild(nameLabel.textField);
			
			var scoreIcon:Image = new Image(AtlasAsset.CommonAtlas.getTexture("bars/score_small"));
			scoreIcon.alignPivot();
			scoreIcon.x = 460 * pxScale;
			scoreIcon.y = 41 * pxScale;
			container.addChild(scoreIcon);
			
			scoreLabel = new XTextField(120 * pxScale, 60 * pxScale, XTextFieldStyle.getChateaudeGarage(27, 0xffffff));
			scoreLabel.autoScale = true;
			container.addChild(scoreLabel);
			scoreLabel.x = 485 * pxScale;
			scoreLabel.y = 11 * pxScale;
		}
		
		protected function createBackground():void
		{
			background = new Quad(ITEM_WIDTH*pxScale, (ITEM_HEIGHT - 2)*pxScale, 0xF6F6F6);
			background.alpha = 0.1;
			container.addChild(background);
		}
		
		protected function commitData():void
		{
			if (!_liveEventLeaderboardPosition) {
				_liveEventLeaderboardPosition.currentRenderer = null;
				return;
			}
			
			_liveEventLeaderboardPosition.currentRenderer = this;
			dummyTexture = AtlasAsset.CommonAtlas.getTexture("avatars/" + String(index % 5 + 1));
			
			container.visible  = !_liveEventLeaderboardPosition.hidden;
			
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
			
			nameLabel.text = _liveEventLeaderboardPosition.fullUserName;
			
			if (!rankLabel)
			{
				rankLabel = new XTextField(120 * pxScale, 60 * pxScale, XTextFieldStyle.getChateaudeGarage(27, 0xec008d));
				rankLabel.autoScale = true;
			}
			
			container.addChild(rankLabel);
			
			rankLabel.text = "#" + _liveEventLeaderboardPosition.rank.toString();
			rankLabel.x = 4*pxScale;
			rankLabel.y = 11*pxScale;
			
			scoreLabel.numValue = _liveEventLeaderboardPosition.score;
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
			
				//if(Math.random()>0.5)
				//avatartUrl = Math.random()>0.5 ? 'https://i.pinimg.com/236x/17/37/b4/1737b4532c26a763634054d4f915aade.jpg' : 'http://media.moddb.com/cache/images/groups/1/23/22700/crop_120x90/topshelf.png';
				
			if (!avatarImage || avatarImage.source == avatartUrl)
				return;
			
			if ((getTimer() - setAvatarLoadTimeout) >= 500) {
				avatarImage.source = avatartUrl;
				//trace('set avatar ', avatartUrl);
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
			
			avatarImage.x = 126 * pxScale; + avatarShiftX;
			avatarImage.y = 3 * pxScale; + avatarShiftY;
		}
		
		private function alignAvatarForNoAvatar():void 
		{
			avatarImage.scale = 0.946;
			avatarMask.width = AVATAR_WIDTH * pxScale / avatarImage.scale;
			avatarMask.height = AVATAR_HEIGHT * pxScale / avatarImage.scale;
			avatarImage.x = 126 * pxScale;
			avatarImage.y = 3 * pxScale;
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
		
		public function appearHiddenRenderer(delay:Number = 0):void 
		{
			container.alpha = 0;
			container.visible = true;
			Starling.juggler.tween(container, 0.15, {alpha:1, delay:delay });
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