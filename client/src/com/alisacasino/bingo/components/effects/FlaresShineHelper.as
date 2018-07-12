package com.alisacasino.bingo.components.effects 
{
	import adobe.utils.CustomActions;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.utils.TweenHelper;
	
	public class FlaresShineHelper 
	{
		private var coordinates:Vector.<Point>;
		
		private var texture:Texture;
		
		private var container:DisplayObjectContainer;
		
		private var intervalId:int;
		
		private var pool:Vector.<Image>;
		
		private var list:Vector.<Image>;
		
		private var showIndexes:Vector.<int>;
		
		private var shineTime:Number;
		
		private var defaultPosition:Point;
		
		private var randomPlay:Boolean;
		
		private var currentIndex:int;
		
		private var scaleMax:Number = 1;
		
		//private var coordinateScaleMultiplier:Number = 1;
		
		public function FlaresShineHelper(container:DisplayObjectContainer, texture:Texture, defaultX:int, defaultY:int, scaleMax:Number = 1) 
		{
			this.container = container;
			this.texture = texture;
			this.scaleMax = scaleMax;
			defaultPosition = new Point(defaultX, defaultY);
			pool = new <Image>[];
			list = new <Image>[];
			showIndexes = new <int>[];
		}
		
		public function setCoordinatesList(coordinatesRaw:Array, shiftX:int, shiftY:int, coordinateScaleMultiplier:Number = 1):void
		{
			coordinates = new <Point>[];
			
			var i:int;
			var length:int = coordinatesRaw.length;
			var pointRaw:Array;
			for (i = 0; i < length; i++) {
				pointRaw = coordinatesRaw[i];
				coordinates.push(new Point((pointRaw[0]*coordinateScaleMultiplier + shiftX) * pxScale, (pointRaw[1]*coordinateScaleMultiplier + shiftY) * pxScale));
			}
		}
		
		public function play(timeToNext:int, shineTime:Number, random:Boolean = true):void
		{
			if (intervalId != -1)
				clearInterval(intervalId);
			
			this.shineTime = shineTime;
			randomPlay = random;
			intervalId = setInterval(showFlare, timeToNext);
		}
		
		public function stop(instantStop:Boolean = false):void
		{
			if (intervalId != -1)
				clearInterval(intervalId);
				
			if (instantStop) {
				var i:int;
				var length:int = list.length;
				var pointRaw:Array;
				for (i = 0; i < length; i++) {
					list[i].visible = false;
				}
			}
		}
		
		private function showFlare():void 
		{
			var image:Image;
			
			if (pool.length > 0) {
				image = pool.pop();
			}
			else {
				image = new Image(texture);
				image.alignPivot();
				image.touchable = false;
				list.push(image);
			}
			
			if (showIndexes.length == 0) {
				var i:int;
				var length:int = coordinates.length;
				for (i = 0; i < length; i++) {
					showIndexes[i] = i;
				}
			}
			
			var point:Point;
			if (randomPlay)
			{
				var index:int = Math.floor(showIndexes.length * Math.random());
				point = coordinates[showIndexes[index]];	
				showIndexes.splice(index, 1);
			}
			else
			{
				if (currentIndex >= showIndexes.length)
					currentIndex = 0;
					
				point = coordinates[showIndexes[currentIndex]];	
				currentIndex++;
			}
			
			image.visible = true;
			image.scale = 0;
			image.x = defaultPosition.x + point.x;
			image.y = defaultPosition.y + point.y;
			image.rotation = Math.random() * Math.PI;
			container.addChild(image);
			
			TweenHelper.tween(image, shineTime / 2, {scale:scaleMax, rotation:(image.rotation + Math.PI/16)}).chain(image, shineTime / 2, {scale:0, rotation:(image.rotation + Math.PI*8/16), onComplete:completeShowFlare, onCompleteArgs:[image]});
		}
		
		private function completeShowFlare(image:Image):void
		{
			image.removeFromParent();
			pool.push(image);
		}
		
	}

	
}