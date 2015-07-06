 package;

 import flixel.FlxG;
 import flixel.util.FlxRandom;

/**
 * Intercom that spouts "helpful" hints for the player
 */
 class Intercom extends UIElement {

    public function new(X:Float=0, Y:Float=0, state:PlayState)  {
        super(X, Y, "Intercom", state);
    }

    public function generateMessage(){
    	FlxG.log.add(FlxRandom.getObject(Announcements.generalAnnouncements));
    }
 }