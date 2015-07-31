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
            ecg.onComplete = function() {
                ecg = FlxDestroyUtil.destroy(ecg);
            }
            ecg.play();
		}
	}

	public function playSuccess() {
		if (Config.SOUND_ON) {
			var success:FlxSound = FlxG.sound.load(AssetPaths.success__wav, 1, false);
            success.onComplete = function() {
                success = FlxDestroyUtil.destroy(success);
            };
            success.play();
		}
	}

	public function playFailure() {
		if (Config.SOUND_ON) {
			var failure:FlxSound = FlxG.sound.load(AssetPaths.failure__wav, 1, false);
            failure.onComplete = function() {
                failure = FlxDestroyUtil.destroy(failure);
            }
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
            flatline = FlxDestroyUtil.destroy(flatline);
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
                tannoySound = FlxDestroyUtil.destroy(tannoySound);
			}

			if (speech != null) {
				// Destroy it
				speech.stop();
                speech = FlxDestroyUtil.destroy(speech);
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
                        speech = FlxDestroyUtil.destroy(speech);
					};
					if (Config.SUBTITLES_ON){
						createSubtitle(value);
					}
					speech.play();
					tannoySound.onComplete = null;
                    tannoySound = FlxDestroyUtil.destroy(tannoySound);
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


	private var possibleVIPLeaving = Utils.randomArray(Receptionist.VIP_LEAVING_KEYS);

	public function playVIPLeaving(tannoy:Tannoy) {
		if (possibleVIPLeaving.length == 0) {
            possibleVIPLeaving = Utils.randomArray(Receptionist.VIP_LEAVING_KEYS);
        }
        var key = possibleVIPLeaving.pop();
        var value:String = Receptionist.VIP_LEAVING.get(key);
        play(tannoy, key, value);
	}

	private var possibleVIPHappy = Utils.randomArray(Receptionist.VIP_HAPPY_KEYS);

	public function playVIPHappy(tannoy:Tannoy) {
		if (possibleVIPHappy.length == 0) {
            possibleVIPHappy = Utils.randomArray(Receptionist.VIP_HAPPY_KEYS);
        }
        var key = possibleVIPHappy.pop();
        var value:String = Receptionist.VIP_HAPPY.get(key);
        play(tannoy, key, value);
	}

	private var possibleVIPUnhappy = Utils.randomArray(Receptionist.VIP_UNHAPPY_KEYS);

	public function playVIPUnhappy(tannoy:Tannoy) {
		if (possibleVIPUnhappy.length == 0) {
            possibleVIPUnhappy = Utils.randomArray(Receptionist.VIP_UNHAPPY_KEYS);
        }
        var key = possibleVIPUnhappy.pop();
        var value:String = Receptionist.VIP_UNHAPPY.get(key);
        play(tannoy, key, value);
	}

	public function playVIPDead(tannoy:Tannoy) {
        play(tannoy, AssetPaths.VIP10__wav, "The VIP did not survive the operation");
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

	public function playGoodPerformance(tannoy:Tannoy) {
		play(tannoy, AssetPaths.Performance_good__wav, "Good job doctor! He said he's never felt better!");
	}

	public function playBadPerformance(tannoy:Tannoy) {
		play(tannoy, AssetPaths.Performance_bad__wav, "Doctor, you're supposed to be making these people better!");
	}

	private var possibleHighReputation = Utils.randomArray(Receptionist.HIGH_REPUTATION_KEYS);

	public function playHighReputation(tannoy:Tannoy) {
		if (possibleHighReputation.length == 0) {
            possibleHighReputation = Utils.randomArray(Receptionist.HIGH_REPUTATION_KEYS);
        }
        var key = possibleHighReputation.pop();
        var value:String = Receptionist.HIGH_REPUTATION.get(key);
        play(tannoy, key, value);
	}

	private var possibleLowReputation = Utils.randomArray(Receptionist.LOW_REPUTATION_KEYS);

	public function playLowReputation(tannoy:Tannoy) {
		if (possibleLowReputation.length == 0) {
            possibleLowReputation = Utils.randomArray(Receptionist.LOW_REPUTATION_KEYS);
        }
        var key = possibleLowReputation.pop();
        var value:String = Receptionist.LOW_REPUTATION.get(key);
        play(tannoy, key, value);
	}
}