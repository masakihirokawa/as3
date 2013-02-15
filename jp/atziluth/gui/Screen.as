﻿package jp.atziluth.gui{
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.DisplayObjectContainer;
	import flash.system.Capabilities;
	import flash.events.MouseEvent;
	import com.rails2u.bridge.JSProxy;
	public class Screen extends Stage {
		public static var stage:Stage;
		private static var _stageWidth:uint;
		private static var _stageHeight:uint;
		private static var _aspect:Number;
		public static const NORMAL_SCREEN_ASPECT:Number = 1.25;
		public static const WIDE_SCREEN_ASPECT:Number = 1.6;
		private static const CHROME:String = "Chrome";
		private static const IE:String = "IE";
		private static const FIREFOX:String = "Firefox";
		private static const SAFARI:String = "Safari";
		private static const OPERA:String = "Opera";
		private static const UNKNOWN:String = "Unknown";
		private static const ERROR:String = "Error";
		private static var _externalGUIHeight:uint;
		private static var _osGUIHeight:uint = 40;
		private static var _chromeGUIHeight:uint = 86;
		private static var _ieGUIHeight:uint = 146;
		private static var _firefoxGUIHeight:uint = 156;
		private static var _safariGUIHeight:uint = 82;
		private static var _operaGUIHeight:uint = 91;
		private static const AVERAGE_GUI_HEIGHT:uint = Math.round((chromeGUIHeight + ieGUIHeight + firefoxGUIHeight + safariGUIHeight + operaGUIHeight) / 5);
		//private static var determiningBrowser:DeterminingBrowser;
		public function Screen(stage:Stage):void {
			Screen.stage = stage;
		}
		public static function set stageWidth(sw:uint):void {
			Screen._stageWidth = sw;
		}
		public static function get stageWidth():uint {
			return ((Screen.stage!=null)? Screen.stage.stageWidth : Screen._stageWidth);
		}
		public static function set stageHeight(sh:uint):void {
			Screen._stageHeight = sh;
		}
		public static function get stageHeight():uint {
			return ((Screen.stage!=null)? Screen.stage.stageHeight : Screen._stageHeight);
		}
		public static function get screenResolutionX():uint {
			return (Capabilities.screenResolutionX);
		}
		public static function get screenResolutionY():uint {
			return (Capabilities.screenResolutionY);
		}
		public static function get aspect():Number {
			if (Screen.stage == null) {
				throw new ArgumentError("Screen.aspect: 静的クラスメンバ stageが初期化されていません");
				return;
			}
			if (Screen.displayState == StageDisplayState.FULL_SCREEN) {
				Screen._aspect = Screen.getRatio(Screen.screenResolutionX,Screen.screenResolutionY);
			} else {
				Screen.stageWidth = Screen.stage.stageWidth;
				Screen.stageHeight = Screen.stage.stageHeight;
				Screen._aspect = Screen.getRatio(Screen.stageWidth,Screen.stageHeight);
			}
			return (Screen._aspect);
		}
		public static function changeDisplayState(event:MouseEvent=null):void {
			if (Screen.stage == null) {
				throw new ArgumentError("Screen.changeDisplayState: 静的クラスメンバ stageが初期化されていません");
				return;
			}
			if (Screen.stage.displayState == StageDisplayState.NORMAL) {
				Screen.stage.displayState = StageDisplayState.FULL_SCREEN;
				Screen.stage.displayState = "fullScreen";
			} else {
				Screen.stage.displayState = StageDisplayState.NORMAL;
				Screen.stage.displayState = "normal";
			}
		}
		public static function get displayState():String {
			if (Screen.stage == null) {
				throw new ArgumentError("Screen.displayState: 静的クラスメンバ stageが初期化されていません");
				return;
			}
			return (Screen.stage.displayState);
		}
		public static function get fullScreen():Boolean {
			if (Screen.stage == null) {
				throw new ArgumentError("Screen.fullScreen: 静的クラスメンバ stageが初期化されていません");
				return;
			}
			return (Screen.stage.displayState=="fullScreen");
		}
		public static function fit(
		    $scope:DisplayObjectContainer, 
		    aspectReferenceSource:Boolean=false, 
		    aspect:Number=1.6, 
		    absolutelyFit:Boolean=false
		):void {
			if (Screen.stage == null) {
				throw new ArgumentError("Screen.fit: 静的クラスメンバ stageが初期化されていません");
				return;
			}
			if ($scope == null) {
				throw new ArgumentError("Screen.fit: ターゲットが存在しません");
				return;
			}
			Screen.stageWidth = Screen.stage.stageWidth;
			Screen.stageHeight = Screen.stage.stageHeight;
			if (absolutelyFit) {
				$scope.width = Screen.stageWidth;
				$scope.height = Screen.stageHeight;
			} else {
				if (aspectReferenceSource) {
					aspect = Screen.getRatio($scope.width,$scope.height);
				}
				if (Screen.isWidescreen) {
					$scope.width = (Screen.stageHeight * aspect) + Screen.externalGUIHeight;
					$scope.height = Screen.stageHeight;
					if ($scope.width < Screen.stageWidth) {
						$scope.width = Screen.stageWidth;
						$scope.height = Screen.stageWidth / aspect;
					}
				} else {
					$scope.width = Screen.stageWidth;
					$scope.height = (Screen.stageWidth / aspect) + Screen.externalGUIHeight;
					if ($scope.height < Screen.stageHeight) {
						$scope.width = Screen.stageHeight * aspect;
						$scope.height = Screen.stageHeight;
					}
				}
				Screen.centering($scope);
			}
			/*
			trace(
			    "-------------------------------------------------"+"\n"+
			    "$scope: "+$scope+"\n"+
			    "$scope.x: "+$scope.x+"\n"+
			    "$scope.y: "+$scope.y+"\n"+
			    "$scope.width: "+$scope.width+"\n"+
			    "$scope.height: "+$scope.height+"\n"+
			    "aspectReferenceSource: "+aspectReferenceSource+"\n"+
			    "aspect: "+aspect+"\n"+
			    "absolutelyFit: "+absolutelyFit+"\n"+
			  "-------------------------------------------------"+"\n"
			);
			*/
		}
		public static function set osGUIHeight(value:uint):void {
			_osGUIHeight = value;
		}
		public static function get osGUIHeight():uint {
			return (_osGUIHeight);
		}
		public static function set chromeGUIHeight(value:uint):void {
			_chromeGUIHeight = value;
		}
		public static function get chromeGUIHeight():uint {
			return (_chromeGUIHeight);
		}
		public static function set ieGUIHeight(value:uint):void {
			_ieGUIHeight = value;
		}
		public static function get ieGUIHeight():uint {
			return (_ieGUIHeight);
		}
		public static function set firefoxGUIHeight(value:uint):void {
			_firefoxGUIHeight = value;
		}
		public static function get firefoxGUIHeight():uint {
			return (_firefoxGUIHeight);
		}
		public static function set safariGUIHeight(value:uint):void {
			_safariGUIHeight = value;
		}
		public static function get safariGUIHeight():uint {
			return (_safariGUIHeight);
		}
		public static function set operaGUIHeight(value:uint):void {
			_operaGUIHeight = value;
		}
		public static function get operaGUIHeight():uint {
			return (_operaGUIHeight);
		}
		public static function set externalGUIHeight(value:uint):void {
			_externalGUIHeight = value;
		}
		public static function get externalGUIHeight():uint {
			try {
				if (Screen.userAgent.search("MSIE") > -1) {
					_externalGUIHeight = ieGUIHeight + osGUIHeight;
				} else if (Screen.userAgent.search("Firefox")>-1) {
					_externalGUIHeight = firefoxGUIHeight + osGUIHeight;
				} else if (Screen.userAgent.search("Opera")>-1) {
					_externalGUIHeight = operaGUIHeight + osGUIHeight;
				} else if (Screen.userAgent.search("Safari")>-1) {
					_externalGUIHeight = safariGUIHeight + osGUIHeight;
				} else if (Screen.userAgent.search("Chrome")>-1) {
					_externalGUIHeight = chromeGUIHeight + osGUIHeight;
				} else {
					_externalGUIHeight = AVERAGE_GUI_HEIGHT + osGUIHeight;
				}
				/*
				switch (Screen.userAgent) {
				case CHROME :
				_externalGUIHeight = chromeGUIHeight + osGUIHeight;
				break;
				case IE :
				_externalGUIHeight = ieGUIHeight + osGUIHeight;
				break;
				case FIREFOX :
				_externalGUIHeight = firefoxGUIHeight + osGUIHeight;
				break;
				case SAFARI :
				_externalGUIHeight = safariGUIHeight + osGUIHeight;
				break;
				case OPERA :
				_externalGUIHeight = operaGUIHeight + osGUIHeight;
				break;
				case UNKNOWN :
				_externalGUIHeight = AVERAGE_GUI_HEIGHT + osGUIHeight;
				break;
				case ERROR :
				_externalGUIHeight = AVERAGE_GUI_HEIGHT + osGUIHeight;
				break;
				default :
				_externalGUIHeight = AVERAGE_GUI_HEIGHT + osGUIHeight;
				break;
				}
				*/
			} catch (error:TypeError) {
				_externalGUIHeight = 0;
			} finally {
				return (_externalGUIHeight);
			}
		}
		public static function get isWidescreen():Boolean {
			return (Screen.getRatio(Screen.screenResolutionX,Screen.screenResolutionY) >= Screen.WIDE_SCREEN_ASPECT);
		}
		public static function get userAgent():String {
			/*
			determiningBrowser.init();
			if (determiningBrowser.userAgent == null) {
			throw new ArgumentError("Screen.userAgent: determiningBrowser.userAgent is null");
			return;
			}
			return (determiningBrowser.userAgent);
			*/
			return (JSProxy.proxy.navigator.$userAgent);
		}
		private static function centering($scope:DisplayObjectContainer):void {
			if ($scope.width >= Screen.stageWidth) {
				$scope.x = (Screen.stageWidth-$scope.width)/2;
			}
			if ($scope.height >= Screen.stageHeight) {
				$scope.y = (Screen.stageHeight-$scope.height)/2;
			}
		}
		private static function getRatio(p:Number, q:Number):Number {
			return (p/q);
		}
	}
}
import com.rails2u.bridge.JSProxy;
//import flash.external.ExternalInterface;
internal class DeterminingBrowser {
	private var _userAgent:String;
	private var jsProxyUserAgent = JSProxy.proxy.navigator.$userAgent;
	private var userAgentToLowerCase:String;
	private const IE:String = "IE";
	private const FIREFOX:String = "Firefox";
	private const OPERA:String = "Opera";
	private const SAFARI:String = "Safari";
	private const CHROME:String = "Chrome";
	private const UNKNOWN:String = "Unknown";
	private const ERROR:String = "Error";
	public function DeterminingBrowser():void {
	}
	public function init():void {
		if (jsProxyUserAgent == null) {
			trace("DeterminingBrowser: JSProxy is not available");
			_userAgent = ERROR;
		} else {
			userAgentToLowerCase = jsProxyUserAgent.toLowerCase();
			if (userAgentToLowerCase.search("msie") > -1) {
				_userAgent = IE;
			} else if (userAgentToLowerCase.search("firefox")>-1) {
				_userAgent = FIREFOX;
			} else if (userAgentToLowerCase.search("opera")>-1) {
				_userAgent = OPERA;
			} else if (userAgentToLowerCase.search("safari")>-1) {
				_userAgent = SAFARI;
			} else if (userAgentToLowerCase.search("chrome")>-1) {
				_userAgent = CHROME;
			} else {
				_userAgent = UNKNOWN;
			}
		}
		/*
		if (ExternalInterface.available) {
		userAgentToLowerCase = ExternalInterface.call("window.navigator.userAgent.toLowerCase");
		if (userAgentToLowerCase.indexOf("msie")) {
		_userAgent = IE;
		} else if (userAgentToLowerCase.indexOf("firefox")) {
		_userAgent = FIREFOX;
		} else if (userAgentToLowerCase.indexOf("opera")) {
		_userAgent = OPERA;
		} else if (userAgentToLowerCase.indexOf("safari")) {
		_userAgent = SAFARI;
		} else if (userAgentToLowerCase.indexOf("chrome")) {
		_userAgent = CHROME;
		} else {
		_userAgent = UNKNOWN;
		}
		} else {
		trace("DeterminingBrowser: ExternalInterface is not available");
		_userAgent = ERROR;
		}
		*/
	}
	public function get userAgent():String {
		if (_userAgent) {
			return (_userAgent);
		} else {
			trace("DeterminingBrowser: _userAgent is null");
			return (ERROR);
		}

	}
}