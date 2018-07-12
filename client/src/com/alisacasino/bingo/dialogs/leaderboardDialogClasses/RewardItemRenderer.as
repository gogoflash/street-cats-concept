package com.alisacasino.bingo.dialogs.leaderboardDialogClasses
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XImage;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.slots.payoutDialogClasses.RewardRenderer;
	import com.alisacasino.bingo.models.LiveEventLeaderboardPosition;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.tournament.LeagueData;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.GameManager;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import feathers.layout.HorizontalLayout;
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.TokenList;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class RewardItemRenderer extends FeathersControl implements IListItemRenderer
	{
		protected var leagueData:LeagueData;
		private var nameLabel:XTextField;
		private var scoreLabel:XTextField;
		
		public static const ITEM_WIDTH:Number = 758 * pxScale;
		public static const ITEM_HEIGHT:Number = 67 * pxScale;
		
		private var _owner:List;
		private var _index:int = -1;
		private var rankMarker:Image;
		private var nameContainer:Sprite;
		private var rewardIconsContainer:LayoutGroup;
		protected var container:Sprite;
		
		public function RewardItemRenderer()
		{
			super();
			width = ITEM_WIDTH;
			height = ITEM_HEIGHT;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			container = new Sprite();
			addChild(container);
			
			var background:Image = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/reward_cell_background"));
			background.scale9Grid = ResizeUtils.getScaledRect(16, 16, 8, 8);
			background.width = ITEM_WIDTH;
			background.height = ITEM_HEIGHT;
			background.alpha = 0.1;
			container.addChild(background);
			
			rankMarker = new Image(AtlasAsset.getEmptyTexture());
			container.addChild(rankMarker);
			
			nameContainer = new Sprite();
			nameContainer.x = 58 * pxScale;
			nameContainer.y = 15 * pxScale;
			container.addChild(nameContainer);
			
			rewardIconsContainer = new LayoutGroup();
			var rewardIconsLayout:HorizontalLayout = new HorizontalLayout();
			rewardIconsLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_TOP;
			rewardIconsLayout.gap = 8 * pxScale;
			rewardIconsContainer.layout = rewardIconsLayout;
			
			rewardIconsContainer.x = 417 * pxScale;
			rewardIconsContainer.y = 10 * pxScale;
			addChild(rewardIconsContainer)
		}
		
		protected function commitData():void
		{
			var rankMarkerTexture:Texture = AtlasAsset.getEmptyTexture();
			var rankMarkerShift:Number = 0;
			var placeType:Boolean = false;
			var leagueColor:uint = 0xffffff;
			
			switch(leagueData.name)
			{
				case "1st":
					rankMarkerTexture = AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/place_1");
					rankMarkerShift = -14 * pxScale;
					placeType = true;
					leagueColor = 0xf7eb11;
					break;
				case "2nd":
					rankMarkerTexture = AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/place_2");
					rankMarkerShift = -14 * pxScale;
					placeType = true;
					leagueColor = 0xb4ebff;
					break;
				case "3rd":
					rankMarkerTexture = AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/place_3");
					rankMarkerShift = -14 * pxScale;
					placeType = true;
					leagueColor = 0xf5a854;
					break;
				case "gold":
					rankMarkerTexture = AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/gold_league");
					leagueColor = 0xf7eb11;
					break;
				case "silver":
					rankMarkerTexture = AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/silver_league");
					leagueColor = 0xb4ebff;
					break;
				case "bronze":
					rankMarkerTexture = AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/bronze_league");
					leagueColor = 0xf5a854;
					break;
			}
			
			rankMarker.texture = rankMarkerTexture;
			rankMarker.readjustSize();
			rankMarker.x = rankMarkerShift;
			rankMarker.y = rankMarkerShift;
			
			nameContainer.removeChildren();
			
			if (placeType)
			{
				var placeValueLabel:XTextField = new XTextField(1, 1, XTextFieldStyle.getWalrus(30, leagueColor), leagueData.name.toUpperCase());
				placeValueLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				placeValueLabel.redraw();
				nameContainer.addChild(placeValueLabel);
				
				var placeLabel:XTextField = new XTextField(1, 1, XTextFieldStyle.getWalrus(30, 0xffffff), "PLACE");
				placeLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				placeLabel.redraw();
				placeLabel.x = placeValueLabel.width + 6 * pxScale;
				nameContainer.addChild(placeLabel);
			}
			else
			{
				var leagueLabel:XTextField = new XTextField(1, 1, XTextFieldStyle.getWalrus(30, 0xffffff), "LEAGUE:");
				leagueLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				leagueLabel.redraw();
				nameContainer.addChild(leagueLabel);
				
				var leagueValueLabel:XTextField = new XTextField(1, 1, XTextFieldStyle.getWalrus(30, leagueColor), leagueData.name.toUpperCase());
				leagueValueLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				leagueValueLabel.redraw();
				leagueValueLabel.x = leagueLabel.width + 6 * pxScale;
				nameContainer.addChild(leagueValueLabel);
			}
			
			rewardIconsContainer.removeChildren();
			
			var cashReward:CommodityItemMessage;
			var powerupReward:CommodityItemMessage;
			
			for each (var item:CommodityItemMessage in leagueData.rewards) 
			{
				if (item.type == Type.CASH)
				{
					cashReward = item;
				}
				else if (item.type == Type.POWERUP)
				{
					powerupReward = item;
				}
			}
			
			if (cashReward)
				rewardIconsContainer.addChild(new ItemRewardRenderer(cashReward));
			
			if (powerupReward)
				rewardIconsContainer.addChild(new ItemRewardRenderer(powerupReward));
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				commitData();
			}
		}
		
		public function get data():Object
		{
			return leagueData;
		}
		
		public function set data(value:Object):void
		{
			if (leagueData != value)
			{
				leagueData = value as LeagueData;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		
		public function get owner():List
		{
			return _owner;
		}
		
		public function set owner(value:List):void
		{
			_owner = value;
		}
		
		public function get isSelected():Boolean
		{
			return false;
		}
		
		public function set isSelected(value:Boolean):void
		{
		}
		
		protected var _factoryID:String;

		public function get factoryID():String {
			return _factoryID;
		}

		public function set factoryID(value:String):void {
			_factoryID = value;
		}
	}
}

import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import com.alisacasino.bingo.protocol.CommodityItemMessage;
import com.alisacasino.bingo.protocol.Type;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextFieldAutoSize;
import starling.textures.Texture;
import starling.utils.Align;

class ItemRewardRenderer extends Sprite
{
	
	public function ItemRewardRenderer(commodityItemMessage:CommodityItemMessage) 
	{
		super();
		setContent(commodityItemMessage);
	}
	
	public function setContent(commodityItemMessage:CommodityItemMessage):void
	{
		var texture:Texture;
		
		if (commodityItemMessage.type == Type.CASH)
			texture = AtlasAsset.CommonAtlas.getTexture("bars/cash");
		else
			texture = AtlasAsset.CommonAtlas.getTexture("bars/energy");
		
		var icon:Image = new Image(texture);
		icon.scale = 0.65;
		addChild(icon);
		
		var label:XTextField = new XTextField(130*pxScale, 1, XTextFieldStyle.getChateaudeGarage(32, 0xffffff, Align.LEFT), commodityItemMessage.quantity.toString());
		label.autoSize = TextFieldAutoSize.VERTICAL;
		label.x = 52 * pxScale;
		label.y = 3 * pxScale;
		label.redraw();
		addChild(label);
	}
	
}