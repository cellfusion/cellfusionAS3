package jp.cellfusion.sound
{
	import fl.motion.easing.Linear;

	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class VideoSound implements ISoundObject
	{
		private var _ns:NetStream;
		private var _soundTransform:SoundTransform;
		private var _volume:Number;
		private var _fadeTimer:Timer;
		private var _fadeTargetVolume:Number;
		private var _fadeTargetTime:Number;
		private var _fadeEasing:Function;
		private var _fadeStartTime:int;
		private var _fadeStartVolume:Number;
		private var _muteVolume:Number;
		private var _isMute:Boolean;
		private var _isSolo:Boolean;

		public function VideoSound(ns:NetStream)
		{
			_ns = ns;
			_soundTransform = _ns.soundTransform;
			volume = 1;

			_fadeTimer = new Timer(250, 4);
			_fadeTimer.addEventListener(TimerEvent.TIMER, fadeProgress);
			_fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fadeComplete);
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
//			trace("volume", _volume * SoundManager.instance.volume, value, _volume, SoundManager.instance.volume);
			_volume = value;
			_soundTransform.volume = _volume * SoundManager.instance.volume;
			_ns.soundTransform = _soundTransform;
		}

		public function mute(fade:Boolean = false, seconds:Number = 1, easing:Function = null):void
		{
			if (!_isMute) {
				_muteVolume = volume;

				if (fade) {
					easing = easing || Linear.easeNone;
					fadeStart(0, seconds, easing);
				} else {
					volume = 0;
				}
			} else {
				if (fade) {
					easing = easing || Linear.easeNone;
					fadeStart(_muteVolume, seconds, easing);
				} else {
					volume = _muteVolume;
				}
			}

			_isMute = !_isMute;
		}

		private function fadeStart(volume:Number, seconds:Number, easing:Function):void
		{
			if (_fadeTimer.running) {
				_fadeTimer.stop();
				_fadeTimer.reset();
			}

			_fadeTimer.delay = 33;
			_fadeTimer.repeatCount = Math.round(seconds / 0.033);
			_fadeTimer.reset();
			_fadeTargetVolume = volume;
			_fadeTargetTime = seconds;
			_fadeEasing = easing;
			_fadeStartTime = getTimer();
			_fadeStartVolume = _volume;
			_fadeTimer.start();
		}

		private function fadeProgress(event:TimerEvent):void
		{
			var dist:Number = (getTimer() - _fadeStartTime) / 1000;
			volume = _fadeEasing(dist, _fadeStartVolume, (_fadeTargetVolume - _fadeStartVolume), _fadeTargetTime);
		}

		private function fadeComplete(event:TimerEvent):void
		{
			volume = _fadeTargetVolume;
		}

		public function solo(fade:Boolean = false, seconds:Number = 1, easing:Function = null):void
		{
			// TODO solo 実装
			
			_isSolo = !_isSolo;
			SoundManager.instance.solo();
		}

		public function get isMute():Boolean
		{
			return _isMute;
		}

		public function get isSolo():Boolean
		{
			return _isSolo;
		}

		public function get position():Number
		{
			return _ns ? _ns.time : 0;
		}
		
		public function set atSoundComplete(value:Function):void
		{
		}
		
		public function set atFadeComplete(value:Function):void
		{
		}
	}
}
