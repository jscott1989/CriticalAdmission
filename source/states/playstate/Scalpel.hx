package states.playstate;

 import flixel.FlxG;
 import flixel.tweens.FlxTween;
 import flixel.util.FlxPoint;

/**
 * Scalpel that allows the opening of holes
 */
 class Scalpel extends UIElement {

    public function new(X:Float=0, Y:Float=0)  {
        super("Scalpel", X, Y);

        fixedDragOffset = new FlxPoint(10, -255);
    }

    public override function dropped() {

        var closestHole = PlayState.getInstance().getClosestHole(true, true);

        if (closestHole != null && Type.getClass(closestHole) == BodyHole && closestHole.isHidden) {
            // First make the scalpel smaller
            
            // Resize to default
            FlxTween.tween(this, {x: closestHole.x, y: (closestHole.y + fixedDragOffset.y) + (closestHole.height / 2)}, 0.1);
            FlxTween.tween(this.scale, {x: PlayState.DEFAULT_SCALE, y: PlayState.DEFAULT_SCALE}, 0.1, {"complete": function(tween: FlxTween) {

                FlxTween.tween(this, {x: this.x + closestHole.width}, 0.2, {"complete": function(tween:FlxTween) {
                    // Open the hole
                    closestHole.show();

                    // // Put the scalpel back
                    PlayState.getInstance().returnDragged(this);
                }});
            }});
            return true;
        }
        return false;
    }

    var shownHole:Hole = null;

    public override function update() {
        if (dragging) {
            var closestHole = PlayState.getInstance().getClosestHole(true, true);

            if (closestHole != null && Type.getClass(closestHole) == BodyHole && closestHole.isHidden) {
                if (!closestHole.isTransparent) {
                    if(shownHole != null) {
                        shownHole.cancelTransparent();
                    }
                    shownHole = closestHole;
                    shownHole.goTransparent();
                }
            } else if(shownHole != null) {
                shownHole.cancelTransparent();
                shownHole = null;
            }
        }
        super.update();
    }
 }