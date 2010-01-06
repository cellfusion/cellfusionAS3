package jp.cellfusion.logger 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;

	/**
	 * @author Mk-10:cellfusion
	 * SOSMax 用のロガークラス
	 * 
	 * SOSMax
	 * http://www.sos.powerflasher.com/
	 */
	public class SOSLogger implements ILogger 
	{
		private var _socket:XMLSocket;
		private var _ready:Boolean = false;

		/**
		 * 初期化
		 * @param level 出力するレベルの設定(default INFO)
		 */
		public function SOSLogger() 
		{
			_socket = new XMLSocket();
			_socket.addEventListener(Event.CONNECT, connectHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			
			try {
				_socket.connect('localhost', 4444);
			} catch (e:SecurityError) {
				Logger.error('SecurityError in SOSAppender:' + e);
				return;
			}
			
			_ready = true;
		}

		private function errorHandler(event:Event):void 
		{
			Logger.error('Error in SOSAppender:' + event);
		}

		private function connectHandler(event:Event):void 
		{
			Logger.info('!Connected is SOS!');
		}

		public function output(message:String, key:String):void 
		{
			if (!_ready) {
				return;
			}
			
			// タグなどを変換
			message = message.replace(/\</g, "&lt;");
			message = message.replace(/\>/g, "&gt;");
			message = message.replace(/\&/g, "&amp;");
			
			try {
				_socket.send("!SOS<showMessage key='" + key + "'>" + message + "</showMessage>\n");
			} catch (e:Error) {
				Logger.error('SOSLogger send Error.');
			}
		}
	}
}