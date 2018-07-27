package com.alisacasino.bingo.screens
{
	import com.alisacasino.bingo.Preloader;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.assets.loading.AssetQueue;
	import com.alisacasino.bingo.commands.dialogCommands.ShowNoConnectionDialog;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.ReconnectDialog;
	import com.alisacasino.bingo.dialogs.TransferRateWarningDialog;
	import com.alisacasino.bingo.logging.SaveHTMLLog;
	import com.alisacasino.bingo.logging.SendLog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.loadingScreenClasses.StarItem;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import feathers.controls.Button;
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextFieldAutoSize;
	
	import starling.display.Quad;
	import starling.events.EnterFrameEvent;
	import starling.textures.Texture;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class LoadingScreen extends ScreenBase
	{
		public static const TIME_TO_SHOW_LOGO:int = 3000;
		
		public static const SETTINGS_LOADED_POSITION:Number = 0.1;
		public static const ASSET_INDICES_LOADED_POSITION:Number = 0.2;
		public static const STATIC_CONFIG_LOADED_POSITION:Number = 0.3;
		public static const LOADING_ASSETS_POSITION:Number = 0.4;
		public static const LOADING_COMPLETE_POSITION:Number = 1.0;
		public static const ADVANCE_INTERVAL_MILLIS:Number = 1000;
		static private const DOWNLOAD_PROGRESS_SHOW_TIME:Number = 10000;
		static private const WARNING_SHOW_TIME:Number = 60000;
		
		public var hideComplete:Boolean;
		
		private var mGameManager:GameManager = GameManager.instance;
		
		private var blackFillBackground:Quad;
		private var backgroundImage:Image;
		private var bg:Image;
		//private var mLoadingBar:LoadingBar;
		
		private var currentAssetQueue:AssetQueue;
		
		private var connectToFacebookButton:XButton;
		private var connectToFacebookLaterButton:Button;
		
		private var splashBg:Image;
		private var logoGlow:Image;
		private var alisaLogoImage:Image;
		
		private var progressBar:NewProgressBar;
		
		private var preloaderLoadedValue:Number = 0;
		
		private var dialogsLayer:Sprite;
		
		private var tweenHideCompleteFunction:Function;
		
		private var blackFill1:Quad;
		private var blackFill2:Quad;
		private var preloaderFadeContainer:Sprite;
		private var contentShown:Boolean;
		private var progressText:XTextField;
		private var progressHintText:XTextField;
		private var gameLoadTimeStart:int = -1;
		private var warningShown:Boolean;
		private var needToShowFacebookLoginBlock:Boolean;
		private var showingFBLoginBlock:Boolean;
		private var maintenanceMode:Boolean;
		private var id:String;
		
		private var stars:Vector.<StarItem> = new <StarItem>[];
		private var starsPosition:Number = 100000;
		private var starsVelocity:Number = 1.4;
		private var starsVelocityDiv:Number = 0;
		private var lastLogoTouchTime:int;
		
		private var progressShown:Boolean;
		
		private var hintsPool:Vector.<String>;
		
		private var startProgressShowTime:int;
		private var lastChangeHintTime:int;
		private var changeHintTimeout:int = 3000;
		
		private var leftTopTouchQuad:Quad;
		private var leftTopTouchQuadLastTouchTime:int;
		private var leftTopTouchQuadFastTouchCount:int;
		
		private var logoText:XTextField;
		
		public function LoadingScreen()
		{
			id = int(Math.random() * int.MAX_VALUE).toString(36);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			preloaderFadeContainer = new Sprite();
			blackFill1 = new Quad(1, 1, 0x000000);
			preloaderFadeContainer.addChild(blackFill1);
			
			blackFill2 = new Quad(1, 1, 0x000000);
			preloaderFadeContainer.addChild(blackFill2);
			
			backgroundImage = new Image(gameManager.preloaderBackgroundTexture);
			
			
			preloaderFadeContainer.addChild(backgroundImage);
			
			addChild(preloaderFadeContainer);
			
			resize();
			
			dialogsLayer = new Sprite();
			addChild(dialogsLayer);
			DialogsManager.setDialogsLayer(dialogsLayer);
			
			leftTopTouchQuad = new Quad(150 * pxScale, 150 * pxScale, 0xFF0000);
			leftTopTouchQuad.addEventListener(TouchEvent.TOUCH, onLeftTopTouchQuadTouch);	
			leftTopTouchQuad.alpha = 0;
			addChild(leftTopTouchQuad);
			
			Game.addToHistory('load_screen');
			
			
		}
		
		override public function resize():void
		{
			blackFill1.width = layoutHelper.stageWidth;
			blackFill1.height = layoutHelper.stageHeight;
			
			backgroundImage.scale = Math.min(layoutHelper.stageWidth / backgroundImage.texture.width, layoutHelper.stageHeight / backgroundImage.texture.height );
			
			backgroundImage.x = (layoutHelper.stageWidth - backgroundImage.width) /2;
			backgroundImage.y = (layoutHelper.stageHeight - backgroundImage.height) / 2;
			
			if (backgroundImage.x > 0)
			{
				blackFill1.width = backgroundImage.x;
				blackFill1.height = layoutHelper.stageHeight;
				blackFill2.x = layoutHelper.stageWidth - backgroundImage.x;
				blackFill2.y = 0;
				blackFill2.width = backgroundImage.x;
				blackFill2.height = layoutHelper.stageHeight;
			}
			else if (backgroundImage.y > 0)
			{
				blackFill1.width = layoutHelper.stageWidth;
				blackFill1.height = backgroundImage.y;
				blackFill2.x = 0;
				blackFill2.y = layoutHelper.stageHeight - backgroundImage.y;
				blackFill2.width = layoutHelper.stageWidth;
				blackFill2.height = backgroundImage.y;
			}
			
			if (!blackFillBackground)
				return;
				
			var viewScale:Number = gameManager.layoutHelper.independentScaleFromEtalonMin;
			
			blackFillBackground.width = layoutHelper.stageWidth;
			blackFillBackground.height = layoutHelper.stageHeight;
			
			/*ResizeUtils.resizeBackground(splashBg);
			splashBg.x = (layoutHelper.stageWidth - splashBg.width) /2;
			splashBg.y = (layoutHelper.stageHeight - splashBg.height) / 2;*/
		
			
			if (logoGlow) 
			{
				logoGlow.alpha = 0;
				logoGlow.visible = false;
				logoGlow.scale = viewScale*2;
				
				alisaLogoImage.scale = viewScale;
				alisaLogoImage.x = layoutHelper.stageWidth/2 - alisaLogoImage.width / 2;
				alisaLogoImage.y = layoutHelper.stageHeight * 0.084// * pxScale//205/720 * pxScale;
				
				logoText.x = alisaLogoImage.x + (alisaLogoImage.width - logoText.width)/2;
				logoText.y = alisaLogoImage.y + 205;
				logoText.visible = false;
				
				alignLogoImages();
				
				
				ResizeUtils.resizeBackground(bg);
				bg.alignPivot();
				bg.x = bg.pivotX + (layoutHelper.stageWidth - bg.texture.frameWidth) / 2;
				bg.y = bg.pivotY + (layoutHelper.stageHeight - bg.texture.frameHeight) / 2;
			}
			
			if (connectToFacebookButton) {
				connectToFacebookButton.scale = layoutHelper.independentScaleFromEtalonMin;
				connectToFacebookButton.x = layoutHelper.stageWidth / 2;
				connectToFacebookButton.y = layoutHelper.stageHeight * 0.768;
				
				connectToFacebookLaterButton.scale = layoutHelper.independentScaleFromEtalonMin;
				connectToFacebookLaterButton.validate();
				connectToFacebookLaterButton.x = layoutHelper.stageWidth / 2;
				connectToFacebookLaterButton.y = layoutHelper.stageHeight * 0.895;
			}
	
			if (progressBar) {
				progressBar.scale = viewScale;
				progressBar.width = layoutHelper.stageWidth/viewScale * 0.76;
				
				progressBar.x = (layoutHelper.stageWidth - progressBar.width*viewScale) / 2;
				progressBar.y = Math.max(layoutHelper.stageHeight - 112 * pxScale, alisaLogoImage.y + alisaLogoImage.height + 10 * pxScale);
			}
			
			if (progressHintText) {
				progressHintText.scale = viewScale;
				progressHintText.x = (layoutHelper.stageWidth - progressHintText.width) / 2;
				progressHintText.y = progressBar.y + 24 * pxScale * viewScale;
			}
			
			/*if (progressText)
			{
				progressText.scale = viewScale;
				progressText.visible = false;
				progressText.x = progressBar.x + progressBar.width / 2;
				progressText.y = progressBar.y + 90 * pxScale * viewScale;
			}*/
			
			preloaderPosition = preloaderLoadedValue;
			
			
			//splashBg.alpha = 0;
			//backgroundImage.alpha = 0;
			//if(logoGlow)
				//logoGlow.alpha = 0;
			//progressBar.alpha = 0;
			//progressText.alpha = 0;
			//connectToFacebookButton.alpha = 0;
			//connectToFacebookLaterButton.alpha = 0;
			//alisaLogoImage.alpha = 0;
			
			//gameManager.preloader.backgroundContainer.alpha = 0;
			
			//addChild(bg);
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void
		{
			if (getTimer() < TIME_TO_SHOW_LOGO)
				return;
				
			removeEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
			preloaderFadeContainer.touchable = false;
			Starling.juggler.tween(preloaderFadeContainer, 0.6, { "alpha":0, /*onComplete:callback_showLogoAndProgress,*/ transition:Transitions.EASE_IN} );
			Starling.juggler.delayCall(callback_showLogoAndProgress, 0.1);
		}
		
		private function callback_showLogoAndProgress():void
		{
			//Starling.juggler.tween(splashBg, 0.5, { "alpha":1} );
			Starling.juggler.tween(logoGlow, 0.5, { "alpha":1} );
			Starling.juggler.tween(alisaLogoImage, 0.5, { "alpha":1} );
			//Starling.juggler.tween(progressBar, 0.5, { "alpha":1} );
			
			Starling.juggler.delayCall(swingLogoAndGlow, 0.55);
		}
		
		private function swingLogoAndGlow():void
		{
			//Starling.juggler.tween(alisaLogoImage, 3, {y:alisaLogoImage.y - 10*pxScale, repeatCount:0, reverse:true, transition:Transitions.EASE_IN_OUT, onUpdate:alignLogoImages});
			//Starling.juggler.tween(logoGlow, 3, {y:logoGlow.y - 10*pxScale, /*alpha:0.5, */repeatCount:0, reverse:true, transition:Transitions.EASE_IN_OUT});
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			dispose();
			removeAssetQueueListener();
		}
		
		public function watchAssetQueue(assetQueue:AssetQueue):void
		{
			currentAssetQueue = assetQueue;
			
			if (currentAssetQueue)
			{
				currentAssetQueue.addEventListener(Event.CHANGE, currentAssetQueue_changeHandler);
			}
		}
		
		private function removeAssetQueueListener():void 
		{
			if (currentAssetQueue)
			{
				currentAssetQueue.removeEventListener(Event.CHANGE, currentAssetQueue_changeHandler);
			}
		}
		
		private function currentAssetQueue_changeHandler(e:Event):void 
		{
			//return;
			var totalAssetLoadPart:Number = LOADING_COMPLETE_POSITION - LOADING_ASSETS_POSITION;
			var position:Number = currentAssetQueue.progess * totalAssetLoadPart + LOADING_ASSETS_POSITION;
			//trace(' >>> ', position);
			//Starling.juggler.removeTweens(mLoadingBar);
			//Starling.juggler.tween(mLoadingBar, 0.2, { "position":position } );
			
			/*if (progressText)
			{
				progressText.text = "DON'T WORRY, THE GAME IS DOWNLOADING " + Number(currentAssetQueue.progess * 100).toFixed(2) + "%";
				progressText.redraw();
				progressText.alignPivot();
			}*/
			
			if (gameLoadTimeStart != -1)
			{
				if (getTimer() > gameLoadTimeStart + DOWNLOAD_PROGRESS_SHOW_TIME && currentAssetQueue.progess < 0.7)
				{
					//progressText.visible = true;
				}
				
				if (!warningShown)
				{
					if (getTimer() > gameLoadTimeStart + WARNING_SHOW_TIME && currentAssetQueue.progess < 0.5)
					{
						warningShown = true;
						DialogsManager.addDialog(new TransferRateWarningDialog());
					}
				}
			}
			
			preloaderPosition = position;
		}
		
		public function set preloaderPosition(value:Number):void {
			preloaderLoadedValue = Math.max(preloaderLoadedValue, value);
			//return;
			if(progressBar)
				progressBar.progress = preloaderLoadedValue;
		}
		
		public function get preloaderPosition():Number {
			return preloaderLoadedValue;
		}
		
		override public function onBackButtonPressed():void
		{
			//NativeApplication.nativeApplication.exit();
		}
		
		public function hideLoadingBar():void
		{
			removeEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
			
			Starling.juggler.removeTweens(backgroundImage);
			//backgroundImage.alpha = 0;
			
			if (alisaLogoImage) {
				Starling.juggler.removeTweens(alisaLogoImage);
				alisaLogoImage.alpha = 1; 
			}
			
			if (progressBar) {
				Starling.juggler.removeTweens(progressBar);
				progressBar.alpha = 0;
			}
		}
		
		public function showFacebookLoginBlock():void 
		{
			if (!contentShown)
			{
				needToShowFacebookLoginBlock = true;
				return;
			}
			
			needToShowFacebookLoginBlock = false;
			showingFBLoginBlock = true;
			
			//Starling.juggler.removeTweens(progressBar);
			//progressBar.visible = false;
			Starling.juggler.removeTweens(connectToFacebookButton);
			connectToFacebookButton.visible = true;
			connectToFacebookButton.alpha = 1;
			Starling.juggler.removeTweens(connectToFacebookLaterButton);
			connectToFacebookLaterButton.visible = true;
			connectToFacebookLaterButton.alpha = 1;
			resize();
			
			startProgressShowTime = 0;
			progressHintText.text = '';
		}
		
		public function hideFacebookLoginBlock():void 
		{
			var complexScale:Number = layoutHelper.independentScaleFromEtalonMin * pxScale;
			
			gameLoadTimeStart = getTimer();
			
			if (!contentShown)
				return;
				
			if (!showingFBLoginBlock)
			{
				return;
			}
			
			tweenHorisontalHide(connectToFacebookButton);
			tweenHorisontalHide(connectToFacebookLaterButton, 0.13);
			
			showProgress();
		}
		
		public function showProgress():void 
		{
			sosTrace(id + ' LoadingScreen >>> showProgress ');
			if (!contentShown || progressShown)
				return;
			
			progressShown = true;
			
			progressBar.visible = true;
			Starling.juggler.tween(progressBar, 0.5, {delay:0.45, alpha:1, transition:Transitions.LINEAR});
			
			startProgressShowTime = getTimer();
			lastChangeHintTime = getTimer();
		}
		
		private function tweenHorisontalHide(displayObject:DisplayObject, delay:Number = 0):void {
			var complexScale:Number = layoutHelper.independentScaleFromEtalonMin * pxScale;
			Starling.juggler.tween(displayObject, 0.5, { x:(displayObject.x + 180 * complexScale), delay:delay, transition:Transitions.EASE_IN_BACK});
			Starling.juggler.tween(displayObject, 0.2, { alpha:0, delay:(delay + 0.3), transition:Transitions.LINEAR});
		}
		
		public function showContents(forMaintenance:Boolean = false, place:String = 'none'):void
		{
			sosTrace(id + ' LoadingScreen >>> showContents');
			
			if (gameManager.deactivated)
			{
				maintenanceMode = forMaintenance;
				Game.addEventListener(Game.ACTIVATED, game_activatedHandler);
				return;
			}
			
			if (!stage)
				return;
			
			contentShown = true;
			
			removeChildren();
			addChild(dialogsLayer);
			
			blackFillBackground = new Quad(1, 1, 0x000000);
			addChild(blackFillBackground);
			
			/*splashBg = new Image(AtlasAsset.LoadingAtlas.getTexture("splash_screen"));
			splashBg.alpha = 0;
			addChild(splashBg);*/
			
			if (forMaintenance)
			{
				resize();
				return;
			}
			
			//createStarsBackground(400, 0.13);
			
			if(leftTopTouchQuad)
				addChild(leftTopTouchQuad);
			
				
			bg = new Image(AtlasAsset.LoadingAtlas.getTexture('start_bg'));
			addChild(bg);	
				
			logoGlow = new Image(AtlasAsset.getEmptyTexture());
			logoGlow.scale = 2;
			logoGlow.alpha = 0;
			logoGlow.touchable = false;
			addChild(logoGlow);
			
			alisaLogoImage = new Image(AtlasAsset.LoadingAtlas.getTexture("logo_full"));
			alisaLogoImage.alpha = 0;
			alisaLogoImage.addEventListener(TouchEvent.TOUCH, onLogoTouch);	
			addChild(alisaLogoImage);
			addChild(logoGlow);
			
			progressBar = new NewProgressBar();
			progressBar.alpha = 0;
			addChild(progressBar);
			
			
			var colors:Array = ['827C81', 'FEA6D3', 'FFFFFF', '7ABAD9', 'DE2C00', '8D6FB2', '589887'];
			var color1:String = colors.splice(Math.floor(Math.random() * colors.length), 1);
			var color2:String = colors.splice(Math.floor(Math.random() * colors.length), 1);
			logoText = new XTextField(400, 80, XTextFieldStyle.getChateaudeGarage(48, 0x00d3ff));
			logoText.isHtmlText = true;
			logoText.text = '<font color="#' + color1 + '">STREET</font> <font color="' + color2 +  '">CATS</font>';
			addChild(logoText);
			
			progressHintText = new XTextField(1, 1, XTextFieldStyle.getChateaudeGarage(24, 0x00d3ff));
			progressHintText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			progressHintText.visible = false;
			addChild(progressHintText);
			
			connectToFacebookLaterButton = createLaterButton();
			connectToFacebookLaterButton.addEventListener(Event.TRIGGERED, connectLaterButton_triggeredHandler);
			connectToFacebookLaterButton.visible = false;
			addChild(connectToFacebookLaterButton);
			
			connectToFacebookButton = new XButton(XButtonStyle.LoadScreenFacebookConnect, 'CONNECT!');
			connectToFacebookButton.alignPivot();
			connectToFacebookButton.addEventListener(Event.TRIGGERED, connectToFacebookButton_triggeredHandler);
			connectToFacebookButton.visible = false;
			addChild(connectToFacebookButton);
			
			addChild(preloaderFadeContainer);
			
			resize();
			
			//GameScreen.debugShowTextField(' 4 loading screen showFacebookLoginBlock ' + place + needToShowFacebookLoginBlock.toString(), true);
			
			if (needToShowFacebookLoginBlock)
			{
				showFacebookLoginBlock();
			}
						
			addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
			
			if (Constants.isLocalBuild) {
				Starling.juggler.delayCall(Game.dispatchEventWith, 0.1, Game.FACEBOOK_LOGIN_CANCELLED);
			}
		}
		
		public function tweenHide(tweenHideCompleteFunction:Function, time:Number = 0.5):void 
		{
			sosTrace(id + ' LoadingScreen >>> tweenHide', blackFillBackground, logoGlow, contentShown, this.tweenHideCompleteFunction);
			
			//return;
			if (this.tweenHideCompleteFunction != null)
				return;
			
			this.tweenHideCompleteFunction = tweenHideCompleteFunction;
			
			if (!contentShown) {
				completeHide();
				return;
			}	
			
			//return;
			
			Starling.juggler.tween(blackFillBackground, time, { "alpha":0} );
			//Starling.juggler.tween(splashBg, time, { "alpha":0} );
			
			Starling.juggler.tween(logoGlow, time, { "alpha":0} );
			Starling.juggler.tween(alisaLogoImage, time, { y:-alisaLogoImage.height - 50*pxScale, transition:Transitions.EASE_IN_BACK, onUpdate:alignLogoImages} );
			
			//Starling.juggler.tween(progressBar, time, { y:gameManager.layoutHelper.stageHeight + 40 * pxScale, transition:Transitions.EASE_IN_BACK});
			Starling.juggler.tween(progressBar, time, { alpha:0, transition:Transitions.LINEAR});
			Starling.juggler.tween(progressHintText, time, { alpha:0});
			
			Starling.juggler.delayCall(completeHide, time);
		}
		
		private function completeHide():void 
		{
			hideComplete = true;
			
			if (tweenHideCompleteFunction != null)
				tweenHideCompleteFunction();
			
			removeEventListener(Event.ENTER_FRAME, handler_starsBgEnterFrame);
			
			Preloader.removeStatusPixels();
		}
		
		private function alignLogoImages():void 
		{
			var viewScale:Number = gameManager.layoutHelper.independentScaleFromEtalonMin;
			
			logoGlow.x = alisaLogoImage.x - 126 * pxScale * viewScale;
			logoGlow.y = alisaLogoImage.y - 80 * pxScale * viewScale;
			
			logoText.x = alisaLogoImage.x + (alisaLogoImage.width - logoText.width)/2;
			logoText.y = alisaLogoImage.y + 215 /** layoutHelper.specialScale*/;
		}
		
		override public function get requiredAssets():Array
		{
			return [];
		}
		
		public function getAssetsForDisplay():Array
		{
			return [AtlasAsset.LoadingAtlas];
		}
		
		private function changeHintText():void 
		{
			if (!hintsPool || hintsPool.length == 0)
				updateHintsPool();
				
			if (progressHintText) {
				lastChangeHintTime = getTimer();
				progressHintText.text = hintsPool.shift();
				progressHintText.x = (layoutHelper.stageWidth - progressHintText.width) / 2;
			}
		}
		
		private function game_activatedHandler(e:Event):void 
		{
			//GameScreen.debugShowTextField('game_activatedHandler', true);
			Game.removeEventListener(Game.ACTIVATED, game_activatedHandler);
			showContents(maintenanceMode);
		}
		
		public function showMaintenanceDialog():void
		{
			//GameScreen.debugShowTextField('showMaintenanceDialog', true);
			showContents(true);
			
			preloaderFadeContainer.touchable = false;
			Starling.juggler.tween(preloaderFadeContainer, 0.6, { "alpha":0, transition:Transitions.EASE_IN} );
			
			//Starling.juggler.tween(splashBg, 0.5, { "alpha":1} );
			
			new ShowNoConnectionDialog(null, null, ReconnectDialog.TYPE_RECONNECT, Settings.instance.maintenanceTitle, Settings.instance.maintenanceText).execute();
		}
		
		private function connectLaterButton_triggeredHandler(e:Event):void 
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			Game.dispatchEventWith(Game.FACEBOOK_LOGIN_CANCELLED);
		}
		
		private function connectToFacebookButton_triggeredHandler(e:Event):void 
		{
			PlatformServices.facebookManager.openSession();
		}
		
		private function createLaterButton():Button
		{
			var button:Button = new Button();
			button.useHandCursor = true;
			button.scaleWhenDown = 0.95;
			
			var buttonSkin:Sprite = new Sprite();
			
			var quadTouchArea:Quad = new Quad(240 * pxScale, 180*pxScale, 0xB800B8);
			quadTouchArea.alpha = 0.0;
			buttonSkin.addChild(quadTouchArea);
			
			var quad:Quad = new Quad(94 * pxScale, 2.5*pxScale, 0xB8B8B8);
			buttonSkin.addChild(quad);
			
			var textField:XTextField = new XTextField(200 * pxScale, 60 * pxScale, XTextFieldStyle.getWalrus(29, 0xB8B8B8), "LATER");
			//textField.alpha = 0.7;
			textField.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			textField.redraw();
			//textField.x = (quad.width - textField.width) / 2;
			buttonSkin.addChild(textField);
			
			if (!gameManager.deactivated) {
				textField.x = (quadTouchArea.width - textField.textBounds.width)/2;
				textField.y = (quadTouchArea.height - textField.textBounds.height) / 2;
			}
			
			quad.x = textField.x + 4*pxScale;
			quad.y = textField.y + 28*pxScale;
			
			button.defaultSkin = buttonSkin;
			button.validate();
			button.alignPivot();
			return button;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
        {
			var displayObject:DisplayObject = super.addChildAt(child, index);
			
			if (dialogsLayer && dialogsLayer.parent == this && (getChildIndex(dialogsLayer) != numChildren - 1))
			{
				
				setChildIndex(dialogsLayer, numChildren);
			}
				
			return displayObject;
		}
		
		private function createStarsBackground(quantity:uint, starsVelocity:Number = 0.4):void
		{
			this.starsVelocity = starsVelocity;
			//this.starsVelocity = 2;
			//quantity = 1;
			var i:int;
			var star:StarItem;
			while (i < quantity) {
				star = new StarItem(AtlasAsset.LoadingAtlas.getTexture("misc/star_4"), 
				AtlasAsset.LoadingAtlas.getTexture("misc/star_1"),
				layoutHelper.stageWidth / 2, 
				layoutHelper.stageHeight / 2,
				layoutHelper.stageWidth,
				layoutHelper.stageHeight,
				100*pxScale,
				Math.min(layoutHelper.stageWidth, layoutHelper.stageHeight)/2);
				
				addChild(star.image);
				stars.push(star);
				i++;
			} 
			
			//contentShown = false;
			
			addEventListener(Event.ENTER_FRAME, handler_starsBgEnterFrame);
			
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, eventDispatcher_keyDownHandler);
			
			resize();
		}
		
		private function handler_starsBgEnterFrame(e:Event):void
		{
			if (startProgressShowTime > 0) {
				changeHintTimeout = (getTimer() - startProgressShowTime < 10000) ?  4000 : 3000;
				if (getTimer() - lastChangeHintTime >= changeHintTimeout) 
					changeHintText();
			}
			
			if (starsVelocityDiv < 0 && (getTimer() - lastLogoTouchTime > 1000)) {
				starsVelocityDiv = Math.min(0, starsVelocityDiv + 0.02);
			}
			
			starsPosition += starsVelocity + starsVelocityDiv;
			for (var i:int=0; i<stars.length; i++) 
			{
				stars[i].progress = starsPosition;
			} 
		}
		
		private function eventDispatcher_keyDownHandler(e:KeyboardEvent):void 
		{
			
			if (e.keyCode == Keyboard.Q)
			{
				starsVelocity += 0.1;
			}
			
			if (e.keyCode == Keyboard.A)
			{
				starsVelocity -= 0.1;
			}
			
			var i:int=0;
			
			if (e.keyCode == Keyboard.LEFT)
			{
				for (i=0; i<stars.length; i++) 
				{
					stars[i].tween(-4, 0);
				} 
			}
			
			if (e.keyCode == Keyboard.RIGHT)
			{
				for (i=0; i<stars.length; i++) 
				{
					stars[i].tween(4, 0);
				} 
			}
			
			if (e.keyCode == Keyboard.UP)
			{
				for (i=0; i<stars.length; i++) 
				{
					stars[i].tween(0, 4);
				} 
			}
			
			if (e.keyCode == Keyboard.DOWN)
			{
				for (i=0; i<stars.length; i++) 
				{
					stars[i].tween(0, -4);
				} 
			}
		}	
		
		private function onLogoTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(alisaLogoImage);
			if (touch == null)
				return;
	
			if (touch.phase == TouchPhase.BEGAN) 
			{
				starsVelocityDiv -= 0.02;
				lastLogoTouchTime = getTimer();
			}
		}
		
		private function onLeftTopTouchQuadTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(leftTopTouchQuad);
			if (touch == null)
				return;
	
			if (touch.phase == TouchPhase.BEGAN) 
			{
				if (getTimer() - leftTopTouchQuadLastTouchTime < 400) 
				{
					leftTopTouchQuadFastTouchCount++;
					if (leftTopTouchQuadFastTouchCount >= 7) {
						leftTopTouchQuadFastTouchCount = 0;
						new SendLog('log_loader_' + SaveHTMLLog.getDateString(false) + '_' + Player.playerId(''), SaveHTMLLog.getHTMLString()).execute();
					}
				}
				
				leftTopTouchQuadLastTouchTime = getTimer();
			}
		}
		
		private function updateHintsPool():void 
		{
			if (!hintsPool)
				hintsPool = new Vector.<String>;
				
			var source:Vector.<String> = Constants.PRELOADER_HINTS.slice(0, Constants.PRELOADER_HINTS.length);
			
			while (source.length > 0) {
				hintsPool.push(source.splice(Math.floor(Math.random()*source.length), 1));
			}
		}
	}

}
import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.assets.Fonts;
import com.alisacasino.bingo.utils.DevUtils;
import com.alisacasino.bingo.utils.EffectsManager;
import flash.geom.Rectangle;
import flash.utils.getTimer;
import flash.utils.setInterval;
import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.text.TextFormat;

final class NewProgressBar extends Sprite 
{
	private var backgroundImage:Image;
	private var progressImage:Image;
	private var progressHeadImage:Image;
	
	private var _progress:Number = 0.0001;
	
	public function NewProgressBar() 
	{
		backgroundImage = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/progress_bg"));
		backgroundImage.scale9Grid = new Rectangle(20*pxScale, 0, 2*pxScale, 0);
		backgroundImage.width = 974*pxScale;
		addChild(backgroundImage);
			
		progressImage = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/progress_line"));
		progressImage.scale9Grid = new Rectangle(465*pxScale, 0, 1*pxScale, 0);
		//progressImage.width = 700*pxScale;
		progressImage.x = 10*pxScale;
		progressImage.y = 6*pxScale;
		addChild(progressImage);
		
		progressHeadImage = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/progress_ball"));
		progressHeadImage.alignPivot();
		progressHeadImage.scaleX = 0.7;
		progressHeadImage.y = backgroundImage.height/2;
		addChild(progressHeadImage);
		
		progress = 0;
		
		
		//EffectsManager.jump(progressHeadImage, -1, 1, 1.5, 0.05, 0.05, 1,
		//EffectsManager.jump(progressHeadImage, 1000, 1, 1.3, 0.12, 0.12, 1.3, 1, 0, 1.8, true);	
		//EffectsManager.jump(progressImage, 1000, 1, 1, 0.12, 0.12, 1.3, 1, 0, 1.8, true);	
		//setInterval(function():void {var ss:Number = DevUtils.getNextValue('11', [1, 0, 0.1, 0.5, 0.95]); progress = ss; trace(ss) },  3000);
	}
	
	override public function set width(value:Number):void {
		backgroundImage.width = value;
	}
	
	override public function get width():Number {
		return backgroundImage.width;
	}
	
	public function set progress(value:Number):void {
		if (_progress == value)
			return;
		
		//trace('> ', getTimer());	
			
		Starling.juggler.removeTweens(progressImage);	
			
		var oldValue:Number = _progress; 
		_progress = Math.max(0, Math.min(1, value));	
		var div:Number = Math.abs(_progress - oldValue);
		
		Starling.juggler.tween(progressImage, div*2, {width:(_progress * (backgroundImage.width - 20*pxScale)), transition:Transitions.EASE_OUT, onUpdate:progressUpdate});
	}
	
	public function get progress():Number {
		return _progress;
	}
	
	private function progressUpdate():void {
		progressHeadImage.x = progressImage.x + progressImage.width;
	}
}

