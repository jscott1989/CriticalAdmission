package states;

import flixel.FlxG;
import flixel.FlxState;
import states.playstate.PlayState;

using flixel.util.FlxSpriteUtil;

/**
 * This is needed so the previous playstate can clean up its resources before a new one is created.
 */
class PassingToPlayState extends FlxState {

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void {
        PlayState.clearInstance();
        FlxG.switchState(PlayState.getInstance());
    }
}