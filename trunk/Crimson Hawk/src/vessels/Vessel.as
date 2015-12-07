package vessels  {
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Marcos Vazquez
	 */
	public class Vessel 
	{
		public var init_hp_:Number;
		public var hp_:Number;
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
		}
		
		public function destroyExplosion():void {
			explosion_mc_.stop();
			Misc.getStage().removeChild(explosion_mc_);
		}
		
	}

}