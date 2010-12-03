package jp.cellfusion.ui.scrollbar
{
	import jp.cellfusion.events.ScrollEvent;
	import jp.cellfusion.ui.AbstractUI;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class ScrollView implements IScrollView
	{
		private var _scrollbar:IScrollbar;
		private var _downButton:Sprite;
		private var _upButton:Sprite;
		private var _track:Sprite;
		private var _thumb:Sprite;
		private var _enabled:Boolean;
		private var _direction:int;

		public function ScrollView(direction:int, scrollbar:IScrollbar)
		{
			_direction = direction;
			_scrollbar = scrollbar;
		}

		public function get upButton():Sprite
		{
			return _upButton;
		}

		public function get downButton():Sprite
		{
			return _downButton;
		}

		public function get track():Sprite
		{
			return _track;
		}

		public function get thumb():Sprite
		{
			return _thumb;
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set view(target:Sprite):void
		{
			try {
				track = target["track"];
			} catch(e:Error) {
			}

			try {
				thumb = target["thumb"];
			} catch(e:Error) {
			}

			try {
				upButton = target["upButton"];
			} catch(e:Error) {
			}

			try {
				downButton = target["downButton"];
			} catch(e:Error) {
			}
		}

		public function set upButton(target:Sprite):void
		{
			if (_upButton) {
				_upButton.removeEventListener(MouseEvent.CLICK, scrollUpHandler);
				_upButton.removeEventListener(MouseEvent.MOUSE_DOWN, upButtonMouseDownHandler);
			}

			target.buttonMode = true;
			_upButton = target;

			_upButton.addEventListener(MouseEvent.CLICK, scrollUpHandler);
			_upButton.addEventListener(MouseEvent.MOUSE_DOWN, upButtonMouseDownHandler);
		}

		public function set downButton(target:Sprite):void
		{
			if (_downButton) {
				_downButton.removeEventListener(MouseEvent.CLICK, scrollDownHandler);
				_downButton.removeEventListener(MouseEvent.MOUSE_DOWN, downButtonMouseDownHandler);
			}

			target.buttonMode = true;
			_downButton = target;

			_downButton.addEventListener(MouseEvent.CLICK, scrollDownHandler);
			_downButton.addEventListener(MouseEvent.MOUSE_DOWN, downButtonMouseDownHandler);
		}

		public function set track(target:Sprite):void
		{
			if (_track) {
				_track.removeEventListener(MouseEvent.MOUSE_DOWN, scrollHandler);
			}

			target.buttonMode = true;
			_track = target;

			try {
				_scrollbar.pos = _scrollbar.minScrollPos;
			} catch (e:Error) {
			}

			_track.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler);
		}

		public function set thumb(target:Sprite):void
		{
			if (_thumb) {
				_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, dragStartHandler);
			}

			target.buttonMode = true;
			_thumb = target;

			_thumb.addEventListener(MouseEvent.MOUSE_DOWN, dragStartHandler);
		}

		public function set enabled(value:Boolean):void
		{
			if (_thumb) _thumb.buttonMode = value;
			if (_track) _track.buttonMode = value;
			if (_upButton) _upButton.buttonMode = value;
			if (_downButton) _downButton.buttonMode = value;
			_enabled = value;
		}

		private function scrollHandler(event:MouseEvent):void
		{
			// Logger.trace("scrollhandler enabled:" + _enabled + " mouseY:" + _track.mouseY);
			if (!_enabled) {
				return;
			}

			var target:Number;

			if (_direction) {
				target = _track.mouseY + _track.y;
			} else {
				target = _track.mouseX + _track.x;
			}

			_scrollbar.scrollHoge(target);
		}

		private function dragStartHandler(event:MouseEvent):void
		{
			// Logger.trace("dragStart enabled:" + _enabled);
			if (!_enabled) {
				return;
			}

			// スクロールを停止する
			_scrollbar.tween.interrupt();

			// ドラッグできる範囲の Rectangle インスタンスを作成
			// var bounds:Rectangle = new Rectangle(_thumb.x, Math.ceil(_track.y + _scrollbar.getMargin().top));
			var bounds:Rectangle;

			// TODO Margin とか
			if (_direction) {
				bounds = new Rectangle(_thumb.x, Math.ceil(_track.y));
				bounds.right = _thumb.x;
				bounds.height = Math.ceil(_scrollbar.maxScrollSize);
			} else {
				bounds = new Rectangle(Math.ceil(_track.x), _thumb.y);
				bounds.bottom = _thumb.y;
				bounds.width = Math.ceil(_scrollbar.maxScrollSize);
			}

			_thumb.startDrag(false, bounds);
			_scrollbar.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_DRAG_START));

			AbstractUI._stage.addEventListener(MouseEvent.MOUSE_UP, dragEndHandler);
			AbstractUI._stage.addEventListener(Event.ENTER_FRAME, dragProgressHandler);
		}

		private function dragProgressHandler(event:Event):void
		{
			// Logger.trace("dragProgressHandler");
			update();

			_scrollbar.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_DRAG_PROGRESS));
		}

		private function update():void
		{
			if (_direction) {
				_scrollbar.pos = (_thumb.y - _scrollbar.minScrollPos) / _scrollbar.maxScrollPos;
			} else {
				_scrollbar.pos = (_thumb.x - _scrollbar.minScrollPos) / _scrollbar.maxScrollPos;
			}
		}

		private function dragEndHandler(event:MouseEvent):void
		{
			// Logger.trace("dragComplete");
			update();

			_thumb.stopDrag();
			_scrollbar.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_DRAG_COMPLETE));
			AbstractUI._stage.removeEventListener(MouseEvent.MOUSE_UP, dragEndHandler);
			AbstractUI._stage.removeEventListener(Event.ENTER_FRAME, dragProgressHandler);
		}

		private function downButtonMouseDownHandler(event:MouseEvent):void
		{
			_scrollbar.repeat.repeatedClick(_downButton, 12);
		}

		private function scrollDownHandler(event:MouseEvent):void
		{
			_scrollbar.scrollDown();
		}

		private function upButtonMouseDownHandler(event:MouseEvent):void
		{
			_scrollbar.repeat.repeatedClick(_upButton, 12);
		}

		private function scrollUpHandler(event:MouseEvent):void
		{
			_scrollbar.scrollUp();
		}
	}
}
