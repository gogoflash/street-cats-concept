// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================
//
// easing functions thankfully taken from http://dojotoolkit.org
//                                    and http://www.robertpenner.com/easing
//

package starling.animation
{
    import flash.utils.Dictionary;

    import starling.errors.AbstractClassError;

    /** The Transitions class contains static methods that define easing functions.
     *  Those functions are used by the Tween class to execute animations.
     * 
     *  <p>Here is a visual representation of the available transitions:</p> 
     *  <img src="http://gamua.com/img/blog/2010/sparrow-transitions.png"/>
     *  
     *  <p>You can define your own transitions through the "registerTransition" function. A 
     *  transition function must have the following signature, where <code>ratio</code> is 
     *  in the range 0-1:</p>
     *  
     *  <pre>function myTransition(ratio:Number):Number</pre>
     */
    public class Transitions
    {        
        public static const LINEAR:String = "linear";
        public static const EASE_IN:String = "easeIn";
        public static const EASE_OUT:String = "easeOut";
        public static const EASE_IN_OUT:String = "easeInOut";
        public static const EASE_OUT_IN:String = "easeOutIn";        
        public static const EASE_IN_BACK:String = "easeInBack";
        public static const EASE_OUT_BACK:String = "easeOutBack";
        public static const EASE_IN_OUT_BACK:String = "easeInOutBack";
        public static const EASE_OUT_IN_BACK:String = "easeOutInBack";
        public static const EASE_IN_ELASTIC:String = "easeInElastic";
        public static const EASE_OUT_ELASTIC:String = "easeOutElastic";
        public static const EASE_IN_OUT_ELASTIC:String = "easeInOutElastic";
        public static const EASE_OUT_IN_ELASTIC:String = "easeOutInElastic";  
        public static const EASE_IN_BOUNCE:String = "easeInBounce";
        public static const EASE_OUT_BOUNCE:String = "easeOutBounce";
        public static const EASE_IN_OUT_BOUNCE:String = "easeInOutBounce";
        public static const EASE_OUT_IN_BOUNCE:String = "easeOutInBounce";
        public static const EASE_IN_CUBIC_OUT_BACK:String = "easeInCubicOutBack";
        public static const EASE_IN_SINE:String = "easeInSine";
        public static const EASE_OUT_SINE:String = "easeOutSine";
        public static const EASE_IN_QUAD:String = "easeInQuad";
        public static const EASE_OUT_QUAD:String = "easeOutQuad";
		static public const EASE_IN_OUT_SINE:String = "easeInOutSine";
		
		
        
        private static var sTransitions:Dictionary;
        
        /** @private */
        public function Transitions() { throw new AbstractClassError(); }
        
        /** Returns the transition function that was registered under a certain name. */ 
        public static function getTransition(name:String):Function
        {
            if (sTransitions == null) registerDefaults();
            return sTransitions[name];
        }
        
        /** Registers a new transition function under a certain name. */
        public static function register(name:String, func:Function):void
        {
            if (sTransitions == null) registerDefaults();
            sTransitions[name] = func;
        }
        
        private static function registerDefaults():void
        {
            sTransitions = new Dictionary();
            
            register(LINEAR, linear);
            register(EASE_IN, easeIn);
            register(EASE_OUT, easeOut);
            register(EASE_IN_OUT, easeInOut);
            register(EASE_OUT_IN, easeOutIn);
            register(EASE_IN_BACK, easeInBack);
            register(EASE_OUT_BACK, easeOutBack);
            register(EASE_IN_OUT_BACK, easeInOutBack);
            register(EASE_OUT_IN_BACK, easeOutInBack);
            register(EASE_IN_ELASTIC, easeInElastic);
            register(EASE_OUT_ELASTIC, easeOutElastic);
            register(EASE_IN_OUT_ELASTIC, easeInOutElastic);
            register(EASE_OUT_IN_ELASTIC, easeOutInElastic);
            register(EASE_IN_BOUNCE, easeInBounce);
            register(EASE_OUT_BOUNCE, easeOutBounce);
            register(EASE_IN_OUT_BOUNCE, easeInOutBounce);
            register(EASE_OUT_IN_BOUNCE, easeOutInBounce);
            register(EASE_IN_CUBIC_OUT_BACK, easeInCubicOutBack);
            register(EASE_IN_SINE, easeInSine);
            register(EASE_OUT_SINE, easeOutSine);
            register(EASE_IN_QUAD, easeInQuad);
            register(EASE_OUT_QUAD, easeOutQuad);
            register(EASE_IN_OUT_SINE, easeInOutSine);
        }         
		
		static private function easeInOutSine(ratio:Number):Number
		{
			return easeCombined(easeInSine, easeOutSine, ratio);
		}
        
        // transition functions
        
        protected static function linear(ratio:Number):Number
        {
            return ratio;
        }
        
        protected static function easeIn(ratio:Number):Number
        {
            return ratio * ratio * ratio;
        }    
        
        protected static function easeOut(ratio:Number):Number
        {
            var invRatio:Number = ratio - 1.0;
            return invRatio * invRatio * invRatio + 1;
        }        
        
        protected static function easeInOut(ratio:Number):Number
        {
            return easeCombined(easeIn, easeOut, ratio);
        }   
        
        protected static function easeOutIn(ratio:Number):Number
        {
            return easeCombined(easeOut, easeIn, ratio);
        }
		
		protected static function easeInQuad(ratio:Number):Number
        {
            return ratio * ratio;
        }
		
		protected static function easeOutQuad(ratio:Number):Number
        {
			return -ratio * (ratio - 2);
        }
		
		protected static function easeInSine(ratio:Number):Number
        {
            return - Math.cos(ratio * (Math.PI/2)) + 1;
        }
		
		protected static function easeOutSine(ratio:Number):Number
        {
            return Math.sin(ratio * (Math.PI/2));
        }
        
        protected static function easeInBack(ratio:Number):Number
        {
            var s:Number = 1.70158;
            return Math.pow(ratio, 2) * ((s + 1.0)*ratio - s);
        }
        
        protected static function easeOutBack(ratio:Number):Number
        {
            var invRatio:Number = ratio - 1.0;            
            var s:Number = 1.70158;
            return Math.pow(invRatio, 2) * ((s + 1.0)*invRatio + s) + 1.0;
        }
        
        protected static function easeInOutBack(ratio:Number):Number
        {
            return easeCombined(easeInBack, easeOutBack, ratio);
        }   
        
		protected static function easeInCubicOutBack(ratio:Number):Number
        {
            return easeCombined(easeIn, easeOutBack, ratio);
        }   
		
        protected static function easeOutInBack(ratio:Number):Number
        {
            return easeCombined(easeOutBack, easeInBack, ratio);
        }        
        
        protected static function easeInElastic(ratio:Number):Number
        {
            if (ratio == 0 || ratio == 1) return ratio;
            else
            {
                var p:Number = 0.3;
                var s:Number = p/4.0;
                var invRatio:Number = ratio - 1;
                return -1.0 * Math.pow(2.0, 10.0*invRatio) * Math.sin((invRatio-s)*(2.0*Math.PI)/p);                
            }            
        }
        
        protected static function easeOutElastic(ratio:Number):Number
        {
            if (ratio == 0 || ratio == 1) return ratio;
            else
            {
                var p:Number = 0.3;
                var s:Number = p/4.0;                
                return Math.pow(2.0, -10.0*ratio) * Math.sin((ratio-s)*(2.0*Math.PI)/p) + 1;                
            }            
        }
        
        protected static function easeInOutElastic(ratio:Number):Number
        {
            return easeCombined(easeInElastic, easeOutElastic, ratio);
        }   
        
        protected static function easeOutInElastic(ratio:Number):Number
        {
            return easeCombined(easeOutElastic, easeInElastic, ratio);
        }
        
        protected static function easeInBounce(ratio:Number):Number
        {
            return 1.0 - easeOutBounce(1.0 - ratio);
        }
        
        protected static function easeOutBounce(ratio:Number):Number
        {
            var s:Number = 7.5625;
            var p:Number = 2.75;
            var l:Number;
            if (ratio < (1.0/p))
            {
                l = s * Math.pow(ratio, 2);
            }
            else
            {
                if (ratio < (2.0/p))
                {
                    ratio -= 1.5/p;
                    l = s * Math.pow(ratio, 2) + 0.75;
                }
                else
                {
                    if (ratio < 2.5/p)
                    {
                        ratio -= 2.25/p;
                        l = s * Math.pow(ratio, 2) + 0.9375;
                    }
                    else
                    {
                        ratio -= 2.625/p;
                        l =  s * Math.pow(ratio, 2) + 0.984375;
                    }
                }
            }
            return l;
        }
        
        protected static function easeInOutBounce(ratio:Number):Number
        {
            return easeCombined(easeInBounce, easeOutBounce, ratio);
        }   
        
        protected static function easeOutInBounce(ratio:Number):Number
        {
            return easeCombined(easeOutBounce, easeInBounce, ratio);
        }
        
        protected static function easeCombined(startFunc:Function, endFunc:Function, ratio:Number):Number
        {
            if (ratio < 0.5) return 0.5 * startFunc(ratio*2.0);
            else             return 0.5 * endFunc((ratio-0.5)*2.0) + 0.5;
        }
    }
}