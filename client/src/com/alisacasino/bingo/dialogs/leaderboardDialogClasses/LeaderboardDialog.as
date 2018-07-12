package com.alisacasino.bingo.dialogs.leaderboardDialogClasses
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.controls.InvisibleButton;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.controls.StarTitle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.DialogProperties;
	import com.alisacasino.bingo.models.LiveEventLeaderboardPosition;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.tournament.LeagueData;
	import com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage;
	import com.alisacasino.bingo.protocol.LiveEventLeaderboardsOkMessage;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.StringUtils;
	import com.alisacasino.bingo.utils.TimeService;
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ToggleButton;
	import feathers.layout.HorizontalLayout;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	import flash.utils.setTimeout;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import starling.display.Image;
	import starling.events.Event;
	
	public class LeaderboardDialog extends BaseDialog
	{
		private static const LEADERBOARD_POSITIONS_COUNT_PER_FETCH:int = 25;
		private var list:List;
		
		private var _requestInProgress:Boolean;
		
		public function get requestInProgress():Boolean 
		{
			return _requestInProgress;
		}
		
		public function set requestInProgress(value:Boolean):void 
		{
			if (_requestInProgress != value)
			{
				_requestInProgress = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		private var minRankInList:int;
		private var maxRankInList:int;
		private var mIsMeToBeShown:Boolean;
		
		//private var mViewTopOrMeBtn:InvisibleButton;
		//private var mViewTopOrMeLabel:XTextField;
		//private var mViewTopOrMeBtnShouldShowTop:Boolean;
		private var liveEventID:int;
		private var positionData:ListCollection;
		private var totalListLength:Number = -1;
		private var scrollDiff:int;
		private var centerOnPlayer:Boolean;
		private var playerRank:int = -1;
		private var switchModeButton:ToggleButton;
		private var ownRankValueLabel:XTextField;
		private var playerLeague:LeagueData;
		private var leagueDescriptionLabel:XTextField;
		private var leagueValueLabel:XTextField;
		private var leagueRewards:LeagueRewards;
		private var timeLeftValueLabel:XTextField;
		private var listBackground:Image;
		private var listContainer:Sprite;
		private var rewardsInfo:Sprite;
		private var loadingAnimation:AnimationContainer;
		
		private var topContainer:Sprite;
		private var bottomContainer:Sprite;
		private var infoButton:Button;
		
		public function LeaderboardDialog()
		{
			var props:DialogProperties = DialogProperties.TOURNEY_LEADERBOARD;
			props.title = gameManager.tournamentData.currentTournamentName.toUpperCase();
			super(props);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			addBackImage(0.2, 0.65, 0.2);
			
			topContainer = new Sprite();
			addChild(topContainer);
			addToFadeList(topContainer);
			
			bottomContainer = new Sprite();
			addChild(bottomContainer);
			addToFadeList(bottomContainer);
			
			var quad:Quad = new Quad(793 * pxScale, 77 * pxScale, 0xffffff);
			quad.x = 9 * pxScale;
			//quad.y = 81 * pxScale;
			quad.alpha = 0.1;
			topContainer.addChild(quad);
			
			switchModeButton = new ToggleButton();
			switchModeButton.x = -17 * pxScale;
			switchModeButton.defaultSkin = getButtonSkin(AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/top_button"), 50, 30);
			switchModeButton.defaultSelectedSkin = getButtonSkin(AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/you_button"), 50, 30);
			switchModeButton.addEventListener(Event.CHANGE, switchModeButton_changeHandler);
			
			var myRankLabel:XTextField = new XTextField(160 * pxScale, 30 * pxScale, XTextFieldStyle.getWalrus(26, 0xff4da5), "RANK");
			myRankLabel.x = 104 * pxScale;
			myRankLabel.y = 7 * pxScale;
			topContainer.addChild(myRankLabel);
			
			ownRankValueLabel = new XTextField(160 * pxScale, 40 * pxScale, XTextFieldStyle.getChateaudeGarage(26, 0xffffff), "# ---");
			ownRankValueLabel.autoScale = true;
			ownRankValueLabel.x = 100 * pxScale;
			ownRankValueLabel.y = 37 * pxScale;
			topContainer.addChild(ownRankValueLabel);
			
			var leagueLabel:XTextField = new XTextField(124 * pxScale, 30 * pxScale, XTextFieldStyle.getWalrus(26, 0xffffff, Align.RIGHT), "LEAGUE:");
			leagueLabel.x = 290 * pxScale;
			leagueLabel.y = 7 * pxScale;
			topContainer.addChild(leagueLabel);
			
			leagueValueLabel = new XTextField(124 * pxScale, 30 * pxScale, XTextFieldStyle.getWalrus(26, 0xf8a5ff, Align.LEFT), "???");
			leagueValueLabel.x = 414 * pxScale;
			leagueValueLabel.y = 7 * pxScale;
			topContainer.addChild(leagueValueLabel);
			
			leagueDescriptionLabel = new XTextField(250 * pxScale, 40 * pxScale, XTextFieldStyle.getChateaudeGarage(26, 0xffffff), "TOP -- %");
			leagueDescriptionLabel.autoScale = true;
			leagueDescriptionLabel.x = 290 * pxScale;
			leagueDescriptionLabel.y = 37 * pxScale;
			topContainer.addChild(leagueDescriptionLabel);
			
			var rewardLabel:XTextField = new XTextField(204 * pxScale, 30 * pxScale, XTextFieldStyle.getWalrus(26, 0x36e201), "REWARD");
			rewardLabel.x = 572 * pxScale;
			rewardLabel.y = 7 * pxScale;
			topContainer.addChild(rewardLabel);
			
			leagueRewards = new LeagueRewards();
			leagueRewards.x = 572 * pxScale;
			leagueRewards.y = 36 * pxScale;
			leagueRewards.setSize(204 * pxScale, 27 * pxScale);
			topContainer.addChild(leagueRewards);
			
			addChild(switchModeButton);
			
			addToFadeList(switchModeButton);
			addToFadeList(topContainer);
			
			loadingAnimation = new AnimationContainer(MovieClipAsset.PackBase);
			loadingAnimation.pivotX = 42 * pxScale;
			loadingAnimation.pivotY = 42 * pxScale;
			loadingAnimation.playTimeline('loading_white', false, true, 24);
			addChild(loadingAnimation);
			
			loadingAnimation.x = 407*pxScale;
			loadingAnimation.y = 410*pxScale;
			
			list = new List();
			
			positionData = new ListCollection();
			list.dataProvider = positionData;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 12 * pxScale;
			layout.paddingTop = 11 * pxScale;
			layout.paddingBottom = 11 * pxScale;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.scrollPositionVerticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			layout.typicalItem = new LeaderboardItemRenderer();
			
			list.layout = layout;
			list.x = - 95 * pxScale;
			list.y = 174 * pxScale;
			list.hasElasticEdges = true;
			list.setSize(1000 * pxScale, 470 * pxScale);	
			list.itemRendererType = LeaderboardItemRenderer;
			list.addEventListener(Event.SCROLL, list_scrollHandler);
			addChild(list);
			addToFadeList(list);
			
			infoButton = new Button();
			infoButton.scaleWhenDown = 0.95;
			infoButton.useHandCursor = true;
			infoButton.defaultSkin = getButtonSkin(AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/info_switch_button"), 25, 25, -15);
			infoButton.x = 58 * pxScale;
			infoButton.addEventListener(Event.TRIGGERED, infoButton_triggeredHandler);
			addChild(infoButton);
			addToFadeList(infoButton);
			
			var timeLeftLabel:XTextField = new XTextField(350 * pxScale, 60 * pxScale, XTextFieldStyle.getWalrus(34, 0xffffff, Align.RIGHT), "TOURNEY ENDS IN");
			timeLeftLabel.x = 114 * pxScale;
			timeLeftLabel.y = 4 * pxScale;
			timeLeftLabel.touchable = false;
			bottomContainer.addChild(timeLeftLabel);
			
			timeLeftValueLabel = new XTextField(350 * pxScale, 60 * pxScale, XTextFieldStyle.getWalrus(44, 0xfee70d, Align.LEFT), "");
			timeLeftValueLabel.x = 470 * pxScale;
			//timeLeftValueLabel.y = 652 * pxScale;
			bottomContainer.addChild(timeLeftValueLabel);
			
			rewardsInfo = new RewardsInfo();
			rewardsInfo.visible = false;
			addChild(rewardsInfo);
			addToFadeList(rewardsInfo);
			
			Game.addEventListener(ConnectionManager.LIVE_EVENT_LEADERBOARDS_OK_EVENT, liveEventLeaderboardsOkEventHandler);
			
			centerOnPlayer = true;
			requestLeaderboards();
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			updateTime();
		}
		
		override public function resize():void
		{
			super.resize();
			
			var layout:VerticalLayout = list.layout as VerticalLayout;

			var viewsGap:int = 12 * pxScale;
			var topViewsHeight:Number = 17 * pxScale + starTitle.height + viewsGap + topContainer.height + viewsGap;
			
			var freeHeight:Number = background.height - topViewsHeight - bottomContainer.height - viewsGap;
			var calculatedRowsCount:int = Math.max(5, Math.floor(freeHeight / (layout.typicalItem.height + layout.gap)));
		
			starTitle.y = background.y + 17 * pxScale + starTitle.pivotY;
			
			list.height = calculatedRowsCount * (layout.typicalItem.height + layout.gap) + layout.paddingTop + layout.paddingBottom - 14*pxScale;
			list.y = background.y + topViewsHeight + (freeHeight - list.height)/2;
			backImage.height = list.height + 1*pxScale;
			backImage.y = list.y - 0.5*pxScale;
			
			topContainer.y = starTitle.y + starTitle.pivotY + (list.y - starTitle.y - starTitle.pivotY - topContainer.height)/2 - 7*pxScale;
			bottomContainer.y = backImage.y + backImage.height + (background.height - backImage.y - backImage.height - bottomContainer.height + background.y) / 2;
			
			switchModeButton.y = topContainer.y - 17*pxScale;
			infoButton.y = bottomContainer.y - 3 * pxScale;
			
			//trace(background.height - backImage.y - backImage.height - bottomContainer.height, background.height - backImage.y - backImage.height);
			
			closeButton.y = starTitle.y;
		}
		
		private function infoButton_triggeredHandler(e:Event):void 
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			
			if (list.visible)
			{
				list.visible = false;
				topContainer.visible = false;
				//bottomContainer.visible = false;
				rewardsInfo.visible = true;
				backImage.visible = false;
				switchModeButton.visible = false;
			}
			else
			{
				topContainer.visible = true;
				//bottomContainer.visible = true;
				list.visible = true;
				rewardsInfo.visible = false;
				backImage.visible = true;
				switchModeButton.visible = true;
			}
		}
		
		private function updateTime():void 
		{
			var timeLeft:Number = gameManager.tournamentData.endsAt - TimeService.serverTimeMs;
			if (timeLeft < 0)
				timeLeft = 0;
			
			timeLeftValueLabel.text = StringUtils.formatTime(int(timeLeft/1000));
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			updateTime();
		}
		
		private function switchModeButton_changeHandler(e:Event):void 
		{
			loadingAnimation.visible = true;
			loadingAnimation.playTimeline('loading_white', true, true, 24);
			
			positionData.removeAll();
			if (switchModeButton.isSelected)
			{
				requestLeaderboards(1, 25, false);
			}
			else
			{
				centerOnPlayer = true;
				requestLeaderboards(-1, -1, true);
			}
		}
		
		private function liveEventLeaderboardsOkEventHandler(e:Event, u:Boolean = false):void 
		{
			loadingAnimation.visible = false;
			loadingAnimation.stop();
			
			var liveEventLeaderboardsOkMessage:LiveEventLeaderboardsOkMessage = e.data as LiveEventLeaderboardsOkMessage;
			totalListLength = liveEventLeaderboardsOkMessage.total.toNumber();
			
			if (liveEventLeaderboardsOkMessage)
			{
				appendToList(liveEventLeaderboardsOkMessage.positions);
			}
			
			list.validate();
			
			updatePlayerInfo();
			
			
			if (centerOnPlayer)
			{
				if (playerRank == -1)
				{
					list.verticalScrollPosition = list.maxVerticalScrollPosition;
				}
				else
				{
					list.scrollToDisplayIndex(playerRank - minRankInList);
				}
			}
			else
			{
				adjustListScroll(scrollDiff);
			}
			
			centerOnPlayer = false;
			requestInProgress = false;
		}
		
		private function updatePlayerInfo():void 
		{
			if (playerRank != -1)
			{
				ownRankValueLabel.text = "#" + playerRank.toString();
			}
			else
			{
				ownRankValueLabel.text = "";
			}
			
			if (playerLeague)
			{
				var leagueColor:uint = 0xffffff;
				switch(playerLeague.name)
				{
					case "gold":
						leagueColor = 0xf7eb11;
						break;
					case "silver":
						leagueColor = 0xb4ebff;
						break;
					case "bronze":
						leagueColor = 0xf5a854;
						break;
					case "intro":
						leagueColor = 0xf8a5ff;
						break;
				}
				leagueValueLabel.textStyle = XTextFieldStyle.getWalrus(26, leagueColor , Align.LEFT);
				leagueValueLabel.text = playerLeague.name.toUpperCase();
				leagueDescriptionLabel.text = playerLeague.description;
				
				leagueRewards.rewardList = playerLeague.rewards;
			}
		}
		
		private function adjustListScroll(scrollDiff:int):void 
		{
			list.stopScrolling();
			list.verticalScrollPosition += scrollDiff * 93 * pxScale;
		}
		
		private function appendToList(positions:Array):void 
		{
			minRankInList = positionData.length > 0 ? (positionData.getItemAt(0) as LiveEventLeaderboardPosition).rank : -1;
			maxRankInList = positionData.length > 0 ? (positionData.getItemAt(positionData.length - 1) as LiveEventLeaderboardPosition).rank : -1;
			
			var prependPositions:Array = [];
			var appendPositions:Array = [];
			for (var i:int = 0; i < positions.length; i++) 
			{
				var leaderboardPositionData:LiveEventLeaderboardPosition = new LiveEventLeaderboardPosition(positions[i]);
				var d:LiveEventLeaderboardPositionMessage = positions[i] as LiveEventLeaderboardPositionMessage;
				//trace(i, ' ', d.player.firstName, d.liveEventRank, d.liveEventScore);
				if (leaderboardPositionData.playerId == Player.current.playerId)
				{
					playerLeague = gameManager.tournamentData.getLeagueByName(leaderboardPositionData.league);
					playerRank = leaderboardPositionData.rank;
				}
				if (minRankInList != -1)
				{
					if (leaderboardPositionData.rank < minRankInList)
					{
						prependPositions.push(leaderboardPositionData);
					}
					else if (leaderboardPositionData.rank > maxRankInList)
					{
						appendPositions.push(leaderboardPositionData);
					}
					else
					{
						positionData.setItemAt(leaderboardPositionData, leaderboardPositionData.rank - minRankInList);
					}
				}
				else
				{
					positionData.addItem(leaderboardPositionData);
				}
			}
			
			scrollDiff = 0;
			
			if (prependPositions.length > 0)
			{
				positionData.addAllAt(new ListCollection(prependPositions), 0);
				
				scrollDiff = prependPositions.length;
			}
			
			if (appendPositions.length > 0)
			{
				positionData.addAllAt(new ListCollection(appendPositions), positionData.length);
				//scrollDiff = -appendPositions.length;
			}
			
			minRankInList = positionData.length > 0 ? (positionData.getItemAt(0) as LiveEventLeaderboardPosition).rank : -1;
			maxRankInList = positionData.length > 0 ? (positionData.getItemAt(positionData.length - 1) as LiveEventLeaderboardPosition).rank : -1;
		}
		
		override protected function feathersControl_removedFromStageHandler(event:Event):void 
		{
			super.feathersControl_removedFromStageHandler(event);
			Game.removeEventListener(ConnectionManager.LIVE_EVENT_LEADERBOARDS_OK_EVENT, liveEventLeaderboardsOkEventHandler);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_STATE))
			{
				switchModeButton.isEnabled = !requestInProgress;
			}
		}

		/*
		private function onViewTopOrMeBtnClick(e:Event):void
		{
			if (!requestInProgress)
			{
				list.stopScrolling();
				if (mViewTopOrMeBtnShouldShowTop)
				{
					requestTopLeaderboardsAndProbablyShow();
					mViewTopOrMeBtnShouldShowTop = false;
					mViewTopOrMeLabel.text = "My rank";
				}
				else
				{
					requestLeaderboardsWithMeAndProbablyShow();
					mViewTopOrMeBtnShouldShowTop = true;
					mViewTopOrMeLabel.text = "Go to top";
				}
			}
		}
		*/
		
		private function list_scrollHandler(e:Event):void 
		{
			if (requestInProgress)
				return;
				
			var from:int = -1;
			var to:int = -1;
			if (list.verticalScrollPosition < 0 && minRankInList > 1)
			{
				to = minRankInList - 1;
				if (to < 1)
				{
					return;
				}
				
				from = minRankInList - LEADERBOARD_POSITIONS_COUNT_PER_FETCH;
				from = Math.max(1, from);
			}
			else if (list.verticalScrollPosition > list.maxVerticalScrollPosition && maxRankInList < totalListLength)
			{
				from = maxRankInList + 1;
				to = maxRankInList + LEADERBOARD_POSITIONS_COUNT_PER_FETCH;
			}
			else
			{
				return;
			}
			requestLeaderboards(from, to);
		}
		
		private function requestLeaderboards(fromPosition:int = -1, toPosition:int = -1, centered:Boolean = false):void
		{
			requestInProgress = true;
			
			//Starling.juggler.delayCall(Game.connectionManager.sendLiveEventLeaderboardsMessage, 1, -1, fromPosition, toPosition, true);
			Game.connectionManager.sendLiveEventLeaderboardsMessage(-1, fromPosition, toPosition, true);
		}
		
		private function getButtonSkin(texture:Texture, gapHorisontal:uint = 10, gapVertical:uint = 10, shiftY:int = 0):Sprite 
		{
			var sprite:Sprite = new Sprite();
			var quad:Quad = new Quad(1, 1, 0x00FF00);
			var image:Image = new Image(texture);
			
			sprite.addChild(quad);
			sprite.addChild(image);
			
			quad.alpha = 0.0;
			quad.width = image.width + 2 * gapHorisontal * pxScale;
			quad.height = image.height + 2 * gapVertical * pxScale;
			
			image.x = gapHorisontal * pxScale;
			image.y = (gapVertical + shiftY) * pxScale;
			
			return sprite;
		}
	}
}