package com.alisacasino.bingo.dialogs.offers 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.TextFileLoaderWrapper;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.offers.OfferBadgeType;
	import com.alisacasino.bingo.models.offers.OfferItem;
	import com.alisacasino.bingo.models.offers.OfferManager;
	import com.alisacasino.bingo.models.universal.ValueDataTable;
	import com.alisacasino.bingo.utils.EffectsManager;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class SaleBadgeView extends Sprite 
	{
		public static const TYPE_BIG_BORDERED:String = 'TYPE_BIG_BORDERED';
		public static const TYPE_BIG:String = 'TYPE_BIG';
		public static const TYPE_MEDIUM:String = 'TYPE_MEDIUM';
		public static const TYPE_SMALL:String = 'TYPE_SMALL';
		public static const TYPE_SMALL_BORDERED:String = 'TYPE_SMALL_BORDERED';
		
		public var isHiding:Boolean;
		
		private var badgeBg:Image;
		private var labelPersent:XTextField;
		private var labelPersentChar:XTextField;
		private var labelOff:XTextField;
		
		private var _percent:Number = 0;
		private var type:String;
		private var badgeTypeTable:ValueDataTable; 

		private var intervalId:int =-1;
		private var timeoutId:int =-1;
		private var timeInterval:int;
		
		private var jumpCount:int;
		private var jumpCurrentCount:int;
		private var iconTexture:Texture;
		private var customString:String;
		private var clickCallback:Function;
		private var customIconScale:Number = 1;
		private var lastTimeTouch:uint;
		
		private var backgroundScale:Number = 1;
		private var labelPersentShiftX:Number = 0;
		private var labelOffShiftX:Number = 0;
		private var labelOffShiftY:Number = 0;
		private var labelPercentCharShiftX:Number = 0;
		
		public function SaleBadgeView(type:String, badgeTypeTable:ValueDataTable, percentValue:Number, iconTexture:Texture = null, customString:String = null, clickCallback:Function = null, customIconScale:Number = 1) 
		{
			super();
			
			this.type = type;
			this.badgeTypeTable = badgeTypeTable;
			_percent = percentValue;
			this.iconTexture = iconTexture;
			this.customString = customString;
			this.clickCallback = clickCallback;
			this.customIconScale = customIconScale;
			
			addEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			init();
			
			//setInterval(function():void { percent = int(Math.random() * 100); }, 3000);
		}
		
		public function setProperties(percentValue:Number, badgeTypeTable:ValueDataTable, iconTexture:Texture = null, customString:String = null):void 
		{
			if(_percent == percentValue && this.badgeTypeTable == badgeTypeTable && this.iconTexture == iconTexture && this.customString == customString)
				return;
			
			this.badgeTypeTable = badgeTypeTable;
			this.iconTexture = iconTexture;
			this.customString = customString;
			
			_percent = percentValue;
			
			badgeBg.texture = badgeTexture;
			badgeBg.readjustSize();
			badgeBg.alignPivot();
			//badgeBg.scale = badgeScale;
			
			refresh();
		}
		
		public function get percent():Number
		{
			return _percent;
		}
		
		public function set percent(value:Number):void 
		{
			if(_percent == value)
				return;
			
			_percent = value;
			
			//labelPersent.text = percent.toString();
			
			badgeBg.texture = badgeTexture;
			badgeBg.readjustSize();
			
			refresh();
		}
		
		public function get expectWidth():Number
		{
			if (iconTexture) 
				return iconTexture.width * scale;
			
			if (type == TYPE_BIG_BORDERED)
				return 156*pxScale;
				
			if (type == TYPE_BIG)
				return 180*pxScale;
					
			if (type == TYPE_MEDIUM)
				return 95 * pxScale;
				
			if (type == TYPE_SMALL)
				return 90 * pxScale;
				
			if (type == TYPE_SMALL_BORDERED)
				return 88 * pxScale;
				
			return 0;
		}
		
		public function showAppear(delay:Number):void
		{
			EffectsManager.scaleJumpAppearBase(badgeBg, badgeScale, 1.2, delay);
			if (labelPersent) {
				EffectsManager.scaleJumpAppearBase(labelPersent, 1, 1.0, delay);
				EffectsManager.scaleJumpAppearBase(labelPersentChar, 1, 1.0, delay + 0.1);
				EffectsManager.scaleJumpAppearBase(labelOff, 1, 1.0, delay + 0.2);
			}
		}	
		
		public function showJump(delay:uint, jumpCount:int, timeInterval:uint = 3000):void
		{
			this.jumpCount = jumpCount;
			this.timeInterval = timeInterval;
			
			if(delay > 0)
				timeoutId = setTimeout(playEffect, delay);
			else
				playEffect();
		}	
		
		public function stopJump():void
		{
			jumpCount = 0;
			jumpCurrentCount = 0;
			clearInterval(intervalId);
			clearTimeout(timeoutId);
			
			intervalId = -1;
			timeoutId = -1;
		}	
		
		private function init():void
		{
			var textAngle:Number = -10 * Math.PI / 180;
			
			switch(type)
			{
				case TYPE_BIG_BORDERED:
				{
					labelPersentShiftX = -2;
					break;
				}
				case TYPE_BIG:
				{
					backgroundScale = 1.2;
					labelPersentShiftX = -5;
					labelPercentCharShiftX = 1;
					break;
				}
				case TYPE_MEDIUM:
				{
					backgroundScale = 0.70;
					labelPersentShiftX = -5;
					labelPercentCharShiftX = -2;
					labelOffShiftX = 0;
					labelOffShiftY = -3;
					break;
				}
				case TYPE_SMALL:
				{
					backgroundScale = 0.61;
					labelPersentShiftX = -3;
					labelPercentCharShiftX = -1;
					labelOffShiftX = 0;
					labelOffShiftY = -3;
					break;
				}
				case TYPE_SMALL_BORDERED:
				{
					backgroundScale = 0.545;
					labelPersentShiftX = -3;
					labelPercentCharShiftX = -1;
					labelOffShiftX = 0;
					labelOffShiftY = -3;
					break;
				}
			}
			
			badgeBg = new Image(badgeTexture);
			badgeBg.alignPivot();
			badgeBg.scale = badgeScale;
			addChildAt(badgeBg, 0);
			
			//labelPersent = new XTextField(106 * pxScale*backgroundScale, 100 * pxScale*backgroundScale, XTextFieldStyle.houseHolidaySans(87*backgroundScale, 0xFFFFFF), '');
			labelPersent = new XTextField(106 * pxScale*badgeScale, 100 * pxScale*badgeScale, XTextFieldStyle.houseHolidaySans(87*badgeScale, 0xFFFFFF).setShadow(0.7, 0, 0.25, 90, 3, 8), '');
			labelPersent.alignPivot();
			labelPersent.touchable = false;
			addChild(labelPersent);
			labelPersent.rotation = textAngle;
			//labelPersent.border = true;
			
			labelPersentChar = new XTextField(70 * pxScale*badgeScale, 100 * pxScale*badgeScale, XTextFieldStyle.houseHolidaySans(87*badgeScale, 0xFFFFFF).setShadow(0.7, 0, 0.25, 90, 3, 8), '');
			labelPersentChar.alignPivot();
			labelPersentChar.touchable = false;
			addChild(labelPersentChar);
			labelPersentChar.rotation = labelPersent.rotation;
			//labelPersentChar.border = true;
			
			labelOff = new XTextField(100 * pxScale*badgeScale, 70 * pxScale*badgeScale, XTextFieldStyle.houseHolidaySans(61*badgeScale, 0xFFFFFF).setShadow(0.7, 0, 0.25, 90, 3, 8), '');
			addChild(labelOff);
			labelOff.rotation = -8 * Math.PI / 180;
			labelOff.touchable = false;
			//labelOff.border = true;
			labelOff.alignPivot();
			
			if (clickCallback != null) 
				addEventListener(TouchEvent.TOUCH, onTouch);
			
			refresh();
		}
		
		private function refresh():void
		{
			if (gameManager.deactivated) {
				Game.addEventListener(Game.ACTIVATED, game_activatedHandler);
				return;
			}
			
			EffectsManager.removeJump(badgeBg);
			EffectsManager.removeJump(labelPersent);
			EffectsManager.removeJump(labelPersentChar);
			EffectsManager.removeJump(labelOff);
			Starling.juggler.removeTweens(badgeBg);
			badgeBg.scale = badgeScale;
			badgeBg.rotation = 0;
			
			var labelsVisibility:Boolean = iconTexture == null && !customString;
			labelPersent.visible = labelsVisibility;
			labelPersentChar.visible = labelsVisibility;
			labelOff.visible = labelsVisibility;
			
			if (labelsVisibility) {
				labelOff.text = 'OFF';
				labelPersentChar.text = '%';
			}
			
			if (customString) 
			{
				labelPersent.text = customString;
				labelPersent.redraw();
				labelPersent.width = 136 * pxScale * badgeScale;
				labelPersent.height = 100 * pxScale * badgeScale;
				
				labelPersent.visible = true;
				labelPersent.x = -(badgeBg.width - 136 * pxScale*badgeScale) / 2 + labelPersentShiftX*pxScale;
				labelPersent.y = 3 * pxScale*badgeScale;
			}
			else 
			{
				labelPersent.width = 106 * pxScale * badgeScale;
				labelPersent.height = 100 * pxScale * badgeScale;
				
				labelPersent.text = percent.toString();
				labelPersent.redraw();
				
				labelPersent.x = -(badgeBg.width - 112 * pxScale*badgeScale) / 2 + labelPersentShiftX*pxScale;
				labelPersent.y = -8 * pxScale*badgeScale;
				
				labelPersentChar.x = -labelPersent.pivotX + labelPersent.textBounds.x + labelPersent.textBounds.width + labelPercentCharShiftX * pxScale;
				labelPersentChar.y = labelPersent.y - 9 * pxScale*badgeScale;
				
				labelOff.x = 5*pxScale*badgeScale + labelOffShiftX*pxScale;
				labelOff.y = labelPersent.y + labelPersent.textBounds.height - 47 * pxScale * badgeScale + labelOffShiftY * pxScale;
			}
		}
		
		public function playEffect():void 
		{
			EffectsManager.jump(badgeBg, 	  1, badgeScale, badgeScale*1.2, 0.4, 0.1, 0, 0, 0, 2.2, true);
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
			
			jumpCurrentCount++;
			
			
			if (timeoutId != -1) 
			{
				timeoutId = -1;
				
				if(timeInterval > 0)	
					intervalId = setInterval(playEffect, timeInterval);
			}
			
			if (jumpCount != 0 && jumpCurrentCount >= jumpCount) {
				clearInterval(intervalId);
				clearTimeout(timeoutId);
			}
		}
		
		public function clean():void 
		{
			clearInterval(intervalId);
			clearTimeout(timeoutId);
			
			EffectsManager.removeJump(badgeBg);	
			EffectsManager.removeJump(labelPersent);	
			EffectsManager.removeJump(labelPersentChar);	
			EffectsManager.removeJump(labelOff);
			Starling.juggler.removeTweens(badgeBg);
			
			
		}
		
		private function handler_removedFromStage(e:Event):void
		{
			Game.removeEventListener(Game.ACTIVATED, game_activatedHandler);
			clean();
		}
		
		private function onTouch(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		
			var touch:Touch = event.getTouch(this);
			if (touch == null)
				return;
	
			if (touch.phase == TouchPhase.ENDED && clickCallback != null) 
			{
				if ((getTimer() - lastTimeTouch) < 700)
					return;
				
				lastTimeTouch = getTimer();
				
				clickCallback();
			}
		}
		
		private function get badgeTexture():Texture 
		{
			if (iconTexture)
				return iconTexture;
			
			switch(type) {
				case TYPE_BIG_BORDERED: return OfferBadgeType.textureBorderedByType(badgeTypeTable.getData(percent));
				case TYPE_BIG: 			
				case TYPE_MEDIUM: 			
				case TYPE_SMALL: 		return OfferBadgeType.textureByType(badgeTypeTable.getData(percent));
				case TYPE_SMALL_BORDERED:return OfferBadgeType.textureBorderedByType(badgeTypeTable.getData(percent));
			}
			
			return AtlasAsset.getEmptyTexture();
		}
		
		private function get badgeScale():Number
		{
			return iconTexture ? customIconScale : backgroundScale;
		}
		
		private function game_activatedHandler(e:Event):void
		{
			Game.removeEventListener(Game.ACTIVATED, game_activatedHandler);
			refresh();
		}
		
		public static function debugPreviewAllBadges(container:DisplayObjectContainer):void 
		{
			var offerItem:OfferItem = new OfferItem();
			
			var saleBadge0:SaleBadgeView = new SaleBadgeView(SaleBadgeView.TYPE_SMALL_BORDERED, offerItem.badgeTypeTable, 1, null, 'NEW');
			saleBadge0.x = 70;
			saleBadge0.y = 200;
			container.addChild(saleBadge0);
			
			var saleBadge1:SaleBadgeView = new SaleBadgeView(SaleBadgeView.TYPE_SMALL, offerItem.badgeTypeTable, 1);
			saleBadge1.x = 200;
			saleBadge1.y = 200;
			container.addChild(saleBadge1);
			
			var saleBadge2:SaleBadgeView = new SaleBadgeView(SaleBadgeView.TYPE_MEDIUM, offerItem.badgeTypeTable, 1);
			saleBadge2.x = 335;
			saleBadge2.y = 200;
			container.addChild(saleBadge2);
			
			var saleBadge3:SaleBadgeView = new SaleBadgeView(SaleBadgeView.TYPE_BIG_BORDERED, offerItem.badgeTypeTable, 1);
			saleBadge3.x = 500;
			saleBadge3.y = 200;
			container.addChild(saleBadge3);
			
			var saleBadge4:SaleBadgeView = new SaleBadgeView(SaleBadgeView.TYPE_BIG, offerItem.badgeTypeTable, 1);
			saleBadge4.x = 700;
			saleBadge4.y = 200;
			container.addChild(saleBadge4);
			
			
			setInterval(function():void 
			{
				var p:int = Math.random() > 0.75 ? 100 : (Math.random() * 100);
				
				saleBadge1.playEffect();
				saleBadge1.percent = p;
				
				saleBadge2.playEffect();
				saleBadge2.percent = p;
				
				saleBadge3.playEffect();
				saleBadge3.percent = p;
				
				saleBadge4.playEffect();
				saleBadge4.percent = p;
				
			}, 3000);
		}
	}

}