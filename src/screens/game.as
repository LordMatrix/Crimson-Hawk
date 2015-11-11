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
			moveEnemies();
			manager_.moveShots();
		}

		
		private function moveEnemies():void {
			
			var i:uint = 0;
			
			for each (var e:Enemy in manager_.active_enemies_) {
				if (e.mc_.x > 0) {
					e.mc_.x -= 10;
					//caculate the probability an enemy will shoot
					if (Math.random() < e.fire_probability_)
						e.Shoot();
				} else  {
					e.mc_.x = Misc.getStage().stageWidth;
				}
				
				if (manager_.ship_.checkShotCollisions(e)) {
					
					//If the enemy is dead, remove him from scene
					if (e.hp_ <= 0) {
						e.mc_.x = -10;
						e.mc_.y = -10;

						manager_.idle_enemies_.push(e);
						manager_.active_enemies_.splice(i, 1);
						
						
					}
				}
				
				i++;
			}
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