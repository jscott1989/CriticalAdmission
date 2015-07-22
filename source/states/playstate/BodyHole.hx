 package states.playstate;

 import flixel.FlxG;
 import flixel.FlxSprite;

/**
 * This is a hole on a body - right now the difference is just the background
 * but in future we may want things to act differently if they're on the UI
 * or in a body
 */
 class BodyHole extends Hole {

    // The type of hole
    public var type:String;
    private var patient:Patient;
    private var variableName:String;

    public function new(patient:Patient=null, X:Float=0, Y:Float=0, type:String="", interactable:Interactable=null, requiresFlip:Bool=false, hidden:Bool=false)  {
        this.type = type;
        variableName = type.substr(0,1).toLowerCase() + type.substr(1);
        this.patient = patient;
        var backgroundSprite = new FlxSprite();
        backgroundSprite.loadGraphic("assets/images/" + type +  "Hole.png");
        super(backgroundSprite, interactable, requiresFlip, false, X, Y);

        highlightSprite = new FlxSprite();
        highlightSprite.loadGraphic("assets/images/" + type +  "HoleHighlight.png");
        highlightSprite.alpha = 0.5;

        if (hidden) {
            hide();
        }
    }

    override public function addInteractable(interactable:Interactable, position:Bool = true) {
        Reflect.setField(patient.info, variableName, interactable.type);
        super.addInteractable(interactable, position);
    }

    override public function removeInteractable() {
        Reflect.setField(patient.info, variableName, null);
        super.removeInteractable();
    }
 }