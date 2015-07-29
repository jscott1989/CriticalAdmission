package sounds;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxDestroyUtil;
import haxe.Timer;
import sounds.speech.Receptionist;
import states.playstate.PlayState;
import states.playstate.Tannoy;

/**
* SoundManager for generating sounds and subtitles
*/
class SoundManager {

	public var subtitle:FlxText;

	var tannoySound:FlxSound;
	var speech:FlxSound;
	var heart:FlxSound;

	private static var instance:SoundManager;
  
    public static inline function getInstance() {
        if (instance == null) {
            instance = new SoundManager();
        }
        return instance;
    }

	public function startAmbient() {
		if (Config.SOUND_ON){
			FlxG.sound.playMusic(AssetPaths.ambient__wav, 0.2, true);
			heart = FlxG.sound.load(AssetPaths.heartbeat__wav, 0.5, true);
			heart.play();
		}
	}

	public function stopAmbient() {
		FlxG.sound.music.stop();
		heart.stop();
	}

	public function playECG() {
		if (Config.SOUND_ON) {
			var ecg:FlxSound = FlxG.sound.load(AssetPaths.ecg__wav, 0.5, false);
			ecg.play();
		}
	}

	public function playSuccess() {
		if (Config.SOUND_ON) {
			FlxG.log.add("SUCCESS");
			var success:FlxSound = FlxG.sound.load(AssetPaths.success__wav, 1, false);
			success.play();
		}
	}

	public function playFailure() {
		if (Config.SOUND_ON) {
			var failure:FlxSound = FlxG.sound.load(AssetPaths.failure__wav, 1, false);
			failure.play();
		}
	}

	var flatline:FlxSound;

	public function playFlatline() {
		if (Config.SOUND_ON) {
			flatline = FlxG.sound.load(AssetPaths.flatline__wav, 0.5, true);
			flatline.play();
		}
	}

	public function stopFlatline() {
		if (flatline != null) {
			flatline.stop();
		}
	}

	private function createSubtitle(text:String){
		subtitle = new FlxText(0, 0, 0, text, Config.SUBTITLE_SIZE);
		subtitle.font = "assets/fonts/Cabin-Regular.ttf";
		subtitle.wordWrap = true;
		subtitle.borderStyle = FlxText.BORDER_OUTLINE;
		subtitle.fieldWidth = FlxG.width - Config.SUBTITLE_X_PADDING - Config.SUBTITLE_X_PADDING;
		subtitle.x = FlxG.width - subtitle.fieldWidth - Config.SUBTITLE_X_PADDING;
		subtitle.y = FlxG.height- subtitle.height - Config.SUBTITLE_Y_PADDING;
		subtitle.borderSize = 3;
    	
    	PlayState.getInstance().add(subtitle);
    	Utils.bringToFront(PlayState.getInstance().members, subtitle);
	}

	private function removeSubtitle(){
		subtitle = FlxDestroyUtil.destroy(subtitle);
	}

	private function play(tannoy:Tannoy, key:String, value:String) {
		if (tannoy != null) {
			if (tannoySound != null) {
				// Destroy it
				tannoySound.stop();
			}

			if (speech != null) {
				// Destroy it
				speech.stop();
			}

			if (subtitle != null) {
				// Destroy it
				removeSubtitle();
			}

			if (Config.SOUND_ON) {
				tannoySound = FlxG.sound.load(AssetPaths.tannoy1__wav);
				tannoySound.volume = 0.2;
				tannoy.startPlaying();
				tannoySound.onComplete = function(){
					speech = FlxG.sound.load(key);
					speech.volume = 70;
					speech.onComplete = function() {
						tannoy.stopPlaying();
						removeSubtitle();
					};
					if (Config.SUBTITLES_ON){
						createSubtitle(value);
					}
					speech.play();
					tannoySound.onComplete = null;
				};
				tannoySound.play();
			}
		}
	}

	private var possibleFiller = Utils.randomArray(Receptionist.FILLER_KEYS);

	public function playFiller(tannoy:Tannoy) {
		if (possibleFiller.length == 0) {
            possibleFiller = Utils.randomArray(Receptionist.FILLER_KEYS);
        }
        var key = possibleFiller.pop();
        var value:String = Receptionist.FILLER.get(key);
        play(tannoy, key, value);
	}

	private var possibleVIPIncoming = Utils.randomArray(Receptionist.VIP_INCOMING_KEYS);

	public function playVIPIncoming(tannoy:Tannoy) {
		if (possibleVIPIncoming.length == 0) {
            possibleVIPIncoming = Utils.randomArray(Receptionist.VIP_INCOMING_KEYS);
        }
        var key = possibleVIPIncoming.pop();
        var value:String = Receptionist.VIP_INCOMING.get(key);
        play(tannoy, key, value);
	}


	private var CUT_SKIN:Array<String> = [
		AssetPaths.CutSkin_1__wav,
		AssetPaths.CutSkin_2__wav,
		AssetPaths.CutSkin_3__wav,
		AssetPaths.CutSkin_4__wav,
	];

	private var possibleCutSkin:Array<String> = [];

	public function playCutSkin() {
		if (possibleCutSkin.length == 0) {
            possibleCutSkin = Utils.randomArray(CUT_SKIN);
        }
        var key = possibleCutSkin.pop();
        playSound(key);
	}

	public function playSound(sound:String) {
		if (Config.SOUND_ON) {
			var s = FlxG.sound.load(sound);
			s.play();
		}
	}
}