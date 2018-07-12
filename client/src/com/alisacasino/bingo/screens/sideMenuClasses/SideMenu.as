package com.alisacasino.bingo.screens.sideMenuClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.dialogCommands.ShowInboxDialog;
	import com.alisacasino.bingo.commands.dialogCommands.ShowStore;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.facebookConnectDialogClasses.FacebookConnectDialog;
	import com.alisacasino.bingo.dialogs.leaderboardDialogClasses.LeaderboardDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.RateDialogManager;
	import com.alisacasino.bingo.models.gifts.GiftsModel;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.collectionsScreenClasses.CollectionsScreen;
	import com.alisacasino.bingo.screens.gameScreenClasses.ScreenCatScooter;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.InventoryScreen;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.LobbyUI;
	import com.alisacasino.bingo.screens.profileScreenClasses.ProfileScreen;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.utils.FriendsManager;
import com.alisacasino.bingo.utils.sounds.SoundManager;
import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAUIInteractionEvent;
import com.alisacasino.bingo.utils.caurina.transitions.properties.DisplayShortcuts;
import com.alisacasino.bingo.utils.support.CustomerSupportManager;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import feathers.core.FeathersControl;

import flash.net.URLRequest;
import flash.net.navigateToURL;

import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SideMenu extends FeathersControl
	{
		public static const ITEM_HEIGHT:int = 79;
		public static const INFO_MIN_HEIGHT:int = 79;
		
		private var rateBlock:RateUsBlock;
		private var sideQuad:Quad;
		private var infoArea:InfoArea;
		protected var gameScreen:GameScreen;
		private var optionButtons:Array;
		private var optionButtonsCache:Object;
		private var _inventoryOptionButton:InventoryOptionButton;
		
		public function SideMenu(gameScreen:GameScreen) 
		{
			this.gameScreen = gameScreen;
			optionButtons = [];
			optionButtonsCache = {};
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			sideQuad = new Quad(3 * pxScale, 1, 0xffffff);
			sideQuad.x = 452 * pxScale;
			addChild(sideQuad);
			
			createHeaderElement();
			createSoundOptions();
			//createCommonButtons();
			createInfoArea();
			//createRateBlock();
		}
		
		public function get inventoryOptionButton():InventoryOptionButton
		{
			return _inventoryOptionButton;
		}
		
		private function createRateBlock():void 
		{
			rateBlock = new RateUsBlock();
			rateBlock.addEventListener(Event.TRIGGERED, rateBlock_triggeredHandler);
			addChild(rateBlock);
		}
		
		private function rateBlock_triggeredHandler(e:Event):void 
		{
			gameManager.analyticsManager.sendDeltaDNAEvent(
							new DDNAUIInteractionEvent(
								DDNAUIInteractionEvent.ACTION_TRIGGERED, 
								DDNAUIInteractionEvent.LOCATION_SIDE_MENU, 
								"rateBlock", 
								DDNAUIInteractionEvent.TYPE_BUTTON));
			
			RateDialogManager.instance.triggered = true;
			RateDialogManager.instance.showRateDialog(null, true);
			closeMenu();
		}
		
		private function createInfoArea():void 
		{
			infoArea = new InfoArea(this);
			infoArea.y = 570 * pxScale;
			addChild(infoArea);
		}
		
		private function createCommonButtons():void 
		{
			addOptionButton(InboxOptionButton, "inbox", "INBOX", 0).addEventListener(Event.TRIGGERED, inboxButton_triggeredHandler);
			addOptionButton(OptionButton, "friends", "INVITE FRIENDS", 1).addEventListener(Event.TRIGGERED, friendsButton_triggeredHandler);
			addOptionButton(OptionButton, "customer_support", "CUSTOMER SUPPORT", 3).addEventListener(Event.TRIGGERED, customerSupportButton_triggeredHandler);
			_inventoryOptionButton = new InventoryOptionButton(AtlasAsset.CommonAtlas.getTexture("side_menu/inventory"), "INVENTORY");
			addOptionButton(InventoryOptionButton, "inventory", "INVENTORY", 5, _inventoryOptionButton).addEventListener(Event.TRIGGERED, inventoryButton_triggeredHandler);
				
			if (PlatformServices.isMobile)
			    addOptionButton(OptionButton, "facebook", PlatformServices.facebookManager.isConnected ? "LOG OUT" : "CONNECT", 6).addEventListener(Event.TRIGGERED, loginButton_triggeredHandler);
			else 
				addOptionButton(OptionButton, "facebook", 'LIKE US', 6).addEventListener(TouchEvent.TOUCH, handler_likeUsTouch);

		}
		
		private function inventoryButton_triggeredHandler(e:Event):void 
		{
			//DialogsManager.addDialog(new CollectionsScreen());
			
			gameManager.analyticsManager.sendDeltaDNAEvent(
							new DDNAUIInteractionEvent(
								DDNAUIInteractionEvent.ACTION_TRIGGERED, 
								DDNAUIInteractionEvent.LOCATION_SIDE_MENU, 
								"inventoryButton", 
								DDNAUIInteractionEvent.TYPE_BUTTON));
			
			DialogsManager.addDialog(new InventoryScreen(InventoryScreen.DAUBER_MODE));
			closeMenu();
		}
		
		private function loginButton_triggeredHandler(e:Event):void 
		{
			gameManager.analyticsManager.sendDeltaDNAEvent(
							new DDNAUIInteractionEvent(
								DDNAUIInteractionEvent.ACTION_TRIGGERED, 
								DDNAUIInteractionEvent.LOCATION_SIDE_MENU, 
								"loginButton", 
								DDNAUIInteractionEvent.TYPE_BUTTON));
			
			if (PlatformServices.facebookManager.isConnected)
				PlatformServices.facebookManager.logOut();
			else 
				DialogsManager.addDialog(new FacebookConnectDialog());
		
			closeMenu();
		}
		
		private function handler_likeUsTouch(e:TouchEvent):void 
		{
			var button:OptionButton = e.currentTarget as OptionButton;
			var touch:Touch = e.getTouch(button);
			if (!touch)
				return;
			
			if (touch.phase == TouchPhase.BEGAN)
			{
				Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP, function onMouseUp(e:MouseEvent):void {
				
					Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					closeMenu();
					
					if (new Rectangle(button.x * scale, button.y * scale, button.width * scale, button.height * scale).contains(Starling.current.nativeStage.mouseX, Starling.current.nativeStage.mouseY))
					{
						navigateToURL(new URLRequest('https://www.facebook.com/arenabingo/'), "_blank");
						gameManager.analyticsManager.sendDeltaDNAEvent(
							new DDNAUIInteractionEvent(
								DDNAUIInteractionEvent.ACTION_TRIGGERED, 
								DDNAUIInteractionEvent.LOCATION_SIDE_MENU, 
								"likeUsButton", 
								DDNAUIInteractionEvent.TYPE_BUTTON));
					}
				});
			}
		}
				
		private function customerSupportButton_triggeredHandler(e:Event):void 
		{
			closeMenu();
            
			gameManager.analyticsManager.sendDeltaDNAEvent(
							new DDNAUIInteractionEvent(
								DDNAUIInteractionEvent.ACTION_TRIGGERED, 
								DDNAUIInteractionEvent.LOCATION_SIDE_MENU, 
								"customerSupportButton", 
								DDNAUIInteractionEvent.TYPE_BUTTON));
			
			if (PlatformServices.isCanvas)
			{
				navigateToURL(new URLRequest('https://alisagaming.zendesk.com/hc/en-us'));
			}
			else 
			{
				CustomerSupportManager.instance.openMailto();
			}
		}
		
		private function friendsButton_triggeredHandler(e:Event):void 
		{
			closeMenu();
			
			gameManager.analyticsManager.sendDeltaDNAEvent(
							new DDNAUIInteractionEvent(
								DDNAUIInteractionEvent.ACTION_TRIGGERED, 
								DDNAUIInteractionEvent.LOCATION_SIDE_MENU, 
								"friendsButton", 
								DDNAUIInteractionEvent.TYPE_BUTTON));
			
			if (PlatformServices.isMobile)
			{
				if (PlatformServices.facebookManager.isConnected)
					FriendsManager.instance.showInviteFriendsDialog(FriendsManager.DIALOG_MODE_FROM_SIDE_MENU, true);
				else 
					DialogsManager.addDialog(new FacebookConnectDialog());
			}
			else
			{
				FriendsManager.instance.showInviteFriendsDialog(FriendsManager.DIALOG_MODE_FROM_SIDE_MENU, true);
			}
		}
		
		private function inboxButton_triggeredHandler(e:Event):void 
		{
			closeMenu();

			gameManager.analyticsManager.sendDeltaDNAEvent(
							new DDNAUIInteractionEvent(
								DDNAUIInteractionEvent.ACTION_TRIGGERED, 
								DDNAUIInteractionEvent.LOCATION_SIDE_MENU, 
								"inboxButton", 
								DDNAUIInteractionEvent.TYPE_BUTTON));
			
			if (PlatformServices.isMobile)
			{
				if (PlatformServices.facebookManager.isConnected || GiftsModel.DEBUG_MODE)
					giftsAndInviteDialogChain();
				else 
					DialogsManager.addDialog(new FacebookConnectDialog());
			}
			else
			{
				giftsAndInviteDialogChain();
			}
		}

		private function giftsAndInviteDialogChain():void
		{
			Game.connectionManager.sendRequestIncomingItemsMessage();

			gameManager.giftsModel.addEventListener(GiftsModel.GIFTS_DESERIALIZED, updateBadgeAndShowGiftAccept);

			function updateBadgeAndShowGiftAccept():void {
				gameManager.giftsModel.removeEventListener(GiftsModel.GIFTS_DESERIALIZED, updateBadgeAndShowGiftAccept);

				new ShowInboxDialog(ShowInboxDialog.TYPE_ON_BUTTON_PRESS).execute();
			}
		}
		
		private function handler_storeButton(e:Event):void 
		{
			gameManager.analyticsManager.sendDeltaDNAEvent(
				new DDNAUIInteractionEvent(
					DDNAUIInteractionEvent.ACTION_TRIGGERED, 
					DDNAUIInteractionEvent.LOCATION_SIDE_MENU, 
					"storeButton", 
					DDNAUIInteractionEvent.TYPE_BUTTON));
			new ShowStore(StoreScreen.CASH_MODE).execute();
		}
		
		private function handler_tourneyButton(e:Event):void 
		{
			gameManager.analyticsManager.sendDeltaDNAEvent(
							new DDNAUIInteractionEvent(
								DDNAUIInteractionEvent.ACTION_TRIGGERED, 
								DDNAUIInteractionEvent.LOCATION_SIDE_MENU, 
								"tourneyButton", 
								DDNAUIInteractionEvent.TYPE_BUTTON));
			DialogsManager.addDialog(new LeaderboardDialog());
		}
		
		public function closeMenu():void 
		{
			dispatchEventWith(Event.CLOSE);
		}
		
		private function addOptionButton(optionButtonClass:Class, iconName:String, label:String, positionIndex:int, optionButton:OptionButton = null):OptionButton
		{
			if (iconName in optionButtonsCache)
				return null;
			
			if (!optionButton)	
				optionButton = new optionButtonClass(AtlasAsset.CommonAtlas.getTexture("side_menu/"+ iconName), label);
			
			optionButton.y = 175 * pxScale + positionIndex * ITEM_HEIGHT * pxScale;
			addChild(optionButton);
			optionButtons[positionIndex] = optionButton;
			optionButtonsCache[iconName] = optionButton;
			return optionButton;
		}
		
		private function removeOptionButton(iconName:String):Boolean
		{
			if (!(iconName in optionButtonsCache)) 
				return false;
				
			var optionButton:OptionButton = optionButtonsCache[iconName] as OptionButton;
			delete optionButtonsCache[iconName];
			
			var i:int = optionButtons.indexOf(optionButton);
			if (i != -1)
				optionButtons[i] = null;
				
			optionButton.removeFromParent();
			
			return true;
		}
		
		private function createSoundOptions():void 
		{
			var soundOptionsBlock:SoundOptionsBlock = new SoundOptionsBlock();
			soundOptionsBlock.y = 74 * pxScale;
			addChild(soundOptionsBlock);
		}
		
		private function createHeaderElement():void 
		{
			if (gameScreen.state == GameScreen.STATE_PRE_GAME && gameScreen.lobbyUI.state == LobbyUI.STATE_LOBBY)
			{
				createProfileHeader();
			}
			else
			{
				createBackHeader();
			}
		}
		
		private function createBackHeader():void 
		{
			var backToHomeBlock:BackToHomeBlock = new BackToHomeBlock();
			backToHomeBlock.addEventListener(Event.TRIGGERED, backToHomeBlock_triggeredHandler);
			addChild(backToHomeBlock);
		}
		
		private function createProfileHeader():void 
		{
			var profileBlock:ProfileBlock = new ProfileBlock();
			profileBlock.addEventListener(Event.TRIGGERED, profileBlock_triggeredHandler);
			addChild(profileBlock);
		}
		
		private function profileBlock_triggeredHandler(e:Event):void 
		{
			closeMenu();
			
			gameManager.analyticsManager.sendDeltaDNAEvent(
							new DDNAUIInteractionEvent(
								DDNAUIInteractionEvent.ACTION_TRIGGERED, 
								DDNAUIInteractionEvent.LOCATION_SIDE_MENU, 
								"profileBlock", 
								DDNAUIInteractionEvent.TYPE_BUTTON));
			
			DialogsManager.addDialog(new ProfileScreen());
		}
		
		private function backToHomeBlock_triggeredHandler(e:Event):void 
		{
			if (!Player.current)
				return;
				
			gameManager.analyticsManager.sendDeltaDNAEvent(
				new DDNAUIInteractionEvent(
					DDNAUIInteractionEvent.ACTION_TRIGGERED, 
					DDNAUIInteractionEvent.LOCATION_SIDE_MENU, 
					"backToHomeButton", 
					DDNAUIInteractionEvent.TYPE_BUTTON));
			
			if (gameScreen.state == GameScreen.STATE_PRE_GAME)
			{
				if (Player.current.cards.length > 0)
				{
					Player.current.refundAndClearCards();
					Game.connectionManager.sendLeaveMessage();
				}
				gameScreen.backToSplash();
			}
			else
			{
				gameScreen.backToLobby();
			}
			
			gameManager.tutorialManager.handleBackFromMenu();
			
			SoundManager.instance.stopSfxLoop(SoundAsset.PowerUpActivateLoop, 0.2);
			SoundManager.instance.stopSfxLoop(SoundAsset.X2BoostFireLoop, 0.2);
					
			dispatchEventWith(Event.CLOSE);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				if (rateBlock) {
				rateBlock.validate();
				rateBlock.y = height - rateBlock.height;
				}
			
				sideQuad.height = height;
				
				handleAdditionalButtonsOnOversizeMenu();
				
				var i:int;
				var index:int;
				var optionButton:OptionButton;
				for (i = 0; i < optionButtons.length; i++) {
					optionButton = optionButtons[i] as OptionButton;
					if (optionButton) {
						optionButton.y = 175 * pxScale + index * ITEM_HEIGHT * pxScale;
						index++;
					}
				}
				
				infoArea.y = 175 * pxScale + index * ITEM_HEIGHT * pxScale;
				infoArea.height = height - infoArea.y// - rateBlock.height;
			}
		}
		
		private function handleAdditionalButtonsOnOversizeMenu():void 
		{
			return;
			
			var i:int;
			var index:int;
			var optionButton:OptionButton;
			for (i = 0; i < optionButtons.length; i++) {
				if (optionButtons[i] as OptionButton) 
					index++;
			}
			
			var optionButtonsHeight:int = 175 * pxScale + (index) * ITEM_HEIGHT * pxScale;
			var extraPlaces:int = Math.floor((height - INFO_MIN_HEIGHT * pxScale - rateBlock.height - optionButtonsHeight) / (ITEM_HEIGHT * pxScale));
			
			// trace(' > ', optionButtonsHeight, extraPlaces, height - INFO_MIN_HEIGHT * pxScale - rateBlock.height - optionButtonsHeight);
			
			while (extraPlaces > 0) 
			{
				if (extraPlaces > 0) {
					optionButton = addOptionButton(OptionButton, "store_icon", 'STORE', 4)
					if (optionButton) {
						optionButton.addEventListener(Event.TRIGGERED, handler_storeButton);
						extraPlaces--;
						continue;
					}
				}	
				
				if(extraPlaces > 0) {
					optionButton = addOptionButton(OptionButton, "tourney_icon", "TOURNEY", 2);
					if (optionButton) {
						optionButton.addEventListener(Event.TRIGGERED, handler_tourneyButton);
						extraPlaces--;
						continue;
					}
				}
				
				extraPlaces--;
			}
			
			while (extraPlaces < 0) 
			{
				if(extraPlaces < 0) {
					if (removeOptionButton("tourney_icon")) {
						extraPlaces++;
						continue;
					}
				}
				
				if (extraPlaces < 0) {
					if (removeOptionButton("store_icon")) {
						extraPlaces++;
						continue;
					}
				}	
				
				extraPlaces++;
			}
		}
	}

}