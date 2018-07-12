package com.alisacasino.bingo.models.skinning 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.CustomDaubIcon;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.screens.gameScreenClasses.CellDaubEffect;
	import starling.textures.Texture;
	
	public class SkinningDauberData extends CustomizerItemBase
	{
		public var particleAnimation:String;
		private var assetName:String;
		private var _atlas:AtlasAsset;
		private var _particlesTextureNames:Vector.<String>;
		private var _particlesTextureNamesX2:Vector.<String>;
		private var _xpColor:uint;
		private var _cellDaubFlyUpXPStyle:XTextFieldStyle;
		private var _markedCellTextColor:uint;
		private var _setPrice:int;
		private var _markedCellTextStyle:XTextFieldStyle;
		
		public function SkinningDauberData() 
		{
			_type = CustomizationType.DAUB_ICON;
			particleAnimation = CellDaubEffect.EXPLOSION;
		}
		
		public function get atlas():AtlasAsset {
			return _atlas;
		}
		
		public function getTexture(texture:String):Texture {
			return _atlas.getTexture(texture);
		}
		
		public function getDaubTexture(x2:Boolean):Texture 
		{
			if (x2) 
				return _atlas.hasTexture('daub_x2') ? _atlas.getTexture('daub_x2') : AtlasAsset.CommonAtlas.getTexture('card/daub_x2');
			
			return _atlas.getTexture('daub');
		}
		
		public function getParticlesTextureNames(x2:Boolean):Vector.<String>
		{
			if (!_particlesTextureNames) {
				_particlesTextureNames = new <String>[];
				fillParticlesNames(_particlesTextureNames, false);
			}
			
			if (!_particlesTextureNamesX2) {
				_particlesTextureNamesX2 = new <String>[];
				fillParticlesNames(_particlesTextureNamesX2, true);
			}
			
			return x2 ? _particlesTextureNamesX2 : _particlesTextureNames;
		}
		
		private function fillParticlesNames(source:Vector.<String>, x2:Boolean):void 
		{
			var i:int;
			var textureName:String;
			while (i < 4) {
				textureName = 'particle_' + (x2 ? 'x2_' : '') + i.toString();
				if (_atlas.hasTexture(textureName)) {
					source.push(textureName);
					i++;
				}
				else {
					break;
				}
			}	
			
			if (source.length == 0)
				source.push('particle_0');
		}
		
		public function addToLoad(source:Array):void {
			if (!_atlas)
				_atlas = new AtlasAsset('skins/daubers/' + assetName);
			source.push(_atlas);
		}
		
		public function get isLoaded():Boolean
		{
			return _atlas && _atlas.loaded;
		}
		
		public function load(onComplete:Function = null):void 
		{
			onLoadComplete = onComplete;
			if (isLoaded) {
				callOnLoadComplete();
				return;
			}
			else
			{
				if (!_atlas)
					_atlas = new AtlasAsset('skins/daubers/' + assetName);
				
				_atlas.load(callOnLoadComplete, null);
			}
		}
		
		public function unload():void 
		{
			onLoadComplete = null;
			_atlas.purge();
			_atlas = null;
		}
		
		public function deserialize(rawDauberData:CustomDaubIcon):SkinningDauberData 
		{
			assetName = rawDauberData.assetUrl;
			super.setBaseProperties(rawDauberData);
			particleAnimation = rawDauberData.practicleAnimation;
			_xpColor = rawDauberData.color;
			_markedCellTextColor = rawDauberData.markedCellTextColor;
			_setPrice = rawDauberData.setPrice;
			return this;
		}
		
		public function get xpColor():uint {
			return _xpColor;
		}
		
		public function get setPrice():int {
			return _setPrice;
		}
		
		public function get cellDaubFlyUpXPStyle():XTextFieldStyle {
			if (!_cellDaubFlyUpXPStyle) 
				_cellDaubFlyUpXPStyle = XTextFieldStyle.getWalrus(32, 0xFFFFFF).setShadow(1.5, _xpColor).setStroke(0.3, _xpColor);
			
			return _cellDaubFlyUpXPStyle;
		}
		
		public function get markedCellTextStyle():XTextFieldStyle 
		{
			if (!_markedCellTextStyle) 
				_markedCellTextStyle = new XTextFieldStyle({
					charsetSourceFontName:'Chateau de Garage',
					charset:		"1234567890",
					fontName:		"markedCell_" + _markedCellTextColor.toString(),
					fontSize:		55.0,
					fontColor:		_markedCellTextColor
				});
			
			return _markedCellTextStyle;
		}
		
		public function create(id:int, assetName:String, imageName:String, name:String, order:int, quantity:int, rarity:int, weight:Number, xpColor:uint, markedCellTextColor:uint = 0xffffff):void
		{
			_id = id;
			this.assetName = assetName;
			_uiAssetPath = imageName;
			_name = name;
			this.order = order;
			_quantity = quantity;
			_rarity = rarity;
			this.weight = weight;
			_xpColor = xpColor;
			_markedCellTextColor = markedCellTextColor;
		}
		
		override protected function get uiAssetPath():String {
			return 'customizers/daubers/' + _uiAssetPath + '.png';
		}
	}
}