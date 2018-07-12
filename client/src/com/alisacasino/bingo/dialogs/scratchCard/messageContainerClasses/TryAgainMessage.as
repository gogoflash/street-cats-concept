package com.alisacasino.bingo.dialogs.scratchCard.messageContainerClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.utils.Constants;
	import feathers.core.FeathersControl;
	import feathers.core.FeathersControl;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.utils.Align;
	;
	;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class TryAgainMessage extends FeathersControl
	{
		
		private var label:XTextField;
		private var kittenImage:Image;
		public function TryAgainMessage() 
		{
			
		}
		
		public function animate():void 
		{
			if (!label)
			{
				return;
			}
			
			label.text = "TRY AGAIN!";
			
			Starling.juggler.removeTweens(label);
			
			label.alpha = 0;
			label.scale = 0;
			
			kittenImage.alpha = 0;
			kittenImage.scale = 0.9;
			
			Starling.juggler.tween(kittenImage, 0.2, { "alpha#": 1, "scale#": 1, delay: 0.1, transition:Transitions.EASE_OUT } );
			
			Starling.juggler.tween(label, 0.1, { "alpha#": 1 } );
			Starling.juggler.tween(label, 0.4, { "scale#": 1, transition:Transitions.EASE_OUT_ELASTIC, onComplete: pulseAlpha } );
		}
		
		private function pulseAlpha():void 
		{
			Starling.juggler.removeTweens(label);
			var tween:Tween = new Tween(label, 0.3, Transitions.EASE_IN_OUT);
			tween.animate("alpha", 0.2);
			tween.repeatCount = 0;
			tween.reverse = true;
			Starling.juggler.add(tween);
		}
		
		public function stop():void
		{
			Starling.juggler.removeTweens(label);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			label = new XTextField(100, 100, XTextFieldStyle.getWalrus(70).addStroke(1, 0x0), "");
			label.autoScale = false;
			label.format.verticalAlign = Align.CENTER;
			addChild(label);
			
			kittenImage = new Image(AtlasAsset.ScratchCardAtlas.getTexture("try_again_kitten"));
			//addChild(kittenImage);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				kittenImage.alignPivot();
				kittenImage.x = actualWidth / 2;
				kittenImage.y = actualHeight/ 3;
				
				label.width = actualWidth;
				label.height = actualHeight/2;
				
				label.alignPivot(Align.CENTER, Align.CENTER);
				label.x = actualWidth / 2;
				label.y = actualHeight / 2;
			}
		}
		
		override public function dispose():void 
		{
			Starling.juggler.removeTweens(label);
			super.dispose();
		}
		
	}

}