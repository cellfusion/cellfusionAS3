package jp.cellfusion.prog4.commands.net
{
	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class LoadXML extends LoadData
	{
		public function LoadXML(request:URLRequest, initObject:Object = null)
		{
			super(request, initObject);
		}

		override protected function _complete(e:Event):void
		{
			// データを保持する
			super.data = new XML(_loader.data);

			// 破棄する
			_destroy();
			
			_initialize();

			// 処理を終了する
			super.executeComplete();
		}
	}
}
