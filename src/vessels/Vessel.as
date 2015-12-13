package vessels  {
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Marcos Vazquez
	 * 
	 * This is the base class for all vessels, both enemies and allies
	 */
	public class Vessel 
	{
		public var init_hp_:Number;
		public var hp_:Number;
		
		public var speed_:int = 5;
		public var shield_:Number = 0;
		public var init_shield_:Number = 0;
		public var shield_recharge_:Number = 0;
		
		public var mc_:MovieClip;
		
		public var exploding_:Boolean = false;
		public var explosion_mc_:MovieClip;
		public var life_bar_:Shape;
		
		public function Vessel() {
			
		}
		
		public function Shoot():void {
		}
		
		public function move():Boolean {
			return false;
		}
		
		
		public function damage(amount:uint):void {
		}
		
		
		/**
		 * @brief	Replaces the ship's graphics by an explosion MovieClip and plays an explosion sound.
		 */
		public function explode():void {
			Misc.getStage().removeChild(mc_);
						
			explosion_mc_ = new explosion1();
			explosion_mc_.x = mc_.x;
			explosion_mc_.y = mc_.y;
			
			Misc.getStage().addChild(explosion_mc_);
			exploding_ = true;
			
			var explosion_mc:MovieClip = explosion_mc_;
			explosion_mc.addFrameScript(explosion_mc.totalFrames - 1, destroyExplosion);
			explosion_mc_.play();
			SoundManager.getInstance().playSFX(2);
		}
		
		
		public function destroyExplosion():void {
			explosion_mc_.stop();
			Misc.getStage().removeChild(explosion_mc_);
		}
		
		
		public function updateShieldGlow():void {
			TweenMax.to(this.mc_, 1, { glowFilter: { color:0x3333ff, alpha:0.8, blurX:45, blurY:45, strength:shield_, quality:1 }} );
		}
		
	
		//This can get either an enemy or a ship (or anything with a life bar)
		public function drawLifeBar():void {
			this.life_bar_.width = (GameManager.getInstance().LIFEBAR_WIDTH * this.hp_ ) / this.init_hp_;
					
			var resultColor:uint; 
			var g:uint = Math.round((0xFF / this.init_hp_) * this.hp_);
			var r:uint = 0xFF - g;
			var b:uint = 0xFF;

			resultColor = r<<16 | g<<8 | b;
			
			var trans:ColorTransform = this.life_bar_.transform.colorTransform;
			trans.color = resultColor;
			
			this.life_bar_.transform.colorTransform = trans;
		}
	}

}