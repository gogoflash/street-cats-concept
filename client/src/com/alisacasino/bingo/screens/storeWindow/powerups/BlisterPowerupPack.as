package com.alisacasino.bingo.screens.storeWindow.powerups 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.store.items.PowerupPackStoreItem;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.DropShadowFilter;
	import starling.utils.Align;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class BlisterPowerupPack extends PowerupPackBase
	{
		private var commonBlister:PowerupBlister;
		private var magicBlister:PowerupBlister;
		private var rareBlister:PowerupBlister;
		public function BlisterPowerupPack(powerupPackStoreItem:PowerupPackStoreItem) 
		{
			super(powerupPackStoreItem);
			baseWidth = 500 * pxScale;
			baseHeight = 292 * pxScale;
		}
		
		override protected function createIcons():void 
		{
			super.createIcons();
			
			commonBlister = new PowerupBlister(AtlasAsset.CommonAtlas.getTexture("store/powerups/set_green"), 0x003333, commonQuantity.toString());
			commonBlister.alignPivot(Align.CENTER, Align.BOTTOM);
			commonBlister.x = 117 * pxScale;
			commonBlister.y = 205 * pxScale;
			commonBlister.rotation = -0.1;
			addChild(commonBlister);
			
			magicBlister = new PowerupBlister(AtlasAsset.CommonAtlas.getTexture("store/powerups/set_blue"), 0x00007c, magicQuantity.toString());
			magicBlister.alignPivot(Align.CENTER, Align.BOTTOM);
			magicBlister.x = 250 * pxScale;
			magicBlister.y = 200 * pxScale;
			//magicBlister.rotation = Math.PI / 18;
			addChild(magicBlister);
			
			rareBlister = new PowerupBlister(AtlasAsset.CommonAtlas.getTexture("store/powerups/set_orange"), 0x5e0100, rareQuantity.toString());
			rareBlister.alignPivot(Align.CENTER, Align.BOTTOM);
			rareBlister.x = 384 * pxScale;
			rareBlister.y = 205 * pxScale;
			rareBlister.rotation = 0.1;
			addChild(rareBlister);
			
		}
		
		override public function animateBuy():void
		{
			animateBlister(commonBlister, getNormalRarityDelay());
			animateBlister(magicBlister, getMagicRarityDelay());
			animateBlister(rareBlister, getRareRarityDelay());
		}
		
		private function animateBlister(blister:PowerupBlister, delay:Number):void 
		{
			var initialRotation:Number = blister.rotation;
			var backTween:Tween = new Tween(blister, 0.3, Transitions.EASE_OUT_BACK);
			backTween.delay = 0.1;
			backTween.animate("scale", 1);
			backTween.animate("rotation", initialRotation);
			Starling.juggler.tween(blister, 0.3, {delay:delay, scale: 1.2, rotation: initialRotation + Math.PI / 18, transition:Transitions.EASE_OUT, nextTween:backTween } );
		}
		
		override public function getNormalSourcePoint():Point
		{
			var bounds:Rectangle = commonBlister.getBounds(this);
			return new Point(bounds.x + bounds.width/2, bounds.y + bounds.height/2);
		}
		
		override public function getMagicSourcePoint():Point
		{
			var bounds:Rectangle = magicBlister.getBounds(this);
			return new Point(bounds.x + bounds.width/2, bounds.y + bounds.height/2);
		}
		
		override public function getRareSourcePoint():Point
		{
			var bounds:Rectangle = rareBlister.getBounds(this);
			return new Point(bounds.x + bounds.width/2, bounds.y + bounds.height/2);
		}
		
		override public function animateAppearance(delay:Number):void 
		{
			super.animateAppearance(delay);
			makePopTween(commonBlister, delay + 0.1);
			makePopTween(magicBlister, delay + 0.2);
			makePopTween(rareBlister, delay + 0.3);
		}
		
	}

}
import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Align;

class PowerupBlister extends Sprite
{
	public function PowerupBlister(texture:Texture, strokeColor:uint, text:String) 
	{
		super();
		
		touchable = false;
		
		var card:Image = new Image(texture);
		//card.scale = 1.25;
		addChild(card);
		
		var label:XTextField = new XTextField(80 * pxScale, 46 * pxScale, 
			XTextFieldStyle.getWalrus(32, 0xffffff).addStroke(0.6, strokeColor),
			text);
		label.autoScale = true;
		label.redraw();
		label.x = card.width - label.width;
		label.y = 107 * pxScale;
		addChild(label);
	}
}