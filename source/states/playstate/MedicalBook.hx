package states.playstate;

import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * MedicalBook shows the effect of interactables on holes
 */
 class MedicalBook extends UIElement {

    private var text:FlxText;

    public function new()  {
        super("MedicalBook");

        text = new FlxText(x, y, width);
        text.alignment = "center";
        text.color = FlxColor.BLACK;
        text.size = 80;

        PlayState.getInstance().add(text);
    }

    override function update() {
        // If we are dragging something, and are hovering over an empty hole
        // the book appearance should change to indicate if this is a good match
        var ps = PlayState.getInstance();
        if (ps.dragging != null) {
            if (ps.hoveringHole != null) {
                text.x = x;
                text.y = y + (height / 2);
                var hh:BodyHole = cast ps.hoveringHole;
                setDisplay(PatientInfo.getQOLForHole(ps.dragging.type, hh.type));
                Utils.bringToFront(PlayState.getInstance().members, text, this);
                return;
            }
        }

        // Otherwise we're not dragging - hide the text
        text.x = -9999;
    }

    private function setDisplay(health:Int) {
        // TODO: Update appearance to show this health value
        if (health >= 0) {
            text.color = FlxColor.GREEN;
            text.text = "+" + Std.string(health) + "%";
        } else {
            text.color = FlxColor.RED;
            text.text = Std.string(health);
        }
    }
 }