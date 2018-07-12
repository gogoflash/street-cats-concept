package com.alisacasino.bingo.protocol.ErrorMessage {
	public final class ErrorCode {
		public static const DefaultError:int = 0;
		public static const SignInError:int = 1;
		public static const JoinError:int = 2;
		public static const BuyCardsError:int = 3;
		public static const PlayerUpdateFailed:int = 4;
		public static const NotAuthorized:int = 5;
		public static const ServerNotActive:int = 6;
		public static const NotActivePlayerError:int = 7;
		public static const OfferAlreadyClaimedError:int = 8;
		public static const OfferExpiredError:int = 9;
	}
}
