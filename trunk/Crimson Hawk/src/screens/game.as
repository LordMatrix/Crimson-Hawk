package screens 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Lord Matrix
	 */
	public class game extends MovieClip {
		
		private var backgr_:Background;
		private var manager_:GameManager;
		
		public function game() {
			super();
			trace("game");
			initScreen();
			addEventListeners();
			addObjects();
		}
		
		private function initScreen():void {
		
			backgr_ = new Background();
			manager_ = GameManager.getInstance();
		}
		
		private function addObjects():void { 
			addChild(backgr_);
		}
		
		
		private function addEventListeners():void {
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		
		private function loop(e:Event):void {
			manager_.moveEnemies();
			manager_.moveShots();
		}

		
		private function nextScreen():void { 
			killScreen();
			Misc.getMain().loadScreen(1);
		}
		
		private function killScreen():void {
			backgr_.kill();
			removeEventListeners();
			removeObjects();
		}
		
		private function removeEventListeners():void {
			removeEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function removeObjects():void {
			
			removeChild(backgr_);
			backgr_ = null;
		}
		
	}

}