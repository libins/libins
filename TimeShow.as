package cn.libins 
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author libins
	 */
	public class TimeShow extends MovieClip
	{
		const ADDTIME:uint = 5;
		private var _timeGo:uint;
		private var _totalTime:Number;
		private var _currentTime:int;
		private var _speed:Number;
		private var _wSpeed:Number;
		private var gameStartTime:uint;
		private var _mTimer:Timer;
		private var initWidth:Number = 0;
		public function TimeShow() 
		{
			initWidth = timeMC.width;
			setBtn();
			trace("timeShow init!");
		}
		public function init():void {
			
			gameStartTime = getTimer();
           // _currentTime = 0;
		   if (_mTimer == null) {
			     _mTimer = new Timer(1000);
			     _mTimer.addEventListener(TimerEvent.TIMER, showTime);
			     _mTimer.start();
				 stopBtn.addEventListener(MouseEvent.CLICK, btnClick);
		         playBtn.addEventListener(MouseEvent.CLICK, btnClick);
		   }
		}
		private function setBtn() {
		     setBtnEvent(playBtn,false);	
		}
		private function btnClick(event:MouseEvent) {
		     switch(event.currentTarget.name) {
				   case "stopBtn":
				         timeStop();
						 setBtnEvent(stopBtn, false);
						 setBtnEvent(playBtn, true);
						 parent["GameSWF"].gameContral(false);
				         break;
				   case "playBtn":
				         timeStart();
						 setBtnEvent(playBtn, false);
						 setBtnEvent(stopBtn, true);
						  parent["GameSWF"].gameContral(true);
				         break;
				}	
		}
		
		private function setBtnEvent(btn, boolean) {
		     btn.mouseChildren = boolean;
		     if(boolean){
		         btn.alpha = 1;
		     }else {
			     btn.alpha = 0.5;
			}
		}
		private function showTime(event:Event):void {
		   	_timeGo = 1000;
            txtShow(_timeGo);
		}
		private function txtShow($num):void {
			//timeTxt.text = clockTime($num);
			timeMC.width -= _speed;
			clockTime($num)
		}
		private function clockTime($num:int):String {
			_currentTime -=  $num;
			//trace("clockTime",_currentTime);
			if (_currentTime <= 0) {
				timeMC.width = 0;
				removeTimer();
				parent["gameOver"]();
				return "时间到了！";
			}
		   	var seconds:int = Math.floor(_currentTime/1000);
            var minutes:int = Math.floor(seconds/60);
            seconds -= minutes * 60;
			var timeString:String = minutes +":"+String(seconds + 100).substr(1, 2);
			return "剩余时间" + timeString;
		}
		public function get totalTime():Number { return _totalTime; }
		public function get currentTime():int { return _currentTime; }
		
		public function set totalTime(value:Number):void 
		{
			_totalTime = value;
			_speed = initWidth / _totalTime;
			timeMC.width = initWidth ;
			gameStartTime = getTimer();
			_currentTime = _totalTime * 1000 ;
			_wSpeed  = initWidth / _currentTime;
	       txtShow(0);
		}
		
		
		
		public function timeStop():void {
			_mTimer.stop();
		}
		
		public function timeStart():void {
		   	_mTimer.start();
		}
		public function removeTimer() {
			if(_mTimer!=null){
			   _mTimer.removeEventListener(TimerEvent.TIMER, showTime);
			   _mTimer = null;
			}
		}
		/*-----------------*/
		public function addTime(time:Number) {
			 if (timeMC.width + _speed < initWidth) {
		         timeMC.width += _wSpeed*time*ADDTIME;
				 _currentTime += time*ADDTIME;
			 }else {
				 timeMC.width = initWidth;
				 _currentTime = _totalTime * 1000 ;
				 trace("满贯了！！");
			}
		}
	}
	
}