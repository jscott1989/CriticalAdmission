package states.playstate;

import Levels;
import flash.geom.Point;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.plugin.MouseEventManager;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxSave;
import haxe.Timer;
import sounds.SoundManager;
import states.PauseState;
import states.gameoverstate.GameOverState;
import states.intrimstate.IntrimState;
import states.playstate.Clipboard;

using flixel.util.FlxSpriteUtil;

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
    public static inline var UI_GRID_PADDING = 70;
    public static inline var UI_GRID_WIDTH = 1030;
    public static inline var UI_GRID_HEIGHT = 450;

    public static inline var REQUIRED_HEALTH = 80;
    public static inline var REQUIRED_VIP_HEALTH = 90;

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
    public var level:Level;
	public var currentLevel:Int = 0;
    public var levelText:String = "";

    // Our reputation
    public var reputation:Int = 80;

	//What patients are incoming this level
	public var incomingPatients = new Array<PatientInfo>();
    public var patientsToTreat = 0;

	//Store all the patients "fixed" this level for interim screen
	public var treatedPatients = 0;

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

    private var readyToEnd = false;
    private var readyToEndFade = false;
    private var readyToGameOver = false;

    private var hoverHealth:FlxText;

    private var startLevel:Int;

    private static var instance:PlayState;
  
    public static inline function getInstance(level:Int = 1) {
        if (instance == null) {
            instance = new PlayState(level);
        }
        return instance;
    }

    public static inline function clearInstance() {
        instance = FlxDestroyUtil.destroy(instance);
    }


    public function new(level:Int = 1) {
        super();
        this.startLevel = level;
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

    public function moveToTable(type:String){

    }

    /**
     * Generate a collection of patients
     *
     * Ensure the game is winnable given the level and the objects in the scene
     * Pffffft. "Ensure its winnable". Where's the fun in that?
     */
    public function generateLevel(level:Int):Level {
        // Target 40-60% health - TODO: Depend on level

        var patients:Array<PatientInfo> = new Array<PatientInfo>();

        // Generate the first 8 patients to be seen that level
        for (i in 0...8) {
            patients.push(generatePatientInfo(level));
        }

        // Calculate time per patient
        var levelTime:Int = 60 - (10*(level-4));

        if (levelTime <= 15){
            levelTime = 15;
        }

        return new Level(level, null, patients, null, 9, [], [], levelTime);
     }

    public static function generatePatientInfo(level:Int, vip:Bool=false, isMale:Bool=null, name:String=null, crown:Int=null, medals:Bool=false):PatientInfo{
        var patient = new PatientInfo(vip, isMale, name, null, null, null, crown, medals);

        var incomingHealth:Float = Math.max(30, 100 - (level * 5));
        
        //var damaged
        // Now swap things around to ensure the health of each patient is within the bounds
        patient.damageOrgans(incomingHealth);
        //
        patient.initialQOL = patient.getQOL();

        // Now open the holes required

        return patient;
    }

	override public function create():Void
	{
        //SoundManager
        soundManager = SoundManager.getInstance();

        soundManager.startAmbient();

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
        hoverHealth = new FlxText(0, 0, 0, "+6", 80); 
        hoverHealth.font = "assets/fonts/Cabin-Regular.ttf";
        hoverHealth.borderSize = 3;
        hoverHealth.borderStyle = FlxText.BORDER_OUTLINE;
        hoverHealth.color = FlxColor.GREEN;

        add(tooltipText);
        add(hoverHealth);
        add(tooltipSprite);
 		
 		// Set up UI holes
        spawnUIHole(new UIHole(), 0, 0);
        spawnUIHole(new UIHole(), 0, 1);
        spawnUIHole(new UIHole(), 0, 2);

        spawnUIHole(new UIHole(true), 1, 0);
        spawnUIHole(new UIHole(true), 1, 1);
        spawnUIHole(new UIHole(true), 1, 2);

        var pauseHole = new UIHole();
        pauseHole.x = FlxG.width - 100;
        pauseHole.y = FlxG.height - 200;
        watchHole(pauseHole);

        //Set up level information
        Levels.populateLevels();

		super.create();

        cat = new Cat();
        cat.x = Std.random(FlxG.width);
        cat.y = FlxG.height;
        watchInteractable(cat);

        var pause = new Pause();
        watchInteractable(pause);
        pauseHole.addInteractable(pause);

        if (startLevel > 1) {
            currentLevel = startLevel - 1;

            for (i in 0...Std.int(Math.min(Levels.LEVELS.length, startLevel - 2))) {
                generateNewUIElements(Levels.LEVELS[i].uiElements);
                if (i == 0) {
                    spawnUIElement(Interactable.createInteractable("Clipboard"));
                }
            }
            patientsToTreat = -9; // sill fix for a silly bug - last minute
            setupLevel();
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
    public function spawnInteractable(interactable:Interactable) { 
        interactable.x = table.x + Std.random(Std.int(table.width - interactable.width));
        interactable.y = table.y + Std.random(Std.int(table.height - interactable.height));
        watchInteractable(interactable);
    }


    public function spawnUIElement(interactable:Interactable) { 
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
        readyToEndFade = fade;
        readyToEnd = true;
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

        if (currentLevel == 5) {
            var options = new FlxSave();
            options.bind("options");
            options.data.hasPlayedLevel5 = true;
            options.flush();
        }

        if (currentLevel == 1){
            showPopup("Tutorial", "Thank God you're here doctor! Press the 'Next' button in the top left (or press the SPACEBAR) to bring in the first patient");
        } else if (currentLevel == 4) {
            showPopup("Tutorial", "Make sure you don't forget to send the patient on their way before the timer expires. Otherwise we'll lose half our reputation!");
        }

        setupLevel();
	}

    public function setupLevel() {
        // First we check if there is a level already available
        if (Levels.LEVELS.length >= currentLevel) {
            level = Levels.LEVELS[currentLevel - 1];
        } else {
            level = generateLevel(currentLevel);
        }

        patientsToTreat += level.patientsToTreat;

        incomingPatients = level.patients;

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
        if (soundManager.subtitle != null) {
            Utils.bringToFront(members, soundManager.subtitle);
        }
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

            if (patient != null && seconds_remaining > 0) {
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

        if (!popupActive && popups.length > 0) {
            openSubState(popups.shift());
            popupActive = true;
        } else {
            var p:PressureGauge = cast findInteractable("states.playstate.PressureGauge");
            if (p != null && ((p.number != p.targetBars) || p.displayedText.length > 0)) {
                // Still changing, wait)
            } else if (readyToGameOver) {
                readyToGameOver = false;
                FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
                    openSubState(new GameOverState());
                });  
            } else if (readyToEnd) {
                readyToEnd = false;
                isActive = false;
                if (readyToEndFade) {
                    FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
                        openSubState(new IntrimState());
                    });
                } else {
                    openSubState(new IntrimState());
                }
                readyToEndFade = false;
            }
        }

        if (dragging != null && hoveringHole != null) {
            var hh:BodyHole = cast hoveringHole;
            hoverHealth.x = FlxG.mouse.x + 60;
            hoverHealth.y = FlxG.mouse.y - 15;

            var q = PatientInfo.getQOLForHole(dragging.type, hh.type);

            hoverHealth.text = Std.string(q / 10);

            if (q >= 0) {
                hoverHealth.text = "+" + hoverHealth.text;
                hoverHealth.color = FlxColor.GREEN;
            } else {
                hoverHealth.color = FlxColor.RED;
            }

            Utils.bringToFront(members, hoverHealth);
        } else {
            hoverHealth.x = -1000;
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
        if (isActive && !popupActive) {
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
                    } else if (!Utils.getSpriteRectangle(table).containsPoint(new Point(FlxG.mouse.x, FlxG.mouse.y))) {
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

                var holeCenter = new FlxPoint(hole.x + (hole.width / 2), hole.y + (hole.height / 2));
                var mousePosition = new FlxPoint(x, y);
                var distance = holeCenter.distanceTo(mousePosition);

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
				treatedPatients += 1;

                var improvement = patient.info.getQOL() - REQUIRED_HEALTH;
                if (patient.info.isVIP) {
                    improvement = patient.info.getQOL() - REQUIRED_VIP_HEALTH;
                }

                if (improvement >= 0) {
                    changeReputation(Std.int(improvement), "HEALTHY: ");
                    if (patient.info.isVIP) {
                        changeReputation(Std.int(improvement), "VIP: ");
                    }

                } else {
                    changeReputation(Std.int(improvement * 2), "UNHEALTHY: ");
                    if (patient.info.isVIP) {
                        changeReputation(Std.int(improvement * 2), "VIP: ");
                    }
                }

                if (patient.info.containsVisible("Grenade")) {
                    Timer.delay(function() {
                        soundManager.playSound(AssetPaths.Explosion__wav);
                    }, 2000);
                }

                if (patient.info.isVIP) {
                    soundManager.playVIPLeaving(cast findInteractable("states.playstate.Tannoy"));

                    if (patient.info.getQOL() < 50) {
                        Timer.delay(function() {
                            soundManager.playVIPUnhappy(cast findInteractable("states.playstate.Tannoy"));
                        }, 10000);
                    } else if (patient.info.getQOL() > 95) {
                        Timer.delay(function() {
                            soundManager.playVIPHappy(cast findInteractable("states.playstate.Tannoy"));
                        }, 10000);
                    }
                } else if (patient.info.getQOL() > 95 && Std.random(10) == 1) {
                    soundManager.playGoodPerformance(cast findInteractable("states.playstate.Tannoy"));
                }

				destroyPatient();
                
                if ((PlayState.getInstance().patientsToTreat - PlayState.getInstance().treatedPatients) <= 0) {
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

    function changeReputation(change: Int, text: String) {
        if (change >= 0) {
            change = Std.int(Math.min(100 - reputation, change));
        } else {
            change = Std.int(Math.max(0 - reputation, change));
        }

        reputation += change;

        if (reputation == 100) {
            text = "FULL REPUTATION: ";
        }

        var p:PressureGauge = cast findInteractable("states.playstate.PressureGauge");

        if (change >= 0) {
            soundManager.playSuccess();
        } else {
            soundManager.playFailure();
        }

        if (p != null) {
            p.reputationChange(change, reputation, text);
        }

        if (reputation < 10 && Std.random(10) == 1) {
            soundManager.playLowReputation(cast findInteractable("states.playstate.Tannoy"));
        } else if (reputation > 90 && Std.random(10) == 1) {
            soundManager.playHighReputation(cast findInteractable("states.playstate.Tannoy"));
        }
    }

    /**
     * The patient has died
     */
    public function killPatient() {
        patient.die();
        soundManager.playFlatline();
        addingPatient = true;
        if (Std.random(10) == 1) {
            soundManager.playBadPerformance(cast findInteractable("states.playstate.Tannoy"));
        }
        FlxTween.tween(patient, {y: FlxG.height}, 1, {complete: function(t:FlxTween) {
            addingPatient = false;
            soundManager.stopFlatline();
            var improvement = patient.info.getQOL() - REQUIRED_HEALTH;

            if (patient.info.isVIP) {
                soundManager.playVIPDead(cast findInteractable("states.playstate.Tannoy"));
                changeReputation(-100, "DEAD VIP: ");
            } else {
                if (improvement < 0) {
                    changeReputation(Std.int(improvement * 2), "UNHEALTHY: ");
                }

                changeReputation(0 - Std.int(reputation / 2), "DEAD PATIENT: ");
            }

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
            readyToGameOver = true;
        }

		// Remove their holes
		for (hole in patient.holes) {
 			removeHole(hole);
 		}

		// Unload patient
		patient = FlxDestroyUtil.destroy(patient);
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


    private var popups = new Array<PopupState>();
    public var popupActive = false;

    public function showPopup(title:String, text:String) {
        if (!skipTutorial) {
            popups.push(new PopupState(title, text));
        }
    }

	/**
	 * Generate a new patient and tween them on to the screen. */
	public function addNewPatient() {
		// Patient
        if ((PlayState.getInstance().patientsToTreat - PlayState.getInstance().treatedPatients) <= 0) {
            // We don't add one if the level is complete
            return;
        } else if (readyToGameOver) {
            // We don't add one if we're about to gameover
            return;
        }

        if (incomingPatients.length == 0) {

            if (patientsToTreat - treatedPatients == 1 && level.vip != null) {
                // Last one - it's the vip
                patient = new Patient(level.vip, 332, FlxG.height);
            } else {
                // Generate a patient
                patient = new Patient(generatePatientInfo(currentLevel), 332, FlxG.height);
            }
        } else {
            // Load the next normal patient
    		patient = new Patient(incomingPatients.shift(), 332, FlxG.height);
        }

        if (patientsToTreat - treatedPatients == 2) {
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

    override public function destroy():Void {
        super.destroy();

        incomingPatients = null;

        background = FlxDestroyUtil.destroy(background);
        table = FlxDestroyUtil.destroy(table);
        cat = FlxDestroyUtil.destroy(cat);
        hoveringHole = FlxDestroyUtil.destroy(hoveringHole);
        tooltip = FlxDestroyUtil.destroy(tooltip);
        tooltipText = FlxDestroyUtil.destroy(tooltipText);
        tooltipSprite = FlxDestroyUtil.destroy(tooltipSprite);
        dragging = FlxDestroyUtil.destroy(dragging);
        dragLastHole = FlxDestroyUtil.destroy(dragLastHole);
        patient = FlxDestroyUtil.destroy(patient);
        if (holes != null) {
            for (hole in holes) {
                FlxDestroyUtil.destroy(hole);
            }
            holes = null;
        }

        soundManager.stopAmbient();
    }
}