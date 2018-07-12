package com.alisacasino.bingo.dialogs
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.utils.Constants;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	
	public class InfoDialog extends BaseDialog
	{
		public function InfoDialog(title:String, description:String, buttonLabel:String, fadeClosable:Boolean, closeButton:Boolean)
		{
			super(new DialogProperties(812, 0, title, closeButton, buttonLabel, true, fadeClosable, false, 0.8, 0.06, true));
			this.description = description;
		}
		
		private var animationContainer:AnimationContainer;
		private var textLabel:XTextField;
		private var description:String;
		
		override protected function initialize():void 
		{
			super.initialize();
			
			addBackImage(0.191, 0.61, 0.12);
			
			animationContainer = new AnimationContainer(MovieClipAsset.PackBase, true);
			animationContainer.validate();
			addChild(animationContainer);
			addToFadeList(animationContainer);
		
			animationContainer.playTimeline("cat_idle", true, true);
			
			dialogProperties.expectWidth * 0.7
			textLabel = new XTextField(300 * pxScale , 30 * pxScale, XTextFieldStyle.getChateaudeGarage(32, 0xFFFFFF, Align.CENTER), Constants.TEXT_CLAIMED);
			textLabel.autoSize = TextFieldAutoSize.VERTICAL;
			addToFadeList(textLabel);
			addChild(textLabel);
		}	
		
		override public function resize():void
		{
			super.resize();
			
			animationContainer.x = (backImageWidth - textLabel.width - animationContainer.width * pxScale) / 2;
			animationContainer.y = (background.height - animationContainer.height* pxScale) / 2 + background.y;
			
			textLabel.x = animationContainer.x + animationContainer.width* pxScale;
			textLabel.y = (background.height - textLabel.height) / 2 + background.y;
			
		}	
		
	}
}
