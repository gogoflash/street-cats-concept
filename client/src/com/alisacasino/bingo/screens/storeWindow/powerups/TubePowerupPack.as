package com.alisacasino.bingo.screens.storeWindow.powerups 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.store.items.PowerupPackStoreItem;
	import com.alisacasino.bingo.utils.caurina.transitions.Tweener;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class TubePowerupPack extends PowerupPackBase
	{
		private var leftTube:Image;
		private var leftTubeContainer:Sprite;
		private var rightTube:Image;
		private var rightTubeContainer:Sprite;
		
		public function TubePowerupPack(powerupPackStoreItem:PowerupPackStoreItem) 
		{
			super(powerupPackStoreItem);
		}
		
		override protected function createIcons():void 
		{
			super.createIcons();
			
			leftTubeContainer = new Sprite();
			leftTubeContainer.touchable = false;
			
			leftTube = new Image(AtlasAsset.CommonAtlas.getTexture("store/powerups/tube_green"));
			leftTubeContainer.addChild(leftTube);
		
			var leftLabel:XTextField = new XTextField(60 * pxScale, 40 * pxScale, 
				XTextFieldStyle.getWalrus(32, 0xffffff, Align.RIGHT).addStroke(0.5, 0x185d00),
				commonQuantity.toString());
			leftLabel.autoScale = true;
			leftLabel.redraw();
			//leftLabel.border = true;
			leftLabel.alignPivot(Align.CENTER, Align.BOTTOM);
			leftLabel.rotation = Math.PI / 18;
			leftLabel.x = leftTube.x + (commonQuantity > 9 ? 50 : 44) * pxScale;
			leftLabel.y = leftTube.y + (commonQuantity > 9 ? 64 : 62) * pxScale;
			leftTubeContainer.addChild(leftLabel);
			
			leftTubeContainer.alignPivot();
			leftTubeContainer.x = 20 * pxScale + leftTubeContainer.width / 2;
			leftTubeContainer.y = 22 * pxScale + leftTubeContainer.height / 2;
			addChild(leftTubeContainer);
			
			rightTubeContainer = new Sprite();
			rightTubeContainer.touchable = false;
			
			rightTube = new Image(AtlasAsset.CommonAtlas.getTexture("store/powerups/tube_blue"));
			rightTubeContainer.addChild(rightTube);
			
			//magicQuantity = 9	
			var rightLabel:XTextField = new XTextField(60 * pxScale, 40 * pxScale, 
				XTextFieldStyle.getWalrus(32, 0xffffff, Align.RIGHT).addStroke(0.5, 0x00007c),
				magicQuantity.toString());
			rightLabel.autoScale = true;
			rightLabel.redraw();
			rightLabel.alignPivot(Align.CENTER, Align.BOTTOM);
			//rightLabel.border = true;
			rightLabel.rotation = Math.PI / 18;
			rightLabel.x = rightTube.x + (magicQuantity > 9 ? 50 : 43) * pxScale;
			rightLabel.y = rightTube.y + (magicQuantity > 9 ? 64 : 62) * pxScale;
			rightTubeContainer.addChild(rightLabel);
			
			rightTubeContainer.alignPivot();
			rightTubeContainer.x = 122 * pxScale + rightTubeContainer.width / 2;
			rightTubeContainer.y = 22 * pxScale + rightTubeContainer.height / 2;
			addChild(rightTubeContainer);
		}
		
		override public function getNormalSourcePoint():Point 
		{
			return new Point(leftTubeContainer.x, leftTubeContainer.y);
		}
		
		override public function getMagicSourcePoint():Point 
		{
			return new Point(rightTubeContainer.x, rightTubeContainer.y);
		}
		
		override public function animateBuy():void 
		{
			super.animateBuy();
			
			tweenTube(leftTubeContainer, 0);
			tweenTube(rightTubeContainer, 0.2);
		}
		
		private function tweenTube(tube:DisplayObject, delay:Number):void 
		{
			var backTween:Tween = new Tween(tube, 0.3, Transitions.EASE_OUT_BACK);
			backTween.delay = 0.1;
			backTween.animate("scale", 1);
			backTween.animate("rotation", 0);
			Starling.juggler.tween(tube, 0.3, {delay:delay, scale: 1.2, rotation: Math.PI / 18, transition:Transitions.EASE_OUT, nextTween:backTween } );
		}
		
		override public function animateAppearance(delay:Number):void 
		{
			super.animateAppearance(delay);
			makePopTween(leftTubeContainer, delay + 0.1);
			makePopTween(rightTubeContainer, delay + 0.2);
		}
		
	}

}