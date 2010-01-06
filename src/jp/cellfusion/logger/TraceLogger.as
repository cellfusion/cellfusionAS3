package jp.cellfusion.logger 
{

	/**
	 * @author cellfusion
	 */
	public class TraceLogger implements ILogger 
	{
		public function output(message:String, key:String):void 
		{
			trace("[" + key + "] " + message);
		}
	}
}