package com.alisacasino.bingo.screens.lobbyScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.dialogs.offers.SaleBadgeView;
	import com.alisacasino.bingo.models.universal.ValueDataTable;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class LobbyStoreButton extends XButton 
	{
		public static const BADGE_CORNER_SALE:String = "BADGE_CORNER_SALE";
		public static const BADGE_CORNER_NEW:String = "BADGE_CORNER_NEW";
		public static const BADGE_CORNER_FREE:String = "BADGE_CORNER_FREE";
		public static const BADGE_BOTTOM_SALE:String = "BADGE_BOTTOM_SALE";
		
		public function LobbyStoreButton(style:XButtonStyle, text:String="", disabledText:String="") 
		{
			super(style, text, disabledText);
		}
		
		private var _badgeTexture:Texture;
		private var _badgeType:String;
		
		private var badgeImage:Image;
		private var saleBadgeView:SaleBadgeView;
		
		public function setBadge(type:String, ...args):void 
		{
			if (_badgeType == type)
				return;
				
			_badgeType = type;
			
			if (_badgeType == null || _badgeType == '')
			{
				badgeTexture = null;
			}	
			else if(_badgeType == BADGE_CORNER_FREE) {
				badgeTexture = AtlasAsset.CommonAtlas.getTexture('controls/badge_free');
			}
			else if(_badgeType == BADGE_CORNER_SALE) {
				badgeTexture = AtlasAsset.CommonAtlas.getTexture('controls/badge_sale');
			}
			else if(_badgeType == BADGE_CORNER_NEW) {
				badgeTexture = AtlasAsset.CommonAtlas.getTexture('controls/badge_new');
			}
			else {
				badgeTexture = null;
			}
		}
		
		public function setRoundSaleBadge(type:String, badgeTypeTable:ValueDataTable, percentValue:Number, iconTexture:Texture = null, clickCallback:Function = null):void 
		{
			if (type)
			{
				if (!saleBadgeView) {
					saleBadgeView = new SaleBadgeView(type, badgeTypeTable, percentValue, iconTexture, null, clickCallback);
					saleBadgeView.showJump(1000, 0, 6000);
					addChild(saleBadgeView);
				}
				else {
					saleBadgeView.setProperties(percentValue, badgeTypeTable, iconTexture);
					saleBadgeView.playEffect();
				}
				
				if (iconTexture) {
					saleBadgeView.scale = Math.min((100 * pxScale) / iconTexture.height, (100 * pxScale) / iconTexture.width, 1);
				}
				else {
					saleBadgeView.scale = 1;
				}
				
				reposition();
			}
			else
			{
				if (saleBadgeView) {
					saleBadgeView.removeFromParent(true);
					saleBadgeView = null;
				}
			}
		}
		
		private function set badgeTexture(value:Texture):void 
		{
			_badgeTexture = value;
			
			if (_badgeTexture) 
			{
				if (!badgeImage) {
					badgeImage = new Image(_badgeTexture);
					badgeImage.touchable = false;
					addChild(badgeImage);
				}
				else {
					badgeImage.texture = _badgeTexture;
					badgeImage.readjustSize();
				}
				
				repositionBadge();
			}
			else 
			{
				if (badgeImage) {
					badgeImage.removeFromParent();
					badgeImage = null;
				}
			}
		}
		
		override public function get width():Number
		{
			return expectedWidth;
		}	
		
		override public function get height():Number
		{
			return 79*pxScale*scale;
		}	
		
		override protected function reposition():void 
		{
			super.reposition();
			repositionBadge();
			
			if (saleBadgeView) {
				saleBadgeView.x = 0//- 17 * pxScale;//width/scale - badgeImage.width * 0.5 - 7 * pxScale;
				saleBadgeView.y = 36*pxScale;
			}
		}
		
		private function repositionBadge():void 
		{
			if (badgeImage) {
				addChild(badgeImage);
				badgeImage.x = 4 * pxScale;//width/scale - badgeImage.width * 0.5 - 7 * pxScale;
				badgeImage.y = -2*pxScale;//-badgeImage.height * 0.5;
			}	
		}
	}

}
