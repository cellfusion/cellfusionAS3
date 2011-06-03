package jp.cellfusion.ui.button
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
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

		public function ToggleButton(invisible:Boolean = true, b:Boolean = true)
		{
			_invisible = invisible;

			buttonMode = true;
			addEventListener(MouseEvent.CLICK, click);
			addEventListener(MouseEvent.ROLL_OVER, rollover);
			addEventListener(MouseEvent.ROLL_OUT, rollout);

			if (b) {
				mouseChildren = false;
				change('on');
			}
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
			
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function atClick():void
		{
			if (_current) {
				_current.atClick();
				toggle();
			} else {
				var state:String = "";
				if (Sprite(onButton).hitTestPoint(stage.mouseX, stage.mouseY)) {
					state = "off";
				} else if (Sprite(offButton).hitTestPoint(stage.mouseX, stage.mouseY)) {
					state = "on";
				}
				
				change(state);
			}
		}

		public function atRollout():void
		{
			if (_current) {
				_current.atRollout();
			}
		}

		public function atRollover():void
		{
			if (_current) {
				_current.atRollover();
			}
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
