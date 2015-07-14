package states.playstate;

import flash.geom.Point;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.plugin.MouseEventManager;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import haxe.Timer;
import sounds.SoundManager;
import sounds.speech.Receptionist;
import states.GameOverState;
import states.intrimstate.IntrimState;

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

	public static inline var BLOOD_DRIP_TIMEOUT = 0.1;

	//Default level time; tweak for testing
	private var LEVEL_TIME:Float = 60;

	//Level and score counter for Game Over screen
	public var currentLevel:Int = 0;

    // Our reputation
    public var reputation:Int = 100;

	//What patients are incoming this level
	public var incomingPatients = new Array<PatientInfo>();

	//Store all the patients "fixed" this level for interim screen
	public var treatedPatients = new Array<PatientInfo>();

	private var isActive:Bool = false; // is the scene playing?
	// (it's not when we're throwing overlays to start/end level)

	// General scene items
	private var background:FlxSprite;
	private var table:FlxSprite;

    private var clockActive = false;
	public var seconds_remaining:Float;
	private var seconds_since_drip:Float;

    public var hoveringHole:Hole;

	// The thing currently being dragged (if any)
	private var dragging:Interactable;
	private var drag_offset:FlxPoint;
	private var drag_started:Float;

    // Where the drag started
    private var dragLastHole:Hole;
    private var dragLastPoint:Point;

	// Patient
	private var addingPatient:Bool;
	private var patient:Patient;

	// Holes to check for drop targets
	private var holes = new Array<Hole>();

	//SoundManager
	private var soundManager:SoundManager = new SoundManager();

	//Checking for Tannoy messages
	private var tannoyCounter:Float = 0;

    private var savedState = new Map<String, {}>();

    private static var instance:PlayState;
  
    public static inline function getInstance() {
        if (instance == null) {
            return instance = new PlayState();
        } else {
            return instance;
        }
    }

    public static inline function clearInstance() {
        instance = null;
    }

    /**
     * Save the current state of the game, ready to be reloaded.
     *
     * All we need to record is the reputation, level and the interactables which are either
     * on the table or in a UIElement
     *
     * Everything else can be generated.
     */
    public function saveState() {
        // savedState = new Map<String, {}>();
        // savedState.set("reputation", reputation);
        // savedState.set("level", level);
        // var interactables = [];
        // var uiHoles = [];

        // for (member in members) {
        //     if (Type.getSuperClass(member) == Interactable) {
        //         if (member.hole == null) {
        //             // Record it
        //             interactables.push(Utils.cloneMap(member.info));
        //         }
        //     } else if (Type.getClass(member) == UIHole) {
        //         if (member.interactable == null) {
        //             uiHoles.push(null);
        //         } else {
        //             uiHoles.push(Utils.cloneMap(member.interactable.info));
        //         }
        //     }
        // }

        // savedState.set("uiHoles", uiHoles);
        // savedState.set("interactables", interactables);
    }

    /**
     * Load the last saved state.
     *
     * This assumes an empty (freshly loaded) scene
     */
    public function loadState(state:Map<String, {}>) {
        // reputation = state.get("reputation");
        // level = state.get("level");

        // for (interactable in stage.get("interactables")) {
            
        // }

        // for (uiHole in stage.get("uiHoles")) {

        // }
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
        for (i in 0...9) {
            // generate 9 patients
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

        table = new FlxSprite(1265, 87);
        table.loadGraphic("assets/images/Table.png");
        add(table);
 		
 		// Set up UI holes
        spawnUIHole(new UIHole(new Next()), 0, 0);
        // spawnUIHole(new UIHole(new Tannoy()), 0, 1);
        spawnUIHole(new UIHole(new MedicalBook()), 0, 1);
        spawnUIHole(new UIHole(new PatientCounter()), 0, 2);

        spawnUIHole(new UIHole(new Clock(), true), 1, 0);
        spawnUIHole(new UIHole(new PressureGauge(), true), 1, 1);
        spawnUIHole(new UIHole(new Scalpel(), true), 1, 2);

		super.create();

        levelComplete(false);
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
        interactable.x = table.x + Std.random(Std.int(table.width - interactable.width));
        interactable.y = table.y + Std.random(Std.int(table.height - interactable.height));
        watchInteractable(interactable);
    }

	/**
	 * A clock has gone off.
	 */
	public function clockFinished() {
        clockActive = false;
        removePatient(addNewPatient);
	}

    public function levelComplete(fade:Bool = true) {
        isActive = false;
        if (fade) {
            FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
                openSubState(new IntrimState());
            });
        } else {
            openSubState(new IntrimState());
        }
    }

	/**
	 * Start the next level
	 */
	public function nextLevel() {
        // Fade in
        FlxG.camera.fade(FlxColor.BLACK, .33, true);

        // Reset the clock
        clockActive = false;
        seconds_remaining = 0;

		isActive = true;
        addingPatient = false;
		currentLevel++;

		incomingPatients = generateLevel(1, null); //This needs to be moved to Interim state when we have the visualiser working
		generateNewOrgans();
        saveState();
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
		MouseEventManager.add(inter, onMouseDownInteractable, onMouseUpInteractable); 
	}

	/**
	 * Remove a hole from the game
	 */
	public function removeHole(hole:Hole) {
		// Remove from drop targets
		holes.remove(hole);

		// Remove from renderer
		remove(hole, true);

        MouseEventManager.remove(hole);

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
		if (isActive) {
			if (dragging != null && (Timer.stamp() - drag_started > CLICK_TIMEOUT)) {
				// Deal with dragging

                Utils.bringToFront(members, dragging);

				if (dragging.getHole() != null) {
					// If it was in a hole, remove it
					dragging.getHole().removeInteractable();
				}

				// maintain offset
				dragging.x = FlxG.mouse.x + drag_offset.x;
				dragging.y = FlxG.mouse.y + drag_offset.y;


                // Highlight any empty holes that will be placed in
                if (hoveringHole != null && new FlxPoint(hoveringHole.x + (hoveringHole.width / 2), hoveringHole.y + (hoveringHole.height / 2)).distanceTo(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y)) < hoveringHole.width) {
                    // Still hovering, do nothing
                } else {
                    if (hoveringHole != null) {
                        hoveringHole.stopHighlight();
                        hoveringHole = null;
                    }
                    var closestHole = getClosestHole();
                    if (closestHole != null && Type.getClass(closestHole) == BodyHole && !closestHole.isHighlighted) {
                        hoveringHole = closestHole;
                        closestHole.startHighlight();
                    }
                }

				if (!FlxG.mouse.pressed) {
					// If we're not pressing any more - stop dragging
					onMouseUpInteractable(dragging);
				}
			}

			//Tannoy code
			tannoyCounter += FlxG.elapsed;
			if (tannoyCounter >= Config.SECONDS_BETWEEN_ANNOUNCEMENTS){
				for (hole in holes){
					if (Type.getClass(hole.interactable) == Tannoy){
						soundManager.playRandomSoundMap(Receptionist.ANNOUNCEMENTS);					
					}
				}
				tannoyCounter = 0;
			}

			Utils.bringToFront(members, soundManager.subtitle);

			// Timer
            if (clockActive) {
    			seconds_remaining -= FlxG.elapsed;
    			if (seconds_remaining <= 0) {
    				clockFinished();
    			}
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

        var drawTargets = [table];

        // if (patient != null) {
        //     drawTargets.push(patient.bodySprite);
        //     drawTargets.push(patient.bedSprite);
        // }

        var drawTarget = background;

        for (d in drawTargets) {
            if (Utils.getSpriteRectangle(d).containsPoint(new Point(x, y))) {
                drawTarget = d;
                break;
            }
        }

        x -= drawTarget.x;
        y -= drawTarget.y;

        // Draw on this then we'll merge it with drawTarget
        var s = new FlxSprite();
        s.makeGraphic(Std.int(drawTarget.width), Std.int(drawTarget.height), FlxColor.TRANSPARENT, true);

		var numberOfDrops = Std.random(10);

		for (i in 0...numberOfDrops) {
			var vx = x + (Std.random(100) - 50);
			var vy = y + (Std.random(100) - 50);

			var alpha = flixel.util.FlxRandom.intRanged(2, 5) * 10;
			var red = flixel.util.FlxRandom.intRanged(13, 23) * 10;
            // Draw on target
            s.drawCircle(vx, vy, Std.random(100) + 1, FlxColorUtil.makeFromARGB(alpha, red, 0, 0));
		}

        drawTarget.pixels.draw(s.pixels);

        // var s2 = new FlxSprite();
        // s2.makeGraphic(Std.int(drawTarget.width), Std.int(drawTarget.height), FlxColor.TRANSPARENT, true);

        // FlxSpriteUtil.alphaMaskFlxSprite(drawTarget, drawTarget, s2);
        // add(s2);

        // drawTarget.pixels.draw(s2.pixels);
	}

	/**
	 * There has been a mouse press on an organ
	 */
	function onMouseDownInteractable(sprite:FlxSprite) {
		drag_started = Timer.stamp();
		seconds_since_drip = 0;
		dragging = cast sprite;
        dragging.dragging = true;

        if (dragging.fixedDragOffset != null) {
            drag_offset = dragging.fixedDragOffset;
            FlxTween.tween(dragging, {x: FlxG.mouse.x + drag_offset.x, y: FlxG.mouse.y + drag_offset.y}, 0.1);
        } else {
            drag_offset = new FlxPoint(dragging.x - FlxG.mouse.x, dragging.y - FlxG.mouse.y);
        }

        
        // Record the position
        dragLastHole = dragging.getHole();
        dragLastPoint = new Point(dragging.x, dragging.y);

		// Make it bigger when grabbed
		FlxTween.tween(dragging.scale, {x: GRABBED_SCALE, y: GRABBED_SCALE}, 0.1);
	}

	/**
	 * Mouse up on an organ
	 */
	function onMouseUpInteractable(sprite:FlxSprite) {
        if (dragging != null) {
            if (Timer.stamp() - drag_started < CLICK_TIMEOUT) {
                // We're clicking not dragging
                var interactable:Interactable = cast sprite;
                interactable.click();
            } else {
                // We only deal with drops if the interactable doesn't
                if (!dragging.dropped()) {
                    var closestHole = getClosestHole();

                    if (closestHole != null) {
                        closestHole.addInteractable(dragging);
                    } else if (!Utils.getSpriteRectangle(table).containsPoint(new Point(dragging.x, dragging.y))) {
                        // If it's not on the table and not placed, put it on the table
                        returnDragged(dragging);
                    }
                }
            }
            // Resize to default
            FlxTween.tween(dragging.scale, {x: DEFAULT_SCALE, y: DEFAULT_SCALE}, 0.1);

            // No longer dragging
            dragging.dragging = false;
            dragging = null;

            if (hoveringHole != null) {
                hoveringHole.stopHighlight();
                hoveringHole = null;
            }
        }
	}

    /**
     * Return the dragged object to its last location
     */
    public function returnDragged(dragging:Interactable) {
        if (dragLastHole != null) {
            dragLastHole.addInteractable(dragging);
        } else {
            FlxTween.tween(dragging, {x: dragLastPoint.x, y: dragLastPoint.y}, 0.1);
        }
    }

    public function getClosestHole(includeHidden:Bool=false, includeOccupied:Bool=false) {
        var x = FlxG.mouse.x;
        var y = FlxG.mouse.y;
        var minDistance:Float = 99999;
        var minHole:Hole = null;

        for (hole in holes) {
            // Check each hole
            if (includeHidden || !hole.isHidden) {
                var distance = new FlxPoint(hole.x + (hole.width / 2), hole.y + (hole.height / 2)).distanceTo(new FlxPoint(x, y));

                if (distance < minDistance) {
                    if (includeOccupied || hole.isEmpty()) {
                        minDistance = distance;
                        minHole = hole;
                    }
                }
            }
        }

        if (minHole != null && minDistance < minHole.width) {
            return minHole;
        }
        return null;
    }

	/**
	 * Remove the patient from surgery
	 */
	public function removePatient(callback:Void->Void) {
		if (patient != null) {
			// If we have one, get rid of them first
			FlxTween.tween(patient, {y: 0-(patient.height)}, 1, {complete: function(t:FlxTween) {
				treatedPatients.push(patient.info);
				//Destroy patient here or once the score is displayed?
				destroyPatient();
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
        reputation -= 40;

        if (reputation <= 0) { 
            // Game Over
            FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
                openSubState(new GameOverState());
            });
        }

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

	public function generateNewOrgans(){
		if (currentLevel == 1){
			spawnInteractable(new Organ("Heart"));
	 		spawnInteractable(new Organ("Brain"));
	 		spawnInteractable(new Organ("Elbow"));
	 		spawnInteractable(new Organ("Guts"));
	 		spawnInteractable(new Organ("Knee"));
	 		spawnInteractable(new Organ("Lung"));
 		}
	}

	/**
	 * Generate a new patient and tween them on to the screen. */
	public function addNewPatient() {
		// Patient

        if (incomingPatients.length == 0) {
            levelComplete();
        } else {
    		patient = new Patient(incomingPatients.shift(), 300, FlxG.height);

    		// Add to renderer
    		add(patient);

    		// Add each hole
    		for (hole in patient.holes) {
     			watchHole(hole);
     		}

     		// Move on to screen
     		FlxTween.tween(patient, {y: 20}, 1, {"complete": patientAdded});
            seconds_remaining = LEVEL_TIME;//* LEVEL_MODIFIER //scales time based on level
            clockActive = true;
        }
	}
}