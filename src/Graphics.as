package  
{
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Lord Matrix
	 */
	public class Graphics extends Sprite
	{
		
		public function Graphics() 
		{
			
		}
		
		private static function startShape(color:uint, alpha:Number):Shape {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color, alpha);	
			return shape;
		}
		
		private static function endShape(shape:Shape):Shape {
			shape.graphics.endFill();
			Misc.getStage().addChild(shape);
			return shape;
		}
		
		public static function getCircle(x:uint, y:uint, radius:uint, color:uint = 0x000000, alpha:Number = 1):Shape {
			var shape:Shape = startShape(color, alpha);
			shape.graphics.drawCircle(x, y, radius);
			return endShape(shape);
		}
			
		public static function getEllipse(x:uint, y:uint, width:uint, height:uint, color:uint = 0x000000, alpha:Number = 1):Shape {
			var shape:Shape = startShape(color, alpha);
			shape.graphics.drawEllipse(x, y, width, height);
			return endShape(shape);
		}
		
		public static function getRectangle(x:uint, y:uint, width:uint, height:uint, color:uint = 0x000000, alpha:Number = 1):Shape {
			var shape:Shape = startShape(color, alpha);
			shape.graphics.drawRect(x, y, width, height);
			return endShape(shape);
		}
		
	}

}