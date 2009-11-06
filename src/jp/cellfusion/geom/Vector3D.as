package jp.cellfusion.geom 
{

	/**
	 * @author Mk-10:cellfusion
	 */
	public class Vector3D 
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;

		/**
		 * @param	x:Number x-axis value of Vector
		 * @param	y:Number y-axis value of Vector
		 * @param	z:Number z-axis value of Vector
		 */
		public function Vector3D(x:Number = 0, y:Number = 0, z:Number = 0) 
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}

		/**
		 * ベクトルの初期化
		 * @param	v:Vector3D コピーするベクトル
		 */
		public function initialize(v:Vector3D):void 
		{
			x = v.x;
			y = v.y;
			z = v.z;
		}

		/**
		 * ベクトルを単位ベクトルに変換する
		 */
		public function normalize():void 
		{
			var _l:Number = 1 / Math.sqrt(x * x + y * y + z * z);
		
			x *= _l;
			y *= _l;
			z *= _l;
		}

		/**
		 * 内積を求める
		 * @param	v:Vector3D ベクトル
		 * @return	Number 内積
		 */
		public function dot(v:Vector3D):Number 
		{
			var n = x * v.x + y * v.y + z * v.z;
		
			return n;
		}

		/**
		 * 外積をもとめる
		 * @param  a:Vector3D ベクトル
		 * @param  b:Vector3D ベクトル
		 */
		public function cross(a:Vector3D, b:Vector3D):void 
		{
			x = a.y * b.z - a.z * b.y;
			y = a.z * b.x - a.x * b.z;
			z = a.x * b.y - a.y * b.x;
		}

		/**
		 * ベクトルを反転する
		 */
		public function invert():void 
		{
			x = -x;
			y = -y;
			z = -z;
		}

		/**
		 * ベクトルを加算
		 * @param  v:Vector3D 加算するベクトル
		 */
		public function plus(v:Vector3D):void 
		{
			x += v.x;
			y += v.y;
			z += v.z;
		}

		/**
		 * ベクトルを減算
		 * @param  v:Number - 減算するベクトル
		 */
		public function minus(v:Vector3D):void 
		{
			x -= v.x;
			y -= v.y;
			z -= v.z;
		}

		/**
		 * ベクトルを乗算する
		 * @param  f:Number - 乗算する倍率
		 */
		public function multiply(f:Number):void
		{
			x *= f;
			y *= f;
			z *= f;
		}

		/**
		 * ベクトルを除算する
		 * @param  d:Number -除算する倍率
		 */
		public function divide(d:Number):void 
		{
			x /= d;
			y /= d;
			z /= d;
		}

		/**
		 * ベクトルのクローン作成
		 */
		public function clone():Vector3D 
		{
			return new Vector3D(x, y, z);
		}

		public function toString():String 
		{
			var x:Number = Math.round(this.x * 1000) * 0.001;
			var y:Number = Math.round(this.y * 1000) * 0.001;
			var z:Number = Math.round(this.z * 1000) * 0.001;
		
			return '[Vector x: ' + x + ' y: ' + y + ' z: ' + z + ']';
		}
	}
}
