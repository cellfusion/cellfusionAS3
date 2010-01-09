package jp.cellfusion.logger 
{

	/**
	 * @author cellfusion
	 * initialize 時に出力するレベルを設定できます
	 * デフォルトは trace まで出力
	 */
	public class Logger 
	{
		public static const NONE:uint = 0;
		public static const TRACE:uint = 1;
		public static const DEBUG:uint = 2;
		public static const INFO:uint = 3;
		public static const WARNING:uint = 4;
		public static const ERROR:uint = 5;
		public static const FATAL:uint = 6;
		private static var _level:uint;
		private static var _ready:Boolean = false;
		private static var _keys:Array;
		private static var _loggers:Array;

		/**
		 * initialize 時に Logger も作成する
		 */
		public static function initialize(level:uint = INFO):void 
		{
			if (_ready) return;
			
			if (level == Logger.NONE) {
				_ready = true;
				return;
			}
			_level = level;
			_keys = ['none', 'trace', 'debug', 'info', 'warning', 'error', 'fatal'];
			
			_loggers = [];
			
			// 指定してある Logger だけ作成
			_loggers.push(new SOSLogger());
			_loggers.push(new TraceLogger());
			
			_ready = true;
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

		private static function log(message:String, level:uint):void 
		{
			if(!_ready) {
				initializeError();
				return;
			}
			
			if (_level < level) { 
				return; 
			}
			
			var key:String = _keys[level];
			for each (var l:ILogger in _loggers) {
				l.output(message, key);
			}
		}

		private static function initializeError():void 
		{
		}

		public static function get level():uint {
			return _level;
		}
		
		static public function get ready():Boolean {
			return _ready;
		}
	}
}