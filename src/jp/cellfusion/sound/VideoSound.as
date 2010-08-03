package jp.cellfusion.sound 
{
	import jp.cellfusion.ui.video.VideoPlayer;
	import flash.media.SoundTransform;
	import flash.net.NetStream;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class VideoSound implements ISoundObject
	{
		private var _ns:NetStream;
		private var _soundTransform:SoundTransform;
		private var _volume:Number;

		public function VideoSound(ns:NetStream)
		{
			_ns = ns;
			_soundTransform = _ns.soundTransform;
			_volume = 1;
		}

		public function play(startTime:Number = 0, loops:int = 0):void 
		{
		}

		public function stop():void 
		{
		}
		
		public function destroy():void 
		{
			_ns = null;
		}
		
		public function mute():void
		{
		}
		
		public function unmute():void
		{
		}
		
		public function solo():void
		{
		}
		
		public function pause():void
		{
		}
		
		public function resume():void
		{
		}
		
		public function get volume():Number
		{
			return _volume;
		}

		public function set volume(value:Number):void
		{
			_volume = value;
			_soundTransform.volume = _volume * SoundManager2.instance.volume;
			_ns.soundTransform = _soundTransform;
		}
	}
}
