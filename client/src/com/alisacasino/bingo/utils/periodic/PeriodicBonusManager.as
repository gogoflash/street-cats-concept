/**
 * @author grdy
 * @since 5/17/17
 */
package com.alisacasino.bingo.utils.periodic {
import com.alisacasino.bingo.Game;
import com.alisacasino.bingo.models.universal.CommodityItem;
import com.alisacasino.bingo.models.universal.CommodityType;
import com.alisacasino.bingo.protocol.CommodityItemMessage;
import com.alisacasino.bingo.protocol.PeriodicBonusDataMessage;
import com.alisacasino.bingo.protocol.PlayerMessage;
import com.alisacasino.bingo.protocol.StaticDataMessage;
import com.alisacasino.bingo.screens.lobbyScreenClasses.CashBonusProgress;

public class PeriodicBonusManager 
{
    public static const PERIODIC_UPDATED:String = "PERIODIC_UPDATED";

    private var _nextTakeTime:Number;
    private var _takeInterval:Number;
    private var _prizes:Vector.<CommodityItem>;

	public function PeriodicBonusManager() {
		_prizes = new <CommodityItem>[];
	}
	
    public function get takeInterval():Number {
        return _takeInterval;
    }
	
	public function set takeInterval(value:Number):void {
        _takeInterval = value;
    }

    public function get prizes():Vector.<CommodityItem> {
        return _prizes;
    }

    public function get nextTakeTime():Number {
        return _nextTakeTime;
    }

    public function set nextTakeTime(value:Number):void {
        _nextTakeTime = value;
    }

    public function updateTakeTime(player:PlayerMessage):void {
        _nextTakeTime = player.periodicBonusTimeMillis.toNumber();

        Game.dispatchEventWith(PERIODIC_UPDATED, false, _nextTakeTime);
    }

    public function deserializeStaticData(staticData:StaticDataMessage):void {
        for each(var periodicDataMessage:PeriodicBonusDataMessage in staticData.periodicData) {
            // TODO: refactoring when type > 1
            if (periodicDataMessage.type == "hourly") {
                _takeInterval = periodicDataMessage.periodMs.toNumber();
				//_takeInterval = 10000;
                _prizes = parseCommodityItemMessages(periodicDataMessage.prizes);
            }
        }
    }

    public static function parseCommodityItemMessages(payload:Array):Vector.<CommodityItem> {
        var result:Vector.<CommodityItem> = new <CommodityItem>[];
        for each (var item:CommodityItemMessage in payload) {
            result.push(new CommodityItem(
                    CommodityType.getTypeByCommodityItemMessageType(item.type),
                    item.quantity
            ));
        }
        return result;
    }
}
}
