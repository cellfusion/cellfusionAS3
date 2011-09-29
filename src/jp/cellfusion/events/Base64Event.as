package jp.cellfusion.events
{
	import flash.events.Event;

	/**
	 * @author cellfusion
	 */
	public class Base64Event extends Event
	{
		public static const COMPLETE:String = "base64EncodeComplete";
		private var _result:String;

		public function Base64Event(type:String, result:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_result = result;
		}

		public function get result():String
		{
			return _result;
		}

		override public function clone():Event
		{
			return new Base64Event(type, result);
		}
	}
}
