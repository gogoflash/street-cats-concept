package com.alisacasino.bingo.components.effects 
{
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class AlisaParticleItem extends Image 
	{
		public var createTime:int;
		
		public var directionAngle:Number = 0;
		public var distance:Number = 0;
		
		public var speedAcceleration:Number = 0;
		public var scaleAcceleration:Number = 0;
		
		public var gravityAcceleration:Number = 0;
		public var gravityAccelerationValue:Number = 0;
		
		public var speed:Number;
		public var rotationSpeed:Number;
		public var scaleSpeed:Number;
		
		public var directionAngleShift:Number = 0;
		public var directionAngleShiftValue:Number = 0;
		public var directionAngleShiftAmplitude:Number = 0;
		
		public var startX:uint;
		public var startY:uint;
		
		public var startSkewTweenTime:int;
		public var skewSpeedX:Number = 0;
		public var skewSpeedY:Number = 0;
		
		public var valueRatio:Number = 0;
		
		public function get easeInValueRatio():Number {
			return valueRatio * valueRatio * valueRatio;
		}
		
		public function AlisaParticleItem(texture:Texture, color:uint = 0xFFFFFF) 
		{
			super(texture);
			this.color = color;
			alignPivot();
			touchable = false;
		}
		
		public function get overallDirectionAngle():Number {
			return directionAngle + directionAngleShift;
		}
	}

}