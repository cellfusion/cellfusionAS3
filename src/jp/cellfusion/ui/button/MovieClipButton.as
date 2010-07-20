package jp.cellfusion.ui.button 
{
	import jp.cellfusion.ui.events.ButtonEvent;

	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class MovieClipButton extends MovieClip implements IButton 
	{
		protected var _up:uint;
		protected var _over:uint;
		protected var _disable:uint;
		private var _target:uint;
		private var _anime:Boolean = true;

		public function MovieClipButton(up:String = 'up', over:String = 'over', disable:String = 'disable')
		{
			_up = getFrame(up);
			_over = getFrame(over);
			_disable = getFrame(disable);
			
			if (_up == 0 && _over == 0 && _disable == 0) {
//				_anime = false;
//				throw new Error('ボタンに必要なラベルがありません');
//				return;
			}
			
			try {
				hitArea = this['hitarea'] || null;
				Sprite(this['hitarea']).alpha = 0;
			} catch (e:Error) {
			}
			
			mouseChildren = false;
			buttonMode = true;
			
			addEventListener(MouseEvent.ROLL_OVER, rollover);
			addEventListener(MouseEvent.ROLL_OUT, rollout);
			addEventListener(MouseEvent.CLICK, click);
			
			stop();
			enabled = true;
		}

		protected function getFrame(label:String):uint
		{
			for each (var f:FrameLabel in currentLabels) {
				if (f.name == label) {
					return f.frame;
				}
			}
			
			return 1;
		}

		public function atClick():void
		{
			enabled = false;
		}

		public function atRollover():void
		{
			tweenStart(_over);
		}

		public function atRollout():void
		{
			tweenStart(_up);
		}

		public function atEnable():void
		{
			removeEventListener(Event.ENTER_FRAME, tweenProgress);
			gotoAndStop(_up);
		}

		public function atDisable():void
		{
			removeEventListener(Event.ENTER_FRAME, tweenProgress);
			gotoAndStop(_disable);
		}

		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			value ? atEnable() : atDisable();
		}

		protected function tweenStart(frame:uint):void
		{
			_target = frame;
			addEventListener(Event.ENTER_FRAME, tweenProgress);
		}

		protected function tweenComplete():void
		{
			removeEventListener(Event.ENTER_FRAME, tweenProgress);
		}

		protected function tweenProgress(event:Event):void
		{
			var distance:int = _target - currentFrame;
			
			if (distance == 0) {
				tweenComplete();
			} else {
				distance > 0 ? nextFrame() : prevFrame();
			}
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
