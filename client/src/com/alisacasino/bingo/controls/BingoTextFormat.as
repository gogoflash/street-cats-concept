// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package com.alisacasino.bingo.controls
{
	import starling.text.TextFormat;
    public class BingoTextFormat extends TextFormat
    {
        public var nativeFilters:Array;
		public var nativeTextExtraWidth:int = 4;
		public var nativeTextExtraHeight:int = 4;
		
        public function BingoTextFormat(font:String="Verdana", size:Number=12, color:uint=0x0,
                                   horizontalAlign:String="center", verticalAlign:String="center")
        {
           super(font, size, color, horizontalAlign, verticalAlign);
        }

		override public function clone():starling.text.TextFormat
        {
            var clone:BingoTextFormat = new BingoTextFormat();
            clone.copyFrom(this);
            return clone;
        }
		
        override public function copyFrom(format:starling.text.TextFormat):void
		{
			nativeFilters = (format is BingoTextFormat) ? (format as BingoTextFormat).nativeFilters : null;
			super.copyFrom(format);
		}

    }
}
