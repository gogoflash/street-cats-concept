package com.alisacasino.bingo.screens.gameScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.cats.CatRole;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class RoundStatusBar extends Sprite
	{
		public function RoundStatusBar(bgWidth:int, bgHeight:int) 
		{
			bgImage = new Image(AtlasAsset.CommonAtlas.getTexture('buttons/dark_blue'));
			
			bgImage.scale9Grid = new Rectangle(12, 12, 2, 2);
			bgImage.alpha = 0.8;
			bgImage.pivotX = 23;
			bgImage.pivotY = 23;
			bgImage.alignPivot();
			bgImage.width = bgWidth;
			bgImage.height = bgHeight;
			
			addChild(bgImage);
			
			catIconScale = bgImage.height / 100;
			
			charV = new XTextField(100*layoutHelper.specialScale, bgImage.height, XTextFieldStyle.houseHolidaySans(layoutHelper.specialScale*55, 0xffffff).setStroke(1), 'VS');
			charV.helperFormat.nativeTextExtraHeight = 10*layoutHelper.specialScale;
			charV.helperFormat.nativeTextExtraWidth = 10*layoutHelper.specialScale;
			charV.alignPivot();
			addChild(charV);
			
			leftActionImage = new Image(AtlasAsset.CommonAtlas.getTexture('cats/actions/sword'));
			leftActionImage.alignPivot();
			leftActionImage.x = -actionIconShiftX;
			//leftActionImage.y = bgImage.height/2;
			addChild(leftActionImage);
			
			rightActionImage = new Image(AtlasAsset.CommonAtlas.getTexture('cats/actions/sword'));
			rightActionImage.alignPivot();
			rightActionImage.x = actionIconShiftX;
			//rightActionImage.y = bgImage.height/2;
			addChild(rightActionImage);
			
			touchable = false;
			
			leftCatIcons = [];
			rightCatIcons = [];
		}
		
		private var bgImage:Image;
		
		private var charV:XTextField;
		
		private var leftActionImage:Image;
		
		private var rightActionImage:Image;
		
		private var leftCatIcons:Array;
		private var rightCatIcons:Array;
		
		private var actionIconShiftX:int = 60//*layoutHelper.specialScale;
		
		public function showSimple(cat_1:CatView, cat_2:CatView):void 
		{
			if(cat_1.isLeft)
				show(new <CatView>[cat_1], new <CatView>[cat_2]);
			else
				show(new <CatView>[cat_2], new <CatView>[cat_1]);
		}
		
		private var storedLeftCats:Vector.<CatView>;
		private var storedRightCats:Vector.<CatView>;
		private var storedText:String;
		
		private var delayCallId:int;
		
		private var catIconScale:Number = 1;
		
		public function show(leftCats:Vector.<CatView>, rightCats:Vector.<CatView>, text:String= 'VS', immediate:Boolean = false):void 
		{
			Starling.juggler.removeTweens(this);
			
			if (!leftCats || !rightCats)
			{
				//visible = false;
				//leftActionImage.visible = false;
				//rightActionImage.visible = false;
				//
				
				Starling.juggler.tween(this, 0.5, {alpha:0});
				
				return;
			}
			
			Starling.juggler.tween(this, 0.5, {alpha:1});
			
			var i:int;
			var catIcon:Image;
			var catView:CatView;
			
			if (immediate)
			{
				storedLeftCats = null;
				storedRightCats = null;
				storedText = null;
				Starling.juggler.removeByID(delayCallId);
			}
			else
			{
				// прячем все
				storedLeftCats = leftCats;
				storedRightCats = rightCats;
				storedText = text;
				
				delayCallId = Starling.juggler.delayCall(show, 0.22, storedLeftCats, storedRightCats, storedText, true);
				
				for (i = 0; i < leftCatIcons.length; i++) 
				{
					catIcon = leftCatIcons[i] as Image;
					Starling.juggler.tween(catIcon, 0.2, {alpha:0, x:(catIcon.x-120*layoutHelper.specialScale), transition:Transitions.EASE_OUT});
				}
				
				for (i = 0; i < rightCatIcons.length; i++) 
				{
					catIcon = rightCatIcons[i] as Image;
					Starling.juggler.tween(catIcon, 0.2, {alpha:0, x:(catIcon.x+120*layoutHelper.specialScale), transition:Transitions.EASE_OUT});
				}
				
				Starling.juggler.tween(leftActionImage, 0.2, {alpha:0, x:(leftActionImage.x - 100*layoutHelper.specialScale), transition:Transitions.EASE_OUT});
				Starling.juggler.tween(rightActionImage, 0.2, {alpha:0, x:(rightActionImage.x+100*layoutHelper.specialScale), transition:Transitions.EASE_OUT});
				
				return;
			}
			
			
			charV.text = text;
			
			
			while (leftCatIcons.length > leftCats.length) {
				catIcon = leftCatIcons.pop() as Image;
				catIcon.removeFromParent();
			}
			
			while (rightCatIcons.length > rightCats.length) {
				catIcon = rightCatIcons.pop() as Image;
				catIcon.removeFromParent();
			}
			
			handleNewCats(leftCatIcons, leftCats, true);
			handleNewCats(rightCatIcons, rightCats, true);
		
			/*for (i = 0; i < leftCats.length; i++) 
			{
				catView = leftCats[i] as CatView;
				if (i >= leftCatIcons.length) {
					catIcon = new Image(AtlasAsset.LoadingAtlas.getTexture(getTextureByRole(catView.cat.role)););
					catIcon.alignPivot();
					catIcon.scaleX = -1;
					leftCatIcons.push(catIcon);
					addChild(catIcon);
				}
				else {
					catIcon = leftCatIcons[i] as Image;
					catIcon.texture = AtlasAsset.LoadingAtlas.getTexture(getTextureByRole(catView.cat.role));
					catIcon.readjustSize();
				}
			}*/
			
		}
		
		private function handleNewCats(catIcons:Array, catViews:Vector.<CatView>, animate:Boolean = false):void 
		{
			var i:int;
			var catIcon:Image;
			var catView:CatView;
			var isLeft:Boolean;
			
			if (catViews.length == 0)
				return;
			
			for (i = 0; i < catViews.length; i++) 
			{
				catView = catViews[i] as CatView;
				isLeft = catView.isLeft;
				if (i >= catIcons.length) {
					catIcon = new Image(AtlasAsset.LoadingAtlas.getTexture(getTextureByCat(catView)));
					catIcon.alignPivot();
					catIcon.scale = bgImage.height/catIcon.texture.frameHeight;
					catIcons.push(catIcon);
					addChild(catIcon);
				}
				else {
					catIcon = catIcons[i] as Image;
					catIcon.texture = AtlasAsset.LoadingAtlas.getTexture(getTextureByCat(catView));
					catIcon.readjustSize();
				}
				
				catIcon.scaleX = isLeft ? Math.abs(catIcon.scale) : -Math.abs(catIcon.scale);
			}
			
			var coef:Number = isLeft ? -1 : 1;
			
			var actionIcon:Image = isLeft ? leftActionImage : rightActionImage;
			actionIcon.scale = Math.abs(catIcon.scale);
			actionIcon.texture = AtlasAsset.CommonAtlas.getTexture(getActionIconTextureByRole(catView.cat.role));
			actionIcon.readjustSize();
			actionIcon.alignPivot();
			actionIcon.alpha = 1;
			actionIcon.x = coef*actionIconShiftX*Math.abs(catIcon.scale);
			
			if (animate)
			{
				Starling.juggler.tween(actionIcon, 0.2, {alpha:1, x:(actionIcon.x), transition:Transitions.EASE_OUT});
				actionIcon.x += coef * 100*layoutHelper.specialScale;
				actionIcon.alpha = 0;
			}
			
			var iconSize:int = 80*layoutHelper.specialScale;
			var iconGap:int = 10*layoutHelper.specialScale;
			var shifhtX:int = 0//catIcons.length * iconSize + (catIcons.length - 1) * iconGap;
			for (i = 0; i < catIcons.length; i++) 
			{
				catIcon= catIcons[i] as Image;
				catIcon.x = coef * (40*Math.abs(catIcon.scale) + catIcon.width - shifhtX + i * (iconSize + iconGap));
				catIcon.alpha = 1;
				
				if (animate)
				{
					Starling.juggler.tween(catIcon, 0.2, {alpha:1, x:catIcon.x, transition:Transitions.EASE_OUT});
					catIcon.x += coef * 120*layoutHelper.specialScale*catIcon.scale;
					catIcon.alpha = 0;
				}
			}
		}
		
		private function getTextureByCat(catView:CatView):String 
		{
			var catPostfix:String = catView.isLeft ? '_blue' : '_red';
			switch(catView.cat.role) {
				case CatRole.FIGHTER : return 'cats/actions_icons/angry' + catPostfix;
				case CatRole.HARVESTER : return 'cats/actions_icons/hungry' + catPostfix;
				case CatRole.DEFENDER : return 'cats/actions_icons/defence' + catPostfix;
			}
			return '';
		}
		
		private function getActionIconTextureByRole(role:String):String 
		{
			switch(role) {
				case CatRole.FIGHTER : return 'cats/actions/sword';
				case CatRole.HARVESTER : return 'cats/actions/fish';
				case CatRole.DEFENDER : return 'cats/actions/shield';
			}
			return '';
		}
		
		public function showHarvestSimple(cat:CatView):void 
		{
			if (!cat)
			{
				visible = false;
				//leftActionImage.visible = false;
				//rightActionImage.visible = false;
				//charV.visible = false;
				return;
			}
			
			visible = true;
			
			var actionIcon:Image;
			if (cat.isLeft) {
				show(new <CatView>[cat], new <CatView>[], '>');
				actionIcon = rightActionImage;
			}
			else {
				
				show(new <CatView>[], new <CatView>[cat], '<');
				actionIcon = leftActionImage;
			}
				
			actionIcon.texture = AtlasAsset.CommonAtlas.getTexture('cats/harvest/fish');
			actionIcon.readjustSize();
			actionIcon.scale = 0.4*catIconScale;
			actionIcon.alignPivot();
			
			Starling.juggler.removeTweens(actionIcon);
			actionIcon.alpha = 1;
			actionIcon.x = (cat.isLeft ? actionIconShiftX : -actionIconShiftX)*catIconScale;
			
			//Starling.juggler.tween(leftActionImage, 0.3, {alpha:1, x:(actionIcon.x), transition:Transitions.EASE_OUT});
		}
		
	}

}