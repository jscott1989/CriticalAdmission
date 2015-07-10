package states.playstate;

 import flixel.FlxG;
 import flixel.util.FlxRandom;

/**
 * Counter for upcoming patients
 */
 class PatientCounter extends UIElement {

    private var number = 9;

    public function new(X:Float=0, Y:Float=0)  {
        super("PatientCounter", X, Y);
    }

    override function update() {
        if (PlayState.getInstance().incomingPatients.length != number) {
            number = PlayState.getInstance().incomingPatients.length;
            loadGraphic("assets/images/PatientCounter" + number + ".png");
        }
    }
 }