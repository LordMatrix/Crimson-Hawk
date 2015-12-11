package 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;

	/**
	 * ...
	 * @author Marcos Vazquez
	 */
	public class SoundManager {
		
		private var music_:Vector.<Sound>; 
		private var sfx_:Vector.<Sound>;
		private var current_music_:SoundChannel;
		
		private static var instance_:SoundManager;
		
		
		public static function getInstance():SoundManager {
			if (!instance_) {
				instance_ = new SoundManager();
				trace("Creating new SoundManager");		
			}
		
			return instance_;
		}
		
		/** Methods **/
		public function SoundManager() {
			super();
			trace("SoundManager");
			
			music_ = new <Sound>[new gynoug_opening(), new gynoug1(), new gynoug2(), new gynoug3(), new gynoug4(), new gynoug_gameover()];
			sfx_ = new <Sound>[new lazer_shot_sfx(), new lazer_impact_sfx(), new explosion1_sfx()];
			current_music_ = new SoundChannel();
		}
		
		
		public function playMusic(id:uint):void {
			if (current_music_)
				stopMusic();
			current_music_ = music_[id].play(0, 999);
		}
		
		
		public function stopMusic():void {
			current_music_.stop();
		}
		
		public function playMusicOnce(id:uint):void {
			if (current_music_)
				stopMusic();
			current_music_ = music_[id].play();
		}
		
		
		public function playSFX(id:uint):void {
			sfx_[id].play();
		}
		
	}

}