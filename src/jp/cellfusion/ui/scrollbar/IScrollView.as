package jp.cellfusion.ui.scrollbar 
{
	import flash.display.Sprite;

	/**
	 * @author Mk-10:cellfusion
	 */
	public interface IScrollView 
	{
		function set view(target:Sprite):void;
		
		function get upButton():Sprite;		function set upButton(target:Sprite):void;
		
		function get downButton():Sprite;		function set downButton(target:Sprite):void;
		
		function get track():Sprite;		function set track(target:Sprite):void;
		
		function get thumb():Sprite;		function set thumb(target:Sprite):void;
		
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
	}
}
