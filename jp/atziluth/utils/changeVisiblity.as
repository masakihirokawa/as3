package jp.atziluth.utils{
	import flash.display.DisplayObject;
	public function changeVisiblity($scope:DisplayObject, $visible:Boolean, $alpha:Number):void {
		$scope.visible = $visible;
		$scope.alpha = $alpha;
	}
}