package com.alisacasino.bingo.dialogs
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.DevUtils;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.UIUtils;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Align;
	
	import starling.display.Image;
	
	public class ReconnectDialog extends BaseDialog
	{
		public static const TYPE_RECONNECT:String = 'TYPE_RECONNECT';
		
		//public static const TYPE_ALERT_DIALOG:String = 'TYPE_ALERT_DIALOG';
		
		public static const TYPE_BLANK:String = 'TYPE_BLANK';
		
		public static const TYPE_ERORR:String = 'TYPE_ERROR';
		
		public static const TYPE_INFO:String = 'TYPE_INFO';
		
		private var textLabel:XTextField;
		private var animationContainer:AnimationContainer;
		
		private var textWidth:int;
		private var textHeight:int;
		private var textAlignHorisontal:String;
		
		private var type:String;
		private var title:String;
		private var description:String;
		private var leading:int;
		private var completeFunction:Function;
		private var animationAsset:MovieClipAsset;
		private var _bottomButtomTitle:String;
		private var _fadeStrength:Number = -1;
		private var fontSize:int = 30;
		
		private var secondBottomButtonTitle:String;
		private var secondBottomButtonStyle:XButtonStyle;
		private var secondBottomButtonCallback:Function;
		private var invertBottomButtonsAlign:Boolean;
		private var secondBottomButtonShiftY:int;
		private var secondBottomButton:XButton;
		
		private var _bottomButtonStyle:XButtonStyle;
		private var buttonsWidth:int;
		private var buttonsHeight:int;
		private var textFontName:String;
		private var isHtmlText:Boolean;
		
		public function ReconnectDialog(type:String = 'TYPE_RECONNECT', title:String = null, description:String = null, leading:int = -999, completeFunction:Function = null, bottomButtomTitle:String = null, fadeStrength:Number = -1)
		{
			var dialogProperties:DialogProperties;
			
			this.type = type;
			textFontName = Fonts.CHATEAU_DE_GARAGE;
			textAlignHorisontal = Align.CENTER;
			textHeight = 437 * pxScale;
			
			switch(type) 
			{
				case TYPE_RECONNECT: {
					dialogProperties = DialogProperties.RECONNECT_DIALOG;
					animationAsset = MovieClipAsset.CatDisconnect;
					this.description = Constants.TEXT_RECONNECT_NEW;
					this.leading = 10 * pxScale;
					this.completeFunction = Game.current.loadGame;
					this.title = dialogProperties.title;
					_bottomButtomTitle = dialogProperties.bottomButtonTitle;
					_fadeStrength = dialogProperties.fadeStrength;
					textWidth = 425 * pxScale;
					break;
				}
				case TYPE_BLANK: {
					dialogProperties = DialogProperties.RECONNECT_BLANK;
					textWidth = 565 * pxScale;
					break;
				}
				case TYPE_ERORR: {
					dialogProperties = DialogProperties.RECONNECT_BLANK;
					textWidth = 565 * pxScale;
					textFontName = Fonts.WALRUS_BOLD;
					break;
				}
				case TYPE_INFO: {
					dialogProperties = DialogProperties.RECONNECT_BLANK;
					textWidth = 750 * pxScale;
					textHeight = 600 * pxScale;
					textFontName = Fonts.WALRUS_BOLD;
					textAlignHorisontal = Align.LEFT;
					isHtmlText = true;
					break;
				}
			}
			
			if (title != null)
				this.title = title;
			
			if (description != null)
				this.description = description;
			
			if(leading != -999)
				this.leading = leading * pxScale;
			
			if(completeFunction != null)	
				this.completeFunction = completeFunction;
			
			if (bottomButtomTitle != null)			
				_bottomButtomTitle = bottomButtomTitle;	
				
			if (fadeStrength != -1)
				_fadeStrength = fadeStrength;
			
			dialogProperties.hasCloseButton = Constants.isLocalBuild;	
				
			super(dialogProperties);
		}
		
		public function setProperties(fontSize:int, hasCloseButton:Boolean, bottomButtonStyle:XButtonStyle, buttonsWidth:int, buttonsHeight:int,secondBottomButtonTitle:String, secondBottomButtonStyle:XButtonStyle, secondBottomButtonCallback:Function, secondBottomButtonShiftY:int, invertBottomButtonsAlign:Boolean = false):void 
		{
			this.fontSize = fontSize;
			dialogProperties.hasCloseButton = hasCloseButton;	 
			
			this.secondBottomButtonTitle = secondBottomButtonTitle;
			this.secondBottomButtonStyle = secondBottomButtonStyle;
			this.secondBottomButtonCallback = secondBottomButtonCallback;
			this.invertBottomButtonsAlign = invertBottomButtonsAlign;
			this.buttonsWidth = buttonsWidth;
			this.buttonsHeight = buttonsHeight;
			this.secondBottomButtonShiftY = secondBottomButtonShiftY;
			_bottomButtonStyle = bottomButtonStyle;
		}
		
		override protected function get bottomButtonStyle():XButtonStyle {
			return _bottomButtonStyle || super.bottomButtonStyle;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			addBackImage(0.189, 0.6, 0.08);
			
			commitShowCatAnimation();
			
			var textLabelText:String;
			if (gameManager.deactivated) {
				Game.addEventListener(Game.ACTIVATED, game_activatedHandler);
				textLabelText = '';
			}
			else {
				textLabelText = description;
			}
			
			var textStyle:XTextFieldStyle = new XTextFieldStyle({fontName:textFontName, fontSize:fontSize, hAlign:textAlignHorisontal, vAlign:Align.CENTER, fontColor:0xFFFFFF});
			
			textLabel = new XTextField(textWidth, textHeight, textStyle, textLabelText);
			textLabel.format.leading = leading;
			textLabel.isHtmlText = isHtmlText;
			textLabel.touchable = false;
			addChild(textLabel);
			addToFadeList(textLabel, 0);
			
			if (PlatformServices.isCanvas && (Capabilities.playerType != "Desktop") && (Capabilities.playerType != "StandAlone") && type == TYPE_RECONNECT) 
				bottomButton.addEventListener(TouchEvent.TOUCH, handler_bottomButtonTouch);
				
			if (secondBottomButtonTitle != null && secondBottomButtonStyle) {
				secondBottomButton = new XButton(secondBottomButtonStyle, secondBottomButtonTitle, secondBottomButtonTitle);
				secondBottomButton.addEventListener(Event.TRIGGERED, handler_secondBottomButton);
				if (buttonsWidth > 0)
					secondBottomButton.width = buttonsWidth;
				if(buttonsHeight > 0)
					secondBottomButton.height = buttonsHeight;	
					
				secondBottomButton.alignPivot();	
				
				addChild(secondBottomButton);
				addToFadeList(secondBottomButton, 0);
			}
			
			if (bottomButton) {
				if (buttonsWidth > 0) {
					bottomButton.width = buttonsWidth;
					bottomButton.alignPivot();
				}
				
				if(buttonsHeight > 0)
					bottomButton.height = buttonsHeight;	
			}
		}	
		
		override public function resize():void
		{
			super.resize();
			
			if (animationContainer) 
			{
				animationContainer.x = 17 * pxScale;
				//animationContainer.y = backImage.y + 34 * pxScale;
				
				animationContainer.y = (background.height - animationContainer.height * pxScale) / 2 + background.y;
				
				textLabel.x = backImage.pivotX + backImageWidth - textLabel.width - 34 * pxScale;
			}
			else 
			{
				textLabel.x = (backgroundWidth - textLabel.width)/2;
			}
			
			textLabel.y = backImage.y + (backImage.height - textLabel.height) / 2;
			
			if (secondBottomButton)
			{
				if (bottomButton) 
				{
					var k:int = invertBottomButtonsAlign ? -1 : 1;
					
					bottomButton.x = backgroundWidth / 2 - k * (bottomButton.width/2 + 60*pxScale);
					secondBottomButton.x = backgroundWidth / 2 + k * (secondBottomButton.width/2 + 60*pxScale);
					
					secondBottomButton.y = bottomButton.y + secondBottomButtonShiftY;
				}
				else
				{
					secondBottomButton.x = backgroundWidth / 2;
					
					if (dialogProperties.autoCenteringContent) {
						var backImageBottomY:Number = backImage ? (backImage.y + backImage.height) : (background.y + background.height);
						secondBottomButton.y = backImageBottomY + (background.y + background.height - backImageBottomY - secondBottomButton.height)/2 + secondBottomButton.pivotY + 3*pxScale;
					}
					else {
						secondBottomButton.y = actualHeight * bottomButtonRelativeY;
					}
				}
			}
		}	
		
		override public function get fadeStrength():Number {
			return _fadeStrength;
		}
		
		override protected function get dialogTitle():String
		{
			return title;
		}
		
		override protected function get bottomButtonTitle():String
		{
			return _bottomButtomTitle;
		}
		
		override protected function handler_bottomButton(e:Event):void
		{
			super.handler_bottomButton(e);
			if (completeFunction != null) {
				completeFunction();
				completeFunction = null;
			}
		}
		
		private function commitShowCatAnimation():void 
		{
			if (!animationAsset)
				return;
			
			if (animationAsset.loaded) 
			{
				if (!animationContainer) {
					animationContainer = new AnimationContainer(animationAsset, true);
					addToFadeList(animationContainer, 0);
				}
					
				animationContainer.touchable = false;
				animationContainer.validate();
				animationContainer.play();
				addChild(animationContainer);
			}
			else 
			{
				animationContainer = new AnimationContainer(animationAsset, true);
				addToFadeList(animationContainer, 0);
				// todo: animationContainer.showPreloader();
				animationAsset.load(completeLoadCatAnimation, null);
			}
		}
		
		private function completeLoadCatAnimation():void 
		{
			commitShowCatAnimation();
			invalidate();
		}
		
		private function handler_secondBottomButton(e:Event):void
		{
			if (secondBottomButtonCallback != null) {
				secondBottomButtonCallback();
				secondBottomButtonCallback = null;
			}
		}
		
		private function game_activatedHandler(e:Event):void
		{
			Game.removeEventListener(Game.ACTIVATED, game_activatedHandler);
			textLabel.text = description;
			resize();
		}
		
		private function handler_bottomButtonTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(bottomButton);
			if (!touch)
				return;
			
			if (touch.phase == TouchPhase.BEGAN)
			{
				Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP, function onMouseUp(e:MouseEvent):void 
				{
					Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					var globalPoint:Point = localToGlobal(new Point(bottomButton.x - bottomButton.width/2, bottomButton.y - bottomButton.height/2));
					//Starling.current.stage.addChild( UIUtils.drawQuad('11', globalPoint.x, globalPoint.y, bottomButton.width*scale, bottomButton.height*scale, 0.7, 0xFF0000) );
					
					if(new Rectangle(globalPoint.x, globalPoint.y, bottomButton.width*scale, bottomButton.height*scale).contains(Starling.current.nativeStage.mouseX, Starling.current.nativeStage.mouseY))
						navigateToURL(new URLRequest(Settings.instance.appURL), "_parent");
				});
			}
		}
	}
}