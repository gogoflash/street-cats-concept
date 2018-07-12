package com.alisacasino.bingo.dialogs
{
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.utils.Constants;
	import starling.utils.Align;
	public class DialogProperties
	{
		public function DialogProperties(expectWidth:uint, expectHeight:uint, title:String = null, hasCloseButton:Boolean = true, bottomButtonTitle:String = null, blockerFade:Boolean = true, fadeClosable:Boolean = true, isRemovableByBackButton:Boolean = true, fadeStrength:Number = 0.8, starTitleRelativeY = 0.06, autoCenteringContent:Boolean = false) 
		{
			this.expectWidth = expectWidth;
			this.expectHeight = expectHeight;
			this.title = title;
			this.hasCloseButton = hasCloseButton;
			this.bottomButtonTitle = bottomButtonTitle;
			this.blockerFade = blockerFade;
			this.fadeClosable = fadeClosable;
			this.isRemovableByBackButton = isRemovableByBackButton;
			this.fadeStrength = fadeStrength;
			this.starTitleRelativeY = starTitleRelativeY;
			this.autoCenteringContent = autoCenteringContent;
			
			setStarTitle(null, starTitleRelativeY);
		}
		
		public function setStarTitle(textStyle:XTextFieldStyle = null, relativeY:Number = 0.06):DialogProperties
		{
			starTitleTextStyle = textStyle || XTextFieldStyle.getWalrus(47, 0xffffff);
			starTitleRelativeY = relativeY;
			return this;
		}
		
		public var expectWidth:Number = 0; 
		
		public var expectHeight:Number = 0;
		
		public var title:String;
		
		public var blockerFade:Boolean;
		
		public var fadeClosable:Boolean;
		
		public var fadeStrength:Number;
		
		public var hasCloseButton:Boolean;
		
		public var bottomButtonTitle:String;
		
		public var isRemovableByBackButton:Boolean;
		
		
		public var starTitleTextStyle:XTextFieldStyle;
		
		public var starTitleRelativeY:Number = 0.06;
		
		public var autoCenteringContent:Boolean;
		
		public static var EMPTY:DialogProperties = new DialogProperties(812, 0);
		
		public static var STUB:DialogProperties = new DialogProperties(812, 0, 'STUB', true, "STUB");
		
		public static var RECONNECT_BLANK:DialogProperties = new DialogProperties(812, 0, null, false, null, true, false, false, 0.85, 0.06, true);
		
		public static var RECONNECT_DIALOG:DialogProperties = new DialogProperties(812, 0, 'CONNECTION LOST', false, "RETRY", true, false, false, 0.85, 0.06, true);
		public static var RATE_US_DIALOG:DialogProperties = new DialogProperties(812, 0, 'RATE US!', true, "RETRY", true, true, true, 0.8, 0.06, true);
		public static var INVITE_FRIENDS:DialogProperties = new DialogProperties(812, 0, 'INVITE FRIENDS', true, "INVITE", true, true, true);
		public static var TOURNEY_LEADERBOARD:DialogProperties = new DialogProperties(812, 0, "", true, null, true, true, true);
		public static var TOURNAMENT_END:DialogProperties = new DialogProperties(812, 0, "THE TOURNEY IS OVER", true, null, true, false, true);
		public static var COLLECTION_PAGE_COMPLETED:DialogProperties = new DialogProperties(812, 0, "", true, null, true, true, true, 0.8, 0.08);
		public static var SEND_GIFTS:DialogProperties = new DialogProperties(812, 0, 'SEND GIFTS', true, "SEND", true, true, true);
		public static var INBOX:DialogProperties = new DialogProperties(812, 0, 'INBOX', true, "ACCEPT ALL", true, true, true);
		public static var SERVICE_DIALOG:DialogProperties = new DialogProperties(1145, 0, 'SERVICE DIALOG', true, null, true, true, false);
		public static var FACEBOOK_CONNECT:DialogProperties = new DialogProperties(812, 0, 'FACEBOOK CONNECT!', true, "CONNECT!", true, true, true, 0.8, 0.06, true);
		public static var TRANSFER_RATE_WARNING:DialogProperties = new DialogProperties(812, 0, "CAN'T CONNECT", true, "GOT IT", true, true, true);
		public static var FREEBIES_CLAIM:DialogProperties = new DialogProperties(812, 0, 'YOU’VE GOT A GIFT!', false, "CLAIM!", true, false, false, 0.8, 0.06, true);
		public static var SERVICE_DAUBER_PARTICLES_DIALOG:DialogProperties = new DialogProperties(1012, 0, null, true, null, true, false, false);
		public static var SERVICE_QUESTS:DialogProperties = new DialogProperties(812, 0, 'SERVICE QUESTS', true, null, true, false);
	}		
}
