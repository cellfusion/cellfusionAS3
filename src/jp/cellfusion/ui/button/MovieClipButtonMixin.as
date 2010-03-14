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
	public class MovieClipButtonMixin implements IButton 
	{
		protected var _normal:uint;
		protected var _over:uint;
		protected var _disable:uint;
		private var _targetFrame:uint;
		private var _target:MovieClip;

		public function MovieClipButtonMixin(target:MovieClip, normal:String = 'normal', over:String = 'over', disable:String = 'disable')
		{
			_target = target;
			_normal = getFrame(normal);
			_over = getFrame(over);
			_disable = getFrame(disable);
			
			if (_normal == 0 && _over == 0 && _disable == 0) {
				throw new Error('ボタンに必要なラベルがありません');
				return;
			}
			
			try {
				_target.hitArea = this['hitarea'] || null;
				Sprite(this['hitarea']).alpha = 0;
			} catch (e:Error) {
				
			}
			
			_target.mouseChildren = false;
			
			_target.addEventListener(MouseEvent.ROLL_OVER, rollover);
			_target.addEventListener(MouseEvent.ROLL_OUT, rollout);
			_target.addEventListener(MouseEvent.CLICK, click);
			
			_target.stop();
			enabled = true;
		}
		
		private function getFrame(label:String):uint
		{
			for each (var f:FrameLabel in _target.currentLabels) {
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
			_target.gotoAndStop(_normal);
		}
		
		public function atDisable():void
		{
//			tweenStart(_disable);
			_target.gotoAndStop(_disable);
		}
		
		public function set enabled(value:Boolean):void
		{
//			buttonMode = value;
			value ? atEnable() : atDisable();
		}
		
		private function tweenStart(frame:uint):void
		{
			_targetFrame = frame;
			_target.addEventListener(Event.ENTER_FRAME, tweenProgress);
		}
		
		private function tweenComplete():void
		{
			_target.removeEventListener(Event.ENTER_FRAME, tweenProgress);
		}
		
		private function tweenProgress(event:Event):void
		{
			var distance:int = _targetFrame - _target.currentFrame;
			
			if (distance == 0) {
				tweenComplete();
			} else {
				distance > 0 ? _target.nextFrame() : _target.prevFrame();
			}
		}
		
		private function click(event:MouseEvent):void
		{
			if (_target.enabled) {
				atClick();
				_target.dispatchEvent(new ButtonEvent(ButtonEvent.CLICK));
			}
		}

		private function rollover(event:MouseEvent):void
		{
			if (_target.enabled) {
				atRollover();
				_target.dispatchEvent(new ButtonEvent(ButtonEvent.ROLL_OVER));
			}
		}
		
		private function rollout(event:MouseEvent):void
		{
			if (_target.enabled) {
				atRollout();
				_target.dispatchEvent(new ButtonEvent(ButtonEvent.ROLL_OUT));
			}
		}
		
		public function get x():Number
		{
			return _target.x;
		}

		public function get y():Number
		{
			return _target.y;
		}
		
		public function get enabled():Boolean
		{
			return _target.enabled;
		}
		
		public function get buttonMode():Boolean
		{
			return _target.buttonMode;
		}

		public function get visible():Boolean
		{
			return _target.visible;
		}

		public function set x(value:Number):void
		{
			_target.x = value;
		}

		public function set y(value:Number):void
		{
			_target.y = value;
		}
		
		public function set buttonMode(value:Boolean):void
		{
			_target.buttonMode = value;
		}
		
		public function set visible(value:Boolean):void
		{
			_target.visible = value;
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _target.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _target.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _target.willTrigger(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_target.removeEventListener(type, listener, useCapture);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_target.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	}
}
