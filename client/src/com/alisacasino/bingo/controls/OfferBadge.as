package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.Countdown;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.offers.FirstTimeOfferDialog;
	import com.alisacasino.bingo.dialogs.offers.OfferDialog;
	import com.alisacasino.bingo.models.offers.OfferItem;
	import com.alisacasino.bingo.models.offers.OfferType;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.BaseMessage;
	import com.alisacasino.bingo.protocol.PurchaseOkMessage;
	import com.alisacasino.bingo.store.items.ComboItem;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.RelativePixelMovingHelper;
	import com.netease.protobuf.Message;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapChar;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;	
	import starling.display.Image;
	import starling.events.Event;

	public class OfferBadge extends Sprite
	{
		private var badgeBg:Image;
		private var labelPersent:XTextField;
		private var labelPersentChar:XTextField;
		private var labelOff:XTextField;
		
		private var _offer:OfferItem;

		private var intervalId:int =-1;
		
		private var lastTimeTouch:uint;
	
		public function OfferBadge(offer:OfferItem)
		{
			super();
			
			_offer = offer;
			//percent = Math.random() * 100;
			addEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			init();
		}
		
		public function get offer():OfferItem 
		{
			return _offer;
		}
		
		public function set offer(value:OfferItem):void 
		{
			if(_offer == value)
				return;
			
			_offer = value;
			
			refresh();
		}
		
		private function init():void
		{
			badgeBg = new Image(AtlasAsset.CommonAtlas.getTexture("card/powerups/instabingo"));
			badgeBg.alignPivot();
			addChild(badgeBg);
			//'balls/b'
			labelPersent = new XTextField(68 * pxScale, 40 * pxScale, XTextFieldStyle.getWalrus(21, 0xFF0000), '');
			
			labelPersent.alignPivot();
			addChild(labelPersent);
			labelPersent.rotation = -Math.PI / 9.5;
			//labelPersent.border = true;
			
			labelPersentChar = new XTextField(63 * pxScale, 40 * pxScale, XTextFieldStyle.getWalrus(21, 0xFF0000), '');
			
			labelPersentChar.alignPivot();
			addChild(labelPersentChar);
			
			labelPersentChar.rotation = labelPersent.rotation;
			//labelPersentChar.border = true;
			
			
			labelOff = new XTextField(160 * pxScale, 40 * pxScale, XTextFieldStyle.getWalrus(21, 0xFF0000), '');
			labelOff.text = "off";
			addChild(labelOff);
			
			labelOff.rotation = -Math.PI / 25.7;
			//labelOff.border = true;
			labelOff.alignPivot();
			
			setTimeout(playEffect, 100);
			intervalId = setInterval(playEffect, 3000);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			refresh();
		}
		
		private function refresh():void
		{
			if (!offer) {
				return;
			}
			
			labelPersent.text = offer.salePercents.toString();
			labelPersentChar.text = '%';
			
			labelPersent.x = -(badgeBg.width - 68 * pxScale) / 2 - 5*pxScale;
			labelPersent.y = -20 * pxScale;
			
			labelPersentChar.x = -labelPersent.pivotX + labelPersent.textBounds.x + labelPersent.textBounds.width - 4 * pxScale;
			labelPersentChar.y = labelPersent.y - 9 * pxScale;
			
			labelOff.x = 5*pxScale;
			labelOff.y = labelPersent.y + labelPersent.textBounds.height - 13*pxScale;
		}
		
		private function playEffect():void 
		{
			EffectsManager.jump(badgeBg, 	  1, 1, 1.2, 0.4, 0.1, 0, 0, 0, 2.2, true);
			EffectsManager.jump(labelPersent, 	  1, 1, 1.4, 0.15, 0.15, 0, 0, 0.15, 1.8);
			EffectsManager.jump(labelPersentChar, 1, 1, 1.4, 0.15, 0.15, 0, 0, 0.3, 1.8);
			EffectsManager.jump(labelOff, 		  1, 1, 1.4, 0.15, 0.15, 0, 0, 0.45, 1.8);
			
			var backTween:Tween = new Tween(badgeBg, 2.3, Transitions.EASE_OUT_ELASTIC);
			backTween.animate("rotation", 0);
			
			var pullTween:Tween = new Tween(badgeBg, 0.4, Transitions.EASE_IN);
			pullTween.animate("rotation", Math.PI /16);
			//pullTween.delay = 0.1;
			pullTween.nextTween = backTween;
			
			Starling.juggler.add(pullTween);
		}
		
		private function handler_removedFromStage(e:Event):void
		{
			clearInterval(intervalId);
			
			EffectsManager.removeJump(badgeBg);	
			EffectsManager.removeJump(labelPersent);	
			EffectsManager.removeJump(labelPersentChar);	
			EffectsManager.removeJump(labelOff);
			Starling.juggler.removeTweens(badgeBg);
		}
		
		
		
		private function onTouch(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		
			var touch:Touch = event.getTouch(this);
			if (touch == null)
				return;
	
			if (touch.phase == TouchPhase.ENDED) 
			{
				if ((getTimer() - lastTimeTouch) < 700)
					return;
				
				lastTimeTouch = getTimer();
				gameManager.offerManager.showDialog(offer);
			}
		}
	}
}
