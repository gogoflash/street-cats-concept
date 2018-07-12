package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.utils.DelayCallUtils;
	import com.alisacasino.bingo.utils.EffectsManager;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.utils.Align;
	import starling.textures.Texture;
	import starling.display.Image;
	
	public class PlayerResourceBarView extends Sprite
	{
		private var TWEEN_HIDE_BUNDLE:String = 'TWEEN_HIDE_BUNDLE';
		
		private var iconImage:Image;
		private var titleBg:Image;
		private var title:XTextField;
		
		private var atlas:AtlasAsset;
		private var bgTexture:String;
		private var iconTexture:String;
		private var labelStyle:XTextFieldStyle;
		private var _value:int;
		private var _type:int;
		
		private var dustAnimation:AnimationContainer;
		
		public function PlayerResourceBarView(type:int) 
		{
			_type = value;
			refreshByType(false);
			
			initialize();
		}
		
		public function set type(value:int):void 
		{
			if (_type == value)
				return;
			
			_type = value;
			
			refreshByType(true);
			/*if (type == Type.POWERUP) {
				iconImage.visible = true;
				reInit(AtlasAsset.CommonAtlas, "bars/base_glow", 'bars/energy', XTextFieldStyle.getWalrus(33, 0xFFFFFF).setShadow());
			}
			else if (type == Type.CASH) {
				iconImage.visible = true;
				reInit(AtlasAsset.CommonAtlas, "bars/base_glow", 'bars/cash', XTextFieldStyle.getWalrus(33, 0xFFFFFF).setShadow());	
			}	
			else if (type == Type.DUST) 
			{
				if (dustAnimation) {
					dustAnimation = new AnimationContainer(MovieClipAsset.Bulb);
					dustAnimation.pivotX = 35*pxScale;
					dustAnimation.pivotY = 42 * pxScale;
					dustAnimation.x = 20*pxScale;
					dustAnimation.y = -9*pxScale;
					dustAnimation.repeatCount = 0;
					dustAnimation.play();
					addChild(dustAnimation);
					dustAnimation.scale = 0;
					
					iconImage.visible = false;
				}
			}*/
		}
		
		public function refreshByType(refreshViews:Boolean):void 
		{
			if (_type == Type.POWERUP) 
			{
				atlas = AtlasAsset.CommonAtlas;
				bgTexture = "bars/base_glow";
				iconTexture = 'bars/energy';
				labelStyle = XTextFieldStyle.getWalrus(33, 0xFFFFFF).setShadow();
			//	iconImage.visible = true;
			}
			else if (_type == Type.CASH) {
				atlas = AtlasAsset.CommonAtlas;
				bgTexture = "bars/base_glow";
				iconTexture = 'bars/cash';
				labelStyle = XTextFieldStyle.getWalrus(33, 0xFFFFFF).setShadow();
				//iconImage.visible = true;
			}	
			/*else if (_type == Type.DUST) 
			{
				if (dustAnimation) {
					dustAnimation = new AnimationContainer(MovieClipAsset.Bulb);
					dustAnimation.pivotX = 35*pxScale;
					dustAnimation.pivotY = 42 * pxScale;
					dustAnimation.x = 20*pxScale;
					dustAnimation.y = -9*pxScale;
					dustAnimation.repeatCount = 0;
					dustAnimation.play();
					addChild(dustAnimation);
					dustAnimation.scale = 0;
					
					iconImage.visible = false;
				}
			}*/
			
			if (refreshViews) 
			{
				titleBg.texture = atlas.getTexture(bgTexture);
				titleBg.readjustSize();
				titleBg.alignPivot(Align.LEFT, Align.CENTER);
					
				iconImage.texture = atlas.getTexture(iconTexture);
				iconImage.readjustSize();
				iconImage.alignPivot();
				
				title.textStyle = labelStyle;
				
				if (_type == Type.DUST) 
				{
					if (!dustAnimation) {
						dustAnimation = new AnimationContainer(MovieClipAsset.PackBase);
						dustAnimation.pivotX = 35*pxScale;
						dustAnimation.pivotY = 42 * pxScale;
						dustAnimation.x = 20*pxScale;
						dustAnimation.y = -9*pxScale;
						dustAnimation.repeatCount = 0;
						dustAnimation.playTimeline('bulb', false, true, 25);
						addChild(dustAnimation);
						dustAnimation.scale = 0;
						
						iconImage.visible = false;
					}
				}
				else
				{
					if (dustAnimation) {
						dustAnimation.removeFromParent();
						dustAnimation = null;
					}
					
					iconImage.visible = true;
				}
			}
		}
		
		public function get type():int
		{
			return _type;
		}	
		
		/*public function reInit(atlas:AtlasAsset, bgTexture:String, iconTexture:String, labelStyle:XTextFieldStyle):void 
		{
			if (this.atlas != atlas || this.bgTexture != bgTexture) 
			{
				this.bgTexture = bgTexture;
				titleBg.texture = atlas.getTexture(bgTexture);
				titleBg.readjustSize();
				titleBg.alignPivot(Align.LEFT, Align.CENTER);
			}
			
			if (this.atlas != atlas || this.iconTexture != iconTexture) 
			{
				this.iconTexture = iconTexture;
				iconImage.texture = atlas.getTexture(iconTexture);
				iconImage.readjustSize();
				iconImage.alignPivot()//Align.LEFT, Align.CENTER);
			}
			
			this.atlas = atlas;
			
			if (this.labelStyle != labelStyle) {
				this.labelStyle = labelStyle;
				title.textStyle = labelStyle;
			}
			
			
			if (_type == Type.DUST) {
				if (_dustAnimation)
					addChild(dustAnimation);
			}
			else {
				if (_dustAnimation) {
					dustAnimation.removeFromParent();
					dustAnimation = null;
				}
			}
		}*/
		
		public function setProperties(iconShiftX:int, iconShiftY:int, labelShiftX:int, labelShiftY:int):void 
		{
			iconImage.readjustSize();
			iconImage.alignPivot();
			
			iconImage.x = iconShiftX * pxScale;
			iconImage.y = iconShiftY * pxScale;
			title.x = titleBg.width/2 + labelShiftX * pxScale;
			title.y = labelShiftY * pxScale;
		}
		
		protected function initialize():void 
		{
			titleBg = new Image(atlas.getTexture(bgTexture));
			titleBg.alignPivot(Align.LEFT, Align.CENTER);
			addChild(titleBg);
			
			iconImage = new Image(atlas.getTexture(iconTexture));
			iconImage.alignPivot();
			addChild(iconImage);

			title = new XTextField(titleBg.width - iconImage.pivotX, titleBg.height, labelStyle, _value.toString());
			title.alignPivot();//Align.LEFT, Align.BOTTOM);
			//title.border = true;
			//title.y = title.pivotY/2;
			title.x = titleBg.width/2;
			addChild(title);
			
			titleBg.alpha = 0;
			title.scaleY = 0;
			iconImage.scale = 0;
		}
		
		public function show(delay:Number, valueShowDelay:Number = 0):void
		{
			DelayCallUtils.cleanBundle(TWEEN_HIDE_BUNDLE);
			
			Starling.juggler.tween(titleBg, 0.1, {transition:Transitions.LINEAR, delay:delay, alpha:1});
			Starling.juggler.tween(iconImage, 0.35, {transition:Transitions.EASE_OUT_BACK, delay:(delay + 0.02), scale:1});
			Starling.juggler.tween(title, 0.3, {transition:Transitions.EASE_OUT_BACK, delay:(delay + valueShowDelay), scaleY:1});
			if (dustAnimation)
				Starling.juggler.tween(dustAnimation, 0.35, {transition:Transitions.EASE_OUT_BACK, delay:(delay + 0.02), scale:1});
		}
			
		public function hide(delay:Number, forceHide:Boolean = false):void
		{
			//if (titleBg.alpha == 0 && title.scaleY == 0 && iconImage.scaleY == 0)
				//return;
			DelayCallUtils.cleanBundle(TWEEN_HIDE_BUNDLE);
			
			if (forceHide)
			{
				removeValueTweens();
				
				Starling.juggler.removeTweens(titleBg);
				Starling.juggler.removeTweens(iconImage);
				Starling.juggler.removeTweens(title);
				
				titleBg.alpha = 0;
				title.scaleY = 0;
				iconImage.scale = 0;
				
				if (dustAnimation) {
					Starling.juggler.removeTweens(dustAnimation);
					dustAnimation.scale = 0;
				}
				
				return;
			}
			
			DelayCallUtils.add(Starling.juggler.tween(titleBg, 0.1, {transition:Transitions.EASE_IN_BACK, delay:delay, alpha:0, onStart:removeValueTweens}), TWEEN_HIDE_BUNDLE);
			DelayCallUtils.add(Starling.juggler.tween(iconImage, 0.1, {transition:Transitions.EASE_IN_BACK, delay:(delay + 0.02), scaleY:0}), TWEEN_HIDE_BUNDLE);
			DelayCallUtils.add(Starling.juggler.tween(title, 0.1, {transition:Transitions.EASE_IN_BACK, delay:(delay + 0.02), scaleY:0}), TWEEN_HIDE_BUNDLE);
			if (dustAnimation)
				Starling.juggler.tween(dustAnimation, 0.35, {transition:Transitions.EASE_IN_BACK, delay:(delay + 0.02), scaleY:0});
		}
		
		public function animate(toValue:int, time:Number=NaN, delay:Number = 0):void 
		{
			removeValueTweens();
			
			if(isNaN(time))
				time = Math.min(1.5, Math.max(0.6, Math.abs(toValue - value) / 16));
				
			Starling.juggler.tween(this, time, {delay:delay, value:toValue});
			
			//EffectsManager.jump(iconImage, 10, 1.25, 0.07, 0.04, 0.0, 0, delay, 1.8, true, false);
			//EffectsManager.jump(title, 10, 1.15, 0.07, 0.04, 0.0, 0, delay, 2.8, true, false);
		}
		
		public function set value(value:int):void {
			if (_value == value)
				return;
				
			_value = value;
			title.text = _value.toString();
			
			EffectsManager.jump(title, 1, 1, 1.15, 0.07, 0.04, 0.0, 0, 0, 2.8, false, false);
			EffectsManager.jump(title, 1, 1, 1.15, 0.07, 0.04, 0.0, 0, 0, 2.8, false, false);
			if (dustAnimation) 
				EffectsManager.jump(dustAnimation, 1, 1, 1.15, 0.07, 0.04, 0.0, 0, 0, 2.8, false, false);
		}
		
		public function get value():int {
			return _value;
		}
		
		private function removeValueTweens():void 
		{
			Starling.juggler.removeTweens(this);
			EffectsManager.removeJump(iconImage);
			EffectsManager.removeJump(title);
			if (dustAnimation) 
				EffectsManager.removeJump(dustAnimation);
		}
	}	
}
