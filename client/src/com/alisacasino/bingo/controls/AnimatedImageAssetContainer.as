package com.alisacasino.bingo.controls 
{
	import starling.animation.Transitions;
	import starling.core.Starling;
	/**
	 * ...
	 * @author 
	 */
	public class AnimatedImageAssetContainer extends ImageAssetContainer 
	{
		public var forceAnimationOnSet:Boolean = false;
		
		private var needToAnimate:Boolean;
		
		public function AnimatedImageAssetContainer() 
		{
			super();
		}
		
		override public function setLoading():void 
		{
			super.setLoading();
			needToAnimate = true;
		}
		
		override protected function setLoaded():void 
		{
			super.setLoaded();
			
			if (image)
			{
				image.alignPivot();
				image.x = image.width / 2;
				image.y = image.height / 2;
				
				if (needToAnimate || forceAnimationOnSet)
				{
					Starling.juggler.removeTweens(image);
					var initialWidth:Number = image.texture.width;
					var initialHeight:Number = image.texture.height;
					image.width = initialWidth * 0.8;
					image.height = initialHeight * 0.8;
					image.alpha = 0;
					Starling.juggler.tween(image, 0.5, {transition: Transitions.EASE_OUT_BACK, "width#": initialWidth, "height#": initialHeight, "alpha#": 1});
				}
			}
			
		}
	}

}