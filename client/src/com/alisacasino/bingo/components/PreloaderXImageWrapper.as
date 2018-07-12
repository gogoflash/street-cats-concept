package com.alisacasino.bingo.components
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.controls.XImage;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class PreloaderXImageWrapper extends Sprite
	{
		private var loadingAnimation:AnimationContainer;
		private var showPreloaderAnimation:Boolean;
		
		private var xImage:XImage;
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		private var quad:Quad;
		private var avatarCat:Image;
		
		public function PreloaderXImageWrapper(defaultTexture:Texture, imageURL:String=null, showPreloaderAnimation:Boolean = false, idleColor:uint = 0xFFFFFF)
		{
			this.showPreloaderAnimation = showPreloaderAnimation;
			
			showBackground(true);
			
			xImage = new XImage(defaultTexture, imageURL, showPreloader, hidePreloader, idleColor);
			addChild(xImage);
			
			if (showPreloaderAnimation && loadingAnimation) 
				addChild(loadingAnimation);
		}
		
		public function get defaultTexture():Texture 
		{
			return xImage.defaultTexture;
		}
		
		public function set defaultTexture(value:Texture):void 
		{
			xImage.defaultTexture = value;
		}
		
		public function get loaded():Boolean
		{
			return xImage.loaded;
		}
		
		public function hasInCache(imageURL:String):Boolean
		{
			return xImage.hasInCache;
		}
				
		public function get imageURL():String
		{
			return xImage.imageURL;
		}
		
		public function set imageURL(value:String):void
		{
			xImage.imageURL = value;
		}
		
		private function showPreloader():void
		{				
			if (showPreloaderAnimation && !loadingAnimation) {
				loadingAnimation = new AnimationContainer(MovieClipAsset.PackBase);
				loadingAnimation.pivotX = 42 * pxScale;
				loadingAnimation.pivotY = 42 * pxScale;
				loadingAnimation.scale = 0.6;
				if(width != 0 && height != 0)
					loadingAnimation.move(width / 2, height / 2);
				addChild(loadingAnimation);
				loadingAnimation.playTimeline('loading_white', false, true, 24);
			}
		}
		
		private function hidePreloader():void
		{				
			if (loadingAnimation) {
				loadingAnimation.removeFromParent();
				loadingAnimation.dispose();
				loadingAnimation = null;
			}
			
			//showBackground(false);
		}
		
		public function showBackground(value:Boolean):void
		{
			if (value)
			{
				if (!quad) {
					quad = new Quad(150*pxScale, 150*pxScale, 0x0F1825);
					addChild(quad);
					
					avatarCat = new Image(AtlasAsset.CommonAtlas.getTexture("avatars/avatar_cat"));
					//avatarCat.scale = (height/150) * pxScale;
					avatarCat.color = 0x303E46;
					avatarCat.y = 150*pxScale - avatarCat.height;
					avatarCat.x = (150*pxScale - avatarCat.width)/2;
					addChild(avatarCat);
				}
			}
			else
			{
				if (quad) {
					quad.removeFromParent();
					quad = null;
					
					avatarCat.removeFromParent();
					avatarCat = null;
				}
			}
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			if (value == _width)
				return;
				
			_width = value;
			xImage.width = value;
			
			if(loadingAnimation)
				loadingAnimation.x = width/2;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			if (value == _height)
				return;
				
			_height = value;
			xImage.height = value;
			
			if(loadingAnimation)
				loadingAnimation.y = height/2;
		}
	}
}