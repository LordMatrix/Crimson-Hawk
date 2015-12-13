package screens 
{	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Marcos Vazquez
	 * @brief  This class manages the game over screen
	 */
	public class gameover extends MovieClip 
	{
		private var title:TextField;
		private var backgr:Background;
		
		/**
		 * @brief Creates screen and calls for listeners and objects
		 */
		public function gameover() {
			super();
			trace("gameover");
			initScreen();
			addEventListeners();
			addObjects();
		}
		
		
		private function initScreen():void {
			
			GameManager.getInstance().removeObjects();
			backgr = new Background();
			title = Misc.getTextField("GAME OVER", Misc.getStageWidth() / 3.5, Misc.getStageHeight() / 5, 80, 0x990000)
		}
		
			
		private function addObjects():void { 	
			addChild(backgr);
			addChild(title);
		}
		
		private function nextScreen():void { 
			killScreen();
			Misc.getMain().loadScreen(1);
		}
		
		private function removeObjects():void {
			removeChild(backgr);
			backgr = null;
			removeChild(title);
			title = null;
		}
		
		private function killScreen():void {
			backgr.kill();
			removeEventListeners();
			removeObjects();
		}
		
		private function addEventListeners():void {
			Misc.getStage().addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function removeEventListeners():void {
			Misc.getStage().removeEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void {
			nextScreen();
		}
	}
}