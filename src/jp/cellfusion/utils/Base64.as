package jp.cellfusion.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import jp.cellfusion.events.Base64Event;

	import mx.utils.Base64Encoder;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	/**
	 * @author cellfusion
	 */
	public class Base64 extends EventDispatcher
	{
		private const LENGTH:uint = 49152;
		private var _count:Number;
		private var _result:String;
		private var _enc:Base64Encoder;
		private var _bytes:ByteArray;
		private var _timer:Timer;

		public function Base64()
		{
			super();

			_enc = new Base64Encoder();
			_count = 0;
			_result = "";
			_timer = new Timer(30/1000);
		}

		public function execute(bytes:ByteArray):void
		{
			_bytes = bytes;
			_timer.addEventListener(TimerEvent.TIMER, encode);
			_timer.start();
		}

		public function interrupt():void
		{
			_timer.removeEventListener(TimerEvent.TIMER, encode);
		}

		private function encode(event:TimerEvent):void
		{
			_enc.encodeBytes(_bytes, _count * LENGTH, LENGTH);

			var tmp:String = _enc.flush();

			if (tmp == "") {
				complete();
				return;
			}

			_result += tmp;
			_count++;
		}

		private function complete():void
		{
			_timer.removeEventListener(TimerEvent.TIMER, encode);

			dispatchEvent(new Base64Event(Base64Event.COMPLETE, _result));
		}
	}
}
