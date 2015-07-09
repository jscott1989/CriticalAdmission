package states.playstate;

import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.plugin.MouseEventManager;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import haxe.Timer;
import states.GameOverState;
import states.IntrimState;

using flixel.util.FlxSpriteUtil;

/**
 * The main playstate set in the surgery room.
 */
class PlayState extends FlxState {

	// UI Grid
    public static inline var UI_GRID_PADDING = 100;
    public static inline var UI_GRID_WIDTH = 900;
    public static inline var UI_GRID_HEIGHT = 600;

	// Consants
	// Scaling when picking things up
	public static inline var GRABBED_SCALE = 1.3;
	public static inline  var DEFAULT_SCALE = 1;

	// How long do we need to hold to make it a drag (seconds)
	public static inline  var CLICK_TIMEOUT = 0.2;

	public static inline var BLOOD_DRIP_TIMEOUT = 0.2;

	//Default level time; tweak for testing
	private var LEVEL_TIME:Float = 60;

	//Level and score counter for Game Over screen
	private var levelCounter:Int = 0;
	private var score:Int = 0;
	//Store all the patients "fixed" this level for interim screen
	private var thisLevelScore:Array<Patient>;


	private var gameover:Bool = false; //has the player lost yet?
	private var isActive:Bool = false; // is the scene playing?
	// (it's not when we're throwing overlays to start/end level)

	// General scene items
	private var background:FlxSprite;
	private var table:Rectangle;

	public var seconds_remaining:Float;
	private var seconds_since_drip:Float;

	// The thing currently being dragged (if any)
	private var dragging:Interactable;
	private var drag_offset_x:Float;
	private var drag_offset_y:Float;
	private var drag_started:Float;

	// Patient
	private var addingPatient:Bool;
	private var patient:Patient;

	// Holes to check for drop targets
	private var holes = new Array<Hole>();

	//Checking for Tannoy messages
	private var tannoyCounter:Float = 0;
	private var SECONDS_BETWEEN_ANNOUNCEMENTS:Float = 15;

    private static var instance:PlayState;
  
    public static inline function getInstance() {
        if (instance == null) {
            return instance = new PlayState();
        } else {
            return instance;
        }
    }

    /**
     * Generate a collection of patients
     *
     * Ensure the game is winnable given the level and the objects in the scene
     */
    public static function generateLevel(level:Int, existingObjects:Array<String>) {
        // Target 40-60% health - TODO: Depend on level
        var targetHealth = 0.5;

        var patientSet = new Array<PatientInfo>();

        // First generate a number of health patients with everything covered
        for (i in 0...10) {
            // generate 10 patients
            patientSet.push(new PatientInfo());

            // Now swap things around to ensure the health of each patient is within the bounds
        }

        // Now open the holes required


        // Now generate the additional organs required that can't be gained from the bodies

        return patientSet;
    }

	override public function create():Void
	{
		// Enable debugger if in debug mode
		FlxG.debugger.visible = true;

		// Scene
		background = new FlxSprite(0,0);
		background.loadGraphic("assets/images/Background.png");
		add(background);

		table = new Rectangle(1300,112,730,1359);
 		
 		// Set up UI holes
        spawnUIHole(new UIHole(new Next()), 0, 0);
        spawnUIHole(new UIHole(new Tannoy()), 0, 1);
        spawnUIHole(new UIHole(new Clock()), 0, 2);

        spawnUIHole(new UIHole(true), 1, 0);
        spawnUIHole(new UIHole(true), 1, 1);
        spawnUIHole(new UIHole(true), 1, 2);

 		// Organs

 		spawnInteractable(new Organ("Heart"));
 		spawnInteractable(new Organ("Brain"));
 		spawnInteractable(new Organ("Elbow", true));
 		spawnInteractable(new Organ("Guts"));
 		spawnInteractable(new Organ("Knee", true));
 		spawnInteractable(new Organ("Lungs"));

 		nextLevel();

		super.create();
	}

    /**
     * Add a UI hole to the interface
     *
     * This uses a 2x6 grid, 0 based
     */
    private function spawnUIHole(hole:UIHole, x:Int, y:Int) { 
        hole.x =  UI_GRID_PADDING + UI_GRID_WIDTH * x;
        hole.y =  UI_GRID_PADDING + UI_GRID_HEIGHT * y;
        watchHole(hole);
    }

	/**
     * Add an interactable on the table.
     */
    private function spawnInteractable(interactable:Interactable) { 
        interactable.x = table.left + Std.random(Std.int(table.width - interactable.width));
        interactable.y = table.top + Std.random(Std.int(table.height - interactable.height));
        watchInteractable(interactable);
    }

	/**
	 * A clock has gone off.
	 */
	public function clockFinished() {
		isActive = false;
		//FlxG.camera.fade(FlxColor.BLACK, .33);
		removePatient(function() {
			openSubState(new IntrimState(levelCounter, score, thisLevelScore));
		});
	}

	/**
	 * Start the next level
	 */
	public function nextLevel() {
		// Reset the clock
		seconds_remaining = LEVEL_TIME;//* LEVEL_MODIFIER //scales time based on level
		isActive = true;
		levelCounter++;
		thisLevelScore = new Array<Patient>();
	}

	/**
	 * Add a hole to the game
	 */
	public function watchHole(hole:Hole) {

		// Add to drop list
		holes.push(hole);

		// Add to renderer
		add(hole);

		if (!hole.isHidden && hole.interactable != null) {
			// If there's an organ, add that too
			watchInteractable(hole.interactable);
		}
	}

	/**
	 * Add an organ to the game
	 */
	public function watchInteractable(inter:Interactable) {
		// Add to renderer
		add(inter);

		// Watch for drag
		MouseEventManager.add(inter, onMouseDown, onMouseUp); 
	}

	/**
	 * Remove a hole from the game
	 */
	public function removeHole(hole:Hole) {
		// Remove from drop targets
		holes.remove(hole);

		// Remove from renderer
		remove(hole, true);

		if (hole.interactable != null) {
			// Remove organ if needed
			removeInteractable(hole.interactable);
		}
	}

	/**
	 * Remove an interactable from the game
	 */
	public function removeInteractable(inter:Interactable) {
		// Remove from renderer
		remove(inter, true);

		// Stop watching for drag
		MouseEventManager.remove(inter);
	}

	override public function update():Void
	{
		if (gameover){
			FlxG.switchState(new GameOverState(levelCounter, score));
		} else if (isActive) {
			if (dragging != null && (Timer.stamp() - drag_started > CLICK_TIMEOUT)) {
				// Deal with dragging

				if (dragging.getHole() != null) {
					// If it was in a hole, remove it
					dragging.getHole().removeInteractable();
				}

				// maintain offset
				dragging.x = FlxG.mouse.x + drag_offset_x;
				dragging.y = FlxG.mouse.y + drag_offset_y;

				if (!FlxG.mouse.pressed) {
					// If we're not pressing any more - stop dragging
					onMouseUp(dragging);
				}
			}

			//Tannoy code
			tannoyCounter += FlxG.elapsed;
			if (tannoyCounter >= SECONDS_BETWEEN_ANNOUNCEMENTS){
				for (hole in holes){
					if (Type.getClass(hole.interactable) == Tannoy){
						var tannoy:Tannoy = cast(hole.interactable, Tannoy);
						tannoy.generateMessage();
					}
				}
				tannoyCounter = 0;
			}

			// Timer
			seconds_remaining -= FlxG.elapsed;
			if (seconds_remaining <= 0) {
				clockFinished();
			}

			// Drips
			if (dragging != null && Type.getClass(dragging) == Organ) {
				seconds_since_drip += FlxG.elapsed;
				if (seconds_since_drip >= BLOOD_DRIP_TIMEOUT) {
					dripBlood(FlxG.mouse.x, FlxG.mouse.y);
					seconds_since_drip = 0;
				}
			}
		}

		super.update();
	}

	/**
	 * Place some blood on the floor.
	 */
	function dripBlood(x:Float, y:Float) {
		var numberOfDrops = Std.random(10);

		for (i in 0...numberOfDrops) {
			var vx = x + (Std.random(100) - 50);
			var vy = y + (Std.random(100) - 50);
			background.drawCircle(vx, vy, Std.random(100) + 1, 0x22FF0000);
		}
	}

	/**
	 * There has been a mouse press on an organ
	 */
	function onMouseDown(sprite:FlxSprite) {
		drag_started = Timer.stamp();
		seconds_since_drip = 0;
		dragging = cast sprite;
		drag_offset_x = dragging.x - FlxG.mouse.x;
		drag_offset_y = dragging.y - FlxG.mouse.y;

		// Make it bigger when grabbed
		FlxTween.tween(dragging.scale, {x: GRABBED_SCALE, y: GRABBED_SCALE}, 0.1);

		// Bring to front
		Utils.bringToFront(members, sprite);
	}

	/**
	 * Mouse up on an organ
	 */
	function onMouseUp(sprite:FlxSprite) {
        if (dragging != null) {
            if (Timer.stamp() - drag_started < CLICK_TIMEOUT) {
                // We're clicking not dragging
                var interactable:Interactable = cast sprite;
                interactable.click();
            } else {
                var placed = false; // Figure out if we're dropping on something
                var minDistance:Float = 99999;
                var minHole:Hole = null;

                for (hole in holes) {
                    // Check each hole
                    var distance = new FlxPoint(hole.x, hole.y).distanceTo(new FlxPoint(dragging.x, dragging.y));

                    if (hole.isEmpty() && distance < minDistance) {
                    	minDistance = distance;
                    	minHole = hole;
                    }
                }

                if (minDistance < minHole.width) {
                    // if the distance is small enough
                    // Add the dragging to the _hole
                    minHole.addInteractable(dragging);
                    placed = true;
                }

                if (!placed && !table.containsPoint(new Point(dragging.x, dragging.y))) {
                    // If it's not on the table and not placed, put it on the table
                    FlxTween.tween(dragging, {x: (table.left + 20)}, 0.1);
                }

            }

            // Resize to default
            FlxTween.tween(dragging.scale, {x: DEFAULT_SCALE, y: DEFAULT_SCALE}, 0.1);

            // No longer dragging
            dragging = null;
        }
	}

	/**
	 * Remove the patient from surgery
	 */
	public function removePatient(callback:Void->Void) {
		if (patient != null) {
			// If we have one, get rid of them first
			FlxTween.tween(patient, {y: 0-(patient.height)}, 1, {complete: function(t:FlxTween) {

				score++;// Still record them if the clock timed out?
				thisLevelScore.push(patient);
				//Destroy patient here or once the score is displayed?
				//destroyPatient();
				//If not here, better destroy them all in start_new
				callback();
			}});
		} else {
			// Otherwise just move on
			callback();
		}
	}

	/**
	 * Call for the next patient
	 */
	public function nextPatient() {
		if (!addingPatient && isActive) { // Avoid spamming patients
			addingPatient = true;
			removePatient(addNewPatient);
		}
	}

	/**
	 * Remove the patient from memory
	 */
	public function destroyPatient() {
		// Remove their holes
		for (hole in patient.holes) {
 			removeHole(hole);
 		}

		// Unload patient
		patient.destroy();
		patient = null;
	}

	/*
	 * The new patient has moved on to the screen
	 */
	public function patientAdded(tween:FlxTween) {
		addingPatient = false;
	}

	/**
	 * Generate a new patient and tween them on to the screen. */
	public function addNewPatient() {
		// Patient
		patient = new Patient(300, FlxG.height);

		// Add to renderer
		add(patient);

		// Add each hole
		for (hole in patient.holes) {
 			watchHole(hole);
 		}

 		// Move on to screen
 		FlxTween.tween(patient, {y: 20}, 1, {"complete": patientAdded});
	}
}