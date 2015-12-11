package 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	/**
	 * ...
	 * @author Marcos Vazquez
	 */
	public class SoundManager {
		
		private var music_:Vector.<Sound>; 
		private var sfx_:Vector.<Sound>;
		private var current_music_:SoundChannel;
		
		private static var instance_:SoundManager;
		
		private var sound_button_:Sprite;
		private static var muted_:Boolean;
		
		
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
			sfx_ = new <Sound>[new lazer_shot_sfx(), new lazer_impact_sfx(), new explosion1_sfx(), new cash()];
			current_music_ = new SoundChannel();
			
			sound_button_ = new sounds_on();
			sound_button_.x = Misc.getStageWidth() - sound_button_.width;
			sound_button_.y = 0;
			Misc.getStage().addChild(sound_button_);
			sound_button_.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownSoundButton);
			
			muted_ = false;
		}
		
		
		private function onMouseDownSoundButton(e:MouseEvent):void {
			trace("Toggling mute");
			toggleMute();
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
		
		
		public function toggleMute():void {
			Misc.getStage().removeChild(sound_button_);
			
			if (muted_) {
				SoundMixer.soundTransform = new SoundTransform(1);
				sound_button_ = new sounds_on();
			} else {
				SoundMixer.soundTransform = new SoundTransform(0);
				sound_button_ = new sounds_off();
			}
			
			sound_button_.x = Misc.getStageWidth() - sound_button_.width;
			sound_button_.y = 0;
			Misc.getStage().addChild(sound_button_);
			sound_button_.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownSoundButton);
			muted_ = !muted_;
		}
		
		
	}

}