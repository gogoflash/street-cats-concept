package com.alisacasino.bingo.screens.sideMenuClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.components.NativeStageRedErrorPlate;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.ServiceDialog;
	import com.alisacasino.bingo.logging.SaveHTMLLog;
	import com.alisacasino.bingo.logging.SendLog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.utils.Constants;
	import feathers.core.FeathersControl;
	import flash.utils.getTimer;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class InfoArea extends FeathersControl
	{
		private var versionLabel:XTextField;
		private var idLabel:XTextField;
		private var backgroundQuad:Quad;
		private var separatorLine:Quad;
		
		private var sideMenu:SideMenu;
		
		private var lastVersionTouchTime:int;
		private var versionFastTouchCount:int;
		
		public function InfoArea(sideMenu:SideMenu) 
		{
			this.sideMenu = sideMenu;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			backgroundQuad = new Quad(852 * pxScale, 77 * pxScale, 0x0);
			backgroundQuad.alpha = 0.6;
			backgroundQuad.x = -400 * pxScale;
			addChild(backgroundQuad);
			
			separatorLine = new Quad(852 * pxScale, 2 * pxScale, 0xcccccc);
			separatorLine.x = -400 * pxScale;
			separatorLine.y = backgroundQuad.height;
			separatorLine.alpha = 0.6;
			addChild(separatorLine);
			
			versionLabel = new XTextField(230 * pxScale, 50 * pxScale, XTextFieldStyle.getWalrus(22, 0xffffff), "VERSION " + gameManager.getVersionString());
			versionLabel.x = 140 * pxScale;
			versionLabel.redraw();
			versionLabel.alignPivot();
			versionLabel.addEventListener(TouchEvent.TOUCH, handler_versionTouch);
			addChild(versionLabel);
			
			idLabel = new XTextField(160 * pxScale, 50 * pxScale, XTextFieldStyle.getWalrus(22, 0x00DEFF), "ID " + (Player.current ? Player.current.playerId : 'no player'));
			idLabel.x = 336 * pxScale;
			idLabel.redraw();
			idLabel.alignPivot();
			addChild(idLabel);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				backgroundQuad.height = height - 2 * pxScale;
				separatorLine.y = height - 2 * pxScale;	
				
				versionLabel.y = height / 2 + 2*pxScale;
				idLabel.y = height / 2 + 2*pxScale;
			}
		}
		
		
		private function handler_versionTouch(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			
			var touch:Touch = event.getTouch(versionLabel);
			if (touch == null)
				return;

			if (touch.phase == TouchPhase.BEGAN) 
			{
				if (/*Constants.isDevFeaturesEnabled*/true) {
					sideMenu.closeMenu();
					DialogsManager.addDialog(new ServiceDialog(), true);
				}
				else 
				{
					if (Game.current)
					{
						if (getTimer() - lastVersionTouchTime < 400) 
						{
							//lastVersionTouchTime = getTimer();
							versionFastTouchCount++;
							
							if (Game.current.hasUncaughtError)
							{
								if (versionFastTouchCount >= 5) {
									versionFastTouchCount = 0;
									NativeStageRedErrorPlate.prodShow(30);
								}
							}
							else
							{
								if (versionFastTouchCount >= 10) {
									versionFastTouchCount = 0;
									new SendLog('log_' + SaveHTMLLog.getDateString(false) + '_' + Player.playerId(''), SaveHTMLLog.getHTMLString()).execute();
									
								}
							}
						}
						lastVersionTouchTime = getTimer();
					}
				}
			}
		}
	}

}