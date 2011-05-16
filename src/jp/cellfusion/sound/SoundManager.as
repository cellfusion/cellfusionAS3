package jp.cellfusion.sound
{
	import fl.motion.easing.Linear;

	import jp.cellfusion.events.SoundManagerEvent;

	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	[Event(name="masterVolumeChange", type="jp.cellfusion.events.SoundManagerEvent")]
	[Event(name="masterFadeComplete", type="jp.cellfusion.events.SoundManagerEvent")]
	
	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 * TODO 後は SE の扱いと各 SO の mute とか solo 実装
	 */
	public class SoundManager extends EventDispatcher
	{
		static private var _instance:SoundManager;
		private var _volume:Number;
		private var _fadeTimer:Timer;
		private var _fadeStartTime:Number;
		private var _fadeStartVolume:Number;
		private var _fadeEasing:Function;
		private var _fadeTargetVolume:Number;
		private var _fadeTargetTime:Number;
		private var _sounds:Array;
		private var _ids:Dictionary;
		private var _muteVolume:Number;
		private var _solo:Array;
		private var _isMute:Boolean;
		private var _isProgress:Boolean;

		static public function get instance():SoundManager
		{
			if (!_instance) _instance = new SoundManager(new SingletonEnforcer());
			return _instance;
		}

		public function SoundManager(se:SingletonEnforcer)
		{
			_sounds = [];
			_solo = [];
			_ids = new Dictionary();
			_volume = 1;
			_isMute = false;
			_isProgress = false;

			_fadeTimer = new Timer(250, 4);
			_fadeTimer.addEventListener(TimerEvent.TIMER, fadeProgress);
			_fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fadeComplete);
		}

		public function add(so:ISoundObject, id:String):ISoundObject
		{
			if (_ids[id] != null) {
				throw new Error("既に id が使用されています");
				return;
			}

			_ids[id] = so;
			_sounds.push(so);

			return so;
		}

		public function getSound(id:String):ISoundObject
		{
			return _ids[id];
		}

		public function remove(id:String):void
		{
			if (_ids[id] == null) {
				throw new Error("id が存在しません");
				return;
			}

			var so:ISoundObject = _ids[id];
			so.destroy();

			var idx:int = _sounds.indexOf(so);
			_sounds.splice(idx, 1);
			_ids[id] = null;
		}

		/**
		 * 
		 */
		public function mute(fade:Boolean = false, seconds:Number = 1, easing:Function = null):void
		{
			if (!_isMute) {
				if (!_isProgress) {
					_muteVolume = volume;
				}

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

		public function solo(fade:Boolean = false, seconds:Number = 1, easing:Function = null):void
		{
			// TODO solo 実装
		}

		public function fade(volume:Number, seconds:Number, easing:Function):void
		{
			fadeStart(volume, seconds, easing);
		}

		public function get volume():Number
		{
			return _volume;
		}

		public function set volume(value:Number):void
		{
//			trace("soundManager", "volume", value);
			_volume = value;

			for each (var so : ISoundObject in _sounds) {
				so.volume = so.volume;
			}

			dispatchEvent(new SoundManagerEvent(SoundManagerEvent.MASTER_VOLUME_CHANGE));
		}

		private function fadeStart(volume:Number, seconds:Number, easing:Function):void
		{
//			trace("fadeStart", volume, seconds, easing);
			
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
			
			_isProgress = true;
		}

		private function fadeProgress(event:TimerEvent):void
		{
			var dist:Number = (getTimer() - _fadeStartTime) / 1000;
			volume = _fadeEasing(dist, _fadeStartVolume, (_fadeTargetVolume - _fadeStartVolume), _fadeTargetTime);
//			trace("fadeProgress", dist, volume);
		}

		private function fadeComplete(event:TimerEvent):void
		{
			volume = _fadeTargetVolume;
//			trace("fadeComplete", volume);
			
			dispatchEvent(new SoundManagerEvent(SoundManagerEvent.MASTER_FADE_COMPLETE));
			_isProgress = false;
		}
	}
}
class SingletonEnforcer
{
}