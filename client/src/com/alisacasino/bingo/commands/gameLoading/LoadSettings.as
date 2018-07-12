package com.alisacasino.bingo.commands.gameLoading 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.ICommand;
	import com.alisacasino.bingo.commands.dialogCommands.ShowNoConnectionDialog;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.NewVersionDialog;
	import com.alisacasino.bingo.dialogs.ReconnectDialog;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.screens.LoadingScreen;
	import com.alisacasino.bingo.utils.AbsoluteVersion;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAReconnectShownEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import starling.core.Starling;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class LoadSettings extends CommandBase
	{
		private var loadOrder:Array;
		private var loadSettingsFile:ICommand;
		
		public function LoadSettings() 
		{
			loadOrder = [Constants.PRIMARY_STATIC_HOST, Constants.PRIMARY_STATIC_HOST, Constants.SECONDARY_STATIC_HOST, Constants.SECONDARY_STATIC_HOST, Constants.TERTIARY_STATIC_HOST, Constants.TERTIARY_STATIC_HOST];
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			tryToLoad();
			
		}
		
		private function tryToLoad(ddnaErrorMessage:String = null):void 
		{
			if (loadOrder.length > 0)
			{
				var host:String = loadOrder.shift();
				loadSettingsFile = new LoadSettingsFile(host).execute(onFileLoadSuccess, onFileLoadFail);
			}
			else
			{
				new ShowNoConnectionDialog(DDNAReconnectShownEvent.NO_RESOURCES, "Can't load game config." + (ddnaErrorMessage ? ('Message:' + ddnaErrorMessage) : ''), ReconnectDialog.TYPE_RECONNECT, Constants.TITLE_LOADING_ERROR, Constants.TEXT_LOADING_CONFIG_ERROR).execute(fail, fail);
			}
		}
		
		private function onFileLoadFail(command:LoadSettingsFile):void 
		{
			command.stop();
			tryToLoad(command.errorMessage);
		}
		
		private function onFileLoadSuccess(command:LoadSettingsFile):void 
		{
			if (Settings.instance.parseFromJSON(command.data))
			{
				checkVersion();
			}
			else
			{
				command.stop();
				tryToLoad('parse JSON error');
			}
		}
		
		private function checkVersion():void 
		{
			//sosTrace( "LoadSettings.checkVersionAndMaintenance", SOSLog.INFO);
			var settings:Settings = Settings.instance;
			
			/*if (PlatformServices.isMobile)
			{
				var clientVersion:Number = AbsoluteVersion.fromString(gameManager.getVersionString());
				var latestVersion:Number = AbsoluteVersion.fromString(settings.latestVersion);
				var cutoffVersion:Number = AbsoluteVersion.fromString(settings.cutoffVersion);
				if (clientVersion < cutoffVersion)
				{
					showNewVersionDialog(false);
					return;
				}
				else if(clientVersion < latestVersion)
				{
					showNewVersionDialog(true);
					return;
				}
			}*/
			
			finish();
		}
		
		public function showNewVersionDialog(canSkip:Boolean = true):void
		{
			var newVersionDialog:NewVersionDialog = new NewVersionDialog(canSkip);	
			DialogsManager.addDialog(newVersionDialog, true, true);
			
			if (canSkip)
				newVersionDialog.addEventListener(BaseDialog.DIALOG_CLOSED_EVENT, newVersionDialog_dialogClosedEventHandler);
			else
				stop();
		}
		
		private function newVersionDialog_dialogClosedEventHandler(e:starling.events.Event):void 
		{
			finish();
		}
		
		override protected function stopInternal():void 
		{
			super.stopInternal();
			
			if (loadSettingsFile)
			{
				loadSettingsFile.stop();
			}
		}
		
	}

}