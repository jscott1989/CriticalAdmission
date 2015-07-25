package states.playstate;

import flixel.FlxG;
/**
 * The next button will allow to call for the next patient.
 */
 class Next extends UIElement {

    public function new()  {
        super("Next");
    }

    public override function interaction() {
    	if (Config.SUBTITLES_ON){
	    	FlxG.sound.play(AssetPaths.button__wav);
			PlayState.getInstance().nextPatient();
		}
    }
 }