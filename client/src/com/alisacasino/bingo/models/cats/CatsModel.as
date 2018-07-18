package com.alisacasino.bingo.models.cats 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.screens.gameScreenClasses.CatView;
	import starling.textures.Texture;
	
	public class CatsModel 
	{
		private var serialCatId:int;
		
		public function CatsModel() 
		{
			
		}
		
		public function getRandomCatUID():int 
		{
			return 3;//Math.floor(Math.random()*9);
		}
		
		public function getCatTexture(uid:int, front:Boolean, state:String):Texture 
		{
			switch(state) {
				case CatView.STATE_IDLE: return AtlasAsset.CommonAtlas.getTexture('cats/' + (front ? 'front/' : 'back/') + uid.toString());
				case CatView.STATE_WALK: return AtlasAsset.CommonAtlas.getTexture('cats/' + (front ? 'walk/front_' : 'walk/') + uid.toString());
				case CatView.STATE_WALK_HARVEST: return AtlasAsset.CommonAtlas.getTexture('cats/' + (front ? 'walk_harvest/' : 'walk_harvest/') + uid.toString());
				case CatView.STATE_FIGHT: return AtlasAsset.CommonAtlas.getTexture('cats/' + (front ? 'fight/' : 'fight/') + uid.toString());
				case CatView.STATE_DEFENCE: return AtlasAsset.CommonAtlas.getTexture('cats/' + (front ? 'defence/' : 'defence/') + uid.toString());
				case CatView.STATE_HARVEST: return AtlasAsset.CommonAtlas.getTexture('cats/' + (front ? 'harvest/' : 'harvest/') + uid.toString());
			}
			
			return AtlasAsset.CommonAtlas.getTexture('cats/' + (front ? 'front/' : 'back/') + uid.toString());
		}
		
		public function getNextCatID():int 
		{
			return serialCatId++;
		}
	}
}