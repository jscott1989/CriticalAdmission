 package;

/**
 * An organ which can be placed in a hole or left on the table
 */
 class Organ extends Interactable {

    public function new(X:Float=0, Y:Float=0, type:String, pState:PlayState)  {
        super(X, Y, type, pState);
    }

    public override function update() {
        super.update();
    }

    public override function click() {
    	this.interaction();
    }
 }