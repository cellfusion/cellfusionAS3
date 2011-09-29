package jp.cellfusion.utils
{
	/**
	 * @author cellfusion
	 */
	public class NumberUtil
	{
		static public function format(number:Number):String
		{
			var words:Array = String(number).split("").reverse();
			var l:int = words.length;
			for ( var i:int = 3; i < l; i += 3 ) {
				if ( words[i] ) {
					words.splice(i, 0, ",");
					i++;
					l++;
				}
			}
			return words.reverse().join("");
		}

		static public function digit(number:Number, figure:int):String
		{
			var str:String = String(number);
			for ( var i:int = 0; i < figure; i++ ) {
				str = "0" + str;
			}
			return str.substr(str.length - figure, str.length);
		}

		public static function decimal(number:Number, figure:int = 1):String
		{
			var tmp:String = "";
			var num:Array = String(number).split(".");
			if (!num[1]) num[1] = "0";
			return num[0] + "." + num[1].substr(0, figure);
		}
	}
}
