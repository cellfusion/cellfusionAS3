package jp.cellfusion.sound
{
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class ExternalSound extends SoundBase implements ISoundObject
	{
		private var _request:URLRequest;
		private var _isLoad:Boolean;
		private var _loadTimer:Timer;
		private var _startTime:Number;
		private var _loops:int;

		public function ExternalSound(request:URLRequest, context:SoundLoaderContext = null, type:uint = BGM)
		{
			super(new Sound(null, context), type);

			_request = request;
			_isLoad = false;
		}

		override protected function playSE(startTime:Number = 0):void
		{
			if (!_isLoad) {
				_sound.load(_request);
				_isLoad = true;
			}

			super.playSE(startTime);
		}

		override protected function playBGM(startTime:Number = 0, loops:int = 0):void
		{
			if (!_isLoad) {
				_sound.load(_request);
				_isLoad = true;
				loadStart();
			}

			_startTime = startTime;
			_loops = loops;

			// super.playBGM(startTime, loops);
		}

		private function loadStart():void
		{
			_loadTimer = new Timer(300);
			_loadTimer.addEventListener(TimerEvent.TIMER, loadProgress);

			_loadTimer.start();
		}

		private function loadProgress(event:TimerEvent):void
		{
			if (_sound.bytesTotal > 0 && _sound.bytesLoaded >= _sound.bytesTotal) {
				loadComplete();
			}
		}

		private function loadComplete():void
		{
			_loadTimer.removeEventListener(TimerEvent.TIMER, loadProgress);

			super.playBGM(_startTime, _loops);
		}
	}
}
