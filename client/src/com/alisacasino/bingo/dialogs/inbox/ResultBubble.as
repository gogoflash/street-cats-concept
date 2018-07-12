package com.alisacasino.bingo.dialogs.inbox 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.gifts.AccumulatedGiftContents;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import feathers.layout.HorizontalLayout;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ResultBubble extends FeathersControl
	{
		private var _giftContent:AccumulatedGiftContents;
		
		public function get giftContent():AccumulatedGiftContents 
		{
			return _giftContent;
		}
		
		public function set giftContent(value:AccumulatedGiftContents):void 
		{
			if (_giftContent != value)
			{
				_giftContent = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		private var background:Image;
		private var rewardIconsContainer:LayoutGroup;
		
		public function ResultBubble() 
		{
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			background = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/bubble_body"));
			background.scale9Grid = new Rectangle(72 * pxScale, 27 * pxScale, 2 * pxScale, 5 * pxScale);
			background.height = 130 * pxScale;
			background.y = -background.height;
			addChild(background);
			
			var bubbleTail:Image = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/bubble_tail"));
			bubbleTail.alignPivot();
			addChild(bubbleTail);
			
			rewardIconsContainer = new LayoutGroup();
			var rewardIconsLayout:HorizontalLayout = new HorizontalLayout();
			rewardIconsLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			rewardIconsLayout.gap = 24 * pxScale;
			rewardIconsContainer.layout = rewardIconsLayout;
			addChild(rewardIconsContainer);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				rewardIconsContainer.removeChildren();
				
				addIconIfExists(CommodityType.TICKET, giftContent);
				addIconIfExists(CommodityType.CASH, giftContent);
				addIconIfExists(CommodityType.ENERGY, giftContent);
				addIconIfExists(CommodityType.KEY, giftContent);
				addIconIfExists(CommodityType.SLOT_MACHINE_GIFT_SPIN, giftContent);
				addIconIfExists(CommodityType.SCORE, giftContent);
			}
			
			rewardIconsContainer.validate();
			
			rewardIconsContainer.x = -rewardIconsContainer.width / 2;
			rewardIconsContainer.y = background.y + background.height / 2;
			
			background.width = rewardIconsContainer.width + 50 * pxScale;
			background.x = -background.width / 2 + 4*pxScale;
		}
		
		private function addIconIfExists(commodityType:String, giftContent:AccumulatedGiftContents):void 
		{
			var quantity:int = giftContent.getCommodityQuantity(commodityType);
			
			if (quantity < 1)
			{
				return;
			}
			
			var giftComponentRenderer:GiftComponentRenderer = new GiftComponentRenderer();
			giftComponentRenderer.commodityType = commodityType;
			giftComponentRenderer.quantity = quantity;
			rewardIconsContainer.addChild(giftComponentRenderer);
			
			giftComponentRenderer.validate();
		}
		
	}

}
import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import com.alisacasino.bingo.models.universal.CommodityItem;
import feathers.core.FeathersControl;
import starling.display.Image;
import starling.text.TextFieldAutoSize;
import starling.utils.Align;
;

class GiftComponentRenderer extends FeathersControl
{
	
	private var winningsIcon:Image;
	private var winningsLabel:XTextField;
	
	private var _commodityType:String;
	
	public function get commodityType():String 
	{
		return _commodityType;
	}
	
	public function set commodityType(value:String):void 
	{
		if (_commodityType != value)
		{
			_commodityType = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}
	}
	
	private var _quantity:int;
	
	public function get quantity():int 
	{
		return _quantity;
	}
	
	public function set quantity(value:int):void 
	{
		if (_quantity != value)
		{
			_quantity = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}
	}
	
	public function GiftComponentRenderer() 
	{
		super();
	}
	
	override protected function initialize():void 
	{
		super.initialize();
		
		winningsIcon = new Image(AtlasAsset.getEmptyTexture());
		winningsIcon.scale = 0.7;
		addChild(winningsIcon);
		
		winningsLabel = new XTextField(100, 0, XTextFieldStyle.SlotMachineGoldPlaqueLabelStyle, "");
		winningsLabel.autoScale = false;
		winningsLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
		addChild(winningsLabel);
	}
	
	override protected function draw():void 
	{
		super.draw();
		
		winningsLabel.text = quantity.toString();
		winningsLabel.redraw();
		winningsIcon.texture = CommodityItem.getCommodityItemTexture(commodityType);
		winningsIcon.readjustSize();
		winningsIcon.alignPivot(Align.LEFT);
		
		winningsLabel.x = winningsIcon.x + winningsIcon.width + 10 * pxScale;
		winningsLabel.y = -winningsLabel.height / 2 - 6 * pxScale;
		sosTrace( "winningsLabel.y : " + winningsLabel.y );
		
		setSizeInternal(winningsLabel.x + winningsLabel.width, 0, false);
	}
}