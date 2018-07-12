package com.alisacasino.bingo.utils 
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.components.AwardImageAssetContainer;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.dialogs.chests.ChestPartsView;
	import com.alisacasino.bingo.models.offers.CashIconType;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.models.skinning.CustomizerSet;
	import com.alisacasino.bingo.models.skinning.SkinningData;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.Type;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class ItemViewHelper 
	{
		public function ItemViewHelper() 
		{
			
		}
		
		public static function getQuestRewardView(item:CommodityItem, countLabel:XTextField):DisplayObject
		{
			if (!item)
				return null;
				
			if (item.type == CommodityType.DUST)
			{
				var animation:AnimationContainer = new AnimationContainer(MovieClipAsset.PackBase);
				animation.pivotX = 35*pxScale;
				animation.pivotY = 42*pxScale;
				animation.y = -10*pxScale;
				animation.repeatCount = 0;
				animation.playTimeline('bulb', false, true, 25);
				animation.scale = 1.26;
				return animation;
			}
			
			var image:Image;
			var cashIconType:int;
			var cardView:AwardImageAssetContainer;
			switch(item.type) 
			{
				case CommodityType.CASH: 
				{
					cashIconType = gameManager.questModel.cashAwardTextureTable.getData(item.quantity);
					image = new Image(CashIconType.questAwardTextureByType(cashIconType));
					image.alignPivot();
					
					switch(cashIconType) 
					{
						case CashIconType.CASE: 
						{
							image.scale = 0.87;
							break;
						}
						case CashIconType.BAG: 
						{
							image.scale = 0.8;
							break;
						}
						case CashIconType.SAFE: 
						{
							image.scale = 0.78;
							break;
						}
					}
					
					countLabel.text = item.quantity.toString();
					
					return image;
					
					break;
				};
				case CommodityType.CHEST: 
				{
					countLabel.text = '';
					var chestType:int = parseInt(item.subType);
					var chestView:ChestPartsView = new ChestPartsView(chestType, 0.91, null, 0, -20 * pxScale);
					chestView.jump(0.5, false);
					
					if (chestType == ChestType.PREMIUM || chestType == ChestType.SUPER)
						chestView.y = 10 * pxScale;
					
					return chestView;
					break;
				}
				
				case CommodityType.POWERUP: {
					image = new Image(AtlasAsset.CommonAtlas.getTexture(Powerup.getTexture(item.subType)));
					image.alignPivot();
					return image;
					
					break;
				}
				case CommodityType.POWERUP_CARD: {
					image = new Image(AtlasAsset.CommonAtlas.getTexture(Powerup.getCardTexture(item.subType)));
					image.alignPivot();
					image.scale = 0.58;
					image.y = 10*pxScale;
					return image;
					
					break;
				}
				case CommodityType.COLLECTION: {
					image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('offers/card_collection'));
					image.alignPivot();
					image.scale = 0.8;
					image.y = 10*pxScale;
					return image;
					break;
				}
				case CommodityType.CUSTOMIZER: {
					
					if (item.subType == null || item.subType == '' || SkinningData.isCustomizerSubtype(item.subType))
					{
						image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('offers/card_customizer'));
						image.alignPivot();
						image.scale = 0.8;
						image.y = 10*pxScale;
						return image;
					}
					else
					{
						var customizerItem:CustomizerItemBase = gameManager.skinningData.getCustomizerByUID(item.subType);
						cardView = new AwardImageAssetContainer(customizerItem.uiAsset, customizerItem.rarityGlowBg, '');
						cardView.scale = 0.585;
						cardView.y = 5 * pxScale;
						//countLabel.text = '';
						return cardView;
					}
					
					break;
				}
				case CommodityType.CUSTOMIZER_SET: 
				{
					var customizerSet:CustomizerSet = gameManager.skinningData.getSetByID(parseInt(item.subType));
					
					var container:Sprite;
					if (customizerSet && customizerSet.dauber && customizerSet.cardBack) 
					{
						container = new Sprite();
						
						cardView = new AwardImageAssetContainer(customizerSet.cardBack.uiAsset, customizerSet.cardBack.rarityGlowBg, '');
						cardView.scale = 0.585;
						cardView.x = -30 * pxScale;
						cardView.y = 17 * pxScale;
						cardView.rotation = -7 * Math.PI / 180;
						container.addChild(cardView);
						
						cardView = new AwardImageAssetContainer(customizerSet.dauber.uiAsset, customizerSet.dauber.rarityGlowBg, '');
						cardView.scale = 0.585;
						cardView.x = 30 * pxScale;
						cardView.y = 17 * pxScale;
						cardView.rotation = 7 * Math.PI / 180;
						container.addChild(cardView);
						
						countLabel.text = '';
						
						return container;
					}
				}
			}
			
			return image;
		}
		
		public static function getDustForTotalDialogView(text:String):DisplayObject
		{
			var cardView:AwardImageAssetContainer = new AwardImageAssetContainer(null, "cards/card_glow_gold", text);
				
			var animation:AnimationContainer = new AnimationContainer(MovieClipAsset.PackBase);
			animation.pivotX = 35 * pxScale;
			animation.pivotY = 42 * pxScale;
			animation.x = 108 * pxScale;
			animation.y = 117 * pxScale;
			animation.repeatCount = 0;
			animation.playTimeline('bulb', false, true, 25);
			animation.scale = 1.26;
			cardView.addChild(animation);
			
			return cardView;
		}
	}
}