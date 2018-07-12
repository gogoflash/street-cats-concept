package com.alisacasino.bingo.screens.lobbyScreenClasses
{
	import com.alisacasino.bingo.controls.CoinsBar;
	import com.alisacasino.bingo.controls.EnergyBar;
	import com.alisacasino.bingo.controls.KeysBar;
	import com.alisacasino.bingo.controls.ScoreBar;
	import com.alisacasino.bingo.controls.TicketsBar;
	import com.alisacasino.bingo.controls.XpBar;
	import com.alisacasino.bingo.screens.GameScreen;
	import starling.display.Sprite;
	
	
	public class LobbyTopPanel extends Sprite
	{
		
		private var gameScreen:GameScreen;
		
		public var xpBar:XpBar;
		public var coinsBar:CoinsBar;
		public var ticketsBar:TicketsBar;
		public var energyBar:EnergyBar;
		//public var keysBar:KeysBar;
		public var scoreBar:ScoreBar;
		
		public var gap:Number = 0;
		
		
		public function LobbyTopPanel(gameScreen:GameScreen)
		{
			this.gameScreen = gameScreen;
			init();
		}
		
		public function init():void
		{				
			xpBar = new XpBar();
			addChild(xpBar);
			
			coinsBar = new CoinsBar();
			addChild(coinsBar);
			
			ticketsBar = new TicketsBar();
			addChild(ticketsBar);
			
			energyBar = new EnergyBar();
			addChild(energyBar);
			
			//keysBar = new KeysBar();
			//addChild(keysBar);
			
			scoreBar = new ScoreBar();
			addChild(scoreBar);
			
			scoreBar.visible = false;
				
			//resize();
		}

		public function show():void
		{
			visible = true;
			
			/*
			if (gameScreen.roomType.hasActiveEvent)
			{
				xpBar.visible = false;
				scoreBar.visible = true;
			}
			*/
		}
		
		public function resize():void
		{
			var topBarHeight:Number;
			var topBarElementsTotalWidth:Number;
			var totalGapWidth:Number;
			const TOP_BAR_MIN_GAP:Number = 4;
			
			var topBarScale:Number = gameManager.layoutHelper.barScale;
			scaleElements();
			calcWidthAndGap();
			
			// если не помещается
			if (topBarElementsTotalWidth + totalGapWidth > gameManager.layoutHelper.stageWidth)
			{
				var topBarElementsTotalWidth_notScaled:Number = topBarElementsTotalWidth / topBarScale;
				topBarScale = (gameManager.layoutHelper.stageWidth - totalGapWidth) / topBarElementsTotalWidth_notScaled;
				scaleElements();
				calcWidthAndGap();
			}
			
			topBarHeight = gameManager.layoutHelper.stageEtalonHeight * topBarScale * 0.21;
			gameScreen.menuButton.x = 0;
			gameScreen.menuButton.y = 16*pxScale;
			xpBar.x = gameScreen.menuButton.x + gameScreen.menuButton.width + xpBar.width / 2 + gap;
			xpBar.y = topBarHeight * 0.42;
			scoreBar.x = gameScreen.menuButton.x + gameScreen.menuButton.width + scoreBar.width / 2 + gap;
			scoreBar.y = topBarHeight * 0.42;
			
			coinsBar.x = xpBar.x + xpBar.width / 2 + coinsBar.width / 2 + gap;
			coinsBar.y = topBarHeight * 0.42;
			ticketsBar.x = coinsBar.x + coinsBar.width / 2 + ticketsBar.width / 2 + gap;
			ticketsBar.y = topBarHeight * 0.42;
			energyBar.x = ticketsBar.x + ticketsBar.width / 2 + energyBar.width / 2 + gap;
			energyBar.y = topBarHeight * 0.42;
			
			if (gameManager.layoutHelper.isLargeScreen)
			{
				//keysBar.x = energyBar.x + energyBar.width / 2 + keysBar.width / 2 + gap;
				//keysBar.y = topBarHeight * 0.42;
				if (gameScreen.mFullscreenBtn)
				{
					gameScreen.mFullscreenBtn.x = gameManager.layoutHelper.stageWidth - gameScreen.mFullscreenBtn.width - gap;
					gameScreen.mFullscreenBtn.y = topBarHeight * 0.42 - gameScreen.mFullscreenBtn.height / 2 + 60*pxScale;
				}
			}
			else
			{
				//keysBar.x = ticketsBar.x + ticketsBar.width / 2 + keysBar.width / 2 + gap;
				//keysBar.y = topBarHeight * 0.42;
				//keysBar.visible = false;
			}
			
			function calcWidthAndGap():void
			{
				if (gameManager.layoutHelper.isLargeScreen)
				{
					if (gameScreen.mFullscreenBtn)
					{
						topBarElementsTotalWidth = gameScreen.menuButton.width + xpBar.width + coinsBar.width + ticketsBar.width + energyBar.width + /*keysBar.width +*/ gameScreen.mFullscreenBtn.width;
						caclGapData(8);
					}
					else
					{
						topBarElementsTotalWidth = gameScreen.menuButton.width + xpBar.width + coinsBar.width + ticketsBar.width + energyBar.width + energyBar.width;
						caclGapData(7);
					}
				}
				else
				{
					topBarElementsTotalWidth = gameScreen.menuButton.width + xpBar.width + coinsBar.width + ticketsBar.width/* + keysBar.width*/;
					caclGapData(6);
				}
			}
			
			function scaleElements():void
			{
				//gameScreen.menuButton.scaleX = gameScreen.menuButton.scaleY = topBarScale;
				
				xpBar.scaleX = xpBar.scaleY = topBarScale;
				coinsBar.scaleX = coinsBar.scaleY = topBarScale;
				ticketsBar.scaleX = ticketsBar.scaleY = topBarScale;
				energyBar.scaleX = energyBar.scaleY = topBarScale;
				//keysBar.scaleX = keysBar.scaleY = topBarScale;
				if (gameScreen.mFullscreenBtn)
					gameScreen.mFullscreenBtn.scale = 0.3;
				scoreBar.scaleX = scoreBar.scaleY = topBarScale;
			}
			
			function caclGapData(nGaps:int):void
			{
				gap = (gameManager.layoutHelper.stageWidth - topBarElementsTotalWidth) / nGaps;
				if (gap < TOP_BAR_MIN_GAP)
					gap = TOP_BAR_MIN_GAP;
				totalGapWidth = gap * nGaps;
			}
			
		}
		
	}
}