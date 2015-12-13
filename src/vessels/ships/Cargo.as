package vessels.ships 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Marcos Vazquez
	 * 
	 * The starting ship
	 */
	public class Cargo extends Ship
	{
		
		public function Cargo() {
			
			var shipMC:MovieClip = new ship1();
			
			shipMC.x = 100;
			shipMC.y = Misc.getStage().stageHeight / 2;
			
			super(3, shipMC, 5, 0);
		}
		
	}

}