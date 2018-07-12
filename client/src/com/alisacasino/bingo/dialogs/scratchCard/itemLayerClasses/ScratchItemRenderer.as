package com.alisacasino.bingo.dialogs.scratchCard.itemLayerClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.scratchCard.ScratchItem;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import feathers.controls.renderers.LayoutGroupListItemRenderer;
	import feathers.core.FeathersControl;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ScratchItemRenderer extends FeathersControl
	{
		
		private var _scratchItem:ScratchItem;
		
		public function get scratchItem():ScratchItem 
		{
			return _scratchItem;
		}
		
		public function set scratchItem(value:ScratchItem):void 
		{
			if (_scratchItem != value)
			{
				_scratchItem = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		private var _multiplier:int;
		
		public function get multiplier():int 
		{
			return _multiplier;
		}
		
		public function set multiplier(value:int):void 
		{
			if (_multiplier != value)
			{
				_multiplier = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		private var winningMarker:Image;
		private var label:XTextField;
		private var multiplierLabel:XTextField;
		private var bingoCashLabel:XTextField;
		
		public function ScratchItemRenderer() 
		{
			
		}
		
		public function playWinAnimation(delay:Number):void 
		{
			showWinningMarker(delay);
		}
		
		private function showWinningMarker(delay:Number):void 
		{
			if (!winningMarker)
			{
				winningMarker = new Image(AtlasAsset.ScratchCardAtlas.getTexture("win_mark"));
				winningMarker.scale9Grid = ResizeUtils.getScaledRect(16, 16, 6, 6);
				winningMarker.width = 174 * pxScale;
				winningMarker.height = 92 * pxScale;
				winningMarker.alignPivot();
				winningMarker.x = actualWidth / 2;
				winningMarker.y = actualHeight / 2;
			}
			addChildAt(winningMarker, 0);
			winningMarker.alpha = 0;
			//winningMarker.scale = 0;
			Starling.juggler.tween(winningMarker, 0.4, { delay: delay, "alpha#": 1, transition:Transitions.EASE_OUT_ELASTIC});
			Starling.juggler.delayCall(playSfx, delay);
		}
		
		private function playSfx():void 
		{
			SoundManager.instance.playSfx(SoundAsset.SfxPlayerBingoed01);
		}
		
		public function hideWinningMarker():void 
		{
			if (winningMarker)
			{
				Starling.juggler.removeTweens(winningMarker);
				winningMarker.removeFromParent();
			}
		}
		
		override protected function initialize():void 
		{
			super.initialize();
		
			label = new XTextField(124*pxScale, 54*pxScale, XTextFieldStyle.getChateaudeGarage(80, 0x333333).addStroke(1, 0xb5dade));
			label.autoScale = true;
			addChild(label);
			
			bingoCashLabel = new XTextField(140*pxScale, 60*pxScale, XTextFieldStyle.getChateaudeGarage(19, 0x333333).addStroke(1, 0xb5dade), "BINGO CASH");
			bingoCashLabel.alignPivot();
			addChild(bingoCashLabel);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				hideWinningMarker();
				
				commitData();
			}
			
			label.redraw();
			label.x = (actualWidth - label.width) / 2;
			label.y = (actualHeight - label.height) / 2 - 10 * pxScale;
			
			bingoCashLabel.x = actualWidth / 2;
			bingoCashLabel.y = 104 * pxScale;
			
			if (multiplier > 1)
			{
				if (!multiplierLabel)
				{
					multiplierLabel = new XTextField(90 * pxScale, 60 * pxScale, XTextFieldStyle.getWalrus(30), "");
					multiplierLabel.alignPivot();
					multiplierLabel.x = actualWidth / 2;
					multiplierLabel.y = 30 * pxScale;
				}
				
				var color:uint = 0xffffff;
				switch(multiplier)
				{
					case 5:
					case 50:
						color = 0xfff000;
						break;
					case 10:
						color = 0xf9c3ff;
						break;
					case 20:
						color = 0x63ff5f;
						break;
				}
				
				multiplierLabel.textStyle = XTextFieldStyle.getWalrus(36, color).addStroke(1, 0x0);
				multiplierLabel.text = multiplier.toString() + "X";
				addChild(multiplierLabel);
			}
			else
			{
				if (multiplierLabel)
					multiplierLabel.removeFromParent();
			}
		}
		
		
		protected function commitData():void 
		{
			if (!scratchItem)
			{
				return;
			}
			
			/*
			icon.setContent(scratchItem.type, scratchItem.winningType, scratchItem.iconRepeat);
			*/
			
			label.text = "$" + scratchItem.winningQuantity.toString();
			
			//label.visible = (scratchItem.type == ScratchItem.TYPE_COMMODITY);
		}
		
	}

}