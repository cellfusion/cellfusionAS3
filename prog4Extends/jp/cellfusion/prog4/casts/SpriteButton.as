package jp.cellfusion.prog4.casts 
{
	import jp.progression.casts.CastSprite;

	import flash.events.MouseEvent;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class SpriteButton extends CastSprite 
	{
		private var _enabled:Boolean;

		public function SpriteButton(initObject:Object = null)
		{
			super(initObject);
			mouseChildren = false;
			enabled = true;
			buttonMode = true;
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(MouseEvent.ROLL_OVER, rolloverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rolloutHandler);
		}

//		override protected function atCastRemoved():void 
//		{
//			removeEventListener(MouseEvent.CLICK, clickHandler);
//			removeEventListener(MouseEvent.ROLL_OVER, rolloverHandler);
//			removeEventListener(MouseEvent.ROLL_OUT, rolloutHandler);
//			super.atCastRemoved();
//		}

		final private function rolloutHandler(event:MouseEvent):void 
		{
			if (enabled) {
				atRollout();
			}
		}

		final private function rolloverHandler(event:MouseEvent):void 
		{
			if (enabled) {
				atRollover();
			}
		}

		final private function clickHandler(event:MouseEvent):void
		{
			if (enabled) {
				atClick();
			}
		}

		protected function atClick():void 
		{
			enabled = false;
			mouseEnabled = false;
		}

		protected function atRollover():void 
		{
		}

		protected function atRollout():void 
		{
		}

		protected function atEnable():void
		{
		}

		protected function atDisable():void
		{
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			value ? atEnable() : atDisable();
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
	}
}
