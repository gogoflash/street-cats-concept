package com.alisacasino.bingo.dialogs.liveEventDialogs 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import feathers.core.FeathersControl;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class LiveEventScoreDisplay extends FeathersControl
	{
		private var _scoreValue:String
		
		public function get scoreValue():String 
		{
			return _scoreValue;
		}
		
		public function set scoreValue(value:String):void 
		{
			if (_scoreValue != value)
			{
				_scoreValue = value;
				invalidate();
			}
		}
		
		private var _scoreLabelText:String;
		
		public function get scoreLabelText():String 
		{
			return _scoreLabelText;
		}
		
		public function set scoreLabelText(value:String):void 
		{
			if (_scoreLabelText != value)
			{
				_scoreLabelText = value;
			}
			invalidate();
		}
		
		private var _iconTexture:Texture;
		private var scorePlate:Image;
		private var scoreIcon:Image;
		private var scoreLabel:XTextField;
		private var scoreValueLabel:XTextField;
		
		public function get iconTexture():Texture 
		{
			return _iconTexture;
		}
		
		public function set iconTexture(value:Texture):void 
		{
			if (_iconTexture != value)
			{
				_iconTexture = value;
				invalidate();
			}
		}
		
		public function LiveEventScoreDisplay() 
		{
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			scorePlate = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/welcome/plate"));
			addChild(scorePlate);
			
			scoreIcon = new Image(AtlasAsset.getEmptyTexture());
			scoreIcon.x = 70 * pxScale;
			scoreIcon.y = scorePlate.height / 2;
			addChild(scoreIcon);
			
			scoreLabel = new XTextField(scorePlate.width * 0.6, scorePlate.height * 0.35, XTextFieldStyle.DialogTextFieldStyle, "");
			scoreLabel.x = 120 * pxScale;
			scoreLabel.y = 4 * pxScale;
			addChild(scoreLabel);
			
			scoreValueLabel = new XTextField(scorePlate.width * 0.6, scorePlate.height * 0.45, XTextFieldStyle.DialogAlternateTextFieldStyle);
			scoreValueLabel.x = 120 * pxScale;
			scoreValueLabel.y = scorePlate.height * 0.35;
			addChild(scoreValueLabel);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				if (iconTexture)
				{
					scoreIcon.texture = iconTexture;
					scoreIcon.readjustSize();
					scoreIcon.alignPivot();
				}
				
				scoreLabel.text = scoreLabelText;
				
				scoreValueLabel.text = scoreValue;
				
			}
		}
		
	}

}