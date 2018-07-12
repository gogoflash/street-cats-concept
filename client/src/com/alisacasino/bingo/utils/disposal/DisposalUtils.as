package com.alisacasino.bingo.utils.disposal 
{
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.text.TextField;

	public class DisposalUtils 
	{
		public static function destroy(displayObjectContainer:DisplayObjectContainer, disposeImages:Boolean = true):void {
			if(displayObjectContainer)
				recursiveDestroy(displayObjectContainer, disposeImages);
		}
		
		private static function recursiveDestroy(displayObjectContainer:DisplayObjectContainer, disposeImages:Boolean):void 
		{
			while (displayObjectContainer.numChildren > 0) {
				var child:DisplayObject = displayObjectContainer.removeChildAt(0);
				
				internalDestroy(child, disposeImages);
				if ((child is DisplayObjectContainer) && !(child is TextField)) 
					recursiveDestroy(DisplayObjectContainer(child), disposeImages);
			}
		}
		
		private static function internalDestroy(displayObject:DisplayObject, disposeImages:Boolean):void 
		{
			if (!displayObject) 
				return;

			if (displayObject is IAnimatable) 
				Starling.juggler.remove(IAnimatable(displayObject));

			if (displayObject is DisplayObject) {
				displayObject.filter = null;
				displayObject.removeEventListeners();
				displayObject.removeFromParent();
				if(disposeImages)
					displayObject.dispose();
			}

			if (displayObject is TextField)
				TextField(displayObject).dispose();
		}	
	}
}
