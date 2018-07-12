package com.alisacasino.bingo.dialogs.inbox 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XImage;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.gifts.IncomingGiftData;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.FacebookData;
	import com.alisacasino.bingo.utils.FriendsManager;
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class InboxRowDisplay extends FeathersControl implements IListItemRenderer
	{
		static public const ROW_ACCEPT_TRIGGER:String = "rowAcceptTrigger";
		static public const ROW_ACCEPT_COMPLETE:String = "rowAcceptComplete";
		static public const ROW_CANCEL_TRIGGER:String = "rowCancelTrigger";
		
		
		private var _data:IncomingGiftData;
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void 
		{
			_data = value as IncomingGiftData;
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private var avatar:XImage;
		private var messageLabel:XTextField;
		private var button:XButton;
		private var _index:int;
		private var _owner:List;
		private var _isSelected:Boolean;
		private var background:Image;
		private var defaultHeight:Number;
		private var cancelButton:Button;
		
		public var showCancelButton:Boolean = true;
		
		public function InboxRowDisplay() 
		{
			
		}
		
		
		/* INTERFACE feathers.controls.renderers.IListItemRenderer */
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set index(value:int):void 
		{
			_index = value;
		}
		
		public function get owner():List 
		{
			return _owner;
		}
		
		public function set owner(value:List):void 
		{
			_owner = value;
		}
		
		public function get isSelected():Boolean 
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void 
		{
			_isSelected = value;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			background = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/blue_item_background"));
			background.touchable = false;
			addChild(background);
			
			defaultHeight = background.height - 35 * pxScale;
			
			setSizeInternal(background.width, defaultHeight, false);
			
			button = new XButton(XButtonStyle.MediumGreenButtonStyle);
			button.x = 628 * pxScale;
			button.y = 6 * pxScale;
			addChild(button);
			
			button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			
			avatar = new XImage(AtlasAsset.CommonAtlas.getTexture("avatars/1"));
			avatar.x = 60 * pxScale;
			avatar.y = 6 * pxScale;
			addChild(avatar);
			
			messageLabel = new XTextField(450 * pxScale, 60*pxScale, XTextFieldStyle.InboxRowMessageStyle);
			messageLabel.x = 160 * pxScale;
			messageLabel.y = 20 * pxScale;
			addChild(messageLabel);
			
			
			if (showCancelButton)
			{
				cancelButton = new Button();
				
				var cancelBackgroundImage:Image = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/red_badge"));
				cancelBackgroundImage.scale = 0.5;
				cancelButton.defaultSkin = cancelBackgroundImage;
				cancelButton.defaultIcon = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/red_badge_close_icon"));
				cancelButton.iconOffsetY = -2 * pxScale;
				cancelButton.scaleWhenDown = 0.9;
				cancelButton.x = 12 * pxScale;
				cancelButton.y = -3 * pxScale;
				cancelButton.useHandCursor = true;
				addChild(cancelButton);
				cancelButton.addEventListener(Event.TRIGGERED, cancelButton_triggeredHandler);
			}
			
		}
		
		private function cancelButton_triggeredHandler(e:Event):void 
		{
			dispatchEventWith(ROW_CANCEL_TRIGGER, true, this);
		}
		
		private function button_triggeredHandler(e:Event):void 
		{
			dispatchEventWith(ROW_ACCEPT_TRIGGER, true, this);
		}
		
		override protected function draw():void 
		{
			super.draw();
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				if (data)
				{
					var senderID:String = data.senderID;
					
					avatar.defaultTexture = AtlasAsset.CommonAtlas.getTexture("avatars/" + String(parseInt(senderID, 36) % 5 + 1));
					avatar.imageURL = Player.getAvatarURL("", senderID)
					
					
					messageLabel.text = "";
					
					var name:String = data.senderFirstName;
					var latinMatch:Array = name.match(/[a-zA-Z0-9-\s]+/);
					if(!latinMatch || latinMatch.length <= 0)
					{
						name = "Your friend";
					}
					
					
					messageLabel.text = name + " sent you a gift!";
					
					
					if (FriendsManager.instance.isGoodForGift(data.senderID, false))
					{
						button.text = Constants.INBOX_ACCEPT_AND_SEND;
					}
					else
					{
						button.text = Constants.INBOX_ACCEPT;
					}
					
				}
			}
		}
		
		protected var _factoryID:String;

		public function get factoryID():String
		{
			return _factoryID;
		}

		public function set factoryID(value:String):void
		{
			_factoryID = value;
		}
		
	}

}