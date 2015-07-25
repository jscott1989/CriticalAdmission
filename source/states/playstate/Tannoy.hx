package states.playstate;

 import flixel.FlxG;
 import flixel.util.FlxRandom;

/**
 * Tannoy that spouts "helpful" hints for the player
 */
 class Tannoy extends UIElement {

    public function new()  {
        super("Tannoy");
    }

    public function startPlaying() {
        loadGraphic("assets/images/Tannoy-lines.png");
    }

    public function stopPlaying() {
        loadGraphic("assets/images/Tannoy.png");
    }
 }