package com.alisacasino.bingo.dialogs.offers 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.offers.CashIconType;
	import com.alisacasino.bingo.models.offers.OfferItem;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.models.universal.ValueDataTable;
	import starling.display.Sprite;
	import com.alisacasino.bingo.controls.XTextField;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class OfferRewardView extends Sprite 
	{
		private var _item:CommodityItem;
		private var image:Image;
		private var titleLabel:XTextField;
		
		public function OfferRewardView(item:CommodityItem, cashTextureTable:ValueDataTable, smallSize:Boolean = false) 
		{
			super();
			
			//touchable = false;
			_item = item;
			
			var imageTexture:Texture;
			var customScale:Number;
			var imageY:int;
			switch(item.type) 
			{
				case CommodityType.CASH: 
				{
					imageTexture = CashIconType.textureByType(cashTextureTable.getData(item.quantity));
					switch(cashTextureTable.getData(item.quantity)) 
					{
						case CashIconType.CASE: 
						{
							titleLabel = new XTextField(140*pxScale, 50 * pxScale, XTextFieldStyle.getWalrus(52, 0xFFFFFF).setStroke(0.5), item.quantity.toString());
							titleLabel.alignPivot();
							titleLabel.rotation = -10 * Math.PI / 180;
							titleLabel.x = 22*pxScale;
							titleLabel.y = -8*pxScale;
							//titleLabel.border = true;
							customScale = 1;
							
							break;
						}
						case CashIconType.BAG: 
						{
							imageY = -15*pxScale;
							
							titleLabel = new XTextField(imageTexture.width, 50 * pxScale, XTextFieldStyle.getWalrus(52, 0xFFFFFF).setStroke(0.5), item.quantity.toString());
							titleLabel.alignPivot();
							titleLabel.y = 25 * pxScale + imageY;
							customScale = 0.914;
							//titleLabel.border = true;
							
							break;
						}
						case CashIconType.SAFE: 
						{
							//imageY = -15*pxScale;
							
							titleLabel = new XTextField(imageTexture.width, 74 * pxScale, XTextFieldStyle.getWalrus(61, 0xFFFFFF).setStroke(0.5), item.quantity.toString());
							titleLabel.alignPivot();
							titleLabel.y = 20 * pxScale// + imageY;
							
							customScale = 1;
							//titleLabel.border = true;
							
							break;
						}
					}
					
					break;
				}
				case CommodityType.POWERUP_CARD: {
					imageTexture = AtlasAsset.CommonAtlas.getTexture(Powerup.getCardTexture(item.subType));
					break;
				}
				case CommodityType.POWERUP: {
					imageTexture = AtlasAsset.CommonAtlas.getTexture(Powerup.getTexture(item.subType));
					break;
				}
				case CommodityType.COLLECTION: {
					imageTexture = OfferItem.atlasAsset.getTexture('offers/card_collection');
					break;
				}
				case CommodityType.CUSTOMIZER: {
					imageTexture = OfferItem.atlasAsset.getTexture('offers/card_customizer');
					break;
				}
			}
			
			image = new Image(imageTexture || Texture.fromColor(10, 10, 0xFFFF00));
			image.scale = isNaN(customScale) ? ((smallSize ? 170 : 187) * pxScale / image.texture.frameHeight) : customScale;
			image.alignPivot();
			image.y = imageY;
			addChild(image);
			
			if (!titleLabel) {
				titleLabel = new XTextField(150 * pxScale, 50 * pxScale, XTextFieldStyle.getWalrus(smallSize ? 34 : 40, 0xFFFFFF, Align.LEFT).setStroke(0.5), item.quantity.toString());
				titleLabel.alignPivot();
				titleLabel.x = -image.width/2 + 10*pxScale + titleLabel.pivotX - titleLabel.textBounds.x;
				titleLabel.y = -image.height/2 + 6*pxScale + titleLabel.pivotY - titleLabel.textBounds.y;
				//titleLabel.border = true;
			}
			
			addChild(titleLabel);
		}
		
		public function get item():CommodityItem {
			return _item;
		}
	}
}
