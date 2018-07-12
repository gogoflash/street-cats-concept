package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.utils.TweenHelper;
	
	public class GameCardX2Progress
	{
		public var index:int;
		private var card:GameCard;
		
		private var fuseProgressQuadLeft:Quad;
		private var fuseProgressQuadBgLeft:Quad;
		private var animationFuseLeft:AnimationContainer;
		
		private var fuseProgressQuadRight:Quad;
		private var fuseProgressQuadBgRight:Quad;
		private var animationFuseRight:AnimationContainer;
		
		private var _position:Number;
		private var _progressPosition:Number = 0;
		private var isShowing:Boolean;
		
		private var centerX:Number = 0;
		public	var centerShiftX:Number;
		private var edgeShiftX:Number;
		private var positionY:Number;
		private var progressAmplitude:int;
		
		public function GameCardX2Progress(card:GameCard, index:int)
		{
			this.index = index;
			this.card = card;
			
			//centerX = card.background.width / 2;
			centerShiftX = 52 * pxScale;
			edgeShiftX = 17 * pxScale;
			positionY = 39 * pxScale;
			
			//refresh();
		}
	
		public function refresh():void 
		{
			centerX = card.background.width / 2;
			progressAmplitude = centerX - centerShiftX - edgeShiftX - 24 * pxScale;
		}
		
		public function show(delay:Number = 0, showTweenTime:Number = 0.2):void 
		{
			if (fuseProgressQuadBgLeft) 
			{
				Starling.juggler.removeTweens(this);
				removeViews();
			}
			
			var quadBgHeight:int = 19 * pxScale;
			var quadProgressHeight:int = 21 * pxScale;
				
			fuseProgressQuadBgLeft = new Quad(1, quadBgHeight, 0xcb0d0d);
			fuseProgressQuadBgLeft.pivotY = quadBgHeight/2;
			fuseProgressQuadBgLeft.width = centerX - centerShiftX - edgeShiftX;
			fuseProgressQuadBgLeft.y = positionY;
			fuseProgressQuadBgLeft.x = centerX - centerShiftX - fuseProgressQuadBgLeft.width;
			card.container.addChild(fuseProgressQuadBgLeft);
			
			fuseProgressQuadLeft = new Quad(1, quadProgressHeight, 0xffff00);
			fuseProgressQuadLeft.pivotY = quadProgressHeight/2;
			fuseProgressQuadLeft.y = positionY;
			//fuseProgressQuadLeft.x = background.width/2 - centerShiftX;
			card.container.addChild(fuseProgressQuadLeft);
			
			animationFuseLeft = new AnimationContainer(MovieClipAsset.PackBase); //50 52
			animationFuseLeft.pivotY = 33*pxScale;
			animationFuseLeft.scaleX = -1;
			animationFuseLeft.playTimeline('2xfuze', false, true);
			animationFuseLeft.y = positionY// 6 * pxScale;
			card.container.addChild(animationFuseLeft);
			
			fuseProgressQuadBgRight = new Quad(1, quadBgHeight, 0xcb0d0d);
			fuseProgressQuadBgRight.pivotY = quadBgHeight/2;
			fuseProgressQuadBgRight.y = positionY;
			fuseProgressQuadBgRight.x = centerX + centerShiftX;
			fuseProgressQuadBgRight.width = centerX - centerShiftX - edgeShiftX;
			card.container.addChild(fuseProgressQuadBgRight);
			
			fuseProgressQuadRight = new Quad(1, quadProgressHeight, 0xffff00);
			//fuseProgressQuadRight.height = ;
			fuseProgressQuadRight.pivotY = quadProgressHeight/2;
			fuseProgressQuadRight.y = positionY;
			fuseProgressQuadRight.x = centerX + centerShiftX;
			card.container.addChild(fuseProgressQuadRight);
			
			animationFuseRight = new AnimationContainer(MovieClipAsset.PackBase);
			//animationFuseLeft.pivotX = 1;
			animationFuseRight.pivotY = 33*pxScale;
			animationFuseRight.playTimeline('2xfuze', false, true);
			animationFuseRight.y = positionY;// 6 * pxScale;
			card.container.addChild(animationFuseRight);
			
			showScaleY = 0;
			centerShiftX = 0.15 * card.background.width;
			progressPosition = 0.6;
			
			var startPosition:Number = 1 - (delay + showTweenTime)*1000/gameManager.gameData.x2TimeMs;
			
			Starling.juggler.tween(this, showTweenTime, {showScaleY:1, transition:Transitions.EASE_OUT_BACK, delay:delay});
			Starling.juggler.tween(this, showTweenTime, {centerShiftX:52 * pxScale, progressPosition:startPosition, onUpdate:refreshProgressBackgrounds, onComplete:completeShowing, transition:Transitions.LINEAR, delay:delay});
		}
		
		private function completeShowing():void {
			isShowing = false;
		}
		
		public function hide():void 
		{
			removeViews();
		}
		
		public function set position(value:Number):void 
		{
			if (isShowing)
				return;
			
			progressPosition = value;
			
			//trace('position ', value);
			//Starling.juggler.tween(this, 1, {progressPosition:value, transition:Transitions.LINEAR});	
		}
		
		private function removeViews():void 
		{
			if (animationFuseLeft) 
			{
				animationFuseLeft.stop();
				animationFuseLeft.removeFromParent();
				animationFuseLeft = null;
				
				animationFuseRight.stop();
				animationFuseRight.removeFromParent();
				animationFuseRight = null;
				
				fuseProgressQuadLeft.removeFromParent(true);
				fuseProgressQuadLeft = null;
				
				fuseProgressQuadBgLeft.removeFromParent(true);
				fuseProgressQuadBgLeft = null;
				
				fuseProgressQuadRight.removeFromParent(true);
				fuseProgressQuadRight = null;
				
				fuseProgressQuadBgRight.removeFromParent(true);
				fuseProgressQuadBgRight = null;
			}
		}
		
		public function set showScaleY(value:Number):void 
		{
			if (!fuseProgressQuadBgLeft)
				return;
				
			fuseProgressQuadBgLeft.scaleY = value;
			fuseProgressQuadLeft.scaleY = value;
			animationFuseLeft.scaleY = value;
			
			fuseProgressQuadBgRight.scaleY = value;
			fuseProgressQuadRight.scaleY = value;
			animationFuseRight.scaleY = value;
		}
		
		public function get showScaleY():Number
		{
			return fuseProgressQuadBgLeft ? fuseProgressQuadBgLeft.scaleY : 0;
		}
		
		public function set progressPosition(value:Number):void 
		{
			/*if (_progressPosition == value)
				return;*/
				
			if (!fuseProgressQuadBgLeft)
				return;	
				
			_progressPosition = value;
			
			animationFuseLeft.x = centerX - centerShiftX - _progressPosition * progressAmplitude;
			animationFuseRight.x = centerX + centerShiftX + _progressPosition * progressAmplitude;
			
			fuseProgressQuadRight.width = animationFuseRight.x - centerX - centerShiftX + 3 * pxScale;
			
			fuseProgressQuadLeft.width = fuseProgressQuadRight.width;
			fuseProgressQuadLeft.x = centerX - centerShiftX - fuseProgressQuadLeft.width;
		}
		
		public function get progressPosition():Number
		{
			return _progressPosition;
		}
		
		public function refreshProgressBackgrounds():void 
		{
			if (!fuseProgressQuadRight)
				return;
				
			fuseProgressQuadRight.x = centerX + centerShiftX;
			
			fuseProgressQuadBgLeft.width = centerX - centerShiftX - edgeShiftX;
			fuseProgressQuadBgRight.width = fuseProgressQuadBgLeft.width;
			
			fuseProgressQuadBgLeft.x = centerX - centerShiftX - fuseProgressQuadBgLeft.width;
			fuseProgressQuadBgRight.x = centerX + centerShiftX;
		}
		
	}
}