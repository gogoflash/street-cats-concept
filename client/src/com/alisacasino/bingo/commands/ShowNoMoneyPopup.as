package com.alisacasino.bingo.commands 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.commands.dialogCommands.ShowStore;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.utils.caurina.transitions.properties.DisplayShortcuts;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.swiftsuspenders.typedescriptions.PropertyInjectionPoint;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.DropShadowFilter;
	import starling.text.TextField;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ShowNoMoneyPopup extends CommandBase
	{
		static public const GREEN:uint = 0x9AFF5D;
		static public const YELLOW:uint = 0xFFE4A7;
		static public const PURPLE:uint = 0xF3A7FF;
		static public const RED:uint = 0xFF0000;
		
		private var container:DisplayObjectContainer;
		private static var lastContent:Sprite;
		private var content:Sprite;
		private var textField:XTextField;
		private var shadow:Image;
		
		private var point:Point;
		private var color:uint;
		private var customText:String;
		private var showStore:Boolean;
		private var customWidth:uint;
		
		private static var delayedCallID:uint;
		
		
		public function ShowNoMoneyPopup(color:uint = YELLOW, container:DisplayObjectContainer = null, point:Point = null, customText:String = null, showStore:Boolean = true, customWidth:int = 490) 
		{
			this.color = color;
			this.point = point;
			this.container = container;
			this.customText = customText;
			this.showStore = showStore;
			this.customWidth = customWidth;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			if(showStore)
				gameManager.storeData.noMoneyRepeat++;
			
			if (gameManager.storeData.noMoneyRepeat >= 8)
			{
				clearRepeatCount();
				new ShowStore().execute();
				tweenAndRemove(lastContent);
				
				finish();
				return;
			}
			
			if (!container)
				container = Game.current.currentScreen as DisplayObjectContainer;
			
			if (!container)
				return;
			
			if (!point)
				point = new Point(container.width / 2, container.height / 2);
						
			tweenAndRemove(lastContent);
			
			content = new Sprite();
			content.touchable = false;
			content.x = point.x;
			content.y = point.y;
			container.addChild(content);
			
			shadow = new Image(AtlasAsset.CommonAtlas.getTexture("effects/shadow_ball"));
			shadow.scale9Grid = new Rectangle(39*pxScale, 38*pxScale, 2*pxScale, 2*pxScale);
			content.addChild(shadow);
			
			textField = new XTextField(customWidth*pxScale, 60*pxScale, XTextFieldStyle.getWalrus(37*pxScale, color).setStroke(0.1).setShadow(0.8), customText || 'NOT ENOUGH CASH'); 
			textField.alignPivot();
			textField.pixelSnapping = false;
			shadow.width = textField.textBounds.width + 18*pxScale;
			shadow.height = 55 * pxScale;
			shadow.pivotX = 40 * pxScale;
			shadow.y = -15 * pxScale;
			
			content.alpha = 0;
			content.scale = 0.6;
			content.addChild(textField);
			
			lastContent = content;
			TweenHelper.tween(content, 0.1, {scale: 1});
			TweenHelper.tween(content, 0.2, {alpha: 1});
			TweenHelper.tween(content, 2, { y:(content.y - 20*pxScale), transition:Transitions.EASE_OUT_SINE} )
				.chain(content, 1, {alpha: 0, transition:Transitions.EASE_IN_SINE, onComplete:onTweensComplete} );
			container.addChild(content);
			
			if(delayedCallID == 0)
				delayedCallID = Starling.juggler.delayCall(clearRepeatCount, 5);
		}
		
		private function tweenAndRemove(content:DisplayObject):void 
		{
			if (!content || !content.parent) 
				return;
			
			TweenHelper.tween(content, 0.3, {alpha:0, /*y:(content.y - 80*pxScale), */transition:Transitions.EASE_OUT, onComplete:removeView, onCompleteArgs:[content]});
		}
		
		private function removeView(view:DisplayObject):void 
		{
			if (view) {
				Starling.juggler.removeTweens(view);
				view.removeFromParent();
			}
		}
		
		private function onTweensComplete():void 
		{
			content.removeFromParent();
		}
		
		private function cancelDelayedClear():void 
		{
			if(delayedCallID != 0)
				Starling.juggler.removeByID(delayedCallID);
			
			delayedCallID = 0;
		}
		
		public function clearRepeatCount():void 
		{
			cancelDelayedClear();
			gameManager.storeData.noMoneyRepeat = 0;
		}
		
	}

}