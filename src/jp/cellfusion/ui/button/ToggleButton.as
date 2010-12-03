package jp.cellfusion.ui.button
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class ToggleButton extends MovieClip implements IToggleButton,IButton
	{
		public var onButton:IButton;
		public var offButton:IButton;
		protected var _current:IButton;
		private var _invisible:Boolean;

		public function ToggleButton(invisible:Boolean = true)
		{
			_invisible = invisible;

			mouseChildren = false;
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, click);
			addEventListener(MouseEvent.ROLL_OVER, rollover);
			addEventListener(MouseEvent.ROLL_OUT, rollout);

			change('on');
		}

		private function rollout(event:MouseEvent):void
		{
			if (enabled) {
				atRollout();
			}
		}

		private function rollover(event:MouseEvent):void
		{
			if (enabled) {
				atRollover();
			}
		}

		private function click(event:MouseEvent):void
		{
			if (enabled) {
				atClick();
			}
		}

		private function toggle():void
		{
			_current == onButton ? change('off') : change('on');
		}

		public function change(state:String):void
		{
			_current = state == 'on' ? onButton : offButton;

			if (_invisible) {
				onButton.visible = state == 'on';
				offButton.visible = state == 'off';
			}

			onButton.enabled = state == 'on';
			offButton.enabled = state == 'off';

			hitArea = Sprite(state == 'on' ? onButton : offButton);

			mouseChildren = false;
		}

		public function atClick():void
		{
			_current.atClick();
			toggle();
		}

		public function atRollout():void
		{
			_current.atRollout();
		}

		public function atRollover():void
		{
			_current.atRollover();
		}

		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			value ? atEnable() : atDisable();
		}

		public function atEnable():void
		{
		}

		public function atDisable():void
		{
		}
	}
}
