package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import flash.utils.getTimer;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.utils.TweenHelper;
	
	public class BingoAnimation
	{
		public var gameCard:GameCard;
		
		private var flare:Image;
		private var shadow:Image;
	
		private var items:Vector.<BingoAnimationItem>;
		private var positionX:Number = 0;
		private var positionY:Number = 0;
		private var container:DisplayObjectContainer;
		private var completeCallback:Function;
		
		private var baseScale:Number = 1;
		
		private var appearTweenRatio:Number = 0;
		private var waveTweenRatio:Number = 0;
		private var startTime:int;
		
		private var upScaleCoefficient:Number = 0;
		
		private var toFinishTween:Boolean;
		
		private var mult:Number = 1;	
		
		public var minChildIndex:int;
		
		private var playStartTime:int;
		
		public function BingoAnimation(container:DisplayObjectContainer, baseScale:Number, positionX:Number, positionY:Number, completeCallback:Function, gameCard:GameCard)
		{
			this.container = container;
			this.baseScale = baseScale;
			this.positionX = positionX;
			this.positionY = positionY;
			this.completeCallback = completeCallback;
			this.gameCard = gameCard;
			
			var atlas:AtlasAsset = AtlasAsset.CommonAtlas;
			
			items = new <BingoAnimationItem> [
				/*BingoAnimationItem.create(atlas.getTexture("card/bingo/_b"), atlas.getTexture("card/bingo/b"), 		0, 	0, 	Math.PI * 0 / 16, -60, 0, 0),
				BingoAnimationItem.create(atlas.getTexture("card/bingo/_i"), atlas.getTexture("card/bingo/i"), 		50, -4, Math.PI * 2 / 16, -40, 0, 0.1),
				BingoAnimationItem.create(atlas.getTexture("card/bingo/_n"), atlas.getTexture("card/bingo/n"), 		109,-7, Math.PI * 4 / 16, -20, 0, 0.2),
				
				BingoAnimationItem.create(atlas.getTexture("card/bingo/_!"), atlas.getTexture("card/bingo/!"), 		361,-25,Math.PI * 12 / 16, 60, 0, 0.6),
				BingoAnimationItem.create(atlas.getTexture("card/bingo/_!!"), atlas.getTexture("card/bingo/!!"), 	321,-22,Math.PI * 10 / 16, 40, 0, 0.5),
				
				BingoAnimationItem.create(atlas.getTexture("card/bingo/_o"), atlas.getTexture("card/bingo/o"), 		265,-14,Math.PI * 8 / 16, 20, 0, 0.4),
				BingoAnimationItem.create(atlas.getTexture("card/bingo/_g"), atlas.getTexture("card/bingo/g"), 		189,-11,Math.PI * 6 / 16, 0, 0, 0.3)*/
				
				BingoAnimationItem.create(atlas.getTexture("card/bingo/_b"), atlas.getTexture("card/bingo/b"), 		0, 	0, 	Math.PI * 0 / 16, -60, 0, 0, 30 * Math.PI / 180),
				BingoAnimationItem.create(atlas.getTexture("card/bingo/_i"), atlas.getTexture("card/bingo/i"), 		50, -4, Math.PI * 3 / 16, -40, 0, 0.1),
				BingoAnimationItem.create(atlas.getTexture("card/bingo/_n"), atlas.getTexture("card/bingo/n"), 		109,-7, Math.PI * 7 / 16, -20, 0, 0.2, -30 * Math.PI / 180),
				
				BingoAnimationItem.create(atlas.getTexture("card/bingo/_!"), atlas.getTexture("card/bingo/!"), 		361,-25,Math.PI * 20 / 16, 60, 0, 0.6, 30 * Math.PI / 180),
				BingoAnimationItem.create(atlas.getTexture("card/bingo/_!!"), atlas.getTexture("card/bingo/!!"), 	321,-22,Math.PI * 17 / 16, 40, 0, 0.5),
				
				BingoAnimationItem.create(atlas.getTexture("card/bingo/_o"), atlas.getTexture("card/bingo/o"), 		265,-14,Math.PI * 14 / 16, 20, 0, 0.4),
				BingoAnimationItem.create(atlas.getTexture("card/bingo/_g"), atlas.getTexture("card/bingo/g"), 		189, -11, Math.PI * 10 / 16, 0, 0, 0.3, 30 * Math.PI / 180)
			];
			
			flare = new Image(AtlasAsset.CommonAtlas.getTexture("effects/rays"));
			flare.pivotX = 112 * pxScale;
			flare.pivotY = 112 * pxScale;
			flare.touchable = false;
			flare.x = positionX;
			flare.y = positionY;
			flare.scale = 0;
			container.addChild(flare);
			
			shadow = new Image(AtlasAsset.CommonAtlas.getTexture("card/bingo_shadow"));
			//shadow.pivotX = 80 * pxScale;
			//shadow.pivotY = 13 * pxScale;
			shadow.touchable = false;
			shadow.x = positionX;
			shadow.y = positionY + 25*pxScale;
			//shadow.scale = baseScale;
			shadow.width = 445 * pxScale * baseScale;
			shadow.height = 139 * pxScale * baseScale;
			shadow.alignPivot();
			shadow.alpha = 0;
			container.addChild(shadow);
			
			var i:int;
			var length:int = items.length;
			var item:BingoAnimationItem;
			var minX:int;
			var maxX:int;
			
			for (i = 0; i < length; i++) 
			{
				item = items[i];
				item.alignPivot();
				item.backImage.alignPivot();
				item.x = positionX + item.positionX;
				item.y = positionY + item.positionY;
				item.waveTweenEnabled = true;
				item.scale = 0;
				
				minX = Math.min(item.positionX - item.pivotX, minX);
				maxX = Math.max(item.positionX + item.pivotX, maxX);
				
				container.addChildAt(item.backImage, container.numChildren - 2*i - 1);
				container.addChild(item);
				
				if (i == 0)
					minChildIndex = container.numChildren - 2 * i - 1;
			}
			
			var shiftX:int = (maxX - minX)/2 - items[0].pivotX;
			for (i = 0; i < length; i++) {
				item = items[i];
				item.positionX -= shiftX;
			}
			
			//container.addChild(shadow);
		}
		
		public function play(delay:Number = 0.1):void 
		{
			startTime = getTimer();
			
			//appearTweenRatio = -1.2;
			appearTweenRatio = -0.6;
			
			//waveTweenRatio = Math.PI;
			
			Starling.current.stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			var tween_0:Tween = new Tween(flare, 0.2, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(flare, 1.00, Transitions.LINEAR);
			var tween_2:Tween = new Tween(flare, 0.2, Transitions.EASE_OUT);
			
			tween_0.delay = delay;
			tween_0.animate('rotation', 90 * Math.PI / 180);
			tween_0.animate('scale', baseScale * 2.8);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('rotation', Math.PI*3/4);
			tween_1.nextTween = tween_2;
		
			tween_2.animate('rotation', 2*Math.PI);
			tween_2.animate('scale', 0);
			Starling.juggler.add(tween_0);
			
			
			TweenHelper.tween(shadow, 0.25, {alpha:0.8, delay:(delay + 0.45)}).chain(shadow, 0.25, {alpha:0, delay:(delay + 0.65)});
			Starling.juggler.tween(shadow, 1.0, {y:(positionY + 55*pxScale), delay:(delay + 0.3)});
		}
		
		public function forceComplete(forClean:Boolean):void 
		{
			
			
			completeAnimation(!forClean);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			var currentFrame:Number = (getTimer() - startTime)/16.6;
			
			//appearTweenRatio += 0.075;
			appearTweenRatio = -0.6 + currentFrame * 0.075;//0.075/mult;
			//appearTweenRatio += 0.015;
			
			if (appearTweenRatio >= 1) 
			{
				//waveTweenRatio = -0.250/mult;
				//waveTweenRatio -= 0.325;
				//waveTweenRatio -= 0.0625;
				//waveTweenRatio -= 0.015;
				
				waveTweenRatio = -(currentFrame * 0.250) % (2 * Math.PI);
				
				//if (waveTweenRatio < -(2 * Math.PI))
					//waveTweenRatio = 0;
			}
			
			reposition();
			
			/*if ((getTimer() - startTime >= 1050*mult)) 
				upScaleCoefficient += 0.048;*/
			
			
			if (!toFinishTween && (getTimer() - startTime >= 1130*mult)) 
			{
				toFinishTween = true;
				
				var i:int;
				var length:int = items.length;
				var item:BingoAnimationItem;
				for (i = 0; i < length; i++) 
				{
					item = items[i];
					item.waveTweenEnabled = false;
					
					var tween_00:Tween = new Tween(item, 0.12*mult, Transitions.LINEAR)//EASE_IN);
					var tween_0:Tween = new Tween(item, 0.1*mult, Transitions.LINEAR) //EASE_OUT);
					
					var maxScale:Number = 2.00 * baseScale;
					
					//trace('>> ', i, tween_00.totalTime, 0.19 * (baseScale*1.95 - item.scale) / 0.7, item.scale, (baseScale*1.95 - item.scale) / 0.7);
					tween_00.animate('scale', maxScale);
					tween_00.animate('x', positionX + item.positionX*maxScale + item.maxShiftX);
					tween_00.animate('y', positionY + item.positionY*maxScale + item.maxShiftY);
					tween_00.nextTween = tween_0;
					
					tween_0.animate('scale', baseScale);
					tween_0.animate('x', positionX + item.positionX * baseScale);
					tween_0.animate('y', positionY + item.positionY * baseScale);
					tween_0.onComplete = i == (length - 1) ? completeAnimation : null;
					
					Starling.juggler.add(tween_00);
				}
			}
			
			//item.alpha = 0.7;
		}
		
		private function completeAnimation(callCompleteCallback:Boolean = true):void 
		{
			var i:int;
			var length:int = items.length;
			for (i = 0; i < length; i++) 
			{
				Starling.juggler.removeTweens(items[i]);
				items[i].remove();
			}
			
			Starling.current.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			
			Starling.juggler.removeTweens(flare);
			flare.removeFromParent(true);
			flare = null;
			
			Starling.juggler.removeTweens(shadow);
			shadow.removeFromParent(true);
			shadow = null;
			
			if(callCompleteCallback && completeCallback != null)
				completeCallback(this);
		}
	
		private function reposition():void
		{
			var i:int;
			var length:int = items.length;
			var item:BingoAnimationItem;
			var coefficient:Number = 0;
			var itemAppearCoefficient:Number = 0;
			for (i = 0; i < length; i++) 
			{
				item = items[i];
				
				if (!item.waveTweenEnabled)
					continue;
				
				itemAppearCoefficient = Math.max(0, Math.min(1, appearTweenRatio - item.appearTweenRatioShift));
				
				//trace('itemAppearCoefficient', itemAppearCoefficient);
				
				if(item.initAngle != 0)
					item.rotation = item.initAngle * (1 - itemAppearCoefficient);
				
				coefficient = Math.cos(waveTweenRatio + item.phaseShift) * itemAppearCoefficient;
	
				item.scale = baseScale * (1 + 0.6 + coefficient * 0.35 + upScaleCoefficient) * itemAppearCoefficient;
				item.x = positionX + item.positionX*item.scale*itemAppearCoefficient + coefficient * item.maxShiftX*itemAppearCoefficient;
				item.y = positionY + item.positionY * item.scale * itemAppearCoefficient + coefficient * item.maxShiftY * itemAppearCoefficient;
				
				//item.brightness = itemAppearCoefficient > 0.8 ? (1 + coefficient*0.2) : 1;
			}
		}
		
		public function resize():void
		{
			baseScale = gameCard.scale * (gameManager.layoutHelper.isLargeScreen ? 1.146 : 1);
			positionX = gameCard.x;
			positionY = gameCard.y + 17 * pxScale * baseScale;
			
			var i:int;
			var length:int = items.length;
			var item:BingoAnimationItem;
			var coefficient:Number;
			var itemAppearCoefficient:Number = 0;
			for (i = 0; i < length; i++) 
			{
				item = items[i];
				
				item.scale = baseScale;
				item.x = positionX + item.positionX*item.scale;
				item.y = positionY + item.positionY*item.scale;
				
				item.backImage.x = item.x;
				item.backImage.y = item.y;
				item.backImage.scale = item.scale;
			}
		}
		
		/*private function tweenItem(item:BingoAnimationItem, delay:Number = 0, onComplete:Function = null):void 
		{
			var tween_0:Tween = new Tween(item, 0.27, Transitions.EASE_IN_OUT);
			var tween_1:Tween = new Tween(item, 0.2, Transitions.LINEAR);
			var tween_2:Tween = new Tween(item, 0.2, Transitions.LINEAR);
			var tween_3:Tween = new Tween(item, 0.2, Transitions.LINEAR);
			var tween_4:Tween = new Tween(item, 0.2, Transitions.LINEAR);
			var tween_5:Tween = new Tween(item, 0.13, Transitions.EASE_OUT);
			
			tween_0.delay = delay;
			tween_0.animate('rotation', 0);
			tween_0.animate('scale', 1.8);
			tween_0.animate('x', positionX + item.positionX + 1.8 * item.maxShiftX);
			tween_0.animate('y', positionY + item.positionY + 1.8 * item.maxShiftY);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scale', 1.36);
			tween_1.animate('x', positionX + item.positionX + 1.36 * item.maxShiftX);
			tween_1.animate('y', positionY + item.positionY + 1.36 * item.maxShiftY);
			tween_1.nextTween = tween_2;
		
			tween_2.animate('scale', 1.8);
			tween_2.animate('x', positionX + item.positionX + 1.8 * item.maxShiftX);
			tween_2.animate('y', positionY + item.positionY + 1.8 * item.maxShiftY);
			tween_2.nextTween = tween_3;
			
			tween_3.animate('scale', 1.36);
			tween_3.animate('x', positionX + item.positionX + 1.36 * item.maxShiftX);
			tween_3.animate('y', positionY + item.positionY + 1.36 * item.maxShiftY);
			tween_3.nextTween = tween_4;
		
			tween_4.animate('scale', 1.8);
			tween_4.animate('x', positionX + item.positionX + 1.8 * item.maxShiftX);
			tween_4.animate('y', positionY + item.positionY + 1.8 * item.maxShiftY);
			tween_4.nextTween = tween_5;
			
			tween_5.animate('scale', 1);
			tween_5.animate('x', positionX + item.positionX);
			tween_5.animate('y', positionY + item.positionY);
			tween_5.onComplete = onComplete;
			
			Starling.juggler.add(tween_0);
		}*/
		
	}
}
