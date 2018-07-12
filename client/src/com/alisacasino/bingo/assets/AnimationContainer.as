package com.alisacasino.bingo.assets 
{
	import com.alisacasino.bingo.assets.loading.GAFClipWrapper;
	import com.alisacasino.bingo.utils.misc.FunctionCallData;
	import com.catalystapps.gaf.data.GAFTimeline;
	import com.catalystapps.gaf.data.config.CAnimationSequence;
	import com.catalystapps.gaf.data.config.CFrameAction;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import starling.core.Starling;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	
	/** Dispatched when the currently playing clip reaches its set number of repetitions. Will not dispatch when looping endlessly. */
	[Event(name = "complete", type = "starling.events.Event")]
	
	
	public class AnimationContainer extends FeathersControl
	{
		private static var cyclingList:Object = {};
		//private static var cyclingList:Dictionary = {};
		
		public function get clipWidth():Number
		{
			return getClipBounds().width;
		}
		
		public function get clipHeight():Number
		{
			return getClipBounds().height;
		}
		
		public function get clipX():Number
		{
			return getClipBounds().x;
		}
		
		public function get clipY():Number
		{
			return getClipBounds().y;
		}
		
		private var _asset:MovieClipAsset;
		
		public function get asset():MovieClipAsset 
		{
			return _asset;
		}
		
		public function set asset(value:MovieClipAsset):void 
		{
			if (_asset == value)
			{
				return;
			}
			
			removeCurrentClip();
			
			_asset = value;
			
			if (!_asset)
			{
				_currentTimelineID = "";
				removeCurrentClip();
				clearStorages();
				return;
			}
			
			if (_currentTimelineID == "")
			{
				_currentTimelineID = _asset.getDefaultTimelineID();
			}
			
			if (stage)
			{
				addClipAndPlay();
			}
			else
			{
				needToAddClip = true;
			}
		}
		
		public function get currentTimelineID():String
		{
			return _currentTimelineID;
		}
		
		public static const EVENT_COMPLETE_TIMELINE:String = "EVENT_COMPLETE_TIMELINE";
		public var dispatchOnCompleteTimeline:Boolean;
		
		private var _currentTimelineID:String = "";
		private var _currentClip:GAFClipWrapper;
		private var propertyStorage:Object;
		private var methodStorage:Vector.<FunctionCallData>;
		private var changingClip:Boolean;
		private var _repeatCount:int = 1;
		private var timelineBounds:Rectangle;
		private var needToAddClip:Boolean;
		private var _fps:int = -1;
		
		// any data
		public var data:Object;
		
		public function get currentClip():GAFClipWrapper {
			return _currentClip;
		}
		
		/**
		 * Resets when playTimeline() is called.
		 * @default: 1 repetition
		 * 0 - repeat endlessly
		 */
		public function get repeatCount():int 
		{
			return _repeatCount;
		}
		
		public function set repeatCount(value:int):void 
		{
			_repeatCount = value;
			if (_repeatCount == 1)
			{
				setClipProperty("loop", false);
			}
			else 
			{
				setClipProperty("loop", true);
			}
		}
		
		public function AnimationContainer(asset:MovieClipAsset = null, loop:Boolean = false, forceAddClip:Boolean = false, timelineID:String = "") 
		{
			_currentTimelineID = timelineID;
			this.asset = asset;
			
			repeatCount = loop ? 0 : 1;
			
			if (forceAddClip) {
				needToAddClip = false;
				addClipAndPlay(false);
			}
			
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void 
		{
			if (needToAddClip)
			{
				addClipAndPlay();
				needToAddClip = false;
			}
			if (_currentClip)
			{
				Starling.juggler.add(_currentClip);
			}
		}
		
		private function removedFromStageHandler(e:Event):void 
		{
			if (_currentClip)
			{
				Starling.juggler.remove(_currentClip);
			}
		}
		
		public function playTimeline(timelineID:String = "", forceReset:Boolean = false, loop:Boolean = false, fps:int = -1, repeatCount:int = 1):void
		{
			if (!asset)
			{
				return;
			}
			
			if (timelineID == "")
			{
				timelineID = asset.getDefaultTimelineID();
			}
			
			clearStorages();
			
			if (_currentTimelineID == timelineID && !forceReset)
			{
				this.repeatCount = loop ? 0 : repeatCount;
				return;
			}
			
			changingClip = true;
			_currentTimelineID = timelineID;
			
			_fps = fps;
			removeCurrentClip();
			
			this.repeatCount = loop ? 0 : repeatCount;
			addClipAndPlay();
			needToAddClip = false;
		}
		
		private function clearStorages():void 
		{
			propertyStorage = null;
			methodStorage = null;
		}
		
		/* DELEGATE com.alisacasino.bingo.assets.loading.GAFClipWrapper */
		
		public function play(applyToAllChildren:Boolean = false):void 
		{
			callClipMethod("play", applyToAllChildren);
		}
		
		public function stop(applyToAllChildren:Boolean = false):void 
		{
			callClipMethod("stop", applyToAllChildren);
		}
		
		public function addClipEventListener(type:String, listener:Function):void
		{
			callClipMethod("addEventListener", type, listener);
		}
		
		public function removeClipEventListener(type:String, listener:Function):void
		{
			callClipMethod("removeEventListener", type, listener);
		}
		
		public function callClipMethod(methodName:String, ...args):void 
		{
			if (!asset || !asset.loaded)
			{
				return;
			}
			
			if (_currentClip && !changingClip)
			{
				FunctionCallData.callFunctionOnTarget(_currentClip, methodName, args);
			}
			else
			{
				storeMethodCall(new FunctionCallData(methodName, args));
			}
		}
		
		public function goToAndPlay(frame:*):void 
		{
			callClipMethod("gotoAndPlay", frame);
		}
		
		public function goToAndStop(frame:*):void 
		{
			callClipMethod("gotoAndStop", frame);
		}
		
		public function playSequence(id:String, play:Boolean = true):void 
		{
			callClipMethod("setSequence", id, play);
		}
		
		public function clearSequence(id:String = null):void 
		{
			callClipMethod("clearAnimationSequence", id);
		}
		
		public function getClipBounds():Rectangle 
		{
			var result:Rectangle = timelineBounds;
			if (!result)
			{
				sosTrace( "getClipBounds was forced to revert to new rect generation for " + asset, SOSLog.WARNING);
				result = new Rectangle(0, 0, 0, 0);
			}
			return result;
		}
		
		public function set reverse(value:Boolean):void 
		{
			if (_currentClip && !changingClip)
				_currentClip.reverse = value;
		}
		
		public function get reverse():Boolean
		{
			return (_currentClip && !changingClip) ? _currentClip.reverse : false; 
		}
		
		public function get currentFrame(): uint
		{
			return (_currentClip && !changingClip) ? _currentClip.currentFrame : 1; // First frame is "1"
		}
		
		public function get totalFrames(): uint
		{
			return (_currentClip && !changingClip) ? _currentClip.totalFrames : 1; // First frame is "1"
		}
		
		public function set fps(value:int):void
		{
			_fps = value;
		}
		
		public function get fps():int
		{
			return _fps;
		}
		
		public function addEventOnFrame(frame:uint, event:String, bubbles:Boolean = false, data:Object = null):void {
			if(_currentClip)
				_currentClip.addEventOnFrame(frame, event, bubbles, data);
		}
		
		public function removeEventOnFrame(frame:uint, event:String):void 
		{
			if(_currentClip)
				_currentClip.removeEventOnFrame(frame, event);
		}
		
		/*public function addClipEventListener(event:String, handler:Function):void {
			_currentClip.addEventListener(event, handler_movieEvent);
		}*/
		
		public function addAnimationSequence(id:String, startFrame:uint, endFrame:uint):void {
			if(_currentClip)
				_currentClip.addAnimationSequence(id, startFrame, endFrame);
		}
		
		/**
		 * return cyclingTime:Number; total cycling time in seconds
		 **/
		public function cycle(id:String, startFrame:int, finishFrame:int, count:int, removeCycleOnFinish:Boolean = false):Number
		{
			var cyclingProperties:CyclingProperties;
			var eventName:String = id + "_animationEventCycle" + startFrame.toString() + finishFrame.toString();
			
			if (id in cyclingList) 
			{
				cyclingProperties = cyclingList[id] as CyclingProperties;
				if (cyclingProperties.startFrame != startFrame || cyclingProperties.finishFrame != finishFrame) 
				{
					var oldEventName:String = id + "_animationEventCycle" + cyclingProperties.startFrame.toString() + cyclingProperties.finishFrame.toString();
					removeClipEventListener(oldEventName, handler_animationCycleFinish);
					removeEventOnFrame(cyclingProperties.finishFrame, oldEventName);
					
					//addClipEventListener(eventName, handler_animationCycleFinish);
					addEventOnFrame(finishFrame, eventName, false, id);
				}
			}	
			else {
				cyclingProperties = new CyclingProperties();
				cyclingList[id] = cyclingProperties;
				
				addEventOnFrame(finishFrame, eventName, false, id);
			}
			
			addClipEventListener(eventName, handler_animationCycleFinish);
			
			cyclingProperties.counter = 0;
			cyclingProperties.count = count;
			cyclingProperties.startFrame = startFrame;
			cyclingProperties.finishFrame = finishFrame;
			cyclingProperties.removeCycleOnFinish = removeCycleOnFinish;
			
			return count * ((finishFrame-startFrame) / fps);
		}
		
		private function handler_animationCycleFinish(event:Event):void 
		{
			var cyclingProperties:CyclingProperties;
			var cycleId:String = String(event.data);
			if (cycleId in cyclingList) 
			{
				cyclingProperties = cyclingList[cycleId] as CyclingProperties;
				
				if (cyclingProperties.counter < cyclingProperties.count) 
				{
					goToAndPlay(cyclingProperties.startFrame);
					cyclingProperties.counter++;
				}
				else
				{
					if(cyclingProperties.removeCycleOnFinish) 
						removeCycle(cycleId);
					else
						cyclingProperties.counter = 0;
				}
			}
			else
			{
				removeCycle(cycleId);
			}
			
			/*if (cycleCount > 0)
			{
				goToAndPlay(cycleStartFrame, false);
				cycleCount--;
			}
			else 
			{
				removeClipEventListener("animationEventCycle"+cycleStartFrame.toString()+cycleFinishFrame.toString(), handler_animationCycleFinish);
				//removeEventOnFrame(cycleFinishFrame, "animationEventCycle"+cycleStartFrame.toString()+cycleFinishFrame.toString());
				cycleStartFrame = 0;
				cycleFinishFrame = 0;
			}*/
		}
		
		public function removeCycle(id:String):void
		{
			var cyclingProperties:CyclingProperties;
			if (id in cyclingList)
			{
				cyclingProperties = cyclingList[id] as CyclingProperties;
				var eventName:String = id + "_animationEventCycle" + cyclingProperties.startFrame.toString() + cyclingProperties.finishFrame.toString();
				removeClipEventListener(eventName, handler_animationCycleFinish);
				removeEventOnFrame(cyclingProperties.finishFrame, eventName);
				delete cyclingList[id];
			}
		}
		
		/*public static function removeAllCycles():void
		{
			
		}*/
		
		private function storeMethodCall(functionCallData:FunctionCallData):void 
		{
			if (!methodStorage)
			{
				methodStorage = new Vector.<FunctionCallData>();
			}
			methodStorage.push(functionCallData);
		}
		
		private function setClipProperty(propertyName:String, value:*):void 
		{
			if (_currentClip && !changingClip)
			{
				if (_currentClip.hasOwnProperty(propertyName))
				{
					_currentClip[propertyName] = value;
				}
				else 
				{
					throw new Error("No property " + propertyName + " on GAFClipWrapper");
				}
			}
			else
			{
				storeProperty(propertyName, value);
			}
		}
		
		private function storeProperty(propertyName:String, value:*):void 
		{
			if (!propertyStorage)
			{
				propertyStorage = { };
			}
			propertyStorage[propertyName] = value;
		}
		
		private function getClipProperty(propertyName:String):*
		{
			if (_currentClip)
			{
				return _currentClip[propertyName];
			}
			else if (propertyStorage)
			{
				return propertyStorage[propertyName];
			}
			
			return null;
		}
		
		private function addClipAndPlay(play:Boolean = true):void 
		{
			if (!asset)
			{
				return;
			}
			
			if (_currentClip)
			{
				removeCurrentClip();
			}
			
			_currentClip = asset.getFromPool(_currentTimelineID, repeatCount == 0);
			changingClip = false;
			if (!_currentClip)
			{
				sosTrace("No clip found with linkage id " + _currentTimelineID + " in asset " + asset, SOSLog.WARNING);
				timelineBounds = new Rectangle(0, 0, 0, 0);
				return;
			}
			
			if(fps != -1)
				_currentClip.fps = fps;
				
			addChild(_currentClip);
			
			if(play)
				_currentClip.play();
			
			applyStored();
			clearStorages();
			
			timelineBounds = _currentClip.timelineBounds;
			
			setSizeInternal(timelineBounds.right, timelineBounds.bottom, false);
			
			addClipEventListener(Event.COMPLETE, clip_completeHandler);
		}
		
		private function clip_completeHandler(e:Event):void 
		{
			if (repeatCount > 0)
			{
				_repeatCount--;
				if (repeatCount < 1)
				{
					_repeatCount = 1;
					setClipProperty("loop", false);
					if (_currentClip)
					{
						_currentClip.stop();
					}
					dispatchEventWith(Event.COMPLETE);
				}
				else if (dispatchOnCompleteTimeline) {
					dispatchEventWith(EVENT_COMPLETE_TIMELINE);
				}
			}
			else if (dispatchOnCompleteTimeline) {
				dispatchEventWith(EVENT_COMPLETE_TIMELINE);
			}
		}
		
		private function applyStored():void 
		{
			applyProperties();
			applyMethods();
		}
		
		private function applyProperties():void 
		{
			if (!_currentClip)
			{
				sosTrace("No clip set when trying to apply properties", SOSLog.WARNING);
				return;
			}
			
			if (!propertyStorage)
			{
				return;
			}
			
			for (var propertyName:String in propertyStorage) 
			{
				setClipProperty(propertyName, propertyStorage[propertyName]);
			}
		}
		
		private function applyMethods():void 
		{
			if (!_currentClip)
			{
				sosTrace("No clip set when trying to apply methods", SOSLog.WARNING);
				return;
			}
			
			if (!methodStorage)
			{
				return;
			}
			
			for (var i:int = 0; i < methodStorage.length; i++) 
			{
				methodStorage[i].callOnTarget(_currentClip);
			}
		}
		
		private function removeCurrentClip():void 
		{
			if (_currentClip)
			{
				_currentClip.removeFromParent();
				_currentClip.removeEventListeners();
				Starling.juggler.remove(_currentClip);
				if (_currentClip.asset)
				{
					_currentClip.asset.putToPool(_currentClip);
				}
				_currentClip = null;
				timelineBounds = new Rectangle(0, 0, 0, 0);
				
				/*if (cycleCount > 0) {
					cycleCount = 0;
					handler_animationCycleFinish(null);
				}*/
			}
		}
		
		override public function dispose():void 
		{
			removeCurrentClip();
			data = null;
			super.dispose();
		}
		
	}

}

class CyclingProperties 
{
	public var id:String;
	public var count:int;
	public var counter:int;
	public var startFrame:int;
	public var finishFrame:int;
	public var removeCycleOnFinish:Boolean;
	
	public function CyclingProperties() {
		
	}
}