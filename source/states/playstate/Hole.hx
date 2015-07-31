package states.playstate;

 import flixel.FlxSprite;
 import flixel.group.FlxSpriteGroup;
 import flixel.tweens.FlxTween;
 import flixel.util.FlxColor;
 import flixel.util.FlxDestroyUtil;

/**
 * A hole is used to contain an Organ
 */
 class Hole extends FlxSpriteGroup {

    // The contained organ
    public var interactable:Interactable;

    private var backgroundSprite:FlxSprite;
    private var highlightSprite:FlxSprite;
    private var transparentSprite:FlxSprite;
    private var hiddenSprite:FlxSprite;

    public var requiresFlip:Bool = false;
    public var locked:Bool = false;
    public var isHidden:Bool = false;
    public var isTransparent:Bool = false;
    public var isHighlighted:Bool = false;

    public function new(backgroundSprite:FlxSprite, interactable:Interactable, requiresFlip:Bool, locked:Bool, X:Float=0, Y:Float=0)  {
        super(X, Y);
        this.backgroundSprite = backgroundSprite;
        this.requiresFlip = requiresFlip;
        this.locked = locked;
        add(backgroundSprite);
        if (interactable != null) {
            initInteractable(interactable);
        }
    }

    /**
     * Spawn an interactable in this hole.
     */
    public function initInteractable(interactable:Interactable) {

        // center it
        interactable.x = x + ((width - interactable.width)/2);
        interactable.y = y + ((height - interactable.height)/2);

        // then add as normal - making sure we don't move it
        addInteractable(interactable, false);
    }

    /**
     * Is this hole empty?
     */
    public function isEmpty() {
        return interactable == null;
    }

    public function addInteractable(interactable:Interactable, position:Bool = true) {
        this.interactable = interactable;
        interactable.setHole(this);

        // We get the size BEFORE adding the interactable
        // so that centering works correctly
        var bWidth = width;
        var bHeight = height;
        var bx = interactable.x;
        var by = interactable.y;
        add(interactable);

        // Re-set the interactable position
        interactable.x = bx;
        interactable.y = by;

        if (position) {
            // Then move it to the center
            FlxTween.tween(interactable, {x: x + ((bWidth - interactable.width)/2), y: y + ((bHeight - interactable.height)/2)}, 0.1);
        }

    }

    /**
     * Remove the organ from the hole
     */
    public function removeInteractable() {
        if (interactable != null) {
            interactable.resetHole();
            remove(interactable, true);
            interactable = null;
        }
    }

    /**
     * Stop rendering
     */
    public function hide() {
        if (hiddenSprite == null) {
            hiddenSprite = new FlxSprite();
            hiddenSprite.makeGraphic(Std.int(backgroundSprite.width), Std.int(backgroundSprite.height), FlxColor.TRANSPARENT);
        }
        remove(interactable, true);
        remove(backgroundSprite);
        PlayState.getInstance().removeInteractable(interactable);
        add(hiddenSprite);

        isHidden = true;
    }

    /**
     * Start rendering
     */
    public function show() {
        add(backgroundSprite);
        backgroundSprite.x = x;
        backgroundSprite.y = y;

        if (isTransparent) {
            cancelTransparent();
        }

        // I don't know why but removing this breaks the Hole...
        // we don't need to as it's hidden by the background
        remove(hiddenSprite, true);

        if (interactable != null) {
            // center it
            PlayState.getInstance().watchInteractable(interactable);
            add(interactable);
            interactable.x = x + ((backgroundSprite.width - interactable.width)/2);
            interactable.y = y + ((backgroundSprite.height - interactable.height)/2);
        }

        isHidden = false;
    }

    public function goTransparent() {
        if (transparentSprite == null) {
            transparentSprite = new FlxSprite(x, y);
            transparentSprite.loadGraphicFromSprite(backgroundSprite);
            transparentSprite.alpha = 0.3;
        }
        isTransparent = true;
        add(transparentSprite);
        transparentSprite.x = x;
        transparentSprite.y = y;
        // remove(hiddenSprite);
    }

    public function cancelTransparent() {
        try {
            isTransparent = false;
            remove(transparentSprite, true);
        } catch( unknown: Dynamic) {}
        // remove(backgroundSprite);
        // add(hiddenSprite);
    }

    public function startHighlight() {
        if (highlightSprite != null) {
            add(highlightSprite);
            highlightSprite.x = x;
            highlightSprite.y = y;
        }
        isHighlighted = true;
    }

    public function stopHighlight() {
        if (highlightSprite != null) {
            remove(highlightSprite, true);
        }
        isHighlighted = false;
    }

    public override function destroy() {
        super.destroy();
        backgroundSprite = FlxDestroyUtil.destroy(backgroundSprite);
        highlightSprite = FlxDestroyUtil.destroy(highlightSprite);
        transparentSprite = FlxDestroyUtil.destroy(transparentSprite);
        hiddenSprite = FlxDestroyUtil.destroy(hiddenSprite);

        interactable = FlxDestroyUtil.destroy(interactable);

    }
 }