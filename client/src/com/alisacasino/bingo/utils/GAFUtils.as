package com.alisacasino.bingo.utils 
{
	import com.catalystapps.gaf.data.GAFTimeline;
	import com.catalystapps.gaf.data.GAFTimelineConfig;
	import com.catalystapps.gaf.data.config.CAnimationFrame;
	import com.catalystapps.gaf.data.config.CAnimationFrameInstance;
	import com.catalystapps.gaf.data.config.CAnimationObject;
	import com.catalystapps.gaf.core.gaf_internal;
	import flash.geom.Matrix;
	
	public class GAFUtils 
	{
		public function GAFUtils() 
		{
			
		}
		
		public static function createGAFMovieClip(originalGAFTimeline:GAFTimeline, id:String, keyChildIndex:String, childIndex:int = 0, debug:Boolean = false):void 
		{
			if (!originalGAFTimeline || originalGAFTimeline.gafAsset.gaf_internal::getGAFTimelineByID(id))
				return;
				
			var timeLineConfig:GAFTimelineConfig = new GAFTimelineConfig('1');
			timeLineConfig.id = id;
			timeLineConfig.textureAtlas = originalGAFTimeline.config.textureAtlas;
			
			var timeLine:GAFTimeline = new GAFTimeline(timeLineConfig);
			timeLine.gafAsset = originalGAFTimeline.gafAsset;
			
			originalGAFTimeline.gafAsset.addGAFTimeline(timeLine);
			
			var frames:Vector.<CAnimationFrame> = originalGAFTimeline.config.animationConfigFrames.frames;
			var frame:CAnimationFrame;
			var animationFrameInstances:Vector.<CAnimationFrameInstance>;
			var animationFrameInstance: CAnimationFrameInstance;
			var animationFrameInstanceHelper: CAnimationFrameInstance;
			var i:int;
			var j:int;
			var length:int = frames.length;
			var animationFrameInstancesLength:int;
			var _childIndex:int;
			
			if (debug) {
				var debugInstancesKeys:Array = [];
				var debugInstancesKeysHelper:Array = [];
			}
			
			for (i = 0; i < length; i++) 
			{
				frame = frames[i];
				animationFrameInstances = frame.instances;
				animationFrameInstancesLength = animationFrameInstances.length;
				
				animationFrameInstance = new CAnimationFrameInstance(id);
				
				if (keyChildIndex) 
				{
					animationFrameInstanceHelper = frame.getInstanceByID(keyChildIndex);
					if (animationFrameInstanceHelper) {
						animationFrameInstances.insertAt(animationFrameInstances.indexOf(animationFrameInstanceHelper), animationFrameInstance);
						animationFrameInstance.update(animationFrameInstanceHelper.zIndex, new Matrix(), 1, null, null);
					}
				}
				else {
					_childIndex = Math.min(childIndex, animationFrameInstancesLength);
					animationFrameInstance.update(0, new Matrix(), 1, null, null);
					animationFrameInstances.insertAt(_childIndex, animationFrameInstance);
				}
				
				
				if (debug)
				{
					debugInstancesKeysHelper= [];
					for (j = 0; j < animationFrameInstancesLength; j++) 
					{
						debugInstancesKeysHelper.push(animationFrameInstances[j].id);
						if (i == 0)
							debugInstancesKeys.push(animationFrameInstances[j].id);
					}
					
					trace(i, ' keys: ', debugInstancesKeysHelper);	
					
					j = 0;
					while (j < debugInstancesKeys.length && i != 0) 
					{
						if (debugInstancesKeysHelper.indexOf(debugInstancesKeys[j]) == -1) {
							debugInstancesKeys.splice(j, 1);
						}
						else {
							j++;
						}
					}
				}
			}
			
			if (debug)
				trace('common keys:', debugInstancesKeys);	
			
			var cAnimationObject:CAnimationObject = new CAnimationObject(id, id, CAnimationObject.TYPE_TIMELINE, false);
			originalGAFTimeline.config.animationObjects.addAnimationObject(cAnimationObject);
		}
		
			
		
	}

}