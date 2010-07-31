package jp.cellfusion.geom 
{
	import flash.geom.Point;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class Line 
	{
		private var _x0:Number;
		private var _x1:Number;
		private var _y0:Number;
		private var _y1:Number;

		public function Line(...param) 
		{
			if (param.length == 4) {
				initAtNumber(param[0], param[1], param[2], param[3]);
			} else if (param.length == 2) {
				initAtPoint(param[0], param[1]);
			} else {
				throw new Error("パラメーターの数が違います");
			}
		}

		private function initAtPoint(p0:Point, p1:Point):void 
		{
			_x0 = p0.x;
			_y0 = p0.y;
			_x1 = p1.x;
			_y1 = p1.y;
		}

		private function initAtNumber(x0:Number, y0:Number, x1:Number, y1:Number):void 
		{
			_x0 = x0;
			_y0 = y0;
			_x1 = x1;
			_y1 = y1;
		}

		public function cross(l:Line):Point
		{
			var det:Number = l.f * g - f * l.g;
 			
 			if (det == 0) return null;
 			
			var dx:Number = l.x - x;
			var dy:Number = l.y - y;
			
			var t1:Number = (l.f *dy - l.g * dx) / det;
			var t2:Number = (f *dy - g * dx) / det;
 			
			return division(t1);
		}

		public function division(d:Number):Point 
		{
			return new Point(x+f*d, y+g*d);
		}

		public function get x() : Number {
			return _x0;
		}
		
		public function get y() : Number {
			return _y0;
		}

		public function get f():Number 
		{
			return _x1 - _x0;
		}

		public function get g():Number 
		{
			return _y1 - _y0;
		}
	}
}
