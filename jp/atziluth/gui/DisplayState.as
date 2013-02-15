package jp.atziluth.gui{
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	public class DisplayState {
		public static var _stage:Stage;
		public function DisplayState(stage:Stage):void {
			DisplayState._stage = stage;
		}
		public static function change(event:MouseEvent=null):void {
			if (_stage == null) {
				throw new ArgumentError("DisplayState.change: 静的クラスメンバ _stageが初期化されていません");
				return;
			}
			if (DisplayState._stage.displayState == StageDisplayState.NORMAL) {
				DisplayState._stage.displayState = StageDisplayState.FULL_SCREEN;
				DisplayState._stage.displayState = "fullScreen";
			} else {
				DisplayState._stage.displayState = StageDisplayState.NORMAL;
				DisplayState._stage.displayState = "normal";
			}
		}
		public static function get mode():String {
			if (DisplayState._stage == null) {
				throw new ArgumentError("DisplayState.mode: 静的クラスメンバ _stageが初期化されていません");
				return;
			}
			return (DisplayState._stage.displayState);
		}
	}
}