package com.alisacasino.bingo.dialogs.slots
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.facebookConnectDialogClasses.FacebookConnectDialog;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.FriendsManager;
	import feathers.core.FeathersControl;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	
	public class FreeSpinsButton extends FeathersControl
	{
		private var baseButton:XButton;
		private var leftLabel:XTextField;
		
		private static var textStyle:XTextFieldStyle = new XTextFieldStyle({fontSize: 56.0, fontColor: 0x007171, strokeSize: 2, strokeColor: 0xFFFFFF, hAlign: Align.CENTER});
		
		private var getSpinsButton:XButton;
		
		public function FreeSpinsButton()
		{
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			baseButton = new XButton(XButtonStyle.BuySpinButtonStyle);
			baseButton.scaleWhenDown = 1.0;
			baseButton.alphaWhenDisabled = 1.0;
			baseButton.enabled = false;
			addChild(baseButton);
			
			width = baseButton.width;
			height = baseButton.height;
			
			leftLabel = new XTextField(0, 0, textStyle, Constants.SLOT_MACHINE_FREE_SPINS_BUTTON_LABEL);
			leftLabel.autoScale = false;
			leftLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			leftLabel.x = 140 * pxScale;
			leftLabel.y = 8 * pxScale;
			addChild(leftLabel);
			
			leftLabel.redraw();
			leftLabel.pivotX = leftLabel.width / 2;
			
			getSpinsButton = new XButton(XButtonStyle.GetFreeSpinsButtonStyle);
			getSpinsButton.x = width - 200 * pxScale;
			getSpinsButton.y = 8 * pxScale;
			getSpinsButton.text = Constants.GET_FREE_SPINS_BUTTON_LABEL;
			addChild(getSpinsButton);
			
			addEventListener(Event.TRIGGERED, triggeredHandler);
		}
		
		private function triggeredHandler(e:Event):void
		{
			if (PlatformServices.facebookManager.isConnected)
			{
				FriendsManager.instance.showInviteFriendsDialog(FriendsManager.MODE_GET_FREE_SPINS, true);
			}
			else
			{
				new FacebookConnectDialog().show();
			}
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function get baseWidth():Number
		{
			return baseButton ? baseButton.width : 0;
		}
	}
}