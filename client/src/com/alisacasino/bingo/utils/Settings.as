package com.alisacasino.bingo.utils
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.models.TutorialManager;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.store.IStoreItem;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import starling.events.EventDispatcher;

	public class Settings extends EventDispatcher
	{
		static public const MAINTENANCE_STATUS_CHANGE:String = "maintenanceStatusChange";
		
		private var mLatestVersion:String = "";
		private var mMaintenance:Boolean = false;
		private var mAppUrl:String = "";
		private var mServers:Array = [];
		private var mComboItems:Array = [];
		private var mCoinsItems:Array = [];
		private var mTicketsItems:Array = [];
		private var mEnergyItems:Array = [];
		private var mKeysItems:Array = [];
		
		private var _maintenanceTitle:String;
		private var _maintenanceText:String;
		private var _adminIds:Array = [];
		private var _snowEnabled:Boolean;
		private var _firstServerHost:String;
		
		private static var sInstance:Settings = null;
		
		public static function get instance():Settings
		{
			if (sInstance == null)
				sInstance = new Settings();
			return sInstance;
		}
		
		private var _spinStoreItems:Array = [];
		
		public function get spinStoreItems():Array 
		{
			return _spinStoreItems;
		}
		
		private var mPreferredServerHost:String = null;
		private var mPreferredServerPort:int = 0;
		
		//private var mSuperSale:Boolean;
		private var mPreselectAll:Boolean = true;
		private var mPreselectFromLevel:int = 0;
		
		private var _slotConfigURI:String;
		private var _assetsFolderUrl:String;

        public function get assetsFolderUrl():String {
            return _assetsFolderUrl;
        }

        public function get slotConfigURI():String
		{
			return _slotConfigURI;
		}
		
		private var _scratchCardConfigURI:String = "static_config/auxiliary2.dat";
		
		private var _saleType:String;
		private var _cutoffVersion:String = "";
		private var _assetIndexParent:String = "";
		private var _isSuperSale:Boolean;
		
		public function get ddnaLoggingEnabled():Boolean 
		{
			return _ddnaLoggingEnabled;
		}
		
		private var _ddnaLoggingEnabled:Boolean;
		
		public function get assetIndexParent():String 
		{
			return _assetIndexParent != "" ? _assetIndexParent : _assetsFolderUrl;
		}
		
		public function get saleType():String 
		{
			return _saleType;
		}

		public function get isSuperSale():Boolean
		{
			return _isSuperSale;
		}

		public function get scratchCardConfigURI():String 
		{
			return _scratchCardConfigURI;
		}
		
		public function get snowEnabled():Boolean
		{
			return _snowEnabled;
		}
		
		private var _avatarProxyPrefix:String = "";
		
		public function get avatarProxyPrefix():String
		{
			return _avatarProxyPrefix;
		}
		
		private var _firstStartTutorType:String = "";
		
		public function get firstStartTutorType():String 
		{
			return _firstStartTutorType;
		}
		
		private var _firstStartTutorABEven:Boolean;
		
		
		private var _minigamePowerupsEnabled:Boolean;
		
		public function get minigamePowerupsEnabled():Boolean 
		{
			return _minigamePowerupsEnabled;
		}
		
		public function get firstStartTutorABEven():Boolean
		{
			return _firstStartTutorABEven;
		}
		
		/**
		 * 
		 * @param	data
		 * @return true if parsing completed successfully, false otherwise
		 */
		public function parseFromJSON(data:String):Boolean
		{
			//sosTrace( "Settings.parseFromJSON > data : " + data, SOSLog.DEBUG);
			try {
				var source:Object = JSON.parse(data);
				mLatestVersion = source.latest_version;
				_cutoffVersion = source.hasOwnProperty("cutoff_version") ? source.cutoff_version : "";
				mAppUrl = source.app_url;
				mMaintenance = source.maintenance;
				
				_maintenanceTitle = source.maintenanceTitle;
				_maintenanceText = source.maintenanceText;
				_adminIds = source.adminIds || [];
				
				_saleType = source["sale_type"];
				if (source.hasOwnProperty("preselect_all"))
				{
					mPreselectAll = source.preselect_all;
				}
				
				mServers = [];
				for each (var o:Object in source.servers)
				{
					if (!_firstServerHost)
						_firstServerHost = o.host;
						
					mServers.push(new Server(o.host, int(o.port), Boolean(o.ssl)));
				}
				
				gameManager.storeData.deserializeSettingsData(source);
				
				gameManager.offerManager.parseOffers("offers" in source ? source["offers"] : null);
				
				if (source.hasOwnProperty("auxiliary_config_file"))
				{
					_slotConfigURI = source["auxiliary_config_file"];
				}

				if (source.hasOwnProperty("s3_assets_directory")) {
					_assetsFolderUrl = source["s3_assets_directory"];
				}
				
				if (source.hasOwnProperty("asset_index_directory")) {
					_assetIndexParent = source["asset_index_directory"];
				}
				
				_snowEnabled = 'snow' in source ? Boolean(source['snow']) : false;
				_isSuperSale = 'super_sale' in source ? Boolean(source['super_sale']) : false;
				
				_ddnaLoggingEnabled = source.hasOwnProperty('ddnaLogging') ? Boolean(source['ddnaLogging']) : false;
				
				_avatarProxyPrefix = source.hasOwnProperty("avatarProxySetting") ? String(source["avatarProxySetting"]) : "";
				
				_firstStartTutorType = 'firstStartTutorType' in source ? String(source['firstStartTutorType']) : TutorialManager.FIRST_START_TUTOR_NONE;
				//_firstStartTutorType = TutorialManager.FIRST_START_TUTOR_WIDTH_BLOCK;
				//_firstStartTutorType = TutorialManager.FIRST_START_TUTOR_WITHOUT_BLOCK;
				_firstStartTutorABEven = 'firstStartTutorABEven' in source ? Boolean(source['firstStartTutorABEven']) : false;
				
				_minigamePowerupsEnabled = 'minigamePowerupsEnabled' in source ? Boolean(source['minigamePowerupsEnabled']) : false;
				
				//_firstStartTutorABEven = true
			} 
			catch (error:Error) 
			{
				sosTrace( "error : " + error.getStackTrace(), SOSLog.WARNING);
				return false;
			}
			
			return true;
		}
		
		public function get latestVersion():String
		{
			return mLatestVersion;
		}
		
		public function get cutoffVersion():String
		{
			return _cutoffVersion != "" ? _cutoffVersion : mLatestVersion;
		}
		
		public function get comboItems():Array
		{
			return mComboItems;
		}
		
		public function get coinsItems():Array
		{
			return mCoinsItems;
		}
		
		public function get ticketsItems():Array
		{
			return mTicketsItems;
		}
		
		public function get energyItems():Array
		{
			return mEnergyItems;
		}
		
		public function get keysItems():Array
		{
			return mKeysItems;
		}

		public function get appURL():String 
		{
			return mAppUrl;
		}
		
		public function set maintenance(value:Boolean):void
		{
			if (mMaintenance != value)
			{
				mMaintenance = value;
				dispatchEventWith(MAINTENANCE_STATUS_CHANGE);
			}
		}
		
		public function get maintenance():Boolean
		{
			return mMaintenance;
		}
		
		public function set maintenanceText(value:String):void
		{
			_maintenanceText = value;
		}
		
		public function get maintenanceText():String 
		{
			return _maintenanceText;
		}
		
		public function set maintenanceTitle(value:String):void
		{
			_maintenanceTitle = value;
		}
		
		public function get maintenanceTitle():String 
		{
			return _maintenanceTitle;
		}
		
		public function get isAdmin():Boolean
		{
			return false;//_adminIds.indexOf() != -1;
		}
		
		/*
		public function get isSuperSale():Boolean
		{
			return mSuperSale;
		}*/
		
		public function get preselectAll():Boolean
		{
			return mPreselectAll;
		}
		
		public function getPreferredOrRandomServer():Server
		{
			var server:Server = null;
			
			if (mServers.length == 0)
				return null;
			
			if (mPreferredServerHost != null && mPreferredServerPort != 0) {
				for (var i:int = 0; i < mServers.length; i++) {
					server = mServers[i];
					if (server.host == mPreferredServerHost && server.port == mPreferredServerPort) {
						mServers.splice(i, 1);
						return server;
					}
				}
			}
			
			var randomIndex:int = int(Math.random() * mServers.length);
			server = mServers[randomIndex];
			mServers.splice(randomIndex, 1);
			mPreferredServerHost = server.host;
			mPreferredServerPort = server.port;
			
			return server;
		}
		
		public function get firstServerHost():String
		{
			return _firstServerHost;
		}
	}
}