package com.alisacasino.bingo.controls 
{
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.assets.IAsset;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.loading.LoadManager;
	import feathers.controls.ImageLoader;
	import feathers.core.FeathersControl;
	import flash.utils.setTimeout;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.FragmentFilter;
	import starling.textures.Texture;
	
	[Event(name = "loaded", type = "starling.events.Event")]
	public class ImageAssetContainer extends FeathersControl 
	{
		public static const LOADED:String = "loaded";
		
		private static const STATE_NOT_INITIALIZED:uint = 0x00;
		private static const STATE_LOADING:uint = 0x01;
		private static const STATE_FAILED:uint = 0x02;
		private static const STATE_LOADED:uint = 0x03;
			
		public var asset:ImageAsset;
		protected var image:Image;
		
		//
		private var _failSkin:Object;
		
		public function get failSkin():Object 
		{
			return _failSkin;
		}
		
		public function set failSkin(value:Object):void 
		{
			if (_failSkin != value)
			{
				_failSkin = value;
				this.invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		//
		private var _loadingSkin:Object;
		
		public function get loadingSkin():Object
		{
			return _loadingSkin;
		}
		
		public function set loadingSkin(value:Object):void 
		{
			if (_loadingSkin != value)
			{
				_loadingSkin = value;
				this.invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		public var loadingStateImageFilter:FragmentFilter;
		public var keepAssetWhileRemoved:Boolean;
		
		//
		private var _source:Object;
		public function get source():Object 
		{
			return _source;
		}
		
		public function set source(value:Object):void 
		{
			if (_source != value)
			{
				removeAssetListeners();
				removeAsAssetParent();
				asset = null;
				_source = value;
				this.invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		//
		private var _state:uint;
		
		public function get state():uint 
		{
			return _state;
		}
		
		public function set state(value:uint):void 
		{
			if (_state != value)
			{
				_state = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		public function get loaded():Boolean
		{
			return state == STATE_LOADED;
		}
		
		private var _color:uint;
		private var colorSetted:Boolean;
		
		private var hAlign:String = "left";
		private var vAlign:String = "top";
		protected var currentContent:DisplayObject;
		
		private function initImage(texture:Texture):Image 
		{
			if (!image)
			{
				image = new Image(texture);
				
				if(colorSetted)
					image.color = _color;
			}
			else
			{
				image.texture = texture;
				image.readjustSize();
			}
			
			return image;
		}
		
		public function ImageAssetContainer(source:* = null, loadingSkin:* = null) 
		{
			super();
			this.source = source;
			this.loadingSkin = loadingSkin;
		}
		
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);

			if(dataInvalid)
			{
				this.commitData();
			}

			if(stateInvalid)
			{
				this.commitState();
			}
		}
		
		protected function commitState():void
		{
			switch (this.state)
			{
				case (STATE_LOADING):
					setLoading();
					break;
				case (STATE_LOADED):
					setLoaded();
					break;
				case (STATE_FAILED):
					setFailed();
					break;
			}
		}
		
		protected function commitData():void
		{
			if (this.source != null)
			{
				if (source is String)
				{
					applyAsset(LoadManager.instance.getImageAssetByName(source as String));
				}
				else if (source is Texture)
				{
					applyTexture(source as Texture);
				}
				else if (source is ImageAsset)
				{
					applyAsset(source as ImageAsset);
				}
				else
				{
					sosTrace("Could not handle source of type " + getQualifiedClassName(source), SOSLog.ERROR);
					return;
				}
			}
			else
			{
				setContent(null);
			}
		}
		
		protected function applyAsset(imageAsset:ImageAsset):void 
		{
			asset = imageAsset;
			
			state = STATE_LOADING;
			
			if (asset.loaded)
			{
				state = STATE_LOADED;
				asset.addParent(this);
			}
			else
			{
				asset.loadForParent(assetLoaded, assetFailed, this);
			}
		}
		
		public function setLoading():void
		{
			applySkin(loadingSkin);
			
			if (image && loadingStateImageFilter)
				image.filter = loadingStateImageFilter;
		}
		
		protected function applySkin(skin:Object):void 
		{
			if (skin is DisplayObject)
			{
				setContent(skin as DisplayObject);
			}
			else if (skin is Texture)
			{
				applyTexture(skin as Texture);
			}
			else
			{
				setContent(null);
			}
		}
		
		protected function applyTexture(texture:Texture):void 
		{
			setContent(initImage(texture));
		}
		
		protected function setContent(content:DisplayObject):void 
		{
			removeChildren();
			currentContent = content;
			if (content)
			{
				addChild(content);
				resizeToContent(content);
			}
		}
		
		private function resizeToContent(content:DisplayObject):void 
		{
			setSizeInternal(content.width, content.height, false);
			/*if (width != content.width)
			{
				sosTrace( "content.width : " + content.width );
				sosTrace( "width : " + width );
				//If we are hitting constraints or explicit size
				content.width = width;
			}
			if (height != content.height)
			{
				//If we are hitting constraints or explicit size
				content.height = height;
			}*/
			
			alignPivot(hAlign, vAlign);
		}
		
		protected function setLoaded():void
		{
			if (asset.texture)
			{
				if (image && image.filter)
				{
					image.filter.dispose();
					image.filter = null;
				}
				
				applyTexture(asset.texture);
				
				dispatchEvent(new Event(LOADED, true));
			}
		}
		
		protected function setFailed():void
		{
			applySkin(failSkin);
		}
		
		
		private function assetFailed():void 
		{
			this.state = STATE_FAILED;
		}
		
		private function assetLoaded():void 
		{
			this.state = STATE_LOADED;			
		}
		
		public function get color():uint 
		{
			return _color;
		}
		
		public function set color(value:uint):void 
		{
			if (_color == value)
			{
				return;
			}
			
			colorSetted = value != 0xFFFFFF;
			_color = value;
			if (image)
				image.color = value;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			removeAssetListeners();
			removeAsAssetParent();
		}
		
		private function removeAssetListeners():void 
		{
			if (asset)
			{
				asset.removeCompleteCallback(assetLoaded);
				asset.removeErrorCallback(assetFailed);
			}
		}
		
		public function setPivot(hAlign:String = "left", vAlign:String = "top"):void 
		{
			this.vAlign = vAlign;
			this.hAlign = hAlign;
			alignPivot(hAlign, vAlign);
		}
		
		override protected function feathersControl_removedFromStageHandler(event:Event):void 
		{
			super.feathersControl_removedFromStageHandler(event);
			if (!keepAssetWhileRemoved)
			{
				removeAsAssetParent();
			}
		}
		
		private function removeAsAssetParent():void 
		{
			if (asset)
			{
				sosTrace( "ImageAssetContainer.removeAsAssetParent " + asset.url, SOSLog.DEBUG);
				asset.removeParent(this);
			}
		}
	}

}