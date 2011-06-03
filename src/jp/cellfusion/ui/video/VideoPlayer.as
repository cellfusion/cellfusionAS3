package jp.cellfusion.ui.video
{
	import flash.events.ErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.AsyncErrorEvent;
	import jp.cellfusion.ui.video.ui.SeekBarBase;
	import jp.cellfusion.events.VideoEvent;
	import jp.cellfusion.events.VideoProgressEvent;
	import jp.cellfusion.sound.ISoundObject;
	import jp.cellfusion.sound.SoundManager;
	import jp.cellfusion.sound.VideoSound;
	import jp.cellfusion.ui.video.ui.IControllerParts;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.Responder;
	import flash.net.URLRequest;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 * 旧VideoPlayer
	 */
	public class VideoPlayer extends Sprite implements IVideoPlayer
	{
		private var _nc:NetConnection;
		private var _ns:NetStream;
		private var _video:Video;
		private var _soundId:String;
		private var _sound:ISoundObject;
		private var _metadata:Object;
		private var _isPlay:Boolean;
		private var _completed:Boolean;
		private var _repeat:Boolean;
		private var _autoRewind:Boolean;
		private var _parts:Array;
		private var _request:URLRequest;
		private var url_re:RegExp;
		private var _load:Boolean;
		private var _tempSondTransrform:SoundTransform;
		private var _duration:*;
		private var _streming:Boolean;
		private var _prevTime:Number;
		private var _count:int;
		private var _timeout:int;
		private var _bufferEmpty:Boolean;
		private var _start:Number;

		[Event( name="metadataReceived", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="playStart", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="playPause", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="playResume", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="playStop", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="complete", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="bufferEmpty", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="bufferFull", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="bufferFlush", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="playStreamNotFound", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="playFailed", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="seekFailed", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="seekInvalidTime", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="seekNotify", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="loadStart", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="loadComplete", type="jp.cellfusion.events.VideoEvent" )]
		[Event( name="progress", type="jp.cellfusion.events.VideoProgressEvent" )]
		public function VideoPlayer(id:String, width:Number, height:Number)
		{
			url_re = /^rtmp\:\/\/([\S^\/]+?)\/([\S^\/]+?)\/(.+)$/;

			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, connectionNsStatusHandler);
			_nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, netConnectionAsyncError);
			_nc.addEventListener(IOErrorEvent.IO_ERROR, netConnectionIoError);
			_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, netConnectionSecurityError);
			_nc.client = {};

			_soundId = id;

			_video = new Video(width, height);
			_video.width = width;
			_video.height = height;

			addChild(_video);

			_completed = false;
			_autoRewind = false;
			_repeat = false;

			_parts = [];
			_load = false;
			_streming = false;
			_tempSondTransrform = new SoundTransform();

			_count = 0;
			_timeout = 20;
			_duration = 0;
			_bufferEmpty = false;
		}

		private function netConnectionSecurityError(event:SecurityErrorEvent):void
		{
//			trace("netConnectionSecurityError", event.text);
		}

		private function netConnectionIoError(event:IOErrorEvent):void
		{
//			trace("netConnectionIoError", event.text);
		}

		private function netConnectionAsyncError(event:AsyncErrorEvent):void
		{
//			trace("netConnectionAsyncError", event.text);
		}

		private function connectionNsStatusHandler(event:NetStatusEvent):void
		{
//			trace("connectionNsStatusHandler", event.info.code, event.info.level);
//			if (event.info.level == "error") {
//				_nc.connect(getConnectURL(_request.url));
//				return;
//			}
			
			if (event.info.code == "NetConnection.Connect.Success") {
				if (_ns == null) {
					_ns = new NetStream(_nc);
					_ns.addEventListener(IOErrorEvent.IO_ERROR, nsIoError);
					_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, nsAsyncError);
					_ns.addEventListener(NetStatusEvent.NET_STATUS, nsStatus);
					_ns.addEventListener(ErrorEvent.ERROR, nsError);
					_ns.client = {onMetaData:metaDataHandler, onPlayStatus:playStatusHandler, onCuePoint:cuePointHandler, onImageData:imageDataHandler, onTextData:textDataHandler};
				}
				_video.attachNetStream(_ns);

				if (_sound == null) {
					_ns.soundTransform = _tempSondTransrform;
					_sound = SoundManager.instance.add(new VideoSound(_ns), _soundId);
//					_sound.volume = 1.0;
				}

				_streming = url_re.test(_request.url);

				_bufferEmpty = false;
				_nc.call("getStreamLength", new Responder(getStreamLengthResult), getVideoURL(_request.url));
<<<<<<< HEAD
				
				// metadata がくるまで再生はまつ
=======

>>>>>>> 1d9e0a7ce840b62f980d70748f4cbd26405e393a
				_ns.play(getVideoURL(_request.url));
				
//				loadStart();

				if (_load) {
					_ns.pause();
					// _ns.seek(0);
				}

//				updateHandler();
<<<<<<< HEAD
			}
		}

		private function nsError(event:ErrorEvent):void
		{
//			trace("nsError");
		}

		private function nsAsyncError(event:AsyncErrorEvent):void
		{
//			trace("nsAsyncError", event.error);
		}
		
		private function cuePointHandler(data:Object):void
		{
//			trace("cuePointHandler");
		}
		
		private function imageDataHandler(data:Object):void
		{
//			trace("imageDataHandler");
		}
		
		private function textDataHandler(data:Object):void
		{
//			trace("textDataHandler");
		}

		private function metaDataHandler(data:Object):void
		{
//			trace("metadataHandler");
			if (!_isPlay) {
				// _ns.seek(0);
=======
>>>>>>> 1d9e0a7ce840b62f980d70748f4cbd26405e393a
			}

			_metadata = data;
			dispatchEvent(new VideoEvent(VideoEvent.METADATA_RECEIVED));
		}

		private function playStatusHandler(data:Object):void
		{
//			trace("onPlayStatus");
		}

		private function nsError(event:ErrorEvent):void
		{
//			trace("nsError");
		}

		private function nsAsyncError(event:AsyncErrorEvent):void
		{
//			trace("nsAsyncError", event.error);
		}
		
		private function cuePointHandler(data:Object):void
		{
//			trace("cuePointHandler");
		}
		
		private function imageDataHandler(data:Object):void
		{
//			trace("imageDataHandler");
		}
		
		private function textDataHandler(data:Object):void
		{
//			trace("textDataHandler");
		}

		private function metaDataHandler(data:Object):void
		{
//			trace("metadataHandler");
			if (!_isPlay) {
				// _ns.seek(0);
			}

			_metadata = data;
			dispatchEvent(new VideoEvent(VideoEvent.METADATA_RECEIVED));
		}

		private function playStatusHandler(data:Object):void
		{
//			trace("onPlayStatus");
		}

		private function getVideoURL(url:String):String
		{
			// rtmp の場合のみ判定
			if (url_re.test(url)) {
				var rst:Array = url.match(url_re);
				var path:String = rst[3];
				var file:String;
				
				// 拡張子を取り除く必要がある
				if (/(f4v|mp4)$/.test(path)) {
//					file = "mp4:" + path.split(".")[0];
					file = "mp4:" + path;
				} else {
					file = path.split(".")[0];
				}
				trace("file", file);

				return file;
			}
			return url;
		}

		private function getConnectURL(url:String):String
		{
			if (url_re.test(url)) {
				var rst:Array = url.match(url_re);
				var domain:String = rst[1];
				var application:String = rst[2];
				var path:String = rst[3];
				var temp:String = "rtmp://" + domain + "/" + application;

				return temp;
			}

			return null;
		}

		private	function getStreamLengthResult(value:*):void
		{
//			trace("getStreamLengthResult", this, value);
			_duration = value;
			_ns.seek(0);
		}

		/**
		 * 途中シーク出来てもいい気がする
		 */
		public function play(request:URLRequest = null, play:Boolean = false, start:Number = -2):void
		{
			_start = start;

			if (request) {
				_request = request;

				if (_nc.connected) {
					if (_nc.uri.indexOf(getConnectURL(request.url)) == 0) {
						if (!_isPlay) _ns.close();
						_ns.play(getVideoURL(request.url), start);
					} else {
						_nc.close();
						_nc.connect(getConnectURL(request.url));
					}
				} else {
					_nc.connect(getConnectURL(request.url));
				}
			} else if (play) {
				_completed = false;
				_ns.resume();
			} else if (_completed) {
				_completed = false;
				_ns.seek(0);
				_ns.resume();
				_bufferEmpty = true;
			} else {
				_ns.resume();
			}

			updateHandler();
			addEventListener(Event.ENTER_FRAME, updateHandler);
			dispatchEvent(new VideoEvent(VideoEvent.PLAY_START));
			_isPlay = true;
		}

		public function pause(temporary:Boolean = false):void
		{
			if (!temporary) {
				_isPlay = false;
				updateHandler();
				dispatchEvent(new VideoEvent(VideoEvent.PLAY_PAUSE));
			}

			_ns.pause();
			removeEventListener(Event.ENTER_FRAME, updateHandler);
		}

		public function stop():void
		{
			_isPlay = false;

			if (_ns) {
				_ns.pause();
				_ns.seek(0);
			}
			updateHandler();
			removeEventListener(Event.ENTER_FRAME, updateHandler);

			reset();

			dispatchEvent(new VideoEvent(VideoEvent.PLAY_STOP));
		}

		public function resume(temporary:Boolean = false):void
		{
			if (!temporary) {
				_isPlay = true;
				updateHandler();
				dispatchEvent(new VideoEvent(VideoEvent.PLAY_RESUME));
			}

			_ns.resume();
			addEventListener(Event.ENTER_FRAME, updateHandler);
		}

		public function togglePause():void
		{
			_isPlay != _isPlay;
			_ns.togglePause();
			updateHandler();
		}

		public function load(request:URLRequest):void
		{
			_load = true;
			_request = request;
			_nc.connect(getConnectURL(request.url));
			
			loadStart();
		}

		public function seek(offset:Number):void
		{
			_ns.seek(offset);
			_bufferEmpty = true;

			if (!_isPlay) {
				updateHandler();
			}
		}

		public function close():void
		{
			stop();
<<<<<<< HEAD
			
//			_video.attachNetStream(null);
			removeChild(_video);
			_video.clear();
			_video = null;
			
			SoundManager.instance.remove(_soundId);
			_sound = null;
=======
			SoundManager.instance.remove(_soundId);
>>>>>>> 1d9e0a7ce840b62f980d70748f4cbd26405e393a

			if (_ns) {
				_ns.close();
			}
<<<<<<< HEAD
			_ns = null;
=======
>>>>>>> 1d9e0a7ce840b62f980d70748f4cbd26405e393a
			
			_nc.close();
			
			_nc.removeEventListener(NetStatusEvent.NET_STATUS, connectionNsStatusHandler);
			_nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, netConnectionAsyncError);
			_nc.removeEventListener(IOErrorEvent.IO_ERROR, netConnectionIoError);
			_nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, netConnectionSecurityError);
<<<<<<< HEAD
			_nc = null;
=======
>>>>>>> 1d9e0a7ce840b62f980d70748f4cbd26405e393a
		}

		private function complete():void
		{
			if (_completed) {
				return;
			}
			
			removeEventListener(Event.ENTER_FRAME, updateHandler);
			
//			pause();

			if (_repeat) {
				seek(0);
				play();
			} else if (_autoRewind) {
				seek(0);
				reset();
			}

			_completed = true;
			_isPlay = false;
			dispatchEvent(new VideoEvent(VideoEvent.COMPLETE));

		}

		private function reset():void
		{
			for each (var i : IControllerParts in _parts) {
				i.reset();
			}
		}

		//
		private function loadStart():void
		{
			dispatchEvent(new VideoEvent(VideoEvent.LOAD_START));
			addEventListener(Event.ENTER_FRAME, loadProgress);
		}

		private function loadProgress(event:Event):void
		{
			var loaded:uint = _ns.bytesLoaded;
			var total:uint = _ns.bytesTotal;

			dispatchEvent(new VideoProgressEvent(VideoProgressEvent.PROGRESS, false, false, loaded, total));

			try {
				updateHandler();
			} catch(error:Error) {
			}

			if (loaded >= total && total > 0) {
				loadComplete();
			}
		}

		private function loadComplete():void
		{
			removeEventListener(Event.ENTER_FRAME, loadProgress);
			dispatchEvent(new VideoEvent(VideoEvent.LOAD_COMPLETE));
		}

		private function updateHandler(event:Event = null):void
		{
			update();
		}

		public function update(countup:Boolean = true):void
		{
//			trace("update");
			for each (var i : IControllerParts in _parts) {
				i.update();

				var seekbar:SeekBarBase = i as SeekBarBase;
				if (seekbar) {
					if (seekbar.isDrag) {
						countup = false;
					}
				}
			}

			// seek 直後は回復するまで countup 無効
			if (_bufferEmpty) {
				countup = false;
			}
			
			//trace("isPlay", _isPlay, "nc.connected", _nc.connected, "time", time, "duration", duration);
			if (_isPlay && _nc.connected && time > 0 && duration > 0 && Math.abs(duration - time) < 1) {
				if (_prevTime == time && countup) {
					_count++;
				} else {
					_count = 0;
					_prevTime = time;
				}
				
				if (_count > _timeout) {
					complete();
				}
			} else if (duration == 0) {
				// duration がない場合のみ対応
				if (_prevTime == time && countup) {
					_count++;
				} else {
					_count = 0;
					_prevTime = time;
				}

				if (_count > _timeout) {
					complete();
				}
			}
		}

		private function nsStatus(event:NetStatusEvent):void
		{
//			trace("nsStatus", event.info.code);
			switch (event.info.code) {
				case "NetStream.Buffer.Empty":
					if (_count > 0) return;
					dispatchEvent(new VideoEvent(VideoEvent.BUFFER_EMPTY));
					break;
				case "NetStream.Buffer.Full":
					dispatchEvent(new VideoEvent(VideoEvent.BUFFER_FULL));
					_bufferEmpty = false;
					break;
				case "NetStream.Buffer.Flush":
					dispatchEvent(new VideoEvent(VideoEvent.BUFFER_FLUSH));
					_bufferEmpty = false;
					break;
				case "NetStream.Play.Start":
					break;
				case "NetStream.Play.Stop":
					break;
				case "NetStream.Play.StreamNotFound":
					dispatchEvent(new VideoEvent(VideoEvent.PLAY_STREAM_NOT_FOUND));
					break;
				case "NetStream.Play.Failed":
					dispatchEvent(new VideoEvent(VideoEvent.PLAY_FAILED));
					break;
				case "NetStream.Seek.Failed":
					dispatchEvent(new VideoEvent(VideoEvent.SEEK_FAILED));
					break;
				case "NetStream.Seek.InvalidTime":
					dispatchEvent(new VideoEvent(VideoEvent.SEEK_INVALID_TIME));
					seek(time - 1);
					break;
				case "NetStream.Seek.Notify":
					dispatchEvent(new VideoEvent(VideoEvent.SEEK_NOTIFY));
					break;
				case "NetStream.Play.Reset":
					break;
				case "NetStream.Pause.Notify":
					break;
				case "NetStream.Unpause.Notify":
					break;
				default:
					for (var i : String in event.info) {
						trace(i, event.info[i]);
					}
			}
		}

		private function nsIoError(event:IOErrorEvent):void
		{
//			trace("nsIoError", event.text);
			dispatchEvent(event);
		}

		//
		public function get time():Number
		{
			return _ns ? _ns.time : 0;
		}

		public function get duration():Number
		{
			return _metadata ? _metadata.duration : _duration;
		}

		public function get bytesLoaded():Number
		{
			if (_streming) return 1;

			return _ns ? _ns.bytesLoaded : 0;
		}

		public function get bytesTotal():Number
		{
			if (_streming) return 1;

			return _ns ? _ns.bytesTotal : 0;
		}

		public function get bufferLength():Number
		{
			return _ns ? _ns.bufferLength : 0;
		}

		public function get bufferTime():Number
		{
			return _ns ? _ns.bufferTime : 0;
		}

		public function set bufferTime(value:Number):void
		{
			_ns.bufferTime = value;
		}

		public override function get soundTransform():SoundTransform
		{
			return _ns ? _ns.soundTransform : _tempSondTransrform;
		}

		public function get metadata():Object
		{
			return _metadata;
		}

		public function get volume():Number
		{
			return _sound ? _sound.volume : _tempSondTransrform.volume;
		}

		public function get autoRewind():Boolean
		{
			return _autoRewind;
		}

		public function get preferredHeight():Number
		{
			if (!_metadata) {
				return 0;
			}
			return metadata.height;
		}

		public function get preferredWidth():Number
		{
			if (!_metadata) {
				return 0;
			}
			return metadata.width;
		}

		public function get smoothing():Boolean
		{
			return _video.smoothing;
		}

		public function set volume(offset:Number):void
		{
			if (!_sound) {
				_tempSondTransrform.volume = offset;
				return;
			}

			_sound.volume = offset;
			updateHandler();
		}

		public function set autoRewind(value:Boolean):void
		{
			_autoRewind = value;
		}

		public function set smoothing(value:Boolean):void
		{
			_video.smoothing = value;
		}

		public function addParts(parts:IControllerParts):void
		{
			_parts.push(parts);
			parts.initialize(this);
		}

		public function removeParts(parts:IControllerParts):void
		{
			var idx:int = _parts.indexOf(parts);
			_parts.splice(idx, 1);
			parts.finalize();
		}

		public function get isPlay():Boolean
		{
			return _isPlay;
		}

		public function get streming():Boolean
		{
			return _streming;
		}
	}
}

class NetStreamClient extends Object
{
	
}