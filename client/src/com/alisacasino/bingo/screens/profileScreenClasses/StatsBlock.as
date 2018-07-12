package com.alisacasino.bingo.screens.profileScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.StarTitle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.UIUtils;
	import com.alisacasino.bingo.utils.tooltips.TooltipTrigger;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import feathers.layout.HorizontalLayout;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class StatsBlock extends FeathersControl
	{
		private var badgeGroup:LayoutGroup;
		
		private var statsTitle:StarTitle;
		
		public function StatsBlock() 
		{
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			var statsBackground:Image = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/collections/card_background"));
			statsBackground.alpha = 0.2;
			statsBackground.scale9Grid = ResizeUtils.getScaledRect(16, 16, 8, 8);
			statsBackground.width = 598 * pxScale;
			statsBackground.height = 333 * pxScale;
			addChild(statsBackground);
			
			statsTitle = new StarTitle("PLAYER STATS", XTextFieldStyle.getWalrus(38, 0x00ccff), 8, 0, -4, starTitleActivateCallback);
			statsTitle.alignPivot(Align.CENTER, Align.TOP);
			statsTitle.x = 306 * pxScale;
			statsTitle.y = 14 * pxScale;
			addChild(statsTitle);
			
			if (!Player.current)
				return;
				
			addStat(0, "PLAYED GAMES:", Player.current.gamesCount.toString());
			addStat(1, "COLLECTED BINGOS:", Player.current.bingosCount.toString());
			
			var winString:String = "-";
			if (Player.current.gamesCount > 0)
			{
				var winPercentage:Number = Math.round((Player.current.bingosCount / Player.current.gamesCount * 100));
				winString = winPercentage.toFixed(0) + "%";
			}
			addStat(2, "WIN PERCENTAGE:", winString);
			addStat(3, "CHESTS OPENED:", Player.current.chestsOpened.toString());
			
			var badgeLayout:HorizontalLayout = new HorizontalLayout();
			badgeLayout.gap = 40 * pxScale;
			badgeGroup = new LayoutGroup();
			badgeGroup.layout = badgeLayout;
			badgeGroup.x = 24 * pxScale;
			badgeGroup.y = 242 * pxScale;
			addChild(badgeGroup);
			
			addBadge(AtlasAsset.CommonAtlas.getTexture("dialogs/profile/gold_medal"), Player.current.tournamentFirstPlaces.toString(), 0.6, Constants.GOLD_BADGE_TOOLTIP);
			addBadge(AtlasAsset.CommonAtlas.getTexture("dialogs/profile/silver_medal"), Player.current.tournamentSecondPlaces.toString(), 0.7, Constants.SILVER_BADGE_TOOLTIP);
			addBadge(AtlasAsset.CommonAtlas.getTexture("dialogs/profile/bronze_medal"), Player.current.tournamentThirdPlaces.toString(), 0.8, Constants.BRONZE_BADGE_TOOLTIP);
			
			
			TweenHelper.tween(statsTitle, 0.15, {delay: 0.2, y:statsTitle.y + 40 * pxScale, transition:Transitions.EASE_OUT } )
				.chain(statsTitle, 0.05, { y:statsTitle.y, transition:Transitions.EASE_OUT } );
		}
		
		private function addBadge(texture:Texture, valueText:String, delay:Number, tooltipText:String):void 
		{
			var badgeContainer:Sprite = new Sprite();
			
			
			var image:Image = new Image(texture);
			image.scale = 0.55;
			var imageContainer:Sprite = new Sprite();
			imageContainer.addChild(image);
			UIUtils.alignPivotAndMove(imageContainer);
			badgeContainer.addChild(imageContainer);
			
			var label:XTextField = new XTextField(1, 1, XTextFieldStyle.getChateaudeGarage(36), valueText);
			label.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			label.x = 70 * pxScale;
			label.y = 12 * pxScale;
			label.redraw();
			
			
			var quad:Quad = new Quad(label.x + label.width, 1, 0x0);
			quad.alpha = 0;
			badgeContainer.addChild(quad);
			
			UIUtils.alignPivotAndMove(label);
			badgeContainer.addChild(label);
			
			badgeGroup.addChild(badgeContainer);
			
			var tooltipTrigger:TooltipTrigger = new TooltipTrigger(badgeContainer.width, badgeContainer.height, tooltipText);
			badgeContainer.addChild(tooltipTrigger);
			
			makePopTween(imageContainer, delay);
			makePopTween(label, delay + 0.1);
		}
		
		
		
		private function addStat(index:int, labelText:String, valueText:String):void 
		{
			var label:XTextField = new XTextField(1, 1, XTextFieldStyle.getChateaudeGarage(28), labelText);
			label.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			label.y = (71 + 41  * index) * pxScale;
			addChild(label);
			label.redraw();
			var targetLabelX:Number = 21 * pxScale;
			
			var valueLabel:XTextField = new XTextField(1, 1, XTextFieldStyle.getChateaudeGarage(28, 0xfff000), valueText);
			valueLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			valueLabel.y = label.y
			addChild(valueLabel);
			var targetValueLabelX:Number = label.x + label.width + 34 * pxScale;
			
			var animDelay:Number = 0.6 + 0.05 * index;
			
			label.alpha = 0;
			label.x = targetLabelX - 50 * pxScale;
			Starling.juggler.tween(label, 0.3, { delay: animDelay, alpha:1, x:targetLabelX, transition:Transitions.EASE_OUT } );
		
			valueLabel.alpha = 0;
			valueLabel.x = targetValueLabelX - 50 * pxScale;
			Starling.juggler.tween(valueLabel, 0.3, { delay: animDelay, alpha:1, x:targetValueLabelX, transition:Transitions.EASE_OUT } );
		}
		
		protected function makePopTween(target:DisplayObject, delay:Number):void
		{
			target.scale = 0;
			TweenHelper.tween(target, 0.2, { delay: delay, scale: 1.2, transition: Transitions.EASE_OUT } )
				.chain(target, 0.15, { scale: 1, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
		}
		
		private function starTitleActivateCallback():void {
			if (statsTitle) 
				statsTitle.alignPivot(Align.CENTER, Align.TOP);
		}		
		
	}

}