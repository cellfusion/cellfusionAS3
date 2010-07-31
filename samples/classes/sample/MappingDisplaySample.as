package sample 
{
	import jp.cellfusion.display.MappingDisplay;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.getTimer;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class MappingDisplaySample extends Sprite 
	{
		private var _loader:Loader;
		private var _image:BitmapData;
		private var _mapping:MappingDisplay;

		public function MappingDisplaySample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//			stage.quality = StageQuality.LOW;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImageComplete);
			_loader.load(new URLRequest("dummy.jpg"));
		}

		private function loadImageComplete(event:Event):void 
		{
			var bmp:Bitmap = Bitmap(_loader.content);
			
			_image = bmp.bitmapData.clone();
			
			_loader.unload();
			
			_mapping = new MappingDisplay(_image, 0, 2);
			
			_mapping.x = 100;
			_mapping.y = 100;
			addChild(_mapping);
			
			addEventListener(Event.ENTER_FRAME, draw);
		}

		private function draw(event:Event):void 
		{
			_mapping.begin();
			
			var l:int = 20;
			var stepX:Number = 200 / l;
			var stepY:Number = Math.PI / 180 * (360 / l);
			for (var i:uint = 0;i < l;i++) {
				var posX:Number = i * stepX;
				var posY:Number = Math.sin(i * stepY + (getTimer() / 200)) * 50;
							
				_mapping.addVertex(posX, posY);
				_mapping.addVertex(posX/10, posY + 200);
			}
			
			_mapping.end();
		}
	}
}
