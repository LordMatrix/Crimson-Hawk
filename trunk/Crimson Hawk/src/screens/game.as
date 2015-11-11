package screens 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
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
		
		private const MAX_ENEMIES:uint = 8;
		
		private var backgr:Background;
		
		private var points:uint;
		private var lives:uint;
		
		
		private var active_enemies:Vector.<Enemy>;
		private var idle_enemies:Vector.<Enemy>;
		
		private var ship:Ship;
		
		public function game() {
			super();
			trace("game");
			initScreen();
			addEventListeners();
			addObjects();
		}
		
		private function initScreen():void {
		
			backgr = new Background();
			
			active_enemies = new Vector.<Enemy>();
			idle_enemies = new Vector.<Enemy>();
		}
		
		private function addObjects():void { 
			addChild(backgr);
			
			
			//shot = Graphics.getCircle(0, 0, 10, 0x990000, 0.8);
			
			
			
			for (var i:uint=0; i < MAX_ENEMIES; i++) {
				
				var foeMC:MovieClip = new saucer1();
				foeMC.x = Misc.getStage().stageWidth + (100 * (i + 1));
				foeMC.y = Misc.random(10, Misc.getStage().stageHeight - 10);
				
				var foe:Enemy = new Enemy(1.0, foeMC, 0.005);
				active_enemies.push(foe);
				addChild(foe.mc_);
			}
			
			var shipMC:MovieClip = new ship1();
			
			shipMC.x = 100;
			shipMC.y = Misc.getStage().stageHeight / 2;
			
			ship = new Ship(10, shipMC);
			
			addChild(ship.mc_);
		}
		
		
		private function addEventListeners():void {
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		
		private function loop(e:Event):void {
			moveEnemies();
		}

		

		
		private function moveEnemies():void {
			
			var i:uint = 0;
			
			for each (var e:Enemy in active_enemies) {
				if (e.mc_.x > 0) {
					e.mc_.x -= 10;
					//caculate the probability an enemy will shoot
					if (Math.random() < e.fire_probability_)
						e.Shoot();
				} else  {
					e.mc_.x = Misc.getStage().stageWidth;
				}
				
				e.moveShots();
				
				if (ship.checkShotCollisions(e)) {
					e.mc_.x = -10;
					e.mc_.y = -10;
					
					idle_enemies.push(e);
					active_enemies.splice(i, 1);
				}
				
				i++;
			}
		}
		
		
		private function nextScreen():void { 
			killScreen();
			Misc.getMain().loadScreen(1);
		}
		
		private function killScreen():void {
			backgr.kill();
			removeEventListeners();
			removeObjects();
		}
		
		private function removeEventListeners():void {
			removeEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function removeObjects():void {
			
			removeChild(backgr);
			backgr = null;
		}
		
	}

}