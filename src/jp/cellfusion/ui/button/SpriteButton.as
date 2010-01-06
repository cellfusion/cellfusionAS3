package jp.cellfusion.ui.button 
{
	import jp.cellfusion.ui.events.ButtonEvent;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class SpriteButton extends Sprite implements IButton 
	{
		protected var _normal:DisplayObject;
		protected var _over:DisplayObject;
		protected var _disable:DisplayObject;
		private var _enabled:Boolean;

		public function SpriteButton(normal:DisplayObject = null, over:DisplayObject = null, disable:DisplayObject = null)
		{
			_normal = normal || this['normal'];
			_over = over || this['over'];
			_disable = disable || this['disable'];
			
			if (_normal == null && _over == null && _disable == null) {
				throw new Error('ボタンに必要な DisplayObject がありません');
				return;
			}
			
			addEventListener(MouseEvent.ROLL_OVER, rollover);			addEventListener(MouseEvent.ROLL_OUT, rollout);			addEventListener(MouseEvent.CLICK, click);
			
			enabled = true;
		}
		
		public function atClick():void
		{
			enabled = false;
		}
		
		public function atRollover():void
		{
			_normal.visible = false;
			_over.visible = true;
			_disable.visible = false;
		}
		
		public function atRollout():void
		{
			_normal.visible = true;
			_over.visible = false;
			_disable.visible = false;
		}
		
		public function atEnable():void
		{
			_normal.visible = true;
			_over.visible = false;
			_disable.visible = false;
		}
		
		public function atDisable():void
		{
			_normal.visible = false;			_over.visible = false;			_disable.visible = true;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			buttonMode = value;
			value ? atEnable() : atDisable();
		}
		
		private function click(event:MouseEvent):void
		{
			if (enabled) {
				atClick();
				dispatchEvent(new ButtonEvent(ButtonEvent.CLICK));
			}
		}

		private function rollover(event:MouseEvent):void
		{
			if (enabled) {
				atRollover();
				dispatchEvent(new ButtonEvent(ButtonEvent.ROLL_OVER));
			}
		}
		
		private function rollout(event:MouseEvent):void
		{
			if (enabled) {
				atRollout();
				dispatchEvent(new ButtonEvent(ButtonEvent.ROLL_OUT));
			}
		}
		
		
	}
}
