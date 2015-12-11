//SoundAS gestiona sonidos (github)
//texture packer para crear spritesheets
package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import screens.game;
	import screens.gameover;
	import screens.select;
	import screens.shop;
	import screens.welcome;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.greensock.*;
	
	/**
	 * ...
	 * @author Marcos Vazquez
	 */
	public class Main extends Sprite 
	{
		
		private var miMC:MovieClip = new MovieClip();
		private var welcomeScreen:welcome;
		private var gameScreen:game;
		private var shopScreen:shop;
		private var gameOverScreen:gameover;
		
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			trace("Main");
			Misc.setMain(this);
			loadScreen(1);
		}
		
		public function loadScreen(num:uint):void {
			switch(num) {
				case 1:
					SoundManager.getInstance().playMusic(0);
					welcomeScreen = new welcome();
					addChild(welcomeScreen);
					break;
				case 2:
					var level:uint = GameManager.getInstance().current_level_;
					SoundManager.getInstance().playMusic((level - 1) % 4 + 1);
					GameManager.getInstance().current_level_++;
					gameScreen = new game();
					addChild(gameScreen);
					break;
				case 3:
					SoundManager.getInstance().playMusic(0);
					shopScreen = new shop();
					addChild(shopScreen);
					break;
				case 4:
					SoundManager.getInstance().playMusicOnce(5);
					gameOverScreen = new gameover();
					addChild(gameOverScreen);
					break;
				default:
					trace ("Screen unknown");
			}
		}
		
	}
	
}