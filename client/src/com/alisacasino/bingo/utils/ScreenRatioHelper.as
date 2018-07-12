package com.alisacasino.bingo.utils  
{
import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import flash.events.EventPhase;
	import flash.system.System;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	
	public class ScreenRatioHelper 
	{
		public function ScreenRatioHelper() 
		{
			ratioList = new <ScreenRatioView> [];
			
			//add(1280, 960, 0x0000FF, 'Web');
			//add(2732, 2048 , 0x0000FF, 'IPad Pro');
			add(1024, 768, 0x0000FF, 'iPad 2');
			add(2048, 1536, 0xFF0000, 'Galaxy Tab S3');
			
			add(960, 640, 0xFF0000, 'iPhone 4S');
			//add(2880, 1920, 0x0000FF, 'ASUS Transformer 3');
			add(2160, 1440, 0x0000FF, 'Galaxy TabPro S');
			
			add(1280, 800, 0x0000FF, 'Kindle Fire HD 8');
			add(2560, 1600, 0x0000FF, 'Galaxy Tab S');
		
			add(800, 480, 0x0000FF, 'Nexus S');
			
			add(1024, 600, 0x0000FF, 'Kindle Fire 7');
			
			add(1280, 720, 0xFFFFFF, 'Native');
			add(1136, 640, 0x0000FF, 'iPhone 5');
			
			//add(1334, 750 , 0xFF00FF, 'iPhone 6');
			//add(1334, 750, 0x0000FF, 'iPhone 6');
			//add(2048, 1536 , 0x0000FF, 'iPad gen 7, AIR 2');
			//add(2732, 2048, 0x0000FF, 'iPad Pro');
			
			add(2960, 1440, 0x0000FF, 'Galaxy S8');
			add(2436, 1125, 0x0000FF, 'iPhone 8');
			
			
			infoTextField = new XTextField(1, 1, XTextFieldStyle.getChateaudeGarage(15, 0xFFFFFF, Align.RIGHT));
			infoTextField.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			infoTextField.alpha = 0.8;
			//add(960, 640, 0xFF0000, 'iPad 4S');
		}
		
		public static function add(resolutionHorisontal:int, resolutionVertical:int, color:uint, name:String = null):void 
		{
			ratioList.push(new ScreenRatioView(resolutionHorisontal, resolutionVertical, color, name));
		}
		
		private static var instance:ScreenRatioHelper;
		
		private static var ratioList:Vector.<ScreenRatioView>;
		private static var container:Sprite;
		private static var intervalId:int;
		private static var infoTextField:XTextField;
		
		public static function toggleSwitch():void 
		{
			if (!container || !container.parent)
				show();
			else
				close();
		}
		
		public static function show():void 
		{
			if (!instance) {
				instance = new ScreenRatioHelper();
			}
			
			if (!container) {
				container = new Sprite();
				container.touchable = false;
				container.addChild(infoTextField);
			}
			
			Starling.current.stage.addEventListener(Event.RESIZE, handler_resize);
			
			intervalId = setInterval(rechildOnTop, 1000);
			rechildOnTop();
			
			handler_resize();
		}
		
		public static function close():void 
		{
			container.removeFromParent();
			Starling.current.stage.removeEventListener(Event.RESIZE, handler_resize);
			clearInterval(intervalId);
		}
		
		private static function rechildOnTop():void 
		{
			if (Starling.current.stage.getChildIndex(container) != (Starling.current.stage.numChildren - 1)) {
				Starling.current.stage.addChild(container);
			}
		}
		
		private static function handler_resize(event:Event = null):void 
		{
			var i:int;
			var length:int = ratioList.length;
			var ratioView:ScreenRatioView;
			for (i = 0; i < length; i++ ) 
			{
				ratioView = ratioList[i];
				
				if (!ratioView.verticalLine.parent) {
					container.addChildAt(ratioView.textField, 0);
					container.addChildAt(ratioView.verticalLine, 0);
					container.addChildAt(ratioView.square, 0);
				}
				
				ratioView.verticalLine.height = Starling.current.stage.stageHeight;
				ratioView.verticalLine.x = (Starling.current.stage.stageHeight / ratioView.resolutionVertical) * ratioView.resolutionHorisontal;
				
				ratioView.textField.x = Math.min(ratioView.verticalLine.x - ratioView.textField.width - 7, Starling.current.stage.stageWidth - ratioView.textField.width - 7);
				ratioView.textField.y = Starling.current.stage.stageHeight - i * 20 - 50;
				
				ratioView.square.x = ratioView.verticalLine.x - 4;
				ratioView.square.y = ratioView.textField.y + 10;
			}
			
			infoTextField.text = 'Current: ' + Starling.current.stage.stageWidth.toString() + ', ' + Starling.current.stage.stageHeight.toString();
			infoTextField.x = Starling.current.stage.stageWidth - infoTextField.width - 3;
			infoTextField.y = Starling.current.stage.stageHeight - infoTextField.height;
			container.addChild(infoTextField);
		}
	}
}
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextFieldAutoSize;
import starling.utils.Align;

final class ScreenRatioView {
	
	public var resolutionHorisontal:int;
	public var resolutionVertical:int;
	public var color:uint;
	public var name:String;
	
	public var verticalLine:Quad;
	public var square:Quad;
	public var textField:XTextField;
	
	public function ScreenRatioView(resolutionHorisontal:int, resolutionVertical:int, color:uint, name:String = null) 
	{
		color = 0xFF0000//Math.random() * 0xFF00FF
		this.resolutionHorisontal = resolutionHorisontal;
		this.resolutionVertical = resolutionVertical;
		this.color = color;
		this.name = (name || '') + ' (' + resolutionHorisontal.toString() + ' ' + resolutionVertical.toString() + ')';
		
		verticalLine = new Quad(1, 1, color);
		//verticalLine.alpha = 0.8;
		
		square = new Quad(5, 8, color);
		square.alpha = 0.8;
		
		textField = new XTextField(350*pxScale, 30*pxScale, XTextFieldStyle.getChateaudeGarage(12, 0xFFFFFF, Align.RIGHT).setStroke(1), this.name);
		//textField.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
		textField.alpha = 0.8;
	}
}
