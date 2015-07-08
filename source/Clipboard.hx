 package;

 import flixel.FlxG;
 import flixel.text.FlxText;

/**
 * The clipboard will show the stats of the current patient.
 */
 class Clipboard extends UIElement {

    private var patient:Patient;
    private var name_text:FlxText;
    private var qol_text:FlxText;

    public function new(X:Float=0, Y:Float=0, patient:Patient)  {
        this.patient = patient;
        super(X, Y, "Clipboard");

        name_text = new FlxText(0, 0, width); // x, y, width
        name_text.alignment = "center";
        name_text.size = 40;
        name_text.color = 255;

        qol_text = new FlxText(0, 0, width); // x, y, width
        qol_text.alignment = "center";
        qol_text.size = 40;
        qol_text.color = 255;

        updateText();
        state.add(name_text);
        state.add(qol_text);
    }

    /**
     * Tidy up the text as it's not being managed by anyone else.
     */
    public override function destroy() {
        state.remove(name_text, true);
        state.remove(qol_text, true);
        name_text.destroy();
        qol_text.destroy();
        super.destroy();
    }

    private function ensureInFront(text:FlxText, xoffset:Float, yoffset:Float) {
        // TODO: Allow an offset
        text.x = x + xoffset;
        text.y = y + yoffset;


        Utils.bringToFront(state.members, text, this);

        // TODO: Adjust font size to match scale of clipboard
    }

    /**
     * Update the text with the QoL etc. from the patient
     */
    private function updateText() {
        qol_text.text = Std.string(patient.getQOL()) + "%";
        name_text.text = patient.name;
    }

    public override function update() {
        if (patient != null) {
            if (!patient.exists) {
                patient = null;
            } else {
                updateText();
            }
        }
        ensureInFront(name_text, 0, 200);
        ensureInFront(qol_text, 0, 300);
        super.update();
    }
 }