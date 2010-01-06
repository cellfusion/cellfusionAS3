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
		protected var _normal:uint;
		protected var _over:uint;
		protected var _disable:uint;
		private var _target:uint;

		public function MovieClipButton(normal:String = 'normal', over:String = 'over', disable:String = 'disable')
		{
			_normal = getFrame(normal);
			_over = getFrame(over);
			_disable = getFrame(disable);
			
			if (_normal == 0 && _over == 0 && _disable == 0) {
				throw new Error('ボタンに必要なラベルがありません');
				return;
			}
			
			try {
				hitArea = this['hitarea'] || null;
				Sprite(this['hitarea']).alpha = 0;
			} catch (e:Error) {
				
			}
			
			mouseChildren = false;
			
			addEventListener(MouseEvent.ROLL_OVER, rollover);
			addEventListener(MouseEvent.ROLL_OUT, rollout);
			addEventListener(MouseEvent.CLICK, click);
			
			stop();
			enabled = true;
		}
		
		private function getFrame(label:String):uint
		{
			for each (var f:FrameLabel in currentLabels) {
				if (f.name == label) {
					return f.frame;
				}
			}
			
			return 0;
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
			tweenStart(_normal);
		}
		
		public function atEnable():void
		{
//			tweenStart(_normal);
			gotoAndStop(_normal);
		}
		
		public function atDisable():void
		{
//			tweenStart(_disable);
			gotoAndStop(_disable);
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
//			buttonMode = value;
			value ? atEnable() : atDisable();
		}
		
		private function tweenStart(frame:uint):void
		{
			_target = frame;
			addEventListener(Event.ENTER_FRAME, tweenProgress);
		}
		
		private function tweenComplete():void
		{
			removeEventListener(Event.ENTER_FRAME, tweenProgress);
		}
		
		private function tweenProgress(event:Event):void
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
