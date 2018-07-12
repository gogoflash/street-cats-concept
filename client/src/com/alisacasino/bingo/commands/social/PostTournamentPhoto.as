package com.alisacasino.bingo.commands.social 
{
	import by.blooddy.crypto.image.JPEGEncoder;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.controls.SharingScreenBlock;
	import com.alisacasino.bingo.utils.ScreenshotUtils;
	import com.jonas.net.Multipart;
	import com.leeburrows.encoders.AsyncJPGEncoder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class PostTournamentPhoto extends CommandBase
	{
		[Embed(source = "../../tourney_share.png")]
		private static var shareFrameClass:Class;
		
		private var stageBD:BitmapData;
		private var accessToken:String;
		private var ssb:SharingScreenBlock;
		private var place:uint;
		
		
		public function PostTournamentPhoto(accessToken:String, place:uint) 
		{
			this.place = place;
			this.accessToken = accessToken;
			
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			stageBD = ScreenshotUtils.drawStageToBD();
			ssb = SharingScreenBlock.show();
			ssb.addEventListener(Event.COMPLETE, ssb_completeHandler);
		}
		
		private function ssb_completeHandler(e:Event):void 
		{
			Starling.juggler.delayCall(startEnconding, 0.2);
		}
		
		private function startEnconding():void 
		{
			var resultBitmapData:BitmapData = frameStageBD();
			
			
			var multipart:Multipart = new Multipart("https://graph.facebook.com/v2.10/me/photos" +
					"?access_token=" + accessToken);
					
			var caption:String = 'Awesome!!! I just scored #' + place.toString() + ' Place in an Arena Bingo Tournament! https://apps.facebook.com/arenabingo/';
			
			multipart.addField("caption", caption);

			multipart.addFile("source", JPEGEncoder.encode(resultBitmapData, 90), "image/jpeg", "tournament_end.jpg");
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
			var request : URLRequest = multipart.request;
			loader.load(request);
			SharingScreenBlock.removeIfAny();
			finish();
		}
		
		private function frameStageBD():BitmapData
		{
			var frame:Bitmap =  new shareFrameClass();
			
			var result:BitmapData = new BitmapData(frame.width, frame.height);
			
			var stageWidth:Number = stageBD.width;
			var stageHeight:Number = stageBD.height;
			
			var scale:Number = 1;
			
			scale = Math.max(780 / stageWidth, 720 / stageHeight);
			
			var tx:Number = (frame.width - stageWidth * scale) / 2;
			var ty:Number = (frame.height - stageHeight * scale) / 2;
			
			var mtx:Matrix = new Matrix();
			mtx.scale(scale, scale);
			mtx.translate(tx, ty);
			
			result.draw(stageBD, mtx, null, null, null, true);
			
			result.copyPixels(frame.bitmapData, new Rectangle(0, 0, frame.width, frame.height), new Point(0, 0), null, null, true);
			return result;
		}
		
		private function revertSSB():void 
		{
			if (ssb)
			{
				ssb.visible = true;
				Starling.current.setRequiresRedraw();
				Starling.current.render();
			}
		}
		
		private function loader_ioErrorHandler(e:IOErrorEvent):void 
		{
			sosTrace( "PostTournamentPhoto.loader_ioErrorHandler > e : " + e, SOSLog.ERROR);
		}
		
	}

}