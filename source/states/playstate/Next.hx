package states.playstate;

import flixel.FlxG;
/**
 * The next button will allow to call for the next patient.
 */
 class Next extends UIElement {

    public function new(X:Float=0, Y:Float=0)  {
        super("Next", X, Y);
    }

    public override function interaction() {
    	if (Config.SUBTITLES_ON){
	    	FlxG.sound.play(AssetPaths.button__wav);
			PlayState.getInstance().nextPatient();
		}
    }
 }