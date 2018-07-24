package com.alisacasino.bingo.models.cats 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.screens.gameScreenClasses.CatView;
	import starling.textures.Texture;
	
	public class CatsModel 
	{
		private var serialCatId:int = 3;
		
		public function CatsModel() 
		{
			
		}
		
		public function getRandomCatUID():int 
		{
			return 3;//Math.floor(Math.random()*9);
		}
		
		public function getCatTexture(uid:int, front:Boolean, state:String):Texture 
		{
			return AtlasAsset.CommonAtlas.getTexture('cats/side/1');
			
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
		
		public function serializePlayerCats():Object
		{
			var raw:Array = [];
			
			var i:int;
			var cat:CatModel;
			for (i = 0; i < gameManager.playerCats.length; i++) 
			{
				cat = gameManager.playerCats[i] as CatModel;
				
				raw.push(
				{
					id: cat.id,
					catProtoId: cat.catUID,
					health: cat.health,
					role: cat.role,
					targetCatId: cat.targetCat
				});
				
			}
			
			return raw;
			
		}
		
		
		public function deserializeCats(catsRaw:Object, targetCatsList:Array):void
		{
			if (catsRaw.playerId == Player.current.playerId)
				return;
				
			var i:int;
			var cat:CatModel;
			var catItemsRaw:Object = catsRaw.pets;	
			var catRaw:Object;
			var catId:int;
			
			var rawCatsIds:Array = [];
			var rawCatsByIds:Object = {};
			
			for each(catRaw in catItemsRaw)
			{
				//rawCatsIds.push(catRaw.id);
				//rawCatsByIds[catRaw.id] = catRaw;
				
				cat = getCatById(gameManager.enemyCats, getEnemyCatId(parseInt(catRaw.id)));
				if (cat) 
				{
					cat.health = catRaw.health;
					cat.catUID = catRaw.catProtoId;
					cat.targetCat = getPlayerCatId(parseInt(catRaw.targetCatId)); // 345
					cat.role = catRaw.role;
				}
			}
			
			/*rawCatsIds.sort();
			
		
			while(rawCatsIds.length > 0)
			{
				catId = rawCatsIds.pop();
				catRaw = rawCatsByIds[catId] as Object;
				
				cat = getCatById(gameManager.enemyCats, parseInt(catRaw.id));
				if (cat) 
				{
					cat.health = catRaw.health;
					cat.catUID = catRaw.catProtoId;
					cat.targetCat = catRaw.targetCatId;
					cat.role = catRaw.role;
				}
			}*/
			
			
			
		/*	
			"firstPlayerInfo": {
            "playerId": 5,
            "gameId": 3,
            "pets": [
                {
                    "id": 0,
                    "catProtoId": 3,
                    "health": 3,
                    "role": "HARVESTER",
                    "targetCatId": -1
                },
                {
			*/
			
			
			
		}
		
		private function getEnemyCatId(id:int):int
		{
			switch(id) {
				case 3: return 0;
				case 4: return 1;
				case 5: return 2;
			}
			
			return -1;
		}
		
		private function getPlayerCatId(id:int):int
		{
			switch(id) {
				case 0: return 3;
				case 1: return 4;
				case 2: return 5;
			}
			
			return -1;
		}
		
		private function getCatById(array:Array, id:int):CatModel
		{
			var i:int;
			var cat:CatModel;
			for (i = 0; i < array.length; i++) 
			{
				cat = array[i] as CatModel;
				
				if (cat.id == id)
					return cat;
			}
			
			return null;
		}
		
	}
}