package jp.cellfusion.sound 
{
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	import flash.media.Sound;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class SoundObject 
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

		public function SoundObject(sound:Sound, type:uint = BGM) 
		{
			_sound = sound;
			_type = type;
			_soundTransform = new SoundTransform();
			_volume = 1;
			_state = STATE_STOP;
		}

		public function mute():void 
		{
			// TODO
		}

		public function unmute():void 
		{
			// TODO
		}
		
		/**
		 * 
		 */
		public function solo():void 
		{
			// TODO
		}

		public function play(startTime:Number = 0, loops:int = 0):void 
		{
			if (_state != STATE_STOP) return;
			
			_state = STATE_PLAY;
			_loops = loops;
			_channel = _sound.play(startTime, loops, _soundTransform);
			_channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
		}

		private function soundComplete(event:Event):void 
		{
			
			_state = STATE_STOP;
			_channel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
			_channel = null;
		}

		public function stop():void 
		{
			if (_state != STATE_PLAY) return;
			
			_state = STATE_STOP;
			
			_channel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
			_channel.stop();
			_channel = null;
		}

		public function pause():void 
		{
			if (_state != STATE_PLAY) return;
			
			_state = STATE_PAUSE;
			
			_position = _channel.position;
			
			_channel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
			_channel.stop();
			_channel = null;
		}

		public function resume():void 
		{
			if (_state != STATE_PAUSE) return;
			
			_state = STATE_PLAY;
			_channel = _sound.play(_position, _loops, _soundTransform);
			_channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
		}

		public function get volume():Number 
		{
			return _volume;
		}

		public function set volume(value:Number):void 
		{
			_volume = value;
			// masterVolume の影響を受ける
			_soundTransform.volume = _volume * SoundManager2.instance.volume;
			
			if (_channel) {
				_channel.soundTransform = _soundTransform;
			}
		}

		public function destroy():void 
		{
			if (_channel) {
				_channel.stop();
				_channel = null;
			}
			
			_sound.close();
			_soundTransform = null;
		}
	}
}
