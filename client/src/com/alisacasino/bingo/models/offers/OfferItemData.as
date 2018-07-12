package com.alisacasino.bingo.models.offers 
{
	import com.alisacasino.bingo.protocol.Type;
	
	public class OfferItemData
	{
		private var _count:int;
		private var _type:int;
		
		public function OfferItemData(type:int, count:int) {
			_type = type;
			_count = count;
		}
		
		public function get type():int {
			return _type;
		}
		
		public function get count():int {
			return _count;
		}
		
		public function get image():String {
			switch(_type) {
				case Type.CASH: return "bars/cash";
				//case Type.TICKET: return "bars/tickets";
				case Type.ENERGY: return "bars/energy";
				/*case Type.KEY: return "bars/key";
				case Type.SLOT_MACHINE_SPIN_0:
				case Type.SLOT_MACHINE_SPIN_1:
				case Type.SLOT_MACHINE_SPIN_2:
				case Type.SLOT_MACHINE_SPIN_3:
				case Type.SLOT_MACHINE_SPIN_4: return "bars/alisa";
				case Type.DAUB_HINT: return "bars/daub_hint";//"daub_hint/daub_hint_icon";*/
			}
			
			return "bars/exp";
		}
	}
}