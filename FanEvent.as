package cn.libins{
	
	import flash.events.MouseEvent;
	
	/*扇形事件 V01
	*作者：Libins
	*时间: 2009-9-24
	*/
	public class FanEvent extends MouseEvent {
        public static const FAN_CLICK:String = "click" ;
		  public function FanEvent(){
			super(FAN_CLICK,true);
		 }
	}
}