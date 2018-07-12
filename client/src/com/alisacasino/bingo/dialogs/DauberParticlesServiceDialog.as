package com.alisacasino.bingo.dialogs 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.assets.ImagesAtlasAsset;
	import com.alisacasino.bingo.assets.XmlAsset;
	import com.alisacasino.bingo.components.effects.AlisaParticleItem;
	import com.alisacasino.bingo.components.effects.FFParticlesView;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.models.skinning.SkinningCardData;
	import com.alisacasino.bingo.models.skinning.SkinningDauberData;
	import com.alisacasino.bingo.screens.gameScreenClasses.CellDaubEffect;
	import de.flintfabrik.starling.extensions.FFParticleSystem.SystemOptions;
	import de.flintfabrik.starling.extensions.FFParticleSystem.styles.FFParticleStyle;
	import de.flintfabrik.starling.extensions.FFParticleSystem.styles.FFParticleStyleClone;
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PickerList;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Slider;
	import feathers.controls.TextInput;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.Direction;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.text.FontStylesSet;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLLoader;
	import flash.system.LoaderContext;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticle;
	import starling.extensions.PDParticleSystem;
	import starling.text.BitmapFont;
	
	import flash.utils.Dictionary;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.text.TextFormat;
	
	import de.flintfabrik.starling.extensions.FFParticleSystem;
	
	public class DauberParticlesServiceDialog extends BaseDialog 
	{
		
		public function DauberParticlesServiceDialog(dialogProperties:DialogProperties=null) 
		{
			super(DialogProperties.SERVICE_DAUBER_PARTICLES_DIALOG);
			objectsById = {};
			/*gameScreen = Game.current.currentScreen as GameScreen;
			
			alignsTypes = [LayoutHelper.ALIGNING_TYPE_AUTO, LayoutHelper.ALIGNING_TYPE_MOBILE, LayoutHelper.ALIGNING_TYPE_TABLET];*/
		}
		
		private var DAUBER_PREVIEW_WIDTH:int = 300 * pxScale;
		private var DAUBER_PREVIEW_HEIGHT:int = 300 * pxScale;
		
		private static var controlsChangeHandlersEnabled:Boolean = true;
		
		private var buttonColorIndex:int;
		
		private var scrollContainer:ScrollContainer;
		
		private var container:Sprite;
		
		private var objectsById:Object;
		
		private var buttonCallbacksDictionary:Dictionary;
		
		private var buttonColors:Array = [330870,9578819,1984337,4052457,7953259,5542953,2947838,6506222,9667284,6882012,6029631,11768473,12957263,13115674,11631817,7431128,11840660,9465891,
		7541346, 10739572, 7195475, 10284260, 4671733, 7301375, 4637006, 9669616, 6357028, 13905221, 986707, 10873472, 2040207,
		44014, 9466874, 8022608, 11523063, 14985616, 7955897, 2129476, 7323293, 10636579, 3730454, 14612893, 3976943, 4327712, 11642786,
		15973863, 15791505, 4863041, 8619008, 10698731, 11631962, 2074951, 16656500, 408212, 647849, 13069060, 8208568, 5110887, 9615107,
		1593128, 13471120, 5775541, 2645567, 384221, 3026865, 15177090, 1790953, 8276972, 6805651, 9155438, 13832500, 6571711, 15209748,
		12386419, 7607419, 14343004, 2850643, 375186, 1546432, 9549672, 6182144, 3948273, 11832975, 8942018, 5699986, 10464585, 4529088,
		10665129, 10393584, 14321620, 15079973, 6254475, 891899, 1476558, 10646534, 8963500, 13279783, 5785910, 15540703, 14432032, 2752310,
		11290374, 5842376, 12700489, 7917561, 13732826, 6615351, 7461272, 15954441, 11733843]
		
		private var _skinningDauberData:SkinningDauberData;
		private var dauberImage:Image;
		private var particlesView:DisplayObject;
		private var intervalId:int = -1;
		private var touchButton:Button;
		private var daubEffectType:String;
		private var dauberContainer:LayoutGroup;
		
		private var topContainer:LayoutGroup;
		
		private var particlesSettingsGroup:LayoutGroup;
		
		private var complexAtlas:ImagesAtlasAsset;
		private var particlesManagerContainer:LayoutGroup;
		private var particleRenderers:Vector.<ParticlePreviewRenderer> = new <ParticlePreviewRenderer>[];
		
		private var daubersPickerList:PickerList;
		private var cardsPickerList:PickerList;
		private var effectsPickerList:PickerList;
		
		private var PDParticlesList:Vector.<PDParticleSystem>;
		
		
		private var LABELS_COLOR:uint = 0xFFFFFF;
		private var BUTTONS_COLOR:uint = 0x555555;
		//private var SLIDER_TRACK_COLOR:uint = 0xFFFFFF;
		private var CONTROLS_HEIGHT:int = 16 * pxScale;
		
		private var CONTROLS_HEIGHT_MAX:int = 20 * pxScale;
		
		//private var buttonBgQuad:Quad;
		//private var buttonCommonTexture:Texture;
		
		private var sliderThumbSkin:Quad;
		
		//sliderTrackSkin = new Quad(viewWidth - 2 * paddingHorisontal - 2 * viewHeight, viewHeight, color);
			
		
		override protected function initialize():void 
		{
			super.initialize();
			scrollContainer = new ScrollContainer();
			addChild(scrollContainer);
			
			container = new Sprite();
			scrollContainer.y = 0*pxScale;
			scrollContainer.addChild(container);
			addToFadeList(container);
				
			buttonCallbacksDictionary = new Dictionary();
			
			scrollContainer.clipContent = true;
			scrollContainer.snapToPages = true;
			scrollContainer.minimumPageThrowVelocity = 2;
			scrollContainer.pageThrowDuration = 0.2;
			scrollContainer.hasElasticEdges = true;
			
			/*buttonBgQuad = new Quad(16 * pxScale, 16 * pxScale, 0xFFFFFF);
			
			buttonCommonTexture = Texture.fromColor(16 * pxScale, 16 * pxScale, 0x1010101);
			sliderThumbSkin = new Quad(16 * pxScale, 16 * pxScale, 0x1010101);*/
			
			/*PDParticlesList = new <PDParticleSystem>[];
			
			var f:PDParticleSystem = new PDParticleSystem(null, AtlasAsset.CommonAtlas.getTexture("buy_cards/gray_padlock"));
			f.x = 300;
			f.y = 300;
			f.start();
			addChild(f);*/
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			//	var psConfig:XML = XML(DefaultFFParticleXML.xml)//XmlAsset.CashPeriodicParticlesCfg.xml);//Snow.xml);
			/*var psConfig:XML = XML(DefaultFFParticleXML.xml)
			var sysOpt:SystemOptions = SystemOptions.fromXML(psConfig, AtlasAsset.CommonAtlas.getTexture("buy_cards/gray_padlock"));
			FFParticleSystem.initPool();
			
			var ffpsStyle:FFParticleStyle = new FFParticleSystem.defaultStyle();
			ffpsStyle.effectType.createBuffers(4096, 16);
			//FFParticleStyleClone.effectType.createBuffers(4096, 16);
			
			// create particle system
			var ps:FFParticleSystem = new FFParticleSystem(sysOpt, ffpsStyle);
			//new FFParticleStyleClone()
			
			Game.current.gameScreen.addChild(ps);
			
			ps.emitterX = 200;
			ps.emitterY = 200;
			
			//	sysOpt.appendFromObject();
			
			//ps.advanceTime(20);
			
			ps.start();
			ps.touchable = false;*/
			
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			
			dauberContainer = new LayoutGroup();
			dauberContainer.setSize(DAUBER_PREVIEW_WIDTH, DAUBER_PREVIEW_HEIGHT);
			
			var quad:Quad = new Quad(dauberContainer.width, dauberContainer.height, 0);
			var touchButton:Button = new Button();
			touchButton.defaultSkin = quad;
			touchButton.addEventListener(Event.TRIGGERED, onTriggered);
			touchButton.alpha = 0.0;
			touchButton.invalidate();
			touchButton.validate();
			touchButton.alignPivot();
			touchButton.x = DAUBER_PREVIEW_WIDTH / 2;
			touchButton.y = DAUBER_PREVIEW_HEIGHT / 2;
			dauberContainer.addChild(touchButton);
			
			//container.addChild(dauberContainer);
			
			//addButton('fake round 3 card', gameScreen.debugShowGame, [true, 3, 16]); 
			//addDivider();
			
			
			
			topContainer = getLayoutGroup(true, HorizontalAlign.LEFT, VerticalAlign.TOP, 15);
			container.addChild(topContainer);
			
			topContainer.addChild(dauberContainer);
			
			
			
			var selectCardDaubersEtcsControlsGroup:LayoutGroup = getLayoutGroup(false, HorizontalAlign.LEFT, VerticalAlign.TOP, 5);
			topContainer.addChild(selectCardDaubersEtcsControlsGroup);
			
			var dataProvider:ListCollection = new ListCollection();
			dataProvider.addItem({text:gameManager.skinningData.defaultDauberSkin.name, object:gameManager.skinningData.defaultDauberSkin});
			for each (var skinningDauberData:SkinningDauberData in gameManager.skinningData.customDaubers) 
			{
				dataProvider.addItem({text:skinningDauberData.name, object:skinningDauberData});
			} 
			  
			daubersPickerList = addDropdownList(selectCardDaubersEtcsControlsGroup, 'Dauber', 200*pxScale, dataProvider, callback_setDauber); 
			
			
			dataProvider = new ListCollection();
			dataProvider.addItem({text:gameManager.skinningData.defaultCardSkin.name, object:gameManager.skinningData.defaultCardSkin});
			for each (var skinningCardData:SkinningCardData in gameManager.skinningData.customCardBacks) 
			{
				dataProvider.addItem({text:skinningCardData.name, object:skinningCardData});
			} 
			  
			cardsPickerList = addDropdownList(selectCardDaubersEtcsControlsGroup, 'Card', 200*pxScale, dataProvider, callback_setCard); 
			
			
			dataProvider = new ListCollection();
			for each(var effectType:String in CellDaubEffect.typesList) 
			{
				dataProvider.addItem({text:effectType, object:effectType});
			} 
			  
			effectsPickerList = addDropdownList(selectCardDaubersEtcsControlsGroup, 'Effect', 200*pxScale, dataProvider, callback_setEffect); 
			
			
			particlesManagerContainer = getLayoutGroup(false, HorizontalAlign.LEFT, VerticalAlign.TOP, 10);
			addButton(particlesManagerContainer, 'ADD Particles', callback_buttonAddParticles, null, 0, 0);
			topContainer.addChild(particlesManagerContainer);
			
			addButton(selectCardDaubersEtcsControlsGroup, 'controls visible', function():void {
				particlesSettingsGroup.visible = !particlesSettingsGroup.visible;
			}, null, 10, 10);
			
			
			addButton(selectCardDaubersEtcsControlsGroup, 'Export XML', handler_exportXML, null, 10, 10);
			addButton(selectCardDaubersEtcsControlsGroup, 'Import XML', handler_importXML, null, 10, 10);
			
			
			addDivider();
			
			
			// settings group
			particlesSettingsGroup = getLayoutGroup(true, HorizontalAlign.LEFT, VerticalAlign.TOP, 40);
			container.addChild(particlesSettingsGroup);
			
			/*var h:int = 50
			while (--h>0){
				addSlider(container, 'speed', 186 * pxScale, 0, 15, 0.1, callback_changeProperties, null, 'speed');
			}*/
			
			
			
			addParticleExplosionControls();
			//addFFParticlesControls();
			
			
			daubersPickerList.selectedIndex = 0;
			callback_setDauber(daubersPickerList.selectedItem);
		}	
		
		private function handler_exportXML(...args):void 
		{
			var ffParticleView:FFParticlesView = particlesView ? (particlesView as FFParticlesView) : null;
			var systemOptions:SystemOptions;
			
			if (ffParticleView) {
				ffParticleView;
				systemOptions = ffParticleView.getParticleSystemByIndex(0).exportSystemOptions();
				
				var file:FileReference = new FileReference();
				file.save(systemOptions.exportConfig(), "particle" + ".xml");
			}
		}
		
		private function handler_importXML(...args):void 
		{
			var ffParticleView:FFParticlesView = particlesView ? (particlesView as FFParticlesView) : null;
			var systemOptions:SystemOptions;
			
			var fileReference:FileReference = new FileReference();
			fileReference.browse([new FileFilter("XML", "*.xml;*.pex")]);
			fileReference.addEventListener("select", onFileSelected);
	
			function onFileSelected(e:*):void {
				fileReference.addEventListener("complete", onFileLoaded);
				fileReference.load();
			}

			function onFileLoaded(e:*):void 
			{
				var xml:XML = new XML(e.target.data);
				
				if (ffParticleView) 
				{
					systemOptions = new SystemOptions(ffParticleView.getParticleSystemByIndex(0).texture, null, xml);
					
					//systemOptions.sourceX = 0;
					//systemOptions.sourceY = 0;
					//systemOptions.sourceVarianceX
					//systemOptions.sourceVarianceY
					
					ffParticleView.setProperties(systemOptions);
					setControlsFromCurrentDauber();
				}
			}	
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
				
				if(displayObject is LayoutGroup)
					(displayObject as LayoutGroup).validate();
				
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
			
			scrollContainer.height = (this.height - gameUILayoutScale * 10) / gameUILayoutScale - scrollContainer.y;
			scrollContainer.width = this.width;
			//scrollContainer.height = this.height - pxScale*10 - scrollContainer.y;
		}	
		
		override public function get baseScale():Number
		{
			return layoutHelper.independentScaleFromEtalonMin;
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
		
		
		override public function close():void
		{
			super.close();
			
			if (intervalId != -1) {
				clearInterval(intervalId);
				intervalId = -1;
			}	
		}	
		
		private function addParticleExplosionControls():void 
		{
			// main settings:
			var layoutGroup:LayoutGroup = getLayoutGroup();
			addNumericStepper(layoutGroup, 'start scale', 0.0, 4, 0.1, 60 * pxScale, callback_changeProperties, null, 'startScale');
			addNumericStepper(layoutGroup, 'speed', -8, 8, 0.1, 30 * pxScale, callback_changeProperties, null, 'speed');
			addNumericStepper(layoutGroup, 'scaleSpeed', -0.5, 0.5, 0.001, 80 * pxScale, callback_changeProperties, null, 'scaleSpeed');
			addNumericStepper(layoutGroup, 'start fade', 0.0, 1, 0.05, 60 * pxScale, callback_changeProperties, null, 'startFade');
			addNumericStepper(layoutGroup, 'fade speed', 0.0, 0.2, 0.02, 60 * pxScale, callback_changeProperties, null, 'fadeSpeed');
			addNumericStepper(layoutGroup, 'speed acceler', -1, 1, 0.01, 60 * pxScale, callback_changeProperties, null, 'speedAcceleration');
			addNumericStepper(layoutGroup, 'scale acceler', -0.1, 0.1, 0.00025, 60 * pxScale, callback_changeProperties, null, 'scaleAcceleration');
			
			addNumericStepper(layoutGroup, 'gravity', -0.3, 0.3, 0.01, 60 * pxScale, callback_changeProperties, null, 'gravityAcceleration');
			addNumericStepper(layoutGroup, 'skew amplitude', 0, 2, 0.025, 60 * pxScale, callback_changeProperties, null, 'skewAplitude');
			
			particlesSettingsGroup.addChild(layoutGroup);
			
			// emitter settings:
			layoutGroup = getLayoutGroup();
			addNumericStepper(layoutGroup, 'minEmitterRadius', 0, 300, 1, 30 * pxScale, callback_changeProperties, null, 'minEmitterRadius');
			addNumericStepper(layoutGroup, 'maxEmitterRadius', 0, 300, 1, 30 * pxScale, callback_changeProperties, null, 'maxEmitterRadius');
			
			addNumericStepper(layoutGroup, 'start particles', 0, 60, 1, 30 * pxScale, callback_changeProperties, null, 'startParticlesCount');
			addNumericStepper(layoutGroup, 'emit time', 0, 1800, 20, 30 * pxScale, callback_changeProperties, null, 'playMilliseconds');
			addNumericStepper(layoutGroup, 'max particles', 0, 60, 1, 30 * pxScale, callback_changeProperties, null, 'maxParticles');
			addNumericStepper(layoutGroup, 'emission time', 0, 500, 20, 30 * pxScale, callback_changeProperties, null, 'minEmissionTime');
			particlesSettingsGroup.addChild(layoutGroup);
			
			// rotation settings 
			layoutGroup = getLayoutGroup(false, HorizontalAlign.LEFT);
			addNumericStepper(layoutGroup, 'emitDirectionAngle', 0, 360, 1, 30 * pxScale, callback_changeProperties, null, 'emitDirectionAngle');
			addNumericStepper(layoutGroup, 'emitAngleAmplitude', 0, 360, 1, 30 * pxScale, callback_changeProperties, null, 'emitAngleAmplitude');
			
			addNumericStepper(layoutGroup, 'rotation speed', -30, +30, 1, 30 * pxScale, callback_changeProperties, null, 'rotationSpeed');
			addNumericStepper(layoutGroup, 'start angle multiplier', -3, +3, 0.005, 30 * pxScale, callback_changeProperties, null, 'startAngleMultiplier');
			addNumericStepper(layoutGroup, 'direction angle shift speed', -10, +10, 1, 30 * pxScale, callback_changeProperties, null, 'directionAngleShiftSpeed');
			addNumericStepper(layoutGroup, 'direction angle shift amplitide', -100, +100, 1, 30 * pxScale, callback_changeProperties, null, 'directionAngleShiftAmplitide');
			addNumericStepper(layoutGroup, 'direction angle speed', -10, +10, 0.005, 30 * pxScale, callback_changeProperties, null, 'directionAngleSpeed');
			particlesSettingsGroup.addChild(layoutGroup);
			
			// randomization settings 
			layoutGroup = getLayoutGroup(false, HorizontalAlign.LEFT);
			addNumericStepper(layoutGroup, 'random multiplier', -5, +5, 0.005, 30 * pxScale, callback_changeProperties, null, 'randomMultiplier');
			addNumericStepper(layoutGroup, 'fastParticlesRatio', -5, +5, 0.005, 30 * pxScale, callback_changeProperties, null, 'fastParticlesRatio');
			addNumericStepper(layoutGroup, 'fastRandomMultiplier', -10, +10, 0.005, 30 * pxScale, callback_changeProperties, null, 'fastRandomMultiplier');
			addNumericStepper(layoutGroup, 'fastRotationRatio', -10, +10, 0.005, 30 * pxScale, callback_changeProperties, null, 'fastRotationRatio');
			addNumericStepper(layoutGroup, 'fastRotationMult', -10, +10, 0.005, 30 * pxScale, callback_changeProperties, null, 'fastRotationMultiplier');
			addNumericStepper(layoutGroup, 'startScaleRandomMult', -10, +10, 0.005, 30 * pxScale, callback_changeProperties, null, 'startScaleRandomMultiplier');
			addNumericStepper(layoutGroup, 'startFadeRandomMult', -10, +10, 0.005, 30 * pxScale, callback_changeProperties, null, 'startFadeRandomMultiplier');
			addNumericStepper(layoutGroup, 'startFadeRandomMult', -10, +10, 0.005, 30 * pxScale, callback_changeProperties, null, 'startFadeRandomMultiplier');
			addNumericStepper(layoutGroup, 'dirAngleShiftAmplitRandMult', -10, +10, 0.005, 30 * pxScale, callback_changeProperties, null, 'directionAngleShiftAmplitideRandomMultiplier');
			particlesSettingsGroup.addChild(layoutGroup);
		}
		
		private function addFFParticlesControls():void 
		{
			// 
			layoutGroup = getLayoutGroup(false, HorizontalAlign.LEFT, VerticalAlign.TOP, 5);
			addDropdownList(layoutGroup, 'Emitter Type', 186, new ListCollection([{text:'Gravity', object:FFParticleSystem.EMITTER_TYPE_GRAVITY}, {text:'Radial', object:FFParticleSystem.EMITTER_TYPE_RADIAL}]), callback_changeProperties, null, 'emitterType');
			particlesSettingsGroup.addChild(layoutGroup);
			
			// main settings:
			var layoutGroup:LayoutGroup = getLayoutGroup(false, HorizontalAlign.LEFT, VerticalAlign.TOP, 5);
			addSlider(layoutGroup, 'Duration', 186, 0, 5, 0.05, callback_changeProperties, null, 'duration');
			addSlider(layoutGroup, 'Max Particles', 186, 1, 500, 1, callback_changeProperties, null, 'maxParticles');
			addSlider(layoutGroup, 'Lifespan', 186, 0, 10, 0.1, callback_changeProperties, null, 'lifespan');
			addSlider(layoutGroup, 'Lifespan Variance', 186, 0, 10, 0.1, callback_changeProperties, null, 'lifespanVariance');
			
			addSlider(layoutGroup, 'Start Size', 186, 0, 70, 0.1, callback_changeProperties, null, 'startParticleSize');
			addSlider(layoutGroup, 'Start Size Variance', 186, 0, 70, 0.1, callback_changeProperties, null, 'startParticleSizeVariance');
			addSlider(layoutGroup, 'Finish Size', 186, 0, 70, 0.1, callback_changeProperties, null, 'finishParticleSize');
			addSlider(layoutGroup, 'Finish Size Variance', 186, 0, 70, 0.1, callback_changeProperties, null, 'finishParticleSizeVariance');
			
			addSlider(layoutGroup, 'Emitter Angle', 186, 0, 360, 1, callback_changeProperties, null, 'angle');
			addSlider(layoutGroup, 'Angle Variance', 186, 0, 360, 1, callback_changeProperties, null, 'angleVariance');
			addSlider(layoutGroup, 'Start Rot.', 186, 0, 360, 1, callback_changeProperties, null, 'rotationStart');
			addSlider(layoutGroup, 'Start Rot. Var.', 186, 0, 360, 1, callback_changeProperties, null, 'rotationStartVariance');
			addSlider(layoutGroup, 'End Rot.', 186, 0, 360, 1, callback_changeProperties, null, 'rotationEnd');
			addSlider(layoutGroup, 'End Rot. Var.', 186, 0, 360, 1, callback_changeProperties, null, 'rotationEndVariance');
			
			particlesSettingsGroup.addChild(layoutGroup);
			
			// emitter settings:
			layoutGroup = getLayoutGroup(false, HorizontalAlign.LEFT, VerticalAlign.TOP, 5);
			addSlider(layoutGroup, 'X', 186, -200, 200, 1, callback_changeProperties, null, 'sourceX');
			addSlider(layoutGroup, 'Y', 186, -200, 200, 1, callback_changeProperties, null, 'sourceY');
			addSlider(layoutGroup, 'X Variance', 186, -200, 200, 1, callback_changeProperties, null, 'sourceVarianceX');
			addSlider(layoutGroup, 'Y Variance', 186, -200, 200, 1, callback_changeProperties, null, 'sourceVarianceY');
			
			addSlider(layoutGroup, 'Speed', 186, 0, 500, 1, callback_changeProperties, null, 'speed');
			addSlider(layoutGroup, 'Speed Variance', 186, 0, 500, 1, callback_changeProperties, null, 'speedVariance');
			addSlider(layoutGroup, 'Gravity X', 186, -500, 500, 1, callback_changeProperties, null, 'gravityX');
			addSlider(layoutGroup, 'Gravity Y', 186, -500, 500, 1, callback_changeProperties, null, 'gravityY');
			addSlider(layoutGroup, 'Tan. Acc.', 186, -1000, 1000, 1, callback_changeProperties, null, 'tangentialAcceleration');
			addSlider(layoutGroup, 'Tan. Acc. Var.', 186, -1000, 1000, 1, callback_changeProperties, null, 'tangentialAccelerationVariance');
			addSlider(layoutGroup, 'Radial Acc.', 186, -1000, 1000, 1, callback_changeProperties, null, 'radialAcceleration');
			addSlider(layoutGroup, 'Radial Acc. Var.', 186, -1000, 1000, 1, callback_changeProperties, null, 'radialAccelerationVariance');
			
			particlesSettingsGroup.addChild(layoutGroup);
			
			
			// rotation settings 
			layoutGroup = getLayoutGroup(false, HorizontalAlign.LEFT, VerticalAlign.TOP, 5);
			
			addSlider(layoutGroup, 'Max Radius', 186, 0, 500, 1, callback_changeProperties, null, 'maxRadius');
			addSlider(layoutGroup, 'Max Radius Variance', 186, 0, 300, 1, callback_changeProperties, null, 'maxRadiusVariance');
			addSlider(layoutGroup, 'Min Radius', 186, 0, 300, 1, callback_changeProperties, null, 'minRadius');
			addSlider(layoutGroup, 'Min Radius Variance', 186, 0, 300, 1, callback_changeProperties, null, 'minRadiusVariance');
			addSlider(layoutGroup, 'Rotate/Sec', 186, -360, 360, 1, callback_changeProperties, null, 'rotatePerSecond');
			addSlider(layoutGroup, 'Rotate/Sec Var', 186, -360, 360, 1, callback_changeProperties, null, 'rotatePerSecondVariance');
			
			particlesSettingsGroup.addChild(layoutGroup);
			
			
			
			/*	
			target.emitterType = this.emitterType;
			target.emitAngleAlignedRotation = this.emitAngleAlignedRotation;
			
			target.startColor = this.startColor;
			target.startColorVariance = this.startColorVariance;
			target.finishColor = this.finishColor;
			target.finishColorVariance = this.finishColorVariance;
			
			target.blendFuncSource = this.blendFuncSource;
			target.blendFuncDestination = this.blendFuncDestination;
			*/
			
			
			/*	
			target.isAnimated = this.isAnimated;
			target.firstFrameName = this.firstFrameName;
			target.firstFrame = this.firstFrame;
			target.lastFrameName = this.lastFrameName;
			target.lastFrame = this.lastFrame;
			target.lastFrame = this.lastFrame;
			target.loops = this.loops;
			target.randomStartFrames = this.randomStartFrames;
			
			target.tinted = this.tinted;
			target.spawnTime = this.spawnTime;
			target.fadeInTime = this.fadeInTime;
			target.fadeOutTime = this.fadeOutTime;
			target.excactBounds = this.excactBounds;
			
			*/
			
			
			
			
			
			
			
		}
		
		/*********************************************************************************************************************
		*
		* Button, Divider, Label, LayoutGroup
		* 
		*********************************************************************************************************************/		
		
		private function addButton(controlContainer:DisplayObjectContainer, label:String, callback:Function, callbackParams:Array = null, paddingHorisontal:uint = 10, paddingVertical:uint = 10, id:String = null):void 
		{
			var button:Button = new Button();
			button.useHandCursor = true;
			button.addEventListener(Event.TRIGGERED, callback_button);
			button.label = label;
			button.labelFactory = labelTextFactory;
			button.defaultSkin = new Image(Texture.fromColor(50*pxScale, CONTROLS_HEIGHT_MAX, BUTTONS_COLOR));
			
			button.paddingLeft = paddingHorisontal*pxScale;
			button.paddingRight = paddingHorisontal*pxScale;
			button.paddingTop = paddingVertical*pxScale;
			button.paddingBottom = paddingVertical*pxScale;
			controlContainer.addChild(button);
			
			button.validate();
			
			if(!callbackParams)
				callbackParams = [];
				
			callbackParams.unshift(callback);
			buttonCallbacksDictionary[button] = callbackParams;
			
			if(id)
				objectsById[id] = button;
		}
		
		private function callback_button(event:Event):void
		{
			var params:Array = buttonCallbacksDictionary[event.target];
			var callback:Function = params[0] as Function;
			if(callback)
				callback.apply(null, params.length > 1 ? params.slice(1, params.length) : null);
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
			var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
			textRenderer.textFormat = new BitmapFontTextFormat(BitmapFont.MINI, 11);
			return textRenderer;
			
			/*var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
			textRenderer.textFormat = new flash.text.TextFormat(Fonts.CHATEAU_DE_GARAGE, 14*pxScale, 0xffffff);
			textRenderer.embedFonts = true;
			return textRenderer;*/
		}
		
		private function addDivider():void 
		{
			var quad:Quad = new Quad(1, 1);
			quad.width = backgroundWidth - 50*pxScale;
			container.addChild(quad);
		}
		
		
		private function getLayoutGroup(horisontal:Boolean = false, hAlign:String = "left", vAlign:String = "middle", gap:Number = 0):LayoutGroup
		{
			var layoutGroup:LayoutGroup = new LayoutGroup();
			
			if (horisontal) 
			{
				var hLayout:HorizontalLayout = new HorizontalLayout();
				hLayout.horizontalAlign = hAlign;
				hLayout.verticalAlign = vAlign;
				hLayout.gap = gap;
				layoutGroup.layout = hLayout;
			}
			else {
				var vLayout:VerticalLayout = new VerticalLayout();
				vLayout.horizontalAlign = hAlign;
				vLayout.verticalAlign = vAlign;
				vLayout.gap = gap;
				layoutGroup.layout = vLayout;
			}
			
			return layoutGroup;
		}
		
		/*********************************************************************************************************************
		*
		* Slider
		* 
		*********************************************************************************************************************/		
			
		private function addSlider(controlContainer:DisplayObjectContainer, text:String, viewWidth:int, min:Number, max:Number, step:Number, callback:Function = null, callbackParams:Array = null, id:String = null, thumbCallback:Function = null):void 
		{
			var color:uint = buttonColors[buttonColorIndex++];
			var viewHeight:int = 16 * pxScale;
			var viewY:int = 13 * pxScale;
			var paddingHorisontal:int = 7 * pxScale;
			
			var sliderContainer:SliderContainer = new SliderContainer();
			//sliderContainer.name = id;
			controlContainer.addChild(sliderContainer);
			
			sliderContainer.buttonMinus = new Button();
			sliderContainer.buttonMinus.useHandCursor = true;
			sliderContainer.buttonMinus.addEventListener(Event.TRIGGERED, function(e:Event):void {sliderContainer.slider.value = Math.max(sliderContainer.slider.value - step, min); });
			sliderContainer.buttonMinus.label = '-';
			sliderContainer.buttonMinus.y = viewY;
			sliderContainer.buttonMinus.labelFactory = labelTextFactory;
			sliderContainer.buttonMinus.defaultSkin = new Quad(viewHeight, viewHeight, BUTTONS_COLOR);//new Image(buttonCommonTexture/*Texture.fromColor(viewHeight, viewHeight, color)*/);
			sliderContainer.addChild(sliderContainer.buttonMinus);
			
			sliderContainer.buttonPlus = new Button();
			sliderContainer.buttonPlus.useHandCursor = true;
			sliderContainer.buttonPlus.addEventListener(Event.TRIGGERED, function(e:Event):void {sliderContainer.slider.value = Math.min(sliderContainer.slider.value + step, max); });
			sliderContainer.buttonPlus.label = '+';
			sliderContainer.buttonPlus.x = viewWidth - viewHeight;
			sliderContainer.buttonPlus.y = viewY;
			sliderContainer.buttonPlus.labelFactory = labelTextFactory;
			sliderContainer.buttonPlus.defaultSkin = new Quad(viewHeight, viewHeight, BUTTONS_COLOR)//new Image(buttonCommonTexture);//Texture.fromColor(viewHeight, viewHeight, color));
			sliderContainer.addChild(sliderContainer.buttonPlus);
			
			sliderContainer.label = new Label();
			sliderContainer.label.textRendererFactory = labelTextFactory;
			sliderContainer.label.touchable = false;
			sliderContainer.label.text = text;
			sliderContainer.label.name = text;
			sliderContainer.label.validate();
			//sliderContainer.label.y = 3*pxScale;
			sliderContainer.addChild(sliderContainer.label);
			
			sliderContainer.slider = new Slider();
			sliderContainer.slider.x = viewHeight + paddingHorisontal;
			sliderContainer.slider.y = viewY;
			sliderContainer.slider.minimum = min;
			sliderContainer.slider.maximum = max;
			sliderContainer.slider.value = (max - min)/2;
			sliderContainer.slider.step = step;
			sliderContainer.slider.direction = Direction.HORIZONTAL;

			sliderContainer.slider.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(viewHeight, viewHeight , 0x555555);
				thumb.addEventListener(Event.TRIGGERED, function(e:Event):void { if(thumbCallback != null) thumbCallback() });
				return thumb;
			};
			
			sliderContainer.slider.minimumTrackFactory  = function():BasicButton
			{
				var track:BasicButton = new BasicButton();
				track.defaultSkin = new Quad(viewWidth - 2 * paddingHorisontal - 2 * viewHeight, viewHeight, 0x333333);
				track.defaultSkin.alpha = 1;
				return track;
			};
			
			sliderContainer.slider.addEventListener(Event.CHANGE, function slider_changeHandler1( event:Event ):void
			{
				sliderContainer.label.text = sliderContainer.label.name + ' ' + sliderContainer.slider.value.toString();
				if(controlsChangeHandlersEnabled && callback != null)
					callback.apply(null, (callbackParams || []).concat(sliderContainer.slider.value));
			});
			
			sliderContainer.slider.validate();
			sliderContainer.addChild(sliderContainer.slider);
			
			
			if(id)
				objectsById[id] = sliderContainer;
		}
		
		private function setSliderByContainer(sliderContainer:SliderContainer, value:Number):void
		{
			if (!sliderContainer)
				return;
			sliderContainer.label.text = sliderContainer.label.name + " " + value.toString();
			sliderContainer.slider.value = value;
		}	
		
		/*********************************************************************************************************************
		*
		* Numeric stepper
		* 
		*********************************************************************************************************************/		
		
		private function addNumericStepper(controlContainer:DisplayObjectContainer, text:String, min:Number, max:Number, step:Number, textBgWidth:int = 30, callback:Function = null, callbackParams:Array = null, id:String = null):void 
		{
			var color:uint = buttonColors[buttonColorIndex++];
			
			var contentContainer:LayoutGroup = new LayoutGroup();
			//sliderContainer.name = id;
			controlContainer.addChild(contentContainer);
			
			var label:Label = new Label();
			label.textRendererFactory = labelTextFactory;
			label.text = text;
			label.name = text;
			label.validate();
			label.x = 0;//((80 * pxScale + textBgWidth) - label.width)/2;
			label.y = 3*pxScale;
			contentContainer.addChild(label);
			
			var numericStepper:NumericStepper = new NumericStepper();
			numericStepper.y = label.height + 5 * pxScale;
			numericStepper.minimum = min;
			numericStepper.maximum = max;
			numericStepper.value = (max - min)/2;
			numericStepper.step = step;
			
			numericStepper.textInputGap = 10;
			
			numericStepper.decrementButtonFactory = function():Button
			{
				var thumb:Button = new Button();
				thumb.defaultSkin = new Quad(30 * pxScale, 30 * pxScale , color);
				//thumb.addEventListener(Event.TRIGGERED, function(e:Event):void { if(thumbCallback != null) thumbCallback() });
				return thumb;
			};
			
			numericStepper.decrementButtonLabel = '-';
			
			numericStepper.incrementButtonFactory = function():Button
			{
				var thumb:Button = new Button();
				thumb.defaultSkin = new Quad(30 * pxScale, 30 * pxScale , color);
				//thumb.addEventListener(Event.TRIGGERED, function(e:Event):void { if(thumbCallback != null) thumbCallback() });
				return thumb;
			};
			
			numericStepper.incrementButtonLabel = '+';
			
			numericStepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				
				var fontStyle:FontStylesSet = new FontStylesSet();
				fontStyle.format = new starling.text.TextFormat(BitmapFont.MINI/*Fonts.CHATEAU_DE_GARAGE*/, 20, 0xFFFFFF);
				
				/*var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
				textRenderer.textFormat = new BitmapFontTextFormat(BitmapFont.MINI, 14);
				return textRenderer;*/
				
				
				var bg:Quad = new Quad(textBgWidth, 30, color);
				bg.alpha = 0.4;
				
				input.backgroundSkin = bg;
				input.padding = 0;
				input.textEditorProperties = {fontStyles:fontStyle};
				input.isEditable = false;
				
				return input;
			}
			
			numericStepper.addEventListener(Event.CHANGE, function hanlder_change( event:Event ):void
			{
				//label.text = label.name + ' ' + slider.value.toString();
				if (controlsChangeHandlersEnabled && callback != null)
					callback.apply(null, (callbackParams || []).concat(numericStepper.value));
			});
			
			numericStepper.validate();
			contentContainer.addChild(numericStepper);
			
			if(id)
				objectsById[id] = numericStepper;
		}
		
		/*********************************************************************************************************************
		*
		* Dropdown list
		* 
		*********************************************************************************************************************/		
		 
		private function addDropdownList(controlContainer:DisplayObjectContainer, text:String, viewWidth:int, itemsList:ListCollection, callback:Function = null, callbackParams:Array = null, id:String = null):PickerList 
		{
			var color:uint = buttonColors[buttonColorIndex++];
			
			var contentContainer:DropDownListContainer = new DropDownListContainer();
			//sliderContainer.name = id;
			controlContainer.addChild(contentContainer);
			
			contentContainer.label = new Label();
			contentContainer.label.textRendererFactory = labelTextFactory;
			contentContainer.label.width = viewWidth;
			contentContainer.label.text = text;
			contentContainer.label.name = text;
			contentContainer.label.validate();
			contentContainer.label.y = 3*pxScale;
			contentContainer.addChild(contentContainer.label);
			
			contentContainer.pickerList = new PickerList();
			contentContainer.pickerList.y = contentContainer.label.height + 5 * pxScale;
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
			
			contentContainer.pickerList.buttonFactory = function():Button
			{
				var button:Button = new Button();
				button.labelFactory = function labelTextFactory():ITextRenderer
				{
					var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
					textRenderer.textFormat = new flash.text.TextFormat(Fonts.CHATEAU_DE_GARAGE, 12*pxScale, 0xffffff);
					textRenderer.embedFonts = true;
					return textRenderer;
				}
				button.defaultSkin = new Quad(viewWidth * pxScale, CONTROLS_HEIGHT, BUTTONS_COLOR);
				button.addEventListener(Event.TRIGGERED, function(e:Event):void {  });

				return button;
			};
			
			contentContainer.pickerList.labelFunction = function( item:Object ):String
			{
				return item.text;
			}
			
			contentContainer.pickerList.listFactory = function():List
			{
				var popUpList:List = new List();
				popUpList.itemRendererFactory = function():IListItemRenderer
				{
					var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
					renderer.labelField = "text";
					
					renderer.defaultSkin = new Quad(viewWidth * pxScale, 20 * pxScale , BUTTONS_COLOR);
					
					renderer.labelFactory = function labelTextFactory():ITextRenderer
					{
						var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
						textRenderer.textFormat = new flash.text.TextFormat(Fonts.CHATEAU_DE_GARAGE, 12*pxScale, 0xFFFFFF);
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
				if(controlsChangeHandlersEnabled && callback != null)
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
		
		private function refreshVolumeSliders():void
		{
			//setSliderByContainer(objectsById['sliderMain'], Math.round(SoundManager.BACKGROUND_VOLUME * 100));
			
		}
		
		private function callback_setDauber(value:*):void
		{
			var dauber:SkinningDauberData = (value && value.object) ? (value.object as SkinningDauberData) : null;
			if (dauber) 
			{
				gameManager.skinningData.loadDauberSkin(dauber.id);
				skinningDauberData = dauber;
			}
		}
		
		private function callback_setCard(value:*):void
		{
			var card:SkinningCardData = (value && value.object) ? (value.object as SkinningCardData) : null;
			if (card) 
			{
				gameManager.skinningData.loadCardSkin(card.id);
				//skinningCardData = card;
			}
		}
		
		private function callback_setEffect(value:*):void
		{
			var effect:String = (value && value.object) ? (value.object as String) : null;
			if (effect != null && effect != '' && effect != daubEffectType) 
			{
				daubEffectType = effect;
				removeParticlesView();
			}
		}
		
		private function callback_buttonAddParticles(...args):void
		{
			var fileReferenceList:FileReferenceList = new FileReferenceList();
			fileReferenceList.browse([new FileFilter("Images", "*.jpg;*.png")]);
			fileReferenceList.addEventListener("select", onFileSelected);
			
			/*var fileReference:FileReference = new FileReference();
			//fileReference.browse([new FileFilter("Images", "*.jpg;*.png")]);
			fileReference.addEventListener("select", onFileSelected);
	
			function onFileSelected(e:*):void {
				fileReference.addEventListener("complete", onFileLoaded);
				fileReference.load();
			}*/

			function onFileSelected(e:*):void {
				fileReferenceList.addEventListener("complete", onFileLoaded);
				while (fileReferenceList.fileList.length > 0) {
					var fileReference:FileReference = fileReferenceList.fileList.shift() as FileReference
					fileReference.addEventListener("complete", onFileLoaded);
					fileReference.load();
				}
			}
			
			function onFileLoaded(e:*):void 
			{
				var loader:Loader = new Loader();
				var particlePreviewRenderer:ParticlePreviewRenderer;
				loader.contentLoaderInfo.addEventListener("complete", function(e:*):void 
				{  
					particlePreviewRenderer = new ParticlePreviewRenderer(Texture.fromBitmapData((loader.content as Bitmap).bitmapData), removeParticlesView, callback_removeParticleRenderer, callback_dublicateParticleRenderer);
					particleRenderers.push(particlePreviewRenderer);
					refreshParticlesContainer();
					
					removeParticlesView();
				} );
				
				loader.loadBytes(e.target.data as ByteArray);
			}	
			
			removeParticlesView();
		}
		
		public function refreshParticlesContainer():void 
		{
			var i:int = 0;
			var index:int;
			var particlePreviewRenderer:ParticlePreviewRenderer;
			
			while (i < particlesManagerContainer.numChildren)
			{
				particlePreviewRenderer = particlesManagerContainer.getChildAt(i) as ParticlePreviewRenderer;
				if (particlePreviewRenderer) {
					index = particleRenderers.indexOf(particlePreviewRenderer);
					if (index == -1) {
						particlesManagerContainer.removeChildAt(i);
					}
					else {
						i++;
					}
				}
				else {
					i++;
				}
			}
	
			i = 0;
			while (i < particleRenderers.length)
			{
				if (i <= (particlesManagerContainer.numChildren-1)) 
				{
					particlePreviewRenderer = particlesManagerContainer.addChild(particleRenderers[i]) as ParticlePreviewRenderer;
				}
				else
				{
					particlePreviewRenderer = particlesManagerContainer.getChildAt(i+1) as ParticlePreviewRenderer;
				}
				
				i++;
			}
			
			particlesManagerContainer.invalidate();
			particlesManagerContainer.validate();
		}
		
		public function getParticlesTexture():AlisaParticleItem {
			return particleRenderers[Math.floor(particleRenderers.length * Math.random())].getParticle();
		}
		
		private function callback_removeParticleRenderer(particleRenderer:ParticlePreviewRenderer):void
		{
			var index:int = particleRenderers.indexOf(particleRenderer);
			if (index != -1)
				particleRenderers.splice(index, 1);
			
			refreshParticlesContainer();
		}
		
		private function callback_dublicateParticleRenderer(particleRenderer:ParticlePreviewRenderer):void
		{
			var index:int = particleRenderers.indexOf(particleRenderer);
			if (index != -1) 
			{
				particleRenderers.splice(index + 1, 0, particleRenderer.clone());
			}
			
			refreshParticlesContainer();
		}
		
		
		/*********************************************************************************************************************
		*
		* 
		* 
		*********************************************************************************************************************/		
		
		private function setControlsFromCurrentDauber():void
		{
			var particleExplosion:ParticleExplosion = particlesView ? (particlesView as ParticleExplosion) : null;
			var ffParticleView:FFParticlesView = particlesView ? (particlesView as FFParticlesView) : null;
			
			var settingsObject:Object;
			
			if (particleExplosion)
				settingsObject = particleExplosion as Object;
			else if(ffParticleView)
				settingsObject = ffParticleView.getParticleSystemByIndex(0).exportSystemOptions() as Object;
				 
			controlsChangeHandlersEnabled = false;
			
			var key:String;
			var control:Object;
			var value:Number;
			for (key in objectsById) 
			{
				control = objectsById[key];
			
				if (key in settingsObject)
				{
					value = parseFloat(settingsObject[key]);
					
					if (control is NumericStepper) {
						(control as NumericStepper).value = value;
					}
					else if (control is SliderContainer) {
						(control as SliderContainer).slider.value = value;
						//(control as SliderContainer).label.text = ;
					}
					else if (control is DropDownListContainer) 
					{
						//(control as DropDownListContainer).pickerList.value = value;
						
					}
				}
			}
			
			// потому что фидерс - дебил, отправляет ченджи на внешние сеты собственных value
			controlsChangeHandlersEnabled = true;
		}
		
		private function setEffectFromCurrentControls():void
		{
			var particleExplosion:ParticleExplosion = particlesView ? (particlesView as ParticleExplosion) : null;
			var ffParticleView:FFParticlesView = particlesView ? (particlesView as FFParticlesView) : null;
			var systemOptions:SystemOptions;
			
			if (particleExplosion)  {
				particleExplosion.cleanParticlesPool();
			}	
			else if (ffParticleView) {
				ffParticleView.stop();
				systemOptions = ffParticleView.getParticleSystemByIndex(0).exportSystemOptions();
			}
			
			var propertiesRaw:Object = {};
				
			var key:String;
			var control:Object;
			var value:*;
			for (key in objectsById) 
			{
				control = objectsById[key];
			
				if (control is NumericStepper) {
					value = (control as NumericStepper).value;
				}
				else if (control is SliderContainer) {
					value = (control as SliderContainer).slider.value;
				}
				else if (control is DropDownListContainer) {
					value = ((control as DropDownListContainer).pickerList.selectedItem as Object).object;
				}
				
				if (particleExplosion && key in (particleExplosion as Object))
				{
					//trace('set ', key, value);
					(particleExplosion as Object)[key] = value;
				}
				else if (systemOptions && key in systemOptions) 
				{
					systemOptions[key] = value;
				}
			}
			
			if (ffParticleView)
				ffParticleView.setProperties(systemOptions);
		}
		
		private function callback_changeProperties(...args):void 
		{
			setEffectFromCurrentControls();
		}
		
		
		
		/*********************************************************************************************************************
		*
		* 
		* 
		*********************************************************************************************************************/		
		
		public function set skinningDauberData(value:SkinningDauberData):void 
		{
			if (_skinningDauberData == value)
				return;
			
			if (intervalId != -1)
				clearInterval(intervalId);	
				
			removeParticlesView();

			if (dauberImage)
				Starling.juggler.removeTweens(dauberImage);
				
			if (_skinningDauberData)
				_skinningDauberData.removeEventListener(CustomizerItemBase.EVENT_RESOURCES_LOADED, handler_loaded);
			
			_skinningDauberData = value;
			
			if (_skinningDauberData) {
				daubEffectType = _skinningDauberData.particleAnimation;
				_skinningDauberData.addEventListener(CustomizerItemBase.EVENT_RESOURCES_LOADED, handler_loaded);
			}
				
			handler_loaded(null);	
		}
		
		private function handler_loaded(event:Event):void 
		{
			if (_skinningDauberData) {
				if (_skinningDauberData.isLoaded)
					createView();
			}
			else {
			
			}
		}
		
		private function createView():void 
		{
			if (!dauberImage) {
				dauberImage = new Image(_skinningDauberData.atlas.getTexture("magicdaub"));
				dauberImage.alignPivot();
				//dauberImage.alpha = 0.3;
				dauberImage.touchable = false;
				dauberImage.x = DAUBER_PREVIEW_WIDTH/2;
				dauberImage.y = DAUBER_PREVIEW_HEIGHT/2;
				dauberContainer.addChild(dauberImage);
			}
			else {
				Starling.juggler.removeTweens(dauberImage);
				dauberImage.texture = _skinningDauberData.atlas.getTexture("magicdaub");
			}
			
			animate();
			
			if (intervalId != -1) {
				clearInterval(intervalId);
				intervalId = -1;
			}
			
			//intervalId = setInterval(animate, 2000);
		}
		
		public function animate():void 
		{
			dauberImage.scaleX = 0;
			dauberImage.scaleY = 0.68;
				
			var tween_0:Tween = new Tween(dauberImage, 0.09, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(dauberImage, 0.07, Transitions.EASE_IN);
			var tween_2:Tween = new Tween(dauberImage, 0.06, Transitions.EASE_IN);
			var tween_3:Tween = new Tween(dauberImage, 0.46, Transitions.EASE_OUT_ELASTIC);
			
			//tween_0.delay = nextDelay * i;
			tween_0.animate('scaleX', 1.82);
			tween_0.animate('scaleY', 1.32);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', 0.87);
			tween_1.animate('scaleY', 1.36);
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scaleX', 1.22);
			tween_2.animate('scaleY', 0.81);
			tween_2.nextTween = tween_3;
			
			tween_3.animate('scaleX', 1);
			tween_3.animate('scaleY', 1);
			
			//tween_2.onComplete = animateParticles;
			
			Starling.juggler.add(tween_0);
			
			
			animateParticles();
		}
		
		public function clean():void 
		{
			if (intervalId != -1) {
				clearInterval(intervalId);
				intervalId = -1;
			}
			
			if(dauberImage)
				Starling.juggler.removeTweens(dauberImage);
			
			removeParticlesView();
			
			if (_skinningDauberData)
				_skinningDauberData.removeEventListener(CustomizerItemBase.EVENT_RESOURCES_LOADED, handler_loaded);
		}
		
		private function animateParticles():void
		{
			if (_skinningDauberData && _skinningDauberData.atlas) 
			{
				if (!particlesView) 
				{
					particlesView = CellDaubEffect.show(dauberContainer, _skinningDauberData.atlas, _skinningDauberData.getParticlesTextureNames(false), daubEffectType, 0, 0, null, (particleRenderers.length > 0 ? getParticlesTexture : null), [DefaultFFParticleXML1.xml], false);
					particlesView.x = DAUBER_PREVIEW_WIDTH/2;
					particlesView.y = 700//DAUBER_PREVIEW_HEIGHT/2;
					particlesView.touchable = false;
					
					setControlsFromCurrentDauber();
					
					CellDaubEffect.play(particlesView);
				}
				
				CellDaubEffect.play(particlesView);
			}
			else {
				
			}
		}
		
		private function removeParticlesView():void
		{
			if (particlesView) {
				CellDaubEffect.stop(particlesView);
				particlesView.removeFromParent();
				particlesView = null;
			}	
		}
		
		
		private function onTriggered(event:Event):void
		{
			if (_skinningDauberData && _skinningDauberData.isLoaded) 
				animate();
		}
		
		
	}

}
import com.alisacasino.bingo.assets.Fonts;
import com.alisacasino.bingo.components.effects.AlisaParticleItem;
import feathers.controls.BasicButton;
import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.controls.PickerList;
import feathers.controls.Slider;
import feathers.controls.TextInput;
import feathers.controls.text.TextFieldTextRenderer;
import feathers.core.ITextRenderer;
import feathers.events.FeathersEventType;
import feathers.text.FontStylesSet;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import flash.text.TextFormat;
import starling.text.TextFormat;
import starling.textures.Texture;

final class SliderContainer extends Sprite {
	public var label:Label;
	public var slider:Slider;
	public var buttonMinus:Button;
	public var buttonPlus:Button;
}

final class DropDownListContainer extends Sprite {
	public var label:Label;
	public var pickerList:PickerList;
}

final class ParticlePreviewRenderer extends Sprite//LayoutGroup 
{
	private var refreshCallback:Function;
	private var removeCallback:Function;
	private var dublicateCallback:Function;
	
	public function ParticlePreviewRenderer(texture:Texture, refreshCallback:Function, removeCallback:Function, dublicateCallback:Function):void 
	{
		this.texture = texture;
		this.refreshCallback = refreshCallback;
		this.removeCallback = removeCallback;
		this.dublicateCallback = dublicateCallback;
		
		image = new Image(texture);
		image.scale = Math.min(1, 40 / image.height);
		image.x = 40;
		addChild(image);
		
		
		textInput = new TextInput();
		var fontStyle:FontStylesSet = new FontStylesSet();
		fontStyle.format = new starling.text.TextFormat(Fonts.CHATEAU_DE_GARAGE, 16, 0xFFFFFF);
		
		var bg:Quad = new Quad(80, 30, 0x101010);
		bg.alpha = 0.4;
		textInput.addEventListener( Event.CHANGE, input_changeHandler );
		textInput.backgroundSkin = bg;
		textInput.padding = 0;
		textInput.textEditorProperties = {fontStyles:fontStyle};
		textInput.isEditable = true;
		textInput.maxChars = 8;
		textInput.restrict = "0-9,A,B,C,D,E,F,a,b,c,d,e,f,x,X,#";
		textInput.x = 90;
		textInput.text = '0xFFFFFF';
		addChild(textInput);
		
		textInput.addEventListener(FeathersEventType.FOCUS_IN, input_focusInHandler );
		textInput.addEventListener(FeathersEventType.FOCUS_OUT, input_focusOutHandler );
		
		
		var removeButton:Button = new Button();
		removeButton.defaultSkin = new Quad(30 * pxScale, 30 * pxScale , 0xFF0202);
		removeButton.addEventListener(Event.TRIGGERED, handler_remove);
		removeButton.x = 0;
		addChild(removeButton);
		removeButton.labelFactory = function labelTextFactory():ITextRenderer {
			var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
			textRenderer.textFormat = new flash.text.TextFormat(Fonts.CHATEAU_DE_GARAGE, 16*pxScale, 0xffffff);
			textRenderer.embedFonts = true;
			textRenderer.text = '-';
			return textRenderer;
		}
		
		var dublicateButton:Button = new Button();
		dublicateButton.defaultSkin = new Quad(30 * pxScale, 30 * pxScale , 0x10FF10);
		dublicateButton.addEventListener(Event.TRIGGERED, handler_dublicate);
		dublicateButton.x = 175;
		addChild(dublicateButton);
		dublicateButton.labelFactory = function labelTextFactory():ITextRenderer {
			var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
			textRenderer.textFormat = new flash.text.TextFormat(Fonts.CHATEAU_DE_GARAGE, 16*pxScale, 0xffffff);
			textRenderer.embedFonts = true;
			textRenderer.text = '+';
			return textRenderer;
		}
		
		//	setSize(110, 30);
	}
	
	private function handler_remove(e:Event):void 
	{
		removeCallback(this);
	}
	
	private function handler_dublicate(e:Event):void 
	{
		dublicateCallback(this);
	}
	
	private function input_focusInHandler(e:Event):void 
	{
		if (textInput.text.toLowerCase().indexOf('ffffff') != -1) {
			textInput.text = '';
		}
	}

	private function input_focusOutHandler(e:Event):void 
	{
		if (textInput.text.length <= 2)
		{
			textInput.text = '0xFFFFFF';
		}
		else {
			
		}
		
		image.color = color;
	}

	private function input_changeHandler(e:Event):void 
	{
		var text:String = textInput.text;
		text = text.replace('0x', '').replace('0X', '').replace('0#', '');
		
		color = parseInt(text, 16);
		
		if (refreshCallback != null)
			refreshCallback();
	}
	
	public function getParticle():AlisaParticleItem {
		return new AlisaParticleItem(texture, color);
	}
	
	public function clone():ParticlePreviewRenderer 
	{
		var item:ParticlePreviewRenderer = new ParticlePreviewRenderer(texture, refreshCallback, removeCallback, dublicateCallback);
		item.color = color;
		item.x2Color = x2Color;
		return item;
	}
	
	public var texture:Texture;
	public var color:uint = 0xFFFFFF;
	public var x2Color:uint;
	public var label:Label;
	public var image:Image;
	
	public var textInput:TextInput;
	
}

class DefaultFFParticleXML 
{
	public static var xml:XML = 
	 
		<particleEmitterConfig>
		  /*<texture name="particle_0"/>*/
		  <sourcePosition x="0.00" y="0.00"/>
		  <sourcePositionVariance x="0.00" y="0.00"/>
		  <speed value="30.00"/>
		  <speedVariance value="10.00"/>
		  <particleLifeSpan value="2.0000"/>
		  <particleLifespanVariance value="1.9000"/>
		  <angle value="360"/>
		  <angleVariance value="360"/>
		  <gravity x="0" y="0"/>
		  <radialAcceleration value="5.88"/>
		  <tangentialAcceleration value="0"/>
		  <radialAccelVariance value="0"/>
		  <tangentialAccelVariance value="0"/>
		  <startColor red="1" green="1" blue="1" alpha="1"/>
		  <startColorVariance red="0.00" green="0.00" blue="0.00" alpha="1.00"/>
		  <finishColor red="1" green="0" blue="0.00" alpha="1.00"/>
		  <finishColorVariance red="0.00" green="0.00" blue="0.00" alpha="1.00"/>
		  <maxParticles value="44.34"/>
		  <startParticleSize value="30.36"/>
		  <startParticleSizeVariance value="3.2600000000000002"/>
		  <finishParticleSize value="10.00"/>
		  <FinishParticleSizeVariance value="5.00"/>
		  <duration value="0.20"/>
		  <emitterType value="0"/>
		  <maxRadius value="100.00"/>
		  <maxRadiusVariance value="0"/>
		  <minRadius value="0.00"/>
		  <minRadiusVariance value="0.00"/>
		  <rotatePerSecond value="0.00"/>
		  <rotatePerSecondVariance value="0.00"/>
		  <blendFuncSource value="1"/>
		  <blendFuncDestination value="1"/>
		  <rotationStart value="0"/>
		  <rotationStartVariance value="0"/>
		  <rotationEnd value="0.00"/>
		  <rotationEndVariance value="0.00"/>
		</particleEmitterConfig>
	
}

class DefaultFFParticleXML1 
{
	public static var xml:XML = 
	 
		<particleEmitterConfig>
		  /*<texture name="particle_0"/>*/
		  <sourcePosition x="0.00" y="0.00"/>
		  <sourcePositionVariance x="0.00" y="0.00"/>
		  <speed value="30.00"/>
		  <speedVariance value="10.00"/>
		  <particleLifeSpan value="2.0000"/>
		  <particleLifespanVariance value="1.9000"/>
		  <angle value="360"/>
		  <angleVariance value="360"/>
		  <gravity x="0" y="0"/>
		  <radialAcceleration value="5.88"/>
		  <tangentialAcceleration value="0"/>
		  <radialAccelVariance value="0"/>
		  <tangentialAccelVariance value="0"/>
		  <startColor red="1" green="1" blue="1" alpha="1"/>
		  <startColorVariance red="0.00" green="0.00" blue="0.00" alpha="0.00"/>
		  <finishColor red="1" green="1" blue="1.00" alpha="1.00"/>
		  <finishColorVariance red="0.00" green="0.00" blue="0.00" alpha="0.00"/>
		  <maxParticles value="44.34"/>
		  <startParticleSize value="30.36"/>
		  <startParticleSizeVariance value="3.2600000000000002"/>
		  <finishParticleSize value="10.00"/>
		  <FinishParticleSizeVariance value="5.00"/>
		  <duration value="0.20"/>
		  <emitterType value="0"/>
		  <maxRadius value="100.00"/>
		  <maxRadiusVariance value="0"/>
		  <minRadius value="0.00"/>
		  <minRadiusVariance value="0.00"/>
		  <rotatePerSecond value="0.00"/>
		  <rotatePerSecondVariance value="0.00"/>
		  <blendFuncSource value="1"/>
		  <blendFuncDestination value="771"/>
		  <rotationStart value="0"/>
		  <rotationStartVariance value="0"/>
		  <rotationEnd value="0.00"/>
		  <rotationEndVariance value="0.00"/>
		</particleEmitterConfig>
	
}