package com.alisacasino.bingo.models.skinning 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.XmlAsset;
	import com.alisacasino.bingo.commands.player.ShowCompleteCollectionPageDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.WeightedList;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.CollectionDataMessage;
	import com.alisacasino.bingo.protocol.CustomCard;
	import com.alisacasino.bingo.protocol.CustomDaubIcon;
	import com.alisacasino.bingo.protocol.CustomVoiceOver;
	import com.alisacasino.bingo.protocol.CustomizationSet;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.protocol.PlayerCustomizationMessage;
	import com.alisacasino.bingo.protocol.PlayerCustomizationSettingsMessage;
	import com.alisacasino.bingo.protocol.PlayerItemMessage;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.ICardData;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import starling.core.Starling;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SkinningData extends EventDispatcher
	{
		/************************************************************************************************************************************
		 * 
		 * - дикторы
		 * - смена фона карточек
		 * - перекрас даубов и мэджик даубов
		 * - иконки на дауб. Помимо кошки любые другие.
		 * - разлет партиклов на даубе. Изменение цвета и партиклов.
		 * 
		 ************************************************************************************************************************************/
		
		public static var DEBUG_MODE:Boolean = false;
		 
		public static var KEY_SNOW_ENABLED:String = 'KEY_SNOW_ENABLED';
		
		public static var EVENT_CARD_SKIN_CHANGED:String = 'EVENT_CARD_SKIN_CHANGED';
		public static var EVENT_DAUBER_SKIN_CHANGED:String = 'EVENT_DAUBER_SKIN_CHANGED';
		public static var EVENT_VOICEOVER_CHANGED:String = 'EVENT_VOICEOVER_CHANGED';
		public static var EVENT_AVATAR_SKIN_CHANGED:String = 'EVENT_AVATAR_SKIN_CHANGED';
		public static var EVENT_SELECTION_CHANGED:String = 'EVENT_SELECTION_CHANGED';
		public static var EVENT_NEW_ITEMS_CHANGE:String = 'EVENT_NEW_ITEMS_CHANGE';
		
		public static var MAX_LOADED_CARD_SKINS:int = 5;
		public static var MAX_LOADED_DAUBER_SKINS:int = 5;
		public static var MAX_LOADED_VOICEOVERS:int = 5;
		
		public var customizerDropItems:Vector.<CustomizerItemBase>;
		
		private var _cardSkin:SkinningCardData;
		private var _cardSkinX2:SkinningCardData;
		
		public var defaultCardSkin:SkinningCardData;
		public var defaultDauberSkin:SkinningDauberData;
		public var defaultVoiceover:VoiceoverData;
		
		private var _dauberSkin:SkinningDauberData;
		
		private var _voiceover:VoiceoverData;
		private var _voiceoversVolume:Object;
		
		private var cardBacksByID:Object;
		private var daubersByID:Object;
		private var voiceoversByID:Object;
		
		private var allCustomizersByUID:Object;
		
		public var customCardBacks:Vector.<SkinningCardData>;
		public var customDaubers:Vector.<SkinningDauberData>;
		public var customVoiceovers:Vector.<VoiceoverData>;
		
		private var customizersListsByType:Object;
		
		public var dropList:WeightedList;
		
		public var setList:Vector.<CustomizerSet>;
		public var setByID:Object;
		public var newCustomizerItems:Vector.<CustomizerItemBase>;
		private	var cardsSetById:Object;
		private	var daubersSetById:Object;
		
		private var loadingCardSkins:Vector.<SkinningCardData>;
		private var loadingDauberSkins:Vector.<SkinningDauberData>;
		private var loadingVoiceovers:Vector.<VoiceoverData>;
		
		private var pendingToCurrentDauberSkinId:int = -1;
		private var pendingToCurrentCardSkinId:int = -1;
		private var pendingToCurrentVoiceoverId:int = -1;
		
		private static var customizersSubtypes:Array = [];
		
		public function SkinningData() 
		{
			defaultCardSkin = new SkinningCardData();
			defaultCardSkin.create(0, 'classic_blue', 'classic_blue', 'Default', 0, 1, CardType.NORMAL, 0);
			defaultCardSkin.baseItem = true;
			defaultCardSkin.defaultItem = true;
			
			defaultDauberSkin = new SkinningDauberData();
            defaultDauberSkin.create(0, 'classic_blue', 'classic_blue', 'Default', 0, 1, CardType.NORMAL, 0, 0x0099ff);
			defaultDauberSkin.baseItem = true;
			defaultDauberSkin.defaultItem = true;
			
			defaultVoiceover = new VoiceoverData();
            defaultVoiceover.create(0, 'default', 'default', 'Harry', 0, 1, CardType.NORMAL, 0, 0.033);
			defaultVoiceover.baseItem = true;
			defaultVoiceover.defaultItem = true;
			defaultVoiceover.callUseSoundsOnLoad = true;
			
			_cardSkinX2 = new SkinningCardData();
			_cardSkinX2.create(0, 'x2', 'x2', 'x2', 0, 1, CardType.NORMAL, 0);
			
			_voiceoversVolume = {};
			_voiceoversVolume['default'] = 0.6;
			_voiceoversVolume['jessica'] = 0.8;
			_voiceoversVolume['john'] = 1;
			_voiceoversVolume['ricardo'] = 0.6;
			_voiceoversVolume['charles'] = 1;
			
			reset();
			
			customizersSubtypes = [
				CustomizationType.DAUB_ICON,
				CustomizationType.DAUB_COLOR,
				CustomizationType.CARD,
				CustomizationType.AVATAR,
				CustomizationType.VOICEOVER
			]
		}
		
		private function reset():void 
		{
			dropList = new WeightedList();
			
			customCardBacks = new Vector.<SkinningCardData>();
			customDaubers = new Vector.<SkinningDauberData>();
			customVoiceovers = new Vector.<VoiceoverData>();
			
			newCustomizerItems = new Vector.<CustomizerItemBase>();
			customizerDropItems = new Vector.<CustomizerItemBase>();
			
			cardBacksByID = { };
			daubersByID = { };
			voiceoversByID = { };
			
			allCustomizersByUID = {};
			
			customizersListsByType = {};
			customizersListsByType[CustomizationType.CARD] = cardBacksByID;
			customizersListsByType[CustomizationType.DAUB_ICON] = daubersByID;
			customizersListsByType[CustomizationType.VOICEOVER] = voiceoversByID;
			//customizersListsByType[CustomizationType.AVATAR] = avatarsByID;
			//customizersListsByType[CustomizationType.CAT] = catsByID;
			
			cardsSetById = {};
			daubersSetById = {};
			
			loadingCardSkins = new <SkinningCardData>[];
			loadingDauberSkins = new <SkinningDauberData>[];
			loadingVoiceovers = new <VoiceoverData>[];
			
			setList = new Vector.<CustomizerSet>();
			setByID = { };
			
			if (defaultVoiceover)
				defaultVoiceover.callUseSoundsOnLoad = true;
		}
		
		public function get cardSkin():SkinningCardData
		{
			return _cardSkin;
		}
		
		public function get cardSkinX2():SkinningCardData
		{
			return _cardSkinX2;
		}
		
		public function get dauberSkin():SkinningDauberData
		{
			return _dauberSkin;
		}
		
		public function get voiceover():VoiceoverData
		{
			return _voiceover;
		}
		
		public function deserializeStaticData(staticData:StaticDataMessage):void 
		{
			reset();
			
			//staticData.customCards.length
			var skinningCardData:SkinningCardData;
			for each (var rawCardData:CustomCard in staticData.customCards) 
			{
				skinningCardData = new SkinningCardData().deserialize(rawCardData);
				customCardBacks.push(skinningCardData);
				cardBacksByID[skinningCardData.id] = skinningCardData;
				cardsSetById[skinningCardData.setID] = skinningCardData;
				allCustomizersByUID[skinningCardData.uid] = skinningCardData;
				if(DEBUG_MODE) {
					skinningCardData.quantity = Math.random() > 0.2 ? 1 : (4 + Math.random() * 12);
					//trace('card skin ', skinningCardData.id, skinningCardData.name);
				}
				dropList.addWeightedItem(skinningCardData, skinningCardData.weight);
			}
			
			var skinningDauberData:SkinningDauberData;
			for each (var rawDauberData:CustomDaubIcon in staticData.customDaubIcons) 
			{
				skinningDauberData = new SkinningDauberData().deserialize(rawDauberData); 
				customDaubers.push(skinningDauberData);
				daubersByID[skinningDauberData.id] = skinningDauberData;
				daubersSetById[skinningDauberData.setID] = skinningDauberData;
				allCustomizersByUID[skinningDauberData.uid] = skinningDauberData;
				if (DEBUG_MODE) {
					skinningDauberData.quantity = Math.random() > 0.2 ? 1 : (4 + Math.random() * 12);
					//trace('dauber skin ', skinningDauberData.id, skinningDauberData.name);
				}
				dropList.addWeightedItem(skinningDauberData, skinningDauberData.weight);
			}
			
			var customizerSet:CustomizerSet;
			for each(var rawSetData:CustomizationSet in staticData.customizationSets)
			{
				customizerSet = getSetByID(rawSetData.id);
				customizerSet.deserialize(rawSetData);
				customizerSet.cardBack = cardsSetById[customizerSet.id];
				customizerSet.dauber = daubersSetById[customizerSet.id];
				//trace('skin set ', customizerSet.id, customizerSet.name);
			}
			
			var voiceoverData:VoiceoverData;
			for each (var rawVoiceoverData:CustomVoiceOver in staticData.customVoiceOvers) 
			{
				voiceoverData = new VoiceoverData().deserialize(rawVoiceoverData); 
				customVoiceovers.push(voiceoverData);
				voiceoversByID[voiceoverData.id] = voiceoverData;
				if (DEBUG_MODE) {
					voiceoverData.quantity = Math.random() > 0.2 ? 1 : (4 + Math.random()*12);
				}
				allCustomizersByUID[voiceoverData.uid] = voiceoverData;
				dropList.addWeightedItem(voiceoverData, voiceoverData.weight);
			}
			
			cardBacksByID[defaultCardSkin.id] = defaultCardSkin;
			customCardBacks.push(defaultCardSkin);
			
			daubersByID[defaultDauberSkin.id] = defaultDauberSkin;
			customDaubers.push(defaultDauberSkin);
			
			voiceoversByID[defaultVoiceover.id] = defaultVoiceover;
			customVoiceovers.push(defaultVoiceover);
			
			debugAddCustomizers();
		}
		
		public function deserializePlayerCustomizers(playerCustomizationSettings:PlayerCustomizationSettingsMessage):void 
		{
			if (Player.current.customizerCardId in cardBacksByID) 
				_cardSkin = cardBacksByID[Player.current.customizerCardId] as SkinningCardData;
			else 
				_cardSkin = defaultCardSkin;
				
			if (Player.current.customizerDaubId in daubersByID) 
				_dauberSkin = daubersByID[Player.current.customizerDaubId] as SkinningDauberData;
			else 
				_dauberSkin = defaultDauberSkin;
				
			if (Player.current.customizerVoiceOverId in voiceoversByID) 
				_voiceover = voiceoversByID[Player.current.customizerVoiceOverId] as VoiceoverData;
			else 
				_voiceover = defaultVoiceover;
			
			
			/*var customizationMessage = new PlayerCustomizationMessage();
			customizationMessage.type = CustomizationType.CARD;
			customizationMessage.quantity = 1;
			customizationMessage.customizationId = 46;
			playerCustomizationSettings.customizations.push(customizationMessage);*/
				
			if (playerCustomizationSettings && playerCustomizationSettings.customizations) 
			{
				var i:int;
				var length:int = playerCustomizationSettings.customizations.length;
				var customizationMessage:PlayerCustomizationMessage;
				var customizerBase:CustomizerItemBase;
				for (i = 0 ; i < length; i++) 
				{
					customizationMessage = playerCustomizationSettings.customizations[i];
					if (customizationMessage.type in customizersListsByType) 
					{
						customizerBase = customizersListsByType[customizationMessage.type][customizationMessage.customizationId];
						if (customizerBase) {
							customizerBase.quantity = customizationMessage.quantity;
						}
					}
				}
			}
				
			// preload snow 
			if (Settings.instance.snowEnabled && gameManager.clientDataManager.getValue(KEY_SNOW_ENABLED, true)) {
				XmlAsset.Snow.load(null, null);
			}
		}
		
		public function fillPlayerMessage(playerMessage:PlayerMessage):void 
		{
			var playerCustomizations:Array = [];
			var customizationMessage:PlayerCustomizationMessage;
			var customizerType:int;
			var customizerListById:Object;
			var customizerBase:CustomizerItemBase;
			
			for (customizerType in customizersListsByType) 
			{
				customizerListById = customizersListsByType[customizerType];
				for each (customizerBase in customizerListById) 
				{
					if (customizerBase.quantity > 0)
					{
						customizationMessage = new PlayerCustomizationMessage();
						customizationMessage.customizationId = customizerBase.id;
						customizationMessage.type = customizerType;
						customizationMessage.quantity = customizerBase.quantity;
						playerCustomizations.push(customizationMessage);
					}
				}
			}
			
			if (!playerMessage.customizationSettings)
				playerMessage.customizationSettings = new PlayerCustomizationSettingsMessage();
				
			playerMessage.customizationSettings.customizations = playerCustomizations;
		}
		
		public function clean():void 
		{
			
		}
		
		public function getAssets():Array
		{
			var result:Array = [];
			cardSkinX2.addToLoad(result);
			
			if(cardSkin)
				cardSkin.addToLoad(result);
			
			if(dauberSkin)
				dauberSkin.addToLoad(result);
				
			if(voiceover)
				voiceover.addToLoad(result);	
				
			return result;
		}
		
		public function applyCustomizer(item:ICardData):void 
		{
			if (item.type == CustomizationType.CARD) {
				loadCardSkin(item.id, true);
				Player.current.customizerCardId = item.id;
				dispatchEventWith(EVENT_CARD_SKIN_CHANGED);
				//Starling.juggler.delayCall(loadCardSkin, 6, item.id, true);
			}
			else if (item.type == CustomizationType.DAUB_ICON) {
				Player.current.customizerDaubId = item.id;
				loadDauberSkin(item.id, true);	
				dispatchEventWith(EVENT_DAUBER_SKIN_CHANGED);
				//Starling.juggler.delayCall(loadDauberSkin, 6, item.id, true);
			}
			else if (item.type == CustomizationType.VOICEOVER) {
				Player.current.customizerVoiceOverId = item.id;
				loadVoiceover(item.id, true);	
				dispatchEventWith(EVENT_VOICEOVER_CHANGED);
			}
			else if (item.type == CustomizationType.AVATAR) {
				Player.current.customizerAvatarId = item.id;
				//loadAvatar(item.id);	
				dispatchEventWith(EVENT_AVATAR_SKIN_CHANGED);
			}
			
			Game.connectionManager.sendPlayerUpdateMessage();
		}
		
		public function checkSelected(item:CustomizerItemBase):Boolean
		{
			if (!item)
				return false;
			
			if (item.type == CustomizationType.CARD)
				return Player.current.customizerCardId == item.id;
			else if (item.type == CustomizationType.DAUB_ICON)
				return Player.current.customizerDaubId == item.id;
			else if (item.type == CustomizationType.VOICEOVER)
				return Player.current.customizerVoiceOverId == item.id;
			else if (item.type == CustomizationType.AVATAR)
				return Player.current.customizerAvatarId == item.id;
			
			return false;	
		}
		
		public function hadleBurnSelected(item:CustomizerItemBase):void
		{
			if (!item || item.quantity > 0)
				return;
			
			if (item.type == CustomizationType.CARD && Player.current.customizerCardId == item.id) {
				applyCustomizer(defaultCardSkin);
				dispatchEventWith(EVENT_SELECTION_CHANGED, false, defaultCardSkin);
			}
			else if (item.type == CustomizationType.DAUB_ICON && Player.current.customizerDaubId == item.id) {
				applyCustomizer(defaultDauberSkin);
				dispatchEventWith(EVENT_SELECTION_CHANGED, false, defaultDauberSkin);
			}
			else if (item.type == CustomizationType.VOICEOVER && Player.current.customizerVoiceOverId == item.id) {
				applyCustomizer(defaultVoiceover);
				dispatchEventWith(EVENT_SELECTION_CHANGED, false, defaultVoiceover);
			}
			else if (item.type == CustomizationType.AVATAR && Player.current.customizerAvatarId == item.id) {
				//applyCustomizer(default);
				//dispatchEventWith(EVENT_SELECTION_CHANGED, false, item);
			}
		}
		
		public function getSelectedItemByType(type:int):CustomizerItemBase
		{
			switch(type) {
				case CustomizationType.CARD: return cardSkin;
				case CustomizationType.DAUB_ICON: return dauberSkin;
				case CustomizationType.VOICEOVER: return voiceover;
				//case CustomizationType.AVATAR: return cardSkin;
				//case CustomizationType.PET: return cardSkin;
			}
			
			return null;	
		}
		
		/*********************************************************************************************************************
		*
		* dauber
		* 
		*********************************************************************************************************************/	
		
		public function loadDauberSkin(id:int, makeCurent:Boolean = false):SkinningDauberData
		{
			if(makeCurent)
				pendingToCurrentDauberSkinId = id;
				
			var i:int;
			var length:int = loadingDauberSkins.length;
			var skinningDauberData:SkinningDauberData;
			for (i = 0; i < length; i++) 
			{
				skinningDauberData = loadingDauberSkins[i];
				if (skinningDauberData.id == id) {
					if(makeCurent && skinningDauberData.isLoaded)
						callback_completeLoadDauberSkin();
					return skinningDauberData;
				}
			}
			
			skinningDauberData = daubersByID[id] as SkinningDauberData;
			if (!skinningDauberData)
				return null;
			
			loadingDauberSkins.push(skinningDauberData);
			skinningDauberData.load(callback_completeLoadDauberSkin);
			
			if (loadingDauberSkins.length > MAX_LOADED_DAUBER_SKINS) 
			{
				var skinToUloadIndex:int = loadingDauberSkins[0].id == (_dauberSkin ? _dauberSkin.id : -1) ? 1 : 0;
				loadingDauberSkins[skinToUloadIndex].unload();
				loadingDauberSkins.splice(skinToUloadIndex, 1);
			}
			
			return skinningDauberData;
		}
		
		private function callback_completeLoadDauberSkin():void 
		{
			if (pendingToCurrentDauberSkinId != -1) 
			{
				if (_dauberSkin.id != pendingToCurrentDauberSkinId)
				{
					var newDauberSkin:SkinningDauberData = daubersByID[pendingToCurrentDauberSkinId] as SkinningDauberData;
					
					if (_dauberSkin.markedCellTextStyle.fontName != newDauberSkin.markedCellTextStyle.fontName)
						Fonts.disposeDynamicBitmapFont(_dauberSkin.markedCellTextStyle.fontName);
					
					_dauberSkin = newDauberSkin;
				}
				
				if (_dauberSkin.isLoaded) {
					refreshInGameTextures();
					pendingToCurrentDauberSkinId = -1;
				}
			}
		}
		
		private function getDauberById(source:Vector.<SkinningDauberData>, id:int):SkinningDauberData
		{
			var i:int;
			var length:int = source.length;
			for (i = 0; i < length; i++) 
			{
				if (source[i].id == id) 
					return source[i];
			}
			
			return null;
		}
		
		/*********************************************************************************************************************
		*
		* cards
		* 
		*********************************************************************************************************************/	
		
		public function loadCardSkin(id:int, makeCurent:Boolean = false):SkinningCardData
		{
			if(makeCurent)
				pendingToCurrentCardSkinId = id;
			
			var i:int;
			var length:int = loadingCardSkins.length;
			var skinningCardData:SkinningCardData;
			for (i = 0; i < length; i++) 
			{
				skinningCardData = loadingCardSkins[i];
				if (skinningCardData.id == id) {
					if(makeCurent && skinningCardData.isLoaded)
						callback_completeLoadCardSkin();
					return skinningCardData;
				}
			}
			
			skinningCardData = cardBacksByID[id] as SkinningCardData;
			if (!skinningCardData)
				return null;
			
			loadingCardSkins.push(skinningCardData);
			skinningCardData.load(callback_completeLoadCardSkin);
			
			if (loadingCardSkins.length > MAX_LOADED_CARD_SKINS) 
			{
				var skinToUloadIndex:int = loadingCardSkins[0].id == (_cardSkin ? _cardSkin.id : -1) ? 1 : 0;
				loadingCardSkins[skinToUloadIndex].unload();
				loadingCardSkins.splice(skinToUloadIndex, 1);
			}
			
			return skinningCardData;
		}
		
		private function callback_completeLoadCardSkin():void 
		{
			if (pendingToCurrentCardSkinId != -1) 
			{
				if (_cardSkin.id != pendingToCurrentCardSkinId)
				{
					var newCardSkin:SkinningCardData = cardBacksByID[pendingToCurrentCardSkinId] as SkinningCardData;
					
					if (_cardSkin.cellTextStyle.fontName != newCardSkin.cellTextStyle.fontName)
						Fonts.disposeDynamicBitmapFont(_cardSkin.cellTextStyle.fontName);
					
					_cardSkin = newCardSkin;
				}
				
				if (_cardSkin.isLoaded) {
					refreshInGameTextures();
					pendingToCurrentCardSkinId = -1;
				}
			}
		}
		
		private function getCardById(source:Vector.<SkinningCardData>, id:int):SkinningCardData
		{
			var i:int;
			var length:int = source.length;
			for (i = 0; i < length; i++) 
			{
				if (source[i].id == id) 
					return source[i];
			}
			
			return null;
		}
		
		/*********************************************************************************************************************
		*
		* voiceovers
		* 
		*********************************************************************************************************************/	
		
		public function loadVoiceover(id:int, makeCurent:Boolean = false):VoiceoverData
		{
			if(makeCurent)
				pendingToCurrentVoiceoverId = id;
			
			var i:int;
			var length:int = loadingVoiceovers.length;
			var voiceoverData:VoiceoverData;
			for (i = 0; i < length; i++) 
			{
				voiceoverData = loadingVoiceovers[i];
				if (voiceoverData.id == id) 
				{
					if(makeCurent && voiceoverData.isPackLoaded)
						callback_completeLoadVoiceover();
					
					//sosTrace('loadVoiceover has in loading', id, makeCurent, voiceoverData.isPackLoaded, SOSLog.INFO);	
					return voiceoverData;
				}
			}
			
			voiceoverData = voiceoversByID[id] as VoiceoverData;
			if (!voiceoverData)
				return null;
			
			loadingVoiceovers.push(voiceoverData);
			voiceoverData.load(callback_completeLoadVoiceover);
			
			if (loadingVoiceovers.length > MAX_LOADED_VOICEOVERS) 
			{
				var skinToUloadIndex:int = loadingVoiceovers[0].id == (_voiceover ? _voiceover.id : -1) ? 1 : 0;
				loadingVoiceovers[skinToUloadIndex].unload();
				loadingVoiceovers.splice(skinToUloadIndex, 1);
			}
			
			return voiceoverData;
		}
		
		private function callback_completeLoadVoiceover():void 
		{
			//sosTrace('callback_completeLoadVoiceover', pendingToCurrentVoiceoverId, _voiceover.id, SOSLog.INFO);	
			if (pendingToCurrentVoiceoverId != -1) 
			{
				if (_voiceover.id != pendingToCurrentVoiceoverId)
					_voiceover = voiceoversByID[pendingToCurrentVoiceoverId] as VoiceoverData;
					
				//sosTrace('>>', pendingToCurrentVoiceoverId, _voiceover.id, _voiceover.soundZipAsset ? (_voiceover.soundZipAsset.loaded.toString + ' | ' + Boolean(_voiceover.soundZipAsset.soundsList)) : 'no zip asset',  SOSLog.INFO);	
				if (_voiceover && _voiceover.useSounds()) {
					//sosTrace('callback_completeLoadVoiceover useSounds complete', pendingToCurrentVoiceoverId, SOSLog.INFO);	
					pendingToCurrentVoiceoverId = -1;
				}
			}
		}
		
		public function getVoiceoverById(id:int):VoiceoverData
		{
			return id in voiceoversByID ? (voiceoversByID[id] as VoiceoverData) : null;
		}
		
		/*********************************************************************************************************************
		*
		* 
		* 
		*********************************************************************************************************************/	
		
		public function cleanUnnecessarySkins():void 
		{
			var i:int;
			var skinningDauberData:SkinningDauberData;
			while (i < loadingDauberSkins.length) {
				skinningDauberData = loadingDauberSkins[i];
				if ((_dauberSkin && skinningDauberData.id == _dauberSkin.id) || pendingToCurrentDauberSkinId == skinningDauberData.id) {
					//sosTrace('cleanUnnecessaryDauber', skinningDauberData.id, skinningDauberData.isLoaded, SOSLog.INFO);	
					i++;
				}
				else {
					skinningDauberData.unload();
					loadingDauberSkins.splice(i, 1);
				}
			}
			
			i = 0;
			var skinningCardData:SkinningCardData;
			while (i < loadingCardSkins.length) {
				skinningCardData = loadingCardSkins[i];
				if ((_cardSkin && skinningCardData.id == _cardSkin.id) || pendingToCurrentCardSkinId == skinningCardData.id) {
					//sosTrace('cleanUnnecessaryCardSkin', skinningCardData.id, skinningCardData.isLoaded, SOSLog.INFO);	
					i++;
				}
				else {
					skinningCardData.unload();
					loadingCardSkins.splice(i, 1);
				}
			}
			
			i = 0;
			var voiceoverData:VoiceoverData;
			while (i < loadingVoiceovers.length) {
				voiceoverData = loadingVoiceovers[i];
				if ((_voiceover && voiceoverData.id == _voiceover.id) || pendingToCurrentVoiceoverId == voiceoverData.id) {
					//sosTrace('cleanUnnecessaryVoiceover', voiceoverData.id, voiceoverData.isPackLoaded, voiceoverData.soundZipAsset ? (voiceoverData.soundZipAsset.loaded.toString + ' | ' + Boolean(voiceoverData.soundZipAsset.soundsList)) : 'no zip asset', SOSLog.INFO);	
					i++;
				}
				else {
					voiceoverData.unload();
					loadingVoiceovers.splice(i, 1);
				}
			}
			
			callback_completeLoadVoiceover();
			callback_completeLoadCardSkin();
			callback_completeLoadDauberSkin();
		}
		
		public function refreshInGameTextures():void {
			if(Game.current.gameScreen.gameUI.gameCardsView)
				Game.current.gameScreen.gameUI.gameCardsView.refreshSkinTextures();
		}
		
		public function refreshLayoutType():void 
		{
			_cardSkin.isTablet = layoutHelper.isLargeScreen;
			_cardSkinX2.isTablet = layoutHelper.isLargeScreen;
			
			var i:int;
			var length:int = loadingCardSkins.length;
			var skinningCardData:SkinningCardData;
			for (i = 0; i < length; i++) 
			{
				skinningCardData = loadingCardSkins[i];
				if (skinningCardData.id != _cardSkin.id)
					skinningCardData.isTablet = layoutHelper.isLargeScreen;
			}
		}
		
		public function getSetByID(id:uint):CustomizerSet
		{
			if (setByID.hasOwnProperty(id))
			{
				return setByID[id];
			}
			
			var customizerSet:CustomizerSet = new CustomizerSet();
			customizerSet.id = id;
			setList.push(customizerSet);
			setByID[id] = customizerSet;
			return customizerSet;
		}
		
		public function getCustomizerItemByTypeAndID(type:int, id:int):CustomizerItemBase
		{
			var map:Object = { };
			switch(type)
			{
				case CustomizationType.CARD:
					map = cardBacksByID;
					break;
				case CustomizationType.DAUB_ICON:
					map = daubersByID;
					break;
				case CustomizationType.VOICEOVER:
					map = voiceoversByID;
					break;
			}
			
			if (map)
			{
				if (map.hasOwnProperty(id))
				{
					return map[id];
				}
				else
				{
					sosTrace("Could not find customizer item with id " + id + " in type " + type, SOSLog.ERROR);
				}
			}
			else
			{
				sosTrace("Could not find customizer map for type " + type, SOSLog.ERROR);
			}
			return null;
		}
		
		public function get isUseCompleteSet():Boolean
		{
			return cardSkin.setID == dauberSkin.setID && cardSkin != defaultCardSkin;
		}
		
		public function cleanNewCustomizerItems():void {
			newCustomizerItems.splice(0, newCustomizerItems.length);
			dispatchEventWith(EVENT_NEW_ITEMS_CHANGE);
		}
		
		public function getRandomCustomizerByAssets(type:int, weightedRaw:Object):CustomizerItemBase 
		{
			if (!weightedRaw)
				return null;
			
			var asset:String;
			var weightedList:WeightedList = new WeightedList();
			var customizer:CustomizerItemBase;
			for (asset in weightedRaw) 
			{
				customizer = getCustomizerByAsset(type, asset);
				if (customizer)
					weightedList.addWeightedItem(customizer, weightedRaw[asset]);
			}
			
			return weightedList.getRandomDrop(Math.random());
		}
		
		public function getCustomizerByAsset(type:int, asset:String):CustomizerItemBase
		{
			var sourceList:Object;
			switch(type) {
				case CustomizationType.CARD: 
					sourceList = cardBacksByID;
					break;
				case CustomizationType.DAUB_ICON: 
					sourceList = daubersByID;
					break;
				case CustomizationType.VOICEOVER: 
					sourceList = voiceoversByID;
					break;
				case CustomizationType.AVATAR: 
					//sourceList = voiceoversByID;
					break;
			}
			
			if (!sourceList)
				return null;
				
			var customizer:CustomizerItemBase;
			for each (customizer in sourceList) 
			{
				if (customizer.sourceAssetPath == asset)
					return customizer;
			}
			
			return null;
		}
		
		public function getCustomizerByUID(uid:String):CustomizerItemBase
		{
			return allCustomizersByUID[uid] as CustomizerItemBase;
		}
		
		public static function isCustomizerSubtype(string:String):Boolean {
			return customizersSubtypes.indexOf(parseInt(string)) != -1;	
		}
		
		public function getVoiceoverVolume(assetName:String):Number 
		{
			if (assetName in _voiceoversVolume)
				return _voiceoversVolume[assetName];
			
			return SoundManager.VOICEOVER_VOLUME;
		}
		
		public function get voiceoversVolume():Object
		{
			return _voiceoversVolume;
		}
		
		/*********************************************************************************************************************
		*
		* 
		* 
		*********************************************************************************************************************/	
		
		
		/*private function cleanLoadedItems():void 
		{
			var i:int;
			var skinningDauberData:SkinningDauberData;
			while (i < loadingDauberSkins.length) {
				skinningDauberData = loadingDauberSkins[i];
				if (!skinningDauberData.isLoaded) {
					i++;
				}
				else {
					loadingDauberSkins.splice(i, 1);
				}
			}
			
			i = 0;
			var skinningCardData:SkinningCardData;
			while (i < loadingCardSkins.length) {
				skinningCardData = loadingCardSkins[i];
				if (!skinningCardData.isLoaded) {
					i++;
				}
				else {
					loadingCardSkins.splice(i, 1);
				}
			}
		}*/
		
		
		public function debugAddCustomizers():void 
		{
			/*debugAddCardSkin('default_black');
			debugAddCardSkin('default_green');
			debugAddCardSkin('alisa');
			debugAddCardSkin('west');
			debugAddCardSkin('retro');
			debugAddCardSkin('elite');
			debugAddCardSkin('gold');
			
			debugAddDauberSkin('default_black');
			debugAddDauberSkin('default_green');
			debugAddDauberSkin('alisa');
			debugAddDauberSkin('west');
			debugAddDauberSkin('retro');
			debugAddDauberSkin('elite');
			debugAddDauberSkin('gold');*/
			
			/*debugAddSet(3, 'Pink set');
			debugAddSet(4, 'Purple set');
			debugAddSet(5, 'Red set');
			debugAddSet(6, 'Pink cats');
			debugAddSet(7, 'Skull set');
			debugAddSet(8, 'Dogs set');*/
			
			/*debugAddVoiceover('default_girl', 'jessica', 'jessica 128');
			debugAddVoiceover('default_girl', 'jessica_64', 'jessica 64');
			debugAddVoiceover('usa', 'john', 'john 128');
			debugAddVoiceover('usa', 'john_64', 'john 64');
			debugAddVoiceover('salsa', 'rodrigo', 'rodrigo 128');
			debugAddVoiceover('salsa', 'rodrigo_64', 'rodrigo 64');*/
			
		}
		
		private static var debugCustomizersIds:int = 100000;
		
		public function debugAddCardSkin(assetPath:String, name:String = null):void 
		{
			var cardSkin:SkinningCardData = new SkinningCardData();
			cardSkin.create(debugCustomizersIds++, assetPath, assetPath, String(name || assetPath).toUpperCase(), 100000, int(Math.random()*2), CardType.NORMAL, 0);
			cardBacksByID[cardSkin.id] = cardSkin;
			customCardBacks.push(cardSkin);
		}
		
		public function debugAddDauberSkin(assetPath:String, name:String = null):void 
		{
			var dauberSkin:SkinningDauberData = new SkinningDauberData();
			dauberSkin.create(debugCustomizersIds++, assetPath, assetPath, String(name || assetPath).toUpperCase(), 100000, int(Math.random()*2), CardType.NORMAL, 0, 0xFFFFFF * Math.random());
			daubersByID[dauberSkin.id] = dauberSkin;
			customDaubers.push(dauberSkin);
		}
		
		public function debugAddVoiceover(imagePath:String, assetPath:String, name:String = null):void 
		{
			var voiceover:VoiceoverData = new VoiceoverData();
			voiceover.create(debugCustomizersIds++, assetPath, imagePath, String(name || assetPath).toUpperCase(), 100000, int(Math.random()*2), CardType.NORMAL, 0);
			voiceoversByID[voiceover.id] = voiceover;
			customVoiceovers.push(voiceover);
		}
		
		public function debugAddSet(id:int, name:String = null):void 
		{
			var customizerSet:CustomizerSet = new CustomizerSet();
			customizerSet.create(id, name, daubersSetById[id], cardsSetById[id]);
			setList.push(customizerSet);
			setByID[id] = customizerSet;
		}
		
		
		public function debugAddRandomCustomizers(addAll:Boolean = false, ignoreWeight:Boolean = false):void 
		{
			var customizerType:int;
			var customizerListById:Object;
			var customizerBase:CustomizerItemBase;
			
			for (customizerType in customizersListsByType) 
			{
				customizerListById = customizersListsByType[customizerType];
				for each (customizerBase in customizerListById) 
				{
					if (!ignoreWeight && customizerBase.weight == 0)
						continue;
					
					if (addAll)
					{
						customizerBase.quantity += 1;
					}
					else
					{
						customizerBase.quantity += Math.random() > 0.65 ? int(Math.random() * 4) : 0;
					}
				}
			}
		}
		
		public function debugAddRandomNewCustomizer(type:int, count:int = 1):void 
		{
			var customizerListById:Object;
			customizerListById = customizersListsByType[type];
			var customizerBase:CustomizerItemBase;
			var customizers:Array = [];
			for each (customizerBase in customizerListById) 
			{
				if (customizerBase.weight == 0)
					continue;
				
				if (customizerBase.quantity <= 0)
				{
					customizers.push(customizerBase);
				}
			}
			
			var index:int;
			while (count > 0 && customizers.length > 0) 
			{
				index = Math.floor(customizers.length * Math.random()); 
				customizerBase = customizers.splice(index, 1)[0] as CustomizerItemBase;
				customizerBase.quantity++;
				gameManager.skinningData.newCustomizerItems.push(customizerBase);
				
				count--;
			}
			
			dispatchEventWith(EVENT_NEW_ITEMS_CHANGE);
			
		}
	}

}
