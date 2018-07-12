/**
 * Created by grdy on 8/15/17.
 */
package com.alisacasino.bingo.models.notification {
import com.alisacasino.bingo.platform.PlatformServices;
import com.alisacasino.bingo.protocol.StaticDataMessage;

public class PushData {
	private var iosText:Object;
	private var androidText:Object;
    public static const PUSH_TITLE:String = "Arena Bingo!";
    public static const CHEST_PUSH_ID:int = 10;
    public static const RETENTION_PUSH_ID:int = 100;

    public var cashBonusPush:String = "cashBonusPush"; 
    public var chestOpenedPush:String = "chestOpenedPush";
    public var chestOpenedIdlePush:String = "chestOpenedIdlePush";
    public var retentionThreePush:String = "retentionThreePush";
    public var retentionWeekPush:String = "retentionWeekPush";
    public var retentionTwoWeekPush:String = "retentionTwoWeekPush";
    public var retentionOneDayPush:String = "retentionOneDayPush";
    public var retentionOneMonthPush:String = "retentionOneMonthPush";
	
	public function PushData() 
	{
		super();
		iosText = { };
		iosText[cashBonusPush] = "\ud83d\udc9c Free Cash Bonus ready! \ud83d\udcb0 Go grab it!";
		iosText[chestOpenedPush] = "\ud83d\udd13 Chest unlocked! \u2705​ Hurry up!";
		iosText[chestOpenedIdlePush] = "\u26A0 You left an unopened Chest in game";
		iosText[retentionThreePush] = "\ud83d\ude40 Good heavens, just look at the time - it's BINGO TIME!";
		iosText[retentionWeekPush] = "\ud83c\udfb2 All your friends are scoring Bingos - what about you? \ud83c\udfaf";
		iosText[retentionTwoWeekPush] = "\ud83c\udf08 We know you wanna BINGO! \ud83d\ude0e Come back to us!";
		iosText[retentionOneDayPush] = "\ud83d\ude3c Playing Bingo yesterday was fun, right? \ud83d\udcab\n\ud83d\udc99 Why not come and play our game again? \ud83d\ude01";
		iosText[retentionOneMonthPush] = "\ud83d\ude05 It’s been almost a month now... \ud83d\ude3f\n\ud83d\ude3e Come on, log in and play BINGO! \ud83d\udca2";
		
		androidText = { };
		androidText[cashBonusPush] = "Free Cash Bonus ready! Go grab it!";
		androidText[chestOpenedPush] = "Chest unlocked! Hurry up!";
		androidText[chestOpenedIdlePush] = "You left an unopened Chest in game";
		androidText[retentionThreePush] = "Good heavens, just look at the time - it's BINGO TIME!";
		androidText[retentionWeekPush] = "All your friends are scoring Bingos - what about you?";
		androidText[retentionTwoWeekPush] = "We know you wanna BINGO! Come back to us!";
		androidText[retentionOneDayPush] = "Playing Bingo yesterday was fun, right?\nWhy not come and play our game again?";
		androidText[retentionOneMonthPush] = "It’s been almost a month now...\nCome on, log in and play some more BINGO!";
	}

    public function deserializeStaticData(staticData:StaticDataMessage):void {
    }
	
	public function getChestOpenedIdlePush():String
	{
		return getTextObject()[chestOpenedIdlePush];
	}
	
	public function getChestOpenedPush():String 
	{
		return getTextObject()[chestOpenedPush];
	}
	
	public function getCashBonusPush():String 
	{
		return getTextObject()[cashBonusPush];
	}
	
	public function getRetentionThreeDaysPush():String 
	{
		return getTextObject()[retentionThreePush];
	}
	
	public function getRetentionWeekPush():String 
	{
		return getTextObject()[retentionWeekPush];
	}
	
	public function getPushMessage(key:String):String
	{
		return getTextObject()[key];
	}
	
	public function getRetentionTwoWeekPush():String 
	{
		return getPushMessage(retentionTwoWeekPush);
	}
	
	public function getRetentionOneDayPush():String 
	{
		return getPushMessage(retentionOneDayPush);
	}
	
	public function getRetentionOneMonthPush():String 
	{
		return getPushMessage(retentionOneMonthPush);
	}
	
	private function getTextObject():Object
	{
		return PlatformServices.isIOS ? iosText : androidText;
	}
}
}
