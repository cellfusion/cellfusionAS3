package jp.cellfusion.ui 
{
	import flash.display.Sprite;
	import flash.display.Stage;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class AbstractUI 
	{
		public static var _stage:Stage;
		private static var _display:Sprite;
		private static var _isReady:Boolean = false;

		public static function initialize(display:Sprite):void
		{
			if (_isReady) {
				return;
			}
			
			_display = display;
			
			try {
				_stage = _display.root.stage;
			} catch (e:Error) {
				return;
			}
			_isReady = true;
		}
		
		static public function get isReady():Boolean
		{
			return _isReady;
		}
	}
}