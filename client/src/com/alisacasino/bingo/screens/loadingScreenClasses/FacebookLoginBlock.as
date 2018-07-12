package com.alisacasino.bingo.screens.loadingScreenClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.RedBadge;
	import com.alisacasino.bingo.utils.Constants;
	import feathers.controls.Button;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class FacebookLoginBlock extends FeathersControl
	{
		private var connectLaterButton:Button;
		private var connectToFacebookButton:XButton;
		private var redBadgeButton:Button;
		
		private var showingBubble:Boolean;
		private var infoBubble:Sprite;
		
		public function FacebookLoginBlock() 
		{
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			connectToFacebookButton = new XButton(XButtonStyle.FacebookConnectButtonStyle);
			connectToFacebookButton.addEventListener(Event.TRIGGERED, connectToFacebookButton_triggeredHandler);
			addChild(connectToFacebookButton);
			
			redBadgeButton = createRedBadgeButton();
			redBadgeButton.y = -20 * pxScale;
			redBadgeButton.addEventListener(Event.TRIGGERED, redBadgeButton_triggeredHandler);
			addChild(redBadgeButton);
			
			connectLaterButton = createLaterButton();
			connectLaterButton.y = 110 * pxScale;
			connectLaterButton.addEventListener(Event.TRIGGERED, connectLaterButton_triggeredHandler);
			addChildAt(connectLaterButton, 0);
			
			infoBubble = new BenefitsBubble();
			addChild(infoBubble);
			infoBubble.alpha = 0;
			
			//showBubble();
		}
		
		private function redBadgeButton_triggeredHandler(e:Event):void 
		{
			if (showingBubble)
			{
				hideBubble();
			}
			else
			{
				showBubble();
			}
		}
		
		private function showBubble():void 
		{
			if (showingBubble)
			{
				return;
			}
			Starling.juggler.removeTweens(infoBubble);
			infoBubble.alpha = 0;
			infoBubble.scale = 0.1;
			Starling.juggler.tween(infoBubble, 0.5, { "scale#":1, transition:Transitions.EASE_OUT_ELASTIC } );
			Starling.juggler.tween(infoBubble, 0.2, { "alpha#":1, transition:Transitions.EASE_OUT} );
			showingBubble = true;
		}
		
		public function hideBubble(skipAnim:Boolean = false):void 
		{
			if (!showingBubble)
			{
				return;
			}
			Starling.juggler.removeTweens(infoBubble);
			
			if (skipAnim)
			{
				infoBubble.alpha = 0;
				return;
			}
			
			infoBubble.alpha = 1;
			infoBubble.scale = 1;
			Starling.juggler.tween(infoBubble, 0.2, { "scale#":0, "alpha#":0, transition:Transitions.EASE_IN } );
			showingBubble = false;
		}
		
		private function createRedBadgeButton():Button
		{
			var button:Button = new Button();
			button.useHandCursor = true;
			button.scaleWhenDown = 0.9;
			
			var badge:Image  = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/red_badge"));
			var textField:XTextField = new XTextField(badge.width, badge.height, XTextFieldStyle.LoadingScreenInfoBadgeTextStyle, "i");
			
			var skin:Sprite = new Sprite();
			skin.scale = 0.75;
			skin.addChild(badge);
			textField.x = -3 * pxScale;
			textField.y = -12 * pxScale;
			skin.addChild(textField);
			
			button.defaultSkin = skin;
			
			return button;
		}
		
		private function createLaterButton():Button
		{
			var button:Button = new Button();
			button.useHandCursor = true;
			button.scaleWhenDown = 0.95;
			
			var buttonSkin:Sprite = new Sprite();
			var quad:Quad = new Quad(360 * pxScale, 70*pxScale, 0x00FFFF);
			quad.alpha = 0.0;
			buttonSkin.addChild(quad);
			
			var textField:XTextField = new XTextField(200 * pxScale, 60 * pxScale, XTextFieldStyle.White70C, "Later");
			textField.alpha = 0.7;
			textField.redraw();
			textField.x = (quad.width - textField.width) / 2;
			buttonSkin.addChild(textField);
			
			button.defaultSkin = buttonSkin;
			
			return button;
		}
		
		private function connectLaterButton_triggeredHandler(e:Event):void 
		{
			Game.dispatchEventWith(Game.FACEBOOK_LOGIN_CANCELLED);
		}
		
		private function connectToFacebookButton_triggeredHandler(e:Event):void 
		{
			PlatformServices.facebookManager.openSession();
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			connectLaterButton.validate();
			
			connectToFacebookButton.x = -connectToFacebookButton.width / 2;
			
			redBadgeButton.x = connectToFacebookButton.x + connectToFacebookButton.width - 40 * pxScale;
			
			connectLaterButton.x = -connectLaterButton.width / 2;
			
			infoBubble.x = redBadgeButton.x + 36 * pxScale;
			infoBubble.y = redBadgeButton.y - 16 * pxScale;
			
			setSizeInternal(connectToFacebookButton.width, connectLaterButton.y + connectLaterButton.height, false);
		}
		
	}

}