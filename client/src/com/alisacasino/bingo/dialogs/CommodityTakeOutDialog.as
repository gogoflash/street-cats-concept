package com.alisacasino.bingo.dialogs 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.commands.player.ShowReservedDrops;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.components.AwardImageAssetContainer;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.offers.OfferRewardView;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.offers.CashIconType;
	import com.alisacasino.bingo.models.offers.OfferItem;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.utils.ItemViewHelper;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	public class CommodityTakeOutDialog extends Sprite implements IDialog 
	{
		public static var WIDTH:uint = 1280;
		public static var HEIGHT:uint = 720;
		
		public function CommodityTakeOutDialog(commoditiesList:Array, showReservedDrops:Boolean = true, fadeStrength:Number = 0.95, onCompleteCallback:Function = null, onCompleteParams:Array = null) 
		{
			super();
			
			this.commoditiesList = commoditiesList;
			_fadeStrength = fadeStrength;
			this.showReservedDrops = showReservedDrops;
			this.onCompleteCallback = onCompleteCallback;
			this.onCompleteParams = onCompleteParams;
			
			allCardViews = [];
			cardsSources = [];
			cardsNumberLabelValuesSources = [];
			cardsGlowSources = [];
			
			initialize();
		}
		
		private var commoditiesList:Array;
		private var _fadeStrength:Number;
		private var showReservedDrops:Boolean;
		private var onCompleteCallback:Function;
		private var onCompleteParams:Array;
		
		private var animationContainer:AnimationContainer;
		
		private var nextButton:XButton;
		private var titleLabel:XTextField;
		private var allCardViews:Array;
		
		private var cardsSources:Array;
		private var cardsNumberLabelValuesSources:Array;
		private var cardsGlowSources:Array;
		
		private var isHiding:Boolean;
		private var isShowing:Boolean;
		
		public function get fadeStrength():Number {
			return _fadeStrength;
		}
		
		public function get blockerFade():Boolean {
			return true;
		}
		
		public function get fadeClosable():Boolean {
			return false;
		}
		
		public function get align():String {
			return Align.CENTER;
		}
		
		override public function get width():Number {
			return WIDTH * pxScale * scale;
		}
		
		override public function get height():Number {
			return HEIGHT * pxScale * scale;
		}
		
		public function get selfScaled():Boolean 
		{
			return false;
		}
		
		public function get baseScale():Number
		{
			return layoutHelper.independentScaleFromEtalonMin;
		}
		
		override public function set scale(value:Number):void 
		{
			super.scale = value;
			resize();
		}
		
		protected function initialize():void 
		{
			var i:int;
			var length:int = commoditiesList.length;
			var item:CommodityItem;
			for (i = 0; i < length; i++) 
			{
				item = commoditiesList[i] as CommodityItem;
				
				switch(item.type)
				{
					case CommodityType.CASH: 
					{
						cardsSources.push(AtlasAsset.CommonAtlas.getTexture("cards/cash"));
						cardsGlowSources.push("cards/card_glow_cian");
						cardsNumberLabelValuesSources.push(item.quantity.toString());
						break;
					}
					case CommodityType.POWERUP_CARD: 
					{
						//item.data = powerUpsRaw;
						cardsSources.push(AtlasAsset.CommonAtlas.getTexture(Powerup.getCardTexture(item.subType)));
						cardsGlowSources.push("cards/card_glow_cian");
						cardsNumberLabelValuesSources.push(item.quantity.toString());
						break;
					}
					case CommodityType.POWERUP: 
					{
						if (Powerup.allRarities.indexOf(item.subType) != -1) 
							cardsSources.push(AtlasAsset.CommonAtlas.getTexture(Powerup.getCardTexture(item.subType)));
						else if (Powerup.allPowerUps.indexOf(item.subType) != -1) 
							cardsSources.push(AtlasAsset.CommonAtlas.getTexture(Powerup.getTexture(item.subType)));
						
						cardsGlowSources.push("cards/card_glow_cian");
						cardsNumberLabelValuesSources.push(item.quantity.toString());
						break;
					}
					case CommodityType.COLLECTION: 
					{
						if (item.data)
						{
							var collectionItem:CollectionItem;
							for each(collectionItem in item.data) 
							{
								cardsSources.push(collectionItem.image);
								cardsGlowSources.push(collectionItem.rarityGlowBg);
								cardsNumberLabelValuesSources.push('');
							}
						}
						
						break;
					}
					case CommodityType.CUSTOMIZER_SET:
					case CommodityType.CUSTOMIZER: 
					{
						if (item.data)
						{
							var customizerItem:CustomizerItemBase;
							for each(customizerItem in item.data) 
							{
								cardsSources.push(customizerItem.uiAsset);
								cardsGlowSources.push(customizerItem.rarityGlowBg);
								cardsNumberLabelValuesSources.push('');
							}
						}
						
						break;
					}
					
					case CommodityType.SCORE: 
					{
						//player.currentLiveEventScore += item.quantity;
						break;
					}
					case CommodityType.CHEST: 
					{
						
						break;
					}
					case CommodityType.DUST: 
					{
						cardsSources.push(ItemViewHelper.getDustForTotalDialogView(item.quantity.toString()));
						cardsGlowSources.push("cards/card_glow_cian");
						cardsNumberLabelValuesSources.push(item.quantity.toString());
						
						break;
					}	
					default: 
					{
						//cardSource = AtlasAsset.CommonAtlas.getTexture("cards/gold_bg");
						//glowSource = "cards/card_glow_cian";
						break;
					}
				}
			}
			
			length = cardsSources.length;
			var cardView:AwardImageAssetContainer;
			for (i = 0; i < length; i++) 
			{
				if (cardsSources[i] is Texture || cardsSources[i] is ImageAsset) {
					cardView = new AwardImageAssetContainer(cardsSources[i], cardsGlowSources[i], cardsNumberLabelValuesSources[i]);
					addChild(cardView);
					allCardViews.push(cardView);
				}
				else if (cardsSources[i] is DisplayObject) {
					addChild(cardsSources[i]);
					allCardViews.push(cardsSources[i]);
				}
				else {
					allCardViews.push(new Image(AtlasAsset.getEmptyTexture()));
				}
			}
			
			if (length <= 16) {
				animationContainer = new AnimationContainer(MovieClipAsset.PackBase, true);
				animationContainer.validate();
				animationContainer.playTimeline("cat_dollar", true, true);
				addChild(animationContainer);
			}
			
			titleLabel = new XTextField(400*pxScale, 70*pxScale, XTextFieldStyle.getWalrus(41, 0x00FFB9, Align.CENTER), "YOU GOT:");
			titleLabel.alignPivot();
			addChild(titleLabel);
			
			nextButton = new XButton(XButtonStyle.DialogBigGreenButtonStyle, 'NEXT', 'NEXT');
			nextButton.maxDragDist = 0;
			nextButton.addEventListener(Event.TRIGGERED, handler_nextButtonClick);
			nextButton.alignPivot();
			nextButton.touchable = false;
			addChild(nextButton);
			
			
			resize();
			isShowing = true;
			tweenShow();
		}
		
		public function resize():void
		{
			if (isShowing || isHiding) 
				return;
			
			var length:int = cardsSources.length;
			
			var cardsShiftX:int;
			if (animationContainer) {
				animationContainer.y = 155 * pxScale;
				animationContainer.x = 118 * pxScale - overWidth / 2;
				animationContainer.scale = 1.24;
				cardsShiftX = (length <= 12 ? 175 : 175)*pxScale;
			}
			
			var cardsAlignSettings:AllCardsAlignSettings = AllCardsAlignSettings.getCardsSettings(length);
			var cardScale:Number = cardsAlignSettings.scale;
			var cardWidth:int = AwardImageAssetContainer.WIDTH * pxScale * cardScale;
			var cardHeight:int = AwardImageAssetContainer.HEIGHT * pxScale * cardScale;
	
			var cardPaddingLeft:int = /*overWidth/2 +*/ (width/scale - Math.min(length, cardsAlignSettings.columns) * cardsAlignSettings.gapHorisontal + (cardsAlignSettings.gapHorisontal - cardWidth))/2 + cardWidth/2 + cardsShiftX;
			var cardsPaddingTop:int = /*overHeight/2 +*/ (height / scale - Math.max(Math.ceil(length / cardsAlignSettings.columns), 1) * cardsAlignSettings.gapVertical + (cardsAlignSettings.gapVertical - cardHeight)) / 2 + cardHeight / 2;
			
			var i:int;
			var cardView:DisplayObject;
			for (i = 0; i < length; i++) 
			{
				cardView = allCardViews[i] as DisplayObject;
				
				//Starling.juggler.removeTweens(cardView);
				
				cardView.x = cardPaddingLeft + (i%cardsAlignSettings.columns) * cardsAlignSettings.gapHorisontal;
				cardView.y = cardsPaddingTop + Math.floor(i/cardsAlignSettings.columns) * cardsAlignSettings.gapVertical;
				cardView.scale = cardScale;
			}
			
			titleLabel.x = (WIDTH * pxScale) / 2;
			titleLabel.y = (cardsPaddingTop - cardHeight/2)/2 - overHeight/2;
			
			nextButton.x = (WIDTH * pxScale) / 2;
			nextButton.y = height / scale + overHeight / 2 - (cardsPaddingTop - cardHeight / 2) / 2;
			
			if (length == 1)
			{
				titleLabel.x += 120 * pxScale;
				nextButton.x += 120 * pxScale;
				
				if(cardView)
					cardView.x = titleLabel.x;
				
				if(animationContainer)
					animationContainer.x += 100;
			}
			else if (length == 2)
			{
				titleLabel.x += 175 * pxScale;
				nextButton.x += 175 * pxScale;
				
				if(animationContainer)
					animationContainer.x += 100;
			}
		}	
		
		private function tweenShow(delay:Number = 0):void
		{
			if (!isShowing)
				return;
				
			Starling.juggler.delayCall(function():void {isShowing = false;}, 0.3);
			
			var length:int = cardsSources.length;
			var cardsAlignSettings:AllCardsAlignSettings = AllCardsAlignSettings.getCardsSettings(length);
			var i:int;
			var cardView:DisplayObject;
			var cardViewX:Number;
			for (i = 0; i < length; i++) 
			{
				cardView = allCardViews[i] as DisplayObject;
				cardViewX = cardView.x;
				cardView.x -= 150 * pxScale;
				cardView.alpha = 0;
				Starling.juggler.tween(cardView, 0.35, {x:cardViewX, alpha:2, transition:Transitions.EASE_OUT, delay:(delay + i * Math.floor(i / cardsAlignSettings.columns) * cardsAlignSettings.delayPerCard)});
			}
			
			var titleLabelX:int = titleLabel.x;
			titleLabel.alpha = 0;
			titleLabel.x -= 150*pxScale;
			Starling.juggler.tween(titleLabel, 0.2, {transition:Transitions.EASE_OUT_BACK, delay:(delay + 0.1), alpha:1, x:titleLabelX});
			
			if (animationContainer) {
				var animationContainerX:int = animationContainer.x;
				animationContainer.alpha = 0;
				animationContainer.x -= 150 * pxScale; 
				Starling.juggler.tween(animationContainer, 0.2, {transition:Transitions.EASE_OUT_BACK, delay:(delay + 0.1), alpha:1, x:animationContainerX});
			}
			
			var nextButtonX:int = nextButton.x;
			nextButton.alpha = 0;
			nextButton.x -= 100 * pxScale
			Starling.juggler.tween(nextButton, 0.35, {x:nextButtonX, delay:(delay + 0.2), alpha:2, transition:Transitions.EASE_OUT_BACK, onStart:setNextButtonTouchable, onStartArgs:[true]});
		}
		
		private function setNextButtonTouchable(value:Boolean):void {
			if (nextButton)
				nextButton.touchable = value;
		}
		
		private function tweenHide():void
		{
			if (isHiding)
				return;
			
			isHiding = true;
			
			while (allCardViews.length > 0) {
				Starling.juggler.tween(allCardViews.pop(), 0.3, {scale:0, delay:(allCardViews.length*0.05), transition:Transitions.EASE_IN_BACK});
			}
			
			if(nextButton)
				Starling.juggler.tween(nextButton, 0.35, {x:(nextButton.x + 100*pxScale), alpha:0, transition:Transitions.EASE_IN});
			
			Starling.juggler.delayCall(callCallbackAndRemove, 0.7);
			
			if (animationContainer)
				Starling.juggler.tween(animationContainer, 0.2, {transition:Transitions.EASE_IN, delay:0.2, alpha:0, x:(animationContainer.x - 100*pxScale)});
			
			Starling.juggler.tween(titleLabel, 0.2, {transition:Transitions.EASE_IN, delay:0.1, alpha:0, x:(titleLabel.x + 100*pxScale)});
		}
		
		private function callCallbackAndRemove():void
		{
			removeFromParent();
			
			if (onCompleteCallback != null) {
				onCompleteCallback.apply(null, onCompleteParams);
				onCompleteCallback = null;
			}
			
			if(showReservedDrops)
				new ShowReservedDrops(0.5).execute();
		}
		
		private function handler_nextButtonClick(e:Event):void 
		{
			nextButton.touchable = false;
			tweenHide();
			
		}
		
		public function close():void 
		{
			tweenHide();
		}
		
		private function get overHeight():int
		{
			return (Math.max(0, gameManager.layoutHelper.stageHeight - height) / 2) / scale;
		}
		
		private function get overWidth():int
		{
			return (Math.max(0, gameManager.layoutHelper.stageWidth - width) / 2) / scale;
		}
		
	}

}



final class AllCardsAlignSettings
{
	public var scale:Number;
	public var gapHorisontal:int;
	public var gapVertical:int;
	public var columns:int;
	public var delayPerCard:Number;
	
	public function AllCardsAlignSettings(scale:Number, gapHorisontal:int, gapVertical:int, columns:int, delayPerCard:Number = 0.05) 
	{
		this.scale = scale;
		this.gapHorisontal = gapHorisontal;
		this.gapVertical = gapVertical;
		this.columns = columns;
		this.delayPerCard = delayPerCard;
	}
	
	public static function getCardsSettings(cardsCount:int):AllCardsAlignSettings
	{
		if (cardsCount <= 3)
			return new AllCardsAlignSettings(0.912, 240 * pxScale, 235 * pxScale, 3, 0);
		else if (cardsCount <= 6)
			return new AllCardsAlignSettings(0.788, 205 * pxScale, 235 * pxScale, 3, 0);
		else if (cardsCount <= 8)
			return new AllCardsAlignSettings(0.738, 180 * pxScale, 205 * pxScale, 4, 0.03);
		else if (cardsCount <= 12)
			return new AllCardsAlignSettings(0.668, 160 * pxScale, 185 * pxScale, 4, 0.03);	
		else if (cardsCount <= 15)
			return new AllCardsAlignSettings(0.668, 155 * pxScale, 185 * pxScale, 5, 0.02);	
		else if (cardsCount <= 21)
			return new AllCardsAlignSettings(0.668, 155 * pxScale, 185 * pxScale, 7, 0.02);	
		else 
			return new AllCardsAlignSettings(0.668, 155 * pxScale, 185 * pxScale, 8, 0.02);	
		
		return 	   new AllCardsAlignSettings(0.912, 180 * pxScale, 205 * pxScale, 3, 0);
	}
}	