package states.playstate;

/**
 * An organ which can be placed in a hole or left on the table
 */
 class Organ extends Interactable {

    public function new(type:String)  {
        super(type, 0, 0);
    }

    public override function update() {
        super.update();
    }

    public override function click() {
    	this.interaction();
    }

    // public override function asArray():Array<{}> {
    //     return ["Organ", [type]];
    // }
 }