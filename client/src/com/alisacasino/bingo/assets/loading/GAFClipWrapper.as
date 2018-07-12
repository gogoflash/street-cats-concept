package com.alisacasino.bingo.assets.loading 
{
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.utils.disposal.IDisposable;
	import com.catalystapps.gaf.data.GAFTimeline;
	import com.catalystapps.gaf.data.config.CAnimationSequence;
	import com.catalystapps.gaf.data.config.CFrameAction;
	import com.catalystapps.gaf.display.GAFMovieClip;
	import flash.display.FrameLabel;
	import flash.display.Scene;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class GAFClipWrapper extends GAFMovieClip implements IDisposable
	{
		public var asset:MovieClipAsset;
		
		
		private var _gafTimeline:GAFTimeline;
		private var fps:int;
		private var addToJuggler:Boolean;
		
		public function GAFClipWrapper(gafTimeline:GAFTimeline, fps:int = -1, addToJuggler:Boolean = true) 
		{
			super(gafTimeline, fps, addToJuggler);
			this.addToJuggler = addToJuggler;
			this.fps = fps;
			_gafTimeline = gafTimeline;
		}
		
		/* INTERFACE ssmit.GAFClipWrapper */
		
		public function gotoFrame(frameNumber:uint):void 
		{
			gotoAndStop(frameNumber);
		}
		
		public function clone():GAFClipWrapper
		{
			var clip:GAFClipWrapper = new GAFClipWrapper(gafTimeline, fps, addToJuggler);
			clip.asset = asset;
			return clip;
		}
		
		
		/*public function set loopStart(value:int):void 
		{
			_loopStart = value;
		}
		
		public function get loopStart():int 
		{
			return _loopStart;
		}*/
		
		public function get gafTimeline():GAFTimeline 
		{
			return _gafTimeline;
		}
		
		override public function dispose():void 
		{
			super.dispose();
		}
		
		public function returnToPool():void 
		{
			if (asset)
			{
				asset.putToPool(this);
			}
		}
		
		public function putToPool():void 
		{
			if (asset)
			{
				asset.putToPool(this);
			}
		}
		
		public function addEventOnFrame(frame:uint, event:String, bubbles:Boolean = false, data:Object = null):void 
		{
			var action:CFrameAction = new CFrameAction();
			action.type = CFrameAction.DISPATCH_EVENT;
			action.params[0] = event;
			action.params[1] = bubbles;
			if (data) {
				action.params[2] = null;
				action.params[3] = data;
			}
				
			gafTimeline.config.animationConfigFrames.frames[Math.min(gafTimeline.config.animationConfigFrames.frames.length-1, frame)].addAction(action);	
		}
		
		public function removeEventOnFrame(frame:uint, event:String):void 
		{
			var i:int;
			var action:CFrameAction;
			var cFrameActions:Vector.<CFrameAction> = gafTimeline.config.animationConfigFrames.frames[Math.min(gafTimeline.config.animationConfigFrames.frames.length - 1, frame)].actions;
			if (cFrameActions)
			{
				for (i = 0; i < cFrameActions.length; i++) {
					action = cFrameActions[i];
					if (action.type == CFrameAction.DISPATCH_EVENT && action.params[0] == event) {
						cFrameActions.splice(i, 1);
						break;
					}
				}
			}
		}
		
		public function removeEventFrames():void {
			// валит анимаху. не надо так.
			//gafTimeline.config.animationConfigFrames.frames.splice(0, gafTimeline.config.animationConfigFrames.frames.length);
		}
		
		public function addAnimationSequence(id:String, startFrame:uint, endFrame:uint):void {
			gafTimeline.config.animationSequences.addSequence(new CAnimationSequence(id, startFrame, endFrame));
		}
		
		public function clearAnimationSequence(id:String = null):void 
		{
			clearSequence();
			
			var sequences:Vector.<CAnimationSequence> = gafTimeline.config.animationSequences.sequences;
			if (id == null) {
				sequences.splice(0, sequences.length);
				return;
			}
			
			var i:int;
			var length:int = sequences.length;
			
			for (i = 0; i < length; i++)
			{
				if (sequences[i].id == id)
				{
					sequences.splice(i, 1);
					return;
				}
			}
		}
	}

}