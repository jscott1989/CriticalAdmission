package states.playstate;

/**
 * An organ which can be placed in a hole or left on the table
 */
 class Organ extends Interactable {

    public function new(type:String, canBeFlipped:Bool=false, X:Float=0, Y:Float=0)  {
        super(type, canBeFlipped, X, Y);
    }

    public override function update() {
        super.update();
    }

    public override function click() {
    	this.interaction();
    }
 }