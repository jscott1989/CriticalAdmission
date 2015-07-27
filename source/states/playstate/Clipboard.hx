package states.playstate;

 import flixel.text.FlxText;
 import flixel.util.FlxColor;

/**
 * The clipboard will show the stats of the current patient.
 */
 class Clipboard extends UIElement {

    private var name_text:FlxText;
    private var qol_text:FlxText;

    public function new()  {
        super("Clipboard");

        name_text = new FlxText(0, 0, width); // x, y, width
        name_text.alignment = "center";
        name_text.size = 40;
        name_text.color = FlxColor.BLACK;

        qol_text = new FlxText(0, 0, width); // x, y, width
        qol_text.alignment = "center";
        qol_text.size = 40;
        qol_text.color = FlxColor.BLACK;

        updateText();
        PlayState.getInstance().add(name_text);
        PlayState.getInstance().add(qol_text);
    }

    /**
     * Tidy up the text as it's not being managed by anyone else.
     */
    public override function destroy() {
        PlayState.getInstance().remove(name_text, true);
        PlayState.getInstance().remove(qol_text, true);
        name_text.destroy();
        qol_text.destroy();
        super.destroy();
    }

    private function ensureInFront(text:FlxText, xoffset:Float, yoffset:Float) {
        // TODO: Allow an offset
        text.x = x + xoffset;
        text.y = y + yoffset;

        Utils.bringToFront(PlayState.getInstance().members, text, this);

        // TODO: Adjust font size to match scale of clipboard
    }

    /**
     * Update the text with the QoL etc. from the patient
     */
    private function updateText() {
        if (PlayState.getInstance().patient != null) {
            name_text.text = PlayState.getInstance().patient.info.name;

            var health = PlayState.getInstance().patient.info.getQOL();
            qol_text.text = Std.string(health) + "%";

            if (health >= PlayState.getInstance().minimumHealth) {
                qol_text.color = FlxColor.GREEN;
            } else {
                qol_text.color = FlxColor.RED;
            }
        }
    }

    public override function update() {
        if (PlayState.getInstance().patient != null) {
            updateText();
        }
        ensureInFront(name_text, 0, 160);
        ensureInFront(qol_text, 0, 220);
        super.update();
    }
 }