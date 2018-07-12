package com.alisacasino.bingo.dialogs
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.protocol.ClaimOfferOkMessage;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import flash.geom.Rectangle;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	public class ClaimBonusDialog extends BaseDialog
	{
		public static const TYPE_FACEBOOK_BONUS:String = 'TYPE_FACEBOOK_BONUS';
		public static const TYPE_FREEBIE_CLAIM:String = 'TYPE_FREEBIE_CLAIM';
		
		private var type:String;
		
		private var animationContainer:AnimationContainer;
		private var benefitItem:Sprite;
		
		private var claimOfferOkMessage:ClaimOfferOkMessage;
		private var freebiesOfferName:String;
		private var textLabel:XTextField;
		
		public function ClaimBonusDialog(type:String, claimOfferOkMessage:ClaimOfferOkMessage, freebiesOfferName:String)
		{
			this.type = type;
			this.claimOfferOkMessage = claimOfferOkMessage;
			this.freebiesOfferName = freebiesOfferName;
		
			var properties:DialogProperties;
			if(type == TYPE_FACEBOOK_BONUS)
				properties = new DialogProperties(812, 0, 'FACEBOOK CONNECT GIFT!', false, "OK", true, false, false, 0.8, 0.06, true);
			else if (type == TYPE_FREEBIE_CLAIM)
				properties = new DialogProperties(812, 0, 'FREEBIE', false, "CLAIM!", true, false, false, 0.8, 0.06, true);
			else
				properties = DialogProperties.EMPTY;
				
			super(properties);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			addBackImage(0.191, 0.61, 0.12);
			
			animationContainer = new AnimationContainer(MovieClipAsset.PackBase, true);
			animationContainer.validate();
			animationContainer.playTimeline("cat_idle", true, true);
			addChild(animationContainer);
			addToFadeList(animationContainer);
		
			if (type == TYPE_FREEBIE_CLAIM) {
				textLabel = new XTextField(450 * pxScale, 30 * pxScale, XTextFieldStyle.getChateaudeGarage(36, 0xFFFFFF, Align.CENTER), Constants.FREEBIE_TEXT);
				textLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				textLabel.format.leading = 18 * pxScale;
				textLabel.isHtmlText = true;
				addChild(textLabel);
				addToFadeList(textLabel);
				
				if (claimOfferOkMessage.offerType == "coins") {
					benefitItem = createBenefitItemWidthImage('', AtlasAsset.CommonAtlas.getTexture('bars/medium/cash'), 1.1, claimOfferOkMessage.offerValue.toString(), 60, 15, 1, true);
					addChild(benefitItem);
					addToFadeList(benefitItem);
				}	
			}
			else if (type == TYPE_FACEBOOK_BONUS) {
				if (claimOfferOkMessage.offerType == "coins") {
					benefitItem = createBenefitItemWidthImage('BONUS', AtlasAsset.CommonAtlas.getTexture('bars/cash'), 0.83, claimOfferOkMessage.offerValue.toString(), 46);
					addChild(benefitItem);
					addToFadeList(benefitItem);
				}	
			}
		}	
		
		override public function resize():void
		{
			super.resize();
			
			var contentMaxWidth:int = textLabel ? textLabel.width : benefitItem.width;
			
			animationContainer.x = (backImageWidth - contentMaxWidth - animationContainer.width * pxScale) / 2;
			animationContainer.y = (background.height - animationContainer.height* pxScale) / 2 + background.y;
			
			if (textLabel) {
				textLabel.x = animationContainer.x + animationContainer.width * pxScale;
				textLabel.y = backImage.y + (backImage.height - textLabel.height - benefitItem.height - 20*pxScale) / 2;
				
				benefitItem.x = textLabel.x + (textLabel.width - benefitItem.width)/2;
				benefitItem.y = textLabel.y + textLabel.height + 20*pxScale;
			}
			else {
				benefitItem.x = animationContainer.x + animationContainer.width * pxScale;
				benefitItem.y = backImage.y + (backImage.height - benefitItem.height)/2;
			}
		}	
		
		private function createBenefitItemWidthImage(text1:String, iconTexture:Texture, iconTextureScale:Number, text2:String, textSize:int = 46, gap:int = 5, textShiftY:int = -5, showBg:Boolean = false):Sprite
		{
			var container:Sprite = new Sprite();
			
			var textLabel:XTextField = new XTextField(300 * pxScale, 30 * pxScale, XTextFieldStyle.getChateaudeGarage(textSize, 0xFFFFFF, Align.LEFT), text1);
			textLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			textLabel.y = textShiftY*pxScale;
			container.addChild(textLabel);
			
			var iconImage:Image = new Image(iconTexture);
			iconImage.y = -5 * pxScale;
			iconImage.x = textLabel.x + textLabel.width + gap * pxScale;
			iconImage.scale = iconTextureScale;
			container.addChild(iconImage);
			
			if (showBg) {
				var bg:Image = new Image(AtlasAsset.CommonAtlas.getTexture('bars/base_frameless'));
				bg.scale9Grid = new Rectangle(0, 31 * pxScale, 1 * pxScale, 2 * pxScale);
				//bg.width = 240 * pxScale;
				bg.height = 70 * pxScale;
				//bg.alignPivot();
				bg.x = iconImage.x + iconImage.width / 2;
				bg.y = iconImage.y + (iconImage.height - bg.height) / 2;
				container.addChildAt(bg, 0);
			}
			
			var textLabel2:XTextField = new XTextField(300 * pxScale, 30 * pxScale, XTextFieldStyle.getChateaudeGarage(textSize, 0xFFFFFF, Align.LEFT), text2);
			textLabel2.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			textLabel2.x = iconImage.x + iconImage.width + gap * pxScale;
			textLabel2.y = textLabel.y;
			container.addChild(textLabel2);
			
			if(bg)
				bg.width = textLabel2.x + textLabel2.width - bg.x + 25*pxScale;
			
			//187 64
			return container;
		}
		
		
		override protected function handler_bottomButton(e:Event):void
		{
			super.handler_bottomButton(e);
			
			if (type == TYPE_FREEBIE_CLAIM) 
			{
				if (claimOfferOkMessage.offerType == "coins")
				{
					Player.current.updateCashCount(claimOfferOkMessage.offerValue, "freebie");
				}
				
				Game.connectionManager.sendPlayerUpdateMessage();
				Game.connectionManager.sendOfferAcceptedMessage(freebiesOfferName);
				gameManager.freebiesManager.claimFreebie();
			}
			else if (type == TYPE_FACEBOOK_BONUS) 
			{
				gameManager.facebookConnectManager.сlaimConnectFacebookBonus();
			}
		}
		
		
	}
}