package com.alisacasino.bingo.models.cats 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.screens.gameScreenClasses.CatView;
	import starling.textures.Texture;
	public class CatRole 
	{
		public static const FIGHTER:String = "FIGHTER";
		public static const DEFENDER:String = "DEFENDER";
		public static const HARVESTER:String = "HARVESTER";
		
		private static var roles:Array = [HARVESTER, FIGHTER, DEFENDER];
		
		public function CatRole() 
		{
			
		}
		
		public static function getRoleTexture(role:String):Texture 
		{
			switch(role) {
				case FIGHTER: return AtlasAsset.CommonAtlas.getTexture('cats/roles/sword');
				case DEFENDER: return AtlasAsset.CommonAtlas.getTexture('cats/roles/shield');
				case HARVESTER: return AtlasAsset.CommonAtlas.getTexture('cats/roles/fork_knife');
			}
			return AtlasAsset.getEmptyTexture();
		}
		
		public static function getNext(role:String):String 
		{
			if (!role)
				return roles[0];
				
			var index:int = roles.indexOf(role);
			
			if (index < (roles.length-1))
				return roles[index + 1];
			
			return roles[0];
		}
		
		public static function getRandom():String 
		{
			var types:Vector.<String> = new <String> [FIGHTER, DEFENDER, HARVESTER];
			//var types:Vector.<String> = new <String> [CASH, XP, SCORE];
			//var types:Vector.<String> = new <String> [X2, CASH, XP, INSTABINGO, /*MINIGAME,*/ SCORE];
			return types[Math.floor(Math.random()*types.length)];
		}
		
		public static function getStateByRole(role:String):String 
		{
			switch(role) {
				case FIGHTER: return CatView.STATE_FIGHT;
				case DEFENDER: return CatView.STATE_DEFENCE;
				case HARVESTER: return CatView.STATE_HARVEST;
			}
			return CatView.STATE_IDLE;
		}
		
	}

}