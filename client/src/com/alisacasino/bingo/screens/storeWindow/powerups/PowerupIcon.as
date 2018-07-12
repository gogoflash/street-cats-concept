package com.alisacasino.bingo.screens.storeWindow.powerups
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.utils.tooltips.TooltipManager;
	import com.alisacasino.bingo.utils.tooltips.TooltipTrigger;
	import feathers.controls.Button;
	import feathers.controls.ButtonState;
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Align;
	import starling.utils.TweenHelper;

	public class PowerupIcon extends FeathersControl
	{
		private var countBackgroundTexture:Texture;
		private var type:String;
		private var label:XTextField;
		private var counterContainer:Sprite;
		private var icon:Image;
		public var value:int;
		
		public function PowerupIcon(type:String, countBackgroundTexture:Texture) 
		{
			super();
			this.type = type;
			this.countBackgroundTexture = countBackgroundTexture;
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			icon = new Image(getIconTexture(type));
			icon.alignPivot();
			icon.x = icon.width / 2;
			icon.y = 39 * pxScale;
			addChild(icon);
			
			counterContainer = new Sprite();
			addChild(counterContainer);
			
			var countBackground:Image = new Image(countBackgroundTexture);
			counterContainer.addChild(countBackground);
			
			label = new XTextField(41 * pxScale, 38 * pxScale, XTextFieldStyle.getWalrus(24));
			label.autoScale = true;
			label.x = countBackground.x;
			label.y = countBackground.y + 4*pxScale;
			counterContainer.addChild(label);
			
			counterContainer.alignPivot(Align.CENTER, Align.BOTTOM);
			counterContainer.x = 55 * pxScale + counterContainer.width/2;
			counterContainer.y = 46 * pxScale + counterContainer.height;
			
			value = gameManager.powerupModel.getPowerupCount(type);
			setLabelToValue();
			
			var tooltipTrigger:TooltipTrigger = new TooltipTrigger(icon.width, icon.height, Powerup.getHintForPowerup(type));
			tooltipTrigger.y = icon.getBounds(this).y;
			addChild(tooltipTrigger);
			
			setSizeInternal(icon.width, countBackground.y, false);
		}
		private function setLabelToValue():void 
		{
			label.text = value.toString();
			dispatchEventWith(Event.CHANGE);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			label.text = gameManager.powerupModel.getPowerupCount(type).toString();
		}
		
		
		private function getIconTexture(type:String):Texture
		{
			var iconTextureName:String;
			switch(type)
			{
				default:
				case Powerup.CASH:
					iconTextureName = "cash";
					break;
				case Powerup.DAUB:
					iconTextureName = "daub";
					break;
				case Powerup.DOUBLE_DAUB:
					iconTextureName = "double_daub";
					break;
				case Powerup.INSTABINGO:
					iconTextureName = "instabingo";
					break;
				case Powerup.MINIGAME:
					iconTextureName = "minigame";
					break;
				case Powerup.SCORE:
					iconTextureName = "score";
					break;
				case Powerup.TRIPLE_DAUB:
					iconTextureName = "triple_daub";
					break;
				case Powerup.X2:
					iconTextureName = "x2";
					break;
				case Powerup.XP:
					iconTextureName = "xp";
					break;
			}
			return AtlasAsset.CommonAtlas.getTexture("store/powerups/" + iconTextureName);
		}
		
		public function addQuantity(quantity:int):void
		{
			value += quantity;
			setLabelToValue();
			
			counterContainer.scaleY = 1.4;
			counterContainer.scaleX = 0.6;
			
			Starling.juggler.removeTweens(counterContainer);
			Starling.juggler.tween(counterContainer, 0.4, { scaleX: 1, scaleY:1, transition:Transitions.EASE_OUT_BACK } );
		}
		
		public function animateAppearance(delay:Number):void 
		{
			icon.scale = 0;
			TweenHelper.tween(icon, 0.10, { delay: delay, scale: 1.4, transition: Transitions.LINEAR } )
				.chain(icon, 0.10, { scale: 1, transition:Transitions.LINEAR } );
			
			var counterTargetY:Number = 46 * pxScale + counterContainer.height;
			counterContainer.scaleY = 0;
			TweenHelper.tween(counterContainer, 0.15, { delay: delay + 0.1, scaleX: 0.8, scaleY: 2, y: counterTargetY - 10*pxScale, transition:Transitions.LINEAR } )
				.chain(counterContainer, 0.15, { scaleX: 1, scaleY: 1, y: counterTargetY, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
			
		}
	}

}