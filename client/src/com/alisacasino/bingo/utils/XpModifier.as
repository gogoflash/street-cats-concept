package com.alisacasino.bingo.utils 
{
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	public class XpModifier 
	{
		public function XpModifier()  {
		}
		
		private var xpBonusLevelMin:int;
		private var xpBonusLevelMax:int;
		private var xpBonusMultiplier:Number = 1;
		
		private var lastMultiplierValue:Number = 1;
		private var lastAddXpValue:int;
		private var lastOriginalXpEarned:int;
		
		public function modifyPlayerXp():void
		{
			var currentLevel:int = gameManager.gameData.getLevelForXp(Player.current.xpCount);
			if (currentLevel < xpBonusLevelMin || currentLevel > xpBonusLevelMax) {
				lastMultiplierValue = 1;
				return;
			}
			
			var multiplierPerLevel:Number = (xpBonusMultiplier-1) / (xpBonusLevelMax - xpBonusLevelMin);
				
			lastMultiplierValue = (xpBonusLevelMax-currentLevel) * multiplierPerLevel + 1;
			lastAddXpValue = Math.ceil(lastMultiplierValue * Player.current.xpEarned) - Player.current.xpEarned;
			
			lastOriginalXpEarned = Player.current.xpEarned;
			Player.current.xpEarned += lastAddXpValue;
			//lastAddXpValue = Player.current.xpEarned - lastOriginalXpEarned;
		}
		
		public function deserializeStaticData(staticDataRaw:Object):void
		{
			xpBonusLevelMin = 'xpBonusLevelMin' in staticDataRaw ? staticDataRaw['xpBonusLevelMin'] : 0;
			xpBonusLevelMax = 'xpBonusLevelMax' in staticDataRaw ? staticDataRaw['xpBonusLevelMax'] : 0;
			xpBonusMultiplier = 'xpBonusMultiplier' in staticDataRaw ? staticDataRaw['xpBonusMultiplier'] : 1;
			
			if ((xpBonusLevelMin == 0 && xpBonusLevelMax == 0) || (xpBonusLevelMin >= xpBonusLevelMax)) {
				xpBonusLevelMin = -1;
				xpBonusLevelMax = -1;
				xpBonusMultiplier = 1;
			}
		}	
		
		public function showModifiers(container:DisplayObjectContainer):void 
		{
			if (!Constants.isDevFeaturesEnabled || lastMultiplierValue <= 1)
				return;
			
			var infoLabel:XTextField = new XTextField(1, 1, XTextFieldStyle.getChateaudeGarage(16, 0xFF007F));
			infoLabel.text = lastMultiplierValue.toPrecision(2) + ' * ' + lastOriginalXpEarned.toString() + 'xp = ' + Player.current.xpEarned.toString() + 'xp (+' + lastAddXpValue.toString() + 'xp)';
			infoLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			infoLabel.x = container.x + (container.width - infoLabel.width)/2;
			infoLabel.y = container.y + container.height - 30 * pxScale;
			//infoLabel.alpha = 0;
			container.parent.addChild(infoLabel);
			
			//Starling.juggler.tween(infoLabel, 0.5, {delay:3.5, alpha:1});
		}
		
	}

}