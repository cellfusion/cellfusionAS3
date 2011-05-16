package jp.cellfusion.prog4.commands.tween
{
	import jp.progression.commands.Command;

	import com.flashdynamix.motion.TweensyGroup;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 * execute 時に TweensyGroup にデータを渡して実行する TweensyGroup コマンド
	 * 暫定的に to のみ実装する
	 */
	public class DoTweensyGroup extends Command
	{
		private var _tg:TweensyGroup;
		private var _params:Vector.<TweensyParameter>;
		private var _onUpdate:Function;

		public function DoTweensyGroup(initObject:Object = null)
		{
			_tg = new TweensyGroup();
			_params = new Vector.<TweensyParameter>();

			super(_executeFunction, _interruptFunction, initObject);
		}

		public function to(instance:Object, to:Object, duration:Number = 0.5, ease:Function = null, delayStart:Number = 0.0, update:Object = null, onComplete:Function = null, onCompleteParams:Array = null):void
		{
			_params.push(new TweensyParameter(instance, null, to, duration, ease, delayStart, update, onComplete, onCompleteParams));
		}

		public function from(instance:Object, from:Object, duration:Number = 0.5, ease:Function = null, delayStart:Number = 0.0, update:Object = null, onComplete:Function = null, onCompleteParams:Array = null):void
		{
			_params.push(new TweensyParameter(instance, from, null, duration, ease, delayStart, update, onComplete, onCompleteParams));
		}
		
		public function fromTo(instance:Object, from:Object, to:Object, duration:Number = 0.5, ease:Function = null, delayStart:Number = 0.0, update:Object = null, onComplete:Function = null, onCompleteParams:Array = null):void
		{
			_params.push(new TweensyParameter(instance, from, to, duration, ease, delayStart, update, onComplete, onCompleteParams));
		}

		private function _interruptFunction():void
		{
			_tg.stopAll();
		}

		private function _executeFunction():void
		{
			_tg.onUpdate = _update;
			_tg.onComplete = _complete;

			for each (var i : TweensyParameter in _params) {
				if (i.to && i.from) {
					_tg.fromTo(i.instance, i.from, i.to, i.duration, i.ease, i.delayStart, i.update, i.onComplete, i.onComplteParams);
				} else if (i.to) {
					_tg.to(i.instance, i.to, i.duration, i.ease, i.delayStart, i.update, i.onComplete, i.onComplteParams);
				} else if (i.from) {
					_tg.from(i.instance, i.from, i.duration, i.ease, i.delayStart, i.update, i.onComplete, i.onComplteParams);
				}
			}
		}

		private function _update():void
		{
			if (_onUpdate != null) {
				_onUpdate();
			}
		}

		private function _complete():void
		{
			// _tg.dispose();
			// _tg = null;

			executeComplete();
		}

		public override function clone():Command
		{
			var temp:DoTweensyGroup = new DoTweensyGroup();

			for each (var i : TweensyParameter in _params) {
				temp.to(i.instance, i.to, i.duration, i.ease, i.delayStart, i.update, i.onComplete, i.onComplteParams);
			}

			return temp;
		}

		public function get onUpdate():Function
		{
			return _onUpdate;
		}

		public function set onUpdate(value:Function):void
		{
			_onUpdate = value;
		}
	}
}
class TweensyParameter
{
	private var _instance:Object;
	private var _to:Object;
	private var _duration:Number;
	private var _ease:Function;
	private var _delayStart:Number;
	private var _update:Object;
	private var _onComplete:Function;
	private var _onComplteParams:Array;
	private var _from:Object;

	public function TweensyParameter(instance:Object, from:Object = null, to:Object = null, duration:Number = 0.5, ease:Function = null, delayStart:Number = 0.0, update:Object = null, onComplete:Function = null, onComplteParams:Array = null)
	{
		_onComplteParams = onComplteParams;
		_onComplete = onComplete;
		_update = update;
		_delayStart = delayStart;
		_ease = ease;
		_duration = duration;
		_to = to;
		_from = from;
		_instance = instance;
	}

	public function get instance():Object
	{
		return _instance;
	}

	public function get to():Object
	{
		return _to;
	}

	public function get duration():Number
	{
		return _duration;
	}

	public function get ease():Function
	{
		return _ease;
	}

	public function get delayStart():Number
	{
		return _delayStart;
	}

	public function get update():Object
	{
		return _update;
	}

	public function get onComplete():Function
	{
		return _onComplete;
	}

	public function get onComplteParams():Array
	{
		return _onComplteParams;
	}

	public function get from():Object
	{
		return _from;
	}
}