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
	 * @author Marcos Vazquez
	 * 
	 * @brief This class manages the main ingame screen
	 * 
	 */
	public class game extends MovieClip {
		
		private var backgr_:Background;
		private var manager_:GameManager;
		private var points_txt_:TextField;
		private var lives_txt_:TextField;
		private var level_txt_:TextField;
		
		public function game() {
			super();
			trace("game");
			initScreen();
			addEventListeners();
			addObjects();
		}
		
		/**
		 * @brief Initializes stage objects, points and lives counters
		 */
		private function initScreen():void {
		
			backgr_ = new Background();
			manager_ = GameManager.getInstance();
			points_txt_ = Misc.getTextField("Points: "+String(manager_.points_), 0, 0, 20, 0x990000);
			lives_txt_ = Misc.getTextField("Lives: " + String(manager_.lives_), 0, 20, 20, 0x990000);
			level_txt_ = Misc.getTextField("Level " + String(manager_.current_level_ - 1 ), 600, 0, 30, 0xFFFFFF);
		}
		
		
		/**
		 * @brief Adds game objects to stage
		 */
		private function addObjects():void { 
			addChild(backgr_);
			addChild(points_txt_);
			addChild(lives_txt_);
			addChild(level_txt_);
		}
		
		
		/**
		 * @brief Creates event listeners for the ingame screen
		 */
		private function addEventListeners():void {
			addEventListener(Event.ENTER_FRAME, loop);
			manager_.ship_.removeEventListeners();
			manager_.ship_.addEventListeners();
		}
		
		
		/**
		 * @brief Updates game status
		 * @param	e TimerEvent
		 */
		private function loop(e:Event):void {
			manager_.moveEnemies();
			manager_.moveShots();
			manager_.checkCollisions();
			
			points_txt_.text = "Points: " + String(manager_.points_);
			lives_txt_.text = "Lives: " + String(manager_.lives_);
			level_txt_.text = "Level: " + String(manager_.current_level_ - 1);
			
			//If there are no lives left, go to game over screen
			if (manager_.lives_ <= 0) {
				gameOver();
			//If the enemy waves are over and there are no enemies left, go to the next screen
			} else if (manager_.waves_finished && manager_.active_enemies_.length == 0) {
				trace("Ending screen");
				nextScreen();
			}
		}

		
		/**
		 * @brief Removes stage elements and loads shop screen
		 */
		private function nextScreen():void { 
			killScreen();
			Misc.getMain().loadScreen(3);
		}
		
		
		/**
		 * @brief Removes stage elements and loads game over screen
		 */
		private function gameOver():void {
			killScreen();
			Misc.getMain().loadScreen(4);
		}
		
		
		/**
		 * @brief Removes stage elements, event listeners and this screen ship's listeners
		 */
		private function killScreen():void {
			backgr_.kill();
			removeEventListeners();
			manager_.ship_.removeEventListeners();
			removeObjects();
		}
		
		
		private function removeEventListeners():void {
			removeEventListener(Event.ENTER_FRAME, loop);
		}
		
		
		private function removeObjects():void {
			
			removeChild(backgr_);
			backgr_ = null;
			//Remove ship from scene
			if (manager_.ship_.mc_.stage)
				Misc.getStage().removeChild(manager_.ship_.mc_);
		}
		
	}

}