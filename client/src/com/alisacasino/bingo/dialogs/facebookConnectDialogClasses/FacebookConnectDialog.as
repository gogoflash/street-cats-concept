package com.alisacasino.bingo.dialogs.facebookConnectDialogClasses
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.DialogProperties;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.platform.PlatformServices;
	import starling.display.Sprite;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	import starling.display.Image;
	import starling.events.Event;

	public class FacebookConnectDialog extends BaseDialog
	{
		public function FacebookConnectDialog()
		{
			super(DialogProperties.FACEBOOK_CONNECT);
			_dialogProperties.setStarTitle(XTextFieldStyle.getWalrus(50), 0.085);
		}
		
		private var animationContainer:AnimationContainer;
		private var benefitsContainer:Sprite;
		private var benefitsVerticalGap:int = 85*pxScale;
		
		override protected function initialize():void 
		{
			super.initialize();
			
			addBackImage(0.191, 0.61, 0.12);
			
			animationContainer = new AnimationContainer(MovieClipAsset.PackBase, true);
			animationContainer.validate();
			animationContainer.playTimeline("cat_fb_connect", true, true, 30);
			addChild(animationContainer);
			addToFadeList(animationContainer);
			
			benefitsContainer = new Sprite();
			addChild(benefitsContainer);
			addToFadeList(benefitsContainer);
		
			var index:int;
			createBenefitItemWidthImage(index++, 'BONUS', AtlasAsset.CommonAtlas.getTexture('bars/cash'), 0.83, '200');
			createBenefitItem(index++, 'SAVE YOUR PROGRESS');
			createBenefitItem(index++, 'EXTRA SECURITY');
			createBenefitItem(index++, 'GIFT CENTER & INBOX');
			//FBConnect
			//RateHeart
			//Rate
		}	
		
		override public function resize():void
		{
			super.resize();
			
			animationContainer.x = -42 * pxScale;
			animationContainer.y = backImage.y + (backImage.height - animationContainer.height * pxScale)/2 + 35 * pxScale;
			
			benefitsContainer.x = 290 * pxScale;
			benefitsContainer.y = backImage.y + (backImage.height - benefitsContainer.height)/2;
		}	
		
		override protected function get bottomButtonStyle():XButtonStyle {
			return XButtonStyle.FacebookConnectButtonStyle;
		}
		
		private function createBenefitItem(index:int, text:String):void 
		{
			var markImage:Image = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/checkmark"));
			markImage.y = index * benefitsVerticalGap;
			markImage.scale = 0.46;
			benefitsContainer.addChild(markImage);
			
			var textLabel:XTextField = new XTextField(300 * pxScale, 30 * pxScale, XTextFieldStyle.getChateaudeGarage(32, 0xFFFFFF, Align.LEFT), text);
			textLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			textLabel.y = index * benefitsVerticalGap;
			textLabel.x = 82*pxScale;
			benefitsContainer.addChild(textLabel);
		}
		
		private function createBenefitItemWidthImage(index:int, text1:String, iconTexture:Texture, iconTextureScale:Number, text2:String):void 
		{
			var markImage:Image = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/checkmark"));
			markImage.y = index * benefitsVerticalGap;
			markImage.scale = 0.46;
			benefitsContainer.addChild(markImage);
			
			var textLabel:XTextField = new XTextField(300 * pxScale, 30 * pxScale, XTextFieldStyle.getChateaudeGarage(32, 0xFFFFFF, Align.LEFT), text1);
			textLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			textLabel.y = index * benefitsVerticalGap;
			textLabel.x = 82*pxScale;
			benefitsContainer.addChild(textLabel);
			
			var iconImage:Image = new Image(iconTexture);
			iconImage.y = index * benefitsVerticalGap - 5 * pxScale;
			iconImage.x = textLabel.x + textLabel.width + 5 * pxScale;
			iconImage.scale = iconTextureScale;
			benefitsContainer.addChild(iconImage);
			
			var textLabel2:XTextField = new XTextField(300 * pxScale, 30 * pxScale, XTextFieldStyle.getChateaudeGarage(46, 0xFFFFFF, Align.LEFT), text2);
			textLabel2.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			textLabel2.y = textLabel.y - 5*pxScale;
			textLabel2.x = iconImage.x + iconImage.width + 5 * pxScale;
			benefitsContainer.addChild(textLabel2);
		}
		
		override protected function handler_bottomButton(e:Event):void
		{
			super.handler_bottomButton(e);
			PlatformServices.facebookManager.openSession();
		}
	}
}
