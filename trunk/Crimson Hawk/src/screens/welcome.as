package screens 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Marcos Vazquez
	 * @brief A class that manages the welcome screen
	 */
	public class welcome extends MovieClip 
	{
		private var title:TextField;
		private var msg:TextField;
		private var backgr:Background;
		
		private var credits_:credits;
		
		public function welcome() {
			super();
			trace("welcome");
			initScreen();
			addEventListeners();
			addObjects();
		}
		
		private function initScreen():void {
			backgr = new Background();
			
			title = Misc.getTextField("The Crimson Hawk", Misc.getStageWidth() / 3.5, Misc.getStageHeight() / 5, 80, 0x990000)
			msg = Misc.getTextField("Click anywhere to continue", Misc.getStageWidth() / 2.5, Misc.getStageHeight() / 1.5, 30, 0xbbbbbb)
			
			credits_ = new credits();
		}
		
			
		private function addObjects():void { 	
			addChild(backgr);
			
			addChild(title);
			addChild(msg);
		}
		
		private function nextScreen():void { 
			killScreen();
			GameManager.getInstance().init();
			Misc.getMain().loadScreen(2);
		}
		
		private function removeObjects():void {
			removeChild(backgr);
			backgr = null;
			removeChild(title);
			title = null;
			removeChild(msg);
			msg = null;
			
			credits_.destroy();
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