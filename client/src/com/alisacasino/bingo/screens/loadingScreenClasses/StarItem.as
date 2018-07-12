package com.alisacasino.bingo.screens.loadingScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.chests.WeightedList;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class StarItem extends Sprite
	{
		private var angle:Number;
		private var shift:Number = 0;
			
		public var image:Image;
		
		private var startX:int;
		private var startY:int;
		
		private var finishX:int;
		private var finishY:int;
		
		private var startDistance:Number;
		private var finishDistance:Number;
		private var tripDistance:Number;
		
		private var isCloseStar:Boolean;
		private var _progress:Number = 0;
		
		private var farRatio:Number = 0;
		
		private var _position:Number = 0;
		
		private var explicitAlpha:Number = 1;
		
		private var startShiftX:Number = 0;
		private var startShiftY:Number = 0;
		private var startShift:Boolean;
		
		private var anglesWeightedList:WeightedList;
		private var anglesWeights:Array;
		private var textureFrameWidth:int;
		
		public function StarItem(closeTexture:Texture, farTexture:Texture, startX:int, startY:int, maxX:int, maxY:int, startRadius:int, maxRadius:int)
		{
			var rnd:Number = Math.random();
			this.startX = startX;
			this.startY = startY;
			
			angle = Math.random() * 2 * Math.PI;
			
			createAnglesWeights(Math.atan(maxY/maxX));
			angle = anglesWeightedList.getRandomDrop() + Math.PI/6 - Math.random() * Math.PI / 3;
			
			
			startDistance = Point.distance(new Point(0, 0), new Point(Math.cos(angle) * (startRadius + (maxRadius - startRadius)* rnd), Math.sin(angle) * (startRadius + (maxRadius - startRadius)* rnd) ));
			
			shift = Math.random() * Math.max(maxX, maxY);
			
			//trace((angle * 180) / Math.PI, Math.abs((maxX / 2) / Math.cos(angle)), Math.abs((maxY / 2) / Math.sin(angle)));
			//trace((angle*180)/Math.PI, Math.min(Math.abs(((maxX-startX)/2)/Math.cos(angle)), Math.abs(((maxY-startY)/2)/Math.sin(angle))));
			
			finishDistance = Math.min(Math.abs(((maxX)/2)/Math.cos(angle)), Math.abs(((maxY)/2)/Math.sin(angle)));
			tripDistance = finishDistance - startDistance;
			
			farRatio = rnd;//startDistance/finishDistance;
			
			isCloseStar = (farRatio < 0.3) && (Math.random() > 0.3);
			
			if (farRatio > 0.5) {
				explicitAlpha = Math.min(1, 0.5 + Math.random() * 0.5);
			}
			
			image = new Image(isCloseStar ? closeTexture : farTexture);
			image.alignPivot();
			image.alpha = 0;
			
			textureFrameWidth = image.texture.frameWidth;
		}
		
		public function get progress():Number 
		{
			return _progress;
		}
		
		public function set progress(value:Number):void 
		{
			_progress = value;
			
			var relativeDistance:Number = (value + shift) % finishDistance;
			var distanceRatio:Number = relativeDistance/finishDistance;
			
			if ((relativeDistance <= 5) && startShift) {
				startShiftX = 0;
				startShiftY = 0;
				startShift = false;
			}
			
			if (isCloseStar) 
			{
				image.scale = Math.max(3 / textureFrameWidth, distanceRatio*distanceRatio*(1-farRatio));
			}
			else 
			{
				//image.scale = Math.min(1.8 / image.texture.frameWidth, distanceRatio * (1 - farRatio) * 3.5);
				image.scale = Math.min(textureFrameWidth, Math.max(2*pxScale, distanceRatio * textureFrameWidth * (farRatio > 0.4 ? 1.5 : 1.2)))/textureFrameWidth;
				//trace('>>', image.texture.frameWidth, distanceRatio,  farRatio);
			}
			
			if (distanceRatio < 0.1) 
				image.alpha = distanceRatio / 0.1;
			else
				image.alpha = explicitAlpha;
		
				
			var accelerationRatio:Number = Math.round(3 * (1 - farRatio));
			var velocityRatio:Number = distanceRatio;
			
			if (accelerationRatio == 2)
				velocityRatio *= distanceRatio;
			else if (accelerationRatio == 3)
				velocityRatio *= distanceRatio * distanceRatio;
			else if (accelerationRatio == 4)
				velocityRatio *= distanceRatio * distanceRatio * distanceRatio;
			
			if (isCloseStar && distanceRatio > 0.5) 
				image.rotation = velocityRatio * 3;
			
			image.x = startShiftX + startX + Math.cos(angle) * (startDistance + tripDistance*velocityRatio);
			image.y = startShiftY + startY + Math.sin(angle) * (startDistance + tripDistance*velocityRatio);
		}
		
		public function tween(x:Number, y:Number):void 
		{
			startShiftX += x;
			startShiftY += y;
			startShift = true;
			
			/*startDistance = Point.distance(new Point(0, 0), new Point(Math.cos(angle) * startRadius * rnd_1, Math.sin(angle) * startRadius * rnd_1) );
			this.startX = startX// + Math.cos(angle) * startRadius * rnd_1;
			this.startY = startY// + Math.sin(angle) * startRadius * rnd_1;
			finishDistance = Math.min(Math.abs(((maxX)/2)/Math.cos(angle)), Math.abs(((maxY)/2)/Math.sin(angle)));*/
		}
		
		private function createAnglesWeights(maxDirectionAngle:Number):void 
		{
			anglesWeightedList = new WeightedList();
			var normal:Number = 0.3;
			var highter:Number = 0.7;
			//normal = 0.03;
			//highter = 0.97;
			anglesWeightedList.addWeightedItem(0, normal);
			anglesWeightedList.addWeightedItem(maxDirectionAngle, highter);
			anglesWeightedList.addWeightedItem(Math.PI / 2, normal);
			anglesWeightedList.addWeightedItem(Math.PI - maxDirectionAngle, highter);
			anglesWeightedList.addWeightedItem(Math.PI, normal);
			anglesWeightedList.addWeightedItem(Math.PI + maxDirectionAngle, highter);
			anglesWeightedList.addWeightedItem(Math.PI + Math.PI/2, normal);
			anglesWeightedList.addWeightedItem(2*Math.PI - maxDirectionAngle, highter);
		}
		
	}	
}
