package
{
	import flash.text.TextFieldType;
	import flash.text.TextField;
	import flash.display.Sprite;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class RegExpTest extends Sprite
	{
		private var _input:TextField;
		private var _result:TextField;
		public function RegExpTest()
		{
			_input = new TextField();
			_input.type = TextFieldType.INPUT;
			_input.multiline = true;
			_input.wordWrap = true;
			
			_result = new TextField();
			_result.type = TextFieldType.DYNAMIC;
			_result.multiline = true;
			_result.wordWrap = true;
			
			
		}
	}
}
