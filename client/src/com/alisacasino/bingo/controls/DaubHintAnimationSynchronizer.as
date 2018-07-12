package com.alisacasino.bingo.controls
{
	
	import com.alisacasino.bingo.assets.AnimationContainer;
	import starling.events.Event;

	
	public class DaubHintAnimationSynchronizer
	{
		public function DaubHintAnimationSynchronizer() {
			
		}
		
		private static var daubHintSynchroneSources:Vector.<AnimationContainer> = new <AnimationContainer>[];
		private static var daubHintSynchroneTargets:Vector.<AnimationContainer> = new <AnimationContainer>[];
		
		public static function unRegisterDaubHintSynchroneSource(animation:AnimationContainer):void {
			var i:int = daubHintSynchroneSources.indexOf(animation);
			if (i != -1) {
				animation.removeEventListener(AnimationContainer.EVENT_COMPLETE_TIMELINE, handler_synchrone);
				daubHintSynchroneSources.splice(i, 1);
			}
			
			i = daubHintSynchroneTargets.indexOf(animation);
			if(i != -1) 
				daubHintSynchroneTargets.splice(i, 1);
			
			if (daubHintSynchroneSources.length == 0)
				playSynchroneTargets();
		}
		
		public static function registerDaubHintSynchroneTarget(animation:AnimationContainer):void 
		{
			if (daubHintSynchroneSources.length == 0 || daubHintSynchroneSources[0].currentFrame == 1) {
				animation.playTimeline('daub_hint', false, false, 24, animation.repeatCount);
				daubHintSynchroneSources.push(animation);
				animation.addEventListener(AnimationContainer.EVENT_COMPLETE_TIMELINE, handler_synchrone);
			}
			else {
				daubHintSynchroneTargets.push(animation);
			}
		}
		
		private static function playSynchroneTargets():void 
		{
			var animation:AnimationContainer;
			while(daubHintSynchroneTargets.length > 0) {
				animation = daubHintSynchroneTargets.shift();
				animation.playTimeline('daub_hint', false, false, 24, animation.repeatCount);
				daubHintSynchroneSources.push(animation);
				animation.addEventListener(AnimationContainer.EVENT_COMPLETE_TIMELINE, handler_synchrone);
			}
		}	
		
		private static function handler_synchrone(e:Event):void {
			playSynchroneTargets();
		}
	
		
		public static function clean():void 
		{
			var animation:AnimationContainer;
			while(daubHintSynchroneSources.length > 0) {
				animation = daubHintSynchroneSources.shift();
				animation.removeEventListener(AnimationContainer.EVENT_COMPLETE_TIMELINE, handler_synchrone);
			}
			
			daubHintSynchroneTargets.splice(0, daubHintSynchroneTargets.length);
		}	
	}
	
}