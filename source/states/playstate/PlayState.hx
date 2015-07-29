package states.playstate;

import flash.geom.Point;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.plugin.MouseEventManager;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import haxe.Timer;
import sounds.SoundManager;
import sounds.speech.Receptionist;
import states.GameOverState;
import states.intrimstate.IntrimState;
import states.PauseState;
import Levels;

using flixel.util.FlxSpriteUtil;

class State {
    public var reputation:Int;
    public var currentLevel:Int;
    public var patientsToTreat:Int;
    public var uiElements:Array<Constructable>;
    public var interactables:Array<Constructable>;
    public var treatedPatients:Array<PatientInfo>;

    public function new(reputation:Int, currentLevel:Int, patientsToTreat:Int, uiElements:Array<Constructable>, interactables:Array<Constructable>, treatedPatients:Array<PatientInfo>) {
        this.reputation = reputation;
        this.currentLevel = currentLevel;
        this.patientsToTreat = patientsToTreat;
        this.uiElements = uiElements;
        this.interactables = interactables;
        this.treatedPatients = treatedPatients;
    }
}

class Constructable {
    
    private var type:String;
    private var x:Float;
    private var y:Float;

    public function new(type:String, x:Float = 0, y:Float = 0) {
        this.type = type;
        this.x = x;
        this.y = y;
    }

    public function construct():Interactable {
        var i = Interactable.createInteractable(type);
        i.x = x;
        i.y = y;
        return i;
    }
}

/**
 * The main playstate set in the surgery room.
 */
class PlayState extends FlxState {

	// UI Grid
    public static inline var UI_GRID_PADDING = 100;
    public static inline var UI_GRID_WIDTH = 1030;
    public static inline var UI_GRID_HEIGHT = 600;

	// Consants
	// Scaling when picking things up
	public static inline var GRABBED_SCALE = 1.3;
	public static inline  var DEFAULT_SCALE = 1;

	// How long do we need to hold to make it a drag (seconds)
	public static inline  var CLICK_TIMEOUT = 0.2;

	public static inline var BLOOD_DRIP_TIMEOUT = 0.1;

    public var skipTutorial = false;

	//Default level time; tweak for testing
	public var levelTime:Float = 10;

	//Level and score counter for Game Over screen
	public var currentLevel:Int = 0;
    public var minimumHealth:Int = 5;
    public var levelText:String = "";

    // Our reputation
    public var reputation:Int = 80;

	//What patients are incoming this level
	public var incomingPatients = new Array<PatientInfo>();
    public var patientsToTreat = 0;

	//Store all the patients "fixed" this level for interim screen
	public var treatedPatients = new Array<PatientInfo>();

	public var isActive:Bool = false; // is the scene playing?
	// (it's not when we're throwing overlays to start/end level)

	// General scene items
	private var background:FlxSprite;
	private var table:FlxSprite;

    private var cat:Cat;

    private var clockActive = false;
	public var seconds_remaining:Float;
	private var seconds_since_drip:Float;

    public var hoveringHole:Hole;
    private var tooltip:Interactable;
    private var tooltipText:FlxText;
    private var tooltipSprite:FlxSprite;

	// The thing currently being dragged (if any)
	public var dragging:Interactable;
	private var drag_offset:FlxPoint;
	private var drag_started:Float;

    // Where the drag started
    private var dragLastHole:Hole;
    private var dragLastPoint:Point;

	// Patient
	public var addingPatient:Bool;
	public var patient:Patient;

	// Holes to check for drop targets
	private var holes = new Array<Hole>();

	//SoundManager
	public var soundManager:SoundManager;

	//Checking for Tannoy messages
	private var tannoyCounter:Float = 0;
    private var ECGCounter:Float = 0;

    public var stateToLoad:State;
    public var lastSaveState:State;

    private static var instance:PlayState;
  
    public static inline function getInstance(state:State = null) {
        if (instance == null) {
            instance = new PlayState(state);
        }
        return instance;
    }

    public static inline function clearInstance() {
        instance = null;
    }

    public function findInteractables(type:String) {
        var interactables = new Array<Interactable>();
        for (member in members) {
            if (Type.getClass(member) == Organ) {
                var o:Organ = cast member;
                if (o.type == type) {
                    interactables.push(o);
                }
            } else if (Type.getSuperClass(Type.getClass(member)) == UIElement) {
                if (Type.getClassName(Type.getClass(member)) == type) {
                    var i:Interactable = cast member;
                    interactables.push(i);
                }
            }
        }
        return interactables;
    }

    public function findInteractable(type:String) {
        var interactables = findInteractables(type);
        if (interactables.length > 0)
            return interactables[0];
        return null;
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
        var interactables = new Array<Constructable>();
        var uiElements = new Array<Constructable>();

        for (member in members) {
            if (Type.getSuperClass(Type.getClass(member)) == Interactable || Type.getClass(member) == Interactable) {
                var interactable:Interactable = cast member;
                if (interactable.hole == null) {
                    interactables.push(new Constructable(interactable.type, interactable.x, interactable.y));
                }
            }
        }

        for (hole in holes) {
             if (Type.getClass(hole) == UIHole) {
                if (hole.interactable == null) {
                    uiElements.push(null);
                } else {
                    uiElements.push(new Constructable(hole.interactable.type));
                }
            }
        }

        return new State(reputation, currentLevel, patientsToTreat, uiElements, interactables, treatedPatients.copy());
    }

    /**
     * Load the last saved state.
     *
     * This assumes an empty (freshly loaded) scene
     */
    public function loadState(state:State) {
        reputation = state.reputation;
        currentLevel = state.currentLevel;
        treatedPatients = state.treatedPatients;
        patientsToTreat = state.patientsToTreat;

        for (interactable in state.interactables) {
            if (interactable != null) {
                watchInteractable(interactable.construct());
            }
        }

        for (interactable in state.uiElements) {
            if (interactable != null) {
                spawnUIElement(interactable.construct());
            }
        }
    }

    /**
     * Generate a collection of patients
     *
     * Ensure the game is winnable given the level and the objects in the scene
     * Pffffft. "Ensure its winnable". Where's the fun in that?
     */
    public function generateLevel(level:Int, existingObjects:Array<String>):Level {
        //Level text
        //TODO: randomise some quotes
        var text:String = "Some generic level text";

        // Target 40-60% health - TODO: Depend on level
        var targetHealth:Float = 0.5;

        var patients:Array<PatientInfo> = new Array<PatientInfo>();

        // Generate the first X patients to be seen that level
        // TODO: Generate number based on level
        var numberOfPatients = 9;
        for (i in 0...numberOfPatients) {
            patients.push(generatePatientInfo(level));
        }

        // Now generate some additional organs
        //TODO: balance/tie to difficulty
        var interactables:Array<Array<Dynamic>> = [
            ["Organ", ["Heart"]],
            ["Organ", ["Heart"]],
        ];
        
        // Calculate improvment required
        //TODO: balance/tie to difficulty
        var minimumHealth:Int = 10;

        // Calculate time per patient
        //TODO: balance/tie to difficulty
        var levelTime:Int = 15;

        return new Level(text, patients, numberOfPatients, interactables, [], minimumHealth, levelTime);
     }

    private function generatePatientInfo(level:Int):PatientInfo{
        // Target 40-60% health - TODO: Depend on level
        var targetHealth:Int = 50;

        var patient = new PatientInfo();
        
        //var damaged
        // Now swap things around to ensure the health of each patient is within the bounds
        patient.damageOrgans(targetHealth);
        //
        patient.initialQOL = patient.getQOL();


        // Now open the holes required

        return patient;
    }

    override public function new(state:State=null) {
        super();
        this.stateToLoad = state;
    }

	override public function create():Void
	{
		// Enable debugger if in debug mode
		FlxG.debugger.visible = true;

        //SoundManager
        soundManager = new SoundManager();
        soundManager.init();

		// Scene
		background = new FlxSprite(0,0);
		background.loadGraphic("assets/images/Background.png");
		add(background);

        table = new FlxSprite(0, 0);
        table.loadGraphic("assets/images/Table.png");

        table.x = FlxG.width - (table.width + 24);
        table.y = 67;
        add(table);

        tooltipText = new FlxText(0, 0, 0, "Test", 50); 
        tooltipText.font = "assets/fonts/Cabin-Regular.ttf";
        tooltipSprite = new FlxSprite();
        tooltipSprite.makeGraphic(10, 10, FlxColor.BLACK);
        add(tooltipText);
        add(tooltipSprite);
 		
 		// Set up UI holes
        spawnUIHole(new UIHole(), 0, 0);
        spawnUIHole(new UIHole(), 0, 1);
        spawnUIHole(new UIHole(), 0, 2);

        spawnUIHole(new UIHole(true), 1, 0);
        spawnUIHole(new UIHole(true), 1, 1);
        spawnUIHole(new UIHole(true), 1, 2);

        var pauseHole = new UIHole(new Pause());
        pauseHole.x = FlxG.width - 100;
        pauseHole.y = FlxG.height - 200;
        watchHole(pauseHole);

        //Set up level information
        Levels.populateLevels();

		super.create();

        if (stateToLoad != null) {
            loadState(stateToLoad);
        } else {
            cat = new Cat();
            cat.x = Std.random(FlxG.width);
            cat.y = FlxG.height;
            watchInteractable(cat);
        }
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


    private function spawnUIElement(interactable:Interactable) { 
        spawnInteractable(interactable);
        for (hole in holes) {
            if (hole.interactable == null) {
                hole.addInteractable(interactable);
                return;
            }
        }
    }

	/**
	 * A clock has gone off.
	 */
	public function clockFinished() {
        clockActive = false;
        killPatient();
	}

    public function levelComplete(fade:Bool = true) {
        isActive = false;
        lastSaveState = saveState();
        if (fade) {
            FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
                openSubState(new IntrimState());
            });
        } else {
            openSubState(new IntrimState());
        }
    }

    public function pause(fade:Bool = true) {
        isActive = false;
        if (fade) {
            FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
                openSubState(new PauseState());
            });
        } else {
            openSubState(new PauseState());
        }
    }

	/**
	 * Start the next level
	 */
	public function nextLevel() {

        // Reset the clock
        clockActive = false;
        seconds_remaining = 0;

        if (patient != null) {
            destroyPatient();
        }
        
        addingPatient = false;
		currentLevel++;
        var level:Level;
        // First we check if there is a level already available
        if (Levels.LEVELS.length >= currentLevel) {
            level = Levels.LEVELS[currentLevel - 1];
        } else {
    		level = generateLevel(currentLevel, null);
        }

        patientsToTreat += level.patientsToTreat;

        incomingPatients = level.patients;

        while (incomingPatients.length < level.patientsToTreat) {
            incomingPatients.push(generatePatientInfo(currentLevel));
        }

        minimumHealth = level.minimumHealth;
        levelTime = level.levelTime;
        levelText = level.text;

		generateNewInteractables(level.interactables);
        generateNewUIElements(level.uiElements);
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
		MouseEventManager.add(inter, onMouseDownInteractable, onMouseUpInteractable, onMouseEnterInteractable, onMouseExitInteractable); 
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

        if (tooltip != null && dragging == null) {
            tooltipText.text = tooltip.label;

            if (tooltipText.width != (tooltipSprite.width + 50)) {
                tooltipSprite.makeGraphic(Std.int(tooltipText.width) + 50, Std.int(tooltipText.height), FlxColor.BLACK);
            }

            tooltipText.x = FlxG.mouse.x - (tooltipText.width / 2);
            tooltipText.y = FlxG.mouse.y + tooltipText.height + 20;

            Utils.bringToFront(members, tooltipSprite);
            Utils.bringToFront(members, tooltipText, tooltipSprite);
        } else {
            tooltipText.x = -1000;
            tooltipText.y = -1000;
        }
        tooltipSprite.x = tooltipText.x - 25;
        tooltipSprite.y = tooltipText.y;

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
				soundManager.playFiller(cast findInteractable("states.playstate.Tannoy"));
				tannoyCounter = 0;
			}

            if (patient != null) {
                ECGCounter += FlxG.elapsed;
                if (ECGCounter >= seconds_remaining/10) {
                    soundManager.playECG();
                    ECGCounter = 0;
                }
            }

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

    function startECG() {
        ECGCounter = 0;
        soundManager.playECG();
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
        if (isActive) {
    		drag_started = Timer.stamp();
    		seconds_since_drip = 0;
    		dragging = cast sprite;
            dragging.dragging = true;
            dragging.pickedUp();
            dragging.playSound();

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

    function onMouseEnterInteractable(sprite:FlxSprite) {
        tooltip = cast sprite;
    }

    function onMouseExitInteractable(sprite:FlxSprite) {
        tooltip = null;
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
                if (patient.info.onExitCallback != null) {
                    patient.info.onExitCallback(patient);
                }
				treatedPatients.push(patient.info);

                var improvement = patient.info.getQOL() - minimumHealth;

                if (improvement >= 0) {
                    changeReputation(Std.int(improvement));
                    if (patient.info.isVIP) {
                        changeReputation(Std.int(improvement));
                    }

                } else {
                    changeReputation(Std.int(improvement * 2));
                    if (patient.info.isVIP) {
                        changeReputation(Std.int(improvement * 2));
                    }
                }

                if (patient.info.contains("Grenade")) {
                    Timer.delay(function() {
                        soundManager.playSound(AssetPaths.Explosion__wav);
                    }, 2000);
                }

				destroyPatient();
                
                if ((PlayState.getInstance().patientsToTreat - PlayState.getInstance().treatedPatients.length) <= 0) {
                    levelComplete();
                } else {
    				callback();
                }
			}});
		} else {
			// Otherwise just move on
			callback();
		}
	}

    function changeReputation(change: Int) {
        reputation += change;

        // TODO: Play a sound appropriate to the reputation change

        // Show the level of reputation change
        var changeText:String = Std.string(change);
        if (change >= 0) {
            soundManager.playSuccess();
            changeText = "+" + changeText;
        } else {
            soundManager.playFailure();
        }

        // We're going to put the text near the reputation level
        var p = findInteractable("states.playstate.PressureGauge");

        if (p != null) {
            var x = p.x + p.width / 2;
            var y = p.y + p.height / 2;

            x += Std.random(300) - 150;
            y += Std.random(300) - 150;

            var text = new FlxText(x, y, p.width, changeText, 100);
            text.font = "assets/fonts/Cabin-Regular.ttf";
            text.color = FlxColor.RED;
            if (change >= 0) {
                text.color = FlxColor.GREEN;
            }
            add(text);

            var self = this;

            Timer.delay(function f() {
                self.remove(text, true);
            }, 500);
        }
    }

    /**
     * The patient has died
     */
    public function killPatient() {
        patient.die();
        soundManager.playFlatline();
        addingPatient = true;
        FlxTween.tween(patient, {y: FlxG.height}, 1, {complete: function(t:FlxTween) {
            addingPatient = false;
            soundManager.stopFlatline();
            var improvement = patient.info.getQOL() - minimumHealth;

            if (patient.info.isVIP) {
                changeReputation(-100);
            }

            if (improvement < 0) {
                changeReputation(Std.int(improvement * 2));
            }

            changeReputation(0 - Std.int(reputation / 2));

            destroyPatient();
        }});
    }

	/**
	 * Call for the next patient
	 */
	public function nextPatient() {
		if (!addingPatient && isActive) { // Avoid spamming patients
            clockActive = false;
			addingPatient = true;
			removePatient(addNewPatient);
		}
	}

	/**
	 * Remove the patient from memory
	 */
	public function destroyPatient() {
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

	public function generateNewInteractables(interactables: Array<Array<Dynamic>>){
        for (i in interactables) {
            var t:Interactable = Type.createInstance(Type.resolveClass("states.playstate." + i[0]), i[1]);
            spawnInteractable(t);
        }
	}

    public function generateNewUIElements(interactables: Array<String>){
        // We have to reference all of the UIElement classes so that they're compiled
        Clipboard;
        Clock;
        MedicalBook;
        Next;
        PatientCounter;
        Pause;
        PressureGauge;
        Radio;
        Tannoy;

        for (i in interactables) {
            var t:Interactable = Type.createInstance(Type.resolveClass("states.playstate." + i), []);
            spawnUIElement(t);
        }
    }

    public function showPopup(title:String, text:String) {
        if (!skipTutorial) {
            openSubState(new PopupState(title, text));
        }
    }

	/**
	 * Generate a new patient and tween them on to the screen. */
	public function addNewPatient() {
		// Patient
        if ((PlayState.getInstance().patientsToTreat - PlayState.getInstance().treatedPatients.length) <= 0) {
            // We don't add one if the level is complete
            return;
        }
        
        if (incomingPatients.length == 0) {
            // Generate a patient
            patient = new Patient(generatePatientInfo(currentLevel), 332, FlxG.height);
        } else {
            // Load the next normal patient
    		patient = new Patient(incomingPatients.shift(), 332, FlxG.height);
        }

        if (patient.info.isVIP) {
            soundManager.playVIPIncoming(cast findInteractable("states.playstate.Tannoy"));
        }

        startECG();

		// Add to renderer
		add(patient);

        if (patient.info.onEnterCallback != null) {
            patient.info.onEnterCallback(patient);
        }

		// Add each hole
		for (hole in patient.holes) {
 			watchHole(hole);
 		}

 		// Move on to screen
 		FlxTween.tween(patient, {y: 20}, 1, {"complete": patientAdded});
        seconds_remaining = levelTime;
        clockActive = true;
	}
}