package jp.cellfusion.ui.button 
{
	import flash.display.Sprite;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class ToggleButton extends Sprite implements IToggleButton 
	{
		protected var _current:IButton;
		protected var _on:IButton;
		protected var _off:IButton;
		private var _enabled:Boolean;

		public function ToggleButton(on:IButton = null, off:IButton = null)
		{
			_on = on || this['onButton'];
			_off = off || this['offButton'];
			
			if (_on == null && _off == null) {
				throw new Error('ToggleButton に必要な Button が存在しません');
				return;
			}
			
			change('on');
		}
		
		public function change(state:String):void
		{
			_current = state == 'on' ? _on : _off;
			
			_on.visible = state == 'on';
			_on.enabled = state == 'on';
			_off.visible = state == 'off';
			_off.enabled = state == 'off';
		}

		public function atClick():void
		{
			_current.atClick();
			toggle();
		}
		
		public function atRollover():void
		{
			_current.atRollover();
		}
		
		public function atRollout():void
		{
			_current.atRollout();
		}
		
		public function atEnable():void
		{
			_current.atEnable();
		}
		
		public function atDisable():void
		{
			_current.atDisable();
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			value ? atEnable() : atDisable();
		}
		
		private function toggle():void
		{
			_current == _on ? change('on') : change('off');
		}
	}
}
