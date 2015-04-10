package cn.libins{
	 import flash.display.Sprite;
	 import flash.geom.Point;
	 import flash.utils.clearInterval;
	 import flash.utils.setInterval;
	 /*2D矩形工具 V01
	*作者：Libins
	*时间: 2009-9-24
	*/
	 public class RectSprite extends Sprite {
		                 //参数的设定： 宽度     顶图高度   圆柱体高度    上图颜色         左图颜色           右图颜色        时间间隔       速度
		 public function RectSprite (w:Number, h:Number, sheight:Number,upColor:Number,leftColor:Number,rightColor:Number,delay:Number,speed:Number = 5){
			//3个面的容器
		    var leftSP:Sprite  = new Sprite();
			var rightSP:Sprite = new Sprite();
			var upSP:Sprite    = new Sprite();
			
			addChild(rightSP);
			addChild(leftSP);
			addChild(upSP);
			
			//关键点
			var p1:Point       = new Point(0,-h);
			var p2:Point       = new Point(w,0);
			var p3:Point       = new Point(0,h);
			var p4:Point       = new Point(-w,0);
			//画上图
			upSP.graphics.beginFill(upColor);
			upSP.graphics.moveTo(p1.x,p1.y);
			upSP.graphics.lineTo(p2.x,p2.y);
			upSP.graphics.lineTo(p3.x,p3.y);
			upSP.graphics.lineTo(p4.x,p4.y);
			upSP.graphics.endFill();
			
			var currentH  :Number = 0;
			var myInterval:Number = setInterval(drawRL,delay);
			
			
			function drawRL(){
				currentH+=speed;
				//画左图
				drawLeft();
				//画右图
				drawRight();
				//移动上图
				moveUpSP();
				if(currentH>=sheight){
					clearInterval(myInterval);
			    }
		    }
			
			function drawLeft(){
				leftSP.graphics.clear();
				leftSP.graphics.beginFill(leftColor);
				leftSP.graphics.moveTo(p4.x,p4.y-currentH);
				leftSP.graphics.lineTo(p3.x,p3.y-currentH);
				leftSP.graphics.lineTo(p3.x,p3.y);
				leftSP.graphics.lineTo(p4.x,p4.y);
				leftSP.graphics.endFill();
			}
			
			
			function drawRight(){
				rightSP.graphics.clear();
				rightSP.graphics.beginFill(rightColor);
				rightSP.graphics.moveTo(p3.x,p3.y-currentH);
				rightSP.graphics.lineTo(p2.x,p2.y-currentH);
				rightSP.graphics.lineTo(p2.x,p2.y);
				rightSP.graphics.lineTo(p3.x,p3.y);
				rightSP.graphics.endFill();
			}
			
			
			function moveUpSP(){
				upSP.y -=speed;
			}
	     }
	}
}