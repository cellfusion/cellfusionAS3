package jp.cellfusion.ui.video.ui
{
	import jp.cellfusion.ui.video.IVideoPlayer;
	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public interface IControllerParts
	{
		function initialize(player:IVideoPlayer):void;

		function update():void;

		function finalize():void;

		function reset():void;
	}
}
