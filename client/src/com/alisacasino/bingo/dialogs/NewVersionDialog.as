package com.alisacasino.bingo.dialogs
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.utils.Settings;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import starling.events.Event;

	public class NewVersionDialog extends BaseDialog
	{
		public static const TYPE_RECONNECT:String = 'TYPE_RECONNECT';
		
		public static const TYPE_BLANK:String = 'TYPE_BLANK';
		
		private var textLabel:XTextField;
		private var animationContainer:AnimationContainer;
		private var animationAsset:MovieClipAsset;
		
		public function NewVersionDialog(canSkip:Boolean)
		{
			var dp:DialogProperties = new DialogProperties(812, 0, 'STUB', canSkip, "STUB", true, canSkip, canSkip);
			super(dp);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			addBackImage(0.189, 0.6, 0.08);
			
			commitShowCatAnimation();
			
			textLabel = new XTextField(465 * pxScale, 437 * pxScale, XTextFieldStyle.getChateaudeGarage(42), "");
			textLabel.isHtmlText = true;
			textLabel.format.leading = 10 * pxScale;;
			textLabel.text = "NEW VERSION IS\nAVAILABLE! PRESS\n<font color=\"#5dff00\">UPDATE</font> BUTTON\nTO GET IT!";
			//textLabel.border = true;
			addChild(textLabel);
			addToFadeList(textLabel, 0)
		}	
		
		override public function resize():void
		{
			super.resize();
			
			if (animationContainer) 
			{
				animationContainer.x = 17 * pxScale;
				
				animationContainer.y = (background.height - animationContainer.height * pxScale) / 2 + background.y;
				
				textLabel.x = backImage.pivotX + backImageWidth - textLabel.width - 34 * pxScale;
			}
			else 
			{
				textLabel.x = (backImageWidth - textLabel.width)/2;
			}
			
			textLabel.y = backImage.y + (backImage.height - textLabel.height)/2;
		}	
		
		private function commitShowCatAnimation():void 
		{
			if (MovieClipAsset.CatIdle.loaded) 
			{
				if(!animationContainer)
					animationContainer = new AnimationContainer(MovieClipAsset.CatIdle, true);
					
				animationContainer.playTimeline("cat_idle", true, true, 60);
				animationContainer.validate();
				animationContainer.play();
				addChild(animationContainer);
				
			}
			else {
				animationContainer = new AnimationContainer(MovieClipAsset.CatIdle, true);
				addToFadeList(animationContainer, 0);
				// todo: animationContainer.showPreloader();
				MovieClipAsset.CatIdle.load(completeLoadCatAnimation, null);
			}
		}
		
		private function completeLoadCatAnimation():void 
		{
			commitShowCatAnimation();
			invalidate();
		}
		
		override protected function get dialogTitle():String
		{
			return "NEW VERSION";
		}
		
		override protected function get bottomButtonTitle():String
		{
			return "UPDATE";
		}
		
		override protected function handler_bottomButton(e:Event):void
		{
			navigateToURL(new URLRequest(Settings.instance.appURL));
		}

		override protected function removeDialog():void 
		{
			MovieClipAsset.CatIdle.purge();
			super.removeDialog();
		}
	}
}