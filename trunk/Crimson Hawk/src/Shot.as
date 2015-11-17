package 
{
	import flash.display.Shader;
	import flash.display.Shape;
	/**
	 * A class representing several kinds of projectiles
	 * @author Marcos Vazquez
	 */
	public class Shot 
	{
		public var shape_:Shape;
		public var damage_:Number;
		public var speedX_:Number;
		public var speedY_:Number;
		
		//0=damages enemies, 1=damages player
		public var whose_:uint;
		
		public function Shot(shape:Shape, damage:Number, speedX:Number, speedY:Number, whose:uint=0) {
			this.shape_ = shape;
			this.damage_ = damage;
			this.speedX_ = speedX;
			this.speedY_ = speedY;
			this.whose_ = whose;
		}
		
	}

}