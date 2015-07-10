package states.playstate;

 import flixel.FlxG;
 import flixel.util.FlxRandom;

/**
 * Tannoy that spouts "helpful" hints for the player
 */
 class Tannoy extends UIElement {

    public function new(X:Float=0, Y:Float=0)  {
        super("Tannoy", X, Y);
    }

    public function generateMessage(){
    	FlxG.log.add(FlxRandom.getObject(Announcements.generalAnnouncements));
    }
 }