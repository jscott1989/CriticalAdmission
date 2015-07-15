package states.playstate;

import flixel.FlxG;

/**
 * MedicalBook shows the effect of interactables on holes
 */
 class MedicalBook extends UIElement {

    public function new(X:Float=0, Y:Float=0)  {
        super("MedicalBook", X, Y);
    }

    override function update() {
        // If we are dragging something, and are hovering over an empty hole
        // the book appearance should change to indicate if this is a good match
        var ps = PlayState.getInstance();
        if (ps.dragging != null) {
            if (ps.hoveringHole != null) {
                var hh:BodyHole = cast ps.hoveringHole;
                setDisplay(PatientInfo.getQOLForHole(ps.dragging.type, hh.type));
            }
        }
    }

    private function setDisplay(health:Int) {
        // TODO: Update appearance to show this health value
    }
 }