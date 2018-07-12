package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.loading.LoadManager;
	import com.alisacasino.bingo.objectives.IActionableObjective;
	import com.alisacasino.bingo.objectives.IProgressiveObjective;
	import com.alisacasino.bingo.objectives.Objective;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;
	import flash.utils.Dictionary;
	import starling.display.DisplayObject;
	import starling.filters.ColorMatrixFilter;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.TokenList;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ObjectiveItemRenderer extends FeathersControl implements IListItemRenderer
	{
		private var mCommonAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		private var mGameManager:GameManager = GameManager.instance;
		private var mNormalContainer:Sprite;
		private var mDoneContainer:Sprite;
		private var mNormalBack:Image;
		private var mDoneBack:Image;
		private var mNormalTitleLabel:XTextField;
		private var mDoneTitleLabel:XTextField;
		private var mRewardLabel:XTextField;
		private var mRewardCoinIcon:Image;
		private var mRewardTicketIcon:Image;
		private var mRewardEnergyIcon:Image;
		private var mRewardKeyIcon:Image;
		private var mRewardScoreIcon:Image;
		private var mRewardAmountLabel:XTextField;
		private var mDoneLabel:XTextField;
		private var mProgressLabel:XTextField;
		private var mProgressPlate:Image;
		private var mActionPlate:Image;
		private var mActionButton:XButton;
		private var mIcon:ImageAssetContainer;
		private var mCheckmark:Image;
		
		private var mOwner:List;
		private var mObjective:Objective;
		private var mIndex:int = -1;
		
		
		private const ITEM_WIDTH:Number = 730 * pxScale;
		private const ITEM_HEIGHT:Number = 144 * pxScale;
		private var _isSelected:Boolean;
		
		public function ObjectiveItemRenderer()
		{
			width = ITEM_WIDTH;
			height = ITEM_HEIGHT;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/* INTERFACE feathers.controls.renderers.IListItemRenderer */
		
		public function get isSelected():Boolean 
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void 
		{
			_isSelected = value;
		}
		
		private function onAddedToStage(e:Event):void
		{
			mNormalContainer = new Sprite();
			mNormalBack = new Image(mCommonAtlas.getTexture("dialogs/objectives/obj_plate"));
			mNormalContainer.addChild(mNormalBack);
			
			mNormalTitleLabel = new XTextField(mNormalBack.width * 0.43, mNormalBack.height * 0.4, XTextFieldStyle.ObjectiveItemTitleTextFieldStyle);
			mNormalContainer.addChild(mNormalTitleLabel);
			mNormalTitleLabel.x = 0.29 * mNormalBack.width;
			mNormalTitleLabel.y = 0.12 * mNormalBack.height;
			
			mProgressPlate = new Image(mCommonAtlas.getTexture("dialogs/objectives/obj_plate_add1"));
			mNormalContainer.addChild(mProgressPlate);
			mProgressPlate.x = mNormalBack.width - mProgressPlate.width;
			mProgressPlate.y = mNormalBack.height * 0.5 - mProgressPlate.height * 0.5;
			
			mRewardLabel = new XTextField(mNormalBack.width * 0.2, mNormalBack.height * 0.4, XTextFieldStyle.ObjectiveItemRewardTextFieldStyle, "Reward:");
			mRewardLabel.x = 0.29 * mNormalBack.width;
			mRewardLabel.y = 0.5 * mNormalBack.height;
			
			mRewardCoinIcon = new Image(mCommonAtlas.getTexture("dialogs/objectives/obj_coin"));
			mRewardCoinIcon.x = 0.49 * mNormalBack.width;
			mRewardCoinIcon.y = 0.52 * mNormalBack.height;
			
			mRewardTicketIcon = new Image(mCommonAtlas.getTexture("dialogs/objectives/obj_ticket"));
			mRewardTicketIcon.x = 0.49 * mNormalBack.width;
			mRewardTicketIcon.y = 0.52 * mNormalBack.height;

			mRewardEnergyIcon = new Image(mCommonAtlas.getTexture("dialogs/objectives/obj_energy"));
			mRewardEnergyIcon.x = 0.49 * mNormalBack.width;
			mRewardEnergyIcon.y = 0.52 * mNormalBack.height;

			mRewardKeyIcon = new Image(mCommonAtlas.getTexture("dialogs/objectives/obj_key"));
			mRewardKeyIcon.x = 0.49 * mNormalBack.width;
			mRewardKeyIcon.y = 0.52 * mNormalBack.height;

			mRewardScoreIcon = new Image(mCommonAtlas.getTexture("dialogs/objectives/obj_score"));
			mRewardScoreIcon.x = 0.49 * mNormalBack.width;
			mRewardScoreIcon.y = 0.52 * mNormalBack.height;

			mRewardAmountLabel = new XTextField(mNormalBack.width * 0.1, mNormalBack.height * 0.4, XTextFieldStyle.ObjectiveItemRewardTextFieldStyle);
			mRewardAmountLabel.x = 0.58 * mNormalBack.width;
			mRewardAmountLabel.y = 0.5 * mNormalBack.height;
			
			mProgressLabel = new XTextField(mNormalBack.width * 0.2, mNormalBack.height * 0.35, XTextFieldStyle.ObjectiveItemProgressTextFieldStyle);
			mNormalContainer.addChild(mProgressLabel);
			mProgressLabel.x = 0.78 * mNormalBack.width;
			mProgressLabel.y = mNormalBack.height - mProgressLabel.height >> 1;
			
			mActionPlate = new Image(mCommonAtlas.getTexture("dialogs/objectives/obj_plate_add2"));
			mNormalContainer.addChild(mActionPlate);
			mActionPlate.x = mNormalBack.width - mActionPlate.width;
			mActionPlate.y = mNormalBack.height * 0.5 - mActionPlate.height * 0.5;
			
			mActionButton = new XButton(XButtonStyle.ObjectiveItemButtonStyle);
			mNormalContainer.addChild(mActionButton);
			mActionButton.x = mActionPlate.x + (mActionPlate.width - mActionButton.width >> 1);
			mActionButton.y = mNormalBack.height * 0.5 - mActionButton.height * 0.5;
			mActionButton.addEventListener(Event.TRIGGERED, performAction);
			
			mDoneContainer = new Sprite();
			mDoneBack = new Image(mCommonAtlas.getTexture("dialogs/objectives/plate_done"));
			mDoneContainer.addChild(mDoneBack);
			
			mDoneTitleLabel = new XTextField(mNormalBack.width * 0.43, mNormalBack.height * 0.4, XTextFieldStyle.ObjectiveItemTitleDoneTextFieldStyle);
			mDoneContainer.addChild(mDoneTitleLabel);
			mDoneTitleLabel.x = 0.29 * mNormalBack.width;
			mDoneTitleLabel.y = 0.12 * mNormalBack.height;
			
			mDoneLabel = new XTextField(mNormalBack.width * 0.2, mNormalBack.height * 0.4, XTextFieldStyle.ObjectiveItemDoneTextFieldStyle, Constants.DONE_LABEL);
			mDoneContainer.addChild(mDoneLabel);
			mDoneLabel.x = 0.29 * mNormalBack.width;
			mDoneLabel.y = 0.5 * mNormalBack.height;
			
			mCheckmark = new Image(mCommonAtlas.getTexture("dialogs/objectives/v"));
			mDoneContainer.addChild(mCheckmark);
			mCheckmark.pivotX = mCheckmark.width >> 1;
			mCheckmark.pivotY = mCheckmark.height >> 1;
			mCheckmark.x = 0.88 * mDoneBack.width;
			mCheckmark.y = mDoneBack.height >> 1;

			addChild(mNormalContainer);
			addChild(mDoneContainer);

			addChild(mRewardLabel);
			addChild(mRewardCoinIcon);
			addChild(mRewardTicketIcon);
			addChild(mRewardEnergyIcon);
			addChild(mRewardKeyIcon);
			addChild(mRewardScoreIcon);
			addChild(mRewardAmountLabel);
		}
		
		private function layout():void
		{
			
			mNormalTitleLabel.text = mObjective.description;
			mDoneTitleLabel.text = mObjective.description;
			
			mDoneContainer.visible = mDoneLabel.visible = mObjective.isCompleted;
			
			mNormalContainer.visible = mRewardAmountLabel.visible = mRewardLabel.visible = !mObjective.isCompleted;
			
			var rewards:Dictionary = new Dictionary(true); 
			rewards[mRewardCoinIcon] = mObjective.rewardCoins;
			rewards[mRewardTicketIcon] = mObjective.rewardTickets;
			rewards[mRewardEnergyIcon] = mObjective.rewardEnergy;
			rewards[mRewardKeyIcon] = mObjective.rewardKeys;
			rewards[mRewardScoreIcon] = mObjective.rewardScore;
			
			for(var keyItem:DisplayObject in rewards)
			{
				keyItem.visible = false;
			}
			
			if (!mObjective.isCompleted) {
				var isActionableObjective:Boolean = mObjective is IActionableObjective;
				mActionPlate.visible = mActionButton.visible = isActionableObjective;
				mProgressPlate.visible = !isActionableObjective;
				
				if (isActionableObjective) {
					mActionButton.text = (mObjective as IActionableObjective).actionName;
					mProgressLabel.text = "";
				} 
				else if(mObjective is IProgressiveObjective) {
					var progressiveObjective:IProgressiveObjective = mObjective as IProgressiveObjective;
					mProgressLabel.text = progressiveObjective.progressCount + "/" + progressiveObjective.progressTotal;
				}

				for(keyItem in rewards)
				{
					if (rewards[keyItem] > 0)
					{
						keyItem.visible = true;
						mRewardAmountLabel.numValue = rewards[keyItem];
						break;
					}
				}
				
				mRewardLabel.visible = mRewardAmountLabel.visible = mRewardAmountLabel.numValue > 0;
			}
			
			if (mIcon) {
				mIcon.removeFromParent();
			}
			mIcon = new ImageAssetContainer();
			mIcon.loadingSkin = LoadManager.instance.getImageAssetByName("objectives/bingo1").texture;
			mIcon.failSkin = LoadManager.instance.getImageAssetByName("objectives/bingo1").texture;
			mIcon.loadingStateImageFilter = new ColorMatrixFilter();
			(mIcon.loadingStateImageFilter as ColorMatrixFilter).adjustSaturation(-1);
			(mIcon.loadingStateImageFilter as ColorMatrixFilter).adjustBrightness(0.2);
			mIcon.source = mObjective.getImagePath();
			mIcon.x = 12 * pxScale;
			mIcon.y = 2 * pxScale;
			addChild(mIcon);
			
			mObjective.removeEventListeners();
			mObjective.addEventListener(Objective.OBJECTIVE_COMPLETED_EVENT, onObjectiveCompleted);
		}
		
		private function performAction(e:Event):void
		{
			if (mObjective != null &&
				mOwner.isEnabled &&
				mObjective.isCompleted == false && 
				mObjective is IActionableObjective) {
				mOwner.isEnabled = false;
				(mObjective as IActionableObjective).performAction();
				if (Starling.juggler)
				{
					Starling.juggler.delayCall(reEnableOwner, 2);
				}
			}
		}
		
		private function reEnableOwner():void 
		{
			if (mOwner)
			{
				mOwner.isEnabled = true;
			}
		}
		
		private function onObjectiveCompleted():void
		{
			Starling.juggler.tween(mNormalContainer, 0.3, {
				onComplete: function():void { mNormalContainer.visible = false; mNormalContainer.alpha = 1.0; },
				alpha: 0
			});
			
			mDoneContainer.visible = true;
			mDoneContainer.alpha = 0;
			Starling.juggler.tween(mDoneContainer, 0.3, {
				alpha: 1.0
			});
			
			mCheckmark.alpha = 0.0;
			mCheckmark.scaleY = 0.0;
			Starling.juggler.tween(mCheckmark, 0.3, {
				transition: Transitions.EASE_OUT_BACK,
				alpha: 1.0,
				scaleY: 1.0,
				delay: 0.1
			});
			
			Starling.juggler.tween(mIcon, 0.15, {
				transition: Transitions.EASE_OUT_BACK,
				scaleX: 1.1,
				scaleY: 1.1,
				onComplete: function():void {
					Starling.juggler.tween(mIcon, 0.15, {
						scaleX: 1.0,
						scaleY: 1.0
					});
				}
			});
		}
		
		public function get data():Object
		{
			return mObjective;
		}
		
		public function set data(value:Object):void
		{
			if (mObjective != value) {
				mObjective = value as Objective;
				if (value) layout();
			}
		}
		
		public function get index():int
		{
			return mIndex;
		}
		
		public function set index(value:int):void
		{
			mIndex = value;
		}
		
		public function get owner():List
		{
			return mOwner;
		}
		
		public function set owner(value:List):void
		{
			mOwner = value;
		}
		
		protected var _factoryID:String;

		public function get factoryID():String {
			return _factoryID;
		}

		public function set factoryID(value:String):void {
			_factoryID = value;
		}
	}
}