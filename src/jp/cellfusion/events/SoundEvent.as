package jp.cellfusion.events
{
	import flash.events.Event;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class SoundEvent extends Event
	{
		public function SoundEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
