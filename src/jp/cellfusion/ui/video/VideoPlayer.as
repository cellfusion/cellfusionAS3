package jp.cellfusion.ui.video
{
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
			url_re = /^rtmp\:\/\/(.+?)(\/.*)?$/m;

			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, connectionNsStatusHandler);
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
			_bufferEmpty = false;
		}

		private function connectionNsStatusHandler(event:NetStatusEvent):void
		{
			if (event.info.code == "NetConnection.Connect.Success") {
				if (_ns == null) {
					_ns = new NetStream(_nc);
					_ns.addEventListener(IOErrorEvent.IO_ERROR, nsIoError);
					_ns.addEventListener(NetStatusEvent.NET_STATUS, nsStatus);
					_ns.client = {onMetaData:function(param:Object):void {
						if (!_isPlay) {
							// _ns.seek(0);
						}

						_metadata = param;

						dispatchEvent(new VideoEvent(VideoEvent.METADATA_RECEIVED));
					}};

					_video.attachNetStream(_ns);
				}

				if (_sound == null) {
					_ns.soundTransform = _tempSondTransrform;
					_sound = SoundManager.instance.add(new VideoSound(_ns), _soundId);
				}

				_streming = url_re.test(_request.url);

				_ns.play(getVideoURL(_request.url));
				_bufferEmpty = false;
				_nc.call("getStreamLength", new Responder(getStreamLengthResult), getVideoURL(_request.url));
				loadStart();

				if (_load) {
					_ns.pause();
					// _ns.seek(0);
				}

				updateHandler();
			}
		}

		private function getVideoURL(url:String):String
		{
			if (url_re.test(url)) {
				var rst:Array = url.match(url_re);
				var path:String = rst[2];
				var file:String = path.substring(path.indexOf("/", 1));

				if (/(f4v|mp4)$/.test(file)) {
					file = "mp4:" + file;
				}

				return file;
			}
			return url;
		}

		private function getConnectURL(url:String):String
		{
			if (url_re.test(url)) {
				var rst:Array = url.match(url_re);
				var domain:String = rst[1];
				var path:String = rst[2];
				var application:String = "rtmp://" + domain + path.substring(0, path.indexOf("/", 1));

				return application;
			}

			return null;
		}

		private	function getStreamLengthResult(value:*):void
		{
			// trace("getStreamLengthResult", this, value);
			_duration = value;
		}

		/**
		 * 途中シーク出来てもいい気がする
		 */
		public function play(request:URLRequest = null, play:Boolean = false):void
		{
			if (request) {
				_request = request;

				if (_nc.connected) {
					if (_nc.uri.indexOf(getConnectURL(request.url)) == 0) {
						_ns.play(getVideoURL(request.url));
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
			SoundManager.instance.remove(_soundId);
			
			if (_ns) {
				_ns.close();
			}
		}

		private function complete():void
		{
			pause();

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

			removeEventListener(Event.ENTER_FRAME, updateHandler);
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
			dispatchEvent(new VideoEvent(VideoEvent.LOAD_COMPLETE));
			removeEventListener(Event.ENTER_FRAME, loadProgress);
		}

		private function updateHandler(event:Event = null):void
		{
			update();
		}

		public function update(countup:Boolean = true):void
		{
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

			if (_isPlay && _nc.connected && time > 0 && duration > 0) {
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
			dispatchEvent(event);
		}

		//
		public function get time():Number
		{
			return _ns ? _ns.time : 0;
		}

		public function get duration():Number
		{
			return _metadata ? _metadata.duration : 0;
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
