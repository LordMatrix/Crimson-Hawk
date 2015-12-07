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
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Lord Matrix
	 */
	public class game extends MovieClip {
		
		private var backgr_:Background;
		private var manager_:GameManager;
		private var points_txt_:TextField;
		private var lives_txt_:TextField;
		
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
			points_txt_ = Misc.getTextField("Points: "+String(manager_.points_), 0, 0, 20, 0x990000);
			lives_txt_ = Misc.getTextField("Lives: "+String(manager_.lives_), 0, 20, 20, 0x990000);
		}
		
		private function addObjects():void { 
			addChild(backgr_);
			addChild(points_txt_);
			addChild(lives_txt_);
		}
		
		
		private function addEventListeners():void {
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		
		private function loop(e:Event):void {
			manager_.moveEnemies();
			manager_.moveShots();
			manager_.checkCollisions();
			
			points_txt_.text = "Points: " + String(manager_.points_);
			lives_txt_.text = "Lives: " + String(manager_.lives_);
			
			//If the enemy waves are over and there are no enemies left, go to the next screen
			if (manager_.waves_finished && manager_.active_enemies_.length == 0) {
				trace("Ending screen");
				nextScreen();
			}
		}

		
		private function nextScreen():void { 
			killScreen();
			Misc.getMain().loadScreen(3);
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
			//Remove ship from scene
			Misc.getStage().removeChild(manager_.ship_.mc_);
		}
		
	}

}