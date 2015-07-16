package states.playstate;

 import flixel.text.FlxText;
 import flixel.util.FlxColor;

/**
 * The clipboard will show the stats of the current patient.
 */
 class Clipboard extends UIElement {

    private var name_text:FlxText;
    private var qol_text:FlxText;
    private var improvement_text:FlxText;

    public function new(X:Float=0, Y:Float=0)  {
        super("Clipboard", X, Y);

        name_text = new FlxText(0, 0, width); // x, y, width
        name_text.alignment = "center";
        name_text.size = 40;
        name_text.color = FlxColor.BLACK;

        qol_text = new FlxText(0, 0, width); // x, y, width
        qol_text.alignment = "center";
        qol_text.size = 40;
        qol_text.color = FlxColor.BLACK;

        improvement_text = new FlxText(0, 0, width); // x, y, width
        improvement_text.alignment = "center";
        improvement_text.size = 40;
        improvement_text.color = FlxColor.GREEN;

        updateText();
        PlayState.getInstance().add(name_text);
        PlayState.getInstance().add(qol_text);
        PlayState.getInstance().add(improvement_text);
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
            qol_text.text = Std.string(PlayState.getInstance().patient.info.getQOL()) + "%";
            name_text.text = PlayState.getInstance().patient.info.name;

            var improvement = PlayState.getInstance().patient.info.getQOL() - PlayState.getInstance().patient.info.initialQOL;

            improvement_text.text = Std.string(improvement) + "%";

            if (improvement > 0) {
                improvement_text.text = "+" + improvement_text.text;
            }

            if (improvement >= PlayState.getInstance().minimumImprovement) {
                improvement_text.color = FlxColor.GREEN;
            } else {
                improvement_text.color = FlxColor.RED;
            }
        }
    }

    public override function update() {
        if (PlayState.getInstance().patient != null) {
            updateText();
        }
        ensureInFront(name_text, 0, 160);
        ensureInFront(qol_text, 0, 220);
        ensureInFront(improvement_text, 0, 280);
        super.update();
    }
 }