package jp.cellfusion.sound
{
	import jp.cellfusion.events.SoundObjectEvent;

	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class SoundBase extends EventDispatcher implements ISoundObject
	{
		public static const BGM:uint = 0;
		public static const SE:uint = 1;
		protected const STATE_STOP:uint = 0;
		protected const STATE_PLAY:uint = 1;
		protected const STATE_PAUSE:uint = 2;
		protected var _channel:SoundChannel;
		protected var _sound:Sound;
		protected var _soundTransform:SoundTransform;
		protected var _volume:Number;
		protected var _type:uint;
		protected var _state:uint;
		private var _position:Number;
		private var _loops:int;
		private var _isMute:Boolean;
		private var _muteVolume:Number;
		private var _fadeTimer:Timer;
		private var _fadeTargetVolume:Number;
		private var _fadeTargetTime:Number;
		private var _fadeEasing:Function;
		private var _fadeStartTime:int;
		private var _fadeStartVolume:Number;
		private var _isSolo:Boolean;
		private var _atSoundComplete:Function;
		private var _atFadeComplete:Function;
		private var _extra:Object;

		public function SoundBase(sound:Sound, type:uint = BGM)
		{
			super();

			_sound = sound;
			_sound.addEventListener(Event.COMPLETE, soundLoadComplete);
			_type = type;
			_soundTransform = new SoundTransform();
			_state = STATE_STOP;
			_isMute = false;
			_isSolo = false;
			_extra = {};

			_volume = 1;

			_fadeTimer = new Timer(250, 4);
			_fadeTimer.addEventListener(TimerEvent.TIMER, fadeProgress);
			_fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fadeComplete);
		}

		private function soundLoadComplete(event:Event):void
		{
			dispatchEvent(new SoundObjectEvent(this, SoundObjectEvent.SOUND_LOAD_COMPLETE));
		}

		public function mute(fade:Boolean = false, seconds:Number = 1, easing:Function = null):void
		{
			if (!_isMute) {
				_muteVolume = volume;

				if (fade) {
					easing = easing || easeNone;
					fadeStart(0, seconds, easing);
				} else {
					volume = 0;
				}
			} else {
				if (fade) {
					easing = easing || easeNone;
					fadeStart(_muteVolume, seconds, easing);
				} else {
					volume = _muteVolume;
				}
			}

			_isMute = !_isMute;
		}

		/**
		 * 
		 */
		public function solo(fade:Boolean = false, seconds:Number = 1, easing:Function = null):void
		{
			// TODO solo 実装
			_isSolo = !_isSolo;

			SoundManager.instance.solo();
		}

		public function soloExecute():void
		{
		}

		/**
		 * BGM の場合
		 */
		public function play(startTime:Number = 0, loops:int = 0):void
		{
			if (_type == BGM) {
				playBGM(startTime, loops);
			} else {
				playSE(startTime);
			}
		}

		protected function playSE(startTime:Number = 0):void
		{
			_channel = _sound.play(startTime, 0, _soundTransform);
		}

		protected function playBGM(startTime:Number = 0, loops:int = 0):void
		{
			if (_state == STATE_PLAY) return;

			if (_state == STATE_PAUSE) {
				resume();
			} else if (_state == STATE_STOP) {
				_state = STATE_PLAY;
				_loops = loops;
				_channel = _sound.play(startTime, loops, _soundTransform);
				_channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);

				dispatchEvent(new SoundObjectEvent(this, SoundObjectEvent.SOUND_PLAY));
			}
		}

		private function soundComplete(event:Event):void
		{
			_state = STATE_STOP;
			_channel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
			_channel = null;

			dispatchEvent(new SoundObjectEvent(this, SoundObjectEvent.SOUND_COMPLETE));

			if (_atSoundComplete != null) {
				_atSoundComplete.apply();
			}
		}

		public function stop():void
		{
			if (_state == STATE_STOP) return;
			
			_state = STATE_STOP;

			_channel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
			_channel.stop();
			_channel = null;

			dispatchEvent(new SoundObjectEvent(this, SoundObjectEvent.SOUND_STOP));
		}

		public function pause():void
		{
			if (_state != STATE_PLAY) return;
			
			_state = STATE_PAUSE;

			_position = _channel.position;

			_channel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
			_channel.stop();
			// _channel = null;

			dispatchEvent(new SoundObjectEvent(this, SoundObjectEvent.SOUND_PAUSE));
		}

		public function resume():void
		{
			if (_state != STATE_PAUSE) return;
			
			_state = STATE_PLAY;
			_channel = _sound.play(_channel.position || 0, _loops, _soundTransform);
			_channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);

			dispatchEvent(new SoundObjectEvent(this, SoundObjectEvent.SOUND_RESUME));
		}

		public function seek(position:Number):void
		{
			if (_state == STATE_PLAY) {
				if (_channel) {
					_channel.stop();
					_channel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
				}

				_channel = _sound.play(position, _loops, _soundTransform);
				_channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);

				dispatchEvent(new SoundObjectEvent(this, SoundObjectEvent.SOUND_PLAY));
			} else if (_state == STATE_PAUSE) {
				_position = position;
			} else if (_state == STATE_STOP) {
			} else {
			}
		}

		public function get volume():Number
		{
			return _volume;
		}

		public function set volume(value:Number):void
		{
			_volume = value;

			// masterVolume の影響を受ける
			_soundTransform.volume = value * SoundManager.instance.volume;

			if (_channel) {
				_channel.soundTransform = _soundTransform;
			}

			dispatchEvent(new SoundObjectEvent(this, SoundObjectEvent.SOUND_VOLUME_CHANGE));
		}

		public function fade(volume:Number, seconds:Number, easing:Function):void
		{
			fadeStart(volume, seconds, easing);
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

			if (_atFadeComplete != null) {
				_atFadeComplete.apply();
			}
		}

		public function close():void
		{
			try {
				_sound.close();
			} catch(error:Error) {
			}
		}

		public function destroy():void
		{
			if (_channel) {
				_channel.stop();
				_channel = null;
			}

			try {
				_sound.close();
			} catch(error:Error) {
			}

			_sound = null;
			_soundTransform = null;

			_fadeTimer.removeEventListener(TimerEvent.TIMER, fadeProgress);
			_fadeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, fadeComplete);
			_fadeTimer = null;
		}

		public function get isSolo():Boolean
		{
			return _isSolo;
		}

		public function get isMute():Boolean
		{
			return _isMute;
		}
		
		public function get position():Number
		{
			return _channel ? _channel.position : 0;
		}

		public function get length():Number
		{
			return _sound ? _sound.length : 0;
		}

		public function set atSoundComplete(value:Function):void
		{
			_atSoundComplete = value;
		}

		public function set atFadeComplete(value:Function):void
		{
			_atFadeComplete = value;
		}

		public function get extra():Object
		{
			return _extra;
		}

		private function easeNone(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * t / d + b;
		}

		public function get bytesLoaded():Number
		{
			return _sound ? _sound.bytesLoaded : 0;
		}

		public function get bytesTotal():Number
		{
			return _sound ? _sound.bytesTotal : 0;
		}

		public function get sound():Sound
		{
			return _sound;
		}
	}
}
