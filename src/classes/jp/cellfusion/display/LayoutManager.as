package jp.cellfusion.display 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class LayoutManager
	{
		public static const TOP_LEFT:String = 'topLeft';
		public static const TOP:String = 'top';
		public static const TOP_RIGHT:String = 'topRight';
		public static const LEFT:String = 'left';
		public static const BOTTOM_LEFT:String = 'bottomLeft';
		public static const BOTTOM:String = 'bottom';
		public static const BOTTOM_RIGHT:String = 'bottomRight';
		public static const RIGHT:String = 'right';		public static const MIDDLE:String = 'middle';
		private static var _contents:Array;
		private static var _ref:Stage;

		public static function initialize(ref:Stage):void
		{
			_ref = ref;
			_ref.addEventListener(Event.RESIZE, resizeAll);
			_contents = [];
		}

		public static function add(display:DisplayObject, align:String, x:Number, y:Number):void
		{
			if (_contents.indexOf(display)) {
				remove(display);
			}
		
			var o:LayoutData = new LayoutData(display, align, x, y);
			_contents.push(o);
		
			resize(o);
		}

		public static function remove(display:DisplayObject):void
		{
			var idx:int = _contents.indexOf(display);
			if (idx < 0) {
				return;
			}
			_contents.splice(idx, 1);
		}

		public static function get isReady():Boolean
		{
			return _ref != null;
		}

		private static function resizeAll(event:Event = null):void
		{
			for each (var o:LayoutData in _contents) {
				resize(o);
			}
		}

		private static function resize(o:LayoutData):void
		{
			var align:String = String(o.align).toLowerCase();
				
			var stageWidth:Number = _ref.stageWidth;
			var stageHeight:Number = _ref.stageHeight;
				
			if (align.indexOf(TOP) >= 0) {
				o.display.y = o.y;
			} else if (align.indexOf(BOTTOM) >= 0) {
				o.display.y = stageHeight - o.y;
			} else {
				o.display.y = (stageHeight >> 1) + o.y;
			}
			
			if (align.indexOf(LEFT) >= 0) {
				o.display.x = o.x;
			} else if (align.indexOf(RIGHT) >= 0) {
				o.display.x = stageWidth - o.x;
			} else {
				o.display.x = (stageWidth >> 1) + o.x;
			}
				
			if (align.indexOf(MIDDLE) >= 0) {
				o.display.x = (stageWidth >> 1) + o.x;
				o.display.y = (stageHeight >> 1) + o.y;
			}
		}
	}
}

import flash.display.DisplayObject;


class LayoutData 
{
	private var _display:DisplayObject;
	private var _align:String;
	private var _x:Number;
	private var _y:Number;

	public function LayoutData(display:DisplayObject, align:String, x:Number, y:Number)
	{
		_display = display;
		_align = align;
		_x = x;
		_y = y;
	}

	public function get display():DisplayObject
	{
		return _display;
	}

	public function get align():String
	{
		return _align;
	}

	public function get x():Number
	{
		return _x;
	}

	public function get y():Number
	{
		return _y;
	}
}