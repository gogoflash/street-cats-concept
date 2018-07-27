package com.alisacasino.bingo.screens.gameScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.components.FrameAnimator;
	import com.alisacasino.bingo.components.SimpleProgressBar;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.cats.CatModel;
	import com.alisacasino.bingo.models.cats.CatRole;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.JumpWithHintHelper;
	import flash.geom.Point;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.DropShadowFilter;
	import starling.filters.GlowFilter;
	
	public class CatView extends Sprite
	{
		public static var WIDTH:int = 130;
		public static var HEIGHT:int = 170;
		
		public static var EVENT_TRIGGERED:String = 'EVENT_TRIGGERED';
		public static var EVENT_MOUSE_DOWN:String = 'EVENT_MOUSE_DOWN';
		public static var EVENT_MOUSE_UP:String = 'EVENT_MOUSE_UP';
		
		private var _state:String = 'STATE_IDLE';
		public static var STATE_IDLE:String = 'STATE_IDLE';
		public static var STATE_HUNGRY:String = 'STATE_HUNGRY';
		public static var STATE_ANGRY:String = 'STATE_ANGRY';
	
		
		public static var STATE_WALK:String = 'STATE_WALK';
		public static var STATE_WALK_HARVEST:String = 'STATE_WALK_HARVEST';
		public static var STATE_FIGHT:String = 'STATE_FIGHT';
		public static var STATE_FIGHT_STANDOFF:String = 'STATE_FIGHT_STANDOFF';
		public static var STATE_DEFENCE:String = 'STATE_DEFENCE';
		public static var STATE_HARVEST:String = 'STATE_HARVEST';
		public static var STATE_HARVEST_STANDOFF:String = 'STATE_HARVEST_STANDOFF';
		public static var STATE_DAMAGE:String = 'STATE_DAMAGE';
		public static var STATE_CONFUSE:String = 'STATE_CONFUSE';
		public static var STATE_DEAD:String = 'STATE_DEAD';
		
		public static var CURSOR_ANIM:String = 'CURSOR_ANIM';
		public static var STARS_ANIM:String = 'STARS_ANIM';
		
		public function CatView() 
		{
		}
		
		public var index:int;
		
		public var roleVisible:Boolean;
		
		public var controlsEnabled:Boolean;
		
		public var isLeft:Boolean;
		
		private var _cat:CatModel;
		
		private var catShadow:Image;
		private var catAnimator:FrameAnimator;
		
		private var roleImage:Image;
		private var roleActionImage:Image;
		private var jumpHelper:JumpWithHintHelper;
		
		private var fightMarksContainer:Sprite;
		
		private var defenderMarksContainer:Sprite;
		
		private var hpLabel:XTextField;
		
		private var healthProgress:SimpleProgressBar;
		
		public var storedParent:DisplayObjectContainer;
		public var storedX:Number = 0;
		public var storedY:Number = 0;
		public var storedScale:Number = 1;
		
		public var storedX_0:Number = 0;
		public var storedY_0:Number = 0;
		
		public var basePosition:Point = new Point();
		
		public var defenderPositionId:int = -1;
		
		
		public function refreshStoreds():void 
		{
			storedParent = parent;
			storedX = x;
			storedY = y;
			storedScale = /*parent.*/scale;
		}
		
		public function set cat(value:CatModel):void 
		{
			if (_cat == value)
				return;
			
			_cat = value;	
				
			if (value)
			{
				setState(_state, false, true);
				
				if (roleImage)
					addChild(roleImage);
					
				if (fightMarksContainer)
					addChild(fightMarksContainer);
					
				if (healthProgress)
					addChild(healthProgress);
			}
			else
			{
				if (catAnimator) {
					catAnimator.removeFromParent();
					catAnimator.clean();
					catAnimator = null;
					
					if (jumpHelper) {
						jumpHelper.dispose();
						jumpHelper = null;
					}
				}	
			}
			
			refreshHP();
		}
		
		public function get cat():CatModel {
			return _cat;
		}
		
		public var catBaseScale:Number = 0.77; 
		
		public function setState(value:String, invertHorisontal:Boolean = false, explicit:Boolean = false, frame:int = 0):void 
		{
			if (_state == value && !explicit)
				return;
				
			_state = value;
			
			if (!catAnimator) 
			{
				catShadow = new Image(AtlasAsset.CommonAtlas.getTexture('cats/sdw'));
				catShadow.alignPivot();
				//catShadow.x = 50 * layoutHelper.specialScale;
				catShadow.y = 103 //* layoutHelper.specialScale;
				catShadow.touchable = false;
				catShadow.scale = 1.2;
				addChild(catShadow);
				
				catAnimator = FrameAnimator.getCatAnimator(_cat.catUID);//new Image(gameManager.catsModel.getCatTexture(_cat.catUID, isLeft, _state));
				addChild(catAnimator);
				
				if (controlsEnabled) {
					jumpHelper = new JumpWithHintHelper(catAnimator, true, true);
					jumpHelper.minScale = catBaseScale * 0.95;
					jumpHelper.minScale = catBaseScale * 1.05;
					jumpHelper.scale = catBaseScale;
					jumpHelper.setStateCallbacks(callback_imageMouseDown, callback_imageMouseUp, callback_imageTriggered);
				}
				
			}
			else 
			{
				//catAnimator.texture = gameManager.catsModel.getCatTexture(_cat.catUID, isLeft, _state);
				
			}
			
			var showLeftAnimation:Boolean = invertHorisontal ? (isLeft) : (!isLeft);
			
			
			var fps:int = 7;
			
			starsVisible = false;
			catShadow.y = 103;
			catShadow.x = 0;
			
			if (_state == STATE_IDLE)
			{
				catAnimator.gotoAndPlay(_state, 0, showLeftAnimation, -1, 25);	
			}
			else if (_state == STATE_ANGRY)
			{
				catAnimator.cycleFps = 3;
				catAnimator.gotoAndPlay(_state, 0, showLeftAnimation, -1, fps, 0, 3);	
			}
			else if (_state == STATE_HUNGRY)
			{
				catAnimator.cycleFps = 1.4;
				catAnimator.gotoAndPlay(_state, 0, showLeftAnimation, -1, fps, 0, 7);	
			}
			else if (_state == STATE_WALK)
			{
				catAnimator.gotoAndPlay(_state, 0, showLeftAnimation, -1, fps);	
			}
			else if (_state == STATE_DEFENCE)
			{
				if(frame == 0)
					catShadow.y = 73;
				else if(frame == 2)
					catShadow.y = 53;
				
				if (frame == -1)
					frame = 0;
					
				catAnimator.gotoAndPlay(_state, frame, showLeftAnimation, 0, fps, frame);
			}
			else if (_state == STATE_FIGHT)
			{
				catAnimator.gotoAndPlay(_state, 0, showLeftAnimation, 1, 3, 3);
			}
			else if (_state == STATE_FIGHT_STANDOFF)
			{
				catAnimator.gotoAndPlay(_state, 0, showLeftAnimation, 1, 3, 2);
			}
			else if (_state == STATE_HARVEST)
			{
				catAnimator.gotoAndPlay(_state, 0, showLeftAnimation, 1, 5, 5);
			}
			else if (_state == STATE_HARVEST_STANDOFF)
			{
				catAnimator.gotoAndPlay(_state, 0, showLeftAnimation, 1, 2, 1);
			}
			else if (_state == STATE_WALK_HARVEST)
			{
				catAnimator.gotoAndPlay(_state, 0, showLeftAnimation, -1, fps);
				
				Starling.juggler.delayCall(function():void {fishVisible = true}, 0.0);
				//fishVisible = true;
				//showFish
			}
			else if (_state == STATE_DAMAGE)
			{
				fishVisible = false;
				catAnimator.gotoAndPlay(_state, 0, showLeftAnimation, 1, 3, 3);	
			}
			else if (_state == STATE_CONFUSE)
			{
				catAnimator.gotoAndPlay(_state, 0, showLeftAnimation, -1, 3);	
				starsVisible = true;
			}
			else if (_state == STATE_DEAD)
			{
				fishVisible = false;
				starsVisible = true;
				catShadow.y = 90;
				catShadow.x = -25;
				catAnimator.gotoAndPlay(_state, 0, showLeftAnimation, -1, fps);	
			}
			
			catAnimator.scaleX = catBaseScale;//isLeft ? catBaseScale : -catBaseScale;
			catAnimator.scaleY = catBaseScale;
			//catImage.scaleX = invertHorisontal ? -1 : 1;
			
			//addChild(catAnimator);
			
			//refreshHP();
			
		}
		
		private function callback_imageTriggered():void {
			dispatchEventWith(EVENT_TRIGGERED, true);
		}
		
		private function callback_imageMouseDown():void {
			dispatchEventWith(EVENT_MOUSE_DOWN, true);
		}
		
		private function callback_imageMouseUp():void {
			dispatchEventWith(EVENT_MOUSE_UP, true);
		}
		
		public function showRoleImage(role:String):void
		{
			if (role)
			{
				if (!roleImage) 
				{
					roleImage = new Image(CatRole.getRoleTexture(role));
					roleImage.alignPivot();
					
					roleImage.touchable = false;
					
					addChild(roleImage);
				}
				else 
				{
					roleImage.texture = CatRole.getRoleTexture(role);
					roleImage.readjustSize();
					roleImage.alignPivot();
				}
				
				if (role == CatRole.FIGHTER) {
					roleImage.x = 75;
					roleImage.y = -85;
				}
				else if (role == CatRole.DEFENDER) {
					roleImage.x = -75;
					roleImage.y = -85;
				}
				else if (role == CatRole.HARVESTER) {
					roleImage.x = 0;
					roleImage.y = -85;
				}
				
			}
			else
			{
				if (roleImage) {
					roleImage.removeFromParent();
					roleImage = null;
				}	
			}	
			
			refreshHP();
		}
		
		/*********************************************************************************************************************
		*
		*
		* 
		*********************************************************************************************************************/	
		
		private var _fightMarks:int;
		
		public function set fightMarks(value:int):void
		{
			if (value == _fightMarks)
				return;
				
			_fightMarks = value;
			
			if (_fightMarks > 0)
			{
				if (!fightMarksContainer) {
					fightMarksContainer = new Sprite();
					fightMarksContainer.x = 50;
					fightMarksContainer.y = -70;
					fightMarksContainer.touchable = false;
					addChild(fightMarksContainer);
				}
				
				while (fightMarksContainer.numChildren != _fightMarks) 
				{
					if (fightMarksContainer.numChildren > _fightMarks) {
						fightMarksContainer.removeChildAt(fightMarksContainer.numChildren-1);
					}
					else {
						var image:Image = new Image(AtlasAsset.CommonAtlas.getTexture('cats/roles/claw'));
						image.alignPivot();
						image.x = fightMarksContainer.numChildren*30;
						//roleImage.y = 215;
						image.scale = 0.4;
						fightMarksContainer.addChild(image);
					}
				}
			}
			else
			{
				if (fightMarksContainer) {
					fightMarksContainer.removeFromParent();
					fightMarksContainer = null;
				}
			}	
		}
		
		public function get fightMarks():int
		{
			return _fightMarks;
		}	
		
		
		/*********************************************************************************************************************
		*
		*
		* 
		*********************************************************************************************************************/	
		
		private var _defenderMarks:int;
		
		public function set defenderMarks(value:int):void
		{
			return;
			
			if (value == _defenderMarks)
				return;
				
			_defenderMarks = value;
			
			if (_defenderMarks > 0)
			{
				if (!defenderMarksContainer) {
					defenderMarksContainer = new Sprite();
					defenderMarksContainer.x = 50;
					defenderMarksContainer.y = -35;
					defenderMarksContainer.touchable = false;
					addChild(defenderMarksContainer);
				}
				
				while (defenderMarksContainer.numChildren != _defenderMarks) 
				{
					if (defenderMarksContainer.numChildren > _defenderMarks) {
						defenderMarksContainer.removeChildAt(defenderMarksContainer.numChildren-1);
					}
					else {
						var image:Image = new Image(AtlasAsset.CommonAtlas.getTexture('cats/roles/shield'));
						image.alignPivot();
						image.x = defenderMarksContainer.numChildren*30;
						//roleImage.y = 215;
						image.scale = 0.4;
						defenderMarksContainer.addChild(image);
					}
				}
			}
			else
			{
				if (defenderMarksContainer) {
					defenderMarksContainer.removeFromParent();
					defenderMarksContainer = null;
				}
			}	
		}
		
		public function get defenderMarks():int
		{
			return _defenderMarks;
		}	
		
		/*********************************************************************************************************************
		*
		*
		* 
		*********************************************************************************************************************/	
		
		private var _fishVisible:Boolean;
		
		private var fishImage:Image;
		
		public function set fishVisible(value:Boolean):void
		{
			if (value == _fishVisible)
				return;
				
			_fishVisible = value;
			
			if (_fishVisible)
			{
				if (!fishImage) {
					fishImage = new Image(AtlasAsset.CommonAtlas.getTexture('cats/fish'));
					fishImage.alignPivot();
					//fishImage.x = 50 * layoutHelper.specialScale;
					fishImage.y = -85 /** layoutHelper.specialScale*/;
					fishImage.touchable = false;
					//image.scale = 0.4;
					addChild(fishImage);
				}
			}
			else
			{
				if (fishImage) {
					fishImage.removeFromParent();
					fishImage = null;
				}
			}	
		}
		
		public function get fishVisible():Boolean
		{
			return _fishVisible;
		}	
		
		
		/*********************************************************************************************************************
		*
		*
		* 
		*********************************************************************************************************************/	
		
		private var _starsVisible:Boolean;
		
		private var starsAnim:FrameAnimator;
		
		public function set starsVisible(value:Boolean):void
		{
			if (value == _starsVisible)
				return;
				
			_starsVisible = value;
			
			if (_starsVisible)
			{
				if (!starsAnim) {
					starsAnim = FrameAnimator.getStarsAnimator();
					starsAnim.touchable = false;
					//fishImage.x = 50 * layoutHelper.specialScale;
					starsAnim.y = -85 /** layoutHelper.specialScale*/;
					starsAnim.touchable = false;
					starsAnim.scale = 0.65;
					addChild(starsAnim);
				}
				
				starsAnim.gotoAndPlay(CatView.STARS_ANIM, 0, false, -1, 7);
			}
			else
			{
				if (starsAnim) {
					starsAnim.clean();
					starsAnim.removeFromParent();
					starsAnim = null;
				}
			}	
		}
		
		public function get starsVisible():Boolean
		{
			return _starsVisible;
		}	
		
		/*********************************************************************************************************************
		*
		*
		* 
		*********************************************************************************************************************/	
		
		public function refreshHP():void
		{
			if (_cat)
			{
				if (!hpLabel) 
				{
					hpLabel = new XTextField(160 * pxScale, 30 * pxScale, XTextFieldStyle.getWalrus(18).setStroke(0.5), '' );
					hpLabel.alignPivot();
					//hpLabel.x = 75;
					hpLabel.y = -125;
					hpLabel.touchable = false;
					
					
				}
				
				hpLabel.y = -130 /** layoutHelper.specialScale*/;//isLeft ? -130 : 123;
				hpLabel.format.color = _cat.health > 0 ? 0x00E100 : 0xE10000;
				hpLabel.text = 'health:' + _cat.health.toString();
				
				//addChild(hpLabel);
				
				
				if (!healthProgress) 
				{
					healthProgress = new SimpleProgressBar(AtlasAsset.CommonAtlas, 'bars/progress_bg', 'bars/progress_fill', 0);
					healthProgress.alignPivot();
					//hpLabel.x = 75;
					healthProgress.y = -125;
					healthProgress.touchable = false;
					
					
				}
				
				healthProgress.y = -130 /** layoutHelper.specialScale*///isLeft ? -130 : 123;
				healthProgress.animateValues(_cat.health / 3, 1, 0);
				//healthProgress.format.color = _cat.health > 0 ? 0x00E100 : 0xE10000;
				//healthProgress.text = 'health:' + _cat.health.toString();
				
				addChild(healthProgress);
				
				
			}
			else
			{
				if (roleImage) {
					//hpLabel.text = '';
					healthProgress.animateValues(0, 1, 0);
				}	
			}	
		}
		
		public function set showSelected(value:Boolean):void 
		{
			if (!catAnimator)
				return;
				
			if (value)
			{
				EffectsManager.jump(catAnimator, 10000, 1, 1.0, 0.05, 0.05, 0.9, 3, 0, 1.3, true);
				
				//catImage.filter = new DropShadowFilter(4, 0, 0xFFFFFF, 1, 3, 2);
				//(catImage.filter as ColorMatrixFilter).adjustBrightness(0.3);
			}
			else
			{
				EffectsManager.removeJump(catAnimator, true);
				//catImage.filter = null;
			}
			
		}
		
		public function showRoleAction(role:String, right:Boolean = true, animateCats:Boolean = false):void
		{
			if (role)
			{
				if (!roleActionImage) 
				{
					roleActionImage = new Image(CatRole.getRoleTexture(role));
					roleActionImage.alignPivot();
					roleActionImage.touchable = false;
					
					addChild(roleActionImage);
				}
				else 
				{
					roleActionImage.texture = CatRole.getRoleTexture(role);
					roleActionImage.readjustSize();
					roleActionImage.alignPivot();
				}
				
				roleActionImage.x = right ?  0: -0;
				EffectsManager.jump(roleActionImage, 10000, 1, 1.08, 0.05, 0.05, 0.08, 0, 0, 1.3, true);
				//roleActionImage.y = 85;
				
				if(animateCats)
					Starling.juggler.tween(catAnimator, 0.25, {delay:0.0, alpha:0, scale:catBaseScale*0.7, transition:Transitions.EASE_OUT, x:(right ? 100 : -100)});
				
			}
			else
			{
				if (roleActionImage) {
					EffectsManager.removeJump(roleActionImage);
					roleActionImage.removeFromParent();
					roleActionImage = null;
				}
				
				Starling.juggler.tween(catAnimator, 0.2, {delay:0.0, alpha:4, scale:catBaseScale, transition:Transitions.EASE_OUT, x:0});
			}	
			
			refreshHP();
		}
	}

}