package jp.cellfusion.events
{
	import flash.events.Event;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class SoundObjectEvent extends Event
	{
		public function SoundObjectEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
