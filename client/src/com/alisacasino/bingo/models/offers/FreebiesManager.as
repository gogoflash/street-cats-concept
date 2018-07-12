package com.alisacasino.bingo.models.offers 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.dialogs.ClaimBonusDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.protocol.ClaimOfferOkMessage;
	
	public class FreebiesManager 
	{
		public function FreebiesManager() 
		{
			
		}
		
		private var freebiesOfferName:String;
		
		private var isFreebiesClaimMessageSent:Boolean;
		
		private var claimedFreebiesNames:Array = [];
		
		public function clean():void
		{
			isFreebiesClaimMessageSent = false;
		}
		
		public function parseFreebies(offerString:String):void
		{
			freebiesOfferName = offerString;
		}
		
		public function parseMobileFreebies(params:Array):void
		{
			if (!params)
				return;
				
			for each (var param:String in params) {
				sosTrace( "param : " + param, SOSLog.DEBUG);
				if(param.lastIndexOf("offer_ref") != -1) {
					var offerKey:String = param.substr( param.lastIndexOf("=") + 1 );
					sosTrace( "offerKey : " + offerKey, SOSLog.DEBUG);
					var offerParts:Array = offerKey.split(/[;:]/);
					if (offerParts.length > 0)
					{
						freebiesOfferName = offerParts[0];
						sosTrace( "mGameManager.offerName : " + freebiesOfferName, SOSLog.DEBUG);
					}
					break;
				}
			}
		}
		
		public function sendFreebiesClaimMessage():void 
		{
			//freebiesOfferName = 'freebie';
			if (Game.current && Game.connectionManager && Game.current.isSignInComplete && freebiesOfferName && freebiesOfferName != '' && !isFreebiesClaimMessageSent) 
			{
				if (claimedFreebiesNames.indexOf(freebiesOfferName) == -1) {
					Game.connectionManager.sendClaimOfferMessage(freebiesOfferName);
					isFreebiesClaimMessageSent = true;
				}
			}
		}
		
		public function parseClaimOfferOk(message:ClaimOfferOkMessage):void
		{
			if (message.offerType == "coins"/* || message.offerType == "tickets" || message.offerType == "energy" || message.offerType == "keys"*/) 
			{
				DialogsManager.addDialog(new ClaimBonusDialog(ClaimBonusDialog.TYPE_FREEBIE_CLAIM, message, freebiesOfferName));
			}
		}
		
		public function claimFreebie():void 
		{
			claimedFreebiesNames.push(freebiesOfferName);
		}
	}

}