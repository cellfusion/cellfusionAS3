package jp.cellfusion.thread 
{

	/**
	 * @author Mk-10:cellfusion
	 */
	public class DelayFunctionThread extends Thread 
	{
		private var _func:Function;
		private var _params:Array;
		private var _delay:uint;

		public function DelayFunctionThread(delay:uint, func:Function, ...params)
		{ 
			_delay = delay;
			_func = func;
			_params = params;
		}

		override protected function run():void 
		{
			sleep(_delay);
			next(execute);
		}

		private function execute():void
		{
			_func.apply(null, _params);
		}

		override protected function finalize():void 
		{
			_func = null;
			_params = null;
		}
	}
}
