/*
 * AbstractUI
 * 
 * Licensed under the MIT License
 * 
 * Copyright (c) 2008 cellfusion (www.cellfusion.jp), supported by Spark project (www.libspark.org).
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */
package jp.cellfusion.ui.scrollbar 
{
	import jp.cellfusion.debug.SOSDebugger;
	import jp.cellfusion.ui.events.ScrollEvent;

	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	[Event( name="scrollChanged", type="jp.cellfusion.abstractui.events.ScrollEvent" )]

	/**
	 * @author Mk-10:cellfusion
	 */
	public class SimpleScrollbar extends EventDispatcher implements IScrollbar 
	{
//		private var _view:DisplayObject;
		private var _scrollPos:Number = 0;
		private var _scrollSize:Number = 20;
		private var _scrollRepeat:IScrollRepeat;
		private var _scrollTween:IScrollTween;
		private var _scrollView:IScrollView;
		private var _thumbSizeLock:Boolean = false;
		private var _margin:Margin;
		private var _viewSize:Number;
		private var _targetSize:Number;
		private var _isReady:Boolean = false;

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
		public function SimpleScrollbar(view:Sprite = null)
		{
			_scrollTween = new SimpleScrollTween();
			_scrollRepeat = new SimpleScrollRepeat();
			_scrollView = new ScrollView(this);
			
			_margin = new Margin();
			
			try {
				_scrollView.view = view;
			} catch (e:Error) {
				
			}
			
			_scrollSize = 20;
		}
		
		/**
		 * 
		 */
		public function initialize(target:Number, view:Number):void
		{
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
			SOSDebugger.debug('SimpleScrollbar.scroll');
			SOSDebugger.debug('target:'+target);
			SOSDebugger.debug('maxScrollHeight'+maxScrollHeight);
			SOSDebugger.debug('_scrollTween'+_scrollTween);
			
			var t:Number = Math.min(Math.max(0, target), 1) * maxScrollHeight;
			_scrollTween.scroll(this, t);
		}
		
		public function setMargin(top:Number = 0, right:Number = 0, bottom:Number = 0, left:Number = 0):void
		{
			_margin.top = top;
			_margin.right = right;
			_margin.bottom = bottom;
			_margin.left = left;
		}
		
		/**
		 * 
		 */
		public function scrollHoge(target:Number):void
		{
			SOSDebugger.debug('SimpleScrollbar.scrollHoge');
			SOSDebugger.debug('target:'+target);
			SOSDebugger.debug('minScrollPos:'+minScrollPos);
			SOSDebugger.debug('maxScrollPos:'+maxScrollPos);
			SOSDebugger.debug('_scrollTween'+_scrollTween);
			
			// ターゲットがはみ出してないか確認
			var t:Number = Math.min(Math.max(minScrollPos, target), maxScrollPos);
			_scrollTween.scroll(this, t);
		}

		// private
		private function setViewArea():void
		{
			// サイズ変更時のポジションを格納
			var percent:Number = scrollPercent;
			
			thumbResize();
			
			// thumb の位置を修正
			var target:Number = minScrollPos + maxScrollHeight * percent;
			target = Math.min(Math.max(minScrollPos, target), maxScrollPos);
			scrollPos = target;
		}

		private function thumbResize():void
		{
			var scale:Number = _scrollView.thumb.scaleY;
			_scrollView.thumb.scaleY = 1;
			_scrollView.thumb.height = _thumbSizeLock ? _scrollView.thumb.height : (_scrollView.track.height - _margin.height) * (_viewSize / _targetSize);
			_scrollView.thumb.scaleY = scale;
		}

		// event
		

		// getter/setter
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
			_scrollPos = value;
			
			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_CHANGED));
			
			// 更新
			_scrollView.thumb.y = value;
		}

		public function get scrollPercent():Number 
		{ 
			return (_scrollPos - minScrollPos) / maxScrollHeight; 
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
			return _scrollView.track.y + _margin.top;
		}

		public function get maxScrollPos():Number
		{
			return minScrollPos + maxScrollHeight;
		}

		public function get maxScrollHeight():Number
		{
			return _scrollView.track.height - _scrollView.thumb.height - _margin.height;
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