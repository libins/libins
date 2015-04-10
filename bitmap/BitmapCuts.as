package cn.libins.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import __AS3__.vec.Vector;
	import gs.TweenLite;
    import fl.transitions.easing.*;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.ui.Mouse;
	
	/**
	 * v02,修改错误运动BUG，添加关闭鼠标事件
	 * @author libins
	 */
	public class BitmapCuts extends Sprite 
	{
		private var _oldBitmap:Bitmap;                  //对象的原始位图信息
		private var _wNum     :uint;                    //X坐标轴上的个数
		private var _hNum     :uint;                    //Y坐标轴上的个数
		private var _debug    :Boolean = false;         //这个是调试代码用的，可以无视
		private var _sprites  :Vector.<MovieClip>;      //装载单个切割后的容器
		private var _stage    :Stage;                   //舞台对象
		private var _disNum   :uint;                    //位图像素切割后的间距
		private var _initX    :Number;                  //初始X坐标
		private var _initY    :Number;                  //初始Y坐标
		private var _delayInt :Number;                  //延时的对象
		private var _disX     :Number;                  //运动的X值
		private var _disY     :Number;                  //运动的Y值
		private var _disZ     :Number;                  //运动的Z值
		private var _disA     :Number;                  //运动的Alpha值
		private var _currNum  :uint;                    //当前运动的索引值
		private var _total    :uint;                    //运动的总值
		private var _spContain:Sprite;                  //所有窃钩后的小图的父级容器
		private var _closeIcon:MovieClip;               //关闭按钮对象
		private var _moveType :String;                  //运动的类型
        private var _delayArr :Array;                   //延时的数组，保存所有的延时对象
		private var _moveTime :uint;                    //运动的时间
		private var _easeType :Function;                //缓冲的类型
		/*
		 * Param1 需要运动的对象
		 * Param2 横坐标个数
		 * Param3 纵坐标个数
		 * Param4 小框之间距离
		 * Param5 偏移的X坐标
		 * Param6 偏移的Y坐标
		 * Param7 偏移的Z坐标
		 * Param8 偏移的alpha坐标
		 */
		//构造函数，就是外界传递的一些初始化的信息，主要与切割，运动参数有关
		public function BitmapCuts($target:DisplayObject, $wNum:uint = 5, $hNum:uint = 5, $disNum:uint = 5, $disX:Number = 100,$disY:Number = 100,$disZ:Number = 100,$disA:Number = 0.5,$moveTime:uint  =2) {
			 if ($target is Bitmap) {
				 _oldBitmap = $target as Bitmap;
			 }else {
				 _oldBitmap = getBitmap($target);
			 }
			 _wNum    = $wNum;
			 _hNum    = $hNum;
			 _disNum  = $disNum;
			 _sprites =  new Vector.<MovieClip>();
	     	 _initX   = $target.x;
		     _initY   = $target.y;
			 _disX    = $disX;
			 _disY    = $disY;
			 _disZ    = $disZ;
			 _disA    = $disA;
			 _moveTime = $moveTime;
			 _total   = $wNum * $hNum;
			 $target.visible = false;
			 addEventListener(Event.ADDED_TO_STAGE, addToStage);
		}
		//添加到舞台，初始化一些基本的参数
		private function addToStage(event:Event):void {
		     removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			 _stage     = stage;
			 _spContain = new Sprite();
			 _delayArr  = [];
			 startCuts(_wNum, _hNum, _disNum);
		}
		//切割对象的函数，par1是宽度上的个数，par2是高度上的，par3是间距
		private function startCuts($wNum:uint, $hNum, $disNum):void {
		     var width :Number  = _oldBitmap.width / $wNum;                      //根据切割的个数，计算切割的宽度
			 var height:Number  = _oldBitmap.height / $hNum;                     //同理
			 var i     :uint    = 0;
			 while (i<$wNum) 
			 {
				 var j:uint     = 0;
				 while (j<$hNum) 
				 {
					 var bitmapData:BitmapData = new BitmapData(width, height,true,0xff334455);
					 bitmapData.copyPixels(_oldBitmap.bitmapData, new Rectangle(i * width, j * height, width, height),new Point(0,0));     //从原始位图上获取像素信息
					 var mc:MovieClip          =  makeSprite(bitmapData, width, height);
					 mc.x                      = _initX + (width + _disNum) * i;
					 mc.y                      = _initY +(height + _disNum) * j;
					 mc.name                   = i + "_" + j;
					 mc.i                      = i;
					 mc.j                      = j;
					 mc.moveed                 = false;
					 mc.orgX                   = mc.x;
					 mc.orgY                   = mc.y;
					 mc.orgZ                   = mc.z;
					 mc.addEventListener(MouseEvent.CLICK, spClick);
					 _spContain.addChild(mc);
					 j++; 
					 _sprites.push(mc);
				 }
				 i++;
			 }
			 addChild(_spContain);
		}
		//制作单个装有位图信息的MovieClip
		private function makeSprite($bitmapData:BitmapData,$width:Number,$height:Number):MovieClip {
			var mc :MovieClip = new MovieClip();
			 mc.graphics.clear();
			 mc.graphics.beginBitmapFill($bitmapData);
			 mc.graphics.drawRect(0, 0, $width, $height);
			 mc.graphics.endFill();
			 return  mc;
		}
		//这个是将我们需要操作的原始对象，转为位图数据
		private function getBitmap($target:DisplayObject):Bitmap {
		     var bitmapData:BitmapData = new BitmapData($target.width, $target.height, true);
			 bitmapData.draw($target);
			 return new Bitmap(bitmapData);
		}
		//鼠标事件，根据点击的次数，判断数运动的类型
		private function spClick(event:MouseEvent):void {
			var mc:MovieClip = event.currentTarget as MovieClip;
			_moveType    = (_moveType == "out")?"in":"out";
			setMoveEabled();
			removeDelay();
			moveSP(mc.i, mc.j);
			this.mouseChildren = this.mouseEnabled = false;
		}
		//运动单个的位图
		private function moveSP($i:uint, $j:uint) {
			var mc:MovieClip = _spContain.getChildByName($i + "_" + $j) as MovieClip;
			 if (mc.moveed) return;                                  // 这个地方比较关键，如果它当前正在移动的话，我们就必须关闭后面的代码，具体要结合checkPoint函数来分析
			 mc.moveed   = true;
			 _delayInt   = setTimeout(checkPoint, 50, $i, $j);       //这个就是一个延时的函数，让对象依次运动
			 _delayArr.push(_delayInt);                              //所有的延时对象装在数组里，方便删除，释放内存，避免出错，提高运行效率
			if(_moveType=="out"){                                    //放大的运动参数定义
			   mc.endX     = mc.x +_disX;
			   mc.endY     = mc.y +_disY;
			   mc.endZ     = mc.z +_disZ;
			   mc.endA     = _disA;
			   _easeType   = Elastic.easeOut;
			}else {                                                  //恢复的参数
			   mc.endX     = mc.orgX;
			   mc.endY     = mc.orgY;
			   mc.endZ     = mc.orgZ;
			   mc.endA     = 1;
			   _easeType   = Elastic.easeInOut;
			}
			 //TweenLite这个我就不用多说了
			 TweenLite.to(mc, _moveTime, { x:mc.endX, z:mc.endZ, y:mc.endY, alpha:mc.endA, ease:_easeType,onComplete:removeInterval } );
		}
		//清空所有的延时对象
		private function removeDelay():void {
			var num:uint = _delayArr.length;
			for (var i:int = 0; i < num; i++) 
			{
				clearTimeout(_delayArr[i]);
				_delayArr[i] = null;
			}
			_delayArr = [];
		}
		//这个是移动对象的依次运动完毕后的函数，主要用于所有动作结束后，我们需要执行的效果                           
		private function removeInterval():void {
			_currNum  ++;
			if (_currNum == _total) {
				 if (_moveType == "out") {
					 //如果是放大的运动类型，我们需要添加一个返回的标识
			         showCloseIcon();
				 }else {
					 //恢复类型的话，就删除上述的标识
					 hideIcon();
				 }
				 //开启鼠标事件，一个运动结束后，才开启，避免反复点击图片出现的错误【这里偶主要是怕麻烦，所以一刀切了，之前也有一个方法，但是运行多次，吃内存～】
				 this.mouseChildren = this.mouseEnabled = true;
			}
		}
		//运动开始前，必须允许他们可以执行，主要操作的属性对象为 moveed
		private function setMoveEabled():void {
		     var num:uint = _sprites.length;
			  _currNum    = 0;
			 for (var i:int = 0; i < num; i++) 
			 {
				 _sprites[i].moveed = false;
			 }
		}
		//这个是比较关键的代码，功能在于，是多个对象以中心点散射执行，我们只需记录一个执行点，然后依次对他执行4个方向对象的运动，注意操作的范围
		private function checkPoint($i:uint, $j:uint):void {
			 //left
			 if ($i > 0) moveSP($i - 1, $j);
			 //up
			 if ($j > 0) moveSP($i, $j - 1);
			 //right
			 if ($i < _wNum - 1) moveSP($i + 1, $j);
			 //down
			 if ($j < _hNum - 1)  moveSP($i , $j + 1);
		}
		//添加关闭标识
		private function showCloseIcon():void {
			 stage.addEventListener(MouseEvent.MOUSE_MOVE, checkHit);
		}
		//判断鼠标是否在我们的对象上
		private function checkHit(event:MouseEvent):void {
		     if (_spContain.hitTestPoint(stage.mouseX, stage.mouseY, true)) {
			     showIcon(event);	 
			 }else {
			     hideIcon();	 
			 }
		}
		//具体添加标识的代码，如果已存在，就让它实现鼠标追随效果
		private function showIcon(event:MouseEvent):void {
		     if (!_closeIcon) {
				 Mouse.hide();
			     _closeIcon = new CloseIcon();
				 _closeIcon.mouseChildren = _closeIcon.mouseEnabled = false;
				 addChild(_closeIcon);
			 }else {
				 _closeIcon.x = stage.mouseX;
			     _closeIcon.y = stage.mouseY;
				 //这个是让鼠标追随效果真实些,事件执行后,强制让舞台渲染一次舞台对象
				 event.updateAfterEvent();
			 }
		}
		//删除标识
		private function hideIcon():void {
		    if (_closeIcon) {
			    removeChild(_closeIcon);
				 _closeIcon = null;
				 Mouse.show();
				 stage.removeEventListener(MouseEvent.MOUSE_MOVE, checkHit);
			}
		}
		
	}
	
}