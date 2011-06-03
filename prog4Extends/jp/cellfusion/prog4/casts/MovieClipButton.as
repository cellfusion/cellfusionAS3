package jp.cellfusion.prog4.casts 
{
	import jp.progression.casts.CastMovieClip;

	import flash.display.FrameLabel;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class MovieClipButton extends CastMovieClip
	{
		private var _up:uint;
		private var _over:uint;
		private var _disable:uint;
		private var _target:uint;

		public function MovieClipButton(up:String = 'up', over:String = 'over', disable:String = 'disable', initObject:Object = null)
		{
			_up = getFrame(up);
			_over = getFrame(over);
			_disable = getFrame(disable);
			super(initObject);
			
			mouseChildren = false;
			stop();
			enabled = true;
			_target = _up;
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(MouseEvent.ROLL_OUT, rolloutHandler);
			addEventListener(MouseEvent.ROLL_OVER, rolloverHandler);
		}

//		override protected function atCastRemoved():void 
//		{
//			removeEventListener(MouseEvent.CLICK, clickHandler);
//			removeEventListener(MouseEvent.ROLL_OUT, rolloutHandler);
//			removeEventListener(MouseEvent.ROLL_OVER, rolloverHandler);
//			super.atCastRemoved();
//		}

		private function rolloverHandler(event:MouseEvent):void 
		{
			if (enabled) {
				atRollover();
			}
		}

		private function rolloutHandler(event:MouseEvent):void 
		{
			if (enabled) {
				atRollout();
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
			tweenStart(_over);
		}

		protected function atRollout():void 
		{
			tweenStart(_up);
		}

		protected function atEnable():void
		{
			tweenComplete();
			gotoAndStop(_up);
		}

		protected function atDisable():void
		{
			tweenComplete();
			gotoAndStop(_disable);
		}

		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			value ? atEnable() : atDisable();
		}

		final private function getFrame(label:String):uint
		{
			for each (var f:FrameLabel in currentLabels) {
				if (f.name == label) {
					return f.frame;
				}
			}
			
			return 1;
		}

		final private function tweenStart(frame:uint):void
		{
			_target = frame;
			addEventListener(Event.ENTER_FRAME, tweenProgress);
		}

		final private function tweenComplete():void
		{
			removeEventListener(Event.ENTER_FRAME, tweenProgress);
		}

		final private function tweenProgress(event:Event):void
		{
			var distance:int = _target - currentFrame;
			
			if (distance == 0) {
				tweenComplete();
			} else {
				distance > 0 ? nextFrame() : prevFrame();
			}
		}
	}
}
