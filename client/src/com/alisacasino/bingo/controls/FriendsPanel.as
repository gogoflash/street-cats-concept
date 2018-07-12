package com.alisacasino.bingo.controls
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.TokenList;
	
	import starling.display.Sprite;
	
	public class FriendsPanel extends FeathersControl implements IListItemRenderer
	{
		private var mFriends:Array;/*<FacebookFriend>*/
		
		private var friendCells:Array = [];
		private var _isSelected:Boolean;
		private var _index:int = -1;
		private var _owner:List;
		
		public function FriendsPanel(panelWidth:Number, panelHeight:Number)
		{
			width = minWidth = panelWidth;
			height = minHeight = panelHeight;
		}
		
		/* INTERFACE feathers.controls.renderers.IListItemRenderer */
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set index(value:int):void 
		{
			_index = value;
		}
		
		public function get owner():List 
		{
			return _owner;
		}
		
		public function set owner(value:List):void 
		{
			_owner = value;
		}
		
		public function get isSelected():Boolean 
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void 
		{
			_isSelected = value;
		}
		
		public function get data():Object
		{
			return mFriends;
		}
		
		public function set data(value:Object):void
		{
			if (mFriends != value) {
				mFriends = value as Array;
				if (value) {
					layout();
				}
			}
		}
		
		private function layout():void
		{
			this.removeChildren(0, -1, true);
			friendCells = [];
			var i:int = 0;
			for (var row:int=0; row < 5; row++) {
				for (var col:int=0; col < 4; col++) {
					
					var friend:FriendsPanelCell = new FriendsPanelCell(mFriends[i]);
					
					friend.x = minWidth / 4 * col;
					friend.y = minHeight / 5 * row;
					
					friendCells.push(friend);
					
					addChild(friend);
					i++;
				}
			}
		}
	}
}
