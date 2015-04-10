package cn.libins {
	import flash.display.MovieClip;
	import gs.TweenLite;
    import fl.transitions.Tween;
    import fl.transitions.easing.*;
	import flash.events.MouseEvent;
	
	final public class MenuSpring extends MovieClip{
        private var currentMC :MovieClip;
        private var bigScale  :Number = 90;
        private var usuSacel  :Number = 70;
        private var smallScale:Number = 50;
        private var totalNum  :uint;
		private var menu      :MovieClip;
		private var delayTime :Number = 0;
		private var btnName   :String;

	public function btnSpring($totalNum:uint,$menuMC:MovieClip,$bigScale:Number = 90,$usuSacel:Number = 70,$smallScale:Number = 50,$delayTime:Number = 1,$btnName:String="btn"){
	     totalNum   = $totalNum;
		 menu       = $menuMC;
		 bigScale   = $bigScale;
		 usuSacel   = $usuSacel;
		 smallScale = $smallScale;
		 delayTime  = $delayTime;
		 btnName    = $btnName;
	     for(var i:int = 0;i<totalNum;i++){
	          menu[btnName+(i+1)].buttonMode = true;
	          menu[btnName+(i+1)].gotoAndStop("on");
	          menu[btnName+(i+1)].addEventListener(MouseEvent.MOUSE_OVER,btnOver);
	          menu[btnName+(i+1)].addEventListener(MouseEvent.MOUSE_OUT,btnOut);
	          menu[btnName+(i+1)].addEventListener(MouseEvent.CLICK,btnClick);
	     }
    }

     private function btnClick(event:MouseEvent):void{
	      if(currentMC!=null) {
		     springMove(currentMC,"small")
	      }
	     currentMC = MovieClip(event.currentTarget);
	     springMove(currentMC,"big")
    }

    private function btnOver(event:MouseEvent):void{
	     MovieClip(event.currentTarget).gotoAndPlay("over");
	     springMove(MovieClip(event.currentTarget),"big")
    }

    private function btnOut(event:MouseEvent):void{
		 MovieClip(event.currentTarget).gotoAndStop(1);
	     if(currentMC != MovieClip(event.currentTarget)&&currentMC==null) {
		     springMove(MovieClip(event.currentTarget),"small")
	     }else{
		     springMove(currentMC,"big")
	     }
    }

	private function springMove(mc:MovieClip,type:String):void{
	     var tempMC:MovieClip 
	     var i:int =0
	     if(type=="big"){
		      for(i= 0;i<totalNum;i++){
			     tempMC= menu[btnName+(i+1)];
			     if(mc == tempMC){
		             TweenLite.to(tempMC, delayTime, {scaleX:bigScale, scaleY:bigScale, ease:Elastic.easeOut});
			     }else{
				     TweenLite.to(tempMC, delayTime, {scaleX:smallScale, scaleY:smallScale, ease:Elastic.easeOut});
			    }
		  }
	    }else{
		     for(i= 0;i<totalNum;i++){
			    tempMC = menu[btnName+(i+1)];
		        TweenLite.to(tempMC, delayTime, {scaleX:usuSacel, scaleY:usuSacel, ease:Elastic.easeInOut});
		     }
	    }
    }
	}
}