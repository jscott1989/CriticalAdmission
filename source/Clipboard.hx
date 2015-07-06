 package;

 import flixel.FlxG;
 import flixel.text.FlxText;

/**
 * The clipboard will show the stats of the current patient.
 */
 class Clipboard extends UIElement {

    private var _patient:Patient;
    private var _name_text:FlxText;

    public function new(X:Float=0, Y:Float=0, patient:Patient, pState:PlayState)  {
        _patient = patient;
        super(X, Y, "Clipboard", pState);

        _name_text = new FlxText(0, 0, width); // x, y, width
        _name_text.alignment = "center";
        _name_text.size = 20;
        _name_text.color = 255;

        updateText();
        state.add(_name_text);
    }

    /**
     * Tidy up the text as it's not being managed by anyone else.
     */
    public override function destroy() {
        state.remove(_name_text, true);
        _name_text.destroy();
        super.destroy();
    }

    private function ensureInFront(text:FlxText) {
        // TODO: Allow an offset
        text.x = x;
        text.y = y + 200;

        // Always ensure that the text is in front of us in the state
        var spriteIndex = state.members.indexOf(this);
        var textIndex = state.members.indexOf(text);

        if (spriteIndex > textIndex) {
            // Move text to spriteIndex
            state.members[textIndex] = state.members[spriteIndex - 1];
            state.members[spriteIndex - 1] = this;
            state.members[spriteIndex] = text;
        }

        // TODO: Adjust font size to match scale of clipboard
    }

    /**
     * Update the text with the QoL etc. from the patient
     */
    private function updateText() {
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
        ensureInFront(_name_text);
        super.update();
    }
 }