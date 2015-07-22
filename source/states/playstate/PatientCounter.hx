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
        var x = (PlayState.getInstance().patientsToTreat - PlayState.getInstance().treatedPatients.length);
        if (x != number) {
            number = x;
            loadGraphic("assets/images/PatientCounter" + number + ".png");
        }
    }
 }