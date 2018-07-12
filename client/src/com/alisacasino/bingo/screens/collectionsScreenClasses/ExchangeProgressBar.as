package com.alisacasino.bingo.screens.collectionsScreenClasses
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	public class ExchangeProgressBar extends Sprite
	{
		private var mAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		private var mBackStart:Image;
		private var mBackCenter:Image;
		private var mBackEnd:Image;
		private var mFillStart:Image;
		private var mFillCenter:Image;
		private var mFillEnd:Image;
		private var mPosition:Number = 0;
		
		private var fillRemoved:Boolean = true;
		
		private var mWidth:uint;
		
		public function ExchangeProgressBar(width:Number)
		{
			mWidth = width;
			
			mBackStart = new Image(mAtlas.getTexture("dialogs/collections/pb_base_left"));
			mBackCenter = new Image(mAtlas.getTexture("dialogs/collections/pb_base_center"));
			mBackCenter.tileGrid = new Rectangle();
			mBackEnd = new Image(mAtlas.getTexture("dialogs/collections/pb_base_right"));
			
			mFillStart = new Image(mAtlas.getTexture("dialogs/collections/pb_fill_left"));
			mFillCenter = new Image(mAtlas.getTexture("dialogs/collections/pb_fill_center"));
			mFillCenter.scale9Grid = new Rectangle();
			mFillEnd = new Image(mAtlas.getTexture("dialogs/collections/pb_fill_right"));
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function onAddedToStage(e:Event):void
		{
			mBackCenter.x = (mBackStart.x + mBackStart.width);
			mBackCenter.width = (mWidth - mBackStart.width - mBackEnd.width);
			mBackEnd.x = (mBackCenter.x + mBackCenter.width);
			
			addChild(mBackStart);
			addChild(mBackCenter);
			addChild(mBackEnd);
			
			position = mPosition;
		}
		
		public function set position(value:Number):void
		{
			if (isNaN(value))
				value = 0;
			if (value < 0)
				value = 0;
			if (value > 1.0)
				value = 1.0;
			
			mPosition = value;
			
			if (mPosition == 0)
			{
				removeChild(mFillStart);
				removeChild(mFillCenter);
				removeChild(mFillEnd);
				
				fillRemoved = true;
				
				return;
			}
			else if (fillRemoved)
			{
				removeChild(mBackStart);
				removeChild(mBackCenter);
				removeChild(mBackEnd);
				
				addChild(mFillStart);
				addChild(mFillCenter);
				addChild(mFillEnd);
				
				addChild(mBackStart);
				addChild(mBackCenter);
				addChild(mBackEnd);
				
				fillRemoved = false;
			}
			
			mFillStart.x = mBackStart.x + 0 * pxScale;
			mFillStart.y = mBackStart.y + 0 * pxScale;
			mFillCenter.x = mBackCenter.x + 0 * pxScale;
			mFillCenter.y = mBackCenter.y + 0 * pxScale;
			mFillCenter.width = (mWidth - mFillStart.width - mFillEnd.width) * mPosition;
			mFillEnd.x = (mFillCenter.x + mFillCenter.width);
			mFillEnd.y = mBackEnd.y;
		}
		
		public function get position():Number
		{
			return mPosition;
		}
		
		public function advanceToPosition(toPosition:Number):void
		{
			var mPositionToAdvance:Number = toPosition;
			
			if (mPositionToAdvance < mPosition)
				mPositionToAdvance = mPosition;
			else if (mPositionToAdvance > 1.0)
				mPositionToAdvance = 1.0;
			
			var tweenIn:Tween = new Tween(this, 0.2, Transitions.EASE_IN);
			var tweenOutBack:Tween = new Tween(this, 0.5, Transitions.EASE_OUT_BACK);
			
			tweenIn.animate('position', mPositionToAdvance + mPositionToAdvance * 0.1);
			tweenIn.nextTween = tweenOutBack;
			tweenOutBack.animate('position', mPositionToAdvance);
			Starling.juggler.add(tweenIn);
		}
	}
}