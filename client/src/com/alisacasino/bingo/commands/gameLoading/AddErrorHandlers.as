package com.alisacasino.bingo.commands.gameLoading 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.platform.PlatformServices;
	import flash.desktop.NativeApplication;
	import flash.display.LoaderInfo;
	import flash.events.UncaughtErrorEvent;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class AddErrorHandlers extends CommandBase
	{
		private var loaderInfo:LoaderInfo;
		
		public function AddErrorHandlers(loaderInfo:LoaderInfo) 
		{
			this.loaderInfo = loaderInfo;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
		
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, Game.uncaughtErrorHandler);
			
			if (!PlatformServices.isCanvas)
				NativeApplication.nativeApplication.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, Game.uncaughtErrorHandler);
				
			finish();
		}
		
	}

}