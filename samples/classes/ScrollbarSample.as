package
{
	import jp.cellfusion.ui.AbstractUI;
	import jp.cellfusion.ui.events.ScrollEvent;
	import jp.cellfusion.ui.scrollbar.IScrollbar;
	import jp.cellfusion.ui.scrollbar.Scrollbar;

	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Matrix;

	/**	 * @author Mk-10:cellfusion	 */
	public class ScrollbarSample extends Sprite
	{
		private var _verticalView:ScrollbarViewVertical;
		private var _horizonView:ScrollbarViewHorizon;
		private var _mask:Sprite;
		private var _sp:Sprite;
		private var _vertical_sb:IScrollbar;
		private var _horizon_sb:Scrollbar;

		public function ScrollbarSample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			AbstractUI.initialize(this);

			_verticalView = new ScrollbarViewVertical();
			_verticalView.x = 520;
			addChild(_verticalView);
			
			_horizonView = new ScrollbarViewHorizon();
			_horizonView.y = 370;
			addChild(_horizonView);

			_mask = new Sprite();
			_sp = new Sprite();
			_sp.mask = _mask;
			addChild(_mask);
			addChild(_sp);

			_mask.graphics.clear();
			_mask.graphics.beginFill(0x000000, 1);
			_mask.graphics.drawRect(0, 0, 520, 370);
			_mask.graphics.endFill();

			var mat:Matrix = new Matrix();
			mat.createGradientBox(2000, 2000);
			mat.rotate(Math.PI / 4);

			_sp.graphics.clear();
			_sp.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0x000000], [1, 1], [0x00, 0xFF], mat);
			_sp.graphics.drawRect(0, 0, 2000, 2000);
			_sp.graphics.endFill();

			
			_vertical_sb = new Scrollbar(Scrollbar.VERTICAL, _verticalView);
//			_svv_sb.setMargin(2, 2, 2, 2);
			_vertical_sb.addEventListener(ScrollEvent.SCROLL_CHANGE, veticalScrollChangeHandler);
			_vertical_sb.addEventListener(ScrollEvent.SCROLL_START, veticalScrollStartHandler);
			_vertical_sb.addEventListener(ScrollEvent.SCROLL_PROGRESS, veticalScrollProgressHandler);
			_vertical_sb.addEventListener(ScrollEvent.SCROLL_COMPLETE, veticalScrollCompleteHandler);
			_vertical_sb.addEventListener(ScrollEvent.SCROLL_DRAG_START, veticalScrollDragStartHandler);
			_vertical_sb.addEventListener(ScrollEvent.SCROLL_DRAG_PROGRESS, veticalScrollDragProgressHandler);
			_vertical_sb.addEventListener(ScrollEvent.SCROLL_DRAG_COMPLETE, veticalScrollDragCompleteHandler);
			_vertical_sb.initialize(_sp.height, _mask.height);

			_horizon_sb = new Scrollbar(Scrollbar.HORIZON, _horizonView);
//			_svh_sb.setMargin(2, 2, 2, 2);
			_horizon_sb.addEventListener(ScrollEvent.SCROLL_CHANGE, horizonScrollChangeHandler);
			_horizon_sb.initialize(_sp.width, _mask.width);
		}

		private function veticalScrollDragCompleteHandler(event:ScrollEvent):void
		{
			trace("verticalScrollDragComplete");
		}

		private function veticalScrollDragProgressHandler(event:ScrollEvent):void
		{
			trace("verticalScrollDragProgress");
		}

		private function veticalScrollDragStartHandler(event:ScrollEvent):void
		{
			trace("verticalScrollDargStart");
		}

		private function veticalScrollCompleteHandler(event:ScrollEvent):void
		{
			trace("verticalScrollComplete");
		}

		private function veticalScrollProgressHandler(event:ScrollEvent):void
		{
			trace("verticalScrollProgress");
		}

		private function veticalScrollStartHandler(event:ScrollEvent):void
		{
			trace("verticalScrollStart");
		}

		private function horizonScrollChangeHandler(event:ScrollEvent):void
		{
			_sp.x = (_mask.width - _sp.width) * _horizon_sb.scrollPercent;
		}

		private function veticalScrollChangeHandler(event:ScrollEvent):void
		{
			trace("verticalScrollChange");
			_sp.y = (_mask.height - _sp.height) * _vertical_sb.scrollPercent;
		}
	}
}
import flash.display.Sprite;

class ScrollbarViewHorizon extends Sprite
{
	private var _thumb:Sprite;
	private var _track:Sprite;
	private var _upButton:Sprite;
	private var _downButton:Sprite;

	public function ScrollbarViewHorizon()
	{
		_track = new Sprite();
		_track.graphics.beginFill(0x808080);
		_track.graphics.drawRect(0, 0, 100, 30);
		_track.graphics.endFill();
		addChild(_track);

		_thumb = new Sprite();
		_thumb.graphics.beginFill(0x000000, 1);
		_thumb.graphics.drawRect(0, 0, 30, 30);
		_thumb.graphics.endFill();
		addChild(_thumb);

		_upButton = new Sprite();
		addChild(_upButton);
		_downButton = new Sprite();
		addChild(_downButton);
	}

	public function get thumb():Sprite
	{
		return _thumb;
	}

	public function get track():Sprite
	{
		return _track;
	}

	public function get upButton():Sprite
	{
		return _upButton;
	}

	public function get downButton():Sprite
	{
		return _downButton;
	}
}
class ScrollbarViewVertical extends Sprite
{
	private var _thumb:Sprite;
	private var _track:Sprite;
	private var _upButton:Sprite;
	private var _downButton:Sprite;

	public function ScrollbarViewVertical()
	{
		_track = new Sprite();
		_track.graphics.beginFill(0x808080);
		_track.graphics.drawRect(0, 0, 30, 100);
		_track.graphics.endFill();
		addChild(_track);

		_thumb = new Sprite();
		_thumb.graphics.beginFill(0x000000, 1);
		_thumb.graphics.drawRect(0, 0, 30, 30);
		_thumb.graphics.endFill();
		addChild(_thumb);

		_upButton = new Sprite();
		addChild(_upButton);
		_downButton = new Sprite();
		addChild(_downButton);
	}

	public function get thumb():Sprite
	{
		return _thumb;
	}

	public function get track():Sprite
	{
		return _track;
	}

	public function get upButton():Sprite
	{
		return _upButton;
	}

	public function get downButton():Sprite
	{
		return _downButton;
	}
}