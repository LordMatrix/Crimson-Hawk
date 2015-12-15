package  {
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Marcos vazquez
	 * 
	 * A class that shows the game credits on the bottom-left corner of the screen
	 */
	public class credits {
		
		
		public var logo:Sprite;
		public var name:TextField;
		
		
		public function credits() {
			logo = new logoEsatMovieClip();
			logo.x = 20;
			logo.y = Misc.getStageHeight() - 200;
			name = Misc.getTextField("Marcos Vázquez Rey - ESAT 2015", 20, Misc.getStageHeight() - 50, 20, 0xFFFFFF);
			
			addObjects();
		}
		
		
		private function addObjects():void {
			Misc.getStage().addChild(logo);
			Misc.getStage().addChild(name);
		}
		
		
		private function removeObjects():void {
			Misc.getStage().removeChild(logo);
			Misc.getStage().removeChild(name);
		}
		
		
		public function destroy():void {
			removeObjects();
		}
	}

}