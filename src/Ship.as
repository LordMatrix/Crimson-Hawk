package 
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Marcos Vazquez
	 */
	public class Ship {
		
		private const MAX_SHOTS:uint = 4;
		
		private var rising:Boolean = false;
		private var falling:Boolean = false;
		private var advancing:Boolean = false;
		private var retreating:Boolean = false;
		
		public var hp_:Number;
		public var mc_:MovieClip;
		
		private var fired_shots:Vector.<Shot>;
		private var spare_shots:Vector.<Shot>;
		
		
		public function Ship(hp:Number, mc:MovieClip) {
			this.hp_ = hp;
			this.mc_ = mc;
			
			init();
			addEventListeners();
		}
		
		private function init():void {
			fired_shots = new Vector.<Shot>();
			spare_shots = new Vector.<Shot>();
			
			//create shots, stop them from going on after x/y < max, reposition them on shooting
			for (var i:int; i < MAX_SHOTS; i++) {
				
				var shot_shape:Shape = Graphics.getEllipse(0, 0, 25, 8, 0x990000, 0.6);
				TweenMax.to(shot_shape, 0, { blurFilter: { blurX:10 }} );
				
				var shot:Shot = new Shot(shot_shape, 1, 30, 0);
				spare_shots.push(shot);
				Misc.getStage().addChild(shot.shape_);
			}
		}
		
		private function addEventListeners():void {
			Misc.getStage().addEventListener(Event.ENTER_FRAME, loop);
			Misc.getStage().addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Misc.getStage().addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		
		private function loop(e:Event):void {
			if (rising)
				this.mc_.y -= 5;
			else if (falling)
				this.mc_.y += 5;
			
			if (advancing)
				this.mc_.x += 5;
			else if (retreating)
				this.mc_.x -= 5;
				
			moveShots();
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case Keyboard.UP:
					rising = true;
					break;
				case Keyboard.DOWN:
					falling = true;
					break;
				case Keyboard.RIGHT:
					advancing = true;
					break;
				case Keyboard.LEFT:
					retreating = true;
					break;
				case Keyboard.SPACE:
					if (fired_shots.length < MAX_SHOTS) {
						Shoot();
					}
					break;
				default:
					trace(e.keyCode);
					break;
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case Keyboard.UP:
					rising = false;
					break;
				case Keyboard.DOWN:
					falling = false;
					break;
				case Keyboard.RIGHT:
					advancing = false;
					break;
				case Keyboard.LEFT:
					retreating = false;
					break;
				default:
					trace(e.keyCode);
					break;
			}
		}
		
		public function Shoot():void {
			var s:Shot = spare_shots.pop();
						
			s.shape_.x = this.mc_.x + this.mc_.width/3;
			s.shape_.y = this.mc_.y;
			
			fired_shots.push(s);
		}
		
		
		private function moveShots():void {
			
			var i:uint = 0;
			
			for each (var s:Shot in fired_shots) {
				
				//Move them
				if (s.shape_.x < Misc.getStage().stageWidth) {
					s.shape_.x += s.speedX_;
				} else  {
					spare_shots.push(s);
					fired_shots.splice(i, 1);
				}
				
				i++;
			}
			
		}
		
		
		public function checkShotCollisions(item:*):Boolean {
			
			//Check collisions with enemies
			var i:uint = 0;
			var collided:Boolean = false;
			
			for each (var shot:Shot in fired_shots) {
				if (shot.shape_.hitTestObject(item.mc_)) {
					collided = true;
					
					spare_shots.push(shot);
					fired_shots.splice(i, 1);
					
					//Place them away
					shot.shape_.x = -10;
					shot.shape_.y = -10;
				}
			
				i++;
			}
			
			return collided;
		}
		
	}

}