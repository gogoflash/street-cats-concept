package com.alisacasino.bingo.dialogs.inbox 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.utils.Constants;
	import starling.display.Image;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CollectAllGiftsButton extends XButton
	{
		private static const _buttonStyle:XButtonStyle = new XButtonStyle({
			upState:		"dialogs/buttons/big_blue",
			downState:		"dialogs/buttons/big_blue_on",
			atlas:			AtlasAsset.LoadingAtlas,
			topAligned:		true,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		48.0,
				fontColor:		0xffffff,
				strokeSize:		2,
				strokeColor:	0x004b6d
			})
		});
		
		private var locked:Boolean;
		private var lockIcon:Image;
		
		public function CollectAllGiftsButton() 
		{
			super(_buttonStyle, Constants.UNLOCK_ONE_TAP_ACCEPT_LABEL);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function removedFromStageHandler(e:Event):void 
		{
			Player.current.removeEventListener(Player.PURCHASE_REGISTERED, current_purchaseRegisteredHandler);
		}
		
		override protected function onAddedToStage(event:Event):void 
		{
			super.onAddedToStage(event);
			
			updateIconAndLabel();
			
			Player.current.addEventListener(Player.PURCHASE_REGISTERED, current_purchaseRegisteredHandler);
		}
		
		private function current_purchaseRegisteredHandler(e:Event):void 
		{
			updateIconAndLabel();
		}
		
		private function updateIconAndLabel():void
		{
			var buttonLabel:String;
			if (Player.current.lifetimeValue > 0)
			{
				buttonLabel = Constants.COLLECT_ALL_GIFTS_BUTTON_LABEL;
				locked = false;
			}
			else
			{
				buttonLabel = Constants.UNLOCK_ONE_TAP_ACCEPT_LABEL;
				locked = true;
			}
			
			text = buttonLabel;
			
			if (locked)
			{
				if (!lockIcon)
				{
					lockIcon = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/lock_icon"));
				}
				lockIcon.x = 30 * pxScale;
				lockIcon.y = 25 * pxScale;
				addChild(lockIcon);
			}
			else
			{
				if (lockIcon)
				{
					lockIcon.removeFromParent();
				}
			}
			
			buttonStyle.labelXShift = locked ? 30 : 0;
			
			reposition();
		}
		
	}

}