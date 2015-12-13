package 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import vessels.enemies.AlienBoss;
	import vessels.enemies.BattleBoss;
	import vessels.enemies.DarkBoss;
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
	 * 
	 * A singleton class that holds data and methods needed throughout the program
	 * or by various classes.
	 */
	public class GameManager extends MovieClip {
		
		
		
		public var level:XML;
		private var myLoader:URLLoader = new URLLoader();
		private var timers:Vector.<Timer>;
		
		
		/** Constants **/
		private const MAX_ENEMIES:uint = 8;
		
		
		
		// Vars **/
		public var MAX_SHOTS:uint;
		public var LIFEBAR_WIDTH:uint = 40;
		
		public static var instance_:GameManager;
		
		public var points_:uint;
		public var lives_:int;
		
		public var active_enemies_:Vector.<Enemy>;
		public var idle_enemies_:Vector.<Enemy>;
		
		public var ship_:vessels.ships.Ship;
			
		public var enemy_shots_:Vector.<Shot>;
		
		public var fired_shots_:Vector.<Shot>;
		public var spare_shots_:Vector.<Shot>;

		public var waves_finished:Boolean;
		
		public var current_level_:uint = 1;
		
		public var num_missiles_:uint = 0;
		public var missiles_damage_:uint = 5;
		public var missiles_:Vector.<Shot>;
		
		public var num_lazers_:uint = 0;
		public var lazers_damage_:uint = 5;
		public var lazers_:Vector.<Shot>;
		
		

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
		}
		
		
		/**
		 * Loads an xml file called levelX.xml and calls
		 * processXML for parsing it.
		 * @param	level	The level number to read from.
		 */
		private function parseLevel(level:uint):void {
			myLoader.load(new URLRequest("../Docs/lvl"+((level-1)%4 + 1)+".xml"));
			myLoader.addEventListener(Event.COMPLETE, processXML);
		}
		
		
		/**
		 * @brief	Processes an xml file
		 * Creates timed events for every wave specified in the file.
		 * 
		 * @param	e	a Complete event
		 */
		private function processXML(e:Event):void {
			level = new XML(e.target.data);
			
			var i:uint = 0;
			var last_time:uint = 0;
			
			for each (var wave:XML in level.time) {
				
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
		
		
		/**
		 * @brief	Processes a wave of enemies
		 * 
		 * @param	wave	an XML document specifying <type> and <amount>
		 * @param	i		the index of the timers vector this wave is set to spawn
		 * @return	void
		 */
		private function processWave(wave:XML, i:uint):Function {
			return function(e:TimerEvent):void {
				//trace(wave);
				
				for each (var pack:XML in wave.enemies) {
					createEnemies(pack.type, pack.amount);
				}
				
				timers[i].stop();
			}
		}
		
		
		/**
		 * @brief	Creates a wave of enemies
		 * 
		 * @param	type	The type of enemies
		 * @param	amount	The amount of enemies to spawn
		 */
		private function createEnemies(type:Number, amount:Number):void {
			
			//calculate difficulty increase based on current level (stage number)
			var diff:Number = current_level_ * 0.25;
			//the number of boss enemies does not increase with levels
			var is_boss:Boolean = (type % 10 == 0);
			//all the other enemies do
			var amount_increase:Number;
			if (is_boss) amount_increase = 1;
			else amount_increase = diff;
			
			for (var i:uint=0; i < Math.round(amount*amount_increase); i++) {
				
				var x:uint = Misc.getStage().stageWidth + (100 * (i + 1));
				var y:uint = Misc.random(10, Misc.getStage().stageHeight - 10);
				var foe:Enemy;
				
				switch(type) {
					case 1:
						foe = new Saucer1(x, y, 3.0*diff, 0.005*diff);
						break;
					case 2:
						foe = new Saucer2(x, y, 1.0*diff, 0.005*diff);
						break;
					case 3:
						foe = new Saucer3(x, 20, 4.0*diff, 0.005*diff);
						break;
					case 10:
						foe = new HeadBoss(Misc.getStage().stageWidth + 50, Misc.getStage().stageHeight / 2, 50.0*diff, 0.05*diff);
						break;
					case 20:
						foe = new DarkBoss(Misc.getStage().stageWidth + 50, Misc.getStage().stageHeight / 2, 50.0*diff, 0.05*diff);
						break;
					case 30:
						foe = new BattleBoss(Misc.getStage().stageWidth + 50, Misc.getStage().stageHeight / 2, 50.0*diff, 0.05*diff);
						break;
					case 40:
						foe = new AlienBoss(Misc.getStage().stageWidth + 50, Misc.getStage().stageHeight / 2, 50.0*diff, 0.05*diff);
						break;
					default:
						foe = new Saucer1(x, y, 3.0*diff, 0.005*diff);
						break;
				}
				
				active_enemies_.push(foe);
				Misc.getStage().addChild(foe.mc_);
			}
		}
		
		
		/**
		 * @brief Initializes a GameManager's vectors, creates a ship and parses the current level's xml
		 */
		public function init():void {
			
			points_ = 10000;
			lives_ = 10;
			MAX_SHOTS = 4;
			waves_finished = false;
			active_enemies_ = new Vector.<Enemy>();
			idle_enemies_ = new Vector.<Enemy>();
			enemy_shots_ = new Vector.<Shot>();
			fired_shots_ = new Vector.<Shot>();
			spare_shots_ = new Vector.<Shot>();
			missiles_ = new Vector.<Shot>();
			lazers_ = new Vector.<Shot>;
			timers = new Vector.<Timer>();
				
			
			createShots();
			
			ship_ = new vessels.ships.Cargo();
			
			Misc.getStage().addChild(ship_.mc_);
			
			parseLevel(current_level_);
		}
		
		
		/// @brief	Prepares variables for a new level restart
		public function resetLevel():void {
			waves_finished = false;
			timers = new Vector.<Timer>();
			parseLevel(current_level_);
			createShots();
		}
		
		
		public function removeObjects():void {
			var i:int;
			
			//remove enemies and their life bars
			for (i = 0; i < active_enemies_.length; i++) {
				if (active_enemies_[i].mc_.stage) {
					Misc.getStage().removeChild(active_enemies_[i].mc_);
					Misc.getStage().removeChild(active_enemies_[i].life_bar_);
				}
			}
			//delete active_enemies_;
			
			//remove enemy shots
			for (i = 0; i < enemy_shots_.length; i++) {
				if (enemy_shots_[i].shape_.stage) {
					Misc.getStage().removeChild(enemy_shots_[i].shape_);
				}
			}
			//delete enemy_shots_;
			
			//delete ship_;
		}
		
		
		/**
		 * @brief	Creates player shots and adds it to the pool
		 */
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
		
		
		/**
		 * @brief	Dumps fired_shots into spare_shots
		 */
		public function mergeShots():void {
			for (var i:uint = 0; i < fired_shots_.length; i++) {
				Misc.getStage().removeChild(fired_shots_[0].shape_);
				spare_shots_.push(fired_shots_.shift());
			}
		}
		
		
		/**
		 * @brief	Moves the player's shots and checks for collisions
		 */
		public function moveShots():void {
			
			var i:uint = 0;
			
			for each (var s:Shot in enemy_shots_) {
				if (s.shape_.x > 0 && s.shape_.y < Misc.getStage().stageHeight) {
					s.shape_.x += s.speedX_;
					s.shape_.y += s.speedY_;
					
					//Check ship collisions
					if (!ship_.exploding_ && s.shape_.hitTestObject(ship_.mc_)) {
						trace("SHIP HIT BY SHOT");
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
		
		
		/**
		 * @brief Moves all the enemies in active_enemies_. Removes them from stage if they go off-screen.
		 */
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
		
		
		/**
		 * @brief	Checks enemy collisions with allied shots && ship
		 */
		public function checkCollisions():void {
			
			for (var i:uint = 0; i < active_enemies_.length; i++ ) {
				if (!active_enemies_[i].exploding_) {
					//Check enemy-shots collisions
					ship_.checkShotCollisions(active_enemies_[i]);
					ship_.checkMissileCollisions(active_enemies_[i]);
					//Check enemy-ship collisions
					if (!ship_.exploding_ && active_enemies_[i].mc_.hitTestObject(ship_.mc_)) {
						trace("SHIP HIT BY ENEMY");
						ship_.damage(2);
						active_enemies_[i].damage(2);
					}
				}
			}
		}
		
	}

}