package jp.cellfusion.debug
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.display.Sprite;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class Console extends Sprite
	{
		static private var _instance:Console;
		private var _params:Dictionary;

		static public function get instance():Console
		{
			if (!_instance) _instance = new Console(new SingletonEnforcer());
			return _instance;
		}

		public function Console(se:SingletonEnforcer)
		{
			super();
			_params = new Dictionary();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		private function addedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			addEventListener(Event.ENTER_FRAME, update);
		}

		private function update(event:Event):void
		{
			
		}
		
		/**
		 * 指定した name の data を更新
		 */
		public function param(name:String, data:*):void
		{
		}
		
		/**
		 * 
		 */
		public function log(...args):void
		{
		}
		
		/**
		 * log をクリア
		 */
		public function clear():void
		{
		}
	}
}
class SingletonEnforcer
{
}