package states.playstate;

import flixel.FlxG;
/**
 * The next button will allow to call for the next patient.
 */
 class Next extends UIElement {

    public function new()  {
        super("Next");
        this.label = "Next (Space)";
    }

    public override function interaction() {
    	PlayState.getInstance().soundManager.playSound(AssetPaths.button__wav);
		PlayState.getInstance().nextPatient();
    }

    public override function update(){
    	if (FlxG.keys.justReleased.SPACE) {
    		interaction();
		}
    }
 }