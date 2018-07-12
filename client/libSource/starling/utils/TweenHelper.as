package starling.utils 
{
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.core.starling_internal;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class TweenHelper 
	{
		
		public function TweenHelper() 
		{
		
		}
		
		public static function tween(target:Object, time:Number, properties:Object):Tween
        {
			var tween:Tween = makeTween(target, time, properties);
            Starling.juggler.add(tween);
			return tween;
        }
		
		static public function makeTween(target:Object, time:Number, properties:Object):Tween 
		{
			if (target == null) throw new ArgumentError("target must not be null");

            var tween:Tween = Tween.starling_internal::fromPool(target, time);
            
            for (var property:String in properties)
            {
                var value:Object = properties[property];
                
                if (tween.hasOwnProperty(property))
                    tween[property] = value;
                else if (target.hasOwnProperty(Tween.getPropertyName(property)))
                    tween.animate(property, value as Number);
                else
                    throw new ArgumentError("Invalid property: " + property);
            }
            
            tween.addEventListener(Event.REMOVE_FROM_JUGGLER, onPooledTweenComplete);
			
			return tween;
		}
		
		static private function onPooledTweenComplete(event:Event):void
        {
            Tween.starling_internal::toPool(event.target as Tween);
        }
		
	}

}