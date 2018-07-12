package com.alisacasino.bingo.platform
{
	import com.alisacasino.bingo.models.collections.CollectionPage;
	
	public interface IFacebookManager
	{
		function get isConnected():Boolean;
		function dialog(method:String, parameters:Object=null, callback:Function=null, allowNativeUI:Boolean=true):void;
		function openSession():void;
		function startMeRequest():void;
		function logOut():void;
		function publishRoomVisitedStory(roomTypeName:String, roomTitle:String):void;
		function publishItemFoundStory(itemName:String, explicitlyShared:Boolean = false):void;
		function publishScratchCardTopPrizeStory():void;
		function get facebookId():String;
		function get accessToken():String;
		function likePage():void;
		
		function join():void;
		
		function publishEventPrizeStory():void;
		
		function publishRareChestStory():void;
		
		function postTournamentPhoto(callback:Function, place:uint):void;
		
		function share(opengraphURL:String, message:String = null):void;
		
		function getAppID():String;
		//function get hasPublishPermission():Boolean;
		function get hasUserFriendsPermission():Boolean;
	}
}
