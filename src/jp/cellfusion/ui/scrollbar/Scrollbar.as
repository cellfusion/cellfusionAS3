package jp.cellfusion.ui.scrollbar
{
	import jp.cellfusion.events.ScrollEvent;

	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	[Event( name="scrollChange", type="jp.cellfusion.events.ScrollEvent" )]
	[Event( name="scrollStart", type="jp.cellfusion.events.ScrollEvent" )]
	[Event( name="scrollProgress", type="jp.cellfusion.events.ScrollEvent" )]
	[Event( name="scrollComplete", type="jp.cellfusion.events.ScrollEvent" )]
	[Event( name="scrollDragStart", type="jp.cellfusion.events.ScrollEvent" )]
	[Event( name="scrollDragProgress", type="jp.cellfusion.events.ScrollEvent" )]
	[Event( name="scrollDragComplete", type="jp.cellfusion.events.ScrollEvent" )]
	/**
	 * @author Mk-10:cellfusion
	 * 汎用スクロールバー
	 * 横向きにも対応
	 * new Scrollbar(Scrollbar.HORIZON);
	 * Event を増やして Drag 時や Complete 時に処理を追加出来るようにした
	 */
	public class Scrollbar extends EventDispatcher implements IScrollbar
	{
		public static const VERTICAL:int = 1;
		public static const HORIZON:int = 0;
		// private var _view:DisplayObject;
		private var _pos:Number = 0;
		private var _size:Number = 0.1;
		private var _repeat:IScrollRepeat;
		private var _tween:IScrollTween;
		private var _view:IScrollView;
		private var _thumbSizeLock:Boolean = false;
		private var _margin:Margin;
		private var _viewSize:Number;
		private var _targetSize:Number;
		private var _isReady:Boolean = false;
		private var _direction:int;

		/**
		 * <pre>// Scrollbar の作成
		 * var scrollbar:IScrollbar = new Scrollbar();
		 * 
		 * // view の指定
		 * scrollbar.thumb = thumb;
		 * scrollbar.track = track;
		 * scrollbar.upButton = upButton;
		 * scrollbar.downButton = downButton;
		 * 
		 * // view が入った Sprite を指定すると thumb のように決められたインスタンス名がついていれば自動で設定する
		 * var scrollbar:IScrollbar = new Scrollbar(ui);
		 * 
		 * // 初期化
		 * scrollbar.initialize(500, 100);
		 * 
		 * // 初期化後に viewSize（見える範囲） と targetSize（実際の大きさ） は個別に変更可能になる
		 * scrollbar.viewSize = 100;
		 * scrollbar.targetSize = 500;
		 * 
		 * // 余白の設定
		 * scrollbar.margin = 2;
		 * 
		 * // スクロールは 0 から 1 の値で指定する
		 * scrollbar.scroll(0.5);
		 * 
		 * // scrollbar と合わせて Sprite を動かす場合には SCROLL_CHANGED イベントを監視してその中で処理をする
		 * scrollbar.addEventListener(ScrollbarEvent.SCROLL_CHANGED, scrollChanged);
		 * 
		 * function scrollChanged(event:ScrollbarEvent):void {
		 *     // 現在の Thumb の位置
		 *     _scrollbar.scrollPercent;
		 * }
		 * </pre>
		 */
		public function Scrollbar(direction:int = 1, view:Sprite = null)
		{
			_tween = new ScrollTween();
			_repeat = new ScrollRepeat();
			_view = new ScrollView(direction, this);

			_margin = new Margin();

			_direction = direction;

			try {
				_view.view = view;
			} catch (e:Error) {
			}

			_size = 0.1;
		}

		/**
		 * 
		 */
		public function initialize(target:Number, view:Number):void
		{
//			Logger.trace("initialize target:" + target + ", view:" + view);
			_targetSize = target;
			_viewSize = view;

			if (target < view) {
				_view.enabled = false;
				return;
			}

			setViewArea();
			_view.enabled = true;
			_isReady = true;
		}

		public function scrollUp():void
		{
			var target:Number = _pos - _size;
			scroll(target);
		}

		public function scrollDown():void
		{
			var target:Number = _pos + _size;
			scroll(target);
		}

		/**
		 * @param target 0...1
		 */
		public function scroll(target:Number):void
		{
			var t:Number = Math.min(Math.max(0, target), 1);
			_tween.scroll(this, t);
		}
		
		/**
		 * 
		 */
		public function scrollHoge(target:Number):void
		{
			scroll(target / maxScrollPos);
		}
		
		public function get scrollTraget():Number
		{
			return _tween.target;
		}

		public function setMargin(top:Number = 0, right:Number = 0, bottom:Number = 0, left:Number = 0):void
		{
			_margin.top = top;
			_margin.right = right;
			_margin.bottom = bottom;
			_margin.left = left;
		}

		

		// private
		private function setViewArea():void
		{
			// サイズ変更時のポジションを格納
			thumbResize();

			draw(_pos);
		}

		private function thumbResize():void
		{
			var scale:Number;

			if (_direction) {
				scale = _view.thumb.scaleY;
				_view.thumb.scaleY = 1;
				_view.thumb.height = _thumbSizeLock ? _view.thumb.height : (_view.track.height - _margin.height) * (_viewSize / _targetSize);
				_view.thumb.scaleY = scale;
			} else {
				scale = _view.thumb.scaleX;
				_view.thumb.scaleX = 1;
				_view.thumb.width = _thumbSizeLock ? _view.thumb.width : (_view.track.width - _margin.width) * (_viewSize / _targetSize);
				_view.thumb.scaleX = scale;
			}
		}

		public function get thumbSizeLock():Boolean
		{
			return _thumbSizeLock;
		}

		public function set thumbSizeLock(value:Boolean):void
		{
			_thumbSizeLock = value;
			if (_view.thumb && _view.track) {
				thumbResize();
			}
		}

		public function get pos():Number
		{
			return _pos;
		}

		public function set pos(value:Number):void
		{
//			Logger.trace("scrollPos:" + value);
			_pos = value;

			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_CHANGE));
			
			draw(value);
		}

		private function draw(value:Number):void
		{
			if (_direction) {
				_view.thumb.y = value * maxScrollSize;
//				_scrollView.thumb.y = value + _scrollView.track.y;
			} else {
				_view.thumb.x = value * maxScrollSize;
//				_scrollView.thumb.x = value + _scrollView.track.x;
			}
		}

		public function get size():Number
		{
			return _size;
		}

		public function set size(value:Number):void
		{
			_size = value;
		}

		public function get tween():IScrollTween
		{
			return _tween;
		}

		public function get repeat():IScrollRepeat
		{
			return _repeat;
		}

		/**
		 * 表示するエリアのサイズ
		 */
		public function set viewSize(value:Number):void
		{
			if (!_isReady) {
				return;
			}

			_viewSize = value;

			if (_targetSize) {
				setViewArea();
			}
		}

		public function get viewSize():Number
		{
			return _viewSize;
		}

		/**
		 * 表示するオブジェクトのサイズ
		 */
		public function set targetSize(value:Number):void
		{
			if (!_isReady) {
				return;
			}

			_targetSize = value;

			if (_viewSize) {
				setViewArea();
			}
		}

		public function get targetSize():Number
		{
			return _targetSize;
		}

		public function get minScrollPos():Number
		{
			if (_direction) {
				return _view.track.y + _margin.top;
			} else {
				return _view.track.x + _margin.left;
			}
		}

		public function get maxScrollPos():Number
		{
			return minScrollPos + maxScrollSize;
		}

		public function get maxScrollSize():Number
		{
			if (_direction) {
				return _view.track.height - _view.thumb.height - _margin.height;
			} else {
				return _view.track.width - _view.thumb.width - _margin.width;
			}
		}

		public function get view():IScrollView
		{
			return _view;
		}
	}
}
class Margin
{
	public var top:Number = 0;
	public var right:Number = 0;
	public var bottom:Number = 0;
	public var left:Number = 0;

	public function Margin()
	{
	}

	public function get height():Number
	{
		return top + bottom;
	}

	public function get width():Number
	{
		return left + right;
	}
}