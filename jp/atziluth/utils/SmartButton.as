package jp.atziluth.utils{
	import flash.display.Sprite;
	public class SmartButton {
		private static var buttons:Array;
		private static var id:int;
		private static var length:uint;
		private static var index:uint;
		public static function change(buttons:Array,currentButtonID:int,buttonNum:uint=0,indexButtonID:uint=1):void {
			SmartButton.initialize(buttons,currentButtonID,buttonNum,indexButtonID);
			SmartButton.exec();
		}
		public static function clear(buttons:Array,buttonNum:uint=0,indexButtonID:uint=1):void {
			SmartButton.initialize(buttons,-1,buttonNum,indexButtonID);
			SmartButton.exec();
		}
		public static function enabled($scope:Sprite,b:Boolean):void {
			$scope.mouseChildren = b;
			$scope.mouseEnabled = b;
		}
		private static function initialize(buttons:Array,id:int,buttonNum:uint,indexButtonID:uint):void {
			SmartButton.buttons = buttons;
			SmartButton.id = id;
			buttonNum <= 0 ? SmartButton.length = SmartButton.buttons.length:SmartButton.length = buttonNum;
			SmartButton.index = indexButtonID;
		}
		private static function exec():void {
			for (var i:uint = SmartButton.index; i <= SmartButton.length; i++) {
				SmartButton.enabled(SmartButton.buttons[i],i != SmartButton.id);
			}
		}
	}
}