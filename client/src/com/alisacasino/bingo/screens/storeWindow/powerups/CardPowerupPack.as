package com.alisacasino.bingo.screens.storeWindow.powerups 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.store.items.PowerupPackStoreItem;
	import flash.geom.Point;
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
	public class CardPowerupPack extends PowerupPackBase
	{
		private var cardViews:Array;
		private var cardPositions:Array;
		
		public function CardPowerupPack(powerupPackStoreItem:PowerupPackStoreItem) 
		{
			/*powerupPackStoreItem.normalQuantity = 20;
			powerupPackStoreItem.magicQuantity = 15;
			powerupPackStoreItem.rareQuantity = 10;*/
			super(powerupPackStoreItem);
			
			cardPositions = [
				[[130, 106, 0]],
				[[70, 106, -9],	[179, 113, 9]],
				[[70, 106, -9],	[130, 90, 0], [179, 113, 9]]
			]
		}
		
		override protected function createIcons():void 
		{
			super.createIcons();
			
			cardViews = [];
			addCard(Powerup.RARITY_NORMAL, commonQuantity);
			addCard(Powerup.RARITY_MAGIC, magicQuantity);
			addCard(Powerup.RARITY_RARE, rareQuantity);
		}
		
		private function addCard(rarity:String, count:int):void 
		{
			if (count <= 0)
				return;
			
			var cardView:CardView =	new CardView(rarity, count, cardsTotal >=3);
			var cardPositionParams:Array = cardPositions[Math.min(cardsTotal-1, cardPositions.length-1)][cardViews.length];
			cardView.x = cardPositionParams[0]*pxScale;
			cardView.y = cardPositionParams[1]*pxScale;
			cardView.rotation = cardPositionParams[2] * Math.PI / 180;
			
			/*if (cardViews.length == 0) {
				cardView.x = 70*pxScale;
				cardView.y = 106*pxScale;
				cardView.rotation = -9 * Math.PI / 180;
			}
			else if (cardViews.length == 1) {
				cardView.x = 179*pxScale;
				cardView.y = 113*pxScale;
				cardView.rotation = 9 * Math.PI / 180;
			}*/
			
			//cardView.alpha = 0.6;
			addChild(cardView);
			cardViews.push(cardView);
		}
		
		override public function getNormalSourcePoint():Point 
		{
			return getCardPointByRarity(Powerup.RARITY_NORMAL);
		}
		
		override public function getMagicSourcePoint():Point 
		{
			return getCardPointByRarity(Powerup.RARITY_MAGIC);
		}
		
		override public function getRareSourcePoint():Point
		{
			return getCardPointByRarity(Powerup.RARITY_RARE);
		}
		
		override public function animateBuy():void 
		{
			super.animateBuy();
			
			var tweenParams:Array = [
				[0.2, 0.1],
				[0, 0.3],
				[0.3, 0.1]
			]
			
			for (var i:int = 0; i < cardViews.length; i++ ) {
				tweenCard.apply(null, [cardViews[i] as DisplayObject].concat(tweenParams[i]));
			}
		}
		
		private function tweenCard(cardPack:DisplayObject, delay:Number, hangDelay:Number):void 
		{
			var backTween:Tween = new Tween(cardPack, 0.3, Transitions.EASE_OUT_BACK);
			backTween.delay = hangDelay;
			backTween.animate("scale", 1);
			backTween.animate("rotation", cardPack.rotation);
			Starling.juggler.tween(cardPack, 0.3, {delay:delay, scale: 1.2, rotation: (cardPack.rotation + Math.PI / 18), transition:Transitions.EASE_OUT, nextTween:backTween } );
		}
		
		override public function getNormalRarityDelay():Number 
		{
			return 0.2;
		}
		
		override public function getMagicRarityDelay():Number 
		{
			return 0;
		}
		
		override public function animateAppearance(delay:Number):void 
		{
			super.animateAppearance(delay);
			
			for (var i:int = 0; i < cardViews.length; i++ ) {
				makePopTween(cardViews[i] as DisplayObject, delay + (cardViews.length - i + 1)*0.1);
			}
		}
		
		private function getCardPointByRarity(rarity:String):Point 
		{
			var cardView:CardView;
			for (var i:int = 0; i < cardViews.length; i++ ) {
				cardView = cardViews[i] as CardView;
				if (cardView.rarity == rarity) {
					return new Point(cardView.x, cardView.y);
				}
			}
			return new Point(110*pxScale, 113*pxScale);
		}
	}

}
import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import com.alisacasino.bingo.models.powerups.Powerup;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Align;

final class CardView extends Sprite 
{
	public var rarity:String;
	
	public function CardView(rarity:String, quantity:int, countLeftAligned:Boolean = false) 
	{
		touchable = false;
		
		this.rarity = rarity;
		
		var texture:Texture;
		var imageRotation:Number;
		var strokeColor:uint;
		var textShiftX:int;
		switch(rarity) 
		{
			case Powerup.RARITY_NORMAL: {
				texture = AtlasAsset.CommonAtlas.getTexture("store/powerups/card_green");
				imageRotation = 9;
				strokeColor = 0x003333;
				textShiftX = -5 * pxScale;
				break;
			}
			case Powerup.RARITY_MAGIC: {
				texture = AtlasAsset.CommonAtlas.getTexture("store/powerups/card_blue");
				imageRotation = -9;
				strokeColor = 0x00007c;
				break;
			}
			case Powerup.RARITY_RARE: {
				texture = AtlasAsset.CommonAtlas.getTexture("store/powerups/card_yellow");
				imageRotation = 9;
				strokeColor = 0x5e0100;
				break;
			}
		}
		
		var cardImage:Image = new Image(texture);
		cardImage.alignPivot();
		cardImage.rotation = imageRotation * Math.PI / 180;
		addChild(cardImage);
		
		var leftCardLabel:XTextField = new XTextField(80 * pxScale, 48 * pxScale, XTextFieldStyle.getWalrus(50, 0xffffff).addStroke(0.8, strokeColor),	quantity.toString());
		leftCardLabel.autoScale = true;
		leftCardLabel.redraw();
		leftCardLabel.alignPivot(Align.CENTER, Align.BOTTOM);
		if (countLeftAligned)
			leftCardLabel.x = -cardImage.width / 2 + 58 * pxScale - textShiftX;
		else
			leftCardLabel.x = cardImage.width / 2 - 58 * pxScale + textShiftX;
		
		leftCardLabel.y = -cardImage.height/2 + 69 * pxScale;
		//leftCardLabel.border = true;
		addChild(leftCardLabel);
	}
}