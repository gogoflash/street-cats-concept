package com.alisacasino.bingo.models.skinning 
{
	import com.alisacasino.bingo.protocol.CustomizationSet;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CustomizerSet 
	{
		public var name:String;
		public var id:uint;
		public var dauber:SkinningDauberData;
		public var cardBack:SkinningCardData;
		
		public function CustomizerSet() 
		{
			name = "Empty set";
		}
		
		public function deserialize(rawData:CustomizationSet):CustomizerSet
		{
			name = rawData.name;
			id = rawData.id;
			return this;
		}
		
		public function create(id:int, name:String, dauber:SkinningDauberData = null, cardBack:SkinningCardData = null):void
		{
			this.id = id;
			this.name = name;
			this.dauber = dauber;
			this.cardBack = cardBack;
		}
		
	}

}