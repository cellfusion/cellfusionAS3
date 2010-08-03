package jp.cellfusion.sound 
{
	import flash.media.SoundLoaderContext;
	import flash.media.Sound;
	import flash.net.URLRequest;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class ExternalSound extends SoundObject implements ISoundObject
	{
		public function ExternalSound(request:URLRequest, context:SoundLoaderContext = null) 
		{
			super(new Sound(request, context));
		}
	}
}
