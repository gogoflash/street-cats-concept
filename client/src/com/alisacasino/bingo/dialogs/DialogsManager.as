package com.alisacasino.bingo.dialogs
{
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.components.NativeStageRedErrorPlate;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAUIInteractionEvent;
	import feathers.core.FeathersControl;
	import flash.utils.getTimer;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Align;
	
	public class DialogsManager extends EventDispatcher
	{
		public static const EVENT_ADD:String = 'EVENT_ADD';
		public static const EVENT_REMOVE:String = 'EVENT_REMOVE';
		
		
		private static var _instance:DialogsManager;
		private var startDialogsQueue:OnStartDialogsQueue;
		
		private var dialogsDeferred:Boolean;
		
		private var _dialogsLayer:DisplayObjectContainer;
		
		public function get dialogsLayer():DisplayObjectContainer
		{
			return _dialogsLayer;
		}
		
		private var _width:int;
		private var _height:int;
		
		private var fadeQuad:Fade;
		
		private var dialogsList:Vector.<IDialog>;
		private var dialogQueue:Vector.<DisplayObject>;
		
		private var history:Vector.<String>;
		private var historyDepth:int = 3;
		
		static public function get activeDialog():IDialog
		{
			return instance.getActiveDialog();
		}
		
		private function getActiveDialog():IDialog
		{
			return dialogsList.length > 0 ? dialogsList[dialogsList.length - 1] : null;
		}
		
		public function DialogsManager()
		{
			initialize();
			startDialogsQueue = new OnStartDialogsQueue();
			startDialogsQueue.addEventListener(Event.COMPLETE, startDialogsQueue_completeHandler);
		}
		
		private function startDialogsQueue_completeHandler(e:Event):void 
		{
			dialogsDeferred = false;
		}
		
		public static function get instance():DialogsManager
		{
			if (!_instance)
				throw new Error('DialogsManager do not inited');
			return _instance;
		}
		
		public static function init():void
		{
			if (!_instance)
				_instance = new DialogsManager();
		}
		
		public static function setDialogsLayer(dialogsLayer:DisplayObjectContainer):void
		{
			if (!_instance)
				return;
			
			instance.setDialogsLayer(dialogsLayer);
		}
		
		public function setDialogsLayer(dialogsLayer:DisplayObjectContainer):void
		{
			if (dialogsLayer)
			{
				dialogsLayer.removeEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
				dialogsLayer.removeEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			}
			
			this._dialogsLayer = dialogsLayer;
			
			if (!dialogsLayer)
				return;
			
			addDialogsFromList();
			
			if (dialogsLayer.stage)
			{
				handler_addedToStage(null);
			}
			else
			{
				dialogsLayer.addEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
				dialogsLayer.addEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			}
			
			dialogsLayer.addChildAt(fadeQuad, 0);
			fadeQuad.addEventListener(TouchEvent.TOUCH, handler_fadeTouch);
		}
		
		private function addDialogsFromList():void
		{
			for (var i:int = 0; i < dialogsList.length; i++)
			{
				var dialog:IDialog = dialogsList[i];
				var dialogDisplayObject:DisplayObject = (dialog is DisplayObject) ? dialog as DisplayObject : (dialog as DialogWrapper).dialog;
				dialogDisplayObject.removeFromParent(false);
				dialogsLayer.addChild(dialogDisplayObject);
				
				if (dialog is BaseDialog)
				{
					(dialog as BaseDialog).invalidate();
					(dialog as BaseDialog).validate();
				}
			}
			
			resizeDialogs();
			
			refreshFade();
		}
		
		private function initialize():void
		{
			dialogsList = new Vector.<IDialog>();
			dialogQueue = new Vector.<DisplayObject>();
			
			fadeQuad = new Fade(10, 10, 0x0);
			fadeQuad.visible = true;
			fadeQuad.alpha = 0;
			fadeQuad.touchable = false;
			
			//fadeQuad.addEventListener(TouchEvent.TOUCH, handler_fadeTouch);
			
			if (dialogsLayer)
				dialogsLayer.addChild(fadeQuad);
		
			history = new <String>[];	
			//handler_resize(null);
		}
		
		public static function addDialog(dialog:DisplayObject, canOpenOverCurrent:Boolean = false, skipDeferring:Boolean = false):void
		{
			if (Game.current && (Game.current.currentScreen is GameScreen)) 
			{
				if (instance.dialogsLayer != (Game.current.currentScreen as GameScreen).dialogsLayer) {
					setDialogsLayer((Game.current.currentScreen as GameScreen).dialogsLayer);
					NativeStageRedErrorPlate.show(10, "Error WRONG DIALOG SCREEN LAYER!");
				}
				/*
				if (!instance.dialogsLayer)
				{
					NativeStageRedErrorPlate.show(10, "Error DIALOG SCREEN LAYER NOT SET!");
				}
				else if (!instance.dialogsLayer.visible) 
				{
					//instance.dialogsLayer.visible = true;
					NativeStageRedErrorPlate.show(10, "Error DIALOG SCREEN LAYER VISIBLE FALSE!");
				}
				*/
			}
			
			instance.addDialog(dialog, canOpenOverCurrent, skipDeferring);
		}
		
		static public function hideDialogLayer():void
		{
			instance.hideDialogLayer();
		}
		
		static public function showDialogLayer():void
		{
			instance.showDialogLayer();
		}
		
		private function showDialogLayer():void
		{
			if (dialogsLayer)
			{
				dialogsLayer.visible = true;
			}
		}
		
		private function hideDialogLayer():void
		{
			if (dialogsLayer)
			{
				dialogsLayer.visible = false;
			}
		}
		
		public static function closeAll(exceptions:Array = null, cleanQueue:Boolean = true):void
		{
			var i:int;
			while (i < instance.dialogsList.length)
			{
				if (hasInList(instance.dialogsList[i], exceptions))
				{
					i++;
				}
				else
				{
					(instance.dialogsList[i] as IDialog).close();
					instance.dialogsList.splice(i, 1);
				}
			}
			
			i = 0;
			if (cleanQueue)
			{
				while (i < instance.dialogQueue.length)
				{
					if (hasInList(instance.dialogQueue[i] as IDialog, exceptions))
						i++;
					else
						instance.dialogQueue.splice(i, 1);
				}
			}
		}
		
		static public function cleanUpAndDeferShowingDialogs():void
		{
			instance.cleanUpAndDeferShowingDialogs();
		}
		
		static public function showDeferredDialogs():void
		{
			instance.showDeferredDialogs();
		}
		
		private function showDeferredDialogs():void
		{
			if (!startDialogsQueue.started)
			{
				startDialogsQueue.start();
			}
		}
		
		private function cleanUpAndDeferShowingDialogs():void
		{
			closeAll();
			dialogsDeferred = true;
			startDialogsQueue.clean();
		}
		
		public function addDialog(dialog:DisplayObject, canOpenOverOthers:Boolean = false, skipDeferring:Boolean = false):void
		{
			if ((dialogsDeferred && !skipDeferring) || !dialogsLayer)
			{
				startDialogsQueue.addToQueue(dialog, canOpenOverOthers);
				return;
			}
			
			if (dialogsList.length > 0 && !canOpenOverOthers)
			{
				dialogQueue.push(dialog);
				return;
			}
			
			if (Game.current.gameScreen)
				Game.current.gameScreen.closeSideMenu();
			
			sosTrace('addDialog ', getQualifiedClassName(dialog));
			
			var className:Array = String(getQualifiedClassName(dialog)).split('::');
			addToHistory(getTimer().toString() + ":" + (className.length > 1 ? className[1] : className[0]));
			
			gameManager.analyticsManager.sendDeltaDNAEvent(
				new DDNAUIInteractionEvent(
					"dialogOpen", 
					DDNAUIInteractionEvent.LOCATION_GLOBAL, 
					className.length > 1 ? className[1] : className[0], 
					DDNAUIInteractionEvent.TYPE_DIALOG));
			
			dispatchEventWith(EVENT_ADD, true, dialog);
			
			var interfacedDialog:IDialog;
			
			if (!(dialog is IDialog))
			{
				interfacedDialog = new DialogWrapper(dialog);
			}
			else
			{
				interfacedDialog = dialog as IDialog;
			}
			
			dialogsList.push(interfacedDialog);
			
			dialog.addEventListener(Event.REMOVED_FROM_STAGE, handler_dialogRemovedFromStage);
			
			dialogsLayer.addChild(dialog);
			
			resizeDialogs();
			if (dialog is FeathersControl)
			{
				(dialog as FeathersControl).validate();
			}
			alignDialog(dialog, dialogsList[dialogsList.length - 1].align);
			
			refreshFade();
		}
		
		public function getDialogByClass(clazz:Class):DisplayObject
		{
			for (var i:int = 0; i < dialogsLayer.numChildren; i++)
			{
				if (dialogsLayer.getChildAt(i) is clazz)
				{
					return dialogsLayer.getChildAt(i);
				}
			}
			return null;
		}
		
		public function closeDialogByClass(clazz:Class):void
		{
			var dialog:IDialog = getDialogByClass(clazz) as IDialog;
			if (dialog)
				dialog.close();
		}
		
		public function getDialogByClassInDialogList(clazz:Class):IDialog
		{
			var length:int = dialogsList.length;
			for (var i:int = 0; i < length; i++)
			{
				if (dialogsList[i] is clazz)
					return dialogsList[i];
			}
			return null;
		}
		
		public static function get logHistory():String
		{
			return _instance.history.join(', ');
		}
		
		private function resizeDialogs():void
		{
			fadeQuad.width = layoutHelper.stageWidth;
			fadeQuad.height = layoutHelper.stageHeight;
			
			var length:int = dialogsList.length;
			var i:int;
			for (i = 0; i < length; i++)
			{
				//TODO: rewrite completely
				var scale:Number = isNaN(dialogsList[i].baseScale) ? layoutHelper.scaleFromEtalonMin : dialogsList[i].baseScale;
				
				if (!dialogsList[i].selfScaled)
				{
					(dialogsList[i] as DisplayObject).scale = scale;
				}
				
				if (dialogsList[i] is BaseDialog)
				{
					(dialogsList[i] as BaseDialog).setHeightBound(layoutHelper.stageHeight / scale);
					(dialogsList[i] as BaseDialog).setWidthBound(layoutHelper.stageWidth / scale);
					(dialogsList[i] as BaseDialog).height = 720 * pxScale * scale;
				}
				alignDialog(dialogsList[i] as DisplayObject, dialogsList[i].align);
			}
		
			//var iDialog:IDialog = dialogsList.length > 0 ? (dialogsList[dialogsList.length - 1] as IDialog) : null;
		}
		
		private function handler_resize(event:Event):void
		{
			resizeDialogs();
		}
		
		private function alignDialog(dialog:DisplayObject, align:String):void
		{
			switch (align)
			{
			case Align.CENTER: 
			{
				dialog.x = int((gameManager.layoutHelper.stageWidth - dialog.width) / 2);
				dialog.y = int((gameManager.layoutHelper.stageHeight - dialog.height) / 2);
				break;
			}
			}
		}
		
		private function refreshFade():void
		{
			Starling.juggler.removeTweens(fadeQuad);
			
			var iDialog:IDialog = dialogsList.length > 0 ? (dialogsList[dialogsList.length - 1] as IDialog) : null;
			
			if (iDialog && iDialog.fadeStrength > 0)
			{
				fadeQuad.touchable = iDialog.blockerFade;
				Starling.juggler.tween(fadeQuad, 0.1, {transition: Transitions.LINEAR, alpha: iDialog.fadeStrength});
			}
			else
			{
				hideFade();
			}
			
			dialogsLayer.addChildAt(fadeQuad, Math.max(0, dialogsList.length - 1));
		}
		
		private function handler_fadeTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(fadeQuad);
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				fadeQuadClick();
			}
		}
		
		private function deTouchFade():void
		{
			fadeQuad.touchable = false;
		}
		
		private function fadeQuadClick():void
		{
			//fadeQuad.touchable = false;
			if (dialogsList.length > 0)
			{
				var iDialog:IDialog = dialogsList[dialogsList.length - 1] as IDialog;
				
				if (iDialog.fadeClosable)
				{
					iDialog.close();
					if (dialogsList.length == 0)
						hideFade();
				}
				
			}
			else
			{
				hideFade();
			}
		}
		
		private function hideFade():void
		{
			deTouchFade();
			if (fadeQuad.alpha != 0)
				Starling.juggler.tween(fadeQuad, 0.1, {transition: Transitions.LINEAR, alpha: 0, onComplete: deTouchFade});
			else
				deTouchFade();
		}
		
		private function handler_addedToStage(e:Event):void
		{
			_instance.dialogsLayer.stage.addEventListener(Event.RESIZE, handler_resize);
			addDialogFromQueue();
			resizeDialogs();
		}
		
		private function handler_removedFromStage(e:Event):void
		{
			_instance.dialogsLayer.stage.removeEventListener(Event.RESIZE, handler_resize);
		}
		
		private function handler_dialogRemovedFromStage(event:Event):void
		{
			var dialog:DisplayObject = event.target as DisplayObject;
			
			var i:int;
			var iDialog:IDialog;
			var length:int = dialogsList.length;
			for (i = 0; i < length; i++)
			{
				iDialog = dialogsList[i];
				if (iDialog == dialog || (iDialog is DialogWrapper && (iDialog as DialogWrapper).dialog == dialog))
				{
					dialog.removeEventListener(Event.REMOVED_FROM_STAGE, handler_dialogRemovedFromStage);
					dialogsList.splice(i, 1);
					dispatchEventWith(EVENT_REMOVE, true, dialog);
					break;
				}
			}
			
			refreshFade();
			
			if (dialogsList.length == 0) 
				addToHistory(getTimer().toString() + ":none");
			
			if (dialogsLayer.stage)
			{
				addDialogFromQueue();
			}
		}
		
		private function addDialogFromQueue():void
		{
			if (dialogsList.length == 0 && dialogQueue.length > 0)
			{
				addDialog(dialogQueue.shift());
			}
		}
		
		private static function hasInList(baseDialog:IDialog, list:Array = null):Boolean
		{
			if (!list || !baseDialog)
				return false;
			
			var i:int;
			var length:int = list.length;
			for (i = 0; i < length; i++)
			{
				trace(list[i] is Class, baseDialog is list[i], baseDialog is (list[i] as Class));
				if ((list[i] is Class) && baseDialog is list[i])
					return true;
				else if (list[i] == baseDialog)
					return true;
			}
			
			return false;
		}
		
		private function addToHistory(value:String):void {
			history.push(value);
			if (history.length > historyDepth)
				history.shift();
		}
	}
}

import starling.display.DisplayObject;
import com.alisacasino.bingo.dialogs.IDialog
import starling.display.Quad;
import starling.utils.Align;

final class DialogWrapper implements IDialog
{
	
	public function DialogWrapper(dialog:DisplayObject)
	{
		this.dialog = dialog;
		_fadeStrength = fadeStrength;
		_blockerFade = blockerFade;
		_fadeClosable = fadeClosable;
		_selfScaled = false; //TODO: make sure it's actually this
	}
	
	public var dialog:DisplayObject;
	
	private var _fadeStrength:Number = 0;
	private var _blockerFade:Boolean;
	private var _fadeClosable:Boolean;
	private var _selfScaled:Boolean;
	
	public function get fadeStrength():Number
	{
		return _fadeStrength;
	}
	
	public function get blockerFade():Boolean
	{
		return _blockerFade;
	}
	
	public function get fadeClosable():Boolean
	{
		return _fadeClosable;
	}
	
	public function get align():String
	{
		return Align.CENTER;
	}
	
	public function resize():void
	{
		if ('resize' in (dialog as Object))
			(dialog['resize'] as Function)();
	}
	
	public function close():void
	{
		if ('close' in (dialog as Object))
			(dialog['close'] as Function)();
		else
			dialog.removeFromParent();
	}
	
	/* INTERFACE com.alisacasino.bingo.dialogs.IDialog */
	
	public function get selfScaled():Boolean
	{
		return _selfScaled;
	}
	
	public function get baseScale():Number
	{
		return NaN;
	}
}

final class Fade extends Quad
{
	public function Fade(width:Number, height:Number, color:uint = 0xffffff)
	{
		super(width, height, color);
	}
	
	override public function dispose():void
	{
		return;
	}
}