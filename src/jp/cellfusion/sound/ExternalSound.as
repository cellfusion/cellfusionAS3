package jp.cellfusion.sound 
{
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class ExternalSound extends SoundBase implements ISoundObject
	{
		public function ExternalSound(request:URLRequest, context:SoundLoaderContext = null, type:uint = BGM) 
		{
			super(new Sound(request, context), type);
		}

	}
}
