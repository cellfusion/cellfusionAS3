package jp.cellfusion.ui.scrollbar 
{
	import flash.display.Sprite;

	/**
	 * @author Mk-10:cellfusion
	 */
	public interface IScrollView 
	{
		function set view(target:Sprite):void;
		
		function get upButton():Sprite;
		
		function get downButton():Sprite;
		
		function get track():Sprite;
		
		function get thumb():Sprite;
		
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
	}
}