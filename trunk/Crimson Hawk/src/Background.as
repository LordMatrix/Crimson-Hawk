package  
{
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * ...
	 * @author Lord Matrix
	 */
	public class Background extends MovieClip
	{
		private var fondoMC_1:MovieClip;
		private var fondoMC_2:MovieClip;
		private var fondo2MC_1:MovieClip;
		private var fondo2MC_2:MovieClip;
		
		
		public function Background() {
			super();
			trace("background");
			init();
			addEventListeners();
			addObjects();
		}
		
		
		private function init():void {
			fondoMC_1 = new bg1();
			fondoMC_2 = new bg1();
			fondo2MC_1 = new bg2();
			fondo2MC_2 = new bg2();
			
			fondoMC_2.x = fondoMC_1.width;
			
			TweenLite.to(fondo2MC_1, 0, { scaleX:2, scaleY:1 } );
			fondo2MC_2.x = fondo2MC_1.width;
			TweenLite.to(fondo2MC_2, 0, { scaleX:2, scaleY:1 } );
		}
		
		private function addObjects():void { 
			addChild(fondoMC_1);
			addChild(fondoMC_2);
			addChild(fondo2MC_1);
			addChild(fondo2MC_2);
		}
		
		private function removeObjects():void {
			removeChild(fondoMC_1);
			removeChild(fondoMC_2);
			fondoMC_1 = null;
			fondoMC_2 = null;
			removeChild(fondo2MC_1);
			removeChild(fondo2MC_2);
			fondo2MC_1 = null;
			fondo2MC_2 = null;
		}
		
		private function addEventListeners():void {
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function removeEventListeners():void {
			removeEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function checkXBorder(background:MovieClip, increment:int):int {
				
			var stage:Stage = Misc.getStage()
			var newX:int = background.x + increment;
			
			if (increment < 0) {
				if (background.x + background.width <= 0)
					newX = stage.stageWidth;
			} else {
				if (background.x  >= stage.stageWidth)
					newX = -stage.stageWidth;
			}
			
			return newX;
		}
		
		private function loop(e:Event):void {
			fondoMC_1.x = checkXBorder(fondoMC_1, -1);
			fondoMC_2.x = checkXBorder(fondoMC_2, -1);
			fondo2MC_1.x = checkXBorder(fondo2MC_1, -3);
			fondo2MC_2.x = checkXBorder(fondo2MC_2, -3);
		}
		
		public function kill():void {
			removeEventListeners();
			removeObjects();
		}
	}

}