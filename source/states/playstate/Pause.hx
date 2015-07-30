package states.playstate;

import flixel.FlxG;
/**
 * The pause button will allow to pause the game.
 */
 class Pause extends UIElement {

    public function new()  {
        super("Pause");
    }

    public override function interaction() {
        if (Config.SOUND_ON){
            PlayState.getInstance().soundManager.playSound(AssetPaths.button__wav);
        }
        PlayState.getInstance().pause();
    }

    public override function update(){
    	if (FlxG.keys.justReleased.ESCAPE) {
    		interaction();
		}
    }
 }