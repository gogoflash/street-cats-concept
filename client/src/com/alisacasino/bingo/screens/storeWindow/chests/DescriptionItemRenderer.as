package com.alisacasino.bingo.screens.storeWindow.chests 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.components.CardsIconView;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.UIUtils;
	import feathers.core.FeathersControl;
	import starling.animation.Transitions;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DescriptionItemRenderer extends FeathersControl
	{
		private var background:Image;
		private var icon:DisplayObject;
		private var text:String;
		private var label:XTextField;
		
		public function DescriptionItemRenderer(icon:DisplayObject, text:String) 
		{
			this.text = text;
			this.icon = icon;
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			background = new Image(AtlasAsset.CommonAtlas.getTexture("store/purple_background"));
			background.scale9Grid = ResizeUtils.getScaledRect(18, 18, 2, 2);
			background.width = 470 * pxScale;
			background.height = 102 * pxScale;
			addChild(background);
			
			icon.alignPivot();
			icon.x = 70 * pxScale;
			icon.y = 50 * pxScale;
			addChild(icon);
			
			label = new XTextField(350 * pxScale, 102 * pxScale, XTextFieldStyle.getWalrus(27, 0xffffff).addShadow(1, 0x6956f1, 1, 4));
			label.isHtmlText = true;
			label.text = text;
			label.x = 100 * pxScale;
			addChild(label);
			
			width = background.width;
			height = background.height;
		}
		
		public function animateAppearance(delay:Number):void
		{
			UIUtils.makePopTween(icon, delay);
			
			label.alpha = 0;
			TweenHelper.tween(label, 0.4, { delay: delay + 0.2, alpha:1, transition:Transitions.EASE_OUT } );
		}
		
	}

}