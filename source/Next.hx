 package;

 import flixel.FlxG;

/**
 * The next button will allow to call for the next patient.
 */
 class Next extends UIElement {

    public function new(X:Float=0, Y:Float=0)  {
        super(X, Y, "Next");
    }

    public override function interaction() {
    	if(PlayState.getInstance().isActive()){
    		PlayState.getInstance().nextPatient();	
    	}
    }
 }