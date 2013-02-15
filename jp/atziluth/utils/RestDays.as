﻿package jp.atziluth.utils{
	public class RestDays {
		private var targetDate:Date;
		private var nowDate:Date;
		private var dateCnt:Number;
		private var totalHour:Number;
		private var hourCnt:Number;
		private var minCnt:Number;
		private var secCnt:Number;
		private var milliCnt:Number;
		private var dateStr:String;
		private var hourStr:String;
		private var minStr:String;
		private var secStr:String;
		private var milliStr:String;
		public var firstDate:String = "0";
		public var firstHour:String = "0";
		public var firstMin:String = "0";
		public var firstSec:String = "0";
		public function RestDays(year:uint, month:uint, day:uint):void {
			targetDate = new Date(year,month - 1,day + 1,0,0,0);
			nowDate = new Date();
			milliCnt = targetDate.getTime() - nowDate.getTime();
			dateCnt = Math.floor(milliCnt / (24 * 60 * 60 * 1000));
			totalHour = Math.floor(milliCnt / (60 * 60 * 1000));
			hourCnt = totalHour - (dateCnt*24);
			minCnt = Math.floor(milliCnt / (60 * 1000)) - (totalHour * 60);
			secCnt = Math.ceil(milliCnt / 1000) - ((minCnt * 60) + (totalHour * 60 * 60));
		}
		public function get date():String {
			if (dateCnt < 1) {
				dateStr = null;
			} else {
				//dateCnt < 10 ? dateStr = firstDate + String(dateCnt):dateStr = String(dateCnt);
				dateStr = String(dateCnt);
			}
			return (dateStr);
		}
		public function get hour():String {
			hourCnt < 10 ? hourStr = firstHour + String(hourCnt):hourStr = String(hourCnt);
			return (hourStr);
		}
		public function get min():String {
			minCnt < 10 ? minStr = firstMin + String(minCnt):minStr = String(minCnt);
			return (minStr);
		}
		public function get sec():String {
			secCnt < 10 ? secStr = firstSec + String(secCnt):secStr = String(secCnt);
			return (secStr);
		}
	}
}