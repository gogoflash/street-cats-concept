package com.alisacasino.bingo.screens 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.components.FixedSizeSprite;
	import com.alisacasino.bingo.controls.StarTitle;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.IDialog;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.UIConstructor;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Align;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class FullscreenDialogBase extends FeathersControl implements IDialog
	{
		protected var closeButton:Button;
		protected var contentContainer:LayoutGroup;
		protected var backgroundQuad:Quad;
		private var titleText:String = "";
		protected var title:StarTitle;
		protected var titleShiftY:Number = 36 * pxScale;
		
		public function FullscreenDialogBase() 
		{
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			createChildren();
			Game.addEventListener(Game.STAGE_RESIZE, stageResizeHandler);
			setSizeToStage();
		}
		
		protected function setTitle(titleText:String):void
		{
			if (!isInitialized)
			{
				this.titleText = titleText;
				return;
			}
			
			title.text = titleText;
			invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		protected function createChildren():void 
		{
			backgroundQuad = new Quad(1, 1, 0x0);
			addChild(backgroundQuad);
			
			title = new StarTitle(titleText, XTextFieldStyle.getWalrus(48, 0xFFFFFF), 8, 0, -4, starTitleActivateCallback);
			title.y = 36 * pxScale;
			addChild(title);
			
			contentContainer = new LayoutGroup();
			contentContainer.setSize(1280*pxScale, 720*pxScale);
			addChild(contentContainer);
			
			closeButton = UIConstructor.dialogCloseButton();
			closeButton.x = 1180 * pxScale + 30*pxScale;
			closeButton.y = 20 * pxScale + 30*pxScale;
			closeButton.addEventListener(Event.TRIGGERED, closeButton_triggeredHandler);
			addChild(closeButton);
		}
		
		
		override protected function feathersControl_removedFromStageHandler(event:Event):void 
		{
			super.feathersControl_removedFromStageHandler(event);
			Game.removeEventListener(Game.STAGE_RESIZE, stageResizeHandler);
		}
		
		private function stageResizeHandler(e:Event):void 
		{
			setSizeToStage();
		}
		
		private function setSizeToStage():void 
		{
			width = layoutHelper.stageWidth;
			height = layoutHelper.stageHeight;
			invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		private function closeButton_triggeredHandler(e:Event):void 
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			close();
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				resizeContent();
			}
		}
		
		protected function resizeContent():void 
		{
			//actualWidth
			
			backgroundQuad.width = actualWidth;
			backgroundQuad.height = actualHeight;
			
			var contentScale:Number = Math.min(layoutHelper.stageWidth / contentContainer.explicitWidth, layoutHelper.stageHeight / contentContainer.explicitHeight);
			if (layoutHelper.canvasLayoutMode && layoutHelper.canvasExtraScale != 1)
				contentScale *= layoutHelper.canvasExtraScale;
			
			contentContainer.scale = contentScale;
			
			contentContainer.move(getContentX(), getContentY());
			
			var _outerScale:Number = outerScale;
			
			title.scale = _outerScale;
			title.y = titleShiftY * title.scale;
			title.x = (actualWidth - title.width) / 2;
			
			closeButton.scale = _outerScale;
			closeButton.validate();
			closeButton.x = actualWidth - closeButton.width / 2 + (layoutHelper.isIPhoneX ? 30 : 40) * pxScale * closeButton.scale;
			closeButton.y = 50 * pxScale * closeButton.scale;
		}
		
		private function starTitleActivateCallback():void {
			if (title) 
				title.x = (actualWidth - title.width) / 2;
		}
		
		protected function getContentY():Number
		{
			return (actualHeight - contentContainer.height) / 2;
		}
		
		protected function getContentX():Number
		{
			return (actualWidth - contentContainer.width) / 2;
		}
		
		public function close():void 
		{
			removeDialog();
		}
		
		protected function removeDialog():void 
		{
			if (title)
				title.dispose();
			removeFromParent(true);
			//dispatchEventWith(DIALOG_REMOVED_EVENT);
		}
		
		public function get selfScaled():Boolean 
		{
			return true;
		}
		
		public function get baseScale():Number
		{
			return NaN;
		}
	
		public function get fadeStrength():Number 
		{
			return 0;
		}
		
		public function get blockerFade():Boolean 
		{
			return true;
		}
		
		public function get fadeClosable():Boolean 
		{
			return false;
		}
		
		public function get align():String 
		{
			return Align.CENTER;
		}
		
		public function get outerScale():Number 
		{
			var heightScale:Number = layoutHelper.stageHeight / (720 * pxScale);
			var outerScale:Number = (layoutHelper.stageWidth / (1280 * pxScale) + heightScale) / 2;
			
			if (layoutHelper.canvasLayoutMode && layoutHelper.canvasExtraScale != 1)
				return Math.min(outerScale, heightScale) * layoutHelper.canvasExtraScale;
			else
				return Math.min(outerScale, heightScale);
		}
	}

}