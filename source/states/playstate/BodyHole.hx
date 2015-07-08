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
            "Brain" => 60,
            "Heart" => 100,
            "Stomach" => 50
        ],
        "Brain" => [
            "Brain" => 100,
            "Heart" => 30,
            "Stomach" => 10
        ],
        "Stomach" => [
            "Brain" => 60,
            "Heart" => 20,
            "Stomach" => 100
        ],
        "Next" => [
            "Brain" => 30,
            "Heart" => 60,
            "Stomach" => 10
        ],
        "Tannoy" => [
            "Brain" => 60,
            "Heart" => 10,
            "Stomach" => 10
        ],
        "Clipboard" => [
            "Brain" => 10,
            "Heart" => 10,
            "Stomach" => 10
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