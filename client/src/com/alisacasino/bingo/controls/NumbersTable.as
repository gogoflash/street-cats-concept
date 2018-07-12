package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.components.Scale9Image;
	import com.alisacasino.bingo.components.Scale9Textures;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.utils.GameManager;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.MeshBatch;
	import starling.display.Quad;
	import starling.textures.Texture;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class NumbersTable extends Sprite
	{
		private var mGameManager:GameManager = GameManager.instance;
		private var mGameAtlas:AtlasAsset = AtlasAsset.CommonAtlas;

		//private var background:Image; 
		private var background:Scale9Image;
		
		//private var marksQuadBatch:MeshBatch;
		//private var mark:Image;
		
		private var CELL_WIDTH:Number = 38;
		private var CELL_HEIGHT:Number = 34;
		
		private var storedNumbers:Array;
		
		public function NumbersTable()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//marksQuadBatch = new MeshBatch();
			storedNumbers = [];
			Game.addEventListener(Game.ACTIVATED, handler_gameActivated);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			//background = new Image(AtlasAsset.CommonAtlas.getTexture("game/numbers_bg"));
			var texture:Texture = AtlasAsset.CommonAtlas.getTexture("game/numbers_bg");
			background = new Scale9Image(new Scale9Textures(texture, new Rectangle(0, 43 * pxScale, texture.nativeWidth, 38 * pxScale)));
			background.isTiled = true;
			background.height = originalHeight;
			addChild(background);
			
			//addChild(marksQuadBatch);
		}
		
		public override function dispose():void {
			super.dispose();
			//mark = null;
			Game.removeEventListener(Game.ACTIVATED, handler_gameActivated);
		}
		
		public function reset():void
		{
			var i:int;
			while (i < numChildren) {
				if (getChildAt(i) is XTextField) 
					removeChildAt(i);
				else	
					i++;
			}
			
			//marksQuadBatch.clear();
			
			/*var i:int = 76;
			while (i-- > 1) {
				addNumber(i);
			}*/
		}
		
		public function xOfNumber(number:int):int
		{
			var column:int = int((number - 1) / 15);
			return (14 + column * CELL_WIDTH + column * 3) * pxScale;
			//return [12, 48, 85, 121, 158][int((number - 1) / 15)] * pxScale;
		}
		
		public function yOfNumber(number:int):int
		{
			var row:int = int((number - 1) % 15);
			return (43 + row * CELL_HEIGHT + row * 4) * pxScale;
			
			//return [32, 60, 88, 116, 144, 172, 200, 228, 256, 284, 312, 340, 368, 396, 424][int((number - 1) % 15)] * pxScale;
		}
		
		public function get originalHeight():Number
		{
			return (134 + (CELL_HEIGHT + 4) * 13) * pxScale;
		}
		
		public function addNumber(number:int):void
		{
			if (gameManager.deactivated) {
				storedNumbers.push(number);
				return;
			}
			
			var cellWidth:Number = CELL_WIDTH * pxScale;
			var cellHeight:Number = CELL_HEIGHT * pxScale;
			
			var numberLabel:XTextField = new XTextField(cellWidth, cellHeight, XTextFieldStyle.getChateaudeGarage(22), String(number));
			numberLabel.x = xOfNumber(number)// - 2*pxScale;
			numberLabel.y = yOfNumber(number) + 1*pxScale;
			numberLabel.batchable = true;
			//numberLabel.border = true;
			addChild(numberLabel);
			
			//marksQuadBatch.addMesh(mark);
		}
		
		private function handler_gameActivated(e:Event):void 
		{
			while (storedNumbers.length > 0) {
				addNumber(storedNumbers.shift());
			}
		}	
	}
}