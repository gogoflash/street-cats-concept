package com.alisacasino.bingo.dialogs.slots 
{
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.controls.StarTitle;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.IDialog;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.UIConstructor;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	
	public class SlotsPayoutsDialog extends FeathersControl implements IDialog 
	{
		public static var WIDTH:uint = 1280;
		public static var HEIGHT:uint = 720;
		
		private var container:Sprite;
		private var quad:Quad
		private var fadeQuad:Quad;
		private var closeButton:Button;
		private var starTitle:StarTitle;
		
		private var cashPayouts:PayoutsBlock;
		private var itemsPayouts:PayoutsBlock;
		
		private var isShowing:Boolean = true;
		private var isHiding:Boolean;
		
		public function SlotsPayoutsDialog() 
		{
			super();
		}
		
		public function get fadeStrength():Number 
		{
			return 0.0;
		}
		
		public function get blockerFade():Boolean 
		{
			return true;
		}
		
		public function get fadeClosable():Boolean 
		{
			return false;
		}
		
		public function get align():String 
		{
			return Align.CENTER;
		}
		
		public function get selfScaled():Boolean 
		{
			return false;
		}
		
		public function get baseScale():Number
		{
			return layoutHelper.independentScaleFromEtalonMin;
		}
		
		override public function get width():Number {
			return WIDTH * pxScale * scale;
		}
		
		override public function get height():Number {
			return HEIGHT * pxScale * scale;
		}
		
		override public function set scale(value:Number):void 
		{
			super.scale = value;
			invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		private function get overHeight():int
		{
			return (Math.max(0, gameManager.layoutHelper.stageHeight - height) / 2) / scale;
		}
		
		private function get overWidth():int
		{
			return (Math.max(0, gameManager.layoutHelper.stageWidth - width) / 2) / scale;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
		
			fadeQuad = new Quad(1, 1, 0x0);
			addChild(fadeQuad);
			
			/*quad = new Quad(1, 1, 0xFF0000);
			addChild(quad);*/
			
			starTitle = new StarTitle('PAYOUTS', XTextFieldStyle.getWalrus(58, 0xffffff), 16, 0, -4, starTitleActivateCallback);
			/*starTitle.pivotX = starTitle.width / 2;
            starTitle.pivotY = starTitle.height / 2;*/
			starTitle.alignPivot();
			addChild(starTitle);
			
			closeButton = UIConstructor.dialogCloseButton();
			closeButton.addEventListener(Event.TRIGGERED, handler_closeButton);
			addChild(closeButton);
			
			container = new Sprite();
			addChild(container);
			
			/*var cashPayoutsData:Array = 
			[
				[CommodityItem.create(CommodityType.CASH, null, 350), 250],
				[CommodityItem.create(CommodityType.CASH, null, 250), 100],
				[CommodityItem.create(CommodityType.CASH, null, 70), 25],
				[CommodityItem.create(CommodityType.CASH, null, 40), 5],
				[CommodityItem.create(CommodityType.CASH, null, 1), 2],
				[CommodityItem.create(CommodityType.CASH, null, 0), 1]
			];
			
			var itemsPayoutsData:Array = 
			[
				[CommodityItem.create(CommodityType.SLOT_FREE_SPINS, null, 1), 10],
				[CommodityItem.create(CommodityType.CHEST, ChestType.SUPER.toString(), 250), 1],
				[CommodityItem.create(CommodityType.CHEST, ChestType.GOLD.toString(), 70), 1],
				[CommodityItem.create(CommodityType.POWERUP, Powerup.INSTABINGO, 40), 5],
				[CommodityItem.create(CommodityType.POWERUP, Powerup.TRIPLE_DAUB, 1), 3],
				[CommodityItem.create(CommodityType.DUST, null, 1), 20]
			];*/
			
			cashPayouts = new PayoutsBlock(0xDC8FFF, 0xF271FF, 'MULTIPLIER');
			cashPayouts.setContent(gameManager.slotsModel.cashPayoutsData, gameManager.slotsModel.freeSpinsMinMax);
			container.addChild(cashPayouts);
			
			itemsPayouts = new PayoutsBlock(0x8FF3FF, 0x71D9FF, 'QUANTITY');
			itemsPayouts.setContent(gameManager.slotsModel.itemsPayoutsData, gameManager.slotsModel.freeSpinsMinMax);
			container.addChild(itemsPayouts);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA)) 
			{
				
			}
			
			
			if (isInvalid(INVALIDATION_FLAG_SIZE)) 
				resize();
				
			tweenAppear();
		}
		
		public function resize():void
		{
			var overHeight:int = this.overHeight;
			
			if (/*!isShowing &&*/ !isHiding)
			{
				container.x = (width / scale) / 2;
				container.y = (height / scale) / 2;
			}
			
			/*quad.alpha = 0;
			quad.x = -overWidth + 5;
			quad.y = -overHeight + 5 ;
			quad.width = gameManager.layoutHelper.stageWidth/scale -10/scale;
			quad.height = gameManager.layoutHelper.stageHeight/scale -10/scale;*/
			
			//indicator.alpha = 0.6
			
			fadeQuad.x = -overWidth;
			fadeQuad.y = -overHeight;
			fadeQuad.width = gameManager.layoutHelper.stageWidth/scale;
			fadeQuad.height = gameManager.layoutHelper.stageHeight/scale;
			
			if (closeButton) {
				closeButton.x = width/scale + overWidth - closeButton.width / 2 + (layoutHelper.isIPhoneX ? 30 : 40) * pxScale;
				closeButton.y = starTitleY;
			}
			
			alignStarTitle();
			
			var payoutsViewsGapSide:int = 8 * pxScale;
			var payoutsViewsGapBetween:int = 2 * pxScale;
			
			cashPayouts.resize((width / scale) / 2 - payoutsViewsGapSide, payoutViewHeight);
			cashPayouts.pivotX = cashPayouts.width / 2;
			cashPayouts.pivotY = cashPayouts.height / 2;
			cashPayouts.x = -cashPayouts.width + cashPayouts.pivotX + payoutsViewsGapBetween;
			cashPayouts.y = 0;
			
			itemsPayouts.resize((width / scale) / 2 - payoutsViewsGapSide, payoutViewHeight);
			itemsPayouts.alignPivot();
			itemsPayouts.x = itemsPayouts.pivotX - payoutsViewsGapBetween;
			itemsPayouts.y = 0;
			
			container.y = containerY;//(height / scale) / 2  + (height / scale - payoutViewHeight)/2 + overHeight/2;
		}
		
		private function tweenAppear():void
		{
			if (!isShowing)
				return;
				
			isShowing = false;
			
			SoundManager.instance.playSfx(SoundAsset.RoundResultsPopup);
			
			var overHeight:int = this.overHeight;
			var overWidth:int = this.overWidth;
			
			fadeQuad.y = -fadeQuad.height - overHeight;
			fadeQuad.alpha = 0;
			Starling.juggler.tween(fadeQuad, 0.22, {y:-overHeight, alpha:1, transition:Transitions.EASE_OUT});
			
			EffectsManager.scaleJumpAppearBase(closeButton, 1, 0.6, 0.4);
			
			/*container.scaleX = 0.8;
			container.scaleY = 1.25;
			container.y = -height - 100 * pxScale;
			
			TweenHelper.tween(container, 0.25, {delay:0, y:containerY, transition:Transitions.EASE_IN}).
				chain(container, 0.1, {scaleX:1.2, scaleY:0.8, transition:Transitions.EASE_OUT}).
				chain(container, 0.3, {scaleX:1, scaleY:1, transition:Transitions.EASE_OUT_BACK});*/
			
			container.y = -container.height/2 - 100 * pxScale;
			TweenHelper.tween(container, 0.4, {y:containerY, transition:Transitions.EASE_OUT_BACK});	
			
			/*starTitle.y = -overHeight - starTitle.pivotY - 20 * pxScale;
			TweenHelper.tween(starTitle, 0.12, {delay:0.3, y:(starTitleY + 25 * pxScale), transition:Transitions.EASE_OUT}).
				chain(starTitle, 0.2, {y: starTitleY,  transition:Transitions.EASE_OUT_BACK});*/
			starTitle.y = -overHeight - starTitle.pivotY - 20 * pxScale;
			Starling.juggler.tween(starTitle, 0.23, {delay:0.2, y:starTitleY, transition:Transitions.EASE_OUT_BACK});	
		}
		
		private function tweenHide():void
		{
			if (isHiding)
				return;	
				
			isHiding = true;
			
			var overHeight:int = this.overHeight;
			var overWidth:int = this.overWidth;
			
			Starling.juggler.tween(fadeQuad, 0.2, { delay: 0.05, y:(-fadeQuad.height-overHeight), transition:Transitions.EASE_OUT });
			//Starling.juggler.tween(fadeQuad, 0.15, { delay: 0.1, alpha:0, transition:Transitions.LINEAR});
			
			if (closeButton) {
				Starling.juggler.removeTweens(closeButton);
				closeButton.touchable = false;
				EffectsManager.scaleJumpDisappear(closeButton, 0.2);
			}
			
			Starling.juggler.tween(container, 0.2, {y:(-overHeight - height/scale - 100*pxScale), transition:Transitions.EASE_OUT });
			
			Starling.juggler.tween(starTitle, 0.15, {transition:Transitions.EASE_OUT, scaleY:1.1, scaleX:0.8, y:(-overHeight - starTitle.pivotY - 20 * pxScale), delay:0.0});
			
			Starling.juggler.delayCall(removeDialog, 0.5);
		}
		
		private function starTitleActivateCallback():void 
		{
			if (starTitle) {
				starTitle.pivotX = starTitle.width / 2;
				starTitle.pivotY = starTitle.height / 2;
				alignStarTitle();
			}
		}
		
		private function alignStarTitle():void
		{
			if (starTitle) {
				starTitle.x = WIDTH*pxScale / 2;
				if(!isShowing)
					starTitle.y = starTitleY; 
			}
		}
		
		private function get starTitleY():int
		{
			return 58 * pxScale - overHeight / 2; 
		}

		private function get containerY():Number {
			return (height / scale) / 2  + (height / scale - payoutViewHeight) / 2 + overHeight / 2;
		}
		
		private function get payoutViewHeight():Number {
			return height / scale - starTitleY - starTitle.height / 2// + 30;
		}
		
		protected function handler_closeButton(e:Event):void
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			close();
		}
		
		public function close():void
		{
			tweenHide();
		}	
		
		protected function removeDialog():void 
		{
			cashPayouts.clean();
			itemsPayouts.clean();
			removeFromParent();
		}
	}

}

import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import com.alisacasino.bingo.models.slots.SlotMachineReward;
import com.alisacasino.bingo.models.slots.SlotMachineRewardType;
import com.alisacasino.bingo.models.universal.CommodityItem;
import com.alisacasino.bingo.models.universal.CommodityType;
import com.alisacasino.bingo.resize.ResizeUtils;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Align;

class PayoutsBlock extends Sprite
{
	private var bg:Image;
	
	private var titleLabel:XTextField;
	
	private var renderers:Array;
	
	private var minRelativeItemsWidth:Number = 0.8;
	
	private var minRelativeItemsScale:Number = 0.8;
	
	public function PayoutsBlock(frameColor:uint, titleColor:uint, title:String) 
	{
		bg = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/frame_glowed'));
		bg.scale9Grid = ResizeUtils.getScaledRect(41, 41, 1, 1);
		bg.color = frameColor;
		//image.x = 21 * pxScale;
		//image.y = (bottomPanelBg.height - image.height)/2;
		addChild(bg);
		
		Starling.juggler.tween(bg, 0.06 - Math.random()*0.01, {alpha:0.80, repeatCount:0});
		
		titleLabel = new XTextField(300 * pxScale, 40 * pxScale, XTextFieldStyle.getWalrus(26, titleColor, Align.RIGHT).setStroke(1.6), title);
		//titleLabel.alignPivot();
		titleLabel.pixelSnapping = false;
		addChild(titleLabel);
		
		renderers = new Array();
	}
	
	public function resize(width:Number, height:Number):void 
	{
		bg.width = width;
		bg.height = height;
		
		titleLabel.x = width - titleLabel.width - 49*pxScale;
		titleLabel.y = 5 * pxScale;
		
		var rendererLeftGap:int = 35 * pxScale;
		var rendererRightGap:int = 40 * pxScale;
		var rendererTopGap:int = 42 * pxScale;
		var rendererBottomGap:int = 25*pxScale;
		
		var i:int;
		var length:int = renderers.length;
		var rendererHeight:int = (height - rendererTopGap - rendererBottomGap)/length;
		var renderer:PayoutsRenderer;
		
		for (i = 0; i < length; i++) 
		{
			renderer = renderers[i] as PayoutsRenderer;
			renderer.resize(width - rendererLeftGap - rendererRightGap, rendererHeight);
			renderer.x = rendererLeftGap;
			renderer.y = rendererTopGap + i * (rendererHeight + 0 * pxScale); 
		}
	}
	
	public function setContent(items:Array, freeSpinsMinMax:String):void 
	{
		var i:int;
		var length:int = items.length;
		var renderer:PayoutsRenderer;
		
		var relativeItemsWidthStep:Number = (1 - minRelativeItemsWidth) / (length - 1);
		var relativeItemsScaleStep:Number = (1 - minRelativeItemsScale) / (length - 1);
		var slotMachineReward:SlotMachineReward;
		var rewardTexture:Texture;
		for (i = 0; i < length; i++) 
		{
			slotMachineReward = items[i][0] as SlotMachineReward;
			rewardTexture = AtlasAsset.ScratchCardAtlas.getTexture(SlotMachineRewardType.getRewardTexture(slotMachineReward.rewardType));
			if (slotMachineReward.rewardType == SlotMachineRewardType.CASH_1)
				renderer = new PayoutsRenderer([rewardTexture, null, null], String(items[i][1]), 1 - relativeItemsWidthStep * i, 1 - relativeItemsScaleStep * i, i == 0 ? 0xFFFC00 : 0xFFFFFF);
			else if (slotMachineReward.rewardType == SlotMachineRewardType.FREE_SPINS)
				renderer = new PayoutsRenderer([rewardTexture, rewardTexture, rewardTexture], freeSpinsMinMax, 1 - relativeItemsWidthStep*i, 1 - relativeItemsScaleStep*i, i==0 ? 0xFFFC00 : 0xFFFFFF);
			else	
				renderer = new PayoutsRenderer([rewardTexture, rewardTexture, rewardTexture], String(items[i][1]), 1 - relativeItemsWidthStep*i, 1 - relativeItemsScaleStep*i, i==0 ? 0xFFFC00 : 0xFFFFFF);
			
			addChild(renderer);
			renderers[i] = renderer;
		}
	}
	
	public function clean():void {
		Starling.juggler.removeTweens(bg);
	}
	
}

class PayoutsRenderer extends Sprite
{
	private var valueBg:Image;
	
	private var titleLabel:XTextField;
	
	private var views:Array;
	
	private var itemsTotalWidthScale:Number = 1;
	
	private var itemsExtraScale:Number = 1;
	
	private var itemsHorisontalMinGap:int = 10 * pxScale;
	
	public function PayoutsRenderer(textures:Array, text:String, itemsTotalWidthScale:Number = 1, itemsExtraScale:Number = 1, valueColor:uint = 0xFFFFFF) 
	{
		views = [];
		this.itemsTotalWidthScale = itemsTotalWidthScale;
		this.itemsExtraScale = itemsExtraScale;
		
		var i:int;
		var length:int = textures.length;
		var image:Image;
		var textField:XTextField;
		for (i = 0; i < length; i++) 
		{
			if (textures[i]) 
			{
				image = new Image(textures[i]);
				image.alignPivot();
				//image.x = image.pivotX + i * (image.width + 0*pxScale);
				//image.y = image.pivotY;
				addChild(image);
				views[i] = image;
			}
			else
			{
				textField = new XTextField(1, 1, XTextFieldStyle.houseHolidaySans(58)/*, 'ANY'*/);
				textField.autoScale = true;
				addChild(textField);
				views[i] = textField;
				//textField.autoSize = text
			}
		}
		
		valueBg = new Image(AtlasAsset.CommonAtlas.getTexture('quests/outer_bg'));
		valueBg.scale9Grid = ResizeUtils.getScaledRect(19, 19, 2, 2);
		valueBg.alignPivot();
		valueBg.alpha = 0.12;
		valueBg.width = 173*pxScale;
		valueBg.height = 83*pxScale;
		addChild(valueBg);
		
		titleLabel = new XTextField(valueBg.width, valueBg.height, XTextFieldStyle.houseHolidaySans(90, valueColor), text);
		titleLabel.alignPivot();
		titleLabel.pixelSnapping = false;
		addChild(titleLabel);
	}
	
	public function resize(width:Number, height:Number):void 
	{
		/*var quad:Quad = new Quad(width, height, 0xFF0000 * Math.random());
		quad.alpha = 0.3;
		addChildAt(quad, 0);*/
		
		valueBg.x = width - valueBg.width + valueBg.width/2;
		valueBg.y = valueBg.height/2 + (height - valueBg.height)/2;
		
		titleLabel.x = valueBg.x;
		titleLabel.y = valueBg.y;
		
		var i:int;
		var length:int = views.length;
		var image:Image;
		var textField:XTextField;
		
		if (length <= 0)
			return;
		
		var itemsPlaceHolderWidth:Number = (width - valueBg.width - 20*pxScale) * itemsTotalWidthScale;	
		var imageScale:Number = 1;
		image = views[0] as Image;
		
		imageScale = Math.min(1, height / image.texture.nativeHeight);
		
		var itemsCalculatedTotalWidth:Number = length * image.texture.nativeWidth + (length - 1) * itemsHorisontalMinGap;
		
		imageScale = Math.min(imageScale, itemsPlaceHolderWidth / itemsCalculatedTotalWidth) * itemsExtraScale;
		
		var itemsHorisontalGap:Number = Math.max(itemsHorisontalMinGap, (itemsPlaceHolderWidth - length * image.texture.nativeWidth * imageScale)/(length - 1));
		
		var startX:int = Math.max(0, (height - image.texture.nativeWidth * imageScale) / 2);
		
		var textUpScale:Number = 1.23;
		
		for (i = 0; i < length; i++) 
		{
			if (views[i] is Image)
			{
				image = views[i] as Image;
				image.scale = imageScale;
				image.x = startX + image.pivotX*imageScale + i * (image.width + itemsHorisontalGap);
				image.y = image.pivotY*imageScale + (height - image.height)/2;
			}
			else if (views[i] is XTextField)
			{
				textField = views[i] as XTextField;
				textField.width = height * imageScale * textUpScale;
				textField.height = height * imageScale * textUpScale;
				textField.text = 'ANY';
				//textField.border = true;
				textField.alignPivot();
				textField.x = startX + textField.pivotX + i * (height * imageScale * textUpScale + itemsHorisontalGap);
				textField.y = textField.pivotY + (height - textField.height)/2;
			}
		}
	}
}