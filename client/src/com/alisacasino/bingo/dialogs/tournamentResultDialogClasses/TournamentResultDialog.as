package com.alisacasino.bingo.dialogs.tournamentResultDialogClasses
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.commands.player.CollectCommodities;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.commands.serverRequests.SendEventPrizeClaim;
	import com.alisacasino.bingo.controls.PlayerValueView;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.DialogProperties;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.facebookConnectDialogClasses.FacebookConnectDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.platform.canvas.CanvasFacebookManager;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.EventPrizeMessage;
	import com.alisacasino.bingo.protocol.TournamentResultMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.profileScreenClasses.AvatarContainer;
	import feathers.controls.LayoutGroup;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalAlign;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class TournamentResultDialog extends BaseDialog
	{
		private var ownScoreValueLabel:XTextField;
		private var ownRankValueLabel:XTextField;
		private var cashPlayerValueView:PlayerValueView;
		private var energyPlayerValueView:PlayerValueView;
		private var tournamentResultMessage:TournamentResultMessage;
		private var onDialogClose:Function;
		
		private var rewardsContainer:Sprite;
		private var eventPrizeMessage:EventPrizeMessage;
		
		private var topUsersContainer:Sprite;
		private var podiumBackground:Quad;
		private var podiumGroup:LayoutGroup;
		
		private var bottomButton:XButton;

		public function TournamentResultDialog(tournamentResultMessage:TournamentResultMessage, onDialogClose:Function = null)
		{
			this.onDialogClose = onDialogClose;
			this.tournamentResultMessage = tournamentResultMessage;
			eventPrizeMessage = tournamentResultMessage.eventPrizes[0];
			super(DialogProperties.TOURNAMENT_END);
		}
		
		override protected function initialize():void
		{
			super.initialize();
		
			if (gameManager.deactivated)
			{
				Game.addEventListener(Game.ACTIVATED, handler_gameActivated);
			}
			else
			{
				// редкий случай когда соединение рвется сразу же после коннекта. Хотя бы ошибку генерировать не будет:
				if (Player.current) {
					createPodium();
					createRewardBlock();
				}
			}
			
			
			if (!PlatformServices.facebookManager.isConnected)
			{
				bottomButton = new XButton(XButtonStyle.DialogBigGreenButtonStyle, "OK");
				bottomButton.addEventListener(Event.TRIGGERED, okButton_triggeredHandler);
			}
			else
			{
				bottomButton = new XButton(XButtonStyle.LargeBlueButtonStyle, "SHARE");
				bottomButton.addEventListener(Event.TRIGGERED, shareButton_triggeredHandler);
			}
			
			bottomButton.x = 245 * pxScale;
			bottomButton.y = 614 * pxScale;
			addChild(bottomButton);	
			
			if (!eventPrizeMessage)
			{
				sosTrace("No event prize message in tournament result!", SOSLog.FATAL);
			}
			else
			{
				new CollectCommodities(eventPrizeMessage.prizePayload.payload, "tournamentEnd", gameManager.powerupModel.tournamentEndDropTable, false).execute();
				new SendEventPrizeClaim(eventPrizeMessage.eventId).execute();
			}
			gameManager.tournamentData.clearResultToShow();
		}
		
		override public function resize():void
		{
			super.resize();
			
			if (gameManager.deactivated || !topUsersContainer || !rewardsContainer)
				return;
			
			starTitle.y = background.y + 20 * pxScale + starTitle.pivotY;
			
			bottomButton.x = 245 * pxScale;
			bottomButton.y = Math.max(background.y + background.height - bottomButton.height - 27 * pxScale, 0); 
			
			var contentHeight:int = bottomButton.y - starTitle.y - starTitle.pivotY;
			var contentGap:int = (contentHeight - podiumBackground.height - rewardsContainer.height ) / 3;
			
			topUsersContainer.y = starTitle.y + starTitle.pivotY + contentGap;
			rewardsContainer.y = topUsersContainer.y + podiumBackground.height + contentGap;//371 * pxScale;
			
			starTitle.y = Math.max(starTitle.y, background.y + (topUsersContainer.y - background.y - starTitle.height) / 2 + starTitle.pivotY);
			
			closeButton.y = starTitle.y;
		}	
		
		private function okButton_triggeredHandler(e:Event):void 
		{
			close();
		}
		
		private function handler_gameActivated(e:Event):void
		{
			Game.removeEventListener(Game.ACTIVATED, handler_gameActivated);
			createPodium();
			createRewardBlock();
			
			invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		private function createPodium():void
		{
			topUsersContainer = new Sprite();
			addChild(topUsersContainer);
			addToFadeList(topUsersContainer);
			
			podiumBackground = new Quad(793 * pxScale, 218 * pxScale, 0xffffff);
			podiumBackground.x = 10 * pxScale;
			//podiumBackground.y = 116 * pxScale;
			podiumBackground.alpha = 0.1;
			topUsersContainer.addChild(podiumBackground);
			//addToFadeList(podiumBackground);
			
			var podiumLayout:HorizontalLayout = new HorizontalLayout();
			podiumLayout.horizontalAlign = HorizontalAlign.CENTER;
			podiumLayout.verticalAlign = VerticalAlign.MIDDLE;
			podiumLayout.gap = 76 * pxScale;
			
			podiumGroup = new LayoutGroup();
			podiumGroup.move(podiumBackground.x, podiumBackground.y);
			podiumGroup.setSize(podiumBackground.width, podiumBackground.height - 20 * pxScale);
			podiumGroup.layout = podiumLayout;
			topUsersContainer.addChild(podiumGroup);
			//addToFadeList(podiumGroup);
			
			for (var i:int = 0; i < 3; i++)
			{
				if (tournamentResultMessage.top.length > i)
				{
					podiumGroup.addChild(new PodiumAvatar(i, tournamentResultMessage.top[i]));
				}
			}
		}
		
		private function createRewardBlock():void
		{
			rewardsContainer = new Sprite();
			rewardsContainer.y = 371 * pxScale;
			addChild(rewardsContainer);
			addToFadeList(rewardsContainer);
			
			var rewardBackground:Image = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/collections/card_background"));
			rewardBackground.alpha = 0.2;
			rewardBackground.x = 28 * pxScale;
			//rewardBackground.y = 371 * pxScale;
			rewardBackground.scale9Grid = ResizeUtils.getScaledRect(16, 16, 8, 8);
			rewardBackground.width = 757 * pxScale;
			rewardBackground.height = 219 * pxScale;
			rewardsContainer.addChild(rewardBackground);
			
			var avatarContainer:AvatarContainer = new AvatarContainer(144, 144);
			avatarContainer.x = 61 * pxScale;
			avatarContainer.y = 19 * pxScale;
			rewardsContainer.addChild(avatarContainer);
			avatarContainer.loadBySource(null, Player.current.facebookId);
			//avatarContainer.loadByFacebookId('425495904128135');
			
			var firstName:String = Player.current.firstName || '';
			//var firstName:String = 'Sergey'//Player.current.firstName || '';
			var nameLabel:XTextField;
			if (Fonts.allCharsInFont(Fonts.WALRUS_BOLD, firstName))
			{
				nameLabel = new XTextField(152 * pxScale, 38 * pxScale, XTextFieldStyle.TournamentResultPlayerNameStyle, firstName.toUpperCase(), 0);
			}
			else
			{
				nameLabel = new XTextField(152 * pxScale, 38 * pxScale, XTextFieldStyle.TournamentResultPlayerNameSystemFont, firstName, 0);
				nameLabel.format.bold = true;
			}
			nameLabel.x = avatarContainer.x - 5 * pxScale; //nameLabel.textBounds.x + (avatarContainer.width - nameLabel.textBounds.width)/2 + 2*pxScale;
			nameLabel.y = avatarContainer.y + avatarContainer.height + 11 * pxScale;
			nameLabel.autoScale = true;
			rewardsContainer.addChild(nameLabel);
			
			var rankImage:Image = new Image(AtlasAsset.CommonAtlas.getTexture("bars/rank"));
			//rankImage.scale = 0.9;
			rankImage.x = 256 * pxScale;
			rankImage.y = 16 * pxScale;
			rewardsContainer.addChild(rankImage);
			
			var ownRankLabel:XTextField = new XTextField(150 * pxScale, 30 * pxScale, XTextFieldStyle.getChateaudeGarage(23), "RANK:");
			ownRankLabel.x = 330 * pxScale;
			ownRankLabel.y = 20 * pxScale;
			rewardsContainer.addChild(ownRankLabel);
			
			var ownRankText:String = "-";
			if (eventPrizeMessage && eventPrizeMessage.place)
			{
				ownRankText = "#" + eventPrizeMessage.place.toString();
			}
			ownRankValueLabel = new XTextField(150 * pxScale, 50 * pxScale, XTextFieldStyle.getChateaudeGarage(40), ownRankText);
			ownRankValueLabel.autoScale = true;
			ownRankValueLabel.x = 330 * pxScale;
			ownRankValueLabel.y = 46 * pxScale;
			rewardsContainer.addChild(ownRankValueLabel);
			
			var scoreImage:Image = new Image(AtlasAsset.CommonAtlas.getTexture("bars/score"));
			scoreImage.x = 256 * pxScale;
			scoreImage.y = 126 * pxScale;
			rewardsContainer.addChild(scoreImage);
			
			var scoreLabel:XTextField = new XTextField(150 * pxScale, 30 * pxScale, XTextFieldStyle.getChateaudeGarage(23), "SCORE:");
			scoreLabel.x = 330 * pxScale;
			scoreLabel.y = 128 * pxScale;
			rewardsContainer.addChild(scoreLabel);
			
			var ownScoreText:String = "-";
			if (eventPrizeMessage && eventPrizeMessage.score)
			{
				ownScoreText = "#" + eventPrizeMessage.score.toString();
			}
			//ownScoreText = "#" + (Math.random() > 0.5 ? int(700000 + 20000000 * Math.random()) : int(50000 * Math.random())).toString();
			ownScoreValueLabel = new XTextField(150 * pxScale, 50 * pxScale, XTextFieldStyle.getChateaudeGarage(40), ownScoreText);
			ownScoreValueLabel.autoScale = true;
			ownScoreValueLabel.x = 330 * pxScale;
			ownScoreValueLabel.y = 153 * pxScale;
			rewardsContainer.addChild(ownScoreValueLabel);
			
			var cashReward:uint = 0;
			var powerupReward:uint = 0;
			
			if (eventPrizeMessage && eventPrizeMessage.prizePayload)
			{
				for each (var item:CommodityItemMessage in eventPrizeMessage.prizePayload.payload)
				{
					if (item.type == Type.CASH)
					{
						cashReward = item.quantity;
					}
					else if (item.type == Type.POWERUP)
					{
						powerupReward += item.quantity;
					}
				}
			}
			
			cashPlayerValueView = new PlayerValueView('bars/medium/cash', -4);
			cashPlayerValueView.show(cashReward, 0);
			cashPlayerValueView.x = 550 * pxScale;
			cashPlayerValueView.y = 64 * pxScale;
			rewardsContainer.addChild(cashPlayerValueView);
			
			energyPlayerValueView = new PlayerValueView('bars/medium/energy', 0);
			energyPlayerValueView.show(powerupReward, 0);
			energyPlayerValueView.x = 550 * pxScale;
			energyPlayerValueView.y = 169 * pxScale;
			rewardsContainer.addChild(energyPlayerValueView);
		}
		
		private function shareButton_triggeredHandler(e:Event):void
		{
			if (PlatformServices.facebookManager.isConnected)
			{
				if(eventPrizeMessage)
					PlatformServices.facebookManager.postTournamentPhoto(onPhotoPostComplete, eventPrizeMessage.place);
			}
			else
			{
				DialogsManager.addDialog(new FacebookConnectDialog());
				close();
			}
		}
		
		private function onPhotoPostComplete():void
		{
			close();
		}
		
		override public function close():void
		{
			super.close();
			if (onDialogClose != null)
			{
				onDialogClose();
			}
			
			new UpdateLobbyBarsTrueValue(1.6).execute();
		}
	
	}

}
import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.assets.Fonts;
import com.alisacasino.bingo.components.PreloaderXImageWrapper;
import com.alisacasino.bingo.controls.XImage;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import com.alisacasino.bingo.models.Player;
import com.alisacasino.bingo.protocol.TournamentTopPlayer;
import com.alisacasino.bingo.resize.ResizeUtils;
import com.alisacasino.bingo.utils.Constants;
import com.alisacasino.bingo.utils.UIUtils;
import feathers.core.FeathersControl;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextFieldAutoSize;
import starling.textures.Texture;
import starling.utils.Align;

class PodiumAvatar extends FeathersControl
{
	public function PodiumAvatar(place:int, ttp:TournamentTopPlayer)
	{
		super();
		
		var player:Player = new Player(ttp.player);
		
		var width:Number = 150;
		var height:Number = 150;
		var widthScaled:Number = width * pxScale;
		var heightScaled:Number = height * pxScale;
		
		setSizeInternal(widthScaled, heightScaled, false);
		
		var avatarContainer:Sprite = new Sprite();
		addChild(avatarContainer);
		
		var avatarImage:PreloaderXImageWrapper = new PreloaderXImageWrapper(Texture.empty(1,1), Player.getAvatarURL(player.avatarSource, player.facebookId, widthScaled, heightScaled), true, 0x7a7a7a);
		avatarImage.width = widthScaled;
		avatarImage.height = heightScaled;
		/*avatarImage.color = 0x303E46;
		avatarImage.y = heightScaled - avatarImage.height;
		avatarImage.x = (widthScaled - avatarImage.width)/2;*/
		avatarContainer.addChild(avatarImage);
		
		avatarContainer.mask = UIUtils.createRoundedRectMaskCanvas(width - 2, height - 2, 17, 1, 1);
		
		var crownSource:String = "dialogs/leaderboard/place_3";
		var frameSource:String = "dialogs/leaderboard/bronze_border";
		var labelColor:uint = 0xffb769;
		switch (place)
		{
			//first place
			case 0: 
				crownSource = "dialogs/leaderboard/place_1";
				frameSource = "dialogs/leaderboard/gold_border";
				labelColor = 0xf2da0e;
				break;
			//second place
			case 1: 
				crownSource = "dialogs/leaderboard/place_2";
				frameSource = "dialogs/leaderboard/silver_border";
				labelColor = 0xa3e7ff;
				break;
		}
		
		if (Constants.isDevFeaturesEnabled && player.isBot)
			labelColor = 0xF05A5C;
		
		var frame:Image = new Image(AtlasAsset.CommonAtlas.getTexture(frameSource));
		frame.scale9Grid = ResizeUtils.getScaledRect(18, 18, 4, 4);
		frame.width = widthScaled;
		frame.height = heightScaled;
		addChild(frame);
		
		var crown:Image = new Image(AtlasAsset.CommonAtlas.getTexture(crownSource));
		crown.scale = 1.3;
		crown.x = -19 * pxScale;
		crown.y = -19 * pxScale;
		addChild(crown);
		
		/*var playerName:XTextField = new XTextField(150*pxScale, 30*pxScale, XTextFieldStyle.getWalrus(27, labelColor));
		   playerName.y = 154 * pxScale;
		   playerName.text = ttp.player.firstName;
		   addChild(playerName);*/
		
		var playerName:XTextField;
		var firstName:String = ttp.player.firstName || '';
		if (Fonts.allCharsInFont(Fonts.WALRUS_BOLD, firstName))
		{
			playerName = new XTextField(156 * pxScale, 38 * pxScale, XTextFieldStyle.getWalrus(30, labelColor, Align.CENTER), firstName.toUpperCase());
		}
		else
		{
			playerName = new XTextField(156 * pxScale, 38 * pxScale, XTextFieldStyle.getSystem(30, labelColor, Align.CENTER), firstName);
			playerName.format.bold = true;
		}
		//playerName.border = true;
		playerName.x = -2 * pxScale; //playerName.textBounds.x + (widthScaled - playerName.textBounds.width)/2;
		playerName.y = 154 * pxScale;
		playerName.autoScale = true;
		addChild(playerName);
	}
}