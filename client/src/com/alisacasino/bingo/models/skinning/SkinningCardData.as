package com.alisacasino.bingo.models.skinning 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.commands.serverRequests.SendClientDataSave;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.CustomCard;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import starling.textures.Texture;
	
	public class SkinningCardData extends CustomizerItemBase
	{
		private var assetName:String;
		
		private var _atlas:AtlasAsset;
		private var _isTablet:Boolean;
		private var _cellTextColor:uint;
		private var _setPrice:int;
		private var _cellTextStyle:XTextFieldStyle;
		
		public var hasOverhangTopEdge:Boolean;
		
		public function SkinningCardData() 
		{
			_isTablet = layoutHelper.isLargeScreen;
			_type = CustomizationType.CARD;
		}
		
		public function get atlas():AtlasAsset {
			return _atlas;
		}
		
		public function getTexture(texture:String, x2:Boolean = false):Texture {
			return x2 ? gameManager.skinningData.cardSkinX2.atlas.getTexture(texture) : _atlas.getTexture(texture);
		}
		
		public function addToLoad(source:Array):void {
			if (!_atlas)
				_atlas = new AtlasAsset('skins/' + (_isTablet ? 'tablet' : 'mobile') + '/cards/' + assetName);
			source.push(_atlas);
		}
		
		public function get isLoaded():Boolean
		{
			return _atlas && _atlas.loaded;
		}
		
		public function get setPrice():int {
			return _setPrice;
		}
		
		public function deserialize(rawCardData:CustomCard):SkinningCardData 
		{
			super.setBaseProperties(rawCardData);
			assetName = rawCardData.assetUrl;
			hasOverhangTopEdge = rawCardData.overhang;
			_cellTextColor = rawCardData.cellTextColor;
			_setPrice = rawCardData.setPrice;
			return this;
		}
		
		public function set isTablet(value:Boolean):void
		{
			if (_isTablet == value)
				return;
				
			_isTablet = value;	
			
			unload();
			
			load(null);
		}
		
		public function get isTablet():Boolean
		{
			return _isTablet;
		}
		
		public function load(onComplete:Function = null):void 
		{
			if (isLoaded) {
				if (onComplete != null)
					onComplete();
				return;
			}
			else
			{
				if (!_atlas)
					_atlas = new AtlasAsset('skins/' + (_isTablet ? 'tablet' : 'mobile') + '/cards/' + assetName);
				
				_atlas.load(onComplete, null);
			}
		}
		
		public function unload():void 
		{
			onLoadComplete = null;
			_atlas.purge();
			_atlas = null;
		}
		
		public function get cellTextStyle():XTextFieldStyle 
		{
			if (!_cellTextStyle) 
				_cellTextStyle = new XTextFieldStyle({
					charsetSourceFontName:'Chateau de Garage',
					charset:		"1234567890",
					fontName:		"cell_" + _cellTextColor.toString(),
					fontSize:		52.0,
					fontColor:		_cellTextColor
				});
			
			return _cellTextStyle;
		}
		
		public function create(id:int, assetName:String, imageName:String, name:String, order:int, quantity:int, rarity:int, weight:Number, cellTextColor:uint = 0x585858):void
		{
			_id = id;
			this.assetName = assetName;
			_uiAssetPath = imageName;
			_name = name;
			this.order = order;
			_quantity = quantity;
			_rarity = rarity;
			this.weight = weight;
			_cellTextColor = cellTextColor;
		}
		
		override protected function get uiAssetPath():String {
			return 'customizers/cards/' + _uiAssetPath + '.png';
		}
	}
}