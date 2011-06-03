package jp.cellfusion.events
{
	import flash.events.Event;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class SoundManagerEvent extends Event
	{
		public static const MASTER_FADE_COMPLETE:String = "masterFadeComplete";
		public static const MASTER_VOLUME_CHANGE:String = "masterVolumeChange";
		public function SoundManagerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
