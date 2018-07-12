package com.alisacasino.bingo.components 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class CardsIconView extends Sprite 
	{
		public static const COLOR_BLUE:int = 1;
		public static const COLOR_ORANGE:int = 2;
		
		public static const ONE_CARD:int = 1;
		public static const ONE_FLAMED_CARD:int = 2;
		public static const TWO_CARDS:int = 3;
		public static const TWO_FLAMED_CARDS:int = 4;
		public static const TWO_MINI_CARDS_QUERY_MARK:int = 5;
		public static const TWO_MINI_CARDS_QUERY_MARK_2:int = 6;
		
		private var countTextField:XTextField;
		private var bottomCard:Image;
		private var topCard:Image;
		
		private var _type:int;
		private var _count:int;
		private var _cardColorType:int;
		
		public function CardsIconView(type:int, cardColorType:int, count:int = -1) 
		{
			super();
			_type = type;
			_cardColorType = cardColorType;
			//_count = count;
			
			var iconTexture:Texture = AtlasAsset.CommonAtlas.getTexture(cardColorType == COLOR_BLUE ? "icons/card_blue" : "icons/card_orange");
			var isQueryMarkTypes:Boolean = _type == TWO_MINI_CARDS_QUERY_MARK || _type == TWO_MINI_CARDS_QUERY_MARK_2;
			
			if (_type == TWO_FLAMED_CARDS || _type == TWO_CARDS || isQueryMarkTypes) {
				bottomCard = new Image(iconTexture);
				bottomCard.alignPivot();
				bottomCard.x = 40 * pxScale;
				bottomCard.y = 82 * pxScale;
				bottomCard.rotation = -10.5 * Math.PI / 180;
				addChild(bottomCard);
			}
			
			topCard = new Image(iconTexture);
			topCard.x = 20 * pxScale;
			topCard.y = 37 * pxScale;
			
			if (_type == TWO_FLAMED_CARDS || _type == ONE_FLAMED_CARD) {
				var flare:Image = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/inventory/flare_back"));
				flare.x = 9 * pxScale;
				addChild(flare);
				
				addChild(topCard);
				
				var flareTop:Image = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/inventory/flare_front"));
				flareTop.x = 29 * pxScale;
				flareTop.y = 18 * pxScale;
				addChild(flareTop);
			}
			else {
				addChild(topCard);
			}
			
			this.count = count;
			
			if (isQueryMarkTypes) 
			{
				bottomCard.x = 0;
				bottomCard.y = 0;
				bottomCard.scale = 0.8;
				
				topCard.scale = 0.8;
				
				countTextField = new XTextField(60* pxScale, 60* pxScale, XTextFieldStyle.getWalrus(50).addStroke(0.7, 0), '?');
				//countTextField.border = true;
				//countTextField.text = value;
				countTextField.alignPivot();
				countTextField.x = 11 * pxScale;
				countTextField.y = 0 * pxScale;
				
				addChild(countTextField);
				
				if (_type == TWO_MINI_CARDS_QUERY_MARK) 
				{
					bottomCard.rotation = -2 * Math.PI / 180;
					topCard.rotation = 11 * Math.PI / 180;
					countTextField.rotation = 11 * Math.PI / 180;
					topCard.x = -8 * pxScale;
					topCard.y = -40 * pxScale;
				}
				else 
				{
					bottomCard.rotation = -12 * Math.PI / 180;
					topCard.x = -16 * pxScale;
					topCard.y = -36 * pxScale;
				}
			}	
		}
		
		public function set count(value:int):void 
		{
			if (_count == value)
				return;
				
			_count = value;	
			
			if (_count >= 0) 
			{
				if (!countTextField) {
					countTextField = new XTextField(80* pxScale, 80* pxScale, _count < 10 ? XTextFieldStyle.CardsIconViewBig : XTextFieldStyle.CardsIconViewSmall, _count.toString());
					//countTextField.border = true;
					//countTextField.text = value;
					countTextField.alignPivot();
					countTextField.x = 52 * pxScale;
					countTextField.y = 79 * pxScale;
					addChild(countTextField);
				}
				else {
					countTextField.textStyle = _count < 10 ? XTextFieldStyle.CardsIconViewBig : XTextFieldStyle.CardsIconViewSmall;
					countTextField.text = _count.toString();
				}
			}
			else {
				if (countTextField) {
					countTextField.removeFromParent(true);
					countTextField = null;
				}
			}
		}
		
		public function get count():int {
			return _count;	
		}
		
		public function set cardColorType(value:int):void 
		{
			if (_cardColorType == value)
				return;
			
			_cardColorType = value;	
				
			var iconTexture:Texture = AtlasAsset.CommonAtlas.getTexture(_cardColorType == COLOR_BLUE ? "icons/card_blue" : "icons/card_orange");
			
			if (topCard)
				topCard.texture = iconTexture;
				
			if (bottomCard)
				bottomCard.texture = iconTexture;
		}		
	}

}