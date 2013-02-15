package jp.atziluth.net{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.geom.Rectangle;
	import flash.filters.BitmapFilterQuality;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import caurina.transitions.Tweener;
	public class SWFLoader extends MovieClip {
		private var $parent:DisplayObjectContainer;
		private var $child:Loader;
		private var $url:URLRequest;
		protected static var onLoadFunction:Function;
		protected static var onCompleteFunction:Function;
		private var childDefAlpha:Number;
		private var loadProgressDefAlpha:Number;
		private static var isLoadProgressBar:Boolean;
		private static var isLoadProgressBarFilter:Boolean;
		private static var isLoadProgressIcon:Boolean;
		private static var isLoadProgressPercent:Boolean;
		private static var addedLoadProgress;
		public static var currentLoadProgress;
		private static var loadProgress:LoadProgress;
		private static var loadProgressBarColor:uint = 0xFFFFFF;
		private static var loadProgressBaseColor:uint = 0x333333;
		private static var loadProgressX:int = 16;
		private static var loadProgressY:int = 24;
		private static var loadProgressWidth:uint = 135;
		private static var loadProgressHeight:uint = 1;
		private static var loadProgressRectangle:Rectangle;
		private static var loadProgressFilterColor:uint = 0xFFFFFF;
		private static var loadProgressFilterAlpha:Number = 0.8;
		private static var loadProgressFilterBlurX:Number = 2;
		private static var loadProgressFilterBlurY:Number = 2;
		private static var loadProgressFilterStrength:Number = 2;
		private static var loadProgressFilterQuality:Number = BitmapFilterQuality.HIGH;
		private static var loadProgressFilterInner:Boolean = false;
		private static var loadProgressFilterKnockout:Boolean = false;
		private static var loadProgressPercentFont:String = "_serif";
		private static var loadProgressPercentFontSize:uint = 12;
		private static var loadProgressPercentFontColor:uint = 0xFFFFFF;
		private static var loadProgressFadeInParams:Array = [.25,"Strong.easeOut",0];
		private static var loadProgressFadeOutParams:Array = [.5,"easeInOutCubic",0];
		private static var childFadeInParams:Array = [1,"liner",0];
		private static var isDeleteLoadProgress:Boolean = false;
		private static var isLoading:Boolean = false;
		private static var totalBytes:Number;
		private static var loadedBytes:Number;
		private static var per:uint;
		private var loadTimer:Timer;
		private var Tween:Function = Tweener.addTween;
		private var removeTween:Function = Tweener.removeTweens;
		public function load(
		    $parent:DisplayObjectContainer, 
		    url:String, 
		    onLoadFunction:Function=null, 
		    onCompleteFunction:Function=null, 
		    childDefAlpha:Number=0,
		    loadProgressDefAlpha:Number=0,
		    delaySecond:Number=0,
		    isLoadProgressBar:Boolean=true,
		    isLoadProgressBarFilter:Boolean=true,
		    isLoadProgressIcon:Boolean=false,
		    isLoadProgressPercent:Boolean=false,
		    addedLoadClip:Sprite=null
		):void {
			this.$child = new Loader();
			this.$parent = $parent;
			this.$parent.addChildAt($child, this.$parent.numChildren);
			this.$url = new URLRequest(url);
			SWFLoader.onLoadFunction = onLoadFunction;
			SWFLoader.onCompleteFunction = onCompleteFunction;
			this.childDefAlpha = childDefAlpha;
			this.loadProgressDefAlpha = loadProgressDefAlpha;
			delaySecond ? loadTimer = new Timer(delaySecond * 1000,0):loadTimer = null;
			SWFLoader.loadProgressBar = isLoadProgressBar;
			SWFLoader.loadProgressBarFilter = isLoadProgressBarFilter;
			SWFLoader.loadProgressIcon = isLoadProgressIcon;
			SWFLoader.loadProgressPercent = isLoadProgressPercent;
			if (addedLoadClip) {
				SWFLoader.addedLoadProgress = addedLoadClip;
			} else {
				if (SWFLoader.rectangle == null) {
					SWFLoader.rectangle = new Rectangle(
					    SWFLoader.x,
					    SWFLoader.y,
					    SWFLoader.width,
					    SWFLoader.height
					);
				}
				SWFLoader.loadProgress = new LoadProgress(
				    SWFLoader.barColor,
				    SWFLoader.baseColor,
				    SWFLoader.rectangle,
				    SWFLoader.filterColor,
				    SWFLoader.filterAlpha,
				    SWFLoader.filterBlurX,
				    SWFLoader.filterBlurY,
				    SWFLoader.filterStrength,
				    SWFLoader.filterQuality,
				    SWFLoader.filterInner,
				    SWFLoader.filterKnockout,
				    SWFLoader.percentFont,
				    SWFLoader.percentFontSize,
				    SWFLoader.percentFontColor,
				    SWFLoader.loadProgressBar,
				    SWFLoader.loadProgressBarFilter,
				    SWFLoader.loadProgressIcon,
				    SWFLoader.loadProgressPercent
				);
			}
			if (SWFLoader.addedLoadProgress) {
				SWFLoader.currentLoadProgress = SWFLoader.addedLoadProgress;
			} else {
				SWFLoader.currentLoadProgress = SWFLoader.loadProgress;
			}
			$parent.addChildAt(
			    SWFLoader.currentLoadProgress,
			    $parent.numChildren
			);
			with (SWFLoader.currentLoadProgress) {
				alpha = 0;
				visible = false;
			}
			$child.contentLoaderInfo.addEventListener(Event.OPEN, onLoadHandler);
			$child.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			$child.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			$child.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			$child.visible = false;
			$child.alpha = this.childDefAlpha;
			loadTimer ? setLoadTimer():execLoad();
		}
		private function setLoadTimer():void {
			loadTimer.addEventListener(TimerEvent.TIMER, execLoadTimer);
			loadTimer.start();
		}
		private function execLoadTimer(event:TimerEvent) {
			loadTimer.removeEventListener(TimerEvent.TIMER, execLoadTimer);
			execLoad();
		}
		private function execLoad():void {
			$child.load($url);
		}
		private function onLoadHandler(event:Event):void {
			with (SWFLoader.currentLoadProgress) {
				alpha = loadProgressDefAlpha;
				visible = true;
			}
			if (SWFLoader.currentLoadProgress.alpha < 1) {
				Tween(SWFLoader.currentLoadProgress,{
				    alpha:1,
				    time:SWFLoader.loadProgressFadeInSecond,
				    transition:SWFLoader.loadProgressFadeInEase,
				    delay:SWFLoader.loadProgressFadeInDelay
				});
			}
			if (SWFLoader.onLoadFunction != null) {
				SWFLoader.onLoadFunction();
			}
			SWFLoader.isLoading = true;
		}
		private function onProgressHandler(event:ProgressEvent):void {
			SWFLoader.bytesTotal = event.bytesTotal;
			SWFLoader.bytesLoaded = event.bytesLoaded;
			SWFLoader.percent = Math.floor(SWFLoader.bytesLoaded / SWFLoader.bytesTotal * 100);
			if (SWFLoader.loadProgressBar) {
				SWFLoader.currentLoadProgress.bar.scaleX = SWFLoader.bytesLoaded / SWFLoader.bytesTotal;
			}
			if (SWFLoader.loadProgressPercent) {
				SWFLoader.currentLoadProgress.percent.getChildByName("percentText").text = String(SWFLoader.percent) + "%";
			}
		}
		private function onCompleteHandler(event:Event):void {
			Tween(SWFLoader.currentLoadProgress,{
			    alpha:0,
			    time:SWFLoader.loadProgressFadeOutSecond,
			    transition:SWFLoader.loadProgressFadeOutEase,
			    delay:SWFLoader.loadProgressFadeOutDelay,
			    onComplete:onFinish
			});
			if (SWFLoader.onCompleteFunction != null) {
				SWFLoader.onCompleteFunction();
			}
			SWFLoader.isLoading = false;
		}
		private function onFinish():void {
			$child.contentLoaderInfo.removeEventListener(Event.OPEN, onLoadHandler);
			$child.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			$child.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler);
			$child.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			$child.visible = true;
			if ($child.alpha < 1) {
				Tween($child, {
				    alpha:1,
				    time:SWFLoader.childFadeInSecond,
				    transition:SWFLoader.childFadeInEase,
				    delay:SWFLoader.childFadeInDelay,
				    onComplete:removeTween,
				    onCompleteParams:[$child]
				});
			}
			if (SWFLoader.clearLoadProgress) {
				deleteLoadProgress();
			}
		}
		private function deleteLoadProgress():void {
			while (SWFLoader.currentLoadProgress.numChildren > 0) {
				SWFLoader.currentLoadProgress.removeChildAt(0);
			}
			removeTween(SWFLoader.currentLoadProgress);
		}
		private function onIOErrorHandler(event:IOErrorEvent):void {
			trace(event);
		}
		public static function get loading():Boolean {
			return (SWFLoader.isLoading);
		}
		public static function get complete():Boolean {
			return !(SWFLoader.isLoading);
		}
		public static function set bytesTotal(totalBytes:Number):void {
			SWFLoader.totalBytes = totalBytes;
		}
		public static function get bytesTotal():Number {
			return (SWFLoader.totalBytes);
		}
		public static function set bytesLoaded(loadedBytes:Number):void {
			SWFLoader.loadedBytes = loadedBytes;
		}
		public static function get bytesLoaded():Number {
			return (SWFLoader.loadedBytes);
		}
		public static function set percent(p:uint):void {
			SWFLoader.per = p;
		}
		public static function get percent():uint {
			return (SWFLoader.per);
		}
		public static function set clearLoadProgress(b:Boolean):void {
			SWFLoader.isDeleteLoadProgress = b;
		}
		public static function get clearLoadProgress():Boolean {
			return (SWFLoader.isDeleteLoadProgress);
		}
		public static function set loadProgressBar(b:Boolean):void {
			SWFLoader.isLoadProgressBar = b;
		}
		public static function get loadProgressBar():Boolean {
			return (SWFLoader.isLoadProgressBar);
		}
		public static function set loadProgressBarFilter(b:Boolean):void {
			SWFLoader.isLoadProgressBarFilter = b;
		}
		public static function get loadProgressBarFilter():Boolean {
			return (SWFLoader.isLoadProgressBarFilter);
		}
		public static function set loadProgressIcon(b:Boolean):void {
			SWFLoader.isLoadProgressIcon = b;
		}
		public static function get loadProgressIcon():Boolean {
			return (SWFLoader.isLoadProgressIcon);
		}
		public static function set loadProgressPercent(b:Boolean):void {
			SWFLoader.isLoadProgressPercent = b;
		}
		public static function get loadProgressPercent():Boolean {
			return (SWFLoader.isLoadProgressPercent);
		}
		public static function set barColor($color:uint):void {
			SWFLoader.loadProgressBarColor = $color;
		}
		public static function get barColor():uint {
			return (SWFLoader.loadProgressBarColor);
		}
		public static function set baseColor($color:uint):void {
			SWFLoader.loadProgressBaseColor = $color;
		}
		public static function get baseColor():uint {
			return (SWFLoader.loadProgressBaseColor);
		}
		public static function set x($x:int):void {
			SWFLoader.loadProgressX = $x;
		}
		public static function get x():int {
			return (SWFLoader.loadProgressX);
		}
		public static function set y($y:int):void {
			SWFLoader.loadProgressY = $y;
		}
		public static function get y():int {
			return (SWFLoader.loadProgressY);
		}
		public static function set width($width:uint):void {
			SWFLoader.loadProgressWidth = $width;
		}
		public static function get width():uint {
			return (SWFLoader.loadProgressWidth);
		}
		public static function set height($height:uint):void {
			SWFLoader.loadProgressHeight = $height;
		}
		public static function get height():uint {
			return (SWFLoader.loadProgressHeight);
		}
		public static function set rectangle($rectangle:Rectangle):void {
			SWFLoader.loadProgressRectangle = $rectangle;
		}
		public static function get rectangle():Rectangle {
			return (SWFLoader.loadProgressRectangle);
		}
		public static function set filterColor($color:uint):void {
			SWFLoader.loadProgressFilterColor = $color;
		}
		public static function get filterColor():uint {
			return (SWFLoader.loadProgressFilterColor);
		}
		public static function set filterAlpha($alpha:Number):void {
			SWFLoader.loadProgressFilterAlpha = $alpha;
		}
		public static function get filterAlpha():Number {
			return (SWFLoader.loadProgressFilterAlpha);
		}
		public static function set filterBlurX($blurX:Number):void {
			SWFLoader.loadProgressFilterBlurX = $blurX;
		}
		public static function get filterBlurX():Number {
			return (SWFLoader.loadProgressFilterBlurX);
		}
		public static function set filterBlurY($blurY:Number):void {
			SWFLoader.loadProgressFilterBlurY = $blurY;
		}
		public static function get filterBlurY():Number {
			return (SWFLoader.loadProgressFilterBlurY);
		}
		public static function set filterStrength($strength:Number):void {
			SWFLoader.loadProgressFilterStrength = $strength;
		}
		public static function get filterStrength():Number {
			return (SWFLoader.loadProgressFilterStrength);
		}
		public static function set filterQuality($quality:Number):void {
			SWFLoader.loadProgressFilterStrength = $quality;
		}
		public static function get filterQuality():Number {
			return (SWFLoader.loadProgressFilterQuality);
		}
		public static function set filterInner($inner:Boolean):void {
			SWFLoader.loadProgressFilterInner = $inner;
		}
		public static function get filterInner():Boolean {
			return (SWFLoader.loadProgressFilterInner);
		}
		public static function set filterKnockout($knockout:Boolean):void {
			SWFLoader.loadProgressFilterKnockout = $knockout;
		}
		public static function get filterKnockout():Boolean {
			return (SWFLoader.loadProgressFilterKnockout);
		}
		public static function set percentFont($font:String):void {
			SWFLoader.loadProgressPercentFont = $font;
		}
		public static function get percentFont():String {
			return (SWFLoader.loadProgressPercentFont);
		}
		public static function set percentFontSize($fontSize:uint):void {
			SWFLoader.loadProgressPercentFontSize = $fontSize;
		}
		public static function get percentFontSize():uint {
			return (SWFLoader.loadProgressPercentFontSize);
		}
		public static function set percentFontColor($fontColor:uint):void {
			SWFLoader.loadProgressPercentFontColor = $fontColor;
		}
		public static function get percentFontColor():uint {
			return (SWFLoader.loadProgressPercentFontColor);
		}
		public static function set loadProgressFadeInSecond(sec:Number):void {
			SWFLoader.loadProgressFadeInParams[0] = sec;
		}
		public static function get loadProgressFadeInSecond():Number {
			return (SWFLoader.loadProgressFadeInParams[0]);
		}
		public static function set loadProgressFadeInEase(ease:String):void {
			SWFLoader.loadProgressFadeInParams[1] = ease;
		}
		public static function get loadProgressFadeInEase():String {
			return (SWFLoader.loadProgressFadeInParams[1]);
		}
		public static function set loadProgressFadeInDelay(delay:Number):void {
			SWFLoader.loadProgressFadeInParams[2] = delay;
		}
		public static function get loadProgressFadeInDelay():Number {
			return (SWFLoader.loadProgressFadeInParams[2]);
		}
		public static function set loadProgressFadeOutSecond(sec:Number):void {
			SWFLoader.loadProgressFadeOutParams[0] = sec;
		}
		public static function get loadProgressFadeOutSecond():Number {
			return (SWFLoader.loadProgressFadeOutParams[0]);
		}
		public static function set loadProgressFadeOutEase(ease:String):void {
			SWFLoader.loadProgressFadeOutParams[1] = ease;
		}
		public static function get loadProgressFadeOutEase():String {
			return (SWFLoader.loadProgressFadeOutParams[1]);
		}
		public static function set loadProgressFadeOutDelay(delay:Number):void {
			SWFLoader.loadProgressFadeOutParams[2] = delay;
		}
		public static function get loadProgressFadeOutDelay():Number {
			return (SWFLoader.loadProgressFadeOutParams[2]);
		}
		public static function set childFadeInSecond(sec:Number):void {
			SWFLoader.childFadeInParams[0] = sec;
		}
		public static function get childFadeInSecond():Number {
			return (SWFLoader.childFadeInParams[0]);
		}
		public static function set childFadeInEase(ease:String):void {
			SWFLoader.childFadeInParams[1] = ease;
		}
		public static function get childFadeInEase():String {
			return (SWFLoader.childFadeInParams[1]);
		}
		public static function set childFadeInDelay(delay:Number):void {
			SWFLoader.childFadeInParams[2] = delay;
		}
		public static function get childFadeInDelay():Number {
			return (SWFLoader.childFadeInParams[2]);
		}
	}
}
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;
internal class LoadProgress extends Sprite {
	public var bar:Sprite = new Sprite();
	public var base:Sprite = new Sprite();
	private var barShape:Shape;
	private var baseShape:Shape;
	public var icon:MovieClip;
	public var percent:Sprite = new Sprite();
	private var percentText:TextField = new TextField();
	private var percentTextFormat:TextFormat = new TextFormat();
	public function LoadProgress(
	    barColor:uint,
	    baseColor:uint,
	    barRectangle:Rectangle,
	    filterColor:uint,
	    filterAlpha:Number,
	    filterBlurX:Number,
	    filterBlurY:Number,
	    filterStrength:Number,
	    filterQuality:Number,
	    filterInner:Boolean,
	    filterKnockout:Boolean,
	    percentFont:String,
	    percentFontSize:uint,
	    percentFontColor:uint,
	    isLoadProgressBar:Boolean,
	    isLoadProgressBarFilter:Boolean,
	    isLoadProgressIcon:Boolean,
	    isLoadProgressPercent:Boolean
	 ):void {
		if (isLoadProgressBar) {
			barShape = drawnShape(barColor,barRectangle);
			baseShape = drawnShape(baseColor,barRectangle);
			addLoadProgressBar(base, baseShape, "baseShape", this.numChildren,barRectangle);
			addLoadProgressBar(bar, barShape, "barShape", this.numChildren,barRectangle);
			if (isLoadProgressBarFilter) {
				setLoadProgressBarFilter(bar, 
				    glowFilter(
				        filterColor, 
				        filterAlpha, 
				        filterBlurX, 
				        filterBlurY, 
				        filterStrength, 
				        filterQuality, 
				        filterInner, 
				        filterKnockout
				    )
				);
			}
			initLoadProgressBarScale(bar, 0);
		}
		if (isLoadProgressIcon) {
			addLoadProgressIcon("icon", this.numChildren);
		}
		if (isLoadProgressPercent) {
			addLoadProgressPercent(percent, percentText, "percentText", this.numChildren);
			setPercentTextFormat(percentFont, percentFontSize, percentFontColor);
			setPercentTextField();
		}
	}
	private function drawnShape($color:uint, $rectangle:Rectangle):Shape {
		var shape:Shape = new Shape();
		shape.graphics.beginFill($color);
		shape.graphics.drawRect(0,0,$rectangle.width,$rectangle.height);
		return Shape(shape);
	}
	private function addLoadProgressBar($parent:Sprite, $child:Shape, $name:String, $depth:int, $rectangle:Rectangle):void {
		this.addChildAt($parent, $depth);
		$parent.x = $rectangle.x;
		$parent.y = $rectangle.y;
		$parent.addChildAt($child, 0);
		$child.name = $name;
	}
	private function setLoadProgressBarFilter($bar:Sprite, $filters:GlowFilter):void {
		$bar.filters = [$filters];
	}
	private function initLoadProgressBarScale($bar:Sprite, $scaleX:Number):void {
		$bar.scaleX = $scaleX;
	}
	private function addLoadProgressIcon($name:String, $depth:int):void {
		icon = new LoadProgressIcon();//この行でライブラリのリンケージクラス 「LoadProgressIcon」を使用しています
		this.addChildAt(icon, $depth);
		icon.name = $name;
	}
	private function addLoadProgressPercent($parent:Sprite, $child:TextField, $name:String, $depth:int):void {
		this.addChildAt($parent, $depth);
		$parent.addChildAt($child, 0);
		$child.name = $name;
	}
	private function setPercentTextFormat(font:String, size:uint, color:uint):void {
		percentTextFormat.font = font;
		percentTextFormat.size = size;
		percentTextFormat.color = color;
	}
	private function setPercentTextField():void {
		percentText.autoSize = "left";
		percentText.multiline = false;
		percentText.wordWrap = false;
		percentText.selectable = false;
		percentText.mouseWheelEnabled = false;
		percentText.defaultTextFormat = percentTextFormat;
		percentText.text = String(0);
	}
	private function glowFilter(
	    color:uint=0xFFFFFF, 
	    alpha:Number=.8, 
	    blurX:Number=2, 
	    blurY:Number=2, 
	    strength:Number=2, 
	    quality:Number=BitmapFilterQuality.HIGH, 
	    inner:Boolean=false, 
	    knockout:Boolean=false
	):GlowFilter {
		return new GlowFilter(
		    color,
		    alpha,
		    blurX,
		    blurY,
		    strength,
		    quality,
		    inner,
		    knockout
		);
	}
}