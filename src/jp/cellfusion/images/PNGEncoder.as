package jp.cellfusion.images
{
	import flash.utils.getTimer;
	import flash.events.TimerEvent;

	import jp.cellfusion.events.PNGEncoderEvent;

	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	/**
	 * @author cellfusion
	 */
	public class PNGEncoder extends EventDispatcher
	{
		private const PROGRESS_NUM:uint = 64;
		private var IDAT:ByteArray;
		private var _img:BitmapData;
		private var _byte:ByteArray;
		private var _timer:Timer;
		private var _prev:int;

		public function PNGEncoder()
		{
			super();

			_timer = new Timer(50);
		}

		public function encode(img:BitmapData, byte:ByteArray):void
		{
			_img = img;

			_byte = byte;
			// Create output byte array
			// Write PNG signature
			_byte.writeUnsignedInt(0x89504e47);
			_byte.writeUnsignedInt(0x0D0A1A0A);

			// Build IHDR chunk
			var IHDR:ByteArray = new ByteArray();
			IHDR.writeInt(_img.width);
			IHDR.writeInt(_img.height);
			IHDR.writeUnsignedInt(0x08060000);
			// 32bit RGBA
			IHDR.writeByte(0);
			writeChunk(_byte, 0x49484452, IHDR);

			// Build IDAT chunk
			IDAT = new ByteArray();
			_prev = 0;

			_timer.addEventListener(TimerEvent.TIMER, encodeProgress);
			_timer.start();
		}

		private function encodeProgress(event:TimerEvent):void
		{
			var count:int = 0;
			for (var i:int = _prev;count < PROGRESS_NUM;i++) {
				count++;

				// 終了判定
				if (i >= _img.height) {
					encodeComplete();
					return;
				}

				// no filter
				IDAT.writeByte(0);
				var p:uint;
				var j:int;
				if ( !_img.transparent ) {
					for (j = 0;j < _img.width;j++) {
						p = _img.getPixel(j, i);
						IDAT.writeUnsignedInt(uint(((p & 0xFFFFFF) << 8) | 0xFF));
					}
				} else {
					for (j = 0;j < _img.width;j++) {
						p = _img.getPixel32(j, i);
						IDAT.writeUnsignedInt(uint(((p & 0xFFFFFF) << 8) | (p >>> 24)));
					}
				}
			}

			_prev = i;
		}

		private function encodeComplete():void
		{
			_timer.removeEventListener(TimerEvent.TIMER, encodeProgress);
			_timer.stop();

			IDAT.compress();
			writeChunk(_byte, 0x49444154, IDAT);
			// Build IEND chunk
			writeChunk(_byte, 0x49454E44, null);
			// return PNG

			dispatchEvent(new PNGEncoderEvent(PNGEncoderEvent.COMPLETE));
		}

		private var crcTable:Array;
		private var crcTableComputed:Boolean = false;

		private function writeChunk(png:ByteArray, type:uint, data:ByteArray):void
		{
			if (!crcTableComputed) {
				crcTableComputed = true;
				crcTable = [];
				var c:uint;
				for (var n:uint = 0; n < 256; n++) {
					c = n;
					for (var k:uint = 0; k < 8; k++) {
						if (c & 1) {
							c = uint(uint(0xedb88320) ^ uint(c >>> 1));
						} else {
							c = uint(c >>> 1);
						}
					}
					crcTable[n] = c;
				}
			}
			var len:uint = 0;
			if (data != null) {
				len = data.length;
			}
			png.writeUnsignedInt(len);
			var p:uint = png.position;
			png.writeUnsignedInt(type);
			if ( data != null ) {
				png.writeBytes(data);
			}
			var e:uint = png.position;
			png.position = p;
			c = 0xffffffff;

			var hoge:int = getTimer();
			trace("for", "start");
			for (var i:int = 0; i < (e - p); i++) {
				c = uint(crcTable[(c ^ png.readUnsignedByte()) & uint(0xff)] ^ uint(c >>> 8));
			}
			trace("for", "end", getTimer() - hoge);
			c = uint(c ^ uint(0xffffffff));
			png.position = e;
			png.writeUnsignedInt(c);
		}

		public function get byte():ByteArray
		{
			return _byte;
		}
	}
}
