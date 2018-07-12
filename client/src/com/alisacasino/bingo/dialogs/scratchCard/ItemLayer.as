package com.alisacasino.bingo.dialogs.scratchCard 
{
	import com.alisacasino.bingo.dialogs.scratchCard.itemLayerClasses.ScratchItemRenderer;
	import com.alisacasino.bingo.models.scratchCard.ScratchItem;
	import com.alisacasino.bingo.models.scratchCard.ScratchResult;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.TiledRowsLayout;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ItemLayer extends LayoutGroup
	{
		private var _scratchResult:ScratchResult;
		
		public function get scratchResult():ScratchResult 
		{
			return _scratchResult;
		}
		
		public function set scratchResult(value:ScratchResult):void 
		{
			sosTrace( "ItemLayer.set > scratchResult : " + value );
			if (_scratchResult != value)
			{
				_scratchResult = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		private static const NUM_COLUMNS:int = 3;
		private static const NUM_ROWS:int = 3;
		private var renderers:Vector.<ScratchItemRenderer>;
		
		public function ItemLayer() 
		{
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			var rendererWidth:Number = width / NUM_COLUMNS;
			var rendererHeight:Number = height / NUM_ROWS;
			
			var tiledRowsLayout:TiledColumnsLayout = new TiledColumnsLayout();
			tiledRowsLayout.useSquareTiles = false;
			layout = tiledRowsLayout;
			
			renderers = new Vector.<ScratchItemRenderer>();
			for (var i:int = 0; i < NUM_COLUMNS * NUM_ROWS; i++) 
			{
				var renderer:ScratchItemRenderer = new ScratchItemRenderer();
				renderer.setSize(rendererWidth, rendererHeight);
				renderers.push(renderer);
				addChild(renderer);
			}
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				commitData();
			}
		}
		
		private function commitData():void 
		{
			if (!scratchResult)
			{
				return;
			}
			
			for (var i:int = 0; i < scratchResult.results.length; i++) 
			{
				if (renderers[i])
				{
					renderers[i].scratchItem = scratchResult.results[i].scratchItem;
					renderers[i].multiplier = scratchResult.results[i].attachedMultiplier;
					renderers[i].hideWinningMarker();
				}
			}
		}
		
		public function highlightWinnings(primeItem:ScratchItem):void 
		{
			var delay:Number = 0.;
			for each (var item:ScratchItemRenderer in renderers) 
			{
				if (item.scratchItem.winningQuantity == primeItem.winningQuantity)
				{
					item.playWinAnimation(delay);
					delay += 0.1;
				}
			}
		}
		
	}

}