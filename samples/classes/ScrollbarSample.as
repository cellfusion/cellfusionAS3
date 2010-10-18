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
		private var _svv:ScrollbarViewVertical;
		private var _mask:Sprite;
		private var _sp:Sprite;
		private var _svv_sb:IScrollbar;
		private var _svh:ScrollbarViewHorizon;
		private var _svh_sb:Scrollbar;

		public function ScrollbarSample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			AbstractUI.initialize(this);

			_svv = new ScrollbarViewVertical();
			_svv.x = 520;
			addChild(_svv);
			
			_svh = new ScrollbarViewHorizon();
			_svh.y = 370;
			addChild(_svh);

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

			
			_svv_sb = new Scrollbar(Scrollbar.VERTICAL, _svv);
//			_svv_sb.setMargin(2, 2, 2, 2);
			_svv_sb.addEventListener(ScrollEvent.SCROLL_CHANGED, scrollChangeHandler);
			_svv_sb.initialize(_sp.height, _mask.height);

			_svh_sb = new Scrollbar(Scrollbar.HORIZON, _svh);
//			_svh_sb.setMargin(2, 2, 2, 2);
			_svh_sb.addEventListener(ScrollEvent.SCROLL_CHANGED, svhScrollChangeHandler);
			_svh_sb.initialize(_sp.width, _mask.width);
		}

		private function svhScrollChangeHandler(event:ScrollEvent):void
		{
			_sp.x = (_mask.width - _sp.width) * _svh_sb.scrollPercent;
		}

		private function scrollChangeHandler(event:ScrollEvent):void
		{
			_sp.y = (_mask.height - _sp.height) * _svv_sb.scrollPercent;
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