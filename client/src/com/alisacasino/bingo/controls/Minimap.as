package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.cardPatternHint.CardPattern;
	import com.alisacasino.bingo.controls.cardPatternHint.CardPatternHintRenderer;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.protocol.RoomPattern;
	import com.alisacasino.bingo.resize.IResizable;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Minimap extends Sprite
	{
		private var cardPatternHintRenderer:CardPatternHintRenderer;
		
		public static var DEBUG_TAKE_POWERUP_BY_CLICK:Boolean = false;
		
		public function Minimap()
		{
			cardPatternHintRenderer = new CardPatternHintRenderer();
			
			cardPatternHintRenderer.setBackground(AtlasAsset.CommonAtlas.getTexture("minimap/normal_background"));
			cardPatternHintRenderer.setEmptySlot(AtlasAsset.CommonAtlas.getTexture("minimap/normal_empty_slot"));
			cardPatternHintRenderer.setDaubTexture(AtlasAsset.CommonAtlas.getTexture("minimap/normal_daub"));
			
			var cardPattern:Vector.<CardPattern> = CardPattern.getCardPatternByRoomPattern(Room.current.roomType.roomPattern);
			cardPatternHintRenderer.setPatternList(cardPattern);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function setRedDaubSet():void 
		{
			cardPatternHintRenderer.setBackground(AtlasAsset.CommonAtlas.getTexture("minimap/lighter_background"));
			cardPatternHintRenderer.setEmptySlot(AtlasAsset.CommonAtlas.getTexture("minimap/lighter_empty_slot"));
			cardPatternHintRenderer.setDaubTexture(AtlasAsset.CommonAtlas.getTexture("minimap/red_daub"));
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addChild(cardPatternHintRenderer);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			if (!DEBUG_TAKE_POWERUP_BY_CLICK)
				return;
				
			event.stopImmediatePropagation();
		
			var touch:Touch = event.getTouch(this);
			if (touch == null)
				return;
	
			if (touch.phase == TouchPhase.BEGAN) 
			{
				Game.current.gameScreen.gameUI.debugAddPowerUpToCards();	
				
				/*var ballNumber:int = Math.max(1, int(Math.random() * 75));
				Game.current.gameScreen.gameUI.addBall(ballNumber);
				Room.current.numbers.push(ballNumber);*/
			}
		}
	}
}