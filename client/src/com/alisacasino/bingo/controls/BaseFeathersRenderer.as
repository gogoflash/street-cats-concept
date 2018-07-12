package com.alisacasino.bingo.controls
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	
	import starling.events.Event;

	public class BaseFeathersRenderer extends FeathersControl implements IListItemRenderer
	{
		protected var _data:Object;
		protected var _index:int = -1;
		protected var _owner:List;
		protected var _isSelected:Boolean = false;
		
		public function BaseFeathersRenderer() {
			super();
		}
		
		//-------------------------------------------------------------------------
		//
		//  Implements:
		//
		//-------------------------------------------------------------------------
		
		public function get data():Object {
			return _data;
		}
		
		public function set data(value:Object):void {
			if (_data == value)
				return;
			
			_data = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get index():int {
			return _index;
		}
		
		public function set index(value:int):void {
			if(_index == value)
				return;
			_index = value;
			//invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get owner():List {
			return List(_owner);
		}
		
		public function set owner(value:List):void {
			if(_owner == value)
				return;
			_owner = value;
			//invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get isSelected():Boolean {
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void {
			if ( _isSelected == value ) 
				return;
			_isSelected = value;
			
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}
		
		protected var _factoryID:String;

		public function get factoryID():String
		{
			return _factoryID;
		}

		public function set factoryID(value:String):void
		{
			_factoryID = value;
		}
	}
}