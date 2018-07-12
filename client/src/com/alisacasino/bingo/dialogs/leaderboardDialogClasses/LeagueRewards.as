package com.alisacasino.bingo.dialogs.leaderboardDialogClasses 
{
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.Type;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import feathers.layout.HorizontalLayout;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class LeagueRewards extends FeathersControl
	{
		private var _rewardList:Array;
		
		public function get rewardList():Array 
		{
			return _rewardList;
		}
		
		public function set rewardList(value:Array):void 
		{
			if (_rewardList != value)
			{
				_rewardList = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		private var rewardIconsContainer:LayoutGroup;
		
		public function LeagueRewards() 
		{
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			rewardIconsContainer = new LayoutGroup();
			var rewardIconsLayout:HorizontalLayout = new HorizontalLayout();
			rewardIconsLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			rewardIconsLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			rewardIconsLayout.gap = 4 * pxScale;
			rewardIconsContainer.layout = rewardIconsLayout;
			addChild(rewardIconsContainer)
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				setContents();
			}
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				rewardIconsContainer.setSize(actualWidth, actualHeight);
			}
		}
		
		private function setContents():void 
		{
			rewardIconsContainer.removeChildren();
			
			var cashReward:CommodityItemMessage;
			var powerupReward:CommodityItemMessage;
			
			if (!rewardList)
			{
				cashReward = new CommodityItemMessage();
				cashReward.type = Type.CASH;
				rewardIconsContainer.addChild(new RewardRenderer(cashReward, true));
				
				powerupReward = new CommodityItemMessage();
				powerupReward.type = Type.POWERUP;
				rewardIconsContainer.addChild(new RewardRenderer(powerupReward, true));
				return;
			}
			
			for each (var item:CommodityItemMessage in rewardList) 
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
				rewardIconsContainer.addChild(new RewardRenderer(cashReward));
			
			if (powerupReward)
				rewardIconsContainer.addChild(new RewardRenderer(powerupReward));
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

class RewardRenderer extends Sprite
{
	private var temporary:Boolean;
	
	public function RewardRenderer(commodityItemMessage:CommodityItemMessage, temporary:Boolean = false) 
	{
		super();
		this.temporary = temporary;
		setContent(commodityItemMessage);
	}
	
	public function setContent(commodityItemMessage:CommodityItemMessage):void
	{
		var texture:Texture;
		
		if (commodityItemMessage.type == Type.CASH)
			texture = AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/cash_small");
		else
			texture = AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/energy_small");
		
		var icon:Image = new Image(texture);
		addChild(icon);
		
		var label:XTextField = new XTextField(1, 1, XTextFieldStyle.getChateaudeGarage(26, 0xffffff));
		
		if (temporary)
		{
			label.text = "??";
		}
		else
		{
			label.text = commodityItemMessage.quantity.toString()
		}
		
		label.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
		label.x = 34 * pxScale;
		label.redraw();
		addChild(label);
	}
	
}