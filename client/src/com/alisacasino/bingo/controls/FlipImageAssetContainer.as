package com.alisacasino.bingo.controls 
{
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.Event;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author 
	 */
	public class FlipImageAssetContainer extends ImageAssetContainer 
	{
		public var forceAnimationOnSet:Boolean = false;
		
		private var needToAnimate:Boolean;
		private var tween:Tween;
		private var uuid:String;
		private var appearSoundAsset:SoundAsset;
		
		public function FlipImageAssetContainer(appearSoundAsset:SoundAsset = null) 
		{
			this.appearSoundAsset = appearSoundAsset;
			uuid = int(Math.random() * int.MAX_VALUE).toString(36);
			super();
		}
		
		override protected function applyAsset(imageAsset:ImageAsset):void 
		{
			super.applyAsset(imageAsset);
			
			if (imageAsset.loaded)
			{
				needToAnimate = false;
			}
		}
		
		override public function get source():Object 
		{
			return super.source;
		}
		
		override public function set source(value:Object):void 
		{
			clearTween();
			super.source = value;
		}
		
		override public function setLoading():void 
		{
			clearTween();
			super.setLoading();
			needToAnimate = true;
		}
		
		override protected function setLoaded():void 
		{
			clearTween();
			
			if (!needToAnimate && !forceAnimationOnSet)
			{
				super.setLoaded();
				return;
			}
			
			if (asset.texture)
			{
				//applySkin(loadingSkin);
				if (loadingSkin is DisplayObject)
				{
					animateLoadingSkin(applyTextureAndAnimate);
					
					if (appearSoundAsset)
						SoundManager.instance.playSfx(appearSoundAsset, 0, 0, 1, 0, true);
				}
				else
				{
					applyTextureAndAnimate();
				}
				
				dispatchEvent(new Event(LOADED, true));
			}
			
		}
		
		private function animateLoadingSkin(onComplete:Function):void 
		{
			var container3D:Sprite3D = new Sprite3D();
			container3D.addChild(loadingSkin as DisplayObject);
			container3D.alignPivot();
			container3D.x = container3D.pivotX;
			container3D.y = container3D.pivotY;
			var container:Sprite = new Sprite();
			container.addChild(container3D);
			setContent(container);
			tween = new Tween(container3D, 0.3, Transitions.EASE_IN);
			tween.animate("rotationY", Math.PI / 2);
			tween.onComplete = onComplete;
			Starling.juggler.add(tween);
		}
		
		private function applyTextureAndAnimate():void 
		{
			clearTween();
			applyTexture(asset.texture);
			if (image)
			{
				var container3D:Sprite3D = new Sprite3D();
				container3D.addChild(image);
				container3D.alignPivot();
				container3D.x = container3D.pivotX;
				container3D.y = container3D.pivotY;
				var container:Sprite = new Sprite();
				container.addChild(container3D);
				setContent(container);
				container3D.rotationY = -Math.PI / 2;
				tween = new Tween(container3D, 0.3, Transitions.EASE_OUT_BACK);
				tween.animate("rotationY", 0);
				tween.onComplete = clearTween;
				Starling.juggler.add(tween);
			}
		}
		
		/*override protected function setContent(content:DisplayObject):void 
		{
			super.setContent(content);
			
			if (content == null) {
				animateLoadingSkin(null);
			}
		}*/
		
		private function clearTween():void 
		{
			if (tween)
			{
				Starling.juggler.remove(tween);
			}
			tween = null;
		}
	}

}