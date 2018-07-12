package com.alisacasino.bingo.dialogs.scratchCard.helperClasses 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class GeometricScratchCalculator 
	{
		private static const padding:Number = 14;
		private var lastX:Number;
		private var lastY:Number;
		
		public var rects:Vector.<Rectangle>;
		public var hits:Vector.<Boolean>;
		
		public function GeometricScratchCalculator(scale:Number, width:Number, height:Number) 
		{
			rects = new Vector.<Rectangle>();
			
			var rectWidth:Number = width / 3;
			var rectHeight:Number = height / 3;
			
			var rectPadding:Number = padding * scale;
			
			for (var i:int = 0; i < 3; i++) 
			{
				for (var j:int = 0; j < 3; j++) 
				{
					var rect:Rectangle = new Rectangle(j * rectWidth + rectPadding, i * rectHeight + rectPadding, rectWidth - rectPadding * 2, rectHeight - rectPadding * 2);
					rects.push(rect);
				}
			}
			
			hits = new Vector.<Boolean>();
			for (var k:int = 0; k < rects.length; k++) 
			{
				hits.push(false);
			}
		}
		
		public function startTracking(x:Number, y:Number):void 
		{
			lastX = x;
			lastY = y;
			
			checkContainsPoint(x, y);
		}
		
		private function checkContainsPoint(x:Number, y:Number):void 
		{
			for (var i:int = 0; i < rects.length; i++) 
			{
				if (hits[i] === true)
				{
					continue;
				}
				
				var rect:Rectangle = rects[i];
				if (rect.contains(x, y))
				{
					hits[i] = true; 
				}
			}
		}
		
		private var lp1:Point = new Point();
		private var lp2:Point = new Point();
		public function track(x:Number, y:Number):Number 
		{
			checkContainsPoint(x, y);
			
			lp1.setTo(lastX, lastY);
			lp2.setTo(x, y);
			checkIntersect(lp1, lp2);
			
			var distance:Number = Math.sqrt((x - lastX) * (x - lastX) + (y - lastY) * (y - lastY));
			
			lastX = x;
			lastY = y;
			
			return distance;
		}
		
		public function reset():void 
		{
			for (var i:int = 0; i < hits.length; i++) 
			{
				hits[i] = false;
			}
		}
		
		public function checkAllHits():Boolean
		{
			for (var i:int = 0; i < hits.length; i++) 
			{
				if (hits[i] == false)
				{
					return false;
				}
			}
			
			return true;
		}
		
		private function checkIntersect(point:Point, point1:Point):void 
		{
			for (var i:int = 0; i < rects.length; i++) 
			{
				if (hits[i] === true)
				{
					continue;
				}
				
				if (lineIntersectsRect(point, point1, rects[i]))
				{
					hits[i] = true;
				}
			}
		}
		
		private var r1p:Point = new Point();
		private var r2p:Point = new Point();
		private var r3p:Point = new Point();
		private var r4p:Point = new Point();
		private var r5p:Point = new Point();
		private var r6p:Point = new Point();
		private var r7p:Point = new Point();
		private var r8p:Point = new Point();
		
		/**
		 * http://stackoverflow.com/questions/5514366/how-to-know-if-a-line-intersects-a-rectangle
		 * + some optimisations using persistent Point objects
		 * @param	p1 line start
		 * @param	p2 line end
		 * @param	r rectangle
		 * @return
		 */
		private function lineIntersectsRect(p1:Point, p2:Point, r:Rectangle):Boolean
		{
			if (p1.x < r.left && p2.x < r.left) return false;
			if (p1.x > r.right && p2.x > r.right) return false;
			if (p1.y < r.top && p2.y < r.top) return false;
			if (p1.y > r.bottom && p2.y > r.bottom) return false;
			
			r1p.setTo(r.x, r.y);
			r2p.setTo(r.right, r.y);
			
			r3p.setTo(r.right, r.y);
			r4p.setTo(r.right, r.bottom);
			
			r5p.setTo(r.right, r.bottom);
			r6p.setTo(r.x, r.bottom);
			
			r7p.setTo(r.x, r.bottom);
			r8p.setTo(r.x, r.y);
			
			return lineIntersectsLine(p1, p2, r1p, r2p) ||
				   lineIntersectsLine(p1, p2, r3p, r4p) ||
				   lineIntersectsLine(p1, p2, r5p, r6p) ||
				   lineIntersectsLine(p1, p2, r7p, r8p);
		}

		private static function lineIntersectsLine(l1p1:Point, l1p2:Point, l2p1:Point, l2p2:Point):Boolean
		{
			var q:Number = (l1p1.y - l2p1.y) * (l2p2.x - l2p1.x) - (l1p1.x - l2p1.x) * (l2p2.y - l2p1.y);
			var d:Number = (l1p2.x - l1p1.x) * (l2p2.y - l2p1.y) - (l1p2.y - l1p1.y) * (l2p2.x - l2p1.x);

			if( d == 0 )
			{
				return false;
			}

			var r:Number = q / d;

			q = (l1p1.y - l2p1.y) * (l1p2.x - l1p1.x) - (l1p1.x - l2p1.x) * (l1p2.y - l1p1.y);
			var s:Number = q / d;

			if( r < 0 || r > 1 || s < 0 || s > 1 )
			{
				return false;
			}

			return true;
		}
		
	}

}