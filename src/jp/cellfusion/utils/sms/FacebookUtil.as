package jp.cellfusion.utils.sms
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	/**
	 * @author cellfusion
	 */
	public class FacebookUtil
	{
		public static function share(url:String):void
		{
			var variables : URLVariables = new URLVariables();
			variables.u= url;
			
			var request : URLRequest = new URLRequest("http://www.facebook.com/sharer/sharer.php");
			request.data = variables;
			request.method = URLRequestMethod.GET;
			
			navigateToURL(request, "_blank");
		}
	}
}
