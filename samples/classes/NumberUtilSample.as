package
{
	import jp.cellfusion.utils.NumberUtil;
	import flash.display.Sprite;

	/**
	 * @author cellfusion
	 */
	public class NumberUtilSample extends Sprite
	{
		public function NumberUtilSample()
		{
			trace(NumberUtil.format(100000000));
			trace(NumberUtil.digit(1234, 6));
			trace(NumberUtil.decimal(1.534, 1));
		}
	}
}
