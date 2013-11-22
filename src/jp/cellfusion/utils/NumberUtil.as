package jp.cellfusion.utils
{
	/**
	 * @author cellfusion
	 */
	public class NumberUtil
	{
		static public function format(number:Number):String
		{
			var numInteger:int = Math.floor(num);
			
			var words:Array = String(numInteger).split("").reverse();
			var l:int = words.length;
			for ( var i:int = 3; i < l; i += 3 ) {
				if ( words[i] ) {
					words.splice(i, 0, ",");
					i++;
					l++;
				}
			}

			var res:String = words.reverse().join("");

			if (num - numInteger > 0) {
				res = res + "." + num.toString().split(".")[1];
			}

			return res;
		}

		static public function digit(number:Number, figure:int):String
		{
			var str:String = String(number);
			for ( var i:int = 0; i < figure; i++ ) {
				str = "0" + str;
			}
			return str.substr(str.length - figure, str.length);
		}

		public static function decimal(number:Number, figure:uint = 1):String
		{
			var numInteger:int = Math.floor(num);

			if (figure == 0) return numInteger.toString();
			return numInteger + "." + Math.floor((num - numInteger) * Math.pow(10, figure));
		}
	}
}
