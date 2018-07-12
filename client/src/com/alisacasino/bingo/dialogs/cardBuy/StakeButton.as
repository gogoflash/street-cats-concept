package com.alisacasino.bingo.dialogs.cardBuy 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.components.Scale9Image;
	import com.alisacasino.bingo.components.Scale9Textures;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.game.StakeData;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.UIUtils;
	import feathers.controls.BasicButton;
	import feathers.controls.ButtonState;
	import feathers.core.FeathersControl;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class StakeButton extends BasicButton
	{
		
		private const baseWidth:Number = 107;
		private const expandedWidth:Number = 187;
		private const baseHeight:Number = 58;
		static public const COMPACT:String = "compact";
		static public const EXPANDED:String = "expanded";
		private var xLabel:XTextField;
		private var elementsContainer:Sprite;
		private var background:Image;
		private var textContainer:Sprite;
		private var cardBoostTextFilter:BrightnessFilter;
		private var greenArrows:Image;
		private var quad:Quad;
		private var mode:String = COMPACT;
		
		public function get currentStake():StakeData 
		{
			return Room.current.stakeData;
		}
		
		public function StakeButton() 
		{
			debugMode = true;
			width = baseWidth * pxScale;
			height = baseHeight * pxScale;
			useHandCursor = true;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			quad = new Quad(width, height, 0xFF0000);
			quad.alpha = 0;
			defaultSkin = quad;
			
			elementsContainer = new Sprite();
			addChild(elementsContainer);
			background = new Image(AtlasAsset.CommonAtlas.getTexture("buttons/button_gray_flat_2"));
			background.scale9Grid = ResizeUtils.getScaledRect(14, 14, 1, 1);
			//background.visible = Math.random() > 0.5;
			elementsContainer.addChild(background);
			
			textContainer = new Sprite();
			textContainer.optionalFilter = true;
			cardBoostTextFilter = new BrightnessFilter();
			textContainer.filter = cardBoostTextFilter;
			var sizeQuad:Quad = new Quad(baseWidth * pxScale, baseHeight*pxScale);
			sizeQuad.visible = false;
			textContainer.addChild(sizeQuad);
			textContainer.alignPivot();
			textContainer.x = sizeQuad.width / 2;
			textContainer.y = sizeQuad.height / 2;
			elementsContainer.addChild(textContainer);
			
			var boostLabel:XTextField = new XTextField(baseWidth * pxScale, 40 * pxScale, XTextFieldStyle.getWalrus(16, 0xffffff).addStroke(1, 0x0), "BOOST");
			boostLabel.y = 22.5 * pxScale;
			textContainer.addChild(boostLabel);
			
			var cardsLabel:XTextField = new XTextField(baseWidth * pxScale, 40 * pxScale, XTextFieldStyle.getWalrus(24, 0x99ff00).addStroke(1, 0x0), "CARDS");
			cardsLabel.y = 1.5 * pxScale;
			textContainer.addChild(cardsLabel);
			
			elementsContainer.alignPivot();
			elementsContainer.x = elementsContainer.width / 2;
			elementsContainer.y = height / 2;
			
			background.width = baseWidth*pxScale;
			background.height = baseHeight*pxScale;
		}
		
		private function room_changeHandler(e:Event):void 
		{
			updateContents();
		}
		
		private function updateContents():void
		{
			Starling.juggler.removeTweens(this);
			Starling.juggler.removeTweens(quad);
			
			if (xLabel)
			{
				tweenXLabelAway();
			}
			else
			{
				TweenHelper.tween(textContainer, 0.1, { scaleX: 0.8, scaleY: 1.3 } )
					.chain(textContainer, 0.1, { scaleY: 0.8, scaleX:1.1 } )
					.chain(textContainer, 0.08, { scaleY: 1, scaleX: 1 } );
				TweenHelper.tween(cardBoostTextFilter, 0.1, { brightness: 1 } )
					.chain(cardBoostTextFilter, 0.1, { brightness: 0 } );
					
				greenArrows = new Image(AtlasAsset.CommonAtlas.getTexture("stakes/green_arrows"));
				greenArrows.optionalFilter = true;
				greenArrows.x = (baseWidth - 8) * pxScale;
				greenArrows.alignPivot(Align.LEFT, Align.CENTER);
				greenArrows.y = (baseHeight / 2 - 1) * pxScale;;
				
				var gaf:BrightnessFilter = new BrightnessFilter();
				gaf.brightness = 1;
				greenArrows.filter = gaf;
				greenArrows.scaleY = 1.2;
				greenArrows.scaleX = 0.5;
				
				TweenHelper.tween(greenArrows, 0.1, { delay: 0.1, scaleX: 1.4, scaleY:0.8, onStart: elementsContainer.addChild, onStartArgs: [greenArrows] } )
					.chain(greenArrows, 0.1, { scaleY: 1, scaleX:1 } );
				TweenHelper.tween(gaf, 0.1, { delay: 0.2, brightness: 0 } );
			}
			
			if (currentStake.multiplier > 1)
			{
				xLabel = new XTextField(80 * pxScale, baseHeight * pxScale, XTextFieldStyle.getWalrus(42, 0xffffff).addStroke(1, 0x0), "");
				xLabel.optionalFilter = true;
				xLabel.x = baseWidth * pxScale + 42*pxScale;
				xLabel.y = (baseHeight / 2 + 2)* pxScale;
				xLabel.alignPivot();
				elementsContainer.addChild(xLabel);
				
				var bf:BrightnessFilter = new BrightnessFilter();
				bf.brightness = 1;
				xLabel.filter = bf;
				xLabel.scaleY = 0;
				
				TweenHelper.tween(xLabel, 0.1, { delay: 0.2, scaleX: 0.8, scaleY: 1.4 } )
					.chain(xLabel, 0.1, { scaleY: 0.8, scaleX:1.2 } )
					.chain(xLabel, 0.08, { scaleY: 1, scaleX: 1 } );
				TweenHelper.tween(bf, 0.1, { delay: 0.3, brightness: 0 } );
				
				Starling.juggler.tween(background, 0.2, { width:expandedWidth * pxScale } );
				mode = EXPANDED;
				invalidate(INVALIDATION_FLAG_SIZE);
				
				xLabel.text = currentStake.label.toUpperCase();
			}
			else
			{
				if (greenArrows)
				{
					Starling.juggler.removeTweens(greenArrows);
					
					TweenHelper.tween(greenArrows, 0.1, { scaleX: 1.4, scaleY:0.8 } )
						.chain(greenArrows, 0.1, { scaleY: 1.4, scaleX:0, onComplete: greenArrows.removeFromParent } );
					if(greenArrows.filter)
						TweenHelper.tween(greenArrows.filter, 0.1, { brightness: 1 } );
				}
				
				Starling.juggler.tween(background, 0.2, { width:baseWidth * pxScale } );
				mode = COMPACT;
				invalidate(INVALIDATION_FLAG_SIZE);
				xLabel = null;
			}
		}
		
		private function tweenXLabelAway():void 
		{
			Starling.juggler.removeTweens(xLabel);
			
			var bf:BrightnessFilter = new BrightnessFilter();
			bf.brightness = 0;
			xLabel.filter = bf;
			
			TweenHelper.tween(xLabel, 0.1, { scaleX: 0.8, scaleY: 1.4 } )
				.chain(xLabel, 0.1, { scaleY: 0.0, scaleX:1.2, onComplete: xLabel.removeFromParent} );
			TweenHelper.tween(bf, 0.1, { brightness: 1 } );
		}
		
		override protected function feathersControl_addedToStageHandler(event:Event):void 
		{
			super.feathersControl_addedToStageHandler(event);
			if (Room.current)
			{
				Room.current.addEventListener(Event.CHANGE, room_changeHandler);
				updateContents();
			}
		}
		
		override protected function feathersControl_removedFromStageHandler(event:Event):void 
		{
			super.feathersControl_removedFromStageHandler(event);
			if (Room.current)
			{
				Room.current.removeEventListener(Event.CHANGE, room_changeHandler);
			}
		}
		
		override protected function draw():void 
		{
			width = quad.width = ((mode == EXPANDED) ? expandedWidth : baseWidth) * pxScale;
			super.draw();
		}
		

		override protected function refreshSkin():void 
		{
			super.refreshSkin();
			elementsContainer.scale = (currentState == ButtonState.DOWN || currentState == ButtonState.DOWN_AND_SELECTED) ? 0.94 : 1;
		}

	}

}

import starling.filters.ColorMatrixFilter

class BrightnessFilter extends ColorMatrixFilter
{
    private var _brightness:Number;
 
    public function BrightnessFilter()
    {
        _brightness = 0;
    }
 
    public function get brightness():Number { return _brightness; }
    public function set brightness(value:Number):void
    {
        _brightness = value;
        reset();
        adjustBrightness(value);
    }
}