package jp.cellfusion.utils.sms
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	/**
	 * @author cellfusion
	 * http://developer.mixi.co.jp/connect/mixi_plugin/simplepost/spec_of_simplepost
	 */
	public class MixiUtil
	{
		public static function voice(message:String):void
		{
			var variables : URLVariables = new URLVariables();
			variables.status = message;
			
			var request : URLRequest = new URLRequest("https://mixi.jp/simplepost/voice");
			request.data = variables;
			request.method = URLRequestMethod.GET;
			
			navigateToURL(request, "_blank");
		}
		
		public static function dialy(title:String, body:String):void
		{
			var variables : URLVariables = new URLVariables();
			variables.title = title;
			variables.body = body;
			
			var request : URLRequest = new URLRequest("https://mixi.jp/simplepost/dialy");
			request.data = variables;
			request.method = URLRequestMethod.GET;
			
			navigateToURL(request, "_blank");
		}
		
		/**
		 * パスコードがいる
		 */
		public static function check(url:String, passcode:String):void
		{
			var variables : URLVariables = new URLVariables();
			variables.u = url;
			variables.k = passcode;
			
			var request : URLRequest = new URLRequest("http://mixi.jp/share.pl");
			request.data = variables;
			request.method = URLRequestMethod.GET;
			
			navigateToURL(request, "_blank");
		}
	}
}
