package com.alisacasino.bingo.dialogs
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.ChestPowerupPack;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.game.StakeData;
	import com.alisacasino.bingo.models.powerups.PowerupModel;
	import com.alisacasino.bingo.models.quests.QuestObjective;
	import com.alisacasino.bingo.models.quests.QuestType;
	import com.alisacasino.bingo.models.quests.questItems.BurnNCards;
	import com.alisacasino.bingo.models.quests.questItems.CollectNCards;
	import com.alisacasino.bingo.models.quests.questItems.QuestBase;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.models.universal.CommoditySource;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.ICardData;
	import com.alisacasino.bingo.utils.TimeService;
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Slider;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.Direction;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import starling.textures.Texture;
	import feathers.core.ITextRenderer;
	
	import starling.display.Image;
	
	public class QuestServiceDialog extends BaseDialog
	{
		static public var DEBUG_PAYMENTS:Boolean = false;
		
		public function QuestServiceDialog()
		{
			super(DialogProperties.SERVICE_QUESTS);
			gameScreen = Game.current.currentScreen as GameScreen;
			objectsById = {};
		}
		
		private var scrollContainer:ScrollContainer;
		
		private var container:Sprite;
		
		private var buttonCallbacksDictionary:Dictionary;
		
		private var buttonColorIndex:int;
		
		private var gameScreen:GameScreen;
		
		private var objectsById:Object;
		
		private var buttonColors:Array = [330870,9578819,1984337,4052457,7953259,5542953,2947838,6506222,9667284,6882012,6029631,11768473,12957263,13115674,11631817,7431128,11840660,9465891,
		7541346, 10739572, 7195475, 10284260, 4671733, 7301375, 4637006, 9669616, 6357028, 13905221, 986707, 10873472, 2040207,
		44014, 9466874, 8022608, 11523063, 14985616, 7955897, 2129476, 7323293, 10636579, 3730454, 14612893, 3976943, 4327712, 11642786,
		15973863, 15791505, 4863041, 8619008, 10698731, 11631962, 2074951, 16656500, 408212, 647849, 13069060, 8208568, 5110887, 9615107,
		1593128, 13471120, 5775541, 2645567, 384221, 3026865, 15177090, 1790953, 8276972, 6805651, 9155438, 13832500, 6571711, 15209748,
		12386419, 7607419, 14343004, 2850643, 375186, 1546432, 9549672, 6182144, 3948273, 11832975, 8942018, 5699986, 10464585, 4529088,
		10665129, 10393584, 14321620, 15079973, 6254475, 891899, 1476558, 10646534, 8963500, 13279783, 5785910, 15540703, 14432032, 2752310,
		11290374, 5842376, 12700489, 7917561, 13732826, 6615351, 7461272, 15954441, 11733843]
		
		override protected function initialize():void 
		{
			super.initialize();
			scrollContainer = new ScrollContainer();
			addChild(scrollContainer);
			
			container = new Sprite();
			//container.y = 75*pxScale;
			scrollContainer.y = 75*pxScale;
			scrollContainer.addChild(container);
			addToFadeList(container);
			
			buttonCallbacksDictionary = new Dictionary();
			
			scrollContainer.clipContent = true;
			scrollContainer.snapToPages = true;
			scrollContainer.minimumPageThrowVelocity = 2;
			scrollContainer.pageThrowDuration = 0.2;
			scrollContainer.hasElasticEdges = true;
			
			// CONTENT:
			
			addDropdownList(container, null, 220, new ListCollection(gameManager.questModel.debugGetQuestsByType(QuestType.EVENT_QUEST, 'no event')), callback_questSelect, null, QuestDropdownListItemRenderer, 'questsSelectList');	
			addDropdownList(container, null, 220, new ListCollection(gameManager.questModel.debugGetQuestsByType(QuestType.DAILY_QUEST, 'no daily')), callback_questSelect, null, QuestDropdownListItemRenderer, 'questsSelectList');	
			addDropdownList(container, null, 220, new ListCollection(gameManager.questModel.debugGetQuestsByType(QuestType.BONUS_QUEST, 'no bonus')), callback_questSelect, null, QuestDropdownListItemRenderer, 'questsSelectList');	
			
			//offersDropdownList.selectedIndex = -1;
			
			//addButton('cycleActiveQuest', gameManager.questModel.cycleActiveQuest, [], 10, 10, true);
			
			addDivider();
			
			addIncreaseObjectivesButtons();
			
			//addLabel();
			
			//addDivider();
			
			//addButton('Add ltv (' + Player.current.lifetimeValue.toString() + ')', increaseLtv, null, 10, 10, false, 'addLtvButton');
			
		}	
		
		override public function resize():void
		{
			super.resize();
			
			var currentX:int = 0;
			var currentY:int = 0//75;
			var verticalGap:int = 16;
			var horisontalGap:int = 16;
			
			var i:int;
			var length:int = container.numChildren;
			var displayObject:DisplayObject;
			var view:DisplayObject;
			
			var lineViewsList:Array = [];
			var lineWidth:int;
			var lineHeight:int;
			
			var viewWidth:int;
			var viewHeight:int;
			
			for(i=0; i<length; i++)
			{
				displayObject = container.getChildAt(i) as DisplayObject;
				
				viewWidth = getViewWidth(displayObject);
				viewHeight = getViewHeight(displayObject);
				
				//trace(' hhhh ', viewWidth, viewHeight);
				if ((lineWidth + viewWidth) > (backgroundWidth - 30))
				{
					currentX += (backgroundWidth - lineWidth) / 2;
					
					if (lineViewsList.length == 1) {
						lineWidth -= horisontalGap;
						currentX = (backgroundWidth - lineWidth) / 2;
					}
						
					while (lineViewsList.length > 0) 
					{
						view = lineViewsList.shift();
						
						view.y = currentY + (lineHeight - getViewHeight(view))/2;
						view.x = currentX;
						currentX = view.x + getViewWidth(view) + horisontalGap;
					}
					
					currentX = 0;
					currentY += lineHeight + verticalGap;
					
					lineWidth = viewWidth + horisontalGap; 
					lineHeight = viewHeight;
					lineViewsList.push(displayObject);
				}
				else
				{
					lineWidth += viewWidth + horisontalGap; 
					lineHeight = Math.max(lineHeight, viewHeight);
					
					lineViewsList.push(displayObject);
				}
			}
			
			currentX += (backgroundWidth - lineWidth) / 2;
			while (lineViewsList.length > 0) 
			{
				view = lineViewsList.shift();
				view.y = currentY + (lineHeight - getViewHeight(view))/2;
				//view.x = (backgroundWidth - getViewWidth(displayObject)) / 2;
				view.x = currentX;
				currentX = view.x + getViewWidth(view) + horisontalGap;
				
				lineWidth -= horisontalGap;
			}
			
			scrollContainer.height = (this.height - gameUILayoutScale*10)/gameUILayoutScale - scrollContainer.y;
			//scrollContainer.height = this.height - pxScale*10 - scrollContainer.y;
		}	
		
		override public function get baseScale():Number
		{
			return layoutHelper.independentScaleFromEtalonMin;
		}
		
		private function addDivider():void 
		{
			var quad:Quad = new Quad(1, 1);
			quad.width = backgroundWidth - 50*pxScale;
			container.addChild(quad);
		}
		
		private function addButton(label:String, callback:Function, callbackParams:Array = null, paddingHorisontal:uint = 10, paddingVertical:uint = 10, close:Boolean=true, id:String = null, color:uint = 0):void 
		{
			var button:Button = new Button();
			button.useHandCursor = true;
			button.addEventListener(Event.TRIGGERED, callback_button);
			button.label = label;
			button.labelFactory = labelTextFactory;
			button.defaultSkin = new Image(Texture.fromColor(50*pxScale, 20*pxScale, color > 0 ? color : (buttonColors[buttonColorIndex++])));
			
			button.paddingLeft = paddingHorisontal*pxScale;
			button.paddingRight = paddingHorisontal*pxScale;
			button.paddingTop = paddingVertical*pxScale;
			button.paddingBottom = paddingVertical*pxScale;
			container.addChild(button);
			
			button.validate();
			
			if(!callbackParams)
				callbackParams = [];
				
			callbackParams.unshift(close);
			callbackParams.unshift(callback);
			buttonCallbacksDictionary[button] = callbackParams;
			
			if(id)
				objectsById[id] = button;
		}
		
		private function callback_button(event:Event):void
		{
			var params:Array = buttonCallbacksDictionary[event.target];
			var callback:Function = params[0] as Function;
			if (params[1])
				removeDialog();
			callback.apply(null, params.slice(2, params.length));
		}
		
		private function addLabel(text:String, paddingHorisontal:uint = 10, paddingVertical:uint = 10):void 
		{
			var label:Label = new Label();
			label.textRendererFactory = labelTextFactory;
			
			label.text = text;
			label.paddingLeft = paddingHorisontal*pxScale;
			label.paddingRight = paddingHorisontal*pxScale;
			label.paddingTop = paddingVertical*pxScale;
			label.paddingBottom = paddingVertical*pxScale;
			label.validate();
			//label.backgroundSkin = new Quad(getViewWidth(label), getViewHeight(label), 0xFF0000);
			container.addChild(label);
		}
		
		private function labelTextFactory():ITextRenderer
		{
			 var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
			textRenderer.textFormat = new TextFormat(Fonts.CHATEAU_DE_GARAGE, 16*pxScale, 0xffffff );
			textRenderer.embedFonts = true;
			return textRenderer;
		}
		
		private function getViewWidth(displayObject:DisplayObject):Number
		{
			//if ('paddingRight' in displayObject && 'paddingLeft' in displayObject)
				//return displayObject.width + displayObject['paddingRight'] + displayObject['paddingLeft']
			
			return displayObject.width;	
		}
		
		private function getViewHeight(displayObject:DisplayObject):Number
		{
			//if ('paddingTop' in displayObject && 'paddingBottom' in displayObject)
				//return displayObject.height + displayObject['paddingTop'] + displayObject['paddingBottom']
			
			return displayObject.height;	
		}
		
		private function addSlider(text:String, sliderWidth:int, min:Number, max:Number, step:Number, callback:Function = null, callbackParams:Array = null, id:String = null, thumbCallback:Function = null):void 
		{
			var color:uint = buttonColors[buttonColorIndex++];
			
			var sliderContainer:Sprite = new Sprite();
			//sliderContainer.name = id;
			container.addChild(sliderContainer);
			
			var label:Label = new Label();
			label.textRendererFactory = labelTextFactory;
			
			label.text = text;
			label.name = text;
			label.validate();
			label.y = 3*pxScale;
			sliderContainer.addChild(label);
			
			var slider:Slider = new Slider();
			slider.x = label.width + 37*pxScale;
			slider.minimum = min;
			slider.maximum = max;
			slider.value = (max - min)/2;
			slider.step = step;
			slider.direction = Direction.HORIZONTAL;

			slider.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(30 * pxScale, 30 * pxScale , color);
				thumb.addEventListener(Event.TRIGGERED, function(e:Event):void { if(thumbCallback != null) thumbCallback() });
				return thumb;
			};
			
			slider.minimumTrackFactory  = function():BasicButton
			{
				var track:BasicButton = new BasicButton();
				track.defaultSkin = new Quad(sliderWidth, 5*pxScale , color);
				return track;
			};
			
			slider.addEventListener(Event.CHANGE, function slider_changeHandler1( event:Event ):void
			{
				label.text = label.name + ' ' + slider.value.toString();
				callback.apply(null, (callbackParams || []).concat(slider.value));
			});
			
			slider.validate();
			sliderContainer.addChild(slider);
			
			
			if(id)
				objectsById[id] = sliderContainer;
		}
		
		private function setSliderByContainer(sliderContainer:Sprite, value:Number):void
		{
			if (!sliderContainer)
				return;
			(sliderContainer.getChildAt(0) as Label).text = (sliderContainer.getChildAt(0) as Label).name + " " + value.toString();
			(sliderContainer.getChildAt(1) as Slider).value = value;
		}	
		
		override public function close():void
		{
			super.close();
			new UpdateLobbyBarsTrueValue(0.5).execute();
			
		}	
		
		/*********************************************************************************************************************
		*
		* Dropdown list
		* 
		*********************************************************************************************************************/		
		 
		private function addDropdownList(controlContainer:DisplayObjectContainer, text:String, viewWidth:int, itemsList:ListCollection, callback:Function = null, callbackParams:Array = null, rendererClass:Class = null, id:String = null):PickerList 
		{
			var color:uint = buttonColors[buttonColorIndex++];
			
			var contentContainer:DropDownListContainer = new DropDownListContainer();
			//sliderContainer.name = id;
			controlContainer.addChild(contentContainer);
			
			if (text)
			{
				contentContainer.label = new Label();
				contentContainer.label.textRendererFactory = function labelTextFactory():ITextRenderer {
					var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
					textRenderer.textFormat = new flash.text.TextFormat(Fonts.CHATEAU_DE_GARAGE, 12*pxScale, 0xffffff);
					textRenderer.embedFonts = true;
					textRenderer.text = '-';
					return textRenderer;
				}
				contentContainer.label.width = viewWidth;
				contentContainer.label.text = text;
				contentContainer.label.name = text;
				contentContainer.label.validate();
				contentContainer.label.y = 3*pxScale;
				contentContainer.addChild(contentContainer.label);
			}
			
			contentContainer.pickerList = new PickerList();
			contentContainer.pickerList.y = contentContainer.label ? (contentContainer.label.height + 3 * pxScale) : 0;
			contentContainer.pickerList.dataProvider = itemsList;
			//pickerList.maximum = max;
			//pickerList.value = (max - min)/2;
			//numericStepper.step = step;
			
			/*pickerList. itemRendererFactory = function():IListItemRenderer
			{
				var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				itemRenderer.labelField = "text";
				return itemRenderer;
			}*/
			
			//contentContainer.pickerList.buttonProperties = {title};
			contentContainer.pickerList.buttonFactory = function():Button
			{
				var button:Button = new Button();
				button.labelFactory = function labelTextFactory(...args):ITextRenderer
				{
					var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
					textRenderer.textFormat = new flash.text.TextFormat(Fonts.CHATEAU_DE_GARAGE, 12*pxScale, 0xffffff);
					textRenderer.embedFonts = true;
					return textRenderer;
				}
				button.defaultSkin = new Quad(viewWidth * pxScale, 40, color);
				button.addEventListener(Event.TRIGGERED, function(e:Event):void {  });

				return button;
			};
			
			contentContainer.pickerList.labelFunction = function( item:Object ):String
			{
				return item.text;
			}
			
			//contentContainer.pickerList.
			contentContainer.pickerList.listFactory = function():List
			{
				var popUpList:List = new List();
				popUpList.itemRendererFactory = function():IListItemRenderer
				{
					//var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
					var renderer:DefaultListItemRenderer = rendererClass ? ((new rendererClass()) as DefaultListItemRenderer) : (new DefaultListItemRenderer());
					renderer.labelField = "text";
					
					renderer.defaultSkin = new Quad(viewWidth * pxScale, 40 * pxScale , color);
					
					renderer.labelFactory = function labelTextFactory():ITextRenderer
					{
						var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
						textRenderer.textFormat = new flash.text.TextFormat(Fonts.CHATEAU_DE_GARAGE, 10*pxScale, 0x000000, null, null, null, null, null, TextFormatAlign.LEFT);
						textRenderer.embedFonts = true;
						return textRenderer;
					}
					
					//renderer.iconSourceField = "thumbnail";
					return renderer;
				};
				
				//popUpList.backgroundSkin = new Quad(100 * pxScale, 100 * pxScale , color);
				
				return popUpList;
			}
			
			//pickerList.prompt = "Select an Item";
			//list.selectedIndex = -1;
			
			contentContainer.pickerList.addEventListener(Event.CHANGE, function slider_changeHandler1( event:Event ):void
			{
				if(callback != null)
					callback.apply(null, (callbackParams || []).concat(contentContainer.pickerList.selectedItem));
			});
			
			contentContainer.pickerList.validate();
			contentContainer.addChild(contentContainer.pickerList);
			
			
			if(id)
				objectsById[id] = contentContainer;
				
			return contentContainer.pickerList;	
		}
		
		
		/*********************************************************************************************************************
		 *
		 * 
		 * 
		 *********************************************************************************************************************/		
		
		private function increaseLtv():void
		{
			Player.current.lifetimeValue += 5;
			
			var button:Button = objectsById['addLtvButton'] as Button;
			button.label = 'Add ltv (' + Player.current.lifetimeValue.toString() + ')';
			
			Game.connectionManager.sendPlayerUpdateMessage();
		}
		
		private var lastSelectedQuest:QuestBase;
		
		private function callback_questSelect(item:Object):void 
		{
			if (!item || !item.object || item.object is String) {
				gameManager.questModel.deactivateQuestByType(String(item.object));
				return;
			}
			
			var quest:QuestBase = item.object as QuestBase;
			lastSelectedQuest = quest;
			
			quest.reset();
				
			if (quest.type == QuestType.DAILY_QUEST)
			{
				quest.timeStart = TimeService.serverTime + 1;
				
				var tourneyFinishTimestamp:int = Math.ceil(gameManager.tournamentData.endsAt / 1000);
				if (TimeService.serverTime >= tourneyFinishTimestamp)
					quest.duration = Math.max(60, Math.ceil(gameManager.tournamentData.duration / 1000)); 
				else 					
					quest.duration = tourneyFinishTimestamp - quest.timeStart;
			}
			else
			{
				quest.timeStart = TimeService.serverTime;
			}
			
			
			gameManager.questModel.activateQuest(quest, true);
			
			//close();
		}
		 
		private function addIncreaseObjectivesButtons():void 
		{
			/*var objectives:Array = QuestObjective.objectives;
			var objective:String;
			
			var color:uint = buttonColors[buttonColorIndex++];
			var buttonsContainer:Sprite = new Sprite();
			container.addChild(buttonsContainer);
			
			for (var i:int = 0; i < objectives.length; i++) 
			{
				objective = objectives[i];
				
				var button:Button = new Button();
				button.useHandCursor = true;
				button.addEventListener(Event.TRIGGERED, callback_button);
				button.label = objective;
				button.labelFactory = labelTextFactory;
				button.defaultSkin = new Image(Texture.fromColor(50*pxScale, 20*pxScale, color));
				
				button.paddingLeft = 10*pxScale;
				button.paddingRight = 10*pxScale;
				button.paddingTop = 10*pxScale;
				button.paddingBottom = 10*pxScale;
				container.addChild(button);
				
				button.validate();
				
				button.x = 100;
				button.y = i*35*pxScale;
				buttonsContainer.addChild(button);
				
				var	callbackParams:Array = [objective];
				callbackParams.unshift(false);
				callbackParams.unshift(increaseQuestObjective);
				buttonCallbacksDictionary[button] = callbackParams;
			}*/
			
			gameManager.questModel.createQuestStyles();
			
			var activeQuests:Array = [
				gameManager.questModel.getActiveQuestByType(QuestType.EVENT_QUEST),
				gameManager.questModel.getActiveQuestByType(QuestType.DAILY_QUEST),
				gameManager.questModel.getActiveQuestByType(QuestType.BONUS_QUEST)
			];
			
			
			for (var i:int = 0; i < activeQuests.length; i++) 
			{
				var quest:QuestBase = activeQuests[i];
				if(quest)
					addButton(quest.type + ' ' + int(quest.getProgress()) + '/' + quest.goal, increaseQuestObjective, [quest], 10, 10, false, 'eQO' + quest.type, quest.style.backgroundColor);
				else
					addButton('no quest', null, null, 10, 10, false, 'eQO___', 0xD0D0D0);
			}
		}
		
		private function increaseQuestObjective(quest:QuestBase):void 
		{
			var functionName:String;
			
			var option_0:* = (quest.options && quest.options.length > 0) ? quest.options[0] : null;
			var options:Array = quest.options;
			
			var card:ICardData;
			var callFunction:Function;	
			
			switch(quest.objectiveType) 
			{
				case QuestObjective.COLLECT_N_BINGOS: 
				{
					switch(option_0)
					{
						default:
						case "any":
							gameManager.questModel.bingoClaimed(false, 30, new <String>['diagonal'], Room.current.stakeData);
							break;
						case "top":
							gameManager.questModel.bingoClaimed(false, int(options[1]), new <String>['diagonal'], Room.current.stakeData);
							break;
						case "pattern":
							gameManager.questModel.bingoClaimed(false, 30, new <String>[options[1]], Room.current.stakeData);
							break;
						case "x2":
							gameManager.questModel.bingoClaimed(true, 30, new < String > ['diagonal'], Room.current.stakeData);
							break;
						case 'card_boost':
							gameManager.questModel.bingoClaimed(true, 30, new <String>['diagonal'], new StakeData(int(options[1]), '', '', [], 0));
							break;
					}
				
					break;
				}
				case QuestObjective.N_BINGO_IN_ROUND: {
					
					gameManager.questModel.roundStart(1, Room.current.stakeData);
					var bingosInRound:int = Math.max(10, int(option_0));
					while (bingosInRound-- > 0) {
						gameManager.questModel.bingoClaimed(true, 30, new <String>['diagonal'], Room.current.stakeData);
					}
					
					gameManager.questModel.roundEnd(1, Room.current.stakeData);
					
					break;
				}
				
				case QuestObjective.USE_N_POWERUPS: 
				case QuestObjective.CLAIM_N_POWERUPS: 
				{
					callFunction = quest.objectiveType == QuestObjective.USE_N_POWERUPS ? gameManager.questModel.powerupUsed : gameManager.questModel.powerupClaimedFromCard;
					
					switch(option_0)
					{
						case "rarity":
							for (var powerup:String in PowerupModel.createByRarityAndCount(options[1], 1)) {
								//gameManager.questModel.powerupClaimedFromCard(powerup);
								callFunction(powerup);
							}
							break;
						case "powerup":
							callFunction(options[1]);
							break;
						default:
							callFunction('1');
							break;
					}
					
					break;
				}
				case QuestObjective.OPEN_N_CHESTS: 
				{
					gameManager.questModel.chestOpened(option_0, []);
					break;
				}
				case QuestObjective.N_DAUBS: 
				{
					gameManager.questModel.daubRegistered(option_0 == "number" ? options[1] :  1);
					break;
				}
				case QuestObjective.N_DAUB_STREAKS: 
				{
					gameManager.questModel.daubStreakProgress(int(option_0));
					break;
				}
				
				case QuestObjective.COLLECT_N_POINTS: 
				{
					switch(option_0) 
					{
						default:
						case 'any': {
							gameManager.questModel.scoreEarned(int(Math.max(1, quest.goal/6)), Room.current.stakeData);
							break;
						}
						case 'card_boost': {
							gameManager.questModel.scoreEarned(int(Math.max(1, quest.goal/6)), new StakeData(int(options[1]), '', '', [], 0));
							break;
						}
					}
					
					break;
				}
				case QuestObjective.PLAY_N_GAMES: 
				{
					switch(option_0) 
					{
						default:
						case 'any': {
							gameManager.questModel.roundEnd((options && options.length > 0) ? int(options[0]) : 1, Room.current.stakeData);
							break;
						}
						case 'card_boost': {
							gameManager.questModel.roundEnd((options && options.length > 0) ? int(options[0]) : 1, new StakeData(int(options[1]), '', '', [], 0));
							break;
						}
					}
					
					break;
				}
				case QuestObjective.BURN_N_CARDS: 
				{
					
					switch(option_0) {
						case BurnNCards.COLLECTION: {
							card = new CollectionItem();
							break;
						}
						case BurnNCards.CUSTOMIZER: {
							card = new CustomizerItemBase();
							break;
						}
						default : {
							card = new CollectionItem();
							break;
						}
					}
					gameManager.questModel.cardBurned(card, 1);
					break;
				}
				case QuestObjective.COLLECT_N_CARDS: 
				{
					switch(option_0) {
						case CollectNCards.COLLECTION: {
							card = new CollectionItem();
							break;
						}
						case CollectNCards.CUSTOMIZER: {
							card = new CustomizerItemBase();
							break;
						}
						default : {
							card = new CollectionItem();
							break;
						}
					}
					gameManager.questModel.cardCollected(card);
					break;
				}
				case QuestObjective.WIN_N_CASH_IN_SCRATCH_CARD: 
				{
					if (option_0 == "minCash") 
						gameManager.questModel.cashCollected(int(options[1]), CommoditySource.SOURCE_SCRATCH_CARD);
					else 
						gameManager.questModel.cashCollected(int(Math.max(1, quest.goal/6)), CommoditySource.SOURCE_SCRATCH_CARD);
					
					break;
				}
				case QuestObjective.OBTAIN_N_CASH_FROM_CHEST: 
				{
					gameManager.questModel.chestOpened((int(option_0)), getChestRewardsMessages(Type.CASH, Math.max(1, quest.goal/6)));
					break;
				}
				case QuestObjective.OBTAIN_N_POWERUPS_FROM_CHEST: 
				{
					var r:ChestPowerupPack = new ChestPowerupPack('1221', {}, Math.max(1, quest.goal/6));
					gameManager.questModel.chestOpened((int(option_0)), [r]);
					break;
				}
				case QuestObjective.OBTAIN_N_CUSTOMIZERS_FROM_CHEST: 
				{
					var rewards:Array = [];
					while (rewards.length <= Math.max(1, quest.goal/6)) { 
						rewards.push(new CustomizerItemBase());
					}
			
					gameManager.questModel.chestOpened((int(option_0)), rewards);
					break;
				}
				
				default: return;
			}
			
			
		/*	
			
			questClassByType[QuestObjective.OBTAIN_N_POWERUPS_FROM_CHEST] = ObtainNPowerupsFromChest;
			questClassByType[QuestObjective.OBTAIN_N_CUSTOMIZERS_FROM_CHEST] = ObtainNCustomizersFromChest;*/
			
			
			for (var i:int = 0; i < gameManager.questModel.activeQuests.length; i++) 
			{
				var _quest:QuestBase = gameManager.questModel.activeQuests[i] as QuestBase;
				var button:Button = objectsById['eQO' + _quest.type] as Button;
				button.label = _quest.type + ' ' + int(_quest.getProgress()) + '/' + _quest.goal;
			}
			
			
			
		}
		
		private function getChestRewardsMessages(type:int, count:int, length:int = 1):Array 
		{
			var rewards:Array = [];
			
			while (rewards.length <= length) 
			{
				var cim:CommodityItemMessage = new CommodityItemMessage();
				cim.type = type;
				cim.quantity = count;
				rewards.push(cim);
			}
			
			return rewards;
		}
		
		
		/*private function increaseQuestObjective(objective:String):void 
		{
			gameManager.questModel.chestOpened();
		}*/
			
		
	}
}
import com.alisacasino.bingo.models.offers.OfferItem;
import com.alisacasino.bingo.models.quests.questItems.QuestBase;
import feathers.controls.Label;
import feathers.controls.PickerList;
import feathers.controls.renderers.DefaultListItemRenderer;
import starling.display.Quad;
import starling.display.Sprite;


final class DropDownListContainer extends Sprite {
	public var label:Label;
	public var pickerList:PickerList;
}

class QuestDropdownListItemRenderer extends DefaultListItemRenderer 
{
	private var questBase:QuestBase;
	
	override public function set data(value:Object):void
	{
		super.data = value;
		questBase  = (value && value.object && value.object is QuestBase) ? (value.object as QuestBase) : null;
	}
	
	override protected function draw():void
	{
		super.draw();
		
		if (defaultSkin && questBase) {
			(defaultSkin as Quad).color = questBase.isDebug ? 0xFFFF00 : (questBase.enabled ? 0x34C300 : 0xC32700);
		}
	}
}