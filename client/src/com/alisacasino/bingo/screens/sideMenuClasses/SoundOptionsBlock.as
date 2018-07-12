package com.alisacasino.bingo.screens.sideMenuClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.FullscreenButton;
	import com.alisacasino.bingo.models.skinning.SkinningData;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAUIInteractionEvent;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ToggleButton;
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalAlign;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SoundOptionsBlock extends FeathersControl
	{
		public function SoundOptionsBlock() 
		{
			
		}
		
		private var buttonsGroup:LayoutGroup;
		
		override protected function initialize():void 
		{
			super.initialize();
			
			var buttonsScale:Number = PlatformServices.isCanvas && Settings.instance.snowEnabled ? 0.9 : 1;
			
			var backgroundQuad:Quad = new Quad(852 * pxScale, 99 * pxScale, 0x0);
			backgroundQuad.alpha = 0.6;
			backgroundQuad.x = -400 * pxScale;
			addChild(backgroundQuad);
			
			var separatorLine:Quad = new Quad(852 * pxScale, 2 * pxScale, 0xcccccc);
			separatorLine.x = -400 * pxScale;
			separatorLine.y = backgroundQuad.height;
			separatorLine.alpha = 0.6;
			addChild(separatorLine);
			
			buttonsGroup = new LayoutGroup();
			addChild(buttonsGroup);
			var buttonsLayout:HorizontalLayout = new HorizontalLayout();
			buttonsLayout.horizontalAlign = HorizontalAlign.CENTER;
			buttonsLayout.gap = 72 * pxScale;
			buttonsLayout.verticalAlign = VerticalAlign.MIDDLE;
			
			buttonsGroup.layout = buttonsLayout;
			buttonsGroup.setSize(452 * pxScale, 98 * pxScale);
			
			var toggleMusicButton:ToggleButton = new ToggleButton();
			toggleMusicButton.useHandCursor = true;
			toggleMusicButton.defaultSkin = new Image(AtlasAsset.CommonAtlas.getTexture("side_menu/music_icon"));
			toggleMusicButton.defaultSkin.alpha = 0.5;
			toggleMusicButton.defaultSelectedSkin = new Image(AtlasAsset.CommonAtlas.getTexture("side_menu/music_icon"));
			toggleMusicButton.isSelected = SoundManager.instance.backgroundMusicEnabled;
			toggleMusicButton.addEventListener(Event.CHANGE, toggleMusicButton_changeHandler);
			toggleMusicButton.scale = buttonsScale;
			buttonsGroup.addChild(toggleMusicButton);
			
			var toggleSoundButton:ToggleButton = new ToggleButton();
			toggleSoundButton.useHandCursor = true;
			toggleSoundButton.defaultSkin = new Image(AtlasAsset.CommonAtlas.getTexture("side_menu/sound_icon"));
			toggleSoundButton.defaultSkin.alpha = 0.5;
			toggleSoundButton.defaultSelectedSkin = new Image(AtlasAsset.CommonAtlas.getTexture("side_menu/sound_icon"));
			toggleSoundButton.isSelected = SoundManager.instance.sfxEnabled;
			toggleSoundButton.addEventListener(Event.CHANGE, toggleSoundButton_changeHandler);
			toggleSoundButton.scale = buttonsScale;
			buttonsGroup.addChild(toggleSoundButton);
			
			var toggleVoiceButton:ToggleButton = new ToggleButton();
			toggleVoiceButton.useHandCursor = true;
			toggleVoiceButton.defaultSkin = new Image(AtlasAsset.CommonAtlas.getTexture("side_menu/voice_over_icon"));
			toggleVoiceButton.defaultSkin.alpha = 0.5;
			toggleVoiceButton.defaultSelectedSkin = new Image(AtlasAsset.CommonAtlas.getTexture("side_menu/voice_over_icon"));
			toggleVoiceButton.isSelected = SoundManager.instance.voiceoverEnabled;
			toggleVoiceButton.addEventListener(Event.CHANGE, toggleVoiceButton_changeHandler);
			toggleVoiceButton.scale = buttonsScale;
			buttonsGroup.addChild(toggleVoiceButton);
			
			if (PlatformServices.isCanvas)
			{
				if (Settings.instance.snowEnabled) {
					buttonsLayout.gap = 23 * pxScale;
					buttonsLayout.paddingRight = 21*pxScale;
					//addSnowButton(buttonsScale);
				}
				else {
					buttonsLayout.gap = 32 * pxScale;
				}
				
				var fullscreenButton:FullscreenButton = new FullscreenButton();
				fullscreenButton.scale = buttonsScale;
				buttonsGroup.addChild(fullscreenButton);
			}
			else if(Settings.instance.snowEnabled)
			{
				buttonsLayout.gap = 32 * pxScale;
				//addSnowButton(buttonsScale);
			}
		}
		
		private function toggleVoiceButton_changeHandler(e:Event):void 
		{
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAUIInteractionEvent(DDNAUIInteractionEvent.ACTION_TRIGGERED, DDNAUIInteractionEvent.LOCATION_SIDE_MENU, "voiceoverButton", DDNAUIInteractionEvent.TYPE_BUTTON));
			SoundManager.instance.voiceoverEnabled = !SoundManager.instance.voiceoverEnabled;
		}
		
		private function toggleSoundButton_changeHandler(e:Event):void 
		{
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAUIInteractionEvent(DDNAUIInteractionEvent.ACTION_TRIGGERED, DDNAUIInteractionEvent.LOCATION_SIDE_MENU, "sfxButton", DDNAUIInteractionEvent.TYPE_BUTTON));
			SoundManager.instance.sfxEnabled = !SoundManager.instance.sfxEnabled;
		}
		
		private function toggleMusicButton_changeHandler(e:Event):void 
		{
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAUIInteractionEvent(DDNAUIInteractionEvent.ACTION_TRIGGERED, DDNAUIInteractionEvent.LOCATION_SIDE_MENU, "musicButton", DDNAUIInteractionEvent.TYPE_BUTTON));
			SoundManager.instance.backgroundMusicEnabled = !SoundManager.instance.backgroundMusicEnabled;
		}
		
		
	}

}