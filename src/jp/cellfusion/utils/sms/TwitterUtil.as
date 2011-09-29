package jp.cellfusion.utils.sms
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	/**
	 * @author cellfusion
	 */
	public class TwitterUtil
	{
		/**
		 * http://dev.twitter.com/pages/intents#tweet-intent
		 */
		public static function tweet(text:String = "", url:String = "", hashtags:Array = null, via:String = "", replyId:String = ""):void
		{
			var variables : URLVariables = new URLVariables();
			variables.text = text;
			variables.url = url;
			if (hashtags) variables.hashtags = hashtags.join(",");
			if (via != "") variables.via = via;
			if (replyId != "") variables.in_reply_to = replyId;
			
			var request : URLRequest = new URLRequest("http://twitter.com/intent/tweet");
			request.data = variables;
			request.method = URLRequestMethod.GET;
			
			navigateToURL(request, "_blank");
		}
		
		/**
		 * http://dev.twitter.com/pages/intents#retweet-intent
		 */
		public static function retweet(tweetId:String):void
		{
			var variables : URLVariables = new URLVariables();
			variables.tweet_id = tweetId;
			
			var request : URLRequest = new URLRequest("http://twitter.com/intent/retweet");
			request.data = variables;
			request.method = URLRequestMethod.GET;
			
			navigateToURL(request, "_blank");
		}
		
		/**
		 * http://dev.twitter.com/pages/intents#favorite-intent
		 */
		public static function favorite(tweetId:String):void
		{
			var variables : URLVariables = new URLVariables();
			variables.tweet_id = tweetId;
			
			var request : URLRequest = new URLRequest("http://twitter.com/intent/favorite");
			request.data = variables;
			request.method = URLRequestMethod.GET;
			
			navigateToURL(request, "_blank");
		}
	}
}
