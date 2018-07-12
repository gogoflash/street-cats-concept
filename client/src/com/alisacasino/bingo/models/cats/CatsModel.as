package com.alisacasino.bingo.models.cats 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import starling.textures.Texture;
	
	public class CatsModel 
	{
		private var serialCatId:int;
		
		public function CatsModel() 
		{
			
		}
		
		public function getRandomCatUID():int 
		{
			return Math.floor(Math.random()*9);
		}
		
		public function getCatTexture(uid:int, front:Boolean):Texture 
		{
			return AtlasAsset.CommonAtlas.getTexture('cats/' + (front ? 'front/' : 'back/') + uid.toString());
		}
		
		public function getNextCatID():int 
		{
			return serialCatId++;
		}
	}
}