package com.alisacasino.bingo.components
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.screens.collectionsScreenClasses.CollectionItemRenderer;
	import flash.geom.Rectangle;
	import starling.filters.GlowFilter;
	import starling.text.TextFieldAutoSize;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class AwardImageAssetContainer extends Sprite 
	{
		public static var WIDTH:int = 217;
		public static var HEIGHT:int = 259;
		
		private var glowBg:Image;
		private var imageAssetContainer:ImageAssetContainer;
		private var showGlow:Boolean;
		private var numberLabel:XTextField;
		
		public function AwardImageAssetContainer(source:* = null, glowSource:String = null, numberLabelValue:String = '', isCollection:Boolean = false) 
		{
			touchable = false;
			
			pivotX = WIDTH/2 * pxScale;
			pivotY = HEIGHT/2 * pxScale;
			
			if (glowSource) 
			{
				glowBg = new Image(AtlasAsset.CommonAtlas.getTexture(glowSource));
				glowBg.scale9Grid = new Rectangle(50 * pxScale, 50 * pxScale, 2 * pxScale, 2 * pxScale);
				glowBg.width = 256 * pxScale;
				glowBg.height = 308 * pxScale;
				glowBg.x = (WIDTH * pxScale - glowBg.width) / 2 - 0.3*pxScale;
				glowBg.y = (HEIGHT * pxScale - glowBg.height) / 2;
				
				addChild(glowBg);
			}
			
			imageAssetContainer = new ImageAssetContainer();
			
			if(source && source is ImageAsset && !(source as ImageAsset).loaded) 
				createPreloaderSkin();
				
			imageAssetContainer.source = source;	
			
			if (source is Texture) {
				imageAssetContainer.x = (WIDTH * pxScale - (source as Texture).width) / 2;
				imageAssetContainer.y = (HEIGHT * pxScale - (source as Texture).height) / 2;
			}
			
			addChild(imageAssetContainer);
			
			if (numberLabelValue && numberLabelValue != '') {
				numberLabel = new XTextField((WIDTH - 25) * pxScale, 55*pxScale, XTextFieldStyle.getWalrus(53, 0xFFFFFF, Align.RIGHT).setStroke(0.25).setShadow(1.5), numberLabelValue);
				//numberLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				numberLabel.redraw();
				numberLabel.y = HEIGHT * pxScale - numberLabel.height - 23 * pxScale;
				addChild(numberLabel);
			}
		}
		
		public function set texture(source:*):void 
		{
			if(source && source is ImageAsset && !(source as ImageAsset).loaded && !imageAssetContainer.loadingSkin) 
				createPreloaderSkin();
				
			imageAssetContainer.source = source;
		}
		
		private function createPreloaderSkin():void 
		{
			var loadingContainer:Sprite = new Sprite();
			
			var bg:Image = new Image(AtlasAsset.CommonAtlas.getTexture("cards/preload_bg"));
			bg.scale9Grid = new Rectangle(26 * pxScale, 23 * pxScale, 2 * pxScale, 2 * pxScale);
			bg.width = WIDTH * pxScale;
			bg.height = HEIGHT * pxScale;
			loadingContainer.addChild(bg);
			
			var loadingAnimation:AnimationContainer = new AnimationContainer(MovieClipAsset.PackBase);
			loadingAnimation.pivotX = 42 * pxScale;
			loadingAnimation.pivotY = 42 * pxScale;
			loadingAnimation.move(100 * pxScale, 118 * pxScale);
			loadingAnimation.playTimeline('loading_white', false, true, 24);
			loadingContainer.addChild(loadingAnimation);
			
			//imageAssetContainer.setPivot(Align.CENTER, Align.CENTER);
			
			imageAssetContainer.loadingSkin = loadingContainer;
		}
	}
}