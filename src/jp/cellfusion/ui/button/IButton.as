package jp.cellfusion.ui.button 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * @author Mk-10:cellfusion
	 */
	public interface IButton extends IEventDispatcher 
	{
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		
		function get buttonMode():Boolean;
		function set buttonMode(value:Boolean):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function atClick():void;
		function atRollover():void;
		function atRollout():void;
		function atEnable():void;
		function atDisable():void;
	}
}
