package com.alisacasino.bingo.dialogs
{
	import by.blooddy.crypto.Base64;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.ShowTournamentEndAndReload;
	import com.alisacasino.bingo.commands.dialogCommands.ChestTakeOutCommand;
	import com.alisacasino.bingo.commands.dialogCommands.ShowNoConnectionDialog;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.components.NativeStageRedErrorPlate;
	import com.alisacasino.bingo.controls.BallsBar;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.controls.Minimap;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.chests.ChestTakeOutDialog;
	import com.alisacasino.bingo.dialogs.slots.SlotsDialog;
	import com.alisacasino.bingo.logging.SaveHTMLLog;
	import com.alisacasino.bingo.logging.SendLog;
	import com.alisacasino.bingo.models.Card;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.TutorialManager;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.gifts.GiftsModel;
	import com.alisacasino.bingo.models.offers.OfferItem;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.powerups.PowerupModel;
	import com.alisacasino.bingo.models.quests.QuestModel;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.gameScreenClasses.InfoDisplay;
	import com.alisacasino.bingo.screens.gameScreenClasses.ScreenCatScooter;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.CashBonusProgress;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.ChestsView;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.LobbyUI;
	import com.alisacasino.bingo.screens.questsScreenClasses.QuestsScreen;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.FacebookData;
	import com.alisacasino.bingo.utils.FriendsManager;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.ScreenRatioHelper;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.StringUtils;
	import com.alisacasino.bingo.utils.keyboard.KeyboardController;
	import com.alisacasino.bingo.utils.layoutHelperClasses.LayoutHelper;
	import com.alisacasino.bingo.utils.sharedObjects.SharedObjectManager;
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PickerList;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Slider;
	import feathers.controls.TextInput;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.Direction;
	import feathers.skins.ImageSkin;
	import feathers.text.BitmapFontTextFormat;
	import feathers.core.ITextRenderer;
	import feathers.text.FontStylesSet;
	import flash.desktop.NativeApplication;
	import flash.display.Stage3D;
	import flash.display.StageDisplayState;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import feathers.controls.renderers.DefaultListItemRenderer;

	import starling.textures.Texture;
	
	import starling.display.Image;
	
	public class ServiceDialog extends BaseDialog
	{
		static public var DEBUG_PAYMENTS:Boolean = false;
		
		public function ServiceDialog()
		{
			super(DialogProperties.SERVICE_DIALOG);
			gameScreen = Game.current.currentScreen as GameScreen;
			objectsById = {};
			
			alignsTypes = [LayoutHelper.ALIGNING_TYPE_AUTO, LayoutHelper.ALIGNING_TYPE_MOBILE, LayoutHelper.ALIGNING_TYPE_TABLET];
		}
		
		private var scrollContainer:ScrollContainer;
		
		private var container:Sprite;
		
		private var buttonCallbacksDictionary:Dictionary;
		
		private var buttonColorIndex:int;
		
		private var gameScreen:GameScreen;
		
		private var objectsById:Object;
		
		private var buttonColors:Array = [330870,9578819,1984337,4052457,7953259,5542953,2947838,6506222,9667284,6882012,6029631,11768473,12957263,13115674,11631817,7431128,11840660,9465891,
		7541346, 10739572, 7195475, 10284260, 4671733, 7301375, 4637006, 9669616, 6357028, 13905221, 986707, 10873472, 2040207,
		44014, 9466874, 8022608, 11523063, 14985616, 7955897, 2129476, 7323293, 10636579, 3730454, 14612893, 3976943, 4327712, 11642786,
		15973863, 15791505, 4863041, 8619008, 10698731, 11631962, 2074951, 16656500, 408212, 647849, 13069060, 8208568, 5110887, 9615107,
		1593128, 13471120, 5775541, 2645567, 384221, 3026865, 15177090, 1790953, 8276972, 6805651, 9155438, 13832500, 6571711, 15209748,
		12386419, 7607419, 14343004, 2850643, 375186, 1546432, 9549672, 6182144, 3948273, 11832975, 8942018, 5699986, 10464585, 4529088,
		10665129, 10393584, 14321620, 15079973, 6254475, 891899, 1476558, 10646534, 8963500, 13279783, 5785910, 15540703, 14432032, 2752310,
		11290374, 5842376, 12700489, 7917561, 13732826, 6615351, 7461272, 15954441, 11733843]
		
		private static var alignIndex:int;
		private var alignsTypes:Array;
		
		private var levelIncreased:Boolean;
		private var ltvIncreased:Boolean;
		
		override protected function initialize():void 
		{
			super.initialize();
			scrollContainer = new ScrollContainer();
			addChild(scrollContainer);
			
			container = new Sprite();
			//container.y = 75*pxScale;
			scrollContainer.y = 75*pxScale;
			scrollContainer.addChild(container);
			addToFadeList(container);
			
			buttonCallbacksDictionary = new Dictionary();
			
			scrollContainer.clipContent = true;
			scrollContainer.snapToPages = true;
			scrollContainer.minimumPageThrowVelocity = 2;
			scrollContainer.pageThrowDuration = 0.2;
			scrollContainer.hasElasticEdges = true;
			
			// CONTENT:
			
			//7.525
			//addSoundSFXCycleDebugger(SoundAsset.SlotsDevilFreeSpinsMusic, 14.8, 0.05, 0.05);
			
			if(NativeStageRedErrorPlate.isActivated)
				addButton("Appear error plate", NativeStageRedErrorPlate.appear, [30], 10, 10, true);
			
			if(!gameManager.tutorialManager.tutorialFirstLevelPassed)
				addButton("Tutor skip first level", skipTutorFirstLevel, null, 10, 10, false, 'skipTutorFirstLevel');	
				
			if(!gameManager.tutorialManager.allStepsIsDone)
				addButton("Tutor increase round (" + Player.current.gamesCount.toString() + ")", tutorIncreaseRound, null, 10, 10, false, 'tutorIncreaseRound');	
				
			if(!gameManager.tutorialManager.allStepsIsDone)
				addButton("Tutor skip all", skipTutor, null, 10, 10, false, 'buttonSkipTutor');
				
			if(gameManager.slotsModel.tutorSpinCount <= TutorialManager.SLOT_MACHINE_TUTOR_MAX_SPIN_COUNT)
				addButton("Skip slots tutor (" + gameManager.slotsModel.tutorSpinCount.toString() + ')', slotsSkipTutor, null, 10, 10, false, 'skipSlotsTutor');	
				
			addButton('fake round 1 card', gameScreen.debugShowGame, [Math.random() > 0.5, 1, 3]); 
			addButton('fake round 2 card', gameScreen.debugShowGame, [true, 2, 0]); 
			addButton('fake round 3 card', gameScreen.debugShowGame, [true, 3, 16]); 
			addButton('fake round 4 card', gameScreen.debugShowGame, [true, 4, 7]); 
			
			addButton('show results win', gameScreen.debugShowResults, [1 + Math.round(Math.random() * 3), true]); 
			addButton('show results lose', gameScreen.debugShowResults, [1 + Math.round(Math.random() * 3), false]); 
			
			addOffersDropdownList();
			addDropdownList(container, null, 300, new ListCollection(gameManager.offerManager.debugGetActiveOffers('offer info')), callback_offerInfo, null, OfferDropdownListItemRenderer, 'offersDropdownListInfo');	
			
			//offersDropdownList.selectedIndex = -1;
			
			addButton('chest Bronze', createChest, [ChestType.BRONZE], 10, 10, false);
			addButton('chest Silver', createChest, [ChestType.SILVER], 10, 10, false);
			addButton('chest Gold', createChest, [ChestType.GOLD], 10, 10, false);
			addButton('chest Super', createChest, [ChestType.SUPER], 10, 10, false);
			//addButton('cheater chests', gameManager.chestsData.debugSetManyAwardsChests, [], 10, 10, false);
			addButton('Free Premium', openFreeChest, [], 10, 10, true);
			
			
			addDivider();
			
			addButton('show FPS', switchFPSCounter, null, 10, 10, false); 
			
			addButton('Screen Ratios', ScreenRatioHelper.toggleSwitch); 
			
			addButton('X', switchIPhoneXBackground, null, 10, 10, false); 
			
			addButton(getAligningName(alignsTypes[alignIndex]), setNextAligningType, null, 10, 10, false, 'alignButton'); 
			
			//addLabel('diagonal: ' + layoutHelper.screenDiagonalInches.toFixed(1) + ', ' +  layoutHelper.realScreenHeight.toString() + 'x' + layoutHelper.realScreenWidth.toString() + ' ' + layoutHelper.isBigAssetMode ? 'ASSET BIG' : 'ASSET SMALL');
			addLabel(layoutHelper.screenDiagonalInches.toFixed(1) + '", ' +  layoutHelper.realScreenWidth.toString() + '*' + layoutHelper.realScreenHeight.toString() + ', ASSET ' + (layoutHelper.isBigAssetMode ? 'BIG' : 'SMALL'));
			
			if (Starling.contentScaleFactor != 1)
				addLabel('Scale Factor: ' + Starling.contentScaleFactor.toFixed(1));
			
			addButton("Send log", sendLog);
			addButton("Reset player", clearProfile);
			
			addDivider();
			
			addButton('Quests', function():void{DialogsManager.addDialog(new QuestServiceDialog()); close();}, null, 10, 10, false); 
			
			addButton('coins +1000', addCoins, [1000], 10, 10, false); 
			addButton('coins -100', addCoins, [ -100], 10, 10, false); 
			addButton('coins -10', addCoins, [ -10], 10, 10, false); 
			
			addButton('dust +30', addDust, [30], 10, 10, false); 
			addButton('dust -30', addDust, [ -30], 10, 10, false); 
			
			addButton('skins all', gameManager.skinningData.debugAddRandomCustomizers, [true, true], 10, 10, false); 
			addButton('skins random', gameManager.skinningData.debugAddRandomCustomizers, [false], 10, 10, false); 
			
			//addButton('snow', gameScreen.toggleSnow); 
			
			addButton('Add energy (1)', changePowerups, [1], 10, 10, false, 'addEnergy'); 
			addButton('Clear energy (' + gameManager.powerupModel.powerupsTotal.toString() + ')', changePowerups, [-gameManager.powerupModel.powerupsTotal], 10, 10, false, 'clearEnergy');
			
			addButton('Add daub hints (1)', changeDaubHints, [1], 10, 10, false, 'addDoubHints'); 
			addButton('Clear daub hints (' + gameManager.gameHintsManager.purchasedDaubHint.toString() + ')', changeDaubHints, [int.MIN_VALUE], 10, 10, false, 'clearDaubHints');
			
			//addButton('Debug PowerUps status: ' + PowerupModel.DEBUG.toString(), enableDebugGamePowerUps, [], 10, 10, false, 'debugPowerUps'); 
			
			//addButton("Give out random chest", giveOutRandomChest);
			
			addButton('payments: ' + (DEBUG_PAYMENTS ? 'Debug' : 'Real'), switchDebugPayments, null, 10, 10, false, 'debugPaymentsButton'); 
			
			//addButton('Chests debug', showDebugChestsInfo, [], 10, 10, true); 	 
			
			if(Constants.isLocalBuild)
				addButton('Switch mute sound', SoundManager.instance.switchMuteSoundOnLocal, null); 
			
			addButton("Add debug friends", addDebugFriends, null, 10, 10, false);
			
			addButton("Add 1 gift", addDebugGifts, [1], 10, 10, false);
			//addButton("Add gifts 3", addDebugGifts, [3], 10, 10, false);
			addLabel("gifts timeout: " + StringUtils.formatTime(gameManager.giftsModel.timeToWaitForNextGift/1000, "{1}:{2}:{3}", true, true, true)); 
			
			addButton('Add level (' + gameManager.gameData.getLevelForXp(Player.current.xpCount).toString() + ')', increaseLevel, null, 10, 10, false, 'addLevelButton');
			addButton('Add ltv (' + Player.current.lifetimeValue.toString() + ')', increaseLtv, null, 10, 10, false, 'addLtvButton');
			
			//addButton('Tour End', KeyboardController.debugShowTournamentResultDialog);
			
			addButton('free spins enabled: ' + String(!gameManager.slotsModel.debugDisableFreeSpins), toggleEnableSlotMachineFreeSpins, null, 10, 10, false, 'slotMachineFreeSpinsButton');
			addButton("slots add zero stake", gameManager.slotsModel.addDebugZeroStake, null, 10, 10, false);
			
			addButton("Dauber constructor", DialogsManager.addDialog, [new DauberParticlesServiceDialog(), true]);
			
			addButton('Color Quest', function():void{QuestsScreen.DEBUG_COLORIZE_QUESTS = true});
			
			addDivider();
		
			//addLabel('Player game count ' + Player.current.gamesCount.toString());
			
			//addSlider('main', 430*pxScale, 0, 100, 1, callback_volumeSoundTrack, null, 'sliderMain');
			//addSlider('voice', 430*pxScale, 0, 100,  1, callback_volumeVoiceover, null, 'sliderVoice', callback_thumbReleaseVoiceover);
			//addSlider('sounds', 430 * pxScale, 0, 100,  1, callback_volumeSounds, null, 'sliderSounds', callback_thumbReleaseSounds);
			//refreshVolumeSliders();
			
			
			/*addSlider('strips tween time', 430 * pxScale, 0.1, 1, 0.05, callback_stripsTweenTime, null, 'stripsTweenTime');
			addSlider('cat scooter scale', 430 * pxScale, 0.6, 1, 0.025, callback_catScooterScale, null, 'catScooterScale');
			refreshStripsTweenTime();*/
			
			//addButton("delay remove all dialogs 60 sec", setTimeout, [function():void{ DialogsManager.closeAll(); }, 60000], 10, 10, false);
			
			//addButton('SHOW RECONNECT', delayShowReconnect, [3000]); 	 
			
			//addButton('INIT RECONNECT', Starling.juggler.delayCall, [debugOnClosedConnection, 7]); 	 
			
			
		
			var scaleSettingsString:String = ', viewPort:' + Starling.current.viewPort.width.toString() + '/' + Starling.current.viewPort.height.toString();
			scaleSettingsString += ', backBuffer: ' + Starling.current.painter.backBufferWidth + '/' + Starling.current.painter.backBufferHeight + ', backBufferScale: ' + Starling.current.painter.backBufferScaleFactor;
			
			addLabel('Scale Factor: ' + Starling.contentScaleFactor.toFixed(1) + scaleSettingsString, 13);
			
			var capabilitiesString:String = Capabilities.manufacturer + ", pixelAspectRatio: " + Capabilities.pixelAspectRatio + ", screenDPI: " + Capabilities.screenDPI.toFixed(1) + ", resXY:" + Capabilities.screenResolutionX.toString() + "/" + Capabilities.screenResolutionY.toString();
			addLabel(Capabilities.os +  ', native: ' + Starling.current.nativeStage.stageWidth.toString() + '/' + Starling.current.nativeStage.stageHeight.toString() + '. ' + capabilitiesString, 13);
			
			
			
			addDivider();
			
			
			
			
			addButton('SHOW TOURNAMENT END DIALOG', delayShowTourneyEnd, [1000], 10, 10, false); 	 
			
			addButton('SEND EMPTY CRASH LOG: ', Game.connectionManager.sendClientMessage, ['debug empty crash log'], 10, 10, false); 	 
			
			
			
			
			//addButton('CHEST 1', KeyboardController.addTestImages, [300, false]); 	 
			//addButton('CHEST 2', KeyboardController.addTestImages, [300, true]); 	 

			
			//addSlider('blur', 430 * pxScale, 0, 4, 0.1, callback_blur, null, 'sliderBlur');
			//addButton("ReconnectDialog", function():void { DialogsManager.addDialog(new ReconnectDialog(ReconnectDialog.TYPE_RECONNECT), true)});
			
			//addButton("Make error", function():void { var a:Array; a.push(1) }, null, 10, 10, false);
			
			/*var s:int = 20
			while (s-- > 0) {
				if (Math.random() > 0.1)
					addButton(Math.random().toString(), gameScreen.debugShowGame, [true, 4, 7]); 
				else 
					addLabel(Math.random().toString());
				
				if (Math.random() > 0.95)
					addDivider();
			}*/
			
			//addButton("Appear error plate", Starling.juggler.delayCall, [showErrorPlate, 1], 10, 10, false);
			
			
			
			Minimap.DEBUG_TAKE_POWERUP_BY_CLICK =  true;
			BallsBar.DEBUG_TAKE_BALL_NUMBER_BY_CLICK =  true;
			InfoDisplay.DEBUG_TAKE_ANYTHING_BY_CLICK = true;
			QuestModel.DEBUG_MODE = true;
			CashBonusProgress.DEBUG_MODE = true;
			SlotsDialog.DEBUG_MODE = true;
		
			//Starling.juggler.delayCall(starTitle.dispose, 3);
			
			//Starling.juggler.delayCall(starTitle.updateText, 6);
		}	
		
		private function clearProfile():void 
		{
			gameManager.tutorialManager.resetTutor();
			gameManager.clearPlayerID();
			gameManager.clearPasswordHash();
			gameManager.chestsData.cleanChests();
			
			if (PlatformServices.isCanvas)  
			{
				Player.current.cleanAll();
				Game.connectionManager.sendPlayerUpdateMessage();
				
				gameManager.clientDataManager.cleanAll();
				Starling.juggler.delayCall(Game.dispatchEventWith, 1.5, Game.FACEBOOK_LOGOUT_EVENT);
			}
			else {
				Game.dispatchEventWith(Game.FACEBOOK_LOGOUT_EVENT);
			}
				
			SharedObjectManager.instance.clean();
		}
		
		private function sendLog():void 
		{
			new SendLog('log_service_' + SaveHTMLLog.getDateString(false) + '_' + Player.playerId(''), SaveHTMLLog.getHTMLString()).execute();
			
			/*if (PlatformServices.isCanvas)  
			{
				
			}
			else
			{
				
			}
			
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(SaveHTMLLog.getHTMLString());
			gameManager.connectionManager.sendClientMessage(Base64.encode(ba), true);*/
		}
		
		private function giveOutRandomChest():void 
		{
			var chestData:ChestData = new ChestData(0);
			chestData.type = int(Math.random() * 4 + 1);
			chestData.seed = (Math.random() * (int.MAX_VALUE - 1)) + 1;
			
			new ChestTakeOutCommand(chestData).execute();
		}
		
		private function switchFPSCounter():void 
		{
			Starling.current.showStats = !Starling.current.showStats;
		}
		
		override public function resize():void
		{
			super.resize();
			
			var currentX:int = 0;
			var currentY:int = 0//75;
			var verticalGap:int = 16;
			var horisontalGap:int = 16;
			
			var i:int;
			var length:int = container.numChildren;
			var displayObject:DisplayObject;
			var view:DisplayObject;
			
			var lineViewsList:Array = [];
			var lineWidth:int;
			var lineHeight:int;
			
			var viewWidth:int;
			var viewHeight:int;
			
			for(i=0; i<length; i++)
			{
				displayObject = container.getChildAt(i) as DisplayObject;
				
				viewWidth = getViewWidth(displayObject);
				viewHeight = getViewHeight(displayObject);
				
				//trace(' hhhh ', viewWidth, viewHeight);
				if ((lineWidth + viewWidth) > (backgroundWidth - 30))
				{
					currentX += (backgroundWidth - lineWidth) / 2;
					
					if (lineViewsList.length == 1) {
						lineWidth -= horisontalGap;
						currentX = (backgroundWidth - lineWidth) / 2;
					}
						
					while (lineViewsList.length > 0) 
					{
						view = lineViewsList.shift();
						
						view.y = currentY + (lineHeight - getViewHeight(view))/2;
						view.x = currentX;
						currentX = view.x + getViewWidth(view) + horisontalGap;
					}
					
					currentX = 0;
					currentY += lineHeight + verticalGap;
					
					lineWidth = viewWidth + horisontalGap; 
					lineHeight = viewHeight;
					lineViewsList.push(displayObject);
				}
				else
				{
					lineWidth += viewWidth + horisontalGap; 
					lineHeight = Math.max(lineHeight, viewHeight);
					
					lineViewsList.push(displayObject);
				}
			}
			
			currentX += (backgroundWidth - lineWidth) / 2;
			while (lineViewsList.length > 0) 
			{
				view = lineViewsList.shift();
				view.y = currentY + (lineHeight - getViewHeight(view))/2;
				//view.x = (backgroundWidth - getViewWidth(displayObject)) / 2;
				view.x = currentX;
				currentX = view.x + getViewWidth(view) + horisontalGap;
				
				lineWidth -= horisontalGap;
			}
			
			scrollContainer.height = (this.height - gameUILayoutScale*10)/gameUILayoutScale - scrollContainer.y;
			//scrollContainer.height = this.height - pxScale*10 - scrollContainer.y;
		}	
		
		override public function get baseScale():Number
		{
			return layoutHelper.independentScaleFromEtalonMin;
		}
		
		private function addDivider():void 
		{
			var quad:Quad = new Quad(1, 1);
			quad.width = backgroundWidth - 50*pxScale;
			container.addChild(quad);
		}
		
		private function addButton(label:String, callback:Function, callbackParams:Array = null, paddingHorisontal:uint = 10, paddingVertical:uint = 10, close:Boolean=true, id:String = null):void 
		{
			var button:Button = new Button();
			button.useHandCursor = true;
			button.addEventListener(Event.TRIGGERED, callback_button);
			button.label = label;
			button.labelFactory = labelTextFactory;
			button.defaultSkin = new Image(Texture.fromColor(50*pxScale, 20*pxScale, buttonColors[buttonColorIndex++]));
			
			button.paddingLeft = paddingHorisontal*pxScale;
			button.paddingRight = paddingHorisontal*pxScale;
			button.paddingTop = paddingVertical*pxScale;
			button.paddingBottom = paddingVertical*pxScale;
			container.addChild(button);
			
			button.validate();
			
			if(!callbackParams)
				callbackParams = [];
				
			callbackParams.unshift(close);
			callbackParams.unshift(callback);
			buttonCallbacksDictionary[button] = callbackParams;
			
			if(id)
				objectsById[id] = button;
		}
		
		private function callback_button(event:Event):void
		{
			var params:Array = buttonCallbacksDictionary[event.target];
			var callback:Function = params[0] as Function;
			if (params[1])
				removeDialog();
			callback.apply(null, params.slice(2, params.length));
		}
		
		private function addLabel(text:String, paddingHorisontal:uint = 10, paddingVertical:uint = 10, size:int = 16):void 
		{
			var label:Label = new Label();
			label.textRendererFactory = function ():TextFieldTextRenderer
			{
				var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				textRenderer.textFormat = new TextFormat(Fonts.CHATEAU_DE_GARAGE, size*pxScale, 0xffffff );
				textRenderer.embedFonts = true;
				return textRenderer;
			}
			
			label.text = text;
			label.paddingLeft = paddingHorisontal*pxScale;
			label.paddingRight = paddingHorisontal*pxScale;
			label.paddingTop = paddingVertical*pxScale;
			label.paddingBottom = paddingVertical*pxScale;
			label.validate();
			//label.backgroundSkin = new Quad(getViewWidth(label), getViewHeight(label), 0xFF0000);
			container.addChild(label);
		}
		
		private function labelTextFactory():ITextRenderer
		{
			 var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
			textRenderer.textFormat = new TextFormat(Fonts.CHATEAU_DE_GARAGE, 16*pxScale, 0xffffff );
			textRenderer.embedFonts = true;
			return textRenderer;
		}
		
		private function getViewWidth(displayObject:DisplayObject):Number
		{
			//if ('paddingRight' in displayObject && 'paddingLeft' in displayObject)
				//return displayObject.width + displayObject['paddingRight'] + displayObject['paddingLeft']
			
			return displayObject.width;	
		}
		
		private function getViewHeight(displayObject:DisplayObject):Number
		{
			//if ('paddingTop' in displayObject && 'paddingBottom' in displayObject)
				//return displayObject.height + displayObject['paddingTop'] + displayObject['paddingBottom']
			
			return displayObject.height;	
		}
		
		private function addSlider(text:String, sliderWidth:int, min:Number, max:Number, step:Number, callback:Function = null, callbackParams:Array = null, id:String = null, thumbCallback:Function = null):void 
		{
			var color:uint = buttonColors[buttonColorIndex++];
			
			var sliderContainer:Sprite = new Sprite();
			//sliderContainer.name = id;
			container.addChild(sliderContainer);
			
			var label:Label = new Label();
			label.textRendererFactory = labelTextFactory;
			
			label.text = text;
			label.name = text;
			label.validate();
			label.y = 3*pxScale;
			sliderContainer.addChild(label);
			
			var slider:Slider = new Slider();
			slider.x = label.width + 37*pxScale;
			slider.minimum = min;
			slider.maximum = max;
			slider.value = (max - min)/2;
			slider.step = step;
			slider.direction = Direction.HORIZONTAL;

			slider.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(30 * pxScale, 30 * pxScale , color);
				thumb.addEventListener(Event.TRIGGERED, function(e:Event):void { if(thumbCallback != null) thumbCallback() });
				return thumb;
			};
			
			slider.minimumTrackFactory  = function():BasicButton
			{
				var track:BasicButton = new BasicButton();
				track.defaultSkin = new Quad(sliderWidth, 5*pxScale , color);
				return track;
			};
			
			slider.addEventListener(Event.CHANGE, function slider_changeHandler1( event:Event ):void
			{
				label.text = label.name + ' ' + slider.value.toFixed(2);
				callback.apply(null, (callbackParams || []).concat(slider.value));
			});
			
			slider.validate();
			sliderContainer.addChild(slider);
			
			
			if(id)
				objectsById[id] = sliderContainer;
		}
		
		private function setSliderByContainer(sliderContainer:Sprite, value:Number):void
		{
			if (!sliderContainer)
				return;
			(sliderContainer.getChildAt(0) as Label).text = (sliderContainer.getChildAt(0) as Label).name + " " + value.toFixed(2);
			(sliderContainer.getChildAt(1) as Slider).value = value;
		}	
		
		override public function close():void
		{
			super.close();
			new UpdateLobbyBarsTrueValue(0.5).execute();
			
			if (levelIncreased && Game.current.gameScreen.state != GameScreen.STATE_IN_GAME)
				Game.current.gameScreen.debugReCreateLobbyUI();
				
			if (levelIncreased || ltvIncreased) {
				//Starling.juggler.delayCall(gameManager.offerManager.refresh, 0.8);
			}
			
			if(soundCycleDebuggerSound)
				SoundManager.instance.stopSfxLoop(soundCycleDebuggerSound, 0);
		}	
		
		/*********************************************************************************************************************
		*
		* Dropdown list
		* 
		*********************************************************************************************************************/		
		 
		private function addDropdownList(controlContainer:DisplayObjectContainer, text:String, viewWidth:int, itemsList:ListCollection, callback:Function = null, callbackParams:Array = null, rendererClass:Class = null, id:String = null):PickerList 
		{
			var color:uint = buttonColors[buttonColorIndex++];
			
			var contentContainer:DropDownListContainer = new DropDownListContainer();
			//sliderContainer.name = id;
			controlContainer.addChild(contentContainer);
			
			if (text)
			{
				contentContainer.label = new Label();
				contentContainer.label.textRendererFactory = function labelTextFactory():ITextRenderer {
					var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
					textRenderer.textFormat = new flash.text.TextFormat(Fonts.CHATEAU_DE_GARAGE, 12*pxScale, 0xffffff);
					textRenderer.embedFonts = true;
					textRenderer.text = '-';
					return textRenderer;
				}
				contentContainer.label.width = viewWidth;
				contentContainer.label.text = text;
				contentContainer.label.name = text;
				contentContainer.label.validate();
				contentContainer.label.y = 3*pxScale;
				contentContainer.addChild(contentContainer.label);
			}
			
			contentContainer.pickerList = new PickerList();
			contentContainer.pickerList.y = contentContainer.label ? (contentContainer.label.height + 3 * pxScale) : 0;
			contentContainer.pickerList.dataProvider = itemsList;
			//pickerList.maximum = max;
			//pickerList.value = (max - min)/2;
			//numericStepper.step = step;
			
			/*pickerList. itemRendererFactory = function():IListItemRenderer
			{
				var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				itemRenderer.labelField = "text";
				return itemRenderer;
			}*/
			
			//contentContainer.pickerList.buttonProperties = {title};
			contentContainer.pickerList.buttonFactory = function():Button
			{
				var button:Button = new Button();
				button.labelFactory = function labelTextFactory(...args):ITextRenderer
				{
					var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
					textRenderer.textFormat = new flash.text.TextFormat(Fonts.CHATEAU_DE_GARAGE, 12*pxScale, 0xffffff);
					textRenderer.embedFonts = true;
					return textRenderer;
				}
				button.defaultSkin = new Quad(viewWidth * pxScale, 40, color);
				button.addEventListener(Event.TRIGGERED, function(e:Event):void {  });

				return button;
			};
			
			contentContainer.pickerList.labelFunction = function( item:Object ):String
			{
				return item.text;
			}
			
			//contentContainer.pickerList.
			contentContainer.pickerList.listFactory = function():List
			{
				var popUpList:List = new List();
				popUpList.itemRendererFactory = function():IListItemRenderer
				{
					//var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
					var renderer:DefaultListItemRenderer = rendererClass ? ((new rendererClass()) as DefaultListItemRenderer) : (new DefaultListItemRenderer());
					renderer.labelField = "text";
					
					renderer.defaultSkin = new Quad(viewWidth * pxScale, 40 * pxScale , color);
					
					renderer.labelFactory = function labelTextFactory():ITextRenderer
					{
						var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
						textRenderer.textFormat = new flash.text.TextFormat(Fonts.CHATEAU_DE_GARAGE, 10*pxScale, 0x000000, null, null, null, null, null, TextFormatAlign.LEFT);
						textRenderer.embedFonts = true;
						return textRenderer;
					}
					
					//renderer.iconSourceField = "thumbnail";
					return renderer;
				};
				
				//popUpList.backgroundSkin = new Quad(100 * pxScale, 100 * pxScale , color);
				
				return popUpList;
			}
			
			//pickerList.prompt = "Select an Item";
			//list.selectedIndex = -1;
			
			contentContainer.pickerList.addEventListener(Event.CHANGE, function slider_changeHandler1( event:Event ):void
			{
				if(callback != null)
					callback.apply(null, (callbackParams || []).concat(contentContainer.pickerList.selectedItem));
			});
			
			contentContainer.pickerList.validate();
			contentContainer.addChild(contentContainer.pickerList);
			
			
			if(id)
				objectsById[id] = contentContainer;
				
			return contentContainer.pickerList;	
		}
		
			/*********************************************************************************************************************
		*
		* Numeric stepper
		* 
		*********************************************************************************************************************/		
		
		private function addNumericStepper(controlContainer:DisplayObjectContainer, text:String, min:Number, max:Number, step:Number, value:Number = NaN, textBgWidth:int = 30, callback:Function = null, callbackParams:Array = null, id:String = null):void 
		{
			var color:uint = buttonColors[buttonColorIndex++];
			
			var contentContainer:Sprite = new Sprite();
			//sliderContainer.name = id;
			controlContainer.addChild(contentContainer);
			
			var label:Label = new Label();
			label.textRendererFactory = labelTextFactory;
			label.text = text;
			label.name = text;
			label.validate();
			label.x = 0;//((80 * pxScale + textBgWidth) - label.width)/2;
			label.y = 3*pxScale;
			contentContainer.addChild(label);
			
			var numericStepper:NumericStepper = new NumericStepper();
			numericStepper.y = label.height + 5 * pxScale;
			numericStepper.minimum = min;
			numericStepper.maximum = max;
			numericStepper.value = isNaN(value) ? (max - min)/2 : value;
			numericStepper.step = step;
			
			numericStepper.textInputGap = 10;
			
			numericStepper.decrementButtonFactory = function():Button
			{
				var thumb:Button = new Button();
				thumb.defaultSkin = new Quad(30 * pxScale, 30 * pxScale , color);
				//thumb.addEventListener(Event.TRIGGERED, function(e:Event):void { if(thumbCallback != null) thumbCallback() });
				return thumb;
			};
			
			numericStepper.decrementButtonLabel = '-';
			
			numericStepper.incrementButtonFactory = function():Button
			{
				var thumb:Button = new Button();
				thumb.defaultSkin = new Quad(30 * pxScale, 30 * pxScale , color);
				//thumb.addEventListener(Event.TRIGGERED, function(e:Event):void { if(thumbCallback != null) thumbCallback() });
				return thumb;
			};
			
			numericStepper.incrementButtonLabel = '+';
			
			numericStepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				
				var fontStyle:FontStylesSet = new FontStylesSet();
				fontStyle.format = new starling.text.TextFormat(BitmapFont.MINI/*Fonts.CHATEAU_DE_GARAGE*/, 20, 0xFFFFFF);
				
				/*var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
				textRenderer.textFormat = new BitmapFontTextFormat(BitmapFont.MINI, 14);
				return textRenderer;*/
				
				
				var bg:Quad = new Quad(textBgWidth, 30, color);
				bg.alpha = 0.4;
				
				input.backgroundSkin = bg;
				input.padding = 0;
				input.textEditorProperties = {fontStyles:fontStyle};
				input.isEditable = false;
				
				return input;
			}
			
			numericStepper.addEventListener(Event.CHANGE, function hanlder_change( event:Event ):void
			{
				//label.text = label.name + ' ' + slider.value.toString();
				if (callback != null)
					callback.apply(null, (callbackParams || []).concat(numericStepper.value));
			});
			
			numericStepper.validate();
			contentContainer.addChild(numericStepper);
			
			
			//contentContainer.invalidate();
			//contentContainer.validate();
			
			//contentContainer.saveMeasurements
			
			
			if(id)
				objectsById[id] = numericStepper;
		}
		
		/*********************************************************************************************************************
		 *
		 * 
		 * 
		 *********************************************************************************************************************/		
		
		private function addCoins(value:int):void
		{
			if (Player.current.cashCount + value < 0) {
				Player.current.reservedCashCount = 0;
				Player.current.setCashCount(0, "debug");
			}
			else {
				Player.current.reservedCashCount += value;
				Player.current.updateCashCount(value, "debug");
			}
			
			Game.connectionManager.sendPlayerUpdateMessage();
			//close();
		}
		
		private function addDust(value:int):void
		{
			if (Player.current.dustCount + value < 0) {
				Player.current.reservedDustCount = 0;
				Player.current.setDustCount(0, "debug");
			}
			else {
				Player.current.reservedDustCount += value;
				Player.current.updateDustCount(value, "debug");
			}
			
			Game.connectionManager.sendPlayerUpdateMessage();
		}
		
		private function enableDebugGamePowerUps(...args):void
		{
			var button:Button = objectsById['debugPowerUps'] as Button;
			PowerupModel.DEBUG = !PowerupModel.DEBUG;
			button.label = 'Debug PowerUps status: ' + PowerupModel.DEBUG.toString();
		}
		
		
		private function changeDaubHints(value:int):void
		{
			gameManager.gameHintsManager.add(Math.max(0, value));
			
			var button:Button = objectsById['clearDaubHints'] as Button;
			button.label = 'Clear daub hints (' + gameManager.gameHintsManager.purchasedDaubHint.toString() + ')';
		}

		private function increaseLevel():void
		{
			var xpCount:int = Player.current.getXpForNextLevel();
			
			Player.current.xpCount = /*Player.current.xpCount +*/ xpCount;
			Player.current.xpLevel = gameManager.gameData.getLevelForXp(Player.current.xpCount);
			
			var xpLevel:int = gameManager.gameData.getLevelForXp(Player.current.xpCount);
			
			//Player.current.xpCount + "/" + Player.current.getXpForNextLevel()
			
			var button:Button = objectsById['addLevelButton'] as Button;
			button.label = 'Add level (' + xpLevel.toString() + ')';
			
			if (Player.current.gamesCount <= 0)
				Player.current.gamesCount = 1;
				
			Game.connectionManager.sendPlayerUpdateMessage();
			
			levelIncreased = true;
		}
		
		private function increaseLtv():void
		{
			Player.current.lifetimeValue += 5;
			
			var button:Button = objectsById['addLtvButton'] as Button;
			button.label = 'Add ltv (' + Player.current.lifetimeValue.toString() + ')';
			
			Game.connectionManager.sendPlayerUpdateMessage();
			
			ltvIncreased = true;
		}
		
		private function switchDebugPayments():void
		{
			DEBUG_PAYMENTS = !DEBUG_PAYMENTS;
			var button:Button = objectsById['debugPaymentsButton'] as Button;
			button.label = 'payments: ' + (DEBUG_PAYMENTS ? 'Debug' : 'Real');
		}
		
		private function createChest(type:int):void
		{
			/*gameManager.chestsData.debugCreateNewAwardChest(type);
			
			if (Game.current.gameScreen.lobbyUI.chestsView.state == ChestsView.STATE_LOBBY || Game.current.gameScreen.lobbyUI.chestsView.state == ChestsView.STATE_INIT) 
			{
				
			}
			else {
				Game.current.gameScreen.lobbyUI.chestsView.takeOutNewAwardChests();
			}*/
		}
		
		private function setNextAligningType():void
		{
			if (alignIndex >= (alignsTypes.length - 1))
				alignIndex = 0;
			else
				alignIndex++;
			
			var alignType:String = alignsTypes[alignIndex];
			
			var button:Button = objectsById['alignButton'] as Button;
			button.label = getAligningName(alignType);
			button.validate();
			
			layoutHelper.setAligningType(alignType);
			
			gameManager.layoutHelper.initScreen(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
			
			gameManager.skinningData.refreshLayoutType(); 
			
			if(Game.current.gameScreen.gameUI.gameCardsView)
				Game.current.gameScreen.gameUI.gameCardsView.refreshSkinTextures();
			
			resize();
			
			Game.current.callResize();
		}
		
		private function getAligningName(alignType:String):String
		{
			return 'Align: ' + (alignType == LayoutHelper.ALIGNING_TYPE_AUTO ? 'auto' : (alignType == LayoutHelper.ALIGNING_TYPE_MOBILE ? 'mobile' : 'tablet'));
		}
		
		private function refreshVolumeSliders():void
		{
			setSliderByContainer(objectsById['sliderMain'], Math.round(SoundManager.BACKGROUND_VOLUME * 100));
			setSliderByContainer(objectsById['sliderVoice'], Math.round(gameManager.skinningData.getVoiceoverVolume(gameManager.skinningData.voiceover.assetName) * 100));
			setSliderByContainer(objectsById['sliderSounds'], Math.round(SoundManager.SOUNDS_VOLUME*100));
		}
		
		private function refreshStripsTweenTime():void
		{
			setSliderByContainer(objectsById['stripsTweenTime'], ScreenCatScooter.stripsTweenTime);
			
			setSliderByContainer(objectsById['catScooterScale'], ScreenCatScooter.catScooterScale);
		}
		
		private function callback_stripsTweenTime(value:Number):void
		{
			ScreenCatScooter.stripsTweenTime = value;
		}
		
		private function callback_catScooterScale(value:Number):void
		{
			ScreenCatScooter.catScooterScale = value;
		}
		
		private function callback_volumeSoundTrack(value:int):void
		{
			SoundManager.instance.setSoundtrackVolume(value / 100, 1);
		}
		
		private function callback_volumeVoiceover(value:int):void
		{
			gameManager.skinningData.voiceoversVolume[gameManager.skinningData.voiceover.assetName] = value / 100;
			//SoundManager.instance.playBallNumber(Math.max(1, int(Math.random() * 75)));
		}
		
		private function callback_volumeSounds(value:int):void
		{
			SoundManager.SOUNDS_VOLUME = value / 100;
			//SoundManager.instance.playSfx( SoundAsset.sfxAssets[Math.floor(Math.random()*SoundAsset.sfxAssets.length-1)]);
		}
		
		private function callback_thumbReleaseVoiceover():void
		{
			SoundManager.instance.playBallNumber(Math.max(1, int(Math.random() * 75)));
		}
		
		private function callback_thumbReleaseSounds():void
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick);
		}
		
		private function callback_blur(value:int):void
		{
			if(Game.current.gameScreen)
				Game.current.gameScreen.setBackgroundBlur(value, 3);
		}
		
		
		private function addDebugFriends():void
		{
			FriendsManager.DEBUG_MODE = true;
			GiftsModel.DEBUG_MODE = true;
			FacebookData.instance.debugInjectFakeFriends(5, 3);
		}
		
		private function addDebugGifts(count:int):void
		{
			GiftsModel.DEBUG_MODE = true;
			GameManager.instance.giftsModel.debugAddGifts(count);
		}
		
		private function delayShowReconnect(delay:int = 15000):void {
			
			setTimeout(function f2():void {  
				var reconnectDialog:ReconnectDialog = new ReconnectDialog(); 
				DialogsManager.addDialog(reconnectDialog); 
			}, delay );
		}
		
		private function skipTutor():void
		{
			var button:Button = objectsById['buttonSkipTutor'] as Button;
			button.removeFromParent();
			gameManager.tutorialManager.skipTutor();
			
			if (objectsById['skipTutorFirstLevel'])
				(objectsById['skipTutorFirstLevel'] as Button).removeFromParent();
					
			if (objectsById['tutorIncreaseRound'])
				(objectsById['tutorIncreaseRound'] as Button).removeFromParent();
				
			SharedObjectManager.instance.setSharedProperty(Constants.SHARED_PROPERTY_FIRST_START, true);
		}
		
		private function skipTutorFirstLevel():void
		{
			var button:Button = objectsById['skipTutorFirstLevel'] as Button;
			button.removeFromParent();
			Player.current.gamesCount = 1;
			
			gameManager.tutorialManager.skipTutorFirstLevel();
			
			if (objectsById['tutorIncreaseRound'])
				(objectsById['tutorIncreaseRound'] as Button).label = "Tutor increase round (" + Player.current.gamesCount.toString() + ")";
				
			SharedObjectManager.instance.setSharedProperty(Constants.SHARED_PROPERTY_FIRST_START, true);
			
			Game.connectionManager.sendPlayerUpdateMessage();
		}
		
		private function tutorIncreaseRound():void
		{
			var button:Button = objectsById['tutorIncreaseRound'] as Button;
			
			Player.current.gamesCount++;
			
			button.label = "Tutor increase round (" + Player.current.gamesCount.toString() + ")";
			button.validate();
			
			if (Player.current.gamesCount >= 1) 
			{
				gameManager.tutorialManager.skipTutorFirstLevel();
				
				if (objectsById['skipTutorFirstLevel'])
					(objectsById['skipTutorFirstLevel'] as Button).removeFromParent();
			}
			
			if (Player.current.gamesCount > TutorialManager.TUTORIAL_GAMES_COUNT) 
			{
				gameManager.tutorialManager.skipTutor();
				
				//button.removeFromParent();
				
				if (objectsById['buttonSkipTutor'])
					(objectsById['buttonSkipTutor'] as Button).removeFromParent();
			}
			
			SharedObjectManager.instance.setSharedProperty(Constants.SHARED_PROPERTY_FIRST_START, true);
			
			Game.connectionManager.sendPlayerUpdateMessage();
		}
		
		private function slotsSkipTutor():void
		{
			gameManager.slotsModel.skipTutor();
			
			if (objectsById['skipSlotsTutor'])
				(objectsById['skipSlotsTutor'] as Button).removeFromParent();
		}
		
		private function delayShowTourneyEnd(delay:int = 15000):void 
		{
			setTimeout(function f2():void {  
				gameManager.tournamentData.debugCreateTournamentResultToShow();
				new ShowTournamentEndAndReload().execute();
			}, delay );
		}
	
		private var powerupTypes:Vector.<String> = new <String> [Powerup.X2, Powerup.DAUB, Powerup.DOUBLE_DAUB, Powerup.TRIPLE_DAUB, Powerup.CASH, Powerup.XP, Powerup.INSTABINGO, Powerup.SCORE];
		private static var powerupIndex:int;
		
		private function changePowerups(count:int):void 
		{
			if (count >= 0) 
			{
				while (count > 0) 
				{
					if (powerupIndex >= powerupTypes.length)
						powerupIndex = 0;
					
					gameManager.powerupModel.addPowerup(powerupTypes[powerupIndex], 1, "debug");
					powerupIndex++;
					
					count--;
				}
			}
			else
			{
				while (count < 0) {
					gameManager.powerupModel.debugRemovePowerup();
					count++;
				}
			}
			
			var button:Button = objectsById['clearEnergy'] as Button;
			button.label = 'Clear energy (' + gameManager.powerupModel.powerupsTotal.toString() + ')';
			button.validate();
			
			gameManager.powerupModel.sendUpdate();
		}
		
		private function showDebugChestsInfo():void 
		{
			gameManager.chestsData.debugTraceState();
		}
		
		private function showErrorPlate():void {
			NativeStageRedErrorPlate.show(10, "TEST Error: ");
			////EffectsManager.jump(objectsById['addLevelButton'], 1000, 1, 1.3, 0.12, 0.12, 1.3, 2, 0, 1.8, true);	
		}
		
		private static var iPhoneXBackgroundIndex:int;
		private static var iPhoneXBackground:ImageLoader;
		
		public static function switchIPhoneXBackground():void
		{
			if (iPhoneXBackgroundIndex >= 2)
				iPhoneXBackgroundIndex = 0;
			else
				iPhoneXBackgroundIndex++;
			
			if (iPhoneXBackgroundIndex == 0) 
			{
				if (iPhoneXBackground) {
					iPhoneXBackground.removeFromParent(false);
				}
				
				if(Game.hasEventListener(Game.STAGE_RESIZE, stageResizeHandler))
					Game.removeEventListener(Game.STAGE_RESIZE, stageResizeHandler);
			}
			else
			{
				if (!iPhoneXBackground) 
				{
					iPhoneXBackground = new ImageLoader();
					iPhoneXBackground.addEventListener("complete", handler_iPhoneXBackgroundLoaded);
					iPhoneXBackground.addEventListener(IOErrorEvent.IO_ERROR, handler_iPhoneXBackgroundLoaded);
					iPhoneXBackground.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handler_iPhoneXBackgroundLoaded);
					iPhoneXBackground.touchable = false;
					iPhoneXBackground.source  = 'https://s3.amazonaws.com/static-bingo2.alisagaming.net/assets-dev/720/images/x_background.png';
					Starling.current.stage.addChild(iPhoneXBackground);
					
					if(!Game.hasEventListener(Game.STAGE_RESIZE, stageResizeHandler))
						Game.addEventListener(Game.STAGE_RESIZE, stageResizeHandler);
				}
				else {
					Starling.current.stage.addChild(iPhoneXBackground);
					stageResizeHandler();
				}
			}
			
			Game.current.dispatchEventWith(Game.EVENT_ORIENTATION_CHANGED);
		}
		
		private static function handler_iPhoneXBackgroundLoaded(event:*):void 
		{
			if (iPhoneXBackground.isLoaded) {
				Starling.juggler.delayCall(function makeAvatarVisible():void 
					{
						stageResizeHandler();
					}, 0.017); // без задержки вернет нулевые width, height
			}		
		}
		
		private static function stageResizeHandler(e:Event = null):void 
		{
			if (iPhoneXBackground) {
				var scale:Number = layoutHelper.stageWidth / iPhoneXBackground.originalSourceWidth;
				iPhoneXBackground.scaleX = iPhoneXBackgroundIndex == 1 ? scale : -scale;
				iPhoneXBackground.scaleY = scale;
				iPhoneXBackground.x = iPhoneXBackgroundIndex == 1 ? 0 : iPhoneXBackground.width;
			}
		}
		
		public static function get isDebugIPhoneXFrame():Boolean
		{
			return iPhoneXBackground && iPhoneXBackgroundIndex > 0; 
		}
		
		public static function get isIPhoneXOrientationRight():Boolean
		{
			return iPhoneXBackgroundIndex == 1; 
		}
		
		public static function get isIPhoneXOrientationLeft():Boolean
		{
			return iPhoneXBackgroundIndex == 2; 
		}
		
		private function debugOnClosedConnection():void
		{
			if(Game.current)
				Game.current.clean();
			
			Game.current.loadGame();	
		}
		
		private function openFreeChest():void 
		{
			var chestData:ChestData = new ChestData(0);
			chestData.type = ChestType.PREMIUM;
			chestData.fillFreePremiumChest();
			new ChestTakeOutCommand(chestData, null, null, true, ChestTakeOutCommand.DEBUG).execute();
		}
		
		private function callback_offerSelect(item:Object):void 
		{
			if (!item || !item.object) {
				gameManager.offerManager.debugOffer = null;
				return;
			}
			
			if (skipSelectOfferOnce) {
				skipSelectOfferOnce = false;
				return;
			}
			
			gameManager.offerManager.refresh();
			close();
			
			gameManager.offerManager.cleanOfferClientData(item.object as OfferItem);
			
			gameManager.offerManager.showDialog(item.object as OfferItem, true, false, true, true);
			
		}
		
		public static function debugSetPlayerStartPack():void 
		{
			gameManager.tutorialManager.skipTutor();
			SharedObjectManager.instance.setSharedProperty(Constants.SHARED_PROPERTY_FIRST_START, true);
			Player.current.gamesCount = 10;
			
			Player.current.reservedCashCount += 10000;
			Player.current.updateCashCount(10000, "debug");
			
			var i:int = 10
			while (i-- < 0) 
			{
				var xpCount:int = Player.current.getXpForNextLevel();
				Player.current.xpCount = Player.current.xpCount + xpCount;
				Player.current.xpLevel = gameManager.gameData.getLevelForXp(Player.current.xpCount);
			}
			
			if (Game.current.gameScreen.state != GameScreen.STATE_IN_GAME)
				Game.current.gameScreen.debugReCreateLobbyUI();
			
			Game.connectionManager.sendPlayerUpdateMessage();
			
			new UpdateLobbyBarsTrueValue(0.1).execute();
		}
		
		private var skipSelectOfferOnce:Boolean;
		
		private function addOffersDropdownList():void 
		{
			var offersDropdownList:PickerList = addDropdownList(container, null, 300, new ListCollection(gameManager.offerManager.debugGetActiveOffers('no debug offer')), callback_offerSelect, null, OfferDropdownListItemRenderer, 'offersDropdownList');	
			
			if (!gameManager.offerManager.debugOffer)
				return;
			
			var i:int;
			var l:int = offersDropdownList.dataProvider.length;
			var object:Object;
			for (i = 0; i < l; i++) {
				object = offersDropdownList.dataProvider.getItemAt(i) as Object;
				if (object && object.object && object.object == gameManager.offerManager.debugOffer) {
					skipSelectOfferOnce = true;		
					offersDropdownList.selectedIndex = i;
					break;
				}
			}
		}
		
		private var lastSelectedOfferInfo:OfferItem;
		
		private function callback_offerInfo(item:Object):void 
		{
			if (!item || !item.object) {
				return;
			}
			
			var offer:OfferItem = item.object as OfferItem;
			lastSelectedOfferInfo = offer;
			
			var string:String = 'current offer: ' + (gameManager.offerManager.currentOffer ? (gameManager.offerManager.currentOffer.id + ', ' + gameManager.offerManager.currentOffer.title) : 'no');
			string += '\n\n' + gameManager.offerManager.debugChangeTimerInfo;
			string += '\n\n lastSignInTime: ' + StringUtils.getDateString(gameManager.lastSignInTime) + ' , lastPurchaseTime: ' + StringUtils.getDateString(gameManager.lastPaymentTime);
			
			string += '\n\n OFFER INFO: \n' + offer.toString();
			string += '\n\n CHECKS: ' + gameManager.offerManager.debugGetOfferStatusString(offer);
			string += '\n\n ' + gameManager.offerManager.debugGetOfferClientDataString(offer);
			
			var infoDialog:ReconnectDialog = new ReconnectDialog(ReconnectDialog.TYPE_INFO, '', string, -999, callback_cleanOfferClientData, 'reset this client data');
			infoDialog.setProperties(14, true, XButtonStyle.GreenButtonMiniFont, 330, 80, 'reset current and refresh', XButtonStyle.GreenButtonMiniFont, callback_resetCurrentOffer, 0);
			DialogsManager.addDialog(infoDialog, true, true);
			
			close();
		}
		
		private function callback_cleanOfferClientData():void 
		{
			if (lastSelectedOfferInfo) 
			{
				gameManager.offerManager.cleanOfferClientData(lastSelectedOfferInfo);
				lastSelectedOfferInfo = null;
			}
		}
		
		private function callback_resetCurrentOffer():void 
		{
			gameManager.offerManager.currentOffer = null;
			gameManager.offerManager.offerId = '';
			gameManager.offerManager.offerStart = 0;
			lastSelectedOfferInfo = null;
			gameManager.offerManager.refresh();
			
			DialogsManager.instance.closeDialogByClass(ReconnectDialog);
		}
		
		
		private function toggleEnableSlotMachineFreeSpins():void
		{
			gameManager.slotsModel.debugDisableFreeSpins = !gameManager.slotsModel.debugDisableFreeSpins;
			
			var button:Button = objectsById['slotMachineFreeSpinsButton'] as Button;
			button.label = 'free spins enabled: ' + String(!gameManager.slotsModel.debugDisableFreeSpins);
		}
		
		
		private var soundCycleDebuggerSound:SoundAsset;
		private var soundCycleDebuggerFadeInTime:Number;
		private var soundCycleDebuggerFadeOutTime:Number;
		private var soundCycleDebuggerDelay:Number;
		
		private function addSoundSFXCycleDebugger(soundAsset:SoundAsset, delay:Number = 2, fadeInTime:Number = 0.5, fadeOutTime:Number = 0.8):void
		{
			if(soundCycleDebuggerSound)
				SoundManager.instance.stopSfxLoop(soundCycleDebuggerSound, 0);
			
			soundCycleDebuggerSound = soundAsset;
			soundCycleDebuggerFadeInTime = fadeInTime;
			soundCycleDebuggerFadeOutTime = fadeOutTime;
			soundCycleDebuggerDelay = delay;
			
			addNumericStepper(container, 'start fade', 0.0, 1, 0.05, fadeInTime, 60 * pxScale, callback_changePropertiesSoundSFXCycleDebugger, null, 'startFade');
			addNumericStepper(container, 'finish fade', 0.0, 1, 0.05, soundCycleDebuggerFadeOutTime, 60 * pxScale, callback_changePropertiesSoundSFXCycleDebugger, null, 'finishFade');
			addNumericStepper(container, 'soundDebuggerDelay', 0.0, 30, 0.05, delay, 60 * pxScale, callback_changePropertiesSoundSFXCycleDebugger, null, 'soundDebuggerDelay');
		}
		
		private function callback_changePropertiesSoundSFXCycleDebugger(...args):void
		{
			var stepper:NumericStepper = objectsById['startFade'] as NumericStepper;
			soundCycleDebuggerFadeInTime = stepper.value;
			
			stepper = objectsById['finishFade'] as NumericStepper;
			soundCycleDebuggerFadeOutTime = stepper.value;
			
			stepper = objectsById['soundDebuggerDelay'] as NumericStepper;
			soundCycleDebuggerDelay = stepper.value;
			
			SoundManager.instance.stopSfxLoop(soundCycleDebuggerSound, 0);
			SoundManager.instance.playSfxLoop(soundCycleDebuggerSound, soundCycleDebuggerDelay, soundCycleDebuggerFadeInTime, soundCycleDebuggerFadeOutTime);
		}
	}
}
import com.alisacasino.bingo.models.offers.OfferItem;
import feathers.controls.Label;
import feathers.controls.PickerList;
import feathers.controls.renderers.DefaultListItemRenderer;
import starling.display.Quad;
import starling.display.Sprite;


final class DropDownListContainer extends Sprite {
	public var label:Label;
	public var pickerList:PickerList;
}

class OfferDropdownListItemRenderer extends DefaultListItemRenderer 
{
	private var offerItem:OfferItem;
	
	override public function set data(value:Object):void
	{
		super.data = value;
		offerItem  = (value && value.object && value.object is OfferItem) ? (value.object as OfferItem) : null;
	}
	
	override protected function draw():void
	{
		super.draw();
		
		if (defaultSkin && offerItem) {
			(defaultSkin as Quad).color = offerItem.isDebug ? 0xFFFF00 : (offerItem.enabled ? 0x34C300 : 0xC32700);
		}
	}
}