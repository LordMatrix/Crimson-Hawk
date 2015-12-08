package 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import vessels.enemies.Enemy;
	import vessels.enemies.HeadBoss;
	import vessels.enemies.Saucer1;
	import vessels.enemies.Saucer2;
	import vessels.enemies.Saucer3;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import vessels.ships.Ship;
	/**
	 * ...
	 * @author Marcos Vázquez
	 */
	public class GameManager extends MovieClip {
		
		
		
		public var level:XML;
		private var myLoader:URLLoader = new URLLoader();
		private var timers:Vector.<Timer>;
		
		
		/** Constants **/
		private const MAX_ENEMIES:uint = 8;
		public const LIFEBAR_WIDTH:uint = 40;
		
		
		// Vars **/
		public var MAX_SHOTS:uint = 4;
		
		public static var instance_:GameManager;
		
		public var points_:uint;
		public var lives_:int;
		
		public var active_enemies_:Vector.<Enemy>;
		public var idle_enemies_:Vector.<Enemy>;
		
		public var ship_:vessels.ships.Ship;
			
		public var enemy_shots_:Vector.<Shot>;
		
		public var fired_shots_:Vector.<Shot>;
		public var spare_shots_:Vector.<Shot>;

		public var waves_finished:Boolean = false;
		
		
		public static function getInstance():GameManager {
			if (!instance_) {
				instance_ = new GameManager();
				trace("Creating new GameManager");		
			}
		
			return instance_;
		}
		
		/** Methods **/
		public function GameManager() {
			super();
			trace("GameManager");
			
			timers = new Vector.<Timer>();
			parseLevel();
			
			init();
		}
		
		
		
		private function parseLevel():void {
			myLoader.load(new URLRequest("../Docs/lvl2.xml"));
			myLoader.addEventListener(Event.COMPLETE, processXML);
		}
		
		private function processXML(e:Event):void {
			level = new XML(e.target.data);
			//trace(level);
			
			var i:uint = 0;
			var last_time:uint = 0;
			
			for each (var wave:XML in level.time) {
				
				//trace(wave.@id);
				last_time = wave.@id;
				timers[i] = new Timer(wave.@id * 1000);
				
				timers[i].addEventListener(TimerEvent.TIMER, processWave(wave, i));
				timers[i].start();
			
				i++;
			}
			
			//Set the flag when all the enemy waves have passed
			timers[i] = new Timer(last_time * 1000);
			timers[i].addEventListener(TimerEvent.TIMER, setWavesFinished(i));
			timers[i].start();
		}
		
		
		private function setWavesFinished(i:uint):Function {
			return function(e:TimerEvent):void {
				waves_finished = true;
				timers[i].stop();
			}
		}
		
		private function processWave(wave:XML, i:uint):Function {
			return function(e:TimerEvent):void {
				//trace(wave);
				
				for each (var pack:XML in wave.enemies) {
					createEnemies(pack.type, pack.amount);
				}
				
				timers[i].stop();
			}
		}
		
		
		private function createEnemies(type:Number, amount:Number):void {
			
			for (var i:uint=0; i < amount; i++) {
				
				var x:uint = Misc.getStage().stageWidth + (100 * (i + 1));
				var y:uint = Misc.random(10, Misc.getStage().stageHeight - 10);
				var foe:Enemy;
				switch(type) {
					case 1:
						foe = new Saucer1(x, y, 3.0, 0.005);
						break;
					case 2:
						foe = new Saucer2(x, y, 1.0, 0.005);
						break;
					case 3:
						foe = new Saucer3(x, 20, 4.0, 0.005);
						break;
					case 10:
						foe = new HeadBoss(Misc.getStage().stageWidth + 50, Misc.getStage().stageHeight / 2, 50.0, 0.1);
						break;
					default:
						foe = new Saucer1(x, y, 3.0, 0.005);
						break;
				}
				
				active_enemies_.push(foe);
				Misc.getStage().addChild(foe.mc_);
			}
		}
		
		
		private function init():void {
				
			points_ = 1000;
			lives_ = 3;
			active_enemies_ = new Vector.<Enemy>();
			idle_enemies_ = new Vector.<Enemy>();
			enemy_shots_ = new Vector.<Shot>();
			fired_shots_ = new Vector.<Shot>();
			spare_shots_ = new Vector.<Shot>();
			
				
			createShots();
			
			
			var shipMC:MovieClip = new ship1();
			
			shipMC.x = 100;
			shipMC.y = Misc.getStage().stageHeight / 2;
			
			ship_ = new vessels.ships.Ship(3, shipMC);
			
			Misc.getStage().addChild(ship_.mc_);
		}
		
		
		public function createShots():void {
			
			mergeShots();
			
			for (var i:uint= spare_shots_.length; i < MAX_SHOTS; i++) {
				
				var shot_shape:Shape = Shapes.getEllipse(0, 0, 25, 8, 0x990000, 0.6);
				TweenMax.to(shot_shape, 0, { blurFilter: { blurX:10 }} );
				
				var shot:Shot = new Shot(shot_shape, 1, 30, 0);
				spare_shots_.push(shot);
				Misc.getStage().addChild(shot.shape_);
			}
		}
		
		
		public function mergeShots():void {
			//dump fired_shots into spare_shots
			for (var i:uint = 0; i < fired_shots_.length; i++) {
				Misc.getStage().removeChild(fired_shots_[0].shape_);
				spare_shots_.push(fired_shots_.shift());
			}
		}
		
		
		public function moveShots():void {
			
			var i:uint = 0;
			
			for each (var s:Shot in enemy_shots_) {
				if (s.shape_.x > 0 && s.shape_.y < Misc.getStage().stageHeight) {
					s.shape_.x += s.speedX_;
					s.shape_.y += s.speedY_;
					
					//Check ship collisions
					if (!ship_.exploding_ && s.shape_.hitTestObject(ship_.mc_)) {
						ship_.damage(1);
						Misc.getStage().removeChild(s.shape_);
						enemy_shots_.splice(i, 1);
					}
				} else  {
					Misc.getStage().removeChild(s.shape_);
					enemy_shots_.splice(i, 1);
				}
				
				i++;
			}
		}
		
		
		public function moveEnemies():void {
			
			var i:uint = 0;
			
			for each (var e:Enemy in active_enemies_) {
				TweenLite.to(e.mc_, 0, {removeTint:true});
				if (!e.exploding_ && !e.move()) {
					Misc.getStage().removeChild(e.mc_);
					Misc.getStage().removeChild(e.life_bar_);
					active_enemies_.splice(i, 1);
				}
				
				i++;
			}
		}
		
		//This can get either an enemy or a ship (or anything with a life bar)
		public function drawLifeBar(e:*):void {
			e.life_bar_.width = (LIFEBAR_WIDTH * e.hp_ ) / e.init_hp_;
					
			var resultColor:uint; 
			var g:uint = Math.round((0xFF / e.init_hp_) * e.hp_);
			var r:uint = 0xFF - g;
			var b:uint = 0xFF;

			resultColor = r<<16 | g<<8 | b;
			
			var trans:ColorTransform = e.life_bar_.transform.colorTransform;
			trans.color = resultColor;
			
			e.life_bar_.transform.colorTransform = trans;
		}
		
		
		
		//Checks enemy collisions with allied shots && ship
		public function checkCollisions():void {
			
			for (var i:uint = 0; i < active_enemies_.length; i++ ) {
				if (!active_enemies_[i].exploding_) {
					//Check enemy-shots collisions
					ship_.checkShotCollisions(active_enemies_[i]);
					//Check enemy-ship collisions
					if (!ship_.exploding_ && active_enemies_[i].mc_.hitTestObject(ship_.mc_)) {
						ship_.damage(2);
						active_enemies_[i].damage(2);
					}
				}
			}
		}
		
		
		public function reset():void {
			waves_finished = false;
			timers = new Vector.<Timer>();
			parseLevel();
			createShots();
		}
		
		
	}

}