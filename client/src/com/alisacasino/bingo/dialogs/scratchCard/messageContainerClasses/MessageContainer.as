package com.alisacasino.bingo.dialogs.scratchCard.messageContainerClasses 
{
	import com.alisacasino.bingo.dialogs.scratchCard.messageContainerClasses.PromptMessage;
	import com.alisacasino.bingo.dialogs.scratchCard.messageContainerClasses.TryAgainMessage;
	import com.alisacasino.bingo.dialogs.scratchCard.messageContainerClasses.TutorialMessage;
	import feathers.core.FeathersControl;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class MessageContainer extends FeathersControl
	{
		private var tutorialMessage:TutorialMessage;
		private var tryAgainMessage:TryAgainMessage;
		private var promptMessage:PromptMessage;
		private var invitationMessage:InvitationMessage;
		
		public function MessageContainer() 
		{
			touchable = false;
		}
		
		public function showPrompt():void 
		{
			hideAllMessages();
			
			if (!promptMessage)
			{
				promptMessage = new PromptMessage();
				promptMessage.setSize(width, height);
			}
			
			addChild(promptMessage);
		}
		
		public function hideAllMessages():void 
		{
			hidePrompt();
			hideTutorial();
			hideTryAgainMessage();
			hideInvitationMessage();
		}
		
		public function hidePrompt():void 
		{
			if (promptMessage)
			{
				promptMessage.removeFromParent();
			}
		}
		
		public function showTutorial():void 
		{
			hideAllMessages();
			
			if (!tutorialMessage)
			{
				tutorialMessage = new TutorialMessage();
				tutorialMessage.setSize(width, height);
			}
			addChild(tutorialMessage);
			
		}
		
		public function hideTutorial():void
		{
			if (tutorialMessage)
			{
				tutorialMessage.removeFromParent();
			}
		}
		
		public function showTryAgainMessage():void 
		{
			hideAllMessages();
			
			if (!tryAgainMessage)
			{
				tryAgainMessage = new TryAgainMessage();
				tryAgainMessage.setSize(width, height);
			}
			addChild(tryAgainMessage);
			
			tryAgainMessage.animate();
		}
		
		public function hideTryAgainMessage():void 
		{
			if (tryAgainMessage)
			{
				tryAgainMessage.stop();
				tryAgainMessage.removeFromParent();
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			if (tryAgainMessage)
			{
				tryAgainMessage.dispose();
			}
		}
		
		public function showInvitationMessage():void 
		{
			hideAllMessages();
			
			if (!invitationMessage)
			{
				invitationMessage = new InvitationMessage();
				invitationMessage.setSize(width, height);
			}
			addChild(invitationMessage);
		}
		
		public function hideInvitationMessage():void 
		{
			if (invitationMessage)
			{
				invitationMessage.removeFromParent();
			}
		}
		
	}

}