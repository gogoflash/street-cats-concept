package com.alisacasino.bingo.screens.lobbyScreenClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.components.AwardImageAssetContainer;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.TutorialManager;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.models.skinning.SkinningData;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class LobbyItemDropsController 
	{
		private var lobbyUI:LobbyUI;
		
		public var collectionDropItems:Vector.<CollectionItem>;
		private var collectionDropContainer:Sprite;
		private var collectionDropEffectContainer:Sprite;
		private var collectionDropEffectLeft:ParticleExplosion;
		private var collectionDropEffectRight:ParticleExplosion;
		private var collectionDropCardScale:Number = 0.68;
		private var collectionDropCardTweenDownDistance:int = 100;
		
		
		public var customizerDropItems:Vector.<CustomizerItemBase>;
		private var customizerDropContainer:Sprite;
		private var customizerDropCardScale:Number = 0.68;
		
		private var doSideMenuTweens:Boolean;
		
		public function LobbyItemDropsController(lobbyUI:LobbyUI) 
		{
			this.lobbyUI = lobbyUI;
		}
		
		public function showDrops(collectionDropItems:Vector.<CollectionItem>, customizerDropItems:Vector.<CustomizerItemBase>):void
		{
			this.collectionDropItems = collectionDropItems || new Vector.<CollectionItem>();
			this.customizerDropItems = customizerDropItems || new Vector.<CustomizerItemBase>();
			
			if (this.collectionDropItems.length > 0 && !collectionDropContainer) 
			{
				collectionDropContainer	= new Sprite();
				lobbyUI.addChildAt(collectionDropContainer, lobbyUI.getChildIndex(lobbyUI.collectionsButton));
				
				collectionDropEffectContainer = new Sprite();
				lobbyUI.addChild(collectionDropEffectContainer);
				
				collectionDropEffectLeft = new ParticleExplosion(AtlasAsset.LoadingAtlas, "misc/white_star", null, 20);
				collectionDropEffectLeft.setProperties(0, 20*pxScale, 3, -0.035, 0.0, 0, 1);
				collectionDropEffectLeft.setFineProperties(0.3, 0.6, 0.5, 1.2, 0.5, 2);
				collectionDropEffectLeft.setEmitDirectionAngleProperties(1, Math.PI, Math.PI / 2);
				collectionDropEffectContainer.addChild(collectionDropEffectLeft);
				
				collectionDropEffectRight = new ParticleExplosion(AtlasAsset.LoadingAtlas, "misc/white_star", null, 20);
				collectionDropEffectRight.setProperties(0, 20*pxScale, 3, -0.035, 0.0, 0, 1);
				collectionDropEffectRight.setFineProperties(0.3, 0.6, 0.5, 1.2, 0.5, 2);
				collectionDropEffectRight.setEmitDirectionAngleProperties(1, 0, Math.PI / 2);
				collectionDropEffectContainer.addChild(collectionDropEffectRight);
			}
			
			if(this.customizerDropItems.length > 0 && !customizerDropContainer)
			{
				customizerDropContainer	= new Sprite();
			}
		
			if(customizerDropContainer)
				Game.current.gameScreen.frontLayer.addChild(customizerDropContainer);
			
			showNextTweenCollectionDrop(0.5);
		}
		
		
		/*********************************************************************************************************
		*
		*	Collection and customizer drops
		*
		*********************************************************************************************************/
		
		private function showNextTweenCollectionDrop(delay:Number = 0):void
		{
			if (collectionDropItems.length == 0) 
			{
				if (!gameManager.tutorialManager.isCollectionStepPassed &&
					(gameManager.collectionsData.newCollectionItems.length - collectionDropItems.length > 0) &&
					!lobbyUI.gameScreen.hasSideMenu && 
					Player.current.cards.length == 0) {
					TutorialManager.TUTORIAL_HINT_COLLECTIONS_BUTTON_DELAY_CALL_ID = Starling.juggler.delayCall(lobbyUI.tutorialStepShowHandOnCollectionButton, 0.2);
				}
				
				gameManager.collectionsData.showRecentlyCollectedPageIfAny();
				
				doSideMenuTweens = !Game.current.gameScreen.sideMenuContainer.isShowing;
				showNextTweenCustomizerDrop();
				
				return;
			}
			
			var buttonTweenDownDistance:int = 13 * pxScale;
			var _collectionsButtonY:Number = lobbyUI.collectionsButtonY;
			
			if (!collectionDropContainer.mask) 
			{
				collectionDropContainer.mask = new Quad(1, 1);
			}
			
			/*var mask:Quad = new Quad(1,1);
			mask.alpha = 0.4;	
			mask.x = collectionsButton.x;
			mask.width = collectionsButton.width;
			mask.y = _collectionsButtonY - AwardImageAssetContainer.HEIGHT - cardTweenDownDistance;
			mask.height = _collectionsButtonY - mask.y + buttonTweenDownDistance;
			addChild(mask);*/
			
			SoundManager.instance.playSfx(SoundAsset.CardToCollections, delay, 0, 1, 0, true);
			
			var collectionItem:CollectionItem = collectionDropItems.shift();
			var collectionView:AwardImageAssetContainer = new AwardImageAssetContainer(collectionItem.image);
			
			collectionView.x = lobbyUI.collectionsButton.x + lobbyUI.collectionsButton.width/2;
			collectionView.y = _collectionsButtonY - AwardImageAssetContainer.HEIGHT / 2 * pxScale - collectionDropCardTweenDownDistance * pxScale * lobbyUI.collectionsButton.scale;
			collectionView.scale = 0.2*lobbyUI.collectionsButton.scale;
			collectionView.alpha = 0;
			collectionDropContainer.addChild(collectionView);
			
			var tween_0:Tween = new Tween(collectionView, 0.2, Transitions.EASE_OUT_BACK);
			var tween_1:Tween = new Tween(collectionView, 0.4, Transitions.EASE_IN);
			
			tween_0.delay = delay;
			tween_0.animate('scale', collectionDropCardScale*lobbyUI.collectionsButton.scale);
			tween_0.animate('alpha', 6);
			tween_0.nextTween = tween_1;
			
			tween_1.delay = 0.1;
			tween_1.animate('y', _collectionsButtonY + AwardImageAssetContainer.HEIGHT / 2 * pxScale + buttonTweenDownDistance);
			tween_1.onComplete = removeView;
			tween_1.onCompleteArgs = [collectionView];
			
			Starling.juggler.add(tween_0);
			
			Starling.juggler.tween(collectionView, 0.1, {delay:(delay + 0.5), alpha:0.4});
			
			var tweenButton_0:Tween = new Tween(lobbyUI.collectionsButton, 0.1, Transitions.EASE_OUT);
			var tweenButton_1:Tween = new Tween(lobbyUI.collectionsButton, 0.18, Transitions.EASE_OUT_BACK);
			
			tweenButton_0.delay = delay + 0.65;
			tweenButton_0.animate('y', _collectionsButtonY + buttonTweenDownDistance);
			tweenButton_0.nextTween = tweenButton_1;
			tweenButton_0.onUpdate = updateCollectionDropEffectContainer;
			tweenButton_0.onStart = lobbyUI.refreshCollectionsButtonNewCount;	
			tweenButton_0.onStartArgs = [gameManager.collectionsData.newCollectionItems.length - collectionDropItems.length];	
			
			tweenButton_1.animate('y', _collectionsButtonY);
			tweenButton_1.onUpdate = updateCollectionDropEffectContainer;
			
			Starling.juggler.add(tweenButton_0);
			
			//Starling.juggler.delayCall(collectionDropEffectRight.play, 0.55, 280, 20);
			//Starling.juggler.delayCall(collectionDropEffectLeft.play, 0.55, 280, 20);
			//collectionDropEffectRight.play(0, 10);
			//collectionDropEffectLeft.play(0, 10);
			
			Starling.juggler.delayCall(showNextTweenCollectionDrop, delay + 0.6, 0);
			
			updateCollectionDropEffectContainer();
		}
		
		private function updateCollectionDropEffectContainer():void {
			
			if (collectionDropContainer.mask) {
				collectionDropContainer.mask.x = lobbyUI.collectionsButton.x;
				collectionDropContainer.mask.width = lobbyUI.collectionsButton.width;
				collectionDropContainer.mask.y = lobbyUI.collectionsButton.y - AwardImageAssetContainer.HEIGHT * pxScale  - collectionDropCardTweenDownDistance * pxScale * lobbyUI.collectionsButton.scale;
				collectionDropContainer.mask.height = lobbyUI.collectionsButton.y - collectionDropContainer.mask.y;
			}
		
			collectionDropEffectContainer.x = lobbyUI.collectionsButton.x;
			collectionDropEffectContainer.y = lobbyUI.collectionsButton.y;
			
			collectionDropEffectLeft.x = lobbyUI.collectionsButton.width * (1 - collectionDropCardScale*lobbyUI.collectionsButton.scale * 0.94) / 2;
			collectionDropEffectRight.x = lobbyUI.collectionsButton.width - collectionDropEffectLeft.x;
		}
		
		private function showNextTweenCustomizerDrop(delay:Number = 0):void
		{
			if (customizerDropItems.length == 0) 
			{
				if(doSideMenuTweens)
					Game.current.gameScreen.sideMenuContainer.hideMenu(0.2, Transitions.EASE_OUT);
				return;
			}
			
			if (doSideMenuTweens)
			{
				if(!Game.current.gameScreen.sideMenuContainer.isShowing)
					Game.current.gameScreen.sideMenuContainer.showMenu(-((layoutHelper.isIPhoneX ? 355 : 400) / pxScale) * gameUILayoutScale, 0.2, Transitions.EASE_OUT);
				else
					Game.current.gameScreen.sideMenuContainer.jumpMenu(-20 * pxScale * gameUILayoutScale, 0.2);
			}
			
			SoundManager.instance.playSfx(SoundAsset.CardToCollections, delay, 0, 1, 0, true);
			
			var customizerItem:CustomizerItemBase = customizerDropItems.shift();
			var customizerView:AwardImageAssetContainer = new AwardImageAssetContainer(customizerItem.uiAsset);
			
			customizerView.x = lobbyUI.collectionsButton.x + lobbyUI.collectionsButton.width/2;
			customizerView.y = Game.current.gameScreen.sideMenuContainer.inventoryButtonPositionY;
			customizerView.scale = 0.2*layoutHelper.independentScaleFromEtalonMin;
			customizerView.alpha = 0;
			customizerDropContainer.addChild(customizerView);
			
			var tween_0:Tween = new Tween(customizerView, 0.2, Transitions.EASE_OUT_BACK);
			var tween_1:Tween = new Tween(customizerView, 0.4, Transitions.EASE_IN_BACK);
			
			tween_0.delay = delay;
			tween_0.animate('scale', customizerDropCardScale*layoutHelper.independentScaleFromEtalonMin);
			tween_0.animate('alpha', 6);
			tween_0.nextTween = tween_1;
			
			tween_1.delay = 0.1;
			tween_1.animate('x', - AwardImageAssetContainer.WIDTH / 2 * pxScale);
			tween_1.onComplete = removeView;
			tween_1.onCompleteArgs = [customizerView];
			
			Starling.juggler.add(tween_0);
			
			Starling.juggler.tween(customizerView, 0.1, {delay:(delay + 0.5), alpha:0.4});
			
			Starling.juggler.delayCall(showNextTweenCustomizerDrop, delay + 0.6, 0);
			
			gameManager.skinningData.dispatchEventWith(SkinningData.EVENT_NEW_ITEMS_CHANGE);
		}
		
		private function removeView(displayObject:DisplayObject):void
		{
			if(displayObject)
				displayObject.removeFromParent();
		}
	}

}