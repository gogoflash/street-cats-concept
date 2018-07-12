package com.alisacasino.bingo.controls.cardPatternHint 
{
	import adobe.utils.CustomActions;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.utils.GameManager;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CardPatternHintRenderer extends Sprite implements IAnimatable
	{
		private var timeDelta:Number;
		
		private var patternList:Vector.<CardPattern>;
		
		/**
		 * Pattern display time in ms
		 */
		public var patternDisplayTime:Number = 1.;
		
		private var currentPatternDisplay:int = 0;
		private var lastPatternDrawn:int = -1;
		
		private var daubs:Array;
		private var backgroundImage:Image;
		private var daubTexture:Texture;
		private var emptySlotTexture:Texture;
		
		public function CardPatternHintRenderer() 
		{
			patternList = new Vector.<CardPattern>();
			
			backgroundImage = new Image(AtlasAsset.CommonAtlas.getTexture("minimap/normal_background"));
			addChild(backgroundImage);
			
			daubTexture = AtlasAsset.CommonAtlas.getTexture("minimap/normal_daub");
			emptySlotTexture = AtlasAsset.CommonAtlas.getTexture("minimap/normal_empty_slot");
			
			createImages();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function createImages():void 
		{
			daubs = [];
			
			for (var i:int = 0; i < 25; i++) 
			{
				var xPos:int = i % 5;
				var yPos:int = int(i / 5);
				var image:Image = new Image(daubTexture);
				image.x = (13 + xPos * 16) * pxScale;
				image.y = (13 + yPos * 16) * pxScale;
				addChild(image);
				daubs.push(image);
			}
		}
		
		private function addedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			timeDelta = 0;
			Starling.current.juggler.add(this);
			drawCurrentPattern();
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function removedFromStageHandler(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			Starling.current.juggler.remove(this);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/* INTERFACE starling.animation.IAnimatable */
		
		public function advanceTime(time:Number):void 
		{
			timeDelta += time;
			//sosTrace( "timeDelta : " + timeDelta, SOSLog.DEBUG);
			while (timeDelta > patternDisplayTime)
			{
				timeDelta -= patternDisplayTime;
				currentPatternDisplay++;
				if (currentPatternDisplay >= patternList.length)
				{
					currentPatternDisplay = 0;
				}
			}
			
			drawCurrentPattern();
		}
		
		private function drawCurrentPattern():void 
		{
			if (currentPatternDisplay == lastPatternDrawn)
			{
				return;
			}
			
			for each (var existingDaub:Image in daubs) 
			{
				if (existingDaub.texture != emptySlotTexture)
				{
					existingDaub.texture = emptySlotTexture;
					existingDaub.readjustSize();
					centerPivot(existingDaub);
				}
			}
			
			var cardPattern:CardPattern = patternList[currentPatternDisplay];
			
			var filledPositions:Vector.<Point> = cardPattern.filledPositions;
			
			for each (var item:Point in filledPositions) 
			{
				var daubIndex:int = item.y * 5 + item.x;
				var daubImage:Image = daubs[daubIndex];
				if (daubImage.texture != daubTexture)
				{
					daubImage.texture = daubTexture;
					daubImage.readjustSize();
					centerPivot(daubImage);
				}
			}
			
			lastPatternDrawn = currentPatternDisplay;
		}
		
		private function centerPivot(image:Image):void 
		{
			image.pivotX = image.texture.width / 2;
			image.pivotY = image.texture.height / 2;
		}
		
		public function setPatternList(list:Vector.<CardPattern>):void
		{
			patternList = list;
			lastPatternDrawn = -1;
			currentPatternDisplay = 0;
			timeDelta = 0;
		}
		
		public function setBackground(texture:Texture):void 
		{
			backgroundImage.texture = texture;
			backgroundImage.readjustSize();
		}
		
		public function setDaubTexture(texture:Texture):void 
		{
			daubTexture = texture;
			lastPatternDrawn = -1;
		}
		
		public function setEmptySlot(texture:Texture):void 
		{
			emptySlotTexture = texture;
		}
		
	}

}