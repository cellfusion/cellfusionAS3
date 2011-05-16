package jp.cellfusion.scenes
{
	import flash.display.Stage;
	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public interface IScene
	{
		function initialize(stage:Stage):void;

		function finalize():void;

		function update():void;
	}
}
