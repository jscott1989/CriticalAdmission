 package states.playstate;

 import flixel.FlxSprite;

/**
 * This is a hole on a body - right now the difference is just the background
 * but in future we may want things to act differently if they're on the UI
 * or in a body
 */
 class BodyHole extends Hole {

    public static var HEALTH_VALUES = [
        "Heart" => [
            "Heart" => 100
        ],
        "Brain" => [
            "Brain" => 100
        ],
        "Lung" => [
            "Lung" => 100
        ],
        "Guts" => [
            "Guts" => 100
        ],
        "Elbow" => [
            "LeftElbow" => 100,
            "RightElbow" => 100
        ],
        "Knee" => [
            "LeftKnee" => 100,
            "RightKnee" => 100
        ]
    ];

    // The type of hole
    private var type:String;

    /**
     * Get the QOL of this hole (how appropriate the contents are)
     */
    public function getQOL():Int {
        if (interactable == null) {
            return 0;
        }

        var h = HEALTH_VALUES.get(interactable.type);

        if (h == null) {
            h = new Map<String, Int>();
        }

        if (h.get(type) != null) {
            return h.get(type);
        }

        return 0;
    }

    public function new(X:Float=0, Y:Float=0, type:String="", interactable:Interactable=null, requiresFlip:Bool=false, hidden:Bool=false)  {
        this.type = type;
        var backgroundSprite = new FlxSprite();
        backgroundSprite.loadGraphic("assets/images/" + type +  "Hole.png");
        super(backgroundSprite, interactable, requiresFlip, X, Y);

        if (hidden) {
            hide();
        }
    }
 }