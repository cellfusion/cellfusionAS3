package jp.cellfusion.debug 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;

	/**
	 * @author Mk-10:cellfusion
	 * SOSMax 用のデバッガークラス
	 * 
	 * SOSMax
	 * http://www.sos.powerflasher.com/
	 * 
	 * initialize 時に出力するレベルを設定できます
	 * デフォルトは trace まで出力
	 * 
	 * TODO 同時に複数の接続がある場合にどの接続かを判断するために uid を発行するようにする
	 */
	public class SOSDebugger 
	{
		private static var _isReady:Boolean;
		private static var _socket:XMLSocket;
		private static var _level:uint;
		public static const NONE:uint = 0;
		public static const TRACE:uint = 1;
		public static const DEBUG:uint = 2;
		public static const INFO:uint = 3;		public static const WARNING:uint = 4;		public static const ERROR:uint = 5;
		public static const FATAL:uint = 6;
		private static var _keys:Array;

		/**
		 * 初期化
		 * @param level 出力するレベルの設定(default INFO)
		 */
		public static function initialize(level:uint = INFO):void
		{
			if (_isReady) return;
			
			if (level == NONE) {
				_isReady = true;
				return;
			}
			
			_level = level;
			_keys = ['none', 'trace', 'debug', 'info', 'warning', 'error', 'fatal'];
			
			_socket = new XMLSocket();
			_socket.addEventListener(Event.CONNECT, connectHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			
			try {
				_socket.connect('localhost', 4444);
			} catch (e:SecurityError) {
//				trace('SecurityError in SOSAppender:' + e);
				return;
			}
			
			_isReady = true;
		}

		private static function errorHandler(event:Event):void
		{
//			trace('Error in SOSAppender:' + event);
		}

		private static function connectHandler(event:Event):void
		{
			log('!Connected is SOS!');
		}
		
		public static function trace(message:String):void
		{
			log(message, TRACE);
		}

		public static function debug(message:String):void
		{
			log(message, DEBUG);
		}
		
		public static function info(message:String):void
		{
			log(message, INFO);
		}
		
		public static function warning(message:String):void
		{
			log(message, WARNING);
		}
		
		public static function error(message:String):void
		{
			log(message, ERROR);
		}
		
		public static function fatal(message:String):void
		{
			log(message, FATAL);
		}
		
		private static function log(message:String, level:uint = INFO):void
		{
			if(!_isReady) {
//				initializeError();
//				return;
				initialize();
				log('初期化されていなかったので初期化しました');
			}
			
			if (_level < level) { return; }
			
			var key:String = _keys[level];
			
			// タグなどを変換
			message = message.replace(/\</g, "&lt;");
			message = message.replace(/\>/g, "&gt;");			message = message.replace(/\&/g, "&amp;");
			
			try {
				_socket.send("!SOS<showMessage key='"+key+"'>"+message+"</showMessage>\n");
			} catch (e:Error) {
				log('送信エラー');
			}
		}

		public static function dump(target:*):void
		{
			for (var idx:String in target) {
				if (target[idx] is Array) {
					debug(idx+':[');
					dump(target[idx]);
					debug(']');
				} else {
					debug(idx+':'+target[idx]);
				}
			}
		}

		public static function get level():uint
		{
			return _level;
		}
	}
}
