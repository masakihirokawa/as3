package jp.atziluth.utils{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	public class TransitionTween extends MovieClip {
		private var transitionManager:TransitionManager;
		private var transitionContent:MovieClip;
		private var transitionType:String;
		private var transitionDirection:Number;
		private var transitionDirectionNumber:Number;
		private var transitionDuration:Number;
		private var transitionEasing:Function;
		private var transitionEasingFunction:Function;
		private var transitionDelay:Number;
		private var transitionTimer:Timer;
		private static var $dimension:Number = 1;
		private static var $xSections:Number = 64;
		private static var $ySections:Number = 64;
		private static var $numStrips:uint = 256;
		private static var $startPoint:Number = 1;
		public function TransitionTween(
		    $scope:MovieClip,
		    type:String,
		    direction:Number=0,
		    duration:Number=1,
		    easing:String=null,
		    delay:Number=0,
		    defaultVisible:Boolean=true,
		    defaultAlpha:Number=1
		):void {
			transitionContent = $scope;
			transitionContent.visible = defaultVisible;
			transitionContent.alpha = defaultAlpha;
			transitionManager = new TransitionManager(transitionContent);
			transitionType = type;
			transitionDirection = convertedDirection(direction);
			transitionDuration = duration;
			transitionEasing = easing == null ? None.easeNone:convertedEasing(easing);
			transitionDelay = delay;
			transitionDelay ? transitionTimer = new Timer(transitionDelay * 1000,0):transitionTimer = null;
			transitionTimer ? startTransitionTimer():startTransitionTween();
		}
		private function startTransitionTween():void {
			switch (transitionType) {
				case "Fade" :
					transitionManager.startTransition({type:Fade, direction:transitionDirection, duration:transitionDuration, easing:transitionEasing});
					break;
				case "Squeeze" :
					transitionManager.startTransition({type:Squeeze, direction:transitionDirection, duration:transitionDuration, easing:transitionEasing, dimension:TransitionTween.dimension});
					break;
				case "PixelDissolve" :
					transitionManager.startTransition({type:PixelDissolve, direction:transitionDirection, duration:transitionDuration, easing:transitionEasing, xSections:TransitionTween.xSections, ySections:TransitionTween.ySections});
					break;
				case "Zoom" :
					transitionManager.startTransition({type:Zoom, direction:transitionDirection, duration:transitionDuration, easing:transitionEasing});
					break;
				case "Photo" :
					transitionManager.startTransition({type:Photo, direction:transitionDirection, duration:transitionDuration, easing:transitionEasing});
					break;
				case "Blinds" :
					transitionManager.startTransition({type:Blinds, direction:transitionDirection, duration:transitionDuration, easing:transitionEasing, numStrips:TransitionTween.numStrips, dimension:TransitionTween.dimension});
					break;
				case "Wipe" :
					transitionManager.startTransition({type:Wipe, direction:transitionDirection, duration:transitionDuration, easing:transitionEasing, startPoint:TransitionTween.startPoint});
					break;
				default :
					transitionManager.startTransition({type:Wipe, direction:transitionDirection, duration:transitionDuration, easing:transitionEasing, startPoint:TransitionTween.startPoint});
					break;
			}
		}
		private function convertedDirection(value:Number):Number {
			if (value == 0) {
				transitionDirectionNumber = Transition.IN;
			} else if (value == 1) {
				transitionDirectionNumber = Transition.OUT;
			} else {
				transitionDirectionNumber = Transition.IN;
			}
			return (transitionDirectionNumber);
		}
		private function convertedEasing(value:String):Function {
			switch (value) {
				case "Back.easeIn" :
					transitionEasingFunction = Back.easeIn;
					break;
				case "Back.easeInOut" :
					transitionEasingFunction = Back.easeInOut;
					break;
				case "Back.easeOut" :
					transitionEasingFunction = Back.easeOut;
					break;
				case "Bounce.easeIn" :
					transitionEasingFunction = Bounce.easeIn;
					break;
				case "Bounce.easeInOut" :
					transitionEasingFunction = Bounce.easeInOut;
					break;
				case "Bounce.easeOut" :
					transitionEasingFunction = Bounce.easeOut;
					break;
				case "Elastic.easeIn" :
					transitionEasingFunction = Elastic.easeIn;
					break;
				case "Elastic.easeInOut" :
					transitionEasingFunction = Elastic.easeInOut;
					break;
				case "Elastic.easeOut" :
					transitionEasingFunction = Elastic.easeOut;
					break;
				case "None.easeIn" :
					transitionEasingFunction = None.easeIn;
					break;
				case "None.easeInOut" :
					transitionEasingFunction = None.easeInOut;
					break;
				case "None.easeNone" :
					transitionEasingFunction = None.easeNone;
					break;
				case "None.easeOut" :
					transitionEasingFunction = None.easeOut;
					break;
				case "Regular.easeIn" :
					transitionEasingFunction = Regular.easeIn;
					break;
				case "Regular.easeInOut" :
					transitionEasingFunction = Regular.easeInOut;
					break;
				case "Regular.easeOut" :
					transitionEasingFunction = Regular.easeOut;
					break;
				case "Strong.easeIn" :
					transitionEasingFunction = Strong.easeIn;
					break;
				case "Strong.easeInOut" :
					transitionEasingFunction = Strong.easeInOut;
					break;
				case "Strong.easeOut" :
					transitionEasingFunction = Strong.easeOut;
					break;
				default :
					transitionEasingFunction = None.easeNone;
					break;
			}
			return (transitionEasingFunction);
		}
		private function startTransitionTimer():void {
			transitionTimer.addEventListener(TimerEvent.TIMER, execTransitionTimer);
			transitionTimer.start();
		}
		private function execTransitionTimer(event:TimerEvent) {
			transitionTimer.removeEventListener(TimerEvent.TIMER, execTransitionTimer);
			startTransitionTween();
		}
		public static function set dimension(number):void {
			TransitionTween.$dimension = number;
		}
		public static function get dimension():Number {
			return (TransitionTween.$dimension);
		}
		public static function set xSections(number):void {
			TransitionTween.$xSections = number;
		}
		public static function get xSections():Number {
			return (TransitionTween.$xSections);
		}
		public static function set ySections(number):void {
			TransitionTween.$ySections = number;
		}
		public static function get ySections():Number {
			return (TransitionTween.$ySections);
		}
		public static function set numStrips(quantity):void {
			TransitionTween.$numStrips = quantity;
		}
		public static function get numStrips():uint {
			return (TransitionTween.$numStrips);
		}
		public static function set startPoint(number):void {
			TransitionTween.$startPoint = startPoint;
		}
		public static function get startPoint():Number {
			return (TransitionTween.$startPoint);
		}
	}
}