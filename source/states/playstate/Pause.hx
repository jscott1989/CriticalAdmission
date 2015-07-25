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
        if (Config.SUBTITLES_ON){
            FlxG.sound.play(AssetPaths.button__wav);
            PlayState.getInstance().pause();
        }
    }
 }