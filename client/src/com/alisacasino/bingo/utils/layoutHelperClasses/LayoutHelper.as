package com.alisacasino.bingo.utils.layoutHelperClasses 
{
	import com.alisacasino.bingo.dialogs.ServiceDialog;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.DeviceOrientation;
	import com.alisacasino.bingo.utils.IPhoneModelDecoder;
	import flash.system.Capabilities;
	import starling.core.Starling;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class LayoutHelper 
	{
		public static const ORIGINAL_WIDTH:uint = 1280;
		public static const ORIGINAL_HEIGHT:uint = 720;
		public static const ORIGINAL_RATIO:Number = ORIGINAL_HEIGHT / ORIGINAL_WIDTH;
		
		private static const ASSET_MODE_BIG:Number = 720;
		private static const ASSET_MODE_SMALL:Number = 480;
		
		static public const CANVAS_MODE:String = "canvasMode";
		static public const TABLET_MODE:String = "tabletMode";
		static public const PHONE_MODE:String = "phoneMode";
		
		public static var LARGE_SCREEN_DIAGONAL:Number = 6.5;
		
		public static var ALIGNING_TYPE_AUTO:String = 'ALIGNING_TYPE_AUTO';
		public static var ALIGNING_TYPE_MOBILE:String = 'ALIGNING_TYPE_MOBILE';
		public static var ALIGNING_TYPE_TABLET:String = 'ALIGNING_TYPE_TABLET';
		
		private var aligningType:String = 'ALIGNING_TYPE_AUTO';
		
		private var mStageWidth:Number;
		private var mStageHeight:Number;
		private var mAssetMode:Number;
		private var mRealScreenWidth:Number;
		private var mRealScreenHeight:Number;
		private var mIsLargeScreen:Boolean;
		
		private var mScaleFromEtalonMin:Number;
		private var _scaleFromEtalon:Number = 1;
		private var _independentScaleFromEtalonMin:Number;
		
		private var _contentScaleFactorCoefficient:Number = 1; 
		
		private static const phoneTest:Boolean = false;
		
		public var CANVAS_MAX_SCALE:Number = 1.15;
		public var canvasExtraScale:Number = 1;
		
		public function LayoutHelper() 
		{
			
		}
		
		public function initScreen(width:Number = Constants.STAGE_START_WIDTH, height:Number = Constants.STAGE_START_HEIGHT):void
		{
			LARGE_SCREEN_DIAGONAL = canvasLayoutMode ? 14.7 : 6;
			
			cachedScale = -1;
			if (width > height) {
				mRealScreenWidth = width;
				mRealScreenHeight = height;
			} else {
				mRealScreenWidth = height;
				mRealScreenHeight = width;
			}
		
			if (canvasLayoutMode) {
				mStageWidth = mRealScreenWidth;
				mStageHeight = mRealScreenHeight;
				
				mAssetMode = ASSET_MODE_BIG;
                //mAssetMode = ASSET_MODE_SMALL;
				
				mScaleFromEtalonMin = Math.min(mRealScreenWidth / stageEtalonWidth, mRealScreenHeight / stageEtalonHeight);
				_scaleFromEtalon = Math.min(mRealScreenWidth / stageEtalonWidth, mRealScreenHeight / stageEtalonHeight);
				
				if (Starling.contentScaleFactor <= 1.2)
					_contentScaleFactorCoefficient = 1;
				else if(Starling.contentScaleFactor <= 2.2)	
					_contentScaleFactorCoefficient = 0.8;
				else
					_contentScaleFactorCoefficient = 0.7;
					
				var canvasMaxScale:Number = CANVAS_MAX_SCALE * _contentScaleFactorCoefficient;	
				
				if (_scaleFromEtalon <= canvasMaxScale)
				{
					_independentScaleFromEtalonMin = mScaleFromEtalonMin;
					canvasExtraScale = 1;
				}
				else
				{
					canvasExtraScale = canvasMaxScale / mScaleFromEtalonMin;
					
					mScaleFromEtalonMin = canvasMaxScale;
					_scaleFromEtalon = canvasMaxScale;
					_independentScaleFromEtalonMin = canvasMaxScale;
				}
				
				//trace('independentScaleFromEtalonMin', _independentScaleFromEtalonMin);
				
			} else 
			{

				var needToForce480:Boolean = IPhoneModelDecoder.needToForce480(PlatformServices.interceptor.getDeviceModelRaw());
				needToForce480 ||= phoneTest;
				mScaleFromEtalonMin = Math.min(mRealScreenWidth / stageEtalonWidth, mRealScreenHeight / stageEtalonHeight);
				
				if (mRealScreenHeight >= 720.0 && !needToForce480) {
					mStageWidth = mRealScreenWidth * 720 / mRealScreenHeight;
					mStageHeight = 720;
					
					mAssetMode = ASSET_MODE_BIG;
				} else {
					mStageWidth = mRealScreenWidth * 480 / mRealScreenHeight;
					mStageHeight = 480;
					
					mAssetMode = ASSET_MODE_SMALL;
				}
				
				mScaleFromEtalonMin = 1;
				_scaleFromEtalon = Math.min(mRealScreenWidth / stageEtalonWidth, mRealScreenHeight / stageEtalonHeight);
				_independentScaleFromEtalonMin = Math.min(mStageWidth / stageEtalonWidth, mStageHeight / stageEtalonHeight);
			}
			
			//trace('_independentScaleFromEtalonMin ', _independentScaleFromEtalonMin, scaleFromEtalonMin);	
				
			if (aligningType == ALIGNING_TYPE_AUTO) 
			{
				if (PlatformServices.interceptor.isIphone)
					mIsLargeScreen = false;
				else	
					mIsLargeScreen = screenDiagonalInches > LARGE_SCREEN_DIAGONAL;
			}
			else if (aligningType == ALIGNING_TYPE_MOBILE)	{
				mIsLargeScreen = false;
			}	
			else if (aligningType == ALIGNING_TYPE_TABLET)	{
				mIsLargeScreen = true;	
			}
				
			//mIsLargeScreen = false;
		
			trace('screenDiagonalInches ', screenDiagonalInches, ' mIsLargeScreen ', mIsLargeScreen, width, height);
		}
		
		public function get layoutMode():String
		{
			if (phoneTest)
				return PHONE_MODE;
			//return PHONE_MODE;
			
			if (PlatformServices.isCanvas)
				return CANVAS_MODE;
			
			if (isLargeScreen)
				return TABLET_MODE
			
			return PHONE_MODE;
		}
		
		public function get canvasLayoutMode():Boolean
		{
			return layoutMode == CANVAS_MODE;
		}
		
		public function get tabletLayoutMode():Boolean
		{
			return layoutMode == TABLET_MODE;
		}
		
		public function get phoneLayoutMode():Boolean
		{
			return layoutMode == PHONE_MODE;
		}
		
		public function get screenRatio():Number
		{
			return mRealScreenHeight/mRealScreenWidth;
		}
		
		
		public function get realScreenWidth():Number
		{
			return mRealScreenWidth;
		}
		
		private const KINDLE_FIRE_BOTTOM_BAR_HEIGHT:Number = 20.0;
		public function get realScreenHeight():Number
		{
			if (isKindleFire1)
				return mRealScreenHeight - KINDLE_FIRE_BOTTOM_BAR_HEIGHT;
			else
				return mRealScreenHeight;
		}
		
		public function get stageWidth():Number
		{
			return mStageWidth;
		}
		
		public function get stageHeight():Number
		{
			return mStageHeight;
		}
		
		public function get assetMode():Number
		{
			return mAssetMode;
		}
		
		public function get isBigAssetMode():Boolean
		{
			return mAssetMode == ASSET_MODE_BIG;
		}
		
		public function get isLargeScreen():Boolean
		{
			return mIsLargeScreen;
		}
		
		
		private var cachedScale:Number = -1;
		
		public function get pxScale():Number
		{
			if (cachedScale == -1)
			{
				cachedScale = stageEtalonHeight / 720;
			}
			return cachedScale;
		}
		
		public function get scaleFromEtalonMin():Number {
			return mScaleFromEtalonMin;
		}
		
		public function get scaleFromEtalon():Number {
			return _scaleFromEtalon;
		}
		
		public function get independentScaleFromEtalonMin():Number {
			return _independentScaleFromEtalonMin;
		}
		
		public function get useCanvasExtraScale():Boolean {
			return canvasExtraScale != 1 && layoutMode == CANVAS_MODE;
		}
		
		public function get contentScaleFactorCoefficient():Number {
			return _contentScaleFactorCoefficient;
		}
		
		/* следующие 2 метода - определяют эталонные размеры: ширину и высоту.
			"эталонный размер" - это размер относительно которого выполняется scale.
			
			При определении эталонных размеров учитывается т.н. assetCoefficient.
			В режиме больших эссетов assetCoefficient == 1.5. Это так потому, что эталонная высота - 480 - соответствует 
			малому режиму эссетов на устройствах (изначально игра писалась для устройств, а в последствии уже для PC). 
			И малые эссеты уменьшаются в TexturePacker в 1.5 раза.
			Поэтому, в режиме больших эссетов мы увеличиваем эталонные размеры в 1.5 раза, чтобы scale коэффициенты были мешьше 
			в 1.5 раза в режиме больших эссетов по савнению с режимом малых эссетов. 
		*/
		public function get stageEtalonWidth():Number {
			return 854 * assetCoefficient;
		}
		public function get stageEtalonHeight():Number {
			return 480 * assetCoefficient;
		}
		
		public function get assetCoefficient():Number {
			return assetMode == ASSET_MODE_BIG ? 1.5 : 1;
		}
		
		private static const BAR_MAX_SCALE:Number = 1.0;
		private static const BAR_MIN_SCALE:Number = 0.7;
		private static const BAR_MIN_SCALE_LARGE_SCREENS:Number = 0.65;
		private static const MIN_RATIO:Number = 1.33;
		private static const MAX_RATIO:Number = 1.77;
		
		public function get barScale():Number
		{
			var ratio:Number = mStageWidth / mStageHeight;
			var minScale:Number = mIsLargeScreen ? BAR_MIN_SCALE_LARGE_SCREENS : BAR_MIN_SCALE;
			
			var scale:Number = Math.max( minScale, Math.min( BAR_MAX_SCALE,
					((BAR_MAX_SCALE - minScale) * ratio + minScale * MAX_RATIO - BAR_MAX_SCALE * MIN_RATIO) / (MAX_RATIO - MIN_RATIO) ));
			
			if (!isLargeScreen) {
				return scale;
			} else {
				if (canvasLayoutMode)
				{
					return 0.8 * mScaleFromEtalonMin;
				}
				else 
				{
					return Math.min(0.8, scale);
				}
			}
		}
		
		public function get newBarScale():Number
		{
			return independentScaleFromEtalonMin;
			
			var ratio:Number = mStageWidth / mStageHeight;
			var scale:Number = (mStageWidth / 1280 / pxScale + mStageHeight / 720 / pxScale) / 2;
			return Math.min(1.2 , Math.max(0.3, scale));
			
			/*var ratio:Number = mRealScreenWidth / mRealScreenHeight;
			var scale:Number = (mRealScreenWidth / 1280 + mRealScreenHeight / 720) / 2;
			return Math.min(1.2 ,Math.max(0.3, scale));*/
		}
		
		public function get dialogScaleWOscreenScale():Number {
            //return 1.0;
			if (mIsLargeScreen)
				return 0.8;
			else
				return 1.0;
		}
		
		public function get dialogScale():Number
		{
			return dialogScaleWOscreenScale * mScaleFromEtalonMin;
		}
		
		public function get isKindleFire1():Boolean
		{
			return PlatformServices.isAndroid && Constants.isAmazonBuild && mRealScreenHeight == 600;
		}
		
		public function get isIPhoneX():Boolean
		{
			return IPhoneModelDecoder.isIPhoneX(PlatformServices.interceptor.getDeviceModel()) || ServiceDialog.isDebugIPhoneXFrame;
		}
		
		public function get isIPhoneXOrientationRight():Boolean
		{
			if (ServiceDialog.isDebugIPhoneXFrame)
				return ServiceDialog.isIPhoneXOrientationRight;
				
			return isIPhoneX && PlatformServices.interceptor.deviceOrientation == DeviceOrientation.ROTATED_RIGHT;
		}
		
		public function get isIPhoneXOrientationLeft():Boolean
		{
			if (ServiceDialog.isDebugIPhoneXFrame)
				return ServiceDialog.isIPhoneXOrientationLeft;
		
			return isIPhoneX && PlatformServices.interceptor.deviceOrientation == DeviceOrientation.ROTATED_LEFT;
		}

		public function get screenDiagonalInches():Number
		{
			var screenWidthInches:Number = mRealScreenWidth / Capabilities.screenDPI;
			var screenHeightInches:Number = mRealScreenHeight / Capabilities.screenDPI;
			return Math.sqrt(screenWidthInches * screenWidthInches + screenHeightInches * screenHeightInches);
		}
		
		public function setAligningType(type:String):void 
		{
			aligningType = type;
		}
		
	}

}