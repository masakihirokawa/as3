﻿package jp.atziluth.utils{
	public class Correct {
		public static function NUMBER(n:Number, d:Number):Number {
			n = Number(n);
			d = Number(d);
			if (! n || isNaN(n)) {
				return (d);
			} else {
				return (n);
			}
		}
		public static function INT(i:int, d:int):int {
			i = int(i);
			d = int(d);
			if (! i || isNaN(i)) {
				return (d);
			} else {
				return (i);
			}
		}
		public static function UINT(u:uint, d:uint):uint {
			u = uint(u);
			d = uint(d);
			if (! u || isNaN(u)) {
				return (d);
			} else {
				return (u);
			}
		}
		public static function STRING(s:String, d:String):String {
			if (! s || s == null) {
				return (d);
			} else {
				return (s);
			}
		}
		public static function BoolInt(o:Object, d:Boolean) {
			if (o) {
				if (int(o) <= 0) {
					return false;
				} else if (int(o)>=1) {
					return true;
				}
			} else {
				return d;
			}
		}
		public static function ID(id:uint,max:uint,min:uint=1):uint {
			if (id < min) {
				return (max);
			}
			if (id > max) {
				return (min);
			}
			return (id);
		}
	}
}