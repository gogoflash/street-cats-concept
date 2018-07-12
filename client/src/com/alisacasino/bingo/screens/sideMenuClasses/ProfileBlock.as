package com.alisacasino.bingo.screens.sideMenuClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.components.MultiCharsLabel;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.platform.PlatformServices;
	import feathers.controls.BasicButton;
	import feathers.controls.ButtonState;
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.utils.Align;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ProfileBlock extends BasicButton
	{
		private var backgroundQuad:Quad;
		private var avatarImage:ImageLoader;
		
		public function ProfileBlock() 
		{
			useHandCursor = true;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			var skin:LayoutGroup = new LayoutGroup();
			backgroundQuad = new Quad(852 * pxScale, 72 * pxScale, 0x00a2ff);
			//backgroundQuad.alpha = 0.6;
			backgroundQuad.x = -400 * pxScale;
			skin.addChild(backgroundQuad);
			
			var separatorLine:Quad = new Quad(852 * pxScale, 2 * pxScale, 0xcccccc);
			separatorLine.x = -400 * pxScale;
			separatorLine.y = backgroundQuad.height;
			separatorLine.alpha = 0.6;
			skin.addChild(separatorLine);
			
			avatarImage = new ImageLoader();
			avatarImage.loadingTexture = AtlasAsset.CommonAtlas.getTexture("side_menu/avatar_placeholder");
			avatarImage.errorTexture = AtlasAsset.CommonAtlas.getTexture("side_menu/avatar_placeholder");
			avatarImage.x = 37 * pxScale;
			avatarImage.y = 1 * pxScale;
			if (PlatformServices.facebookManager.isConnected)
			{
				avatarImage.source  = Player.getAvatarURL("", PlatformServices.facebookManager.facebookId, Math.ceil(72 * pxScale), Math.ceil(72 * pxScale));
			}
			else
			{
				avatarImage.source = null;
			}
			skin.addChild(avatarImage);
			
			var xpBackground:Image = new Image(AtlasAsset.CommonAtlas.getTexture("side_menu/xp_background"));
			//xpBackground.scale = 0.7;
			xpBackground.alignPivot();
			xpBackground.x = 158 * pxScale;
			xpBackground.y = 37 * pxScale;
			skin.addChild(xpBackground);
			
			var xpLabel:XTextField = new XTextField(64 * pxScale, 40 * pxScale, XTextFieldStyle.MenuProfileXpLabel, Player.current ? Player.current.xpLevel.toString() : '-');
			xpLabel.autoScale = true;
			xpLabel.redraw();
			xpLabel.alignPivot(Align.CENTER, Align.CENTER);
			xpLabel.x = xpBackground.x;
			xpLabel.y = xpBackground.y + 2 * pxScale;
			skin.addChild(xpLabel);
			
			var nameLabel:MultiCharsLabel = new MultiCharsLabel(XTextFieldStyle.MenuProfileNickNameLabel, 240 * pxScale, 50 * pxScale, Player.current ? Player.current.firstName : 'no player', true);
			nameLabel.textField.x = 190 * pxScale + 10;
			nameLabel.textField.y = 14 * pxScale;
			skin.addChild(nameLabel.textField);
			//nameLabel.debugTest(false);
			
			defaultSkin = skin;
			
			skin.setSize(452 * pxScale, 75 * pxScale);
		}
		
		override protected function refreshSkin():void 
		{
			super.refreshSkin();
			
			if (currentState == ButtonState.DOWN)
			{
				backgroundQuad.color = 0x10b2ff;
			}
			else
			{
				backgroundQuad.color = 0x00a2ff;
			}
		}
		
	}

}