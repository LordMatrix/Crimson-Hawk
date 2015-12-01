package 
{
	import com.greensock.TweenLite;
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
		
		public var init_hp_:Number;
		public var hp_:Number;
		
		private var rising:Boolean = false;
		private var falling:Boolean = false;
		private var advancing:Boolean = false;
		private var retreating:Boolean = false;
		
		public var mc_:MovieClip;
		public var life_bar_:Shape;
		
		
		public function Ship(hp:Number, mc:MovieClip) {
			this.hp_ = hp;
			this.init_hp_ = hp;
			this.mc_ = mc;
			
			init();
			addEventListeners();
		}
		
		private function init():void {
			this.life_bar_ = Graphics.getRectangle(0, 0, 50, 30, 0x00cc00, 0.6);
			life_bar_.x = 20;
			life_bar_.y = 20;
			TweenMax.to(this.life_bar_, 0, { blurFilter: { blurX:3 }} );
			Misc.getStage().addChild(life_bar_);
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
			TweenLite.to(mc_, 0, {removeTint:true});
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
					if (GameManager.getInstance().fired_shots_.length < GameManager.getInstance().MAX_SHOTS) {
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
			var s:Shot = GameManager.getInstance().spare_shots_.pop();
						
			s.shape_.x = this.mc_.x + this.mc_.width/3;
			s.shape_.y = this.mc_.y;
			
			GameManager.getInstance().fired_shots_.push(s);
		}
		
		
		private function moveShots():void {
			
			var i:uint = 0;
			
			for each (var s:Shot in GameManager.getInstance().fired_shots_) {
				
				//Move them
				if (s.shape_.x < Misc.getStage().stageWidth) {
					s.shape_.x += s.speedX_;
				} else  {
					GameManager.getInstance().spare_shots_.push(s);
					GameManager.getInstance().fired_shots_.splice(i, 1);
				}
				
				i++;
			}
			
		}
		
		
		public function checkShotCollisions(item:*):Boolean {
			
			//Check collisions with enemies
			var i:uint = 0;
			var collided:Boolean = false;
			
			for each (var shot:Shot in GameManager.getInstance().fired_shots_) {
				if (shot.shape_.hitTestObject(item.mc_)) {
					collided = true;
					
					GameManager.getInstance().spare_shots_.push(shot);
					GameManager.getInstance().fired_shots_.splice(i, 1);
					
					//Place them away
					shot.shape_.x = -10;
					shot.shape_.y = -10;
					
					item.damage(shot.damage_)
				}
			
				i++;
			}
			
			return collided;
		}
		
		
		public function damage(amount:uint):void {
			hp_ -= amount;
			trace ("Ship HP is: " + hp_);
			GameManager.getInstance().drawLifeBar(this);
			
			//turn ship red
			TweenLite.to(mc_, 0, { tint:0xff0000 } );
			
			if (hp_ <= 0) {
				hp_ = init_hp_;
				GameManager.getInstance().lives_--;
				mc_.x = 100;
				mc_.y = Misc.getStage().stageHeight / 2;
			}
		}
		
	}

}