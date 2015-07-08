 package;

 import flixel.FlxG;
 import flixel.text.FlxText;

/**
 * The clipboard will show the stats of the current patient.
 */
 class Clipboard extends UIElement {

    private var _patient:Patient;
    private var _name_text:FlxText;
    private var _qol_text:FlxText;

    public function new(X:Float=0, Y:Float=0, patient:Patient)  {
        _patient = patient;
        super(X, Y, "Clipboard");

        _name_text = new FlxText(0, 0, width); // x, y, width
        _name_text.alignment = "center";
        _name_text.size = 40;
        _name_text.color = 255;

        _qol_text = new FlxText(0, 0, width); // x, y, width
        _qol_text.alignment = "center";
        _qol_text.size = 40;
        _qol_text.color = 255;

        updateText();
        state.add(_name_text);
        state.add(_qol_text);
    }

    /**
     * Tidy up the text as it's not being managed by anyone else.
     */
    public override function destroy() {
        state.remove(_name_text, true);
        state.remove(_qol_text, true);
        _name_text.destroy();
        _qol_text.destroy();
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
        _qol_text.text = Std.string(_patient.getQOL()) + "%";
        _name_text.text = _patient.name;
    }

    public override function update() {
        if (_patient != null) {
            if (!_patient.exists) {
                _patient = null;
            } else {
                updateText();
            }
        }
        ensureInFront(_name_text, 0, 200);
        ensureInFront(_qol_text, 0, 300);
        super.update();
    }
 }