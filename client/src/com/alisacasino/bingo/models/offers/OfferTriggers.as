package com.alisacasino.bingo.models.offers 
{
	public class OfferTriggers
	{
		// По cricial value тикетов, монет, энергии, ключей 
		public static const LOW_RESOURCES:String = "LOW_RESOURCES";
		
		// При попытке купить что-то, на что не хватает ресурсов cразу
		public static const AFTER_NO_MONEY_ALERT:String = "AFTER_NO_MONEY_ALERT";
		
		// Выходит из диалогов покупки без покупки вместо предложения инвайтить друзей
		public static const BUY_DIALOG_EXIT:String = 'BUY_DIALOG_EXIT';
		
		// После сбора дейли-бонуса
		public static const HARVEST_DAILY_BONUS:String = 'HARVEST_DAILY_BONUS';
		
		// После закрытия пустого диалога с гифтами в инбоксе
		public static const EMPTY_GIFT_DIALOG_CLOSE:String = 'EMPTY_GIFT_DIALOG_CLOSE';
		
		// Когда закончились бесплатные дауб-алерты 
		public static const FREE_DAUB_ALERT_FINISHED:String = 'FREE_DAUB_ALERT_FINISHED';
		
		// Когда закончились платные дауб-алерты 
		public static const PURCHASED_DAUB_ALERT_FINISHED:String = 'PURCHASED_DAUB_ALERT_FINISHED';
		
		// После раунда
		public static const ROUND_FINISH:String = 'ROUND_FINISH';
		
		public function OfferTriggers() {
		}
	}
}

