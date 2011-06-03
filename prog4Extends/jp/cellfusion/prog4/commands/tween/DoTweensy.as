package jp.cellfusion.prog4.commands.tween
{
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;

	import com.flashdynamix.motion.Tweensy;
	import com.flashdynamix.motion.TweensyTimeline;

	public class DoTweensy extends Command
	{
		public function get target():Object
		{
			return _target;
		}

		private var _target:Object;

		public function get parameters():Object
		{
			return _parameters;
		}

		private var _parameters:Object;
		private var _executingParams:Object;
		private var _before:Object;
		private var _timeline:TweensyTimeline;

		public function get duration():Number
		{
			return _duration;
		}

		private var _duration:Number;

		public function get ease():Function
		{
			return _ease;
		}

		private var _ease:Function;

		public function get delayStart():Number
		{
			return _delayStart;
		}

		private var _delayStart:Number;

		public function get update():Object
		{
			return _update;
		}

		private var _update:Object;

		public function get onCompleteFunc():Function
		{
			return _onCompleteFunc;
		}

		private var _onCompleteFunc:Function;

		public function get onCompleteParams():Array
		{
			return _onCompleteParams;
		}

		private var _onCompleteParams:Array;

		/**
		 * <p>新しい DoTweener インスタンスを作成します。</p>
		 * <p>Creates a new DoTweener object.</p>
		 * 
		 * @param target
		 * <p></p>
		 * <p>Any object that will suffer a tweening. These objects are usually MovieClip, TextField, or Sound instances, or any other custom object with a numeric property that needs to be tweened.</p>
		 * @param tweeningParameters
		 * <p></p>
		 * <p>An object containing various properties of the original object that you want to tween on the original objects, with their final values assigned (some special properties are also allowed), as well as some built-in Tweener properties used when defining tweening parameters. This is like the recipe for the tweening, declaring both what will be tweened, and how.</p>
		 * @param initObject
		 * <p>設定したいプロパティを含んだオブジェクトです。</p>
		 * <p></p>
		 */
		public function DoTweensy(target:Object, parameters:Object, duration:Number, ease:Function = null, delayStart:Number = 0, update:Object = null, onCompleteFunc:Function = null, onCompleteParams:Array = null, initObject:Object = null)
		{
			// 引数を設定する
			_target = target;
			_parameters = parameters || {};
			_duration = duration;
			_ease = ease;
			_delayStart = delayStart;
			_update = update;
			_onCompleteFunc = onCompleteFunc || new Function();
			_onCompleteParams = onCompleteParams;

			// 親クラスを初期化する
			super(_executeFunction, _interruptFunction, initObject);
		}

		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void
		{
			// 現在の状態を保存する
			_before = {};
			_executingParams = {};
			for ( var p:String in _parameters ) {
				_executingParams[p] = _parameters[p];
				if ( p in _target ) {
					_before[p] = _target[p];
				}
			}

			// 実行する
			_timeline = Tweensy.to(_target, _parameters, _duration, _ease, _delayStart, _update, _onComplete);
		}

		private function _clear():void
		{
			_timeline.dispose();
			_timeline = null;
			_ease = null;
			_update = null;
			_onCompleteFunc = null;
			_onCompleteParams = null;
		}

		/**
		 * 
		 */
		private function _onComplete():void
		{
			// 初期状態を破棄する
			_before = null;
			_executingParams = null;
			_onCompleteFunc.apply(null, _onCompleteParams);
			_clear();
			// 処理を終了する
			super.executeComplete();
		}

		/**
		 * 
		 */
		private function _onError(errorScope:Object, metaError:Error):void
		{
			errorScope;

			// 初期状態を破棄する
			_before = null;
			_executingParams = null;
			_clear();
			// 例外をスローする
			super.throwError(this, metaError);
		}

		/**
		 * 中断実行されるコマンドの実装です。
		 */
		private function _interruptFunction():void
		{
			// 実行中のパラメータを取得する
			// var params:Array = [ _target ];
			// for ( var p:String in _executingParams ) {
			// params.push( p );
			// }

			// 中断する
			try {
				Tweensy.remove.apply(null, _timeline);
				// Tweener.removeTweens.apply( null, params );
			} catch ( e:Error ) {
			}

			// 実行時間を 0 にする
			// _before.time = 0;
			_duration = 0;
			_executingParams.duration = 0;

			// 中断方法によって処理を振り分ける
			trace("interruptType=", interruptType);
			switch ( interruptType ) {
				// case 0	: { Tweener.addTween( _target, _before ); break; }
				case 0	:
					{
						_timeline.yoyo();
						break; }
				// case 2	: { Tweener.addTween( _target, _executingParams ); break; }
				case 2	:
					{
						_timeline.stop();
						break; }
			}

			// 初期状態を破棄する
			_before = null;
			_executingParams = null;
			_clear();
		}

		public override function clone():Command
		{
			return new DoTweensy(_target, _parameters, _duration, _ease, _delayStart, _update, _onCompleteFunc, _onCompleteParams, this);
		}

		public override function toString():String
		{
			return ObjectUtil.formatToString(this, super.className, super.id ? "id" : null, "target");
		}
	}
}
