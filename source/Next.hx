 package;

 import flixel.FlxG;

/**
 * The next button will allow to call for the next patient.
 */
 class Next extends Organ {

    public function new(X:Float=0, Y:Float=0, state:PlayState)  {
        super(X, Y, "Next", state);
    }

    public override function click() {
        state.nextPatient();
    }
 }