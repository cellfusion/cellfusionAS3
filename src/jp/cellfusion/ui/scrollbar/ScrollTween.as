/*
	import jp.cellfusion.ui.AbstractUI;
		{
			if (_target == target) return;
			_scrollbar.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_START));
				unregisterListener();
				_scrollbar.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_COMPLETE));
				_scrollbar.pos += delta * FRICTION;
				_scrollbar.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_PROGRESS));
			_running = false;
		}

		public function get target():Number
		{
			return _target;
		}