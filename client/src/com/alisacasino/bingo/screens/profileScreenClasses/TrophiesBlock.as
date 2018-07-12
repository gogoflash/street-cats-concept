package com.alisacasino.bingo.screens.profileScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.StarTitle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.collections.Collection;
	import com.alisacasino.bingo.models.collections.CollectionPage;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import starling.animation.Transitions;
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
	public class TrophiesBlock extends FeathersControl
	{
		
		public function TrophiesBlock() 
		{
			
		}
		
		private var trophiesTitle:StarTitle;
		
		override protected function initialize():void 
		{
			super.initialize();
			
			var statsBackground:Image = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/collections/card_background"));
			statsBackground.alpha = 0.2;
			statsBackground.scale9Grid = ResizeUtils.getScaledRect(16, 16, 8, 8);
			statsBackground.width = 598 * pxScale;
			statsBackground.height = 333 * pxScale;
			addChild(statsBackground);
			
			setSizeInternal(statsBackground.width, statsBackground.height, false);
			
			trophiesTitle = new StarTitle("TROPHIES", XTextFieldStyle.getWalrus(38, 0xffc000), 8, 0, -4, starTitleActivateCallback);
			trophiesTitle.alignPivot(Align.CENTER, Align.TOP);
			trophiesTitle.x = 306 * pxScale;
			trophiesTitle.y = 14 * pxScale;
			addChild(trophiesTitle);
			
			var trophiesLayout:HorizontalLayout = new HorizontalLayout();
			trophiesLayout.paddingLeft = statsBackground.width;
			trophiesLayout.paddingRight = 42 * pxScale;
			
			var trophiesList:List = new List();
			trophiesList.y = 80 * pxScale;
			trophiesList.layout = trophiesLayout;
			trophiesList.itemRendererType = TrophyRenderer;
			trophiesList.setSize(statsBackground.width, 250 * pxScale);
			addChild(trophiesList);
			
			var maskQuad:Quad = new Quad(statsBackground.width, statsBackground.height);
			mask = maskQuad;
			
			var pageData:ListCollection = new ListCollection();
			
			for each (var item:Collection in gameManager.collectionsData.collectionList) 
			{
				for each (var page:CollectionPage in item.pages) 
				{
					if (!page.comingSoon && page.completed)
					{
						pageData.addItem(page);
					}
				}
			}
			for each (item in gameManager.collectionsData.collectionList) 
			{
				for each (page in item.pages) 
				{
					if (!page.comingSoon && !page.completed)
					{
						pageData.addItem(page);
					}
				}
			}
			
			
			trophiesList.dataProvider = pageData;
			trophiesLayout.gap = 160 * pxScale;
			TweenHelper.tween(trophiesLayout, 0.6, {delay: 0.4, paddingLeft: 42*pxScale, gap:18*pxScale, transition:Transitions.EASE_OUT_BACK } )
			
			TweenHelper.tween(trophiesTitle, 0.15, {delay: 0.2, y:trophiesTitle.y + 40 * pxScale, transition:Transitions.EASE_OUT } )
				.chain(trophiesTitle, 0.05, { y:trophiesTitle.y, transition:Transitions.EASE_OUT } );
		}
		
		private function starTitleActivateCallback():void {
			if (trophiesTitle) 
				trophiesTitle.alignPivot(Align.CENTER, Align.TOP);
		}
		
	}

}
import com.alisacasino.bingo.assets.AnimationContainer;
import com.alisacasino.bingo.assets.ImageAsset;
import com.alisacasino.bingo.assets.MovieClipAsset;
import com.alisacasino.bingo.controls.AnimatedImageAssetContainer;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import com.alisacasino.bingo.models.collections.Collection;
import com.alisacasino.bingo.models.collections.CollectionPage;
import com.alisacasino.bingo.protocol.ModificatorMessage;
import com.alisacasino.bingo.protocol.ModificatorType;
import com.alisacasino.bingo.utils.tooltips.TooltipTrigger;
import feathers.controls.LayoutGroup;
import feathers.controls.renderers.LayoutGroupListItemRenderer;
import feathers.core.FeathersControl;
import starling.display.Image;
import starling.display.Quad;
import starling.filters.ColorMatrixFilter;

class TrophyRenderer extends LayoutGroupListItemRenderer
{
	private var image:AnimatedImageAssetContainer;
	private var collectionNameLabel:XTextField;
	private var tooltipTrigger:TooltipTrigger;
	public function TrophyRenderer() 
	{
		super();
	}
	
	override protected function initialize():void 
	{
		super.initialize();
		
		
		
		image = new AnimatedImageAssetContainer();
		
		var loadingSkin:LayoutGroup = new LayoutGroup();
		loadingSkin.setSize(144 * pxScale, 190 * pxScale);
		var loadingAnimation:AnimationContainer = new AnimationContainer(MovieClipAsset.PackBase);
		loadingAnimation.pivotX = 42 * pxScale;
		loadingAnimation.pivotY = 42 * pxScale;
		loadingAnimation.scale = 0.6;
		loadingAnimation.move(72 * pxScale, 90 * pxScale);
		loadingAnimation.playTimeline('loading_white', false, true, 24);
		loadingSkin.addChild(loadingAnimation);
		
		image.loadingSkin = loadingSkin;
		
		image.setSize(144 * pxScale, 190 * pxScale);
		addChild(image);
		
		
		
		collectionNameLabel = new XTextField(1, 1, XTextFieldStyle.getWalrus(28, 0xffe400));
		collectionNameLabel.autoScale = true;
		collectionNameLabel.width = 144 * pxScale;
		collectionNameLabel.height = 40 * pxScale;
		collectionNameLabel.y = 200 * pxScale;
		addChild(collectionNameLabel);
		
		tooltipTrigger = new TooltipTrigger(144 * pxScale, 240 * pxScale, "");
		addChild(tooltipTrigger);
		
		setSizeInternal(144 * pxScale, 240 * pxScale, false);
	}
	
	override protected function draw():void 
	{
		super.draw();
		
		if (isInvalid(INVALIDATION_FLAG_DATA))
		{
			if (collectionPage)
			{
				if (collectionPage.completed)
				{
					image.filter = null;
				}
				else
				{
					var bwFilter:ColorMatrixFilter = new ColorMatrixFilter();
					bwFilter.adjustSaturation( -1);
					image.filter = bwFilter;
				}
				image.source = collectionPage.trophyImage;
				collectionNameLabel.text = collectionPage.name.toUpperCase();
				
				
				updateTooltipToBonus(collectionPage.collection.name, collectionPage.getPermanentEffect());
				
			}
			else
			{
				image.source = null;
				tooltipTrigger.text = "";
			}
			
		}
	}
	
	private function updateTooltipToBonus(name:String, permanentEffect:ModificatorMessage):void 
	{
		if (!permanentEffect)
		{
			tooltipTrigger.text = "";
			return;
		}
		
		var text:String = "Trophy grants permanent bonus:\n";
		switch(permanentEffect.type)
		{
			case ModificatorType.CASH_MOD:
				text += "<font color=\"#c42de8\">+" + permanentEffect.quantity + "% cash bonus</font>";
				break;
			case ModificatorType.DISCOUNT_MOD:
				text += "<font color=\"#54c300\">+" + permanentEffect.quantity + "% discount on cards</font>";
				break;
			case ModificatorType.EXP_MOD:
				text += "<font color=\"#00b8ff\">+" + permanentEffect.quantity + "% extra xp payouts</font>";
				break;
			case ModificatorType.SCORE_MOD:
				text += "<font color=\"#ff59d6\">+" + permanentEffect.quantity + "% extra point winnings</font>";
				break;
		}
		text += " (" + name + " TOURNEY)";
		tooltipTrigger.text = text;
	}
	
	public function get collectionPage():CollectionPage
	{
		return _data as CollectionPage;
	}
}