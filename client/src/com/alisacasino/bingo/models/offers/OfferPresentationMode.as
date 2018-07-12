package com.alisacasino.bingo.models.offers 
{
	public class OfferPresentationMode 
	{
		public function OfferPresentationMode() {
		}
		
		public static const BADGE_LOBBY					:uint = 1 << 0;
		public static const BADGE_STORE_BTN				:uint = 1 << 1;
		
		public static const STORE_BTN_CROSS_RIBBON_SALE	:uint = 1 << 2;
		public static const STORE_BTN_CROSS_RIBBON_NEW	:uint = 1 << 3;
		public static const STORE_BTN_CROSS_RIBBON_FREE	:uint = 1 << 4;
		
		public static const STORE_BTN_BOTTOM_RIBBON		:uint = 1 << 5;
		
		public static const SESSION_SINGLE_SHOW			:uint = 1 << 6;
		
		//public static const STORE_MENU_ITEM				:uint = 1 << 2;
		
		public static function check(value:uint, flag:uint):Boolean 
		{
			return (value & flag) > 0;
		}
		
		public static function get STORE_BTN_CROSS_RIBBONS_FLAGS():uint 
		{
			return STORE_BTN_CROSS_RIBBON_SALE | STORE_BTN_CROSS_RIBBON_NEW | STORE_BTN_CROSS_RIBBON_FREE | STORE_BTN_BOTTOM_RIBBON;
		}
	}

}