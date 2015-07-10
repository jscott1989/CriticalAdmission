package sounds;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.util.FlxRandom;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

import states.playstate.PlayState;



/**
* SoundManager for generating sounds and subtitles
*/
class SoundManager {

	private var SUBTITLE_TIMEOUT:Float = 3;

	private var subtitle:FlxText;

	public function new(){}

	private function playSound(id:String){
		var sound:FlxSound = FlxG.sound.load(id);
		sound.play();
	}

	private function createSubtitle(text:String){
		subtitle = new FlxText(50, 50, 0, text, 60);
		subtitle.borderStyle = FlxText.BORDER_OUTLINE;
		subtitle.borderSize = 3;
    	PlayState.getInstance().add(subtitle);
    	new FlxTimer(SUBTITLE_TIMEOUT, removeSubtitle, 1);
	}

	private function removeSubtitle(timer:FlxTimer){
		subtitle = FlxDestroyUtil.destroy(subtitle);
	}

	public function playRandomSoundMap(soundMap:Map<String, String>){
		
		var keys = soundMap.keys();
		var i:Int;
		for(i in 0...Math.floor(Math.random()*Lambda.array(soundMap).length)-1){
			keys.next();
		}
		var key:String = keys.next();
		var value:String = soundMap.get(key);

		FlxG.log.add(key+", "+value);

		playSound(key);
		createSubtitle(value);
	}

}