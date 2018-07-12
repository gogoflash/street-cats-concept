package com.alisacasino.bingo.controls.cardPatternHint 
{
	import adobe.utils.CustomActions;
	import com.alisacasino.bingo.protocol.RoomPattern;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CardPattern 
	{
		public static const BLACKOUT:String = 'blackout';
		public static const BIN:String = 'bin';
		public static const NGO:String = 'ngo';
		public static const RAILROAD:String = 'railroad';
		public static const LETTER_X:String = 'letterX';
		public static const CROSS:String = 'cross';
		public static const CRAZY_PYRAMID:String = 'crazyPyramid';
		public static const CHEVRON:String = 'chevron';
		public static const ALL_CORNERS:String = 'allCorners';
		public static const FOUR_CORNERS:String = 'fourCorners';
		public static const SMALL_CORNER_X:String = 'smallCornerX';
		public static const RECTANGLE:String = 'rectangle';
		public static const DIAGONAL:String = 'diagonal';
		public static const COLUMN:String = 'column';
		public static const ROWS:String = 'rows' ;
		public static const CORNERS:String = 'corners';

		
		public var filledPositions:Vector.<Point>;
		public var id:String;
		
		public function CardPattern(filledPositions:Vector.<Point> = null, id:String = null) 
		{
			if (!filledPositions)
				filledPositions = new Vector.<Point>();
				
			this.filledPositions = filledPositions;
			this.id = id;
		}
		
		public function fromString(source:String):CardPattern
		{
			for (var i:int = 0; i < source.length; i++) 
			{
				if (source.charAt(i) == "o")
				{
					filledPositions.push(new Point(i % 5, int(i / 5)));
				}
			}
			
			return this;
		}
		
		static public function fromStrings(source:Vector.<String>, id:String = null):Vector.<CardPattern>
		{
			var result:Vector.<CardPattern> = new Vector.<CardPattern>();
			
			for (var i:int = 0; i < source.length; i++) 
			{
				result.push(new CardPattern(null, id).fromString(source[i]));
			}
			
			return result;
		}
		
		static public function generateStandardPatternList():Vector.<CardPattern>
		{
			var list:Vector.<CardPattern> = new Vector.<CardPattern>();
			fillInCorners(list);
			fillInColumns(list);
			fillInRows(list);
			fillInDiagonals(list);
			return list;
		}
		
		static public function generateTutorialList():Vector.<CardPattern>
		{
			var list:Vector.<CardPattern> = new Vector.<CardPattern>();
			fillInDiagonals(list);
			//fillInRows(list);
			//fillInColumns(list);
			return list;
		}
		
		static public function generateRowsList(randomizeList:Boolean = false):Vector.<CardPattern>
		{
			var list:Vector.<CardPattern> = new Vector.<CardPattern>();
			fillInRows(list);
			if(randomizeList)
				randomizeVector(list);
			return list;
		}
		
		static public function generateColumnsList(randomizeList:Boolean = false):Vector.<CardPattern>
		{
			var list:Vector.<CardPattern> = new Vector.<CardPattern>();
			fillInColumns(list);
			if(randomizeList)
				randomizeVector(list);
			return list;
		}
		
		static public function generateCornersList():Vector.<CardPattern>
		{
			var list:Vector.<CardPattern> = new Vector.<CardPattern>();
			fillInCorners(list);
			return list;
		}
		
		static public function generateBlackoutList():Vector.<CardPattern>
		{
			var blackoutPattern:CardPattern = new CardPattern(null, BLACKOUT);
			
			for (var i:int = 0; i < 5; i++) 
			{
				for (var j:int = 0; j < 5; j++) 
				{
					blackoutPattern.filledPositions.push(new Point(i, j));
				}
			}
			
			return new <CardPattern>[blackoutPattern];
		}
		
		static public function generate2x2PatternList():Vector.<CardPattern> 
		{
			return generateRectangles(2, 2);
		}
		
		static private function generateRectangles(width:int, height:int):Vector.<CardPattern>
		{
			var list:Vector.<CardPattern> = new Vector.<CardPattern>();
			
			var repetitionsYAxis:int = 6 - height; //Basically, (bingo card width - pattern width + 1). For 2x2 there's 4 positions for each axis, for 3x3 it's 3, etc.
			var repetitionsXAxis:int = 6 - width; //Basically, (bingo card width - pattern width + 1). For 2x2 there's 4 positions for each axis, for 3x3 it's 3, etc.
			
			for (var i:int = 0; i < repetitionsYAxis; i++) 
			{
				for (var j:int = 0; j < repetitionsXAxis; j++) 
				{
					list.push(generateRectangle(j, i, width, height));
				}
			}
			
			return list;
		}
		
		static public function generate3x3PatternList():Vector.<CardPattern> 
		{
			return generateRectangles(3, 3);
		}
		
		static public function generateBinNgoPatternList():Vector.<CardPattern> 
		{
			var list:Vector.<CardPattern> = new Vector.<CardPattern>();
			
			var binPattern:CardPattern = new CardPattern(null, BIN);
			for (var i:int = 0; i < 3; i++) 
			{
				getColumnPoints(i, binPattern.filledPositions);
			}
			list.push(binPattern);
			
			var ngoPattern:CardPattern = new CardPattern(null, NGO);
			for (i = 2; i < 5; i++) 
			{
				getColumnPoints(i, ngoPattern.filledPositions);
			}
			list.push(ngoPattern);
			
			return list;
		}
		
		static public function generate4x4PatternList():Vector.<CardPattern>
		{
			return generateRectangles(4, 4);
		}
		
		static public function generateRailroadTracks():Vector.<CardPattern>
		{
			var list:Vector.<CardPattern> = new Vector.<CardPattern>();
			var pattern:CardPattern;
			for (var i:int = 0; i < 4; i++) 
			{
				pattern = new CardPattern(null, RAILROAD);
				getColumnPoints(i, pattern.filledPositions);
				getColumnPoints(i + 1, pattern.filledPositions);
				list.push(pattern);
			}
			
			for (var j:int = 0; j < 4; j++) 
			{
				pattern = new CardPattern(null, RAILROAD);
				getRowPoints(j, pattern.filledPositions);
				getRowPoints(j + 1, pattern.filledPositions);
				list.push(pattern);
			}
			
			return list;
		}
		
		static public function generateLetterX():Vector.<CardPattern>
		{
			return fromStrings(new <String>[
				"o...o" +
				".o.o." +
				"..o.." +
				".o.o." +
				"o...o"
			], LETTER_X);
		}
		
		static public function generateCross():Vector.<CardPattern> 
		{
			return fromStrings(new <String>[
				"..o.." +
				"..o.." +
				"ooooo" +
				"..o.." +
				"..o.."
			], CROSS);
		}
		
		static public function generateCrazyPyramidList():Vector.<CardPattern> 
		{
			return fromStrings(new <String>[
				"o...." +
				"oo..." +
				"ooo.." +
				"oo..." +
				"o....",
				
				"ooooo" +
				".ooo." +
				"..o.." +
				"....." +
				".....",
				
				"....o" +
				"...oo" +
				"..ooo" +
				"...oo" +
				"....o",
				
				"....." +
				"....." +
				"..o.." +
				".ooo." +
				"ooooo",
			], CRAZY_PYRAMID);
		}
		
		static public function generateAnyChevronList():Vector.<CardPattern>  
		{
			return fromStrings(new <String>[
				"o...." +
				".o..." +
				"..o.." +
				".o..." +
				"o....",
				
				"o...o" +
				".o.o." +
				"..o.." +
				"....." +
				".....",
				
				"....o" +
				"...o." +
				"..o.." +
				"...o." +
				"....o",
				
				"....." +
				"....." +
				"..o.." +
				".o.o." +
				"o...o",
			], CHEVRON);
		}
		
		static public function generateAllCorners():Vector.<CardPattern>  
		{
			return fromStrings(new <String>[
				"oo.oo" +
				"o...o" +
				"....." +
				"o...o" +
				"oo.oo"
			], ALL_CORNERS);
		}
		
		static public function generateFourCorners():Vector.<CardPattern>   
		{
			return fromStrings(new <String>[
				"o...o" +
				"....." +
				"....." +
				"....." +
				"o...o"
			], FOUR_CORNERS);
		}
		
		static public function generateAny6Pack():Vector.<CardPattern>   
		{
			return generateRectangles(3, 2);
		}
		
		static public function generateSmallCornerX():Vector.<CardPattern>  
		{
			return fromStrings(new <String>[
				"o.o.." +
				".o..." +
				"o.o.." +
				"....." +
				".....",
				
				"..o.o" +
				"...o." +
				"..o.o" +
				"....." +
				".....",
				
				"....." +
				"....." +
				"..o.o" +
				"...o." +
				"..o.o",
				
				"....." +
				"....." +
				"o.o.." +
				".o..." +
				"o.o..",
			], SMALL_CORNER_X);
		}
		
		static public function getCardPatternByRoomPattern(roomPattern:int):Vector.<CardPattern> 
		{
			switch(roomPattern) {
				case RoomPattern.AllCorners: 			return generateAllCorners();
				case RoomPattern.FourCornersAllCalls: 	return generateFourCorners();
				case RoomPattern.Any6Pack: 				return generateAny6Pack();
				case RoomPattern.SmallCornerX: 			return generateSmallCornerX();
				case RoomPattern.RailRoadTracks: 		return generateRailroadTracks();
				case RoomPattern.LetterXAllCalls: 		return generateLetterX();
				case RoomPattern.Cross: 				return generateCross();
				case RoomPattern.CrazyPyramid: 			return generateCrazyPyramidList();
				case RoomPattern.AnyChevron: 			return generateAnyChevronList();
				case RoomPattern.Square3: 				return generate3x3PatternList();
				case RoomPattern.Square2: 				return generate2x2PatternList();
				case RoomPattern.Blackout: 				return generateBlackoutList();
				case RoomPattern.BinNgo: 				return generateBinNgoPatternList();
				case RoomPattern.Square4: 				return generate4x4PatternList();
				default: 								return generateStandardPatternList();
			}
			
			return generateStandardPatternList();
		}
		
		static private function generateRectangle(xStart:int, yStart:int, width:int, height:int):CardPattern
		{
			var sourceArray:Array = [];
			for (var i:int = 0; i < width; i++) 
			{
				for (var j:int = 0; j < height; j++) 
				{
					sourceArray.push([xStart + i, yStart + j]);
				}
			}
			return new CardPattern(null, RECTANGLE).fromIntArray2(sourceArray);
		}
		
		static private function fillInDiagonals(list:Vector.<CardPattern>):void 
		{
			var topLeftBottomRight:CardPattern = new CardPattern(null, DIAGONAL);
			var topRightBottomLeft:CardPattern = new CardPattern(null, DIAGONAL);
			for (var i:int = 0; i < 5; i++) 
			{
				topLeftBottomRight.filledPositions.push(new Point(i, i));
				topRightBottomLeft.filledPositions.push(new Point(4 - i, i));
			}
			list.push(topLeftBottomRight);
			list.push(topRightBottomLeft);
		}
		
		static private function fillInColumns(list:Vector.<CardPattern>):void 
		{
			for (var i:int = 0; i < 5; i++) 
			{
				list.push(new CardPattern(getColumnPoints(i), COLUMN));
			}
		}
		
		static private function getColumnPoints(columnNum:int, target:Vector.<Point> = null):Vector.<Point>
		{
			if (!target) 
				target = new Vector.<Point>();
			
			for (var i:int = 0; i < 5; i++) 
			{
				target.push(new Point(columnNum, i));
			}
			return target;
		}
		
		static private function getRowPoints(rowNum:int, target:Vector.<Point> = null):Vector.<Point>
		{
			if (!target) 
				target = new Vector.<Point>();
			
			for (var i:int = 0; i < 5; i++) 
			{
				target.push(new Point(i, rowNum));
			}
			return target;
		}
		
		static private function fillInRows(list:Vector.<CardPattern>):void 
		{
			for (var i:int = 0; i < 5; i++) 
			{
				list.push(new CardPattern(getRowPoints(i), ROWS));
			}
		}
		
		static private function fillInCorners(list:Vector.<CardPattern>):void 
		{
			list.push(new CardPattern(null, CORNERS).fromIntArray2([[0, 0], [4, 0], [0, 4], [4, 4]]));
		}
		
		private function fromIntArray2(array2:Array):CardPattern
		{
			sosTrace( "CardPattern.fromIntArray2 > array2 : " + array2 );
			for (var i:int = 0; i < array2.length; i++) 
			{
				var positionTuple:Array = array2[i];
				filledPositions.push(new Point(positionTuple[0], positionTuple[1]));
			}
			return this;
		}
		
		static public function randomizeVector(source:Vector.<CardPattern>):void
		{
			source.sort(function(a:*, b:*):int { 
				return Math.random() > 0.5 ? -1 : 1; 
			});
		}
		
		static public function getStringName(pattern:String):String 
		{
			switch(pattern) {
				case BLACKOUT: return 'BLACKOUT';
				case BIN: return 'BIN';
				case NGO: return 'NGO';
				case RAILROAD: return 'RAILROAD';
				case LETTER_X: return 'LETTER X';
				case CROSS: return 'CROSS';
				case CRAZY_PYRAMID: return 'CRAZY PYRAMID';
				case CHEVRON: return 'CHEVRON';
				case ALL_CORNERS: return 'ALL CORNERS';
				case FOUR_CORNERS: return 'FOUR CORNERS';
				case SMALL_CORNER_X: return 'SMALL CORNER X';
				case RECTANGLE: return 'RECTANGLE';
				case DIAGONAL: return 'Diagonal line';
				case COLUMN: return 'Vertical';
				case ROWS: return 'Horizontal' ;
				case CORNERS: return 'Four Corners';
			}
			
			return 'UNKNOWN PATTERN: ' + String(pattern);
		}
		
	}

}