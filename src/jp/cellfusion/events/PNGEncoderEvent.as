package jp.cellfusion.events
{
	import flash.events.Event;

	/**
	 * @author cellfusion
	 */
	public class PNGEncoderEvent extends Event
	{
		public static const COMPLETE:String = "PNGEncodeComplete";

		public function PNGEncoderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

	}
}
