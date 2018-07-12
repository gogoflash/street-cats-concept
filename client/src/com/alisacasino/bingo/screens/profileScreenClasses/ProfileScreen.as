package com.alisacasino.bingo.screens.profileScreenClasses
{
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.components.MultiCharsLabel;
	import com.alisacasino.bingo.controls.CoinsBar;
	import com.alisacasino.bingo.controls.EnergyBar;
	import com.alisacasino.bingo.controls.StarTitle;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.controls.XpBar;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.IDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.collections.Collection;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.FullscreenDialogBase;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.InventoryScreen;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.tooltips.TooltipTrigger;
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.SpinnerList;
	import feathers.controls.ToggleButton;
	import feathers.core.FeathersControl;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalSpinnerLayout;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ProfileScreen extends FullscreenDialogBase
	{
		private var firstDraw:Boolean;
		private var profileContent:LayoutGroup;
		private var cashBar:CoinsBar;
		private var energyBar:EnergyBar;
		private var shopButton:XButton;
		private var xpLabel:XTextField;
		private var xpBar:XpBar;
		private var inventoryButton:XButton;
		private var energyTooltipTrigger:TooltipTrigger;
		private var cashTooltipTrigger:TooltipTrigger;
		private var xpBarTooltipTrigger:TooltipTrigger;
		
		private var avatar:AvatarContainer;
		private var statsBlock:StatsBlock;
		private var trophiesBlock:TrophiesBlock;
		
		public function ProfileScreen()
		{
			titleShiftY = 20 * pxScale;
			setTitle("PROFILE");
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			
			
			profileContent = new LayoutGroup();
			profileContent.setSize(1280 * pxScale, 720 * pxScale);
			contentContainer.addChild(profileContent);
			
			var background:Image = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/collections/card_background"));
			background.alpha = 0.2;
			background.x = 20 * pxScale;
			background.y = 82 * pxScale;
			background.scale9Grid = ResizeUtils.getScaledRect(16, 16, 8, 8);
			background.width = 1240 * pxScale;
			background.height = 617 * pxScale;
			profileContent.addChild(background);
			
			avatar = new AvatarContainer();
			avatar.x = 38 * pxScale;
			avatar.y = 96 * pxScale;
			//avatar.loadByFacebookId('cafesiren') 
			//avatar.loadByFacebookId('212881995497403') 
			avatar.loadBySource(null, Player.current ? Player.current.facebookId : null);
			profileContent.addChild(avatar);
			
			xpLabel = new XTextField(1, 1, XTextFieldStyle.getChateaudeGarage(24, 0x60dbff), "");
			xpLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			xpLabel.text = Player.current ? (Player.current.xpCount + "/" + Player.current.getXpForNextLevel()) : '';
			
			xpLabel.y = 100 * pxScale;
			profileContent.addChild(xpLabel);
			
			xpBar = new XpBar(false);
			xpBar.touchable = false;
			xpBar.x = 292*pxScale;
			xpBar.y = 114*pxScale;
			profileContent.addChild(xpBar);
			
			xpBarTooltipTrigger = new TooltipTrigger(xpBar.width, xpBar.height, "This is your <font color=\"#00b8ff\">Experience Bar</font>! When it\nfills with experience <font color=\"#00b8ff\">(XP)</font>, you get\na level up.\n\nYou can earn <font color=\"#00b8ff\">XP</font> by\nplacing daubs in Bingo rounds!", Align.BOTTOM);
			xpBarTooltipTrigger.x = xpBar.x;
			xpBarTooltipTrigger.y = xpBar.y;
			profileContent.addChild(xpBarTooltipTrigger);
			
			
			var nameLabel:MultiCharsLabel = new MultiCharsLabel(XTextFieldStyle.getWalrus(40, 0xffffff, Align.LEFT), 440 * pxScale, 50 * pxScale, Player.current ? Player.current.fullName : 'no user', true);
			nameLabel.textField.x = 296 * pxScale;
			nameLabel.textField.y = 225 * pxScale;
			//nameLabel.debugTest(false);
			profileContent.addChild(nameLabel.textField);
			
			var playerIDLabel:XTextField = new XTextField(1, 1, XTextFieldStyle.getWalrus(27, 0x65e300));
			playerIDLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			playerIDLabel.x = 296 * pxScale;
			playerIDLabel.y = 302 * pxScale;
			playerIDLabel.text = "PLAYER ID: " + (Player.current ? Player.current.playerId.toString() : ' - ');
			profileContent.addChild(playerIDLabel);
			
			cashBar = new CoinsBar(true);
			cashBar.x = 1045 * pxScale;
			profileContent.addChild(cashBar);
			
			cashTooltipTrigger = new TooltipTrigger(cashBar.width, cashBar.height, "This is the amount of <font color=\"#c42de8\">Cash</font> you've got. Cash\nis the main currency in the game.\n\nIT is spent on things like Bingo cards,\nextra powerups, playing scratch card\nmini-games, opening chests and much more", Align.BOTTOM);
			cashTooltipTrigger.x = cashBar.x;
			cashTooltipTrigger.y = 90 * pxScale;
			profileContent.addChild(cashTooltipTrigger);
			
			energyBar = new EnergyBar(true);
			energyBar.x = 1045 * pxScale;
			profileContent.addChild(energyBar);
			
			energyTooltipTrigger = new TooltipTrigger(energyBar.width, energyBar.height, "This number is equal to the total sum of\nall of your <font color=\"#ff5846\">power-ups</font> in your posession.\n\nPower-ups are used in the rounds of Bingo\nto give you a little bit of an extra edge!", Align.BOTTOM);
			energyTooltipTrigger.x = energyBar.x;
			energyTooltipTrigger.y = 170 * pxScale;
			profileContent.addChild(energyTooltipTrigger);
			
			inventoryButton = new XButton(XButtonStyle.InventoryPurple, "INVENTORY");
			//inventoryButton.enabled = false;
			inventoryButton.x = 758 * pxScale;
			inventoryButton.addEventListener(Event.TRIGGERED, inventoryButton_triggeredHandler);
			profileContent.addChild(inventoryButton);
			
			shopButton = new XButton(XButtonStyle.ProfileShopGreenButtonStyle, "SHOP");
			shopButton.x = 1048 * pxScale;
			shopButton.addEventListener(Event.TRIGGERED, shopButton_triggeredHandler);
			profileContent.addChild(shopButton);
			
			statsBlock = new StatsBlock();
			statsBlock.x = 37 * pxScale;
			statsBlock.y = 351 * pxScale;
			profileContent.addChild(statsBlock);
			
			trophiesBlock = new TrophiesBlock();
			trophiesBlock.x = 651 * pxScale;
			trophiesBlock.y = 351 * pxScale;
			profileContent.addChild(trophiesBlock);
			
			var trophiesTooltipTrigger:TooltipTrigger = new TooltipTrigger(trophiesBlock.width, 70*pxScale, "Trophies are awarded for collecting <font color=\"#ff9c00\">8 unique\ncards</font> on a single page of a Collection.\n\nYour trophies grant you one of the following\npermanent bonuses, but only for THAT room:\n\n<font color=\"#00b8ff\">- Extra XP payout</font>\n<font color=\"#b55acc\">- Extra Cash rewards</font>\n<font color=\"#54c300\">- Discount on cards</font>\n<font color=\"#ff59d6\">- Extra POINTS winnings</font>", Align.TOP);
			trophiesTooltipTrigger.x = trophiesBlock.x;
			trophiesTooltipTrigger.y = trophiesBlock.y;
			profileContent.addChild(trophiesTooltipTrigger);
			
			profileContent.alignPivot(Align.CENTER, Align.BOTTOM);
			profileContent.x = profileContent.width / 2;
			profileContent.y = profileContent.height;
			
			firstDraw = true;
		}
		
		private function inventoryButton_triggeredHandler(e:Event):void 
		{
			close();
			DialogsManager.addDialog(new InventoryScreen(InventoryScreen.DAUBER_MODE));
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (firstDraw)
			{
				animateAppearance();
			}
			
			firstDraw = false;
		}
		
		private function animateAppearance():void 
		{
			//SoundManager.instance.setSoundtrackVolume(SoundManager.BACKGROUND_LOW_VOLUME);
			SoundManager.instance.playSfx(SoundAsset.RoundResultsPopup);
			
			cashBar.y = 60 * pxScale;
			TweenHelper.tween(cashBar, 0.2, { y:110*pxScale } )
				.chain(cashBar, 0.05, {y:160*pxScale, transition:Transitions.EASE_OUT} )
				.chain(cashBar, 0.45, { y:110 * pxScale , transition:Transitions.EASE_IN_OUT } )
			
			energyBar.y = 150 * pxScale;
			TweenHelper.tween(energyBar, 0.2, { y:190*pxScale } )
				.chain(energyBar, 0.05, {y:230*pxScale, transition:Transitions.EASE_OUT} )
				.chain(energyBar, 0.45, { y:190 * pxScale , transition:Transitions.EASE_IN_OUT } )
			
			shopButton.y = 232 * pxScale;
			TweenHelper.tween(shopButton, 0.2, { y:262*pxScale } )
				.chain(shopButton, 0.05, {y:290*pxScale, transition:Transitions.EASE_OUT} )
				.chain(shopButton, 0.45, { y:262 * pxScale , transition:Transitions.EASE_IN_OUT } )
				
			inventoryButton.y = 232 * pxScale;
			TweenHelper.tween(inventoryButton, 0.2, { y:262*pxScale } )
				.chain(inventoryButton, 0.05, {y:290*pxScale, transition:Transitions.EASE_OUT} )
				.chain(inventoryButton, 0.45, { y:263 * pxScale , transition:Transitions.EASE_IN_OUT } )
			
			backgroundQuad.y = - backgroundQuad.height;
			Starling.juggler.tween(backgroundQuad, 0.2, { y:0 } );
			
			contentContainer.y = - contentContainer.height;
			TweenHelper.tween(contentContainer, 0.2, { y:getContentY() } )
				.chain(profileContent, 0.05, {scaleX:1.05, scaleY: 0.9, transition:Transitions.EASE_OUT} )
				.chain(profileContent, 0.25, {scaleX:0.95, scaleY:1.1, transition:Transitions.EASE_IN_OUT})
				.chain(profileContent, 0.2, { scaleX:1, scaleY:1, transition:Transitions.EASE_OUT_BACK } );
				
			xpLabel.x = 330 * pxScale;
			xpLabel.alpha = 0;
			TweenHelper.tween(xpLabel, 0.3, { delay: 0.6, alpha: 1, x: 380 * pxScale, transition:Transitions.EASE_OUT } );
			
			title.alpha = 0;
			Starling.juggler.tween(title, 0.2, { delay: 0.45, alpha:1, transition:Transitions.EASE_OUT } );
				
			closeButton.scale = 0;
			TweenHelper.tween(closeButton, 0.2, { delay: 0.6, scale: contentContainer.scale*1.2, transition: Transitions.EASE_OUT } )
				.chain(closeButton, 0.15, { scale: contentContainer.scale, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
				
			xpBar.numValue = gameManager.gameData.getLevelData(Player.current ? Player.current.xpLevel : 0).xpCount;
			TweenHelper.tween(xpBar, 1, { delay: 0.6, numValue: Player.current ? Player.current.xpCount : 0, transition: Transitions.EASE_OUT } );
		}
		
		override public function close():void 
		{
			//SoundManager.instance.setSoundtrackVolume(SoundManager.BACKGROUND_VOLUME);
			
			Starling.juggler.tween(backgroundQuad, 0.3, { delay: 0.2, y:-backgroundQuad.height, transition:Transitions.EASE_IN, onComplete:avatar.clean} );
			
			TweenHelper.tween(profileContent, 0.15, { scaleX:1.2, scaleY:0.6, transition:Transitions.EASE_OUT} )
				.chain(profileContent, 0.15, { scaleX:0.9, scaleY:1.6, transition:Transitions.EASE_IN } )
				.chain(contentContainer, 0.2, { y: - contentContainer.height } );
			
			Starling.juggler.tween(title, 0.2, { delay: 0.25, alpha:0, transition:Transitions.EASE_OUT } );
			
			Starling.juggler.delayCall(removeFromParent, 0.5, true); 
		}
		
		private function shopButton_triggeredHandler(e:Event):void
		{
			close();
			DialogsManager.addDialog(new StoreScreen(StoreScreen.CASH_MODE));
		}
		
		override protected function resizeContent():void 
		{
			super.resizeContent();
			
			var freeTopHeight:int = getContentY() + 100 * pxScale * profileContent.scale;
			closeButton.y = freeTopHeight/2;
			title.y = closeButton.y - title.height / 2;
		}
	
	}
}