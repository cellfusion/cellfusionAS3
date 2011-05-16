package jp.cellfusion.data 
{
	import flash.utils.Dictionary;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class Config 
	{
		static private var _instance:Config;
		private var _urls:Dictionary;

		static public function get instance():Config
		{
			if (!_instance) _instance = new Config(new SingletonEnforcer());
			return _instance;
		}

		public function Config(se:SingletonEnforcer) 
		{
			_urls = new Dictionary();
		}

		public function initialize(xml:XML):void 
		{
			var lists:XMLList = xml.alias;
			// parse
			for each (var i : XML in lists) {
				_urls[String(i.@id)] = String(i.@url);
			}
		}

		public function getUrl(id:String):String
		{
			return _urls[id];
		}
	}
}

class SingletonEnforcer 
{
}