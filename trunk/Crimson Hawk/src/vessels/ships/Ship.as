package vessels.ships 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.ui.Keyboard;
	import vessels.enemies.Enemy;
	import vessels.Vessel;
	
	/**
	 * ...
	 * @author Marcos Vazquez
	 * 
	 * This is the base class for all the ships the player can control
	 */
	public class Ship extends Vessel {
		
		private var rising:Boolean = false;
		private var falling:Boolean = false;
		private var advancing:Boolean = false;
		private var retreating:Boolean = false;
		
		private var invulnerable_threshold_:uint = 70; 
		private var invulnerable_:uint = invulnerable_threshold_;
		
		private var manager_:GameManager;
		
		
		public function Ship(hp:Number, mc:MovieClip, speed:int, shield:Number) {
			this.hp_ = hp;
			this.init_hp_ = hp;
			this.mc_ = mc;
			this.speed_ = speed;
			this.shield_ = shield;
			this.init_shield_ = shield;
			
			manager_ = GameManager.getInstance();
			
			init();
			addEventListeners();
		}
		
		private function init():void {
			drawLifeBar();
		}
		
		
		override public function drawLifeBar():void {
			
			this.life_bar_ = Shapes.getRectangle(0, 0, 50, 30, 0x00cc00, 0.6);
			life_bar_.x = 20;
			life_bar_.y = 20;
			TweenMax.to(this.life_bar_, 0, { blurFilter: { blurX:3 }} );
			Misc.getStage().addChild(life_bar_);
			
			this.life_bar_.width = this.hp_ * 15;
					
			var resultColor:uint; 
			var g:uint = Math.round((0xFF / this.init_hp_) * this.hp_);
			var r:uint = 0xFF - g;
			var b:uint = 0x00;

			resultColor = r<<16 | g<<8 | b;
			
			var trans:ColorTransform = this.life_bar_.transform.colorTransform;
			trans.color = resultColor;
			
			this.life_bar_.transform.colorTransform = trans;
		}
		
		
		public function removeLifeBar():void {
			Misc.getStage().removeChild(life_bar_);
		}
		
		
		public function addEventListeners():void {
			Misc.getStage().addEventListener(Event.ENTER_FRAME, loop);
			Misc.getStage().addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Misc.getStage().addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		
		public function removeEventListeners():void {
			Misc.getStage().removeEventListener(Event.ENTER_FRAME, loop);
			Misc.getStage().removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Misc.getStage().removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			//set all movement flags to false when deleting event listeners
			rising = false;
			falling = false;
			advancing = false;
			retreating = false;
		}
		
		
		private function loop(e:Event):void {
			
			if (rising)
				this.mc_.y -= speed_;
			else if (falling)
				this.mc_.y += speed_;
			
			if (advancing)
				this.mc_.x += speed_;
			else if (retreating)
				this.mc_.x -= speed_;
				
			moveShots();
			moveMissiles();
			DissipateLazers();
			TweenLite.to(mc_, 0, { removeTint:true } );
			
			//change alpha intermitently if the ship is in invulnerable state
			if (invulnerable_ < invulnerable_threshold_) {
				if (invulnerable_ % 2 == 0) mc_.alpha = 0;
				else mc_.alpha = 1;
					
				invulnerable_++;
			}
			
			//Restore shield over time
			if (shield_ < init_shield_) {
				shield_ += shield_recharge_ / 2000;
				updateShieldGlow();
			}
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
					if (!exploding_ && manager_.fired_shots_.length < manager_.MAX_SHOTS) {
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
		
		override public function Shoot():void {
			var s:Shot = manager_.spare_shots_.pop();
						
			s.shape_.x = this.mc_.x + this.mc_.width/3;
			s.shape_.y = this.mc_.y;
			
			manager_.fired_shots_.push(s);
			SoundManager.getInstance().playSFX(0);
		}
		
		
		private function moveShots():void {
			
			var i:uint = 0;
			
			for each (var s:Shot in manager_.fired_shots_) {
				
				//Move them
				if (s.shape_.x < Misc.getStage().stageWidth) {
					s.shape_.x += s.speedX_;
				} else  {
					manager_.spare_shots_.push(s);
					manager_.fired_shots_.splice(i, 1);
				}
				
				i++;
			}
			
		}
		
		
		/**
		 * @brief Moves the missiles towards their assigned targets. Deletes them if they move off-screen.
		 */
		private function moveMissiles():void {
			
			var i:uint = 0;
			var max_speed:int = 15;
			var min_speed:int = -15;
			
			
			for each (var s:Shot in manager_.missiles_) {
				
				
				//Get the coordinates of the missile target
				if (manager_.active_enemies_.length > 0 && s.target_ && s.target_.mc_.stage) {
					var fx:int = s.target_.mc_.x;
					var fy:int = s.target_.mc_.y;
					
					//Correct trajectory by altering x&y speeds
					if (fx > s.shape_.x && manager_.missiles_[i].speedX_ < max_speed)
						manager_.missiles_[i].speedX_++;
					else if (fx < s.shape_.x && manager_.missiles_[i].speedX_ > min_speed)
						manager_.missiles_[i].speedX_--;
						
					if (fy > s.shape_.y && manager_.missiles_[i].speedY_ < max_speed )
						manager_.missiles_[i].speedY_++;
					else if (fy < s.shape_.y && manager_.missiles_[i].speedY_ > min_speed)
						manager_.missiles_[i].speedY_--;
				}
				
				
				//Move them
				if (s.shape_.x < Misc.getStage().stageWidth && s.shape_.y < Misc.getStage().stageHeight && s.shape_.x > 0 && s.shape_.y > 0) {
					s.shape_.x += s.speedX_;
					s.shape_.y += s.speedY_;
				} else  {
					Misc.getStage().removeChild(manager_.missiles_[i].shape_);
					manager_.missiles_.splice(i, 1);
				}
				
				i++;
			}
			
		}
		
		
		/// @brief gradually applies a blur effect to the lazer beams until they fade out.
		private function DissipateLazers():void {
			
			for (var i:uint = 0; i < manager_.lazers_.length; i++) {
				manager_.lazers_[i].blur_ += 0.5;
				TweenMax.to(manager_.lazers_[i].shape_, 0, { blurFilter: { blurY: manager_.lazers_[i].blur_ }} );
				
				if (manager_.lazers_[i].blur_ > 20) {
					Misc.getStage().removeChild(manager_.lazers_[i].shape_);
					manager_.lazers_.splice(i, 1);
				}
			}
			
		}
		
		
		/**
		 * Checks if any of the ship's laser beams has collided with the given object.
		 * @param	item	The collidable object to check against.
		 * @return	Boolean	whether it has collided or not
		 */
		public function checkShotCollisions(item:*):Boolean {
			
			//Check collisions with enemies
			var i:uint = 0;
			var collided:Boolean = false;
			
			for each (var shot:Shot in manager_.fired_shots_) {
				if (shot.shape_.hitTestObject(item.mc_)) {
					collided = true;
					
					manager_.spare_shots_.push(shot);
					manager_.fired_shots_.splice(i, 1);
					
					//Place them away
					shot.shape_.x = -10;
					shot.shape_.y = -10;
					
					item.damage(shot.damage_)
				}
			
				i++;
			}
			
			return collided;
		}
		
		
		/**
		 * Checks if any of the ship's missiles has collided with the given object.
		 * @param	item	The collidable object to check against.
		 * @return	Boolean	whether it has collided or not
		 */
		public function checkMissileCollisions(item:*):Boolean {
			
			//Check collisions with enemies
			var collided:Boolean = false;
			var broken_missiles:Vector.<Shot> = new Vector.<Shot>;
			
			for (var i:uint=0; i < manager_.missiles_.length; i++ ) {
				
				var missile:Shot = manager_.missiles_[i];
				
				if (missile.shape_.hitTestObject(item.mc_)) {
					collided = true;
					
					//Destroy missile
					if (manager_.missiles_[i] && manager_.missiles_[i].shape_.stage)
					Misc.getStage().removeChild(manager_.missiles_[i].shape_);
					delete manager_.missiles_[i];
					manager_.missiles_.splice(i, 1);
					
					item.damage(missile.damage_)
				}
			
				i++;
			}
			
			
			return collided;
		}
		
		
		/**
		 * @brief 	Damages the ship
		 * Reduces the shield, if any.
		 * Substracts from the ship's hp_ otherwise.
		 * Makes the ship explode if hp<=0
		 * 
		 * @param	amount How many points of damage are inflicted
		 */
		override public function damage(amount:uint):void {
			
			if (invulnerable_ >= invulnerable_threshold_) {
				if (shield_ >= amount) {
					shield_ -= amount;
					updateShieldGlow();
					trace ("Ship SHIELD is: " + shield_);
				} else {	
					shield_ = 0;
					updateShieldGlow();
					hp_ -= (amount - shield_);
					trace ("Ship HP is: " + hp_);
					this.removeLifeBar();
					this.drawLifeBar();
					//turn ship red
					TweenLite.to(mc_, 0, { tint:0xff0000 } );
				
					if (hp_ <= 0) {
						explode();
						hp_ = init_hp_;
						shield_ = init_shield_;
						updateShieldGlow();
						manager_.lives_--;
						mc_.x = 100;
						mc_.y = Misc.getStage().stageHeight / 2;
					}
				}
			}
		}
		
		
		/**
		 * @brief	Removes the explosion movieclip from scene
		 */
		override public function destroyExplosion():void {
			explosion_mc_.stop();
			Misc.getStage().removeChild(explosion_mc_);
			if (manager_.lives_ > 0) {
				Misc.getStage().addChild(mc_);
				invulnerable_ = 0;
			} else {
				removeEventListeners();
				Misc.getStage().removeChild(life_bar_);
			}
			exploding_ = false;
		}
		
		
		/**
		 * @brief	Restores the ship's stats
		 */
		public function restore():void {
			hp_ = init_hp_;
			shield_ = init_shield_;
			updateShieldGlow();
			this.removeLifeBar();
			this.drawLifeBar();
		}
		
		
		/**
		 * @brief	Launches a missile
		 * @param	target_index	The index of the enemy to be locked on, in GameManager.active_enemies_
		 */
		public function LaunchMissile(target_index:uint):void {
			trace("LAUNCHING MISSILE");
			var shot_shape:Shape = Shapes.getCircle(0, 0, 10, 0xFF5555, 0.6);
			TweenMax.to(shot_shape, 0, { blurFilter: { blurY:10 }} );
			
			shot_shape.x = this.mc_.x - this.mc_.width/3;
			shot_shape.y = this.mc_.y;
						
			var s:Shot = new Shot(shot_shape, GameManager.getInstance().missiles_damage_, 1, 1, 0);
			GameManager.getInstance().missiles_.push(s);
			Misc.getStage().addChild(s.shape_);
			
			//Assign a target
			s.target_ = GameManager.getInstance().active_enemies_[target_index];;
		}
		
		
		/**
		 * @brief	Fires a lazer beam that damages a target instantly
		 * @param	target	The vessel to attack
		 */
		public function FireLazer(target:Vessel):void {
			trace ("FIRE DA LAZER!");
			
			var lz_shape:Shape = new Shape();
			lz_shape.graphics.lineStyle(1, 0xFF0000, 0.85);
			lz_shape.graphics.moveTo(this.mc_.x, this.mc_.y);
			lz_shape.graphics.lineTo(target.mc_.x, target.mc_.y);
			
			var lz:Shot = new Shot(lz_shape, manager_.lazers_damage_, 0, 0, 0);

			GameManager.getInstance().lazers_.push(lz);
			Misc.getStage().addChild(lz.shape_);
			
			//Insta-damage target
			target.damage(manager_.lazers_damage_);
		}

	}

}