package jp.cellfusion.display 
{
	import jp.cellfusion.geom.Line;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class MappingDisplay extends Sprite 
	{
		public static const TRIANGLE:uint = 0;
		public static const TRIANGLE_STRIP:uint = 1;
		
		private var _vertices:Vector.<Number>;
		private var _indices:Vector.<int>;
		private var _uv:Vector.<Number>;
		private var _divisionX:uint;
		private var _divisionY:uint;
		private var _image:BitmapData;
		private var _points:Vector.<Number>;
		private var _type:uint;

		public function MappingDisplay(image:BitmapData, divisionX:uint = 0, divisionY:uint = 0)
		{
			_divisionX = divisionX;
			_divisionY = divisionY;
			_image = image;
			
			_points = new Vector.<Number>();
		}

		/**
		 * 頂点追加
		 * ポリゴン分割は OpenGL の GL_TRIANGLE_STPIP を参考にした
		 * 向き不向きがあるので基本は GL_TRIANGE にしたほうが良さそう
		 */
		public function addVertex(x:Number, y:Number):void 
		{
			_points.push(x);
			_points.push(y);
		}

		/**
		 * 描画 mode を指定
		 */
		public function begin():void 
		{
			_points = new Vector.<Number>();
		}

		public function end():void 
		{
			_vertices = setupVertices();
			_indices = setupIndices();
			_uv = setupUv();
				
			draw(false);
		}

		/**
		 * 描画内容をクリア
		 */
		public function clear():void 
		{
			graphics.clear();
		}

		/**
		 * 描画
		 * ポイント変更なしの時のために残すべき？
		 */
		public function draw(repeat:Boolean = true, smooth:Boolean = false, line:Boolean = false):void 
		{
			graphics.clear();
//			graphics.lineStyle(1, 0xFF0000, 0.5);
			graphics.beginBitmapFill(_image, null, repeat, smooth);
			graphics.drawTriangles(_vertices, _indices, _uv);
			graphics.endFill();
		}

		/**
		 * bitmapdata をセット
		 * 参照先を変更するだけなのでセットした BitmapData を変更して draw すれば反映されます
		 */
		public function set image(value:BitmapData):void 
		{
			_image = value;
		}

		/**
		 * uv を定義
		 */
		private function setupUv():Vector.<Number> 
		{
			var temp:Vector.<Number> = new Vector.<Number>();
			
			var lx:int = _divisionX + 1;
			var ly:int = _divisionY + 1;
			var stepX:Number = _divisionX == 0 ? 1 : 1 / (_divisionX + 1);
			var stepY:Number = _divisionY == 0 ? 1 : 1 / (_divisionY + 1);
			var x:Number, y:Number;
			
			var step:Number = (_points.length - 4) / 4;
			
			for (var k:uint = 0;k < step;k++) {
				for (var i:uint = k == 0 ? 0 : 1;i <= lx;i++) {
					x = (i + (k * lx)) * (stepX / step);
					for (var j:uint = 0;j <= ly;j++) {
						y = j * stepY;
						temp.push(x);
						temp.push(y);
					}
				}
			}
			
			return temp;
		}

		/**
		 * ポリゴンを定義
		 */
		private function setupIndices():Vector.<int> 
		{
			var temp:Vector.<int> = new Vector.<int>();
			
			var lx:uint = _divisionX + 1;
			var ly:uint = _divisionY + 1;
			var division:int = _divisionY + 2;
			
			var step:Number = (_points.length - 4) / 4;
			
			for (var k:uint = 0;k < step ;k++) {
				for (var i:uint = 0;i < lx;i++) {
					var base:int = (i + (k * _divisionX)) * division + (k * division);
					for (var j:uint = 0;j < ly;j++) {
						var base2:int = base + j;
					
						temp.push(base2);
						temp.push(base2 + 1);
						temp.push(base2 + 2 + _divisionY);
						temp.push(base2 + 2 + _divisionY);
						temp.push(base2 + 1);
						temp.push(base2 + 3 + _divisionY);
					}
				}
			}
			
			return temp;
		}

		/**
		 * 頂点を定義
		 */
		private function setupVertices():Vector.<Number> 
		{
			var temp:Vector.<Number> = new Vector.<Number>();
			
			var lx:int = _divisionX + 1;
			var ly:int = _divisionY + 1;
			var stepX:Number = _divisionX == 0 ? 1 : 1 / (_divisionX + 1);
			var stepY:Number = _divisionY == 0 ? 1 : 1 / (_divisionY + 1);
			
			for (var k:uint = 0;k < (_points.length - 4);k += 4) {
				// TODO Line を再利用する
				var top:Line = new Line(_points[k], _points[k + 1], _points[k + 2], _points[k + 3]);
				var bottom:Line = new Line(_points[k + 4], _points[k + 5], _points[k + 6], _points[k + 7]);
				var left:Line = new Line(_points[k + 0], _points[k + 1], _points[k + 4], _points[k + 5]);
				var right:Line = new Line(_points[k + 2], _points[k + 3], _points[k + 6], _points[k + 7]);
				
				for (var i:uint = k == 0 ? 0 : 1;i <= lx;i++) {
					// 横分解
					var line0:Line = new Line(left.division(i * stepX), right.division(i * stepX));
				
					for (var j:uint = 0;j <= ly;j++) {
						// 縦分解
						var line1:Line = new Line(top.division(j * stepY), bottom.division(j * stepY));
						var cross:Point = line0.cross(line1);
					
						if (cross == null) {
							temp.push(0);
							temp.push(0);
						} else {
							temp.push(cross.x);
							temp.push(cross.y);
						}
					}
				}
			}
			
			return temp;
		}
	}
}
