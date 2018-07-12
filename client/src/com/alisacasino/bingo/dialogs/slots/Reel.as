package com.alisacasino.bingo.dialogs.slots 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.models.slots.SlotItem;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import feathers.controls.LayoutGroup;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class Reel extends LayoutGroup
	{
		static public const REEL_TIME:Number = 0.5;
		public var shiftTime:Number = 0.6;
		private var _stopped:Boolean;
		
		public function get stopped():Boolean 
		{
			return _stopped;
		}
		
		private var image:Image;
		private var blurImage:Image;
		private var background:Image;
		private var reelDelay:Number;
		private var result:String;
		private var evenOddFlag:Boolean;
		private var randomItemForSpin:String;
		
		public function Reel() 
		{
			width = 160*pxScale;
			height = 260*pxScale;
			
			background = new Image(Texture.fromColor(width, height, 0xFFFF0000));
			background.alpha = 0.2;
			//addChild(background);
			
			image = new Image(SlotItem.getItemTexture(SlotItem.ALISA_ICON));
			image.alignPivot();
			image.x = width / 2;
			image.y = height / 2;
			addChild(image);
			
			blurImage = new Image(SlotItem.getItemTexture(SlotItem.getRandom()));
			blurImage.alignPivot(Align.CENTER, Align.TOP);
			blurImage.x = background.width / 2;
			blurImage.height = background.height;
			blurImage.setTexCoords(0, 0, 0.45);
			blurImage.setTexCoords(1, 1, 0.45);
			blurImage.setTexCoords(2, 0, 0.55);
			blurImage.setTexCoords(3, 1, 0.55);
			blurImage.filter = new BlurFilter(0.8, 0, 0.2);
			blurImage.visible = false;
			addChild(blurImage);
			
			clipContent = true;
		}
		
		public function launch(reelDelay:Number, result:String):void 
		{
			this.result = result;
			this.reelDelay = reelDelay;
			_stopped = false;
			
			Starling.current.juggler.removeTweens(image);
			
			Starling.current.juggler.tween(image, 0.2, { transition: Transitions.EASE_IN_BACK, y: background.height + image.height, alpha:0.7} );
			Starling.current.juggler.delayCall(onLaunchComplete, 0.25);
			
			blurImage.visible = true;
			blurImage.alpha = 0;
			Starling.current.juggler.tween(blurImage, 0.2, {delay: 0.1, alpha:1} );
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function animateShift(duration:Number):void 
		{
			Starling.current.juggler.removeTweens(image);
			Starling.current.juggler.tween(image, shiftTime, {"y#": height - 63 * pxScale, "scaleY#": 0.9, transition:Transitions.EASE_OUT});
			Starling.current.juggler.tween(image, shiftTime, {"y#": height / 2, "scaleY#": 1, delay:duration, transition:Transitions.EASE_OUT});
		}
		
		private function onLaunchComplete():void 
		{
			image.visible = false;
			Starling.juggler.delayCall(stopSpinning, REEL_TIME + reelDelay);
		}
		
		private function stopSpinning():void 
		{
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			SoundManager.instance.playSfx(SoundAsset.SfxSlotMachineReelStop);
			
			Starling.current.juggler.tween(blurImage, 0.15, { alpha:0} );
			image.y = -image.height;
			image.texture = SlotItem.getItemTexture(result);
			image.readjustSize();
			image.alignPivot();
			image.x = width / 2;
			image.alpha = 1;
			image.visible = true;
			Starling.current.juggler.tween(image, 0.2, { transition: Transitions.EASE_OUT_ELASTIC, y: height / 2, onComplete: onStopComplete} );
		}
		
		private function onStopComplete():void 
		{
			blurImage.visible = false;
			
			_stopped = true;
			dispatchEventWith(Event.COMPLETE);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			evenOddFlag = !evenOddFlag;
			
			if (!evenOddFlag)
				return;
			
			randomItemForSpin = SlotItem.getRandomForReelSpinExcluding(randomItemForSpin);
			blurImage.texture = SlotItem.getItemTexture(randomItemForSpin);
			//blurImage.alpha = (randomItemForSpin == SlotItem.ALISA_ICON) ? 0.6 : 1;
			blurImage.readjustSize();
			blurImage.height = background.height;
			blurImage.alignPivot(Align.CENTER, Align.TOP);
			blurImage.x = background.width / 2 + (Math.random() * 20 - 10) * pxScale;
		}
	}

}