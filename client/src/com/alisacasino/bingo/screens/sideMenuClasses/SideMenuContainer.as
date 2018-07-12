package com.alisacasino.bingo.screens.sideMenuClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.utils.Constants;
	import feathers.controls.BasicButton;
	import feathers.core.FeathersControl;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SideMenuContainer extends FeathersControl
	{
		public static const POSITION_HIDE_X:int = -500;
		
		private var blackQuad:Quad;
		private var quadButton:BasicButton;
		private var menu:SideMenu;
		protected var gameScreen:GameScreen;
		private var isHiding:Boolean;
		
		public function SideMenuContainer(gameScreen:GameScreen) 
		{
			this.gameScreen = gameScreen;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			quadButton = new BasicButton();
			blackQuad = new Quad(1, 1, 0x0);
			blackQuad.alpha = 0;
			quadButton.defaultSkin = blackQuad;
			
			quadButton.addEventListener(Event.TRIGGERED, quadButton_triggeredHandler);
			
			if(layoutHelper.isIPhoneX || Constants.isDevFeaturesEnabled)
				Game.addEventListener(Game.EVENT_ORIENTATION_CHANGED, handler_deviceOrientationChanged);
		}
		
		private function quadButton_triggeredHandler(e:Event):void 
		{
			hideMenu();
		}
		
		public function get isShowing():Boolean
		{
			return menu && menu.parent && menu.x != POSITION_HIDE_X * gameUILayoutScale;
		}
		
		public function hideMenu(time:Number = 0.4, transition:String = null):void 
		{
			isHiding = true;
			fadeOut();
			transition = transition || Transitions.EASE_IN;
			if (menu) {
				Starling.juggler.removeTweens(menu);
				menu.touchable = false;
				Starling.juggler.tween(menu, time, { "x#":POSITION_HIDE_X*pxScale, transition:transition, onComplete:removeMenu});
			}
		}
		
		private function removeMenu():void 
		{
			if (menu) {
				menu.removeFromParent(true);
				menu = null;
			}
		}
		
		private function fadeOut():void 
		{
			Starling.juggler.removeTweens(blackQuad);
			
			if(blackQuad.alpha == 0) {
				quadButton.removeFromParent();
				return;
			}
			
			Starling.juggler.tween(blackQuad, 0.3, { "alpha#":0.0, transition: Transitions.EASE_IN, onComplete:
					function():void { quadButton.removeFromParent(); }
				} );
		}
		
		public function showMenu(positionX:int = 0, time:Number = 1.5, transition:String = null):void
		{
			fadeIn();
			
			if (menu)
			{
				menu.removeFromParent(true);
			}
			
			transition = transition || Transitions.EASE_OUT_ELASTIC;
			isHiding = false;
			menu = new SideMenu(gameScreen);
			menu.addEventListener(Event.CLOSE, menu_closeHandler);
			addChild(menu);
			setMenuScale();
			menu.x = POSITION_HIDE_X * gameUILayoutScale;
			Starling.juggler.tween(menu, time, { "x#":(positionX + (layoutHelper.isIPhoneXOrientationRight ? 0 : 20)) * pxScale, transition:transition } );
		}
		
		public function jumpMenu(distance:int = 0, time:Number = 1.5):void
		{
			if (!menu)
				return;			
				
			var tween_0:Tween = new Tween(menu, 0.05, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(menu, 0.07, Transitions.EASE_OUT);
			
			//tween_0.delay = delay + 0;
			tween_0.nextTween = tween_1;
			tween_0.animate('x', menu.x + distance);
			
			tween_1.animate('x', menu.x);
			
			Starling.juggler.add(tween_0);
		}
		
		public function get inventoryButtonPositionY():Number
		{
			return menu ? (menu.inventoryOptionButton.y * menu.scale + (SideMenu.ITEM_HEIGHT * pxScale) * menu.scale/2): 0;
		}
		
		private function menu_closeHandler(e:Event):void 
		{
			hideMenu();
		}
		
		private function fadeIn():void 
		{
			Starling.juggler.removeTweens(blackQuad);
			addChild(quadButton);
			Starling.juggler.tween(blackQuad, 0.3, { "alpha#":0.6, transition: Transitions.EASE_OUT } );
		}
		
		override protected function draw():void 
		{
			super.draw();
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				quadButton.width = width;
				quadButton.height = height;
				
				if (menu)
				{
					setMenuScale();
				}
			}
		}
		
		private function setMenuScale():void 
		{
			menu.scale = gameManager.layoutHelper.independentScaleFromEtalonMin;
			menu.height = height / menu.scale;
			menu.validate();
		}
		
		private function handler_deviceOrientationChanged(event:Event):void
		{
			if (!menu)
				return;
				dispose
			if (!isHiding) {
				Starling.juggler.removeTweens(menu);
				Starling.juggler.tween(menu, 0.2, { "x#":(layoutHelper.isIPhoneXOrientationRight ? 0 : 20) * pxScale, transition:Transitions.EASE_OUT} );
			}
		}
		
		override public function dispose():void
		{
			if(layoutHelper.isIPhoneX || Constants.isDevFeaturesEnabled)
				Game.removeEventListener(Game.EVENT_ORIENTATION_CHANGED, handler_deviceOrientationChanged);
				
			super.dispose();
		}
	}

}