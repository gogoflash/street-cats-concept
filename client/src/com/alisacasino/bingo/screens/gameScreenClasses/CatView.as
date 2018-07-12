package com.alisacasino.bingo.screens.gameScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.cats.CatModel;
	import com.alisacasino.bingo.models.cats.CatRole;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.JumpWithHintHelper;
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
		public static var WIDTH:int = 190;
		public static var HEIGHT:int = 270;
		
		public static var EVENT_TRIGGERED:String = 'EVENT_TRIGGERED';
		
		public function CatView() 
		{
			
		}
		
		public var roleVisible:Boolean;
		
		public var controlsEnabled:Boolean;
		
		public var isFront:Boolean;
		
		private var _cat:CatModel;
		
		private var catImage:Image;
		private var roleImage:Image;
		private var roleActionImage:Image;
		private var jumpHelper:JumpWithHintHelper;
		
		private var fightMarksContainer:Sprite;
		
		private var defenderMarksContainer:Sprite;
		
		private var hpLabel:XTextField;
		
		
		
		public var storedParent:DisplayObjectContainer;
		public var storedX:Number = 0;
		public var storedY:Number = 0;
		public var storedScale:Number = 1;
		
		public var storedX_0:Number = 0;
		public var storedY_0:Number = 0;
		
		public function refreshStoreds():void 
		{
			storedParent = parent;
			storedX = x;
			storedY = y;
			storedScale = parent.scale;
		}
		
		public function set cat(value:CatModel):void 
		{
			if (_cat == value)
				return;
			
			_cat = value;	
				
			if (value)
			{
				if (!catImage) 
				{
					catImage = new Image(gameManager.catsModel.getCatTexture(_cat.catUID, isFront));
					catImage.alignPivot();
					addChild(catImage);
					
					if (controlsEnabled) {
						jumpHelper = new JumpWithHintHelper(catImage, true, true);
						jumpHelper.setStateCallbacks(null, null, callback_imageTriggered);
					}
					
				}
				else 
				{
					catImage.texture = gameManager.catsModel.getCatTexture(_cat.catUID, isFront);
					catImage.readjustSize();
					catImage.alignPivot();
				}
				
				if (roleImage)
					addChild(roleImage);
					
				if (fightMarksContainer)
					addChild(fightMarksContainer);
					
				if (hpLabel)
					addChild(hpLabel);
			}
			else
			{
				if (catImage) {
					catImage.removeFromParent();
					catImage = null;
					
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
		
		private function callback_imageTriggered():void {
			dispatchEventWith(EVENT_TRIGGERED, true);
		}
		
		public function showRoleImage(role:String):void
		{
			if (role)
			{
				if (!roleImage) 
				{
					roleImage = new Image(CatRole.getRoleTexture(role));
					roleImage.alignPivot();
					roleImage.x = 75;
					roleImage.y = 85;
					roleImage.touchable = false;
					
					addChild(roleImage);
				}
				else 
				{
					roleImage.texture = CatRole.getRoleTexture(role);
					roleImage.readjustSize();
					roleImage.alignPivot();
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
				
				hpLabel.y = isFront ? -130 : 123;
				hpLabel.format.color = _cat.health > 0 ? 0x00E100 : 0xE10000;
				hpLabel.text = 'health:' + _cat.health.toString();
				
				addChild(hpLabel);
			}
			else
			{
				if (roleImage) {
					hpLabel.text = '';
				}	
			}	
		}
		
		public function set showSelected(value:Boolean):void 
		{
			if (!catImage)
				return;
				
			if (value)
			{
				EffectsManager.jump(catImage, 10000, 1, 1.0, 0.05, 0.05, 0.9, 3, 0, 1.3, true);
				
				//catImage.filter = new DropShadowFilter(4, 0, 0xFFFFFF, 1, 3, 2);
				//(catImage.filter as ColorMatrixFilter).adjustBrightness(0.3);
			}
			else
			{
				EffectsManager.removeJump(catImage, true);
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
					Starling.juggler.tween(catImage, 0.25, {delay:0.0, alpha:0, scale:0.7, transition:Transitions.EASE_OUT, x:(right ? 100 : -100)});
				
			}
			else
			{
				if (roleActionImage) {
					EffectsManager.removeJump(roleActionImage);
					roleActionImage.removeFromParent();
					roleActionImage = null;
				}
				
				Starling.juggler.tween(catImage, 0.2, {delay:0.0, alpha:4, scale:1, transition:Transitions.EASE_OUT, x:0});
			}	
			
			refreshHP();
		}
	}

}