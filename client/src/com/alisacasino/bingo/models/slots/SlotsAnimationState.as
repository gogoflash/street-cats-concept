package com.alisacasino.bingo.models.slots 
{
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.utils.GAFUtils;
	
	public class SlotsAnimationState 
	{
		public static const LAYER_REELS_ID:String = '_reelsContainer';		
		public static const LAYER_SCREEN_ID:String = '_screenContainer';
		
		public static const HELL:String = "hell";
		public static const HEAVEN:String = "heaven";
		
		public static const APPEAR:String = "_appear";
		public static const HIDE:String = "_hide";
		public static const IDLE:String = "_idle";
		public static const SPIN:String = "_spin";
		public static const WIN:String = "_win";
		public static const WIN_ALTERNATIVE:String = "_win_alternative";
		
		public var state:String;
		public var type:String;
		
		private static var _animationLayerIdsSettings:Object;
		private static var _animationCycleSettings:Object;
	
		public function SlotsAnimationState(state:String, type:String) 
		{
			this.state = state;
			this.type = type;
		}
	
		public static function getCycleSettings(type:String, state:String):Array
		{
			return state in animationCycleSettings[type] ? animationCycleSettings[type][state] : [-1, -1];
		}
		
		public static function prepareCustomLayers(animationAsset:MovieClipAsset):void
		{
			var statesList:Array = 
			[
				APPEAR,
				HIDE,
				IDLE,
				SPIN,
				WIN,
				WIN_ALTERNATIVE
			]
			
			injectCustomLayer(animationAsset, LAYER_REELS_ID, HELL, statesList);
			injectCustomLayer(animationAsset, LAYER_SCREEN_ID, HELL, statesList);
			
			injectCustomLayer(animationAsset, LAYER_REELS_ID, HEAVEN, statesList);
			injectCustomLayer(animationAsset, LAYER_SCREEN_ID, HEAVEN, statesList);
		}
		
		private static function injectCustomLayer(animationAsset:MovieClipAsset, layerId:String, animationType:String, statesList:Array):void
		{
			var i:int;
			var length:int = statesList.length;
			var linkageId:String;
			for (i = 0; i < length; i++) {
				linkageId = animationType + statesList[i];
				GAFUtils.createGAFMovieClip(animationAsset.getGAFTimelineByLinkage(linkageId), linkageId + layerId, animationLayerIdsSettings[layerId + linkageId]);//, 0, true);	
			}
		}
		
		private static function get animationLayerIdsSettings():Object 
		{
			if (!_animationLayerIdsSettings) 
			{
				_animationLayerIdsSettings = {}
				_animationLayerIdsSettings[LAYER_REELS_ID + 'hell_appear'] = '100';
				_animationLayerIdsSettings[LAYER_REELS_ID + 'hell_hide'] = '100';
				_animationLayerIdsSettings[LAYER_REELS_ID + 'hell_idle'] = '100';
				_animationLayerIdsSettings[LAYER_REELS_ID + 'hell_spin'] = '99';
				_animationLayerIdsSettings[LAYER_REELS_ID + 'hell_win'] = '99';
				_animationLayerIdsSettings[LAYER_REELS_ID + 'hell_win_alternative'] = '99';
				
				_animationLayerIdsSettings[LAYER_SCREEN_ID + 'hell_appear'] = '103';
				_animationLayerIdsSettings[LAYER_SCREEN_ID + 'hell_hide'] = '103';
				_animationLayerIdsSettings[LAYER_SCREEN_ID + 'hell_idle'] = '103';
				_animationLayerIdsSettings[LAYER_SCREEN_ID + 'hell_spin'] = '103';
				_animationLayerIdsSettings[LAYER_SCREEN_ID + 'hell_win'] = '103';
				_animationLayerIdsSettings[LAYER_SCREEN_ID + 'hell_win_alternative'] = '103';
				
				_animationLayerIdsSettings[LAYER_REELS_ID + 'heaven_appear'] = '100';
				_animationLayerIdsSettings[LAYER_REELS_ID + 'heaven_hide'] = '100';
				_animationLayerIdsSettings[LAYER_REELS_ID + 'heaven_idle'] = '100';
				_animationLayerIdsSettings[LAYER_REELS_ID + 'heaven_spin'] = '99';
				_animationLayerIdsSettings[LAYER_REELS_ID + 'heaven_win'] = '99';
				_animationLayerIdsSettings[LAYER_REELS_ID + 'heaven_win_alternative'] = '99';
				
				_animationLayerIdsSettings[LAYER_SCREEN_ID + 'heaven_appear'] = '103';
				_animationLayerIdsSettings[LAYER_SCREEN_ID + 'heaven_hide'] = '103';
				_animationLayerIdsSettings[LAYER_SCREEN_ID + 'heaven_idle'] = '103';
				_animationLayerIdsSettings[LAYER_SCREEN_ID + 'heaven_spin'] = '103';
				_animationLayerIdsSettings[LAYER_SCREEN_ID + 'heaven_win'] = '103';
				_animationLayerIdsSettings[LAYER_SCREEN_ID + 'heaven_win_alternative'] = '103';
			}
			
			return _animationLayerIdsSettings;
		}
		
		private static function get animationCycleSettings():Object 
		{
			if (!_animationCycleSettings) 
			{
				_animationCycleSettings = {};
				_animationCycleSettings[HEAVEN] = {};
				_animationCycleSettings[HEAVEN][WIN_ALTERNATIVE] = [55, 110];
				_animationCycleSettings[HEAVEN][WIN] = [49, 85];
				
				_animationCycleSettings[HELL] = {};
				_animationCycleSettings[HELL][WIN_ALTERNATIVE] = [49, 95];
				_animationCycleSettings[HELL][WIN] = [50, 90];
			}
			
			return _animationCycleSettings;
		}
		
	}

}