package com.alisacasino.bingo.dialogs.cardBuy 
{
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.game.StakeData;
	import com.alisacasino.bingo.utils.UIUtils;
	import feathers.core.FeathersControl;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CardStakeBanner extends FeathersControl
	{
		private var _stakeData:StakeData;
		
		public function get stakeData():StakeData 
		{
			return _stakeData;
		}
		
		public function set stakeData(value:StakeData):void 
		{
			if(_stakeData != value)
			{
				previousStake = _stakeData;
				_stakeData = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		private var previousStake:StakeData;
		
		private var bannerContainer:Sprite;
		
		private var banners:Array;
		
		private var baseWidth:Number;
		
		private var index:uint;
		
		public function CardStakeBanner(index:uint) 
		{
			this.index = index;
			baseWidth = 200 * pxScale;
			banners = [];
		}
		
		public function setDefaultStake():void 
		{
			stakeData = gameManager.gameData.getDefaultStake();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			bannerContainer = new Sprite();
			var quad:Quad = new Quad(200 * pxScale, 57 * pxScale, 0xff0000);
			//bannerContainer.addChild(quad);
			bannerContainer.x = 10 * pxScale;
			bannerContainer.y = 30 * pxScale;
			addChild(bannerContainer);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				animateNewStake();
			}
		}
		
		private function animateNewStake():void 
		{
			if (stakeData.multiplier == 1)
			{
				hideBanners(true);
			}
			else if (!previousStake || previousStake.multiplier == 1)
			{
				appearBanner();
			}
			else
			{
				switchBanner();
			}
		}
		
		private function hideBanners(animateRollback:Boolean):void 
		{
			while (banners.length)
			{
				var item:Banner = banners.pop();
				if (animateRollback)
				{
					item.animateRollback();
				}
				else
				{
					item.animateFade();
				}
			}
		}
		
		private function appearBanner():void 
		{
			hideBanners(false);
			addBanner();
		}
		
		private function addBanner():void 
		{
			var banner:Banner = new Banner(stakeData.graphicsPrefix, stakeData.getPointsBonusForCardNum(index + 1));
			banners.push(banner);
			bannerContainer.addChild(banner);
			banner.animateAppearance();
		}
		
		private function switchBanner():void 
		{
			hideBanners(false);
			addBanner();
		}
		
	}

}

import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import com.alisacasino.bingo.utils.StringUtils;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.TweenHelper;

class Banner extends Sprite
{
	private var graphicsPrefix:String;
	private var catIcon:Sprite;
	private var badge:Image;
	private var appeared:Boolean;
	private var leftPart:Image;
	private var centerPart:Image;
	private var rightPart:Image;
	private var maskQuad:Quad;
	
	private var badgeCenterX:Number;
	private var pointsBonus:Number;
	private var percentLabel:XTextField;
	private var pointsLabel:XTextField;
	
	public function Banner(graphicsPrefix:String, pointsBonus:Number) 
	{
		super();
		this.pointsBonus = pointsBonus;
		this.graphicsPrefix = graphicsPrefix;
		badgeCenterX = 192 * pxScale;
	}
	
	public function animateRollback():void 
	{
		if (!appeared)
			return;
		
		Starling.juggler.removeTweens(badge);
		Starling.juggler.removeTweens(catIcon);
		Starling.juggler.removeTweens(leftPart);
		Starling.juggler.removeTweens(centerPart);
		Starling.juggler.removeTweens(rightPart);
		Starling.juggler.removeTweens(percentLabel);
		Starling.juggler.removeTweens(pointsLabel);
		Starling.juggler.removeTweens(maskQuad);
		
		TweenHelper.tween(leftPart, 0.167, {delay: 0.23, transition: Transitions.LINEAR, onComplete:removeChild, onCompleteArgs: [leftPart] });
		TweenHelper.tween(centerPart, 0.167, {delay: 0.23, width: 0, transition: Transitions.LINEAR, onComplete:removeChild, onCompleteArgs: [centerPart] });
		TweenHelper.tween(rightPart, 0.167, {delay: 0.23, x: 0, transition: Transitions.LINEAR, onComplete:removeChild, onCompleteArgs: [rightPart] });
		
		TweenHelper.tween(maskQuad, 0.167, {delay: 0.23, width: 0, transition: Transitions.LINEAR, onComplete:removeChild, onCompleteArgs: [maskQuad] });
		
		TweenHelper.tween(percentLabel, 0.25, {delay:0.02, x: -200 * pxScale, transition: Transitions.EASE_IN_BACK, onComplete:removeChild, onCompleteArgs: [percentLabel] });
		TweenHelper.tween(pointsLabel, 0.25, {delay: 0, x: -200 * pxScale, transition: Transitions.EASE_IN_BACK, onComplete:removeChild, onCompleteArgs: [pointsLabel] });
		
		TweenHelper.tween(catIcon, 0.1, { scale: 0.9, transition:Transitions.LINEAR} )
			.chain(catIcon, 0.1, { scale: 1.1, transition:Transitions.LINEAR} )
			.chain(catIcon, 0.15, { scale: 0, transition: Transitions.LINEAR } );
			
		TweenHelper.tween(badge, 0.1, {delay: 0.06, scale: 0.9, transition:Transitions.LINEAR} )
			.chain(badge, 0.1, { scale: 1.1, transition:Transitions.LINEAR} )
			.chain(badge, 0.15, {scale: 0, transition: Transitions.LINEAR } );
		
		Starling.juggler.delayCall(removeFromParent, 0.5);
	}
	
	public function animateAppearance():void 
	{
		if (appeared)
			return;
			
		leftPart = new Image(AtlasAsset.CommonAtlas.getTexture(StringUtils.substitute("stakes/{0}_left", graphicsPrefix)));
		leftPart.x = -leftPart.width;
		addChild(leftPart);
		
		centerPart = new Image(AtlasAsset.CommonAtlas.getTexture(StringUtils.substitute("stakes/{0}_center", graphicsPrefix)));
		centerPart.width = 0;
		addChild(centerPart);
		
		rightPart = new Image(AtlasAsset.CommonAtlas.getTexture(StringUtils.substitute("stakes/{0}_right", graphicsPrefix)));
		addChild(rightPart);
		
		TweenHelper.tween(centerPart, 0.165, {width: badgeCenterX - rightPart.width, transition: Transitions.LINEAR });
		TweenHelper.tween(rightPart, 0.167, {x: badgeCenterX - rightPart.width, transition: Transitions.LINEAR });
		
		
		maskQuad = new Quad(200, 80, 0x0);
		maskQuad.x = -3 * pxScale;
		maskQuad.width = 0;
		maskQuad.visible = false;
		addChild(maskQuad);
		TweenHelper.tween(maskQuad, 0.165, {width: badgeCenterX, transition: Transitions.LINEAR });
		
		
		percentLabel = new XTextField(160 * pxScale, 40 * pxScale, XTextFieldStyle.getWalrus(32), "+" + int((pointsBonus - 1) * 100) + "%");
        percentLabel.y = 1 * pxScale;
		percentLabel.mask = maskQuad;
		percentLabel.x = -percentLabel.width;
        addChild(percentLabel);
		
        pointsLabel = new XTextField(160 * pxScale, 40 * pxScale, XTextFieldStyle.getWalrus(18), "score");
        pointsLabel.y = 21 * pxScale;
		pointsLabel.x = -pointsLabel.width;
        pointsLabel.mask = maskQuad;
        addChild(pointsLabel);
		
		TweenHelper.tween(percentLabel, 0.2, {delay: 0.1, x: 0, transition: Transitions.EASE_OUT_BACK});
		TweenHelper.tween(pointsLabel, 0.14, {delay: 0.16, x: 7*pxScale, transition: Transitions.EASE_OUT_BACK});
		
		badge = new Image(AtlasAsset.CommonAtlas.getTexture(StringUtils.substitute("stakes/{0}_badge", graphicsPrefix)));
		badge.x = badgeCenterX;
		badge.y = 29 * pxScale;
		badge.alignPivot();
		addChild(badge);
		
		badge.scale = 0;
		TweenHelper.tween(badge, 0.1, {delay: 0.1, scale: 1.1, transition: Transitions.LINEAR } )
			.chain(badge, 0.1, { scale: 0.9, transition:Transitions.LINEAR} )
			.chain(badge, 0.1, { scale: 1, transition:Transitions.LINEAR} );
		
		var catIconImage:Image = new Image(AtlasAsset.CommonAtlas.getTexture("card/powerups/score"));
		catIconImage.scale = 0.70;
		catIconImage.alignPivot();
		catIcon = new Sprite();
		catIcon.addChild(catIconImage);
		catIcon.x = badgeCenterX + 0.6 * pxScale;
		catIcon.y = 27.6 * pxScale;
		addChild(catIcon);
		
		catIcon.scale = 0;
		TweenHelper.tween(catIcon, 0.15, {delay: 0.1, scale: 1.1, transition: Transitions.LINEAR } )
			.chain(catIcon, 0.1, { scale: 0.9, transition:Transitions.LINEAR} )
			.chain(catIcon, 0.1, { scale: 1, transition:Transitions.LINEAR} );
		
		
		
		appeared = true;
	}
	
	public function animateFade():void 
	{
		if (!appeared)
			return;
			
		Starling.juggler.removeTweens(badge);
		Starling.juggler.removeTweens(catIcon);
		Starling.juggler.removeTweens(leftPart);
		Starling.juggler.removeTweens(centerPart);
		Starling.juggler.removeTweens(rightPart);
		Starling.juggler.removeTweens(percentLabel);
		Starling.juggler.removeTweens(pointsLabel);
		Starling.juggler.removeTweens(maskQuad);
		
		
		
		TweenHelper.tween(badge, 0.1, {scale: 0, transition: Transitions.LINEAR, onComplete:removeChild, onCompleteArgs: [badge] } );
		TweenHelper.tween(catIcon, 0.1, {scale: 0, transition: Transitions.LINEAR, onComplete:removeChild, onCompleteArgs: [catIcon] } )
		
		TweenHelper.tween(leftPart, 0.167, {delay:0.1, alpha: 0, transition: Transitions.LINEAR, onComplete:removeChild, onCompleteArgs: [leftPart] });
		TweenHelper.tween(centerPart, 0.167, {delay:0.1, alpha: 0, transition: Transitions.LINEAR, onComplete:removeChild, onCompleteArgs: [centerPart] });
		TweenHelper.tween(rightPart, 0.167, {delay:0.1, alpha: 0, transition: Transitions.LINEAR, onComplete:removeChild, onCompleteArgs: [rightPart] });
		
		
		TweenHelper.tween(percentLabel, 0.1, {x: 200 * pxScale, transition: Transitions.LINEAR, onComplete:removeChild, onCompleteArgs: [percentLabel] });
		TweenHelper.tween(pointsLabel, 0.08, {delay: 0.02, x: 200*pxScale, transition: Transitions.LINEAR, onComplete:removeChild, onCompleteArgs: [pointsLabel] });
		
		
		Starling.juggler.delayCall(removeFromParent, 0.27);
	}
}