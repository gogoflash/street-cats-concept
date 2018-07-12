package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.dialogs.ServiceDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.TutorialManager;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.gameScreenClasses.GameUIPanel;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import feathers.core.FeathersControl;
	import flash.utils.getTimer;
	import starling.animation.Tween;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BallsBar extends FeathersControl
	{
		public static var DEBUG_TAKE_BALL_NUMBER_BY_CLICK:Boolean = false;
		
		private const NORMAL_BALL_SCALE:Number = 0.745;
		private const NORMAL_BALL_SCALE_TABLET:Number = 0.65;
		
		private var gameUIPanel:GameUIPanel;
		private var mSoundManager:SoundManager = SoundManager.instance;
		private var lastBallBackground:Image;
		private var ballContainer:Sprite;
		private var ballNumberContainer:Sprite;
		//private var mOrigWidth:Number;
		//private var mEffectiveWidth:Number;
		
		private var mBallSize:Number;
		private var mBallGap:Number = 0;
		private var balls:Array;
		private var ballsMaxCount:uint;
		private var isAnimationInProgress:Boolean;
		private var queue:Array;
		private var queueTimer:Timer;
		private const BALL_ANIMATION_DURATION:Number = 0.4;
		private const QUEUE_TIMER_INTERVAL:Number = 500;
		private var testQuad:Quad;
		
		private var ballY:Number;
		private var normalBallScale:Number;
		
		public function BallsBar(gameUIPanel:GameUIPanel)
		{
			this.gameUIPanel = gameUIPanel;
			
			testQuad = new Quad(10, 10, 0xFF00FF);
			testQuad.alpha = 0.2;
			//addChild(testQuad);
			
			lastBallBackground = new Image(AtlasAsset.CommonAtlas.getTexture("balls/last_ball_background"));
			lastBallBackground.scale9Grid = ResizeUtils.getScaledRect(11, 11, 1, 1);
			lastBallBackground.width = 159*pxScale;
			lastBallBackground.height = 159*pxScale;
			lastBallBackground.addEventListener(TouchEvent.TOUCH, lastBallBgTouch);
			addChild(lastBallBackground);
			
			ballContainer = new Sprite();
			ballContainer.touchable = false;
			ballNumberContainer = new Sprite();
			ballNumberContainer.touchable = false;
			
			//mOrigWidth = mTop.width;
			mBallSize = 116 * pxScale;
			balls = [];
			queue = [];
			
			setSizeInternal(lastBallBackground.width, lastBallBackground.height, false);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			queueTimer = new Timer(QUEUE_TIMER_INTERVAL);
			queueTimer.addEventListener(TimerEvent.TIMER, handler_queueTimer);
			
			gameManager.addEventListener(ConnectionManager.EVENT_CONNECTION_RESTORED, handler_connectionRestored);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addChild(ballContainer);
			addChild(ballNumberContainer);
		}
		
		private function handler_connectionRestored(event:Event):void
		{
			if (queue.length > 0 && !queueTimer.running) {
				checkQueue();
				queueTimer.start();
			}
		}
		
		private function handler_queueTimer(event:TimerEvent):void
		{
			checkQueue();
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				const minGap:Number = 0 * pxScale;
				//One minGap is added to account for the first ball position and gap. 
				//Second is added to make the calculation correct -
				//we are dividing width by the ball+gap size, but we need one less gap than there are balls. 
				//One ball is added to account for the first ball
				
				var isLargeScreen:Boolean = gameManager.layoutHelper.isLargeScreen;
				
				normalBallScale = isLargeScreen ? NORMAL_BALL_SCALE_TABLET : NORMAL_BALL_SCALE;
				mBallSize = normalBallScale * 161 * pxScale;
				
				if (isLargeScreen)
					ballY = Math.max(-29 * pxScale, Math.min(-1 * pxScale, gameUIPanel.gameUI.gameCardsView.topY - 40 * gameUILayoutScale - mBallSize*scale)); 
				else
					ballY = Math.max(-21 * pxScale, Math.min(-1 * pxScale, gameUIPanel.gameUI.gameCardsView.topY - 32 * gameUILayoutScale - mBallSize*scale)); 
				
				gameManager.watchdogs.connectionWatchdog.stopBallTimer();
				
				ballsMaxCount = int((width + minGap * 2 - 160 * pxScale ) / (mBallSize + minGap)) + 1;
				
				//mBallGap = (width - 160 * pxScale - mBallSize * (ballsMaxCount  - 1)) / (ballsMaxCount  - 1);
				mBallGap = minGap;
				testQuad.width = width;
				
				for (var i:int = 0; i < balls.length; i++) {
					alignBall(i);
				}
			}
			
			checkQueue();
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			/*
			if (!mGameManager.layoutHelper.isKindleFire1)
			{
				mBallsShadowsContainer.mask = new Quad(mEffectiveWidth - 6, mBallSize);
				mBallsShadowsContainer.mask.x = 2;
				ballContainer.mask = new Quad(mEffectiveWidth - 6, mBallSize);
				ballContainer.mask.x = 2;
				ballNumberContainer.mask = new Quad(mEffectiveWidth - 6, mBallSize);
				ballNumberContainer.mask.x = 2;
			}
			*/
		}
		
		public function addBall(number:uint, animate:Boolean = true):void
		{
			/*
			if (!animate)
				return;
			*/
				
			if (queue.length > 0 && !queueTimer.running) 
				queueTimer.start();
			
			queue.push([number, animate]);
			invalidate(INVALIDATION_FLAG_DATA);
			//checkQueue(animate);
		}
		
		private function checkQueue():void 
		{
			while(queue.length > 0 && !isAnimationInProgress)
			{
				//Check if all balls are added without animation, then we can only add the ones that would be shown in the actual bar. This should only happen at the start of the round.
				var canTrimQueue:Boolean = true
				for (var i:int = 0; i < queue.length; i++) 
				{
					if (queue[i][1] == true)
					{
						canTrimQueue = false;
						break;
					}
				}
				
				if (canTrimQueue)
				{
					while (queue.length > ballsMaxCount)
					{
						queue.shift();
					}
				}
				
				var queueElement:Array = queue.shift();
				addBallInternal(queueElement[0], queueElement[1]);
			}
		}
		
		private function addBallInternal(number:uint, animate:Boolean = true):void
		{
			var ball:Ball = new Ball(number);
			
			ballContainer.addChild(ball.ballImage);
			ballNumberContainer.addChild(ball.label);
			
			balls.unshift(ball);
			
			if (animate && queue.length == 0 && parent.visible == true)
			{
				mSoundManager.playBallNumber(number);
			}
			
			for (var i:int = 0; i < balls.length; i++)
			{
				ball = balls[i];
				if (animate)
				{
					isAnimationInProgress = true;
					
					if (i == 0)
					{
						tweenBallAppear(ball);
					}
					else if (i == 1)
					{
						Starling.juggler.tween(ball, BALL_ANIMATION_DURATION*2/3, 
						{
							scale: normalBallScale,
							x: getBallPosition(i),
							y: ballY,
							transition: Transitions.EASE_IN
						});
						
						ball.labelAlphaTween();
					}
					else if (i == ballsMaxCount-1)
					{
						Starling.juggler.tween(ball, BALL_ANIMATION_DURATION, 
						{
							scale: normalBallScale,
							alpha: 0.5,
							x: getBallPosition(i),
							y: ballY,
							transition: Transitions.EASE_IN_OUT
						});
					}
					else if (i == ballsMaxCount)
					{
						Starling.juggler.tween(ball, BALL_ANIMATION_DURATION, 
						{
							scale: normalBallScale,
							alpha: 0,
							x: getBallPosition(i),
							y: ballY,
							transition: Transitions.EASE_IN_OUT
						});
					}
					else
					{
						Starling.juggler.tween(ball, BALL_ANIMATION_DURATION, 
						{
							scale: normalBallScale,
							x: getBallPosition(i),
							y: ballY,
							transition: Transitions.EASE_IN_OUT
						});
					}
				}
				else
				{
					alignBall(i);
				}
			}
			
			while (balls.length > ballsMaxCount + 1)
			{
				(balls.pop() as Ball).removeChildren();
			}
		}
		
		private function getBallPosition(i:int):Number
		{
			return (i - 1) * (mBallSize + mBallGap) + (gameManager.layoutHelper.isLargeScreen ? 138 : 145) * pxScale;
		}
		
		private function alignBall(ballIndex:int):void 
		{
			var ball:Ball = balls[ballIndex];
			if (ballIndex == 0)
			{
				ball.x = 3 * pxScale;
				ball.y = 3 * pxScale;
				ball.scale = 1;
			}
			else
			{
				if (ballIndex == ballsMaxCount-1)
					ball.alpha = 0.5;
				
				ball.x = getBallPosition(ballIndex);
				ball.y = ballY;
				ball.scale = normalBallScale;
			}
		}
		
		private function tweenBallAppear(ball:Ball, delay:Number = 0):void
		{
			var tween_0:Tween = new Tween(ball, 0.15, Transitions.EASE_IN);
			var tween_1:Tween = new Tween(ball, 0.07, Transitions.EASE_OUT);
			var tween_2:Tween = new Tween(ball, 0.15, Transitions.EASE_OUT_BACK);
			
			//ball.scaleY = 1;
			ball.scaleX = 0.75;
			ball.x = 3*pxScale;
			ball.y = -ball.ballImage.pivotY - 9*pxScale//ball.ballImage.pivotY -300;
			//ballImage.pivotY + _y
			
			tween_0.delay = delay;
			tween_0.animate('y', 3*pxScale);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', 1.2);
			tween_1.animate('scaleY', 0.83);
			tween_1.animate('y', 15*pxScale);
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scaleX', 1);
			tween_2.animate('scaleY', 1);
			tween_2.animate('y', 3*pxScale);
			tween_2.onComplete = completeTweenBallAppear;
			
			Starling.juggler.add(tween_0);
		}
		
		private function completeTweenBallAppear():void
		{
			isAnimationInProgress = false
		}
		
		public function reset(isStartGame:Boolean):void
		{
			queue = [];
			while (balls.length) {
				(balls.pop() as Ball).removeChildren();
			}
			
			isAnimationInProgress = false;
			
			if (isStartGame) 
				invalidate(INVALIDATION_FLAG_SIZE);
				
			queueTimer.stop()	
		}
		
		private function lastBallBgTouch(event:TouchEvent):void
		{
			if (!DEBUG_TAKE_BALL_NUMBER_BY_CLICK)
				return;
				
			event.stopImmediatePropagation();
		
			var touch:Touch = event.getTouch(lastBallBackground);
			if (touch == null)
				return;

			if (touch.phase == TouchPhase.BEGAN) 
			{
				/*var ballNumber:int = Math.max(1, int(Math.random() * 75));
				Game.current.gameScreen.gameUI.addBall(ballNumber);
				Room.current.numbers.push(ballNumber);*/
				TutorialManager.addBallToGame();
			}
		}
		
		override public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			queueTimer.stop();
			queueTimer.removeEventListener(TimerEvent.TIMER, handler_queueTimer);
			gameManager.removeEventListener(ConnectionManager.EVENT_CONNECTION_RESTORED, handler_connectionRestored);
			
			super.dispose();
		}
		
	}
}