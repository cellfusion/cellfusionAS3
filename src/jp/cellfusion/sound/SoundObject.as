package jp.cellfusion.sound
{
	import flash.media.Sound;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class SoundObject extends SoundBase implements ISoundObject
	{
		public function SoundObject(sound:Sound, type:uint = BGM)
		{
			super(sound, type);
		}
	}
}
