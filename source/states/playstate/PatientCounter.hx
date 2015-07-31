package states.playstate;

 import flixel.FlxG;
 import flixel.util.FlxRandom;

/**
 * Counter for upcoming patients
 */
 class PatientCounter extends UIElement {

    private var number = 9;

    public function new()  {
        super("PatientCounter");
    }

    override function update() {
        var x = (PlayState.getInstance().patientsToTreat - PlayState.getInstance().treatedPatients);
        if (x < 0) { 
            x = 0;
        } else if (x > 9) {
            x = 9;
        }
        if (x != number) {
            number = x;
            loadGraphic("assets/images/PatientCounter" + number + ".png");
        }
    }
 }