package sounds;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxTimer;
import states.playstate.PlayState;
import states.playstate.Tannoy;

/**
* SoundManager for generating sounds and subtitles
*/
class SoundManager {

	public var subtitle:FlxText;

	public function new(){
		if (Config.MUSIC_ON){
			FlxG.sound.playMusic(AssetPaths.ambient__wav, 0.2, true);
		}
	}

	public function init(){
		if (Config.MUSIC_ON){
			var ecg:FlxSound = FlxG.sound.load(AssetPaths.ecg__wav, 0.5, true);
			ecg.play();

			var heart:FlxSound = FlxG.sound.load(AssetPaths.heartbeat__wav, 0.5, true);
			heart.play();
		}
	}

	private function createSubtitle(text:String){
		subtitle = new FlxText(0, 0, 0, text, Config.SUBTITLE_SIZE);
		subtitle.wordWrap = true;
		subtitle.borderStyle = FlxText.BORDER_OUTLINE;
		subtitle.fieldWidth = FlxG.width - Config.SUBTITLE_X_PADDING - Config.SUBTITLE_X_PADDING;
		subtitle.x = FlxG.width - subtitle.fieldWidth - Config.SUBTITLE_X_PADDING;
		subtitle.y = FlxG.height- subtitle.height - Config.SUBTITLE_Y_PADDING;
		subtitle.borderSize = 3;
    	
    	PlayState.getInstance().add(subtitle);
    	new FlxTimer(Config.SUBTITLE_TIMEOUT, removeSubtitle, 1);
	}

	private function removeSubtitle(timer:FlxTimer){
		subtitle = FlxDestroyUtil.destroy(subtitle);
	}

	public function playRandomSoundMap(soundMap:Map<String, String>, tannoy:Tannoy=null){
		var keys = soundMap.keys();
		var i:Int;
		for(i in 0...Math.floor(Math.random()*Lambda.array(soundMap).length)-1){
			keys.next();
		}
		var key:String = keys.next();
		var value:String = soundMap.get(key);


		var tannoySound:FlxSound = FlxG.sound.load(AssetPaths.tannoy1__wav);
		tannoySound.volume = 0.2;
		tannoy.startPlaying();
		tannoySound.onComplete = function(){
			var speech:FlxSound = FlxG.sound.load(key);
			speech.volume = 70;
			speech.onComplete = function() {
				tannoy.stopPlaying();
			};
			speech.play();
			tannoySound.onComplete = null;
		};
		tannoySound.play();

		if (Config.SUBTITLES_ON){
			createSubtitle(value);
		}
	}

}