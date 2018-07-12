package com.alisacasino.bingo.dialogs
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

	public class TransferRateWarningDialog extends BaseDialog
	{
		public function TransferRateWarningDialog()
		{
			super(DialogProperties.TRANSFER_RATE_WARNING);
			_dialogProperties.setStarTitle(XTextFieldStyle.getWalrus(50), 0.085);
		}
		
		private var animationContainer:AnimationContainer;
		private var benefitsContainer:Sprite;
		private var benefitsVerticalGap:int = 85*pxScale;
		private var textLabel:XTextField;
		
		override protected function initialize():void 
		{
			super.initialize();
			
			addBackImage(0.191, 0.61, 0.12);
			
			animationContainer = new AnimationContainer(MovieClipAsset.CatDisconnect, true);
			animationContainer.validate();
			addChild(animationContainer);
			addToFadeList(animationContainer);
			textLabel = new XTextField(465 * pxScale, 437 * pxScale, XTextFieldStyle.getChateaudeGarage(30), "Something is slowing down the connection.\n\nMake sure you are using Wi-Fi or try a different connection!");
			textLabel.format.leading = 10*pxScale;
			//textLabel.border = true;
			addChild(textLabel);
			addToFadeList(textLabel, 0);
		}	
		
		override public function resize():void
		{
			super.resize();
			
			if (animationContainer) 
			{
				animationContainer.x = 17 * pxScale;
				animationContainer.y = backImage.y + 34 * pxScale;
				
				textLabel.x = backImage.pivotX + backImageWidth - textLabel.width - 34 * pxScale;
			}
			else 
			{
				textLabel.x = (backImageWidth - textLabel.width)/2;
			}
			
			textLabel.y = backImage.y + (backImage.height - textLabel.height)/2;
		}	
	}
}
