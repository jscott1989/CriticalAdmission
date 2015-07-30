package states.playstate;

 import flixel.text.FlxText;
 import flixel.util.FlxColor;

/**
 * The clipboard will show the stats of the current patient.
 */
 class Clipboard extends UIElement {

    private var name_text:FlxText;
    private var injury_text:FlxText;
    private var qol_text:FlxText;

    private var isVIP:Bool = false;

    public function new()  {
        super("Clipboard");

        name_text = new FlxText(0, 0, 260); // x, y, width
        name_text.font = "assets/fonts/Cabin-Bold.ttf";
        name_text.alignment = "center";
        name_text.size = 40;
        name_text.color = FlxColor.BLACK;

        injury_text = new FlxText(0, 0, 260); // x, y, width
        injury_text.font = "assets/fonts/Cabin-Regular.ttf";
        injury_text.alignment = "center";
        injury_text.size = 40;
        injury_text.color = FlxColor.BLACK;

        qol_text = new FlxText(0, 0, 260); // x, y, width
        qol_text.font = "assets/fonts/Cabin-Regular.ttf";
        qol_text.alignment = "center";
        qol_text.size = 40;
        qol_text.color = FlxColor.BLACK;

        updateText();
        PlayState.getInstance().add(name_text);
        PlayState.getInstance().add(injury_text);
        PlayState.getInstance().add(qol_text);
    }

    /**
     * Tidy up the text as it's not being managed by anyone else.
     */
    public override function destroy() {
        PlayState.getInstance().remove(name_text, true);
        PlayState.getInstance().remove(injury_text, true);
        PlayState.getInstance().remove(qol_text, true);
        name_text.destroy();
        injury_text.destroy();
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
        var patient = PlayState.getInstance().patient;
        if (patient != null) {
            name_text.text = PlayState.getInstance().patient.info.name;
            injury_text.text = PlayState.getInstance().patient.info.injury;

            var health = PlayState.getInstance().patient.info.getQOL();
            qol_text.text = Std.string(health) + "% (";

            var improvement = health - PlayState.REQUIRED_HEALTH;

            if (patient.info.isVIP) {
                var improvement = health - PlayState.REQUIRED_VIP_HEALTH;
            }

            if (improvement > 0) {
                qol_text.text += "+" + improvement + ")";
            } else {
                qol_text.text += improvement + ")";
            }

            if ((!patient.info.isVIP && health >= PlayState.REQUIRED_HEALTH) || (patient.info.isVIP && health >= PlayState.REQUIRED_VIP_HEALTH)) {
                qol_text.color = FlxColor.GREEN;
            } else {
                qol_text.color = FlxColor.RED;
            }

            if (PlayState.getInstance().patient.info.isVIP && !isVIP)  {
                isVIP = true;
                loadGraphic("assets/images/VIPClipboard.png");
            } else if (!PlayState.getInstance().patient.info.isVIP && isVIP) {
                isVIP = false;
                loadGraphic("assets/images/Clipboard.png");
            }
        }
    }

    public override function update() {
        if (PlayState.getInstance().patient != null) {
            updateText();
        }
        ensureInFront(name_text, 130, 160);
        ensureInFront(injury_text, 130, 170 + name_text.height);
        ensureInFront(qol_text, 130, 400);
        super.update();
    }
 }