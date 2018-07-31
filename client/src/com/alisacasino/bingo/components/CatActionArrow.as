package com.alisacasino.bingo.components 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.cats.CatRole;
	import com.alisacasino.bingo.utils.tweens.BezierTween;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class CatActionArrow extends Sprite
	{
		
		public var hasArrow:Boolean = true;
		
		public var time:Number = 5;
		
		public var interval:Number = 1.3;
		
		public var up:Boolean = true;
		
		private var _rect:Rectangle;
		
		private var curvesPool:Array = [];
		
		private var start:Point;
		private var finish:Point;
		private var bezier:Point;
		
		private var bgImage:Image;
		
		private var arrowImage:Image;
			
		private var intervalId:int;
		
		private var dQuad:Quad;
		
		public var angle:Number = 0;
		
		public function CatActionArrow() 
		{
			super();
		}
		
		public var actionType:String;
		
		public var shiftX:int;
		public var shiftY:int;
		
		public function set rect(value:Rectangle):void
		{
			if (value == _rect || (_rect && value && _rect.equals(value)))
				return;
				
			_rect = value;
			
			if (_rect) 
			{
				if (up)
				{
					start = new Point(_rect.x + shiftX, _rect.y + shiftY);
					finish = new Point(_rect.x + _rect.width + shiftX, _rect.y + _rect.height + shiftY);
					bezier = new Point(_rect.x + _rect.width, _rect.y + _rect.height/2);
					
					
				}
				else
				{
					start = new Point(_rect.x + shiftX, _rect.y + _rect.height + shiftY);
					finish = new Point(_rect.x + _rect.width, _rect.y + shiftY);
					bezier = new Point(_rect.x + _rect.width + shiftX, _rect.y + _rect.height/2);
				}
			}
			
			redraw();
		}
		
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		private function redraw():void 
		{
			var curve:Image;
			while (numChildren > 0) 
			{
				curve = removeChildAt(0) as Image;
				Starling.juggler.removeTweens(curve);
				clearInterval(intervalId);
			}
			
			if (arrowImage) {
				Starling.juggler.removeTweens(arrowImage);
				arrowImage.removeFromParent();
			}
			
			if (!_rect) 
			{
				return;
			}
			
			/*if (!dQuad) {
				dQuad = new Quad(1, 1);
				dQuad.alpha = 0.5;
				
			}
			addChild(dQuad);
			dQuad.x = _rect.x;
			dQuad.y = _rect.y;
			dQuad.width = _rect.width;
			dQuad.height = _rect.height;*/
			
			resetParticles();
			
			for (var i:int = 0; i < Math.floor(time / interval); i++) 
			{
				tweenParticle(i*interval);
			}
			
			
			intervalId = setInterval(tweenParticle, interval * 1000);
			
			if (hasArrow) 
			{
				
				if (!bgImage) {
					
					bgImage = new Image(AtlasAsset.CommonAtlas.getTexture('cats/circle_white'));
					
					bgImage.scale9Grid = new Rectangle(35, 0, 1, 71);
					bgImage.alpha = 0.8;
					bgImage.pivotX = 35.5;
					bgImage.pivotY = 35.5;
				}
				
				bgImage.color = bgColor;
				bgImage.width = Point.distance(start, finish);
				bgImage.x = start.x + (finish.x - start.x)/2
				
				var rotDir:int = finish.y >= start.y ? 1 : -1;
				angle =  (Math.abs(finish.y - start.y) > 10) ? Math.acos((finish.x - start.x)/bgImage.width) : 0;
				angle *= rotDir;
				bgImage.y = start.y + (rotDir*Math.abs(finish.y - start.y))/2
				bgImage.rotation = angle;
				
						
				
				if (!arrowImage) {
					
					arrowImage = new Image(AtlasAsset.CommonAtlas.getTexture('cats/arrow'));
					//arrowImage.pivotX = 11;	
					//arrowImage.pivotY = 4;
					arrowImage.alignPivot();
				}
				
				arrowImage.scale = 0;
				arrowImage.alpha = 0.8;
				
				var a:Number = 0//Vector3D.angleBetween(new Vector3D(bezier.x, bezier.y, 1, 1), new Vector3D(finish.x, finish.y, 1, 1));
					
				arrowImage.x = finish.x;	
				arrowImage.y = finish.y;
				
				arrowImage.rotation = angle;
				
				/*if (Math.abs(finish.x - start.x) > 80) {
					arrowImage.rotation = (up ? -1 : 1) * (2*a + Vector3D.angleBetween(new Vector3D(1, 1, 1, 1), new Vector3D(finish.x, finish.y, 1,1)));
				}
				else {
					arrowImage.rotation = 0;
				}*/
				
				Starling.juggler.tween(arrowImage, 1, {transition:Transitions.LINEAR, /*alpha:0, */scale:1.2, repeatCount:0});
				//Starling.juggler.tween(arrowImage, 0.2, {delay:0.8, transition:Transitions.LINEAR, alpha:0, repeatCount:0});
				
				addChildAt(bgImage, 0);
				
				//addChild(arrowImage);
			}
		}
		
		private function tweenParticle(advTime:Number = 0):void 
		{
			var curve:Image;
			
			if (curvesPool.length > 0) {
				curve = curvesPool.pop() as Image;
				
			}
			else {
				curve = new Image(AtlasAsset.CommonAtlas.getTexture(imageTexture));
				curve.alpha = 0.8;
				curve.alignPivot();
			}
			
			addChild(curve);
			
			//if(arrowImage)
				//addChild(arrowImage);
			
			curve.y = start.y;
			curve.x = start.x;
			curve.rotation = angle + Math.PI/2;
			curve.scale = 0.65;
			//puffImage.scale = 1.2;
			
			var curveTween:Tween = new Tween(curve, time, Transitions.LINEAR);
			curveTween.moveTo(finish.x, finish.y);
			curveTween.onComplete = toPool;
			curveTween.onCompleteArgs = [curve];
			//curveTween.onUpdate = processRotation;
			//curveTween.onUpdateArgs = [curve, curveTween];
			
			if(advTime > 0)
				curveTween.advanceTime(advTime);
			
			Starling.juggler.add(curveTween);
		}
		
		private function get imageTexture():String {
			switch(actionType) {
				case CatRole.FIGHTER : return 'cats/actions/sword';
				case CatRole.DEFENDER : return 'cats/actions/shield01';
				case CatRole.HARVESTER : return 'cats/actions/fishSkull';
			}
			/*switch(actionType) {
				case CatRole.FIGHTER : return 'cats/actions/sword_1';
				case CatRole.DEFENDER : return 'cats/actions/shield_1';
				case CatRole.HARVESTER : return 'cats/actions/fish_1';
			}*/
			return '';
		}
		
		private function get bgColor():uint {
			switch(actionType) {
				case CatRole.FIGHTER : return 0xFF6699;
				case CatRole.DEFENDER : return 0x00CCFF;
				case CatRole.HARVESTER : return 0x99CC66;
			}
			return 0xFFFFFF;
		}
		
		private function processRotation(curve:Image, curveTween:BezierTween):void 
		{
			curve.rotation = curveTween.progress;
		}
		
		private function toPool(curve:Image):void 
		{
			curvesPool.push(curve);
			curve.removeFromParent();
		}
		
		private function resetParticles():void 
		{
			var curve:Image;
			
			for (var i:int = 0;  i < curvesPool.length; i++) {
				curve = curvesPool[i] as Image;
				curve.texture = AtlasAsset.CommonAtlas.getTexture(imageTexture);
				curve.readjustSize();
			}
		}	
	}
}