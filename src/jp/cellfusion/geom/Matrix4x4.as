package jp.cellfusion.geom 
{

	/**
	 * @author Mk-10:cellfusion
	 */
	public class Matrix4x4 
	{
		public var m00:Number, m01:Number, m02:Number, m03:Number;
		public var m10:Number, m11:Number, m12:Number, m13:Number;
		public var m20:Number, m21:Number, m22:Number, m23:Number;
		public var m30:Number, m31:Number, m32:Number, m33:Number;

		public function Matrix4x4() 
		{
			initialize();
		}

		/**
		 * 単位行列で初期化
		 * @param  m:Matrix - 
		 */
		public function initialize():void 
		{
			m00 = 1; 
			m01 = 0; 
			m02 = 0; 
			m03 = 0;
			m10 = 0; 
			m11 = 1; 
			m12 = 0; 
			m13 = 0;
			m20 = 0; 
			m21 = 0; 
			m22 = 1; 
			m23 = 0;
			m30 = 0; 
			m31 = 0; 
			m32 = 0; 
			m33 = 1;
		}

		/**
		 * 配列の合成
		 * @param  m(Matrix) - 合成するMatrix
		 */
		public function mult(m:Matrix4x4):void 
		{
			m00 = m00 * m.m00 + m01 * m.m10 + m02 * m.m20 + m03 * m.m30; 
			m01 = m00 * m.m01 + m01 * m.m11 + m02 * m.m21 + m03 * m.m31;
			m02 = m00 * m.m02 + m01 * m.m12 + m02 * m.m22 + m03 * m.m32;
			m03 = m00 * m.m03 + m01 * m.m13 + m02 * m.m23 + m03 * m.m33;
			m10 = m10 * m.m00 + m11 * m.m10 + m12 * m.m20 + m13 * m.m30; 
			m11 = m10 * m.m01 + m11 * m.m11 + m12 * m.m21 + m13 * m.m31;
			m12 = m10 * m.m02 + m11 * m.m12 + m12 * m.m22 + m13 * m.m32;
			m13 = m10 * m.m03 + m11 * m.m13 + m12 * m.m23 + m13 * m.m33;
			m20 = m20 * m.m00 + m21 * m.m10 + m22 * m.m20 + m23 * m.m30; 
			m21 = m20 * m.m01 + m21 * m.m11 + m22 * m.m21 + m23 * m.m31;
			m22 = m20 * m.m02 + m21 * m.m12 + m22 * m.m22 + m23 * m.m32;
			m23 = m20 * m.m03 + m21 * m.m13 + m22 * m.m23 + m23 * m.m33;
			m30 = m30 * m.m00 + m31 * m.m10 + m32 * m.m20 + m33 * m.m30; 
			m31 = m30 * m.m01 + m31 * m.m11 + m32 * m.m21 + m33 * m.m31;
			m32 = m30 * m.m02 + m31 * m.m12 + m32 * m.m22 + m33 * m.m32;
			m33 = m30 * m.m03 + m31 * m.m13 + m32 * m.m23 + m33 * m.m33;
		}

		/**
		 * 拡大縮小
		 * @param  sx:Number X倍率
		 * @param  sy:Number Y倍率
		 * @param  sz:Number Z倍率
		 */
		public function scale(sx:Number, sy:Number, sz:Number):void 
		{
			//| sx  0  0  0|
			//|  0 sy  0  0|
			//|  0  0 sz  0|
			//|  0  0  0  1|
			var m:Matrix4x4 = new Matrix4x4();
			m.m00 = sx; 
			m.m01 = 0; 
			m.m02 = 0; 
			m.m03 = 0;
			m.m10 = 0; 
			m.m11 = sy; 
			m.m12 = 0; 
			m.m13 = 0;
			m.m20 = 0; 
			m.m21 = 0; 
			m.m22 = sz; 
			m.m23 = 0;
			m.m30 = 0; 
			m.m31 = 0; 
			m.m32 = 0; 
			m.m33 = 1;
		
			this.mult(m);
		}

		/**
		 * X軸回転
		 * @param  r(Number) - 回転角（単位ラジアン）
		 * 
		 * | 1     0    0 0 |
		 * | 0  cosX sinX 0 |
		 * | 0 -sinX cosX 0 |
		 * | 0     0    0 1 |
		 */
		public function rotateX(r:Number):void 
		{
			var sinx:Number = Math.sin(r);
			var cosx:Number = Math.cos(r);
		
			// X軸回転
			var m:Matrix4x4 = new Matrix4x4();
			m.m00 = 1; 
			m.m01 = 0; 
			m.m02 = 0; 
			m.m03 = 0;
			m.m10 = 0; 
			m.m11 = cosx; 
			m.m12 = sinx; 
			m.m13 = 0;
			m.m20 = 0; 
			m.m21 = -sinx; 
			m.m22 = cosx; 
			m.m23 = 0;
			m.m30 = 0; 
			m.m31 = 0; 
			m.m32 = 0; 
			m.m33 = 1;
		
			this.mult(m);
		}

		/**
		 * Y軸回転
		 * @param r:Number 回転角（単位ラジアン）
		 * 
		 * | cosY 0 -sinY 0 |
		 * |    0 1     0 0 |
		 * | sinY 0  cosY 0 |
		 * |    0 0     0 1 |
		 */
		public function rotateY(r:Number):void 
		{
			var siny:Number = Math.sin(r);
			var cosY:Number = Math.cos(r);
	
			var m:Matrix4x4 = new Matrix4x4();
			m.m00 = cosY; 
			m.m01 = 0; 
			m.m02 = -siny; 
			m.m03 = 0;
			m.m10 = 0; 
			m.m11 = 1; 
			m.m12 = 0; 
			m.m13 = 0;
			m.m20 = siny; 
			m.m21 = 0; 
			m.m22 = cosY; 
			m.m23 = 0;
			m.m30 = 0; 
			m.m31 = 0; 
			m.m32 = 0; 
			m.m33 = 1;
	
			this.mult(m);
		}

		/**
		 * Z軸回転
		 * @param	r:Number 回転角（単位ラジアン）
		 * |  cosZ sinZ 0 0 |
		 * | -sinZ cosZ 0 0 |
		 * |     0    0 1 0 |
		 * |     0    0 0 1 |	
		 */
		public function rotateZ(r:Number):void 
		{
			var sinz:Number = Math.sin(r);
			var cosz:Number = Math.cos(r);	
		
			var m:Matrix4x4 = new Matrix4x4();
			m.m00 = cosz; 
			m.m01 = sinz; 
			m.m02 = 0; 
			m.m03 = 0;
			m.m10 = -sinz; 
			m.m11 = cosz; 
			m.m12 = 0; 
			m.m13 = 0;
			m.m20 = 0; 
			m.m21 = 0; 
			m.m22 = 1; 
			m.m23 = 0;
			m.m30 = 0; 
			m.m31 = 0; 
			m.m32 = 0; 
			m.m33 = 1;
		
			this.mult(m);
		}

		/**
		 * 平行移動
		 * @param	dx:Number X移動量
		 * @param	dy:Number Y移動量
		 * @param	dz:Number Z移動量
		 * |  1  0  0  0 |
		 * |  0  1  0  0 |
		 * |  0  0  1  0 |
		 * | dx dy dz  1 |
		 */
		public function translate(dx:Number, dy:Number, dz:Number):void 
		{
			var m:Matrix4x4 = new Matrix4x4();
			m.m00 = 1; 
			m.m01 = 0; 
			m.m02 = 0; 
			m.m03 = 0;
			m.m10 = 0; 
			m.m11 = 1; 
			m.m12 = 0; 
			m.m13 = 0;
			m.m20 = 0; 
			m.m21 = 0; 
			m.m22 = 1; 
			m.m23 = 0;
			m.m30 = dx; 
			m.m31 = dy; 
			m.m32 = dz; 
			m.m33 = 1;
		
			this.mult(m);
		}

		/**
		 * 一次変換
		 * @param	a:Vector3D 変換するベクトル
		 * @return	Vector3D
		 */
		public function transform(a:Vector3D):Vector3D 
		{
			var v:Vector3D = new Vector3D();
			v.x = m00 * a.x + m10 * a.y + m20 * a.z + m30;
			v.y = m01 * a.x + m11 * a.y + m21 * a.z + m31;
			v.z = m02 * a.x + m12 * a.y + m22 * a.z + m32;
			return v;
		}

		/**
		 * 移動無視の一次変換
		 * @param	a:Vector3D 変換するベクトル
		 * @return	Vector3D
		 */
		public function rotation(a:Vector3D):Vector3D 
		{
			var v:Vector3D = new Vector3D();
			v.x = m00 * a.x + m10 * a.y + m20;
			v.y = m01 * a.x + m11 * a.y + m21;
			v.z = m02 * a.x + m12 * a.y + m22;

			return v;
		}

		/**
		 * 転置行列の作成
		 * @param	v:Matrix
		 */
		public function invert(v:Matrix4x4):void
		{
			m00 = v.m00;
			m01 = v.m10;
			m02 = v.m20;
			m03 = 0;
			m10 = v.m01;
			m11 = v.m11;
			m12 = v.m21;
			m13 = 0;
			m20 = v.m02;
			m21 = v.m12;
			m22 = v.m22;
			m23 = 0;
			m30 = 0;
			m31 = 0;
			m32 = 0;
			m33 = 1.0;	
		}

		public function clone():Matrix4x4
		{
			var m:Matrix4x4 = new Matrix4x4();
			
			m.m00 = m00;			m.m01 = m01;			m.m02 = m02;			m.m03 = m03;
			
			m.m10 = m10;
			m.m11 = m11;
			m.m12 = m12;
			m.m13 = m13;
			
			m.m20 = m20;
			m.m21 = m21;
			m.m22 = m22;
			m.m23 = m23;
			
			m.m30 = m30;
			m.m31 = m31;
			m.m32 = m32;
			m.m33 = m33;
			
			return m;
		}

		/**
		 * ビュー変換行列の作成
		 * @param	from:Vector3D - カメラの位置
		 * @param	at:Vector3D - ターゲットの位置
		 * @param	wup:Vector3D - カメラの上方向
		 */
		public static function view(from:Vector3D, at:Vector3D, wup:Vector3D):Matrix4x4 
		{
			var view:Vector3D = new Vector3D();
			view.x = at.x - from.x;
			view.y = at.y - from.y;
			view.z = at.z - from.z;
		
			view.normalize();
		
			var dot:Number = wup.dot(view);
		
			var up:Vector3D = new Vector3D();
		
			up.x = wup.x - dot * view.x;
			up.y = wup.y - dot * view.y;
			up.z = wup.z - dot * view.z;
		
			up.normalize();
		
			var right:Vector3D = new Vector3D();
			right.cross(up, view);
			
			var m:Matrix4x4 = new Matrix4x4();
		
			m.m00 = right.x;	
			m.m01 = up.x;	
			m.m02 = view.x;	
			m.m03 = 0;
			m.m10 = right.y;	
			m.m11 = up.y;	
			m.m12 = view.y;	
			m.m13 = 0;
			m.m20 = right.z;	
			m.m21 = up.z;	
			m.m22 = view.z;	
			m.m23 = 0;
			m.m30 = -from.dot(right);
			m.m31 = -from.dot(up);
			m.m32 = -from.dot(view);
			m.m33 = 1.0;
			
			return m;
		}

		/**
		 * 射影変換行列
		 * @param	near:Number 
		 * @param	far:Number
		 * @param	fov:Number
		 * @param	aspect:Number
		 **/
		public static function projection(near:Number, far:Number, fov:Number, aspect:Number):Matrix4x4 
		{
			var w:Number = aspect * (Math.cos(fov * 0.5) / Math.sin(fov * 0.5));
			var h:Number = 1.0 * (Math.cos(fov * 0.5) / Math.sin(fov * 0.5));
			var q:Number = far / (far - near);
			
			var m:Matrix4x4 = new Matrix4x4();		
		
			m.m00 = w;
			m.m11 = h;
			m.m22 = q;
			m.m23 = 1.0;
			m.m32 = -q * near;
			
			return m;
		}

//		function toString():String 
//		{
//			return "[" + m00 + ", " + m01 + ", " + m02 + ", " + m03 + "]\n" + "[" + m10 + ", " + m11 + ", " + m12 + ", " + m13 + "]\n" + "[" + m20 + ", " + m21 + ", " + m22 + ", " + m23 + "]\n" + "[" + m30 + ", " + m31 + ", " + m32 + ", " + m33 + "]\n";
//		}
	}
}