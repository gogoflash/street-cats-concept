package com.alisacasino.bingo.dialogs
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.commands.player.ClaimCollectionPageReward;
	import com.alisacasino.bingo.commands.player.CollectCommodities;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.commands.serverRequests.SendEventPrizeClaim;
	import com.alisacasino.bingo.controls.AnimatedImageAssetContainer;
	import com.alisacasino.bingo.controls.PlayerValueView;
	import com.alisacasino.bingo.controls.StarTitle;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.DialogProperties;
	import com.alisacasino.bingo.dialogs.facebookConnectDialogClasses.FacebookConnectDialog;
	import com.alisacasino.bingo.models.collections.CollectionPage;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.EventPrizeMessage;
	import com.alisacasino.bingo.protocol.ModificatorMessage;
	import com.alisacasino.bingo.protocol.ModificatorType;
	import com.alisacasino.bingo.protocol.TournamentResultMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.profileScreenClasses.AvatarContainer;
	import com.alisacasino.bingo.utils.StringUtils;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNACollectionPageCompleted;
	import feathers.controls.LayoutGroup;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalAlign;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CollectionPageRewardDialog extends BaseDialog
	{
		private var ownScoreValueLabel:XTextField;
		private var trophyBonusLabel:XTextField;
		private var cashPlayerValueView:PlayerValueView;
		private var energyPlayerValueView:PlayerValueView;
		private var onDialogClose:Function;
		private var contentContainer:LayoutGroup;
		private var collectionPage:CollectionPage;
		
		public function CollectionPageRewardDialog(collectionPage:CollectionPage, onDialogClose:Function = null)
		{
			this.collectionPage = collectionPage;
			this.onDialogClose = onDialogClose;
			var props:DialogProperties = DialogProperties.COLLECTION_PAGE_COMPLETED;
			props.title = "PAGE COMPLETED";
			super(props);
			
			if (collectionPage.completionMarked)
			{
				close();
				return;
			}
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			if (collectionPage.completionMarked)
			{
				close();
				return;
			}
			
			contentContainer = new LayoutGroup();
			addChild(contentContainer);
			contentContainer.alpha = 0;
			//Starling.juggler.tween(container, 0.05, { "alpha#":1, delay: 0.6 } );
			addToFadeList(contentContainer, 0);
			
			var rewardBackground:Image = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/collections/card_background"));
			rewardBackground.alpha = 0.2;
			rewardBackground.x = 28 * pxScale;
			rewardBackground.y = 116 * pxScale;
			rewardBackground.scale9Grid = ResizeUtils.getScaledRect(16, 16, 8, 8);
			rewardBackground.width = 757 * pxScale;
			rewardBackground.height = 486 * pxScale;
			contentContainer.addChild(rewardBackground);
			
			var trophyImage:AnimatedImageAssetContainer = new AnimatedImageAssetContainer();
			trophyImage.scale = 1.25;
			trophyImage.setPivot(Align.CENTER, Align.CENTER);
			trophyImage.source = collectionPage.trophyImage;
			trophyImage.x = 200 * pxScale;
			trophyImage.y = 280 * pxScale;
			contentContainer.addChild(trophyImage);
			
			var rewardLabel:XTextField= new XTextField(300*pxScale, 80*pxScale, XTextFieldStyle.getWalrus(44, 0x00deff), "REWARD");
			rewardLabel.x = 434 * pxScale;
			rewardLabel.y = 140 * pxScale;
			contentContainer.addChild(rewardLabel);
			
			var cashReward:uint = collectionPage.getCashReward();
			var powerupReward:uint = collectionPage.getPowerupReward();
			
			cashPlayerValueView = new PlayerValueView('bars/medium/cash', -4);
			cashPlayerValueView.show(cashReward, 0);
			cashPlayerValueView.x = 504 * pxScale;
			cashPlayerValueView.y = 280 * pxScale;
			contentContainer.addChild(cashPlayerValueView);
				
			energyPlayerValueView = new PlayerValueView('bars/medium/energy', 0);
			energyPlayerValueView.show(powerupReward, 0);
			energyPlayerValueView.x = 504 * pxScale;
			energyPlayerValueView.y = 388 * pxScale;
			contentContainer.addChild(energyPlayerValueView);
			
			trophyBonusLabel = new XTextField(756 * pxScale, 50 * pxScale, XTextFieldStyle.getChateaudeGarage(31), "TROPHY BONUS:");
			trophyBonusLabel.x = rewardBackground.x;
			trophyBonusLabel.y = 450 * pxScale;
			contentContainer.addChild(trophyBonusLabel);
			
			var trophyValueText:String = getTemplateForBonus(collectionPage.getPermanentEffect());
			trophyValueText = StringUtils.substitute(trophyValueText, collectionPage.getPermanentEffect() ? collectionPage.getPermanentEffect().quantity : 0, collectionPage.collection.name);
			trophyValueText = trophyValueText.toUpperCase();
			
			var trophyValueLabel:XTextField = new XTextField(756 * pxScale, 100 * pxScale, XTextFieldStyle.getChateaudeGarage(31, 0xec95ff), trophyValueText);
			trophyValueLabel.x = rewardBackground.x;
			trophyValueLabel.y = 489 * pxScale;
			contentContainer.addChild(trophyValueLabel);
			
			if (!PlatformServices.facebookManager.isConnected)
			{
				var okButton:XButton = new XButton(XButtonStyle.DialogBigGreenButtonStyle, "OK");
				okButton.x = 245 * pxScale;
				okButton.y = 614 * pxScale;
				okButton.addEventListener(Event.TRIGGERED, okButton_triggeredHandler);
				addChild(okButton);
			}
			else
			{
				var shareButton:XButton = new XButton(XButtonStyle.LargeBlueButtonStyle, "SHARE");
				shareButton.x = 245 * pxScale;
				shareButton.y = 614 * pxScale;
				shareButton.addEventListener(Event.TRIGGERED, shareButton_triggeredHandler);
				addChild(shareButton);
			}
			
			var collectCommodities:CollectCommodities = new CollectCommodities(collectionPage.prizes, "collectionPage", gameManager.powerupModel.collectionPageDropTable, false);
			collectCommodities.execute();
			var powerupDropResult:Object = collectCommodities.powerupDropResult;
			
			new ClaimCollectionPageReward(collectionPage).execute();
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNACollectionPageCompleted(collectionPage, powerupDropResult));
		}
		
		private function okButton_triggeredHandler(e:Event):void 
		{
			close();
		}
		
		private function getTemplateForBonus(permanentEffect:ModificatorMessage):String
		{
			if (!permanentEffect)
				return "";
			
			switch(permanentEffect.type)
			{
				case ModificatorType.CASH_MOD:
					return "+{0}% Cash Bonus Payout\nin {1} Tourney"
					break;
				case ModificatorType.DISCOUNT_MOD:
					return "-{0}% Bingo Cards Cost\nin {1} Tourney";
					break;
				case ModificatorType.EXP_MOD:
					return "+{0}% Extra XP Earned\nIn {1} Tourney";
					break;
				case ModificatorType.SCORE_MOD:
					return "+{0}% Extra Score Points\nIn {1} Tourney";
					break;
			}
			return "";
		}
		
		private function shareButton_triggeredHandler(e:Event):void 
		{
			close();
			if (PlatformServices.facebookManager.isConnected)
			{
				PlatformServices.facebookManager.share(collectionPage.opengraphURL, 'WOW! Just look at this trophy I got in Arena Bingo! Collect cards and get your trophies, too!');
			}
			else
			{
				DialogsManager.addDialog(new FacebookConnectDialog());
			}
		}
		
		override public function close():void 
		{
			super.close();
			if (onDialogClose != null)
			{
				onDialogClose();
			}
			
			new UpdateLobbyBarsTrueValue(0.5).execute();
		}
	
	}

}