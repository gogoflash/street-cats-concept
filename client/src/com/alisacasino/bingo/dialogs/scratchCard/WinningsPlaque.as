package com.alisacasino.bingo.dialogs.scratchCard 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.StringUtils;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class WinningsPlaque extends FeathersControl
	{
		private var background:Image;
		private var winningsAmountLabel:XTextField;
		private var winningsIcon:Image;
		private var winningsContainer:Sprite;
		private var tweenId:uint;
		private var _baseColor:uint;
		
		public function WinningsPlaque(winningsColor:uint) 
		{
			_baseColor = winningsColor;
			background = new Image(AtlasAsset.ScratchCardAtlas.getTexture("win_frame"));
			background.scale9Grid = ResizeUtils.getScaledRect(12, 12, 6, 6);
			background.width = 332 * pxScale;
			background.height = 100 * pxScale;
			addChild(background);
			
			/*
			var winText:XTextField = new XTextField(100 * pxScale, 64 * pxScale, XTextFieldStyle.Yellow70C, "GOOD LUCK!");
			winText.x = 14*pxScale;
			winText.y = 3 * pxScale;
			addChild(winText);
			*/
			
			winningsContainer = new Sprite();
			addChild(winningsContainer);
			
			winningsAmountLabel = new XTextField(332 * pxScale, 90 * pxScale, XTextFieldStyle.getWalrus(40, winningsColor), "");
			winningsAmountLabel.y = 6 * pxScale;
			winningsContainer.addChild(winningsAmountLabel);
			showGoodLuck();
		}
		
		public function set baseColor(value:uint):void
		{
			if (_baseColor == value)
				return;
				
			_baseColor = value;	
			winningsAmountLabel.format.color = _baseColor;
		}
		
		public function get baseColor():uint
		{
			return _baseColor;
		}		
		
		public function hideWinnings():void
		{
			winningsContainer.visible = false;
			Starling.juggler.removeTweens(winningsContainer);
		}
		
		public function showGoodLuck():void
		{
			winningsAmountLabel.textStyle = XTextFieldStyle.getWalrus(40, _baseColor);
			winningsAmountLabel.text = "GOOD LUCK";
		}
		
		public function showWinnings(winnings:CommodityItem):void
		{
			winningsAmountLabel.width = 332 * pxScale;
			winningsAmountLabel.textStyle = XTextFieldStyle.getChateaudeGarage(50, _baseColor);
			if (winnings)
			{
				winningsAmountLabel.text = "$" + StringUtils.delimitThousands(winnings.quantity, "'");
			}
			else
			{
				winningsAmountLabel.text = "TRY AGAIN";
			}
			
			winningsContainer.alpha = 0;
			winningsContainer.visible = true;
			tweenId = Starling.juggler.tween(winningsContainer, 0.2, {'alpha#':1, repeatCount:5, reverse:true});
		}
		
		public function getGlobalIconPoint():Point
		{
			return localToGlobal(new Point(winningsIcon.x, winningsIcon.y));
		}
		
	}

}