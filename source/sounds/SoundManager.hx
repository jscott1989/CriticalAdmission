package sounds;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.util.FlxRandom;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

import Config;
import states.playstate.PlayState;



/**
* SoundManager for generating sounds and subtitles
*/
class SoundManager {

	

	public var subtitle:FlxText;

	public var bingBong:FlxSound;

	public function new(){
		// FlxG.sound.playMusic(AssetPaths.ecg__wav, 1, true);
		bingBong = FlxG.sound.load(AssetPaths.tannoy1__wav);
	}

	private function playSound(id:String){
		// var sound:FlxSound = FlxG.sound.load(id);
		// sound.play();
	}

	private function createSubtitle(text:String){
		subtitle = new FlxText(0, 0, 0, text, Config.SUBTITLE_SIZE);
		subtitle.borderStyle = FlxText.BORDER_OUTLINE;
		subtitle.x = FlxG.width - subtitle.fieldWidth - Config.SUBTITLE_X_PADDING;
		subtitle.y = FlxG.height- Config.SUBTITLE_SIZE - Config.SUBTITLE_Y_PADDING;
		subtitle.borderSize = 3;
    	
    	PlayState.getInstance().add(subtitle);
    	new FlxTimer(Config.SUBTITLE_TIMEOUT, removeSubtitle, 1);
	}

	private function removeSubtitle(timer:FlxTimer){
		subtitle = FlxDestroyUtil.destroy(subtitle);
	}

	public function playRandomSoundMap(soundMap:Map<String, String>, prefixSound=null){
		
		bingBong.play();

		var keys = soundMap.keys();
		var i:Int;
		for(i in 0...Math.floor(Math.random()*Lambda.array(soundMap).length)-1){
			keys.next();
		}
		var key:String = keys.next();
		var value:String = soundMap.get(key);

		playSound(AssetPaths.tannoy1__wav);
		playSound(key);
		if (Config.SUBTITLES_ON){
			createSubtitle(value);
		}
	}

}