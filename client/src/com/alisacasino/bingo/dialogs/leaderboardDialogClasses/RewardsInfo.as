package com.alisacasino.bingo.dialogs.leaderboardDialogClasses 
{
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import feathers.controls.List;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class RewardsInfo extends FeathersControl
	{
		private var list:List;
		
		public function RewardsInfo() 
		{
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			var myRankLabel:XTextField = new XTextField(300 * pxScale, 60 * pxScale, XTextFieldStyle.getWalrus(42, 0x36ff00), "REWARDS");
			myRankLabel.x = 260 * pxScale;
			myRankLabel.y = 92 * pxScale;
			addChild(myRankLabel);
			
			list = new List();
			
			var rewardsCollection:ListCollection = new ListCollection();
			rewardsCollection.addItem(gameManager.tournamentData.getLeagueByName("1st"));
			rewardsCollection.addItem(gameManager.tournamentData.getLeagueByName("2nd"));
			rewardsCollection.addItem(gameManager.tournamentData.getLeagueByName("3rd"));
			rewardsCollection.addItem(gameManager.tournamentData.getLeagueByName("gold"));
			rewardsCollection.addItem(gameManager.tournamentData.getLeagueByName("silver"));
			rewardsCollection.addItem(gameManager.tournamentData.getLeagueByName("bronze"));
			
			list.dataProvider = rewardsCollection;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 10 * pxScale;
			layout.paddingTop = 16 * pxScale;
			layout.paddingBottom = 11 * pxScale;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.scrollPositionVerticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			list.layout = layout;
			list.x = 6 * pxScale;
			list.y = 154 * pxScale;
			list.setSize(800 * pxScale, 470 * pxScale);	
			list.itemRendererType = RewardItemRenderer;
			addChild(list);
		}
		
	}

}