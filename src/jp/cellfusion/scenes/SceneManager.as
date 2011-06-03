package jp.cellfusion.scenes
{
	import flash.events.Event;
	import flash.display.Stage;
	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class SceneManager
	{
		static private var _instance:SceneManager;
		private var _isInitialize:Boolean = false;
		private var _current:IScene;
		private var _stage:Stage;

		static public function get instance():SceneManager
		{
			if (!_instance) _instance = new SceneManager(new SingletonEnforcer());
			return _instance;
		}

		public function SceneManager(se:SingletonEnforcer)
		{
			super();
		}

		public function initialize(stage:Stage, scene:IScene):void
		{
			if (!_isInitialize) {
				_isInitialize = true;
			}
			
			scene.initialize(stage);
			_stage = stage;
			
			_current = scene;
			stage.addEventListener(Event.ENTER_FRAME, update);
		}

		private function update(event:Event):void
		{
			_current.update();
		}

		public function change(scene:IScene):void
		{
			_current.finalize();
			
			scene.initialize(_stage);
			_current = scene;
		}
	}
}

class SingletonEnforcer {}