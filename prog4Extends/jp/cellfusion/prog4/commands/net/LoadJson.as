package jp.cellfusion.prog4.commands.net
{
	import flash.net.URLRequest;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class LoadJson extends LoadData
	{
		public function LoadJson(request:URLRequest, initObject:Object = null)
		{
			super(request, initObject);
		}
	}
}
