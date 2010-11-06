/* * AbstractUI *  * Licensed under the MIT License *  * Copyright (c) 2008 cellfusion (www.cellfusion.jp), supported by Spark project (www.libspark.org). *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. *  */package jp.cellfusion.ui.scrollbar {	import jp.cellfusion.ui.events.ScrollEvent;
	import jp.cellfusion.ui.AbstractUI;	import flash.events.Event;	/**	 * FLASHer 式スクロール	 * @author Mk-10:cellfusion	 */	public class ScrollTween implements IScrollTween 	{		private var _running:Boolean;		private var _scrollbar:IScrollbar;		private var _target:Number;		private static const FRICTION:Number = 0.45;		public function ScrollTween()		{			_running = false;		}		public function scroll(scrollbar:IScrollbar, target:Number):void
		{
			if (_target == target) return;						// 既に動いている場合は終了する			if (_running) {				interruptExecute();			}						// 値を記録			_scrollbar = scrollbar;			_target = target;						AbstractUI._stage.addEventListener(Event.ENTER_FRAME, execute);
			_scrollbar.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_START));						// 			_running = true;		}		public function interrupt():void		{			// 動いてない場合は終了			if (!_running) return;						interruptExecute();		}		private function execute(event:Event):void		{			var delta:Number = _target - _scrollbar.pos;						if (Math.abs(delta) < 0.005) {				_scrollbar.pos = _target;
				unregisterListener();
				_scrollbar.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_COMPLETE));			} else {
				_scrollbar.pos += delta * FRICTION;
				_scrollbar.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_PROGRESS));			}		}		private function interruptExecute():void		{			unregisterListener();		}		private function unregisterListener():void		{			AbstractUI._stage.removeEventListener(Event.ENTER_FRAME, execute);
			_running = false;
		}

		public function get target():Number
		{
			return _target;
		}	}}