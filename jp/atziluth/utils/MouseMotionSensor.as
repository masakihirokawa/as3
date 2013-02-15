package jp.atziluth.utils{
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	public class MouseMotionSensor {
		private var stage:Stage;
		private var isMouseStillness:Boolean;
		private var mouseCursorX:Number;
		private var mouseCursorY:Number;
		public var onMouseActivityFunction:Function;
		public var onMouseStillnessFunction:Function;
		public var timerInterval:uint = 100;
		private var timer:Timer;
		public var standbySecond:uint = 5;
		private var stillnessTime:uint;
		private var standbyTime:uint = Math.round((standbySecond * (1000 / timerInterval)));
		public function MouseMotionSensor(stage:Stage):void {
			this.stage = stage;
		}
		public function start():void {
			if ((timer == null)) {
				timer = new Timer(timerInterval,0);
				timer.addEventListener(TimerEvent.TIMER,monitoring);
				timer.start();
			} else {
				return;
			}
		}
		private function monitoring(event:TimerEvent):void {
			if (((mouseCursorX == stage.mouseX) && mouseCursorY == stage.mouseY)) {
				if ((stillnessTime == standbyTime)) {
					if (! isMouseStillness) {
						onMouseStillnessFunction();
					}
					isMouseStillness = true;
				}
				stillnessTime++;
			} else {
				if (isMouseStillness) {
					onMouseActivityFunction();
				}
				isMouseStillness = false;
				if (stillnessTime) {
					stillnessTime = 0;
				}
			}
			mouseCursorX = stage.mouseX;
			mouseCursorY = stage.mouseY;
		}
		public function clear():void {
			if (timer != null) {
				timer.removeEventListener(TimerEvent.TIMER,monitoring);
				timer = null;
			}
		}
	}
}