package jp.cellfusion.ui.scrollbar
{
	import jp.cellfusion.logger.Logger;
	import jp.cellfusion.ui.events.ScrollEvent;

	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	[Event( name="scrollChanged", type="jp.cellfusion.ui.events.ScrollEvent" )]
	/**
	 * @author Mk-10:cellfusion
	 */
	public class Scrollbar extends EventDispatcher implements IScrollbar
	{
		public static const VERTICAL:int = 1;
		public static const HORIZON:int = 0;
		// private var _view:DisplayObject;
		private var _scrollPos:Number = 0;
		private var _scrollSize:Number = 0.1;
		private var _scrollRepeat:IScrollRepeat;
		private var _scrollTween:IScrollTween;
		private var _scrollView:IScrollView;
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
		 * // 初期化後に viewSize と targetSize は個別に変更可能になる
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
			_scrollTween = new ScrollTween();
			_scrollRepeat = new ScrollRepeat();
			_scrollView = new ScrollView(direction, this);

			_margin = new Margin();

			_direction = direction;

			try {
				_scrollView.view = view;
			} catch (e:Error) {
			}

			_scrollSize = 5;
		}

		/**
		 * 
		 */
		public function initialize(target:Number, view:Number):void
		{
			Logger.trace("initialize target:" + target + ", view:" + view);
			_targetSize = target;
			_viewSize = view;

			if (target < view) {
				_scrollView.enabled = false;
				return;
			}

			setViewArea();
			_scrollView.enabled = true;
			_isReady = true;
		}

		public function scrollUp():void
		{
			var target:Number = _scrollPos - _scrollSize;

			scrollHoge(target);
		}

		public function scrollDown():void
		{
			var target:Number = _scrollPos + _scrollSize;

			scrollHoge(target);
		}

		/**
		 * @param target 0...1
		 */
		public function scroll(target:Number):void
		{
			Logger.debug('SimpleScrollbar.scroll');
			Logger.debug('target:' + target);
			Logger.debug('maxScrollHeight' + maxScrollSize);
			Logger.debug('_scrollTween' + _scrollTween);

			var t:Number = Math.min(Math.max(0, target), 1) * maxScrollSize;
			_scrollTween.scroll(this, t);
		}
		
		/**
		 * 
		 */
		public function scrollHoge(target:Number):void
		{
			Logger.debug('SimpleScrollbar.scrollHoge');
			Logger.debug('target:' + target);
			Logger.debug('minScrollPos:' + minScrollPos);
			Logger.debug('maxScrollPos:' + maxScrollPos);
			Logger.debug('_scrollTween' + _scrollTween);

			// ターゲットがはみ出してないか確認
			var t:Number = Math.min(Math.max(minScrollPos, target), maxScrollPos);
			_scrollTween.scroll(this, t);
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
			var percent:Number = scrollPercent;

			thumbResize();

			// thumb の位置を修正
			var target:Number = minScrollPos + maxScrollSize * percent;
			target = Math.min(Math.max(minScrollPos, target), maxScrollPos);
			// scrollPos = target;
			_scrollPos = target;

			draw(target);
		}

		private function thumbResize():void
		{
			var scale:Number;

			if (_direction) {
				scale = _scrollView.thumb.scaleY;
				_scrollView.thumb.scaleY = 1;
				_scrollView.thumb.height = _thumbSizeLock ? _scrollView.thumb.height : (_scrollView.track.height - _margin.height) * (_viewSize / _targetSize);
				_scrollView.thumb.scaleY = scale;
			} else {
				scale = _scrollView.thumb.scaleX;
				_scrollView.thumb.scaleX = 1;
				_scrollView.thumb.width = _thumbSizeLock ? _scrollView.thumb.width : (_scrollView.track.width - _margin.width) * (_viewSize / _targetSize);
				_scrollView.thumb.scaleX = scale;
			}
		}

		public function get thumbSizeLock():Boolean
		{
			return _thumbSizeLock;
		}

		public function set thumbSizeLock(value:Boolean):void
		{
			_thumbSizeLock = value;
			if (_scrollView.thumb && _scrollView.track) {
				thumbResize();
			}
		}

		public function get scrollPos():Number
		{
			return _scrollPos;
		}

		public function set scrollPos(value:Number):void
		{
			Logger.trace("scrollPos:" + value);
			_scrollPos = value;

			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_CHANGED));
			
			draw(value);
		}

		private function draw(value:Number):void
		{
			if (_direction) {
				_scrollView.thumb.y = value;
//				_scrollView.thumb.y = value + _scrollView.track.y;
			} else {
				_scrollView.thumb.x = value;
//				_scrollView.thumb.x = value + _scrollView.track.x;
			}
		}

		public function get targetPos():Number
		{
			return scrollPercent * (_targetSize - viewSize);
		}

		public function get scrollPercent():Number
		{
			return (_scrollPos - minScrollPos) / maxScrollSize;
		}

		public function get scrollSize():Number
		{
			return _scrollSize;
		}

		public function set scrollSize(value:Number):void
		{
			_scrollSize = value;
		}

		public function get scrollTween():IScrollTween
		{
			return _scrollTween;
		}

		public function get scrollRepeat():IScrollRepeat
		{
			return _scrollRepeat;
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
				return _scrollView.track.y + _margin.top;
			} else {
				return _scrollView.track.x + _margin.left;
			}
		}

		public function get maxScrollPos():Number
		{
			return minScrollPos + maxScrollSize;
		}

		public function get maxScrollSize():Number
		{
			if (_direction) {
				return _scrollView.track.height - _scrollView.thumb.height - _margin.height;
			} else {
				return _scrollView.track.width - _scrollView.thumb.width - _margin.width;
			}
		}

		public function get scrollView():IScrollView
		{
			return _scrollView;
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