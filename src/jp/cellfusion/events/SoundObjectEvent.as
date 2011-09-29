package jp.cellfusion.events
{
	import jp.cellfusion.sound.ISoundObject;

	import flash.events.Event;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class SoundObjectEvent extends Event
	{
		public static const SOUND_PLAY:String = "SoundObjectPlay";
		public static const SOUND_PAUSE:String = "SoundObjectPause";
		public static const SOUND_RESUME:String = "SoundObjectResume";
		public static const SOUND_STOP:String = "SoundObjectStop";
		public static const SOUND_COMPLETE:String = "SoundObjectComplete";
		public static const SOUND_VOLUME_CHANGE:String = "SoundObjectVolumeChange";
		public static const SOUND_LOAD_COMPLETE:String = "SoundObjectLoadComplete";
		private var _so:ISoundObject;

		public function SoundObjectEvent(so:ISoundObject, type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);

			_so = so;
		}

		public function get sound():ISoundObject
		{
			return _so;
		}
	}
}
