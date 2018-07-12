package com.alisacasino.bingo.screens.profileScreenClasses 
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.controls.AnimatedImageAssetContainer;
	import com.alisacasino.bingo.controls.XImage;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.UIUtils;
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.Canvas;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class AvatarContainer extends Sprite
	{
		private var widthScaled:Number;
		private var heightScaled:Number;
		private var imageContainer:Sprite;
		private var avatarImage:ImageLoader;
		private var isLoaded:Boolean;
		private var source:String;
		private var loadingAnimation:AnimationContainer;
		private var avatarPlaceholder:Sprite;
		
		public function AvatarContainer(width:Number = 243, height:Number = 233)
		{
			super();
			
			widthScaled = width * pxScale;
			heightScaled = height * pxScale;
			
			imageContainer = new Sprite();
			addChild(imageContainer);
			
			avatarPlaceholder = new Sprite();
			
			var quad:Quad = new Quad(widthScaled, heightScaled, 0x0F1825);
			avatarPlaceholder.addChild(quad);
			
			var avatarCat:Image = new Image(AtlasAsset.CommonAtlas.getTexture("avatars/avatar_cat"));
			avatarCat.scale = height/150;
			avatarCat.color = 0x303E46;
			avatarCat.y = heightScaled - avatarCat.height;
			avatarCat.x = (widthScaled - avatarCat.width)/2;
			avatarPlaceholder.addChild(avatarCat);
			imageContainer.addChild(avatarPlaceholder);
			
			imageContainer.mask = UIUtils.createRoundedRectMaskCanvas(width - 2, height - 2, 17, 1, 1);
			
			var frame:Image = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/profile/avatar_border"));
			frame.scale9Grid = ResizeUtils.getScaledRect(18, 18, 4, 4);
			frame.width = widthScaled;
			frame.height = heightScaled;
			addChild(frame);
		}
		
		public function loadBySource(url:String, facebookId:String = null):void
		{
			var _source:String = Player.getAvatarURL(url, facebookId, widthScaled, heightScaled) ;
			
			if (source == _source)
				return;
				
			source = _source;
				
			if (source == null && source == "0" && source == '') {
				destroyAvatarImage();
				return;
			}
			
			loadURL(_source);
		}
		
		public function loadURL(url:String):void
		{
			if (!avatarImage)
			{
				avatarImage = new ImageLoader();
				avatarImage.addEventListener(Event.COMPLETE, handler_avatarLoaded);
				avatarImage.addEventListener(IOErrorEvent.IO_ERROR, handler_avatarLoaded);
				avatarImage.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handler_avatarLoaded);
				//avatarImage.x = 2* pxScale;
				//avatarImage.y = 2 * pxScale;
				
				//avatarImage.source = AtlasAsset.CommonAtlas.getTexture("winners_pane/avatar_mask");
				//avatarImage.alpha = 0.65;
				//avatarImage.color = noAvatarBgColor;
				imageContainer.addChild(avatarImage);
			}
			
			if (!loadingAnimation) {
				loadingAnimation = new AnimationContainer(MovieClipAsset.PackBase);
				loadingAnimation.pivotX = 42 * pxScale;
				loadingAnimation.pivotY = 42 * pxScale;
				loadingAnimation.scale = 0.6;
				loadingAnimation.move(widthScaled / 2, heightScaled / 2);
				loadingAnimation.playTimeline('loading_white', false, true, 24);
				imageContainer.addChild(loadingAnimation);
			}
			
			//avatarBg.visible = true;
			
			avatarImage.visible = false;
			//avatarImage.loadingTexture = AtlasAsset.CommonAtlas.getTexture("winners_pane/avatar_mask");
			avatarImage.source  = url;
		}
		
		private function handler_avatarLoaded(event:*):void 
		{
			if (avatarImage.isLoaded && (avatarImage.source is String) && (event is Event)) 
			{
				isLoaded = true;
				Starling.juggler.delayCall(makeAvatarVisible, 0.017); // без задержки вернет нулевые width, height
			}
		}
		
		private function makeAvatarVisible():void 
		{
			if (!isLoaded || !avatarImage) 
				return;
			
			removeLoadingAnimation();
				
			avatarImage.visible = true;
			
			var avatarShiftX:Number = (widthScaled - avatarImage.width) / 2;
			var avatarShiftY:Number = (heightScaled - avatarImage.height)/2;
			
			avatarImage.x = avatarShiftX;// + 2 * pxScale;
			avatarImage.y = avatarShiftY;// + 2 * pxScale;
		}
		
		public function clean():void 
		{
			source = null;
			destroyAvatarImage();
			imageContainer.mask = null;
			removeLoadingAnimation();
		}
		
		private function destroyAvatarImage():void 
		{
			if (avatarImage) {
				avatarImage.source = null;
				avatarImage.removeEventListener(Event.COMPLETE, handler_avatarLoaded);
				avatarImage.removeEventListener(IOErrorEvent.IO_ERROR, handler_avatarLoaded);
				avatarImage.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handler_avatarLoaded);
				avatarImage.removeFromParent();
				avatarImage = null;
			}
			
			removeLoadingAnimation();
		}
		
		private function removeLoadingAnimation():void {
			if (loadingAnimation) {
				loadingAnimation.removeFromParent();
				loadingAnimation.dispose();
				loadingAnimation = null;
			}	
		}
	}
}