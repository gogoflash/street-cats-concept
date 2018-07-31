package com.alisacasino.bingo.utils
{
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import flash.system.Capabilities;
	import mx.utils.StringUtil;

	public class Constants
	{
		public static function get isDevBuild():Boolean
		{
			//return false;
			if (CONFIG::devBuild)
			{
				return true;
			}
			
			return false;
		}
		
		public static const CANVAS_VERSION:String = "0.00.25";
		
		static public var devCheatMode:Boolean = false;
		
		static public const keepLocalUser:Boolean = false;

		static public var enableProdLogging:Boolean = false;
		
		static public var USE_ALL_LOCAL_ASSETS:Boolean = true;
		
		static public var USE_LOCAL_ASSETS:Boolean = USE_ALL_LOCAL_ASSETS || false;
		
		static public var USE_LOCAL_SKINS_ASSETS:Boolean = USE_ALL_LOCAL_ASSETS || false;
		
		static public var USE_LOCAL_IMAGES_ASSETS:Boolean = USE_ALL_LOCAL_ASSETS || false;
		
		static public var USE_LOCAL_ANIMATION_ASSETS:Boolean = USE_ALL_LOCAL_ASSETS || false;
		
		static public var USE_LOCAL_SOUND_ASSETS:Boolean = USE_ALL_LOCAL_ASSETS || false;
		
		private static var cachedLocalBuild:int = -1;
		
		public static function get isLocalBuild():Boolean
		{
			if (cachedLocalBuild == -1)
			{
				if (Capabilities.playerType == "StandAlone")
				{
					cachedLocalBuild = 1;
				}
				else 
				{
					cachedLocalBuild = 0;
				}
			}
			
			return cachedLocalBuild == 1;
		}
		
		public static function get isAmazonBuild():Boolean
		{
			if(CONFIG::amazonBuild)
			{
				return true;
			}
			
			return false;
		}

		public static function get isDevFeaturesEnabled():Boolean
		{
			return isDevBuild || (Player.current && Player.current.isAdmin);
		}
		
		public static const PRIMARY_STATIC_HOST:String = "https://static-bingo2.alisagaming.net/settings/";
		public static const SECONDARY_STATIC_HOST:String = "https://s3.amazonaws.com/static-bingo2.alisagaming.net/settings/";
		public static const TERTIARY_STATIC_HOST:String = "http://s3.us-east-2.amazonaws.com/static-bingo2-mirror.alisagaming.net/settings/";

		public static const GOOGLE_PLAY_SETTINGS_FILENAME:String = "googleplay";
		public static const AMAZON_SETTINGS_FILENAME:String = "amazon";
        public static const IOS_SETTINGS_FILENAME:String = "ios";
        public static const FACEBOOK_SETTINGS_FILENAME:String = "facebook";
		
		public static const ANDROID_SETTINGS_FILENAME:String = isAmazonBuild ? AMAZON_SETTINGS_FILENAME : GOOGLE_PLAY_SETTINGS_FILENAME;
		
		static public const ANALYTICS_HOST:String = "https://lytics-bingo2.alisagaming.net";
		
		private static const appIdByPlatform:Object =
		{
			"fbDev": "1",
			"androidDev":"2",
			"amazonDev":"3",
			"iosDev":"4",
			"fb":"5",
			"android":"6",
			"amazon":"7",
			"ios":"8"
		};
		
		private static var cachedPlatformId:String;
		
		static public function get analyticsAppId():String
		{
			if (!cachedPlatformId)
			{
				var platformType:String;
				switch(PlatformServices.platform)
				{
					case Platform.AMAZON_APP_STORE:
						platformType = "amazon";
						break;
					case Platform.APPLE_APP_STORE:
						platformType = "ios";
						break;
					case Platform.FACEBOOK:
						platformType = "fb";
						break;
					case Platform.GOOGLE_PLAY:
						platformType = "android";
						break;
				}
				if (isDevBuild)
				{
					platformType += "Dev";
				}
				cachedPlatformId = appIdByPlatform[platformType];
				
				if (!cachedPlatformId)
				{
					sosTrace("Could not determine platform for analytics", SOSLog.ERROR);
					cachedPlatformId = "0";
				}
			}
			
			return cachedPlatformId;
		}
		
		
		static public const PROTOCOL_VERSION:int = 1;
		
		public static function get assetsURL():String 
		{
			if (Settings.instance.assetsFolderUrl)
			{
				return Settings.instance.assetsFolderUrl;
			}
			return "https://s3.amazonaws.com/static-bingo2.alisagaming.net/assets-dev/";
		}
		
		public static const localAssetsURL:String = '../../assets_dist/';
		
		public static const AVATARS_URL:String = 'https://static-bingo2.alisagaming.net/assets-prod/';
		
		public static const OPENGRAPH_ROOMS_DIRECTORY:String = "http%3A%2F%2Fs3.alisabingo.net%2Fopengraph%2Frooms%2F";
		public static const OPENGRAPH_ITEMS_DIRECTORY:String = "http%3A%2F%2Fs3.alisabingo.net%2Fopengraph%2Fcollectibles%2F";
		public static const OPENGRAPH_OBJECTIVES_DIRECTORY:String = "http%3A%2F%2Fs3.alisabingo.net%2Fopengraph%2Fobjectives%2F";
		
		public static const FACEBOOK_PAGE_ID:String = "231833403627323";
		
		public static const AF_DEV_KEY:String = "Fuh4F7fffnay4Rj3zAfPK4";
		public static const APPLE_ID:String = "1294656579";

		public static const ANDROID_PUSH_SENDER_ID:String = "1002334838000";
		
		public static const NETWORK_REQUEST_TIMEOUT_MILLIS:Number = 5000;
		public static const SOCKET_TIMEOUT_MILLIS:Number = 15000;
		
		public static const REQUEST_SERVER_STATUS_INTERVAL_MILLIS:Number = 5000;
		public static const ONE_SECOND_INTERVAL_MILLIS:Number = 1000;
		
		public static const MAX_CRASH_LOG_SEND_COUNT:int = 4;
		
		public static const SPECIAL_BONUS_INTERVAL_MILLIS:Number = 23 * 60 * 60 * 1000;
		public static const SPECIAL_BONUS_INTERVAL_MILLIS_DEV:Number = 5 * 60 * 1000;
		public static const SLOT_MACHINE_HAPPY_SPIN_INTERVAL:Number = 6 * 24 * 60 * 60 * 1000;
		public static const SPECIAL_BONUS_MIN_COINS_COUNT:uint = 30;
		public static const SPECIAL_BONUS_MAX_COINS_COUNT:uint = 100;
		public static const SPECIAL_BONUS_MIN_TICKETS_COUNT:uint = 15;
		public static const SPECIAL_BONUS_ONLY_FOR_FB_CONNECTED_PLAYERS:Boolean = false;
		
		public static const CONNECT_FACEBOOK_BONUS_CASH:uint = 200;
		
		public static const ANTI_ACCUMULATION_POLICY_XP_LEVEL_THRESHOLD:uint = 3;
		public static const ANTI_ACCUMULATION_POLICY_COINS_THRESHOLD:uint = 100;
		public static const ANTI_ACCUMULATION_POLICY_TICKETS_THRESHOLD:uint = 30;
		public static const ANTI_ACCUMULATION_POLICY_ENERGY_THRESHOLD:uint = 10;
		public static const ANTI_ACCUMULATION_POLICY_KEYS_THRESHOLD:uint = 10;
		
		public static const BINGO_RATIO_TOO_HIGH:Number = 1.0;
		public static const BINGO_RATIO_NORMAL:Number = 0.5;
		
		public static const LIMITED_TIME_OFFER_EXPIRES_MILLIS:Number = 3 * 60 * 60 * 1000;
		
		public static const CRITICAL_VALUE_CASH:uint = 49;
		public static const CRITICAL_VALUE_ENERGY:uint = 4;
		
		public static const FACEBOOK_APP_ID:String = "128427124377299";
		public static const FACEBOOK_APP_ID_DEV:String = "1759615694368865";

		public static const FACEBOOK_READ_PERMISSIONS:Array = ["email"];
		public static const FACEBOOK_PUBLISH_PERMISSIONS:Array = ["publish_actions"];
		
		public static const BONUS_BTN_COLLECT:String = "COLLECT!!";
		public static const BONUS_BTN_TITLE:String = "Daily Bonus";
		public static const OBJECTIVES_TITLE:String = "Objectives";
		public static const COLLECTIONS_TITLE:String = "Collections";
		
		public static const LEADERBOARDS_TITLE:String = "Leaderboards";
		
		public static const PROFILE_ITEM_TOTAL_GAMES:String = "Total games";
		public static const PROFILE_ITEM_TOTAL_BINGOS:String = "Total bingos";
		public static const PROFILE_ITEM_PLAYER_ID:String = "Player ID";
		
		public static const SETTINGS_ITEM_ON_TEXT:String = "ON";
		public static const SETTINGS_ITEM_OFF_TEXT:String = "OFF";
		public static const SETTINGS_ITEM_MUSIC:String = "Background music";
		public static const SETTINGS_ITEM_SFX:String = "Sound effects";
		public static const SETTINGS_ITEM_VOICE:String = "Voice over";
		public static const SETTINGS_DIALOG_TITLE:String = "Settings";
		public static const SETTINGS_LOGIN_BTN_TEXT:String = "Connect with Facebook";
		public static const SETTINGS_LOGOUT_BTN_TEXT:String = "Log Out";
		
		public static const TITLE_LOADING_ERROR:String = "Loading error";
		public static const TEXT_LOADING_ERROR:String = "Can't load resources. Please check your internet connection and try again.";
		public static const TEXT_LOADING_ERROR_DEV:String = "Can't load: ";
		public static const TEXT_LOADING_CONFIG_ERROR:String = "Can't load game config. Please check your internet connection and try again.";
		
		
		public static const TITLE_UNABLE_TO_CONNECT:String = "Unable to connect";
		public static const TEXT_UNABLE_TO_CONNECT:String = "Can't connect to the server. Please check your internet connection and try again.";
		public static const BTN_TRY_AGAIN:String = "Try again";
		
		public static const TITLE_RECONNECT:String = "Connection lost";
		public static const TEXT_RECONNECT:String = "The connection to the server has been lost. Please reconnect to continue playing.";
		public static const TEXT_RECONNECT_NEW:String = "Cannot establish a connection to the server at the moment.\n\nPlease switch\nto a stable Wi-Fi\nor try again later!";
		public static const BTN_RECONNECT:String = "Reconnect";
		
		public static const TITLE_MAINTENANCE:String = "Under maintenance";
		public static const TEXT_MAINTENANCE:String = "The game servers are under maintenance. Please check back soon.";
		
		public static const TITLE_FB_CONNECT:String = "Connect with Facebook";
		public static const TEXT_FB_CONNECT:String = "Please sign in with your Facebook account and receive a bonus!";
		public static const BTN_FB_CONNECT:String = "Connect with Facebook";
		
		public static const TEXT_WBT_PLAY_NOW:String = "Like to travel? Click on the Earth icon in the lobby and play NOW!";
		public static const TEXT_EASTER_PLAY_NOW:String = "Welcome to Easter\nBingo room!\nEnds on Mar 28\nPlay NOW!";
		public static const TEXT_SAN_FRANCISCO_PLAY_NOW:String = "Welcome to \nSan Francisco!\nEnds on May 1\nPlay NOW!";
		
		public static const TITLE_NEW_VERSION:String = "New version is available";
		public static const TEXT_NEW_VERSION:String = "The new version of the game is available. Please update!";
		public static const BTN_NEW_VERSION:String = "Update";
		
		public static const TITLE_QUIT:String = "Quit the game?";
		public static const TEXT_QUIT:String = "Are you sure you want to quit the game?"
		public static const BTN_QUIT:String = "Quit";
		public static const BTN_CANCEL:String = "Cancel";
		public static const BTN_OK:String = "OK";
		
		public static const TITLE_SETTINGS:String = "Settings";
		
		public static const TITLE_ITEM_FOUND:String = "You found a collectible!";
		
		public static const TITLE_ROOM_LOCKED:String = "The room is locked";
		public static const TEXT_ROOM_LOCKED:String = "You need to reach level {0} to play this room.";
		
		public static const STORE_ITEM_COINS:String = "coins";
		public static const STORE_ITEM_TICKETS:String = "tickets";
		public static const STORE_ITEM_ENERGY:String = "energy";
		public static const STORE_ITEM_KEYS:String = "keys";
		
		public static const TITLE_BUY_COINS:String = "Buy coins";
		public static const TITLE_BUY_TICKETS:String = "Buy tickets";
		public static const TITLE_BUY_ENERGY:String = "Buy energy";
		public static const TITLE_BUY_KEYS:String = "Buy keys";
		
		public static const TITLE_GET_FREE_COINS:String = "Get FREE coins";
		public static const TITLE_GET_FREE_TICKETS:String = "Get FREE tickets";
		public static const TITLE_GET_FREE_ENERGY:String = "Get FREE energy";
		public static const TITLE_GET_FREE_KEYS:String = "Get FREE keys";
		
		public static const TITLE_LIMITED_TIME_OFFER:String = "Limited time offer";
		
		public static const TITLE_BUY_CARDS_TO_PLAY:String = "Choose the number of cards";
		public static const BTN_PLAY:String = "Play";
		
		public static const TITLE_ROUND_RESULTS:String = "Round results";
		
		public static const TEXT_YOU_HAVE_REACHED_NEW_LEVEL:String = "You have reached\na new level !!!";
		
		public static const TITLE_LEAVE:String = "Game in progress";
		public static const TEXT_LEAVE:String = "Are you sure you want to leave this room?";
		public static const BTN_LEAVE:String = "Leave";
		
		public static const TEXT_NEW_ROOM:String = "The new room is now unlocked!! Do you want to play it now?";
		
		public static const TITLE_NO_COINS:String = "Not enough coins";
		public static const TEXT_NO_COINS:String = "You ran out of coins. Please buy more!";

		public static const TITLE_NO_TICKETS:String = "Not enough tickets";
		public static const TEXT_NO_TICKETS:String = "You ran out of tickets. Please buy more!";
		public static const BTN_BUY:String = "Buy";
		public static const BTN_ACCEPT:String = "Accept!";
		
		public static const TITLE_PURCHASE_COMPLETE:String = "Thank you!";
		public static const TEXT_PURCHASE_COMPLETE_TICKETS:String = "You have just bought {0} tickets!";
		public static const TEXT_PURCHASE_COMPLETE_SPIN:String = "You have just bought {0} spin!";
		public static const TEXT_PURCHASE_COMPLETE_SPINS:String = "You have just bought {0} spins!";
		public static const TEXT_PURCHASE_COMPLETE_COINS:String = "You have just bought {0} coins!";
		public static const TEXT_PURCHASE_COMPLETE_COMBO_ITEM:String = "You have just bought a lotta stuff!"; 
		
		public static const INVITE_MESSAGE_LIFETIME_MILLIS:Number = 24 * 3600 * 1000;
		public static const FRIENDS_LOBBY_BUTTON_TITLE:String = "Friends";
		public static const INVITE_FRIENDS_TITLE:String = "Invite friends";
		public static const INVITE_BUTTON_TITLE:String = "INVITE";
		public static const ASK_FRIENDS_BUTTON_TITLE:String = "Get!";
		
		public static const GIFTS_LOBBY_BUTTON_TITLE:String = "Gifts";
		public static const SEND_GIFTS_TITLE:String = "Send FREE Gifts";
		public static const SEND_GIFTS_BTN_TEXT:String = "OK";
		public static const ACCEPT_GIFT_TITLE:String = "You’ve got a gift!";
		public static const ACCEPT_GIFT_BTN_TEXT:String = "Accept";
		public static const ACCEPT_AND_SEND_GIFT_BTN_TEXT:String = "Accept & Send";
		public static const INVITE_FACEBOOK_MESSAGE:String = "Join Alisa Bingo now!";
		public static const GIFT_FACEBOOK_MESSAGE:String = "Here's a gift just for you! Have a great day!";
		public static const GIFTS_BADGE_UPDATE_INTERVAL_MILLIS:Number = 60 * 1000;
		
		public static const CLAIM_BONUS_TITLE:String = "You’ve got a gift!";
		public static const CLAIM_BONUS_BTN_TEXT:String = "Claim";
		public static const TITLE_CLAIMED:String = "OFFER CLAIMED";
		public static const TEXT_CLAIMED:String = "This offer has already been claimed.";
		public static const TITLE_EXPIRED:String = "OFFER EXPIRED";
		public static const TEXT_EXPIRED:String = "This offer has expired.";
		
		public static const FBLIKE_TITLE:String = "Like us on Facebook!";
		
		public static const STAGE_START_WIDTH:Number = 1280;
		public static const STAGE_START_HEIGHT:Number = 720;
		
		public static const CLIENT_MESSAGE_MIN_INTERVAL_MILLIS:Number =  15 * 1000;
		public static const PLAYER_CAN_COLLECT_GIFTS_COUNT:Number = 100;
		public static const TITLE_LIMIT_REACHED:String = "Limit reached";
		public static const TEXT_GIFTSCAPPING_YOU_MUST_WAIT:String = "You must wait";
		public static const TEXT_GIFTSCAPPING_BEFORE_COLLECTING_MORE:String = "before collecting more";
		public static const BTN_CONTINUE:String = "Continue";
		public static const PLAY_ON_MOBILE:String = "Play on Mobile";
		
		public static const REFUND_TITLE:String = "OOPS!";
		public static const REFUND_TEXT:String = "Looks like your game crashed during the last round, but no worries, your resources have been restored.";
		static public const BTN_SLOT_MACHINE_GET_SPINS:String = "Get spins!";
		static public const BTN_SLOT_MACHINE_SPINS_LEFT:String = "Spins: ";
		static public const TITLE_BUY_SLOT_MACHINE_SPINS:String = "Get spins!";
		static public const BTN_SLOT_MACHINE_PAYOUT:String = "Payouts";
		static public const SLOT_MACHINE_ANY_SYMBOL_LABEL:String = "any";
		static public const SLOT_MACHINE_PAYOUT_HEADER:String = "Payouts";
		static public const SLOT_MACHINE_GOOD_LUCK:String = "Good luck!";
		static public const SLOT_MACHINE_BUY_ONE_SPIN:String = "{0} Spin";
		static public const SLOT_MACHINE_BUY_MULTIPLE_SPINS:String = "{0} Spins";
		static public const SLOT_MACHINE_FREE_SPINS:String = "Free Spins!";
		static public const SLOT_MACHINE_GET_SPINS_DIALOG_TITLE:String = "Get Spins";
		static public const DAILY_SPIN_BUTTON_TITLE:String = "Daily Spin";
		static public const SLOT_MACHINE_FREE_SPINS_BUTTON_LABEL:String = "Free spins!";
		static public const SLOT_MACHINE_FREE_SPINS_COMING_SOON:String = "Coming\nsoon";
		static public const BTN_SLOT_MACHINE_SPINNING:String = "Spinning!";
		static public const BTN_SLOT_MACHINE_WIN:String = "Great!";
		static public const BTN_SLOT_MACHINE_BIG_WIN:String = "WOW!!!";
		static public const COLLECT_ALL_GIFTS_BUTTON_LABEL:String = "Accept All Gifts with One Tap!";
		static public const INBOX_DIALOG_TITLE:String = "Inbox";
		static public const UNLOCK_ONE_TAP_ACCEPT_LABEL:String = "Unlock one-tap accept all!";
		static public const INBOX_ACCEPT:String = "Accept";
		static public const INBOX_ACCEPT_AND_SEND:String = "Accept & Send";
		static public const GET_SOME_STUFF:String = "Buy now!";
		static public const PREMIUM_FEATURE_DIALOG_TITLE:String = "One-Tap Accept";
		static public const PREMIUM_FEATURE_DIALOG_BODY:String = "Make any purchase, and collect all your gifts at once!";
		static public const INBOX_LOBBY_BUTTON_TITLE:String = "Inbox";
		static public const INBOX_COME_BACK_LATER:String = "Come back later\nfor more gifts!";
		static public const GET_FREE_SPINS_BUTTON_LABEL:String = "Get!";
		static public const TITLE_GET_FREE_SPINS:String = "Get FREE spins";
		static public const NOTIFICATION_COLLECT_ACTION:String = "Collect!";
		static public const SLOT_MACHINE_NOTIFICATION_BODY:String = "Collect your FREE spin NOW!";
		static public const GIFT_COLLECT_NOTIFICATION_BODY:String = "Get your gifts NOW!";
		static public const SCRATCH_CARD_PROMPT:String = "Click on the\nbutton to play";
		static public const SCRATCH_CARD_TUTORIAL:String = "Scratch & match 3\nto win!";
		static public const SCRATCH_CARD_TRY_AGAIN:String = "Try again!";
		static public const SCRATCH_CARD_PAYMENT_FIRST_PART:String = "Play for";
		static public const SCRATCH_CARD_BUTTON_DOWN_TEXT:String = "Scratch!";
		static public const SCRATCH_CARD_BUTTON_GAME_STARTED:String = "Round started";
		static public const SCRATCH_CARD_INVITATION:String = "Play Magic Scratch\nwhile you wait for\nthe round to start!";
		static public const SHARE_BUTTON_TEXT:String = "Share";
		static public const DONE_LABEL:String = "Done!";
		static public const OPENGRAPH_PRIZE_DIRECTORY:String = "http%3A%2F%2Fs3.alisabingo.net%2Fopengraph%2Fprizes%2F";
		static public const INBOX_INVITE_MORE_FRIENDS:String = "You don't have any more gifts at the moment!\n\n<font color='#36ff00'>Invite</font> more friends to get more gifts!";
		public static const INBOX_NO_MORE_GIFTS_PLAY_NOW:String = "You don't have any more gifts at the moment!\n\nCheck back later\ngo <font color='#36ff00'>play now!</font>";
		public static const INBOX_NO_MORE_GIFTS_SEND_GET:String = "You don't have any more gifts at the moment!\n\n<font color='#36ff00'>send gifts</font> to friends and get more in return!";
		public static const PLAY_NOW:String = "PLAY NOW!";
		public static const SEND_GET:String = "SEND & GET";
		static public const DAILY_EVENT_CHEST_DIALOG_TITLE:String = "Rare Chest";
		
		
		public static const INVITE_FRIENDS_HINT:String = 'Receive <font color="#36ff00">free</font> cash                  from your friends!';
        public static const INVITE_FRIENDS_NO_FRIENDS_HINT:String = "Not found your friends.\n\n You are a lonely cat!";
		public static const INVITE_FRIENDS_NO_FRIENDS_FOR_INVITE:String = "All friends invited!";
		public static const SEND_GIFT_FRIENDS_NO_FRIENDS_FOR_GIFT:String = "All friends gifted!";
		public static const SEND_GIFT_FRIENDS_HINT:String = "Receive free       from your friends!";
		public static const SELECT_ALL:String = "SELECT ALL";
		public static const SELECT_NONE:String = "SELECT NONE";
		
		public static const RATE_US_DIALOG_BUBBLE_RATE:String = "Like our game? Your rating is important to us!";
		public static const RATE_US_DIALOG_BUBBLE_AFTER_RATE:String = "Thank you for rating us! We appreciate it!";
		public static const RATE_US_DIALOG_BUBBLE_TITLE:String = "RATE US!";
		public static const RATE_US_DIALOG_BUTTON_SEND:String = "RATE";
		public static const RATE_US_DIALOG_BUTTON_OKAY:String = "OKAY";
		public static const SETTINGS_DIALOG_RATE:String = "RATE!";
		public static const WBT_LEVEL_UNAVAILABLE_HINT:String = "Available on level "; 
		public static const DAUB_ALERT_BUBBLE_HINT:String = "1 Round"; 
		public static const DAUB_ALERT_FREE_BUBBLE_HINT_MULTIPLE:String = " rounds";
		public static const DAUB_ALERT_FREE_BUBBLE_HINT_SINGLE:String = " round";
		public static const DAUB_ALERT_PURCHASED_BUBBLE_HINT:String = "hints enabled";
		public static const DAUB_ALERT_BUTTON_LABEL:String = "Daub Alert";
		public static const DAUB_ALERT_FREE_BUBBLE_HINT_FREE:String = "FREE";
		
		public static const BUTTON_BINGO:String = "BINGO!";
		
		public static const SHARED_PROPERTY_FIRST_START:String = "SHARED_PROPERTY_FIRST_START";
		
		static public const FREEBIE_TEXT:String = "It's your reward!\nKeep checking\n<font color='#4ea5ff'>facebook page</font>\n for more!";
		
		
		static public const POWERUPS_CAT_TOOLTIP_TEXT:String = "Hello there! These are your <font color=\"#ff3939\">Power-ups.</font>\nYou can tap on each individual one to\nlearn more about it!\n\nPowerups are split into three categories\nby their rarity: <font color=\"#41c900\">Normal (Green)</font>, <font color=\"#59a6ff\">Magic (Blue)</font>\nand <font color=\"#ff9326\">Rare (Yellow)</font>.\n\nOn the right you can buy power-ups and see\nhow many powerups of which kind will you\nget! You can also get powerups from chests.";
		static public const GOLD_BADGE_TOOLTIP:String = "<font color=\"#ffc000\">Gold medals</font> are awarded\nfor #1 place in tournaments!";
		static public const SILVER_BADGE_TOOLTIP:String = "<font color=\"#4ca9e8\">Silver medals</font> are awarded\nfor #2 place in tournaments!";
		static public const BRONZE_BADGE_TOOLTIP:String = "<font color=\"#db3b2a\">Bronze medals</font> are awarded\nfor #3 place in tournaments!";
		
		public static const LAST_CARD_BURN_WARNING:String = "YOU  ONLY  HAVE  1  CARD  LEFT\nARE  YOU  SURE?";
		public static const LAST_CARDS_BURN_WARNING:String = "YOU  WILL  BURN  ALL  CARDS\nARE  YOU  SURE?";
		
		static public const INVENTORY_TOOLTIP:String = "This is the Inventory screen! Opening a Super Chest\nmay give you Customization Cards. Here you can see\nall of them (daubers, callers, etc.) split into categories.\n\nCustomization Cards can be <font color=\"#47cdbc\">Normal</font>, <font color=\"#00ccff\">Silver</font> or <font color=\"#ffc000\">Gold</font>.\n\nYou can burn excess cards to get <font color=\"#24E734\">Emerald Dust</font>\nto spend on a Super chest!";
		
		public static const OFFER_EXPIRES_STRING:String = "THIS OFFER EXPIRES IN ";
		public static const OFFER_EXPIRES_STRING_SHORT:String = "EXPIRES IN ";
		
		public static const NO_MORE_QUESTS_FOR_TODAY:String = "NO MORE QUESTS\n<font color=\"#ffff00\">FOR TODAY</font>";
		public static const COME_BACK_TOMORROW:String = "COME BACK\nTOMORROW!";
		
		static public const PRELOADER_HINTS:Vector.<String> = new <String>
		[
			'printing bingo cards',
			'polishing the balls',
			'checking bingo patterns',
			'readying daubers',
			'oiling up powerups',
			'feeding alisa cat',
			'checking correct daubs',
			'dusting off collections',
			'almost done',
			'just a few moments more',
			'tidying trophies',
			'shipping chests',
			'crafting chest keys',
			'restocking the store',
			'going around the world',
			'teaching cat bingo',
			'landing on the moon',
			'calling all your friends'

			//ready! set! DAUB! (100%)
		]
		

	}
}