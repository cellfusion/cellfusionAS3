package jp.cellfusion.sound
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class SoundManager
	{
		private var _soundsDict:Dictionary;
		private var _sounds:Array;
		private static var __instance:SoundManager;
		private const LIBRARY:String = "library";
		private const EXTERNAL:String = "external";
		private var _isMute:Boolean = false;
		
		public static const STOP:uint = 0;
		public static const PLAY:uint = 1;
		public static const PAUSE:uint = 2;
		public static const MUTE:uint = 3;

		public static function get instance():SoundManager 
		{
			if ( __instance === null ) {
				__instance = new SoundManager();
			}
			return __instance;
		}

		public function SoundManager()
		{
			if(__instance) {
				throw new ArgumentError("SoundManager は new できません");
				return;
			}
        	
			_soundsDict = new Dictionary(true);
			_sounds = new Array();
		}

		/**
		 * ライブラリのサウンドを登録します
		 * @param linkageID
		 * @param name 呼び出す際に使用する ID
		 */
		public function addLibrarySound(linkageID:Class, name:String, volume:Number = 1):void
		{
			for each (var s:SoundObject in _sounds) {
				if (s.name == name) {
					throw new Error('指定した id は既に使用されています');
					return;
				}
			}
           
			var snd:Sound = new linkageID();
			var sndObj:SoundObject = new SoundObject(name, snd, LIBRARY);
			sndObj.defaultVolume = volume;
           
			_soundsDict[name] = sndObj;
			_sounds.push(sndObj);
		}
		
		/**
		 * 外部ストリーミングを登録
		 */
		public function addExternalSound(request:URLRequest, name:String, volume:Number = 1, buffer:Number = 1000, checkPolicyFile:Boolean = false):void
		{
			for each (var s:SoundObject in _sounds) {
				if (s.name == name) {
					throw new Error('指定した id は既に使用されています');
					return;
				}
			}
           
			var snd:Sound = new Sound(request, new SoundLoaderContext(buffer, checkPolicyFile));
			var sndObj:SoundObject = new SoundObject(name, snd, EXTERNAL);
			sndObj.defaultVolume = volume;
           
			_soundsDict[name] = sndObj;
			_sounds.push(sndObj);
		}
		
		/**
		 * 
		 */
		public function removeSound(name:String):void
		{
			for (var i:int = 0;i < _sounds.length;i++) {
				if (_sounds[i].name == name) {
					_sounds[i] = null;
					_sounds.splice(i, 1);
					break;
				}
			}
           
			delete _soundsDict[name];
		}

		public function removeAllSounds():void
		{
			for (var i:int = 0;i < _sounds.length;i++) {
				_sounds[i] = null;
			}
           
			_sounds = [];
			_soundsDict = new Dictionary(true);
		}
		
		public function playSE(name:String, volume:Number = 1):void
		{
			var snd:SoundObject = _soundsDict[name];
			if (!snd) { return; }
			
			var st:SoundTransform = new SoundTransform(volume);
			snd.sound.play(0, 0, st);
		}
		
		public function playBGM(name:String, fade:Boolean = false):void
		{
			var snd:SoundObject = _soundsDict[name];
			if (!snd) return;
			if (snd.state == PLAY) return;
			
			var st:SoundTransform = new SoundTransform(fade ? 0 : snd.defaultVolume);
			snd.channel = snd.sound.play(0, int.MAX_VALUE, st);
			if (fade) { fadeSound(name,snd.defaultVolume); }
           
			snd.state = PLAY;
		}
		
		public function playSound(name:String, volume:Number = 1, start:Number = 0, loops:int = 0, fade:Boolean = false):void
		{
			var snd:SoundObject = _soundsDict[name];
			if (!snd) { return; }
			
//			switch (snd.state) {
//				case PLAY:
//				case MUTE: return;
//				case PAUSE:
//					start = snd.position;
//					break;
//				case STOP:
//					break;
//			}
			
			snd.volume = volume;
			snd.startTime = start;
			snd.loops = loops;
			
			var st:SoundTransform = new SoundTransform(fade ? 0 : volume);
			snd.channel = snd.sound.play(start, snd.loops, st);
			if (fade) { fadeSound(name, volume); }
           
			snd.state = PLAY;
		}

		public function stopSound(name:String, fade:Boolean = false):void
		{
			var snd:SoundObject = _soundsDict[name];
			if (!snd) { return; }
			
			if (fade) {
				fadeSound(name, 0, 1, stopSoundCompleted, snd);
			} else {
				stopSoundCompleted(snd);
			}
		}

		private function stopSoundCompleted(snd:SoundObject):void
		{
			snd.channel.stop();
			snd.state = STOP;
			snd.position = 0;
		}

		public function pauseSound(name:String):void
		{
			var snd:SoundObject = _soundsDict[name];
			if (!snd) { return; }
			
			switch (snd.state) {
				case STOP:
				case PAUSE:
					return;
				case PLAY:
				case MUTE:
					break;
			}
			
			snd.state = PAUSE;
			snd.position = snd.channel.position;
			snd.channel.stop();
		}

		public function playAllSounds(useCurrentlyPlayingOnly:Boolean = false):void
		{
			for each (var s:SoundObject in _sounds) {
				var id:String = s.name;
               
				if (useCurrentlyPlayingOnly) {
					if (_soundsDict[id].pausedByAll) {
						_soundsDict[id].pausedByAll = false;
						playSound(id);
					}
				} else {
					playSound(id);
				}
			}
		}

		public function stopAllSounds(useCurrentlyPlayingOnly:Boolean = true):void
		{
			for each (var s:SoundObject in _sounds) {
				var id:String = s.name;
				
				if (useCurrentlyPlayingOnly) {
					if (!_soundsDict[id].paused) {
						_soundsDict[id].pausedByAll = true;
						stopSound(id);
					}
				} else {
					stopSound(id);
				}
			}
		}

		public function pauseAllSounds(useCurrentlyPlayingOnly:Boolean = true):void
		{
			for each (var s:SoundObject in _sounds) {
				var id:String = s.name;
               
				if (useCurrentlyPlayingOnly) {
					if (!_soundsDict[id].paused) {
						_soundsDict[id].pausedByAll = true;
						pauseSound(id);
					}
				} else {
					pauseSound(id);
				}
			}
		}

		public function fadeSound(name:String, targVolume:Number = 0, fadeLength:Number = 1, onComplete:Function = null, ...onCompleteArgs:Array):void
		{
			var s:SoundObject = _soundsDict[name];
			if (!s) { return; }
			
			var fadeChannel:SoundChannel = s.channel;
			
			// TODO あとで直す
			//Tweensy.to(fadeChannel.soundTransform, {volume:targVolume}, fadeLength, Linear.easeNone, 0, fadeChannel, onComplete, onCompleteArgs);
			
			var tween:IObjectTween = BetweenAS3.to(fadeChannel, {soundTransform: {volume: targVolume}}, fadeLength, Linear.easeNone);
			tween.onComplete = onComplete;
			tween.onCompleteParams = onCompleteArgs;
			tween.play();
		}

		public function muteAllSounds(fade:Boolean = false, fadeLength:Number = 1):void
		{
			for each (var s:SoundObject in _sounds) {
				var id:String = s.name;
               
				if (fade) {
					fadeSound(id, 0, fadeLength);
				} else {
					setSoundVolume(id, 0);
				}
				
				s.state = MUTE;
			}
			
			if (fade) {
				//Tweensy.to(SoundMixer.soundTransform, {volume:0}, fadeLength, Linear.easeNone, 0, SoundMixer);
				BetweenAS3.to(SoundMixer, {soundTransform: {volume: 0}}, fadeLength, Linear.easeNone).play();
			} else {
				var curTransform:SoundTransform = SoundMixer.soundTransform;
				curTransform.volume = 0;
				SoundMixer.soundTransform = curTransform;
			}
			
			_isMute = true;
		}

		public function unmuteAllSounds(fade:Boolean = false, fadeLength:Number = 1):void
		{
			for each (var s:SoundObject in _sounds) {
				var id:String = s.name;
				var snd:Object = _soundsDict[id];
				
				if (fade) {
					fadeSound(id, s.defaultVolume, fadeLength);
				} else {
					setSoundVolume(id, s.defaultVolume);
				}
			}
			
			if (fade) {
				//Tweensy.to(SoundMixer.soundTransform, {volume:1}, fadeLength, Linear.easeNone, 0, SoundMixer);
				BetweenAS3.to(SoundMixer, {soundTransform: {volume: 1}}, fadeLength, Linear.easeNone).play();
			} else {
				var curTransform:SoundTransform = SoundMixer.soundTransform;
				curTransform.volume = 1;
				SoundMixer.soundTransform = curTransform;
			}
			
			_isMute = false;
		}

		public function setSoundVolume(name:String, volume:Number):void
		{
			var snd:Object = _soundsDict[name];
			if (!snd) { 
				return; 
			}
			
			var curTransform:SoundTransform = snd.channel.soundTransform;
			curTransform.volume = volume;
			snd.channel.soundTransform = curTransform;
		}

		public function getSoundVolume(name:String):Number
		{
			return _soundsDict[name].channel.soundTransform.volume;
		}

		public function getSoundPosition(name:String):Number
		{
			return _soundsDict[name].channel.position;
		}

		public function getSoundDuration(name:String):Number
		{
			return _soundsDict[name].sound.length;
		}

		public function getSoundObject(name:String):Object
		{
			return _soundsDict[name];
		}

		public function getSound(name:String):Sound
		{
			return _soundsDict[name].sound;
		}

		public function isSoundPaused(name:String):Boolean
		{
			return _soundsDict[name].paused;
		}

		public function isSoundPausedByAll(name:String):Boolean
		{
			return _soundsDict[name].pausedByAll;
		}

		public function get sounds():Array
		{
			return _sounds;
		}

		public function toString():String
		{
			return getQualifiedClassName(this);
		}

		public function get isMute():Boolean
		{
			return _isMute;
		}
	}
}

import flash.media.Sound;
import flash.media.SoundChannel;

class SoundObject
{
	public var name:String;
	public var sound:Sound;
	public var channel:SoundChannel = new SoundChannel();
	public var position:Number = 0;
	public var state:uint = 0;
	public var volume:Number = 1;	public var prevVolume:Number = 1;
	public var startTime:Number = 0;
	public var loops:uint = 0;
	public var pausedByAll:Boolean = false;
	public var type:String;
	public var defaultVolume:Number;

	public function SoundObject(name:String, sound:Sound, type:String) 
	{
		this.name = name;
		this.sound = sound;
		this.type = type;
	}
}