package jp.cellfusion.ui.button 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class Button extends MovieClip implements IButton 
	{
		private var _target:MovieClip;

		public function Button(target:MovieClip)
		{
			_target = target;
			
			_target.addEventListener(MouseEvent.ROLL_OVER, rollover);
			_target.addEventListener(MouseEvent.ROLL_OUT, rollout);
			_target.addEventListener(MouseEvent.CLICK, click);
			
			super.mouseEnabled = false;
			_target.mouseEnabled = true;
			_target.buttonMode = true;
		}
		
		public function atClick():void
		{
		}
		
		public function atRollover():void
		{
		}
		
		public function atRollout():void
		{
		}
		
		public function atEnable():void
		{
		}
		
		public function atDisable():void
		{
		}

		override public function get mouseEnabled():Boolean
		{
			return _target.mouseEnabled;
		}

		override public function set mouseEnabled(value:Boolean):void
		{
			_target.mouseEnabled = value;
			value ? atEnable() : atDisable();
		}

		override public function get buttonMode():Boolean
		{
			return _target.buttonMode;
		}

		override public function set buttonMode(value:Boolean):void
		{
			_target.buttonMode = value;
		}

		private function click(event:MouseEvent):void
		{
			if (!mouseEnabled) return;
			dispatchEvent(event);
			atClick();
		}

		private function rollout(event:MouseEvent):void
		{
			if (!mouseEnabled) return;
			dispatchEvent(event);
			atRollout();
		}

		private function rollover(event:MouseEvent):void
		{
			if (!mouseEnabled) return;
			dispatchEvent(event);
			atRollover();
		}
	}
}
