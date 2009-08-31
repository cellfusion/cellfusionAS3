package jp.cellfusion.tweensy.thread 
{	import com.flashdynamix.motion.TweensyTimeline;	
	import com.flashdynamix.motion.Tweensy;
	
	import org.libspark.thread.Monitor;
	import org.libspark.thread.Thread;
	
	import flash.utils.getTimer;	

	/**	 * @author Mk-10:cellfusion	 */	public class TweensyThread extends Thread 
	{		private var _monitor:Monitor;
		private var _instance:Object;
		private var _to:Object;
		private var _duration:Number;
		private var _ease:Function;
		private var _delayStart:Number;
		private var _startTime:int;
		private var _timeline:TweensyTimeline;
		private var _update:Object;
		private var _updateHandler:Function;
		private var _updateParams:Array;

		public function TweensyThread(instance:Object, to:Object, duration:Number = 0.5, ease:Function = null, delayStart:Number = 0, update:Object = null, onUpdate:Function = null, onUpdateParams:Array = null)
		{
			_instance = instance;
			_to = to;
			_duration = duration;
			_ease = ease;
			_delayStart = delayStart;
			_update = update;
			_updateHandler = onUpdate;
			_updateParams = onUpdateParams;
						_monitor = new Monitor();		}

		override protected function run():void
		{
			_startTime = getTimer();
			
			_monitor.wait();
			interrupted(interruptedHandler);
			
			_timeline = Tweensy.to(_instance, _to, _duration, _ease, _delayStart, _update, completeHandler, null);
			if (_updateHandler) {
				_timeline.onUpdate = _updateHandler;
				_timeline.onUpdateParams = _updateParams;
			}
		}
		
		private function interruptedHandler():void
		{
			if (!_timeline) {
				return;
			}
			
			if (_timeline.playing) {
				_timeline.stop();
			}
		}

		private function completeHandler():void
		{
			_monitor.notify();
		}
	}}