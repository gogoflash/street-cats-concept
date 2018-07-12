package com.alisacasino.bingo.components.effects 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class AlphaMask extends Sprite
	{
		private var alphaMaskImage:Image;
	
		private var alphaMaskQuads:Vector.<Quad>;
		
		private var stageWidth:uint; 
		private var stageHeight:uint;
		
		public function AlphaMask(x:int, y:int, width:uint, height:uint, overrideStageWidth:uint=0, overrideStageHeight:uint = 0) 
		{
			stageWidth = overrideStageWidth == 0 ? layoutHelper.stageWidth : overrideStageWidth;
			stageHeight = overrideStageHeight == 0 ? layoutHelper.stageHeight : overrideStageHeight;
			
			alphaMaskImage = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/mask_hole_round"));
			alphaMaskImage.scale9Grid = new Rectangle(37 * pxScale, 37 * pxScale, 2 * pxScale, 2 * pxScale);
			alphaMaskImage.alignPivot();
			alphaMaskImage.x = x;
			alphaMaskImage.y = y;
			alphaMaskImage.width = width;
			alphaMaskImage.height = height;
			//alphaMaskImage.touchable = false;
			addChild(alphaMaskImage);
			
			alphaMaskQuads = new <Quad>[];
			var quad:Quad = new Quad(1, 1, 0x000000);
			//quad.touchable = false;
			quad.width = stageWidth;
			addChild(quad);
			alphaMaskQuads.push(quad);
			
			
			quad = new Quad(1, 1, 0x000000);
			quad.width = stageWidth;
			//quad.touchable = false;
			addChild(quad);
			alphaMaskQuads.push(quad);
			
			quad = new Quad(1, 1, 0x000000);
			//quad.touchable = false;
			addChild(quad);
			alphaMaskQuads.push(quad);
			
			quad = new Quad(1, 1, 0x000000);
			//quad.touchable = false;
			addChild(quad);
			alphaMaskQuads.push(quad);
			
			addChild(alphaMaskImage);
			
			alignAlphaMask();
		}
		
		public function tween(x:int, y:int, width:uint, height:uint, instant:Boolean = false, time:Number = 0.2, delay:Number = 0, transition:String = "easeOut", onComplete:Function = null, onCompleteArgs:Array = null):void
		{
			//Starling.juggler.removeTweens(this);
			
			Starling.juggler.removeTweens(alphaMaskImage);
			
			if (instant) 
				time = 0;
			
			Starling.juggler.tween(alphaMaskImage, time, {x:x, y:y, width:width, height:height, delay:delay, onUpdate:alignAlphaMask, transition:transition, onComplete:onComplete, onCompleteArgs:onCompleteArgs});
		}
		
		public function get maskX():Number {
			return alphaMaskImage.x;
		}
		
		public function get maskY():Number {
			return alphaMaskImage.y;
		}
		
		/*public function hideAlphaMask(instant:Boolean = false, alphaTime:Number = 0.2, tweenTime:Number = 0.2, delay:Number = 0, toWidth:Number = NaN, toHeight:Number = NaN):void
		{
			if (instant) {
				Starling.juggler.removeTweens(this);
				Starling.juggler.removeTweens(alphaMaskImage);
			}	
			else {
				Starling.juggler.tween(this, alphaTime, {alpha:0, delay:delay});
				Starling.juggler.tween(alphaMaskImage, tweenTime, {width:(isNaN(toWidth) ? alphaMaskImage.width : toWidth), height:(isNaN(toHeight) ? alphaMaskImage.height : toHeight), delay:delay, onUpdate:alignAlphaMask, transition:Transitions.EASE_OUT, onComplete:removeAlphaMask});
			}
		}*/
		
		private function alignAlphaMask():void
		{
			var halfImageHeight:Number = alphaMaskImage.height / 2;
			var halfImageWidth:Number = alphaMaskImage.width / 2;
			
			var quad:Quad;
			
			alphaMaskQuads[0].height = Math.max(0, alphaMaskImage.y - halfImageHeight);
			
			quad = alphaMaskQuads[1];
			quad.y = alphaMaskImage.y + halfImageHeight;
			quad.height = Math.max(0, stageHeight - quad.y);
			
			quad = alphaMaskQuads[2];
			quad.y = alphaMaskQuads[0].height;
			quad.height = alphaMaskQuads[1].y - quad.y;
			quad.width = Math.max(0, alphaMaskImage.x - halfImageWidth);
			
			quad = alphaMaskQuads[3];
			quad.y = alphaMaskQuads[0].height;
			quad.height = alphaMaskQuads[2].height;
			quad.x = alphaMaskImage.x + halfImageWidth;
			quad.width = Math.max(0, stageWidth - quad.x);
		}
		
		/*public function clean():void
		{
			//removeFromParent();
			alphaMaskImage = null;
			
			var quad:Quad;
			while (alphaMaskQuads.length > 0) {
				quad = alphaMaskQuads.shift();
				quad.removeFromParent(true);
			}
			
			alphaMaskQuads = null;
		}*/
			
	}

}