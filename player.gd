extends KinematicBody2D # has access to all the properties of a KinematicBody2D

export(float) var SPEED = 10.0 # speed player moves at - editable in the inspector
export(float) var FRICTION = 10.0 # friction that slows the player
export(int) var MAX_HEALTH = 3 # the number of times the player can get hit

var v = Vector2(0, 0) # velocity
var health = MAX_HEALTH # health
var inv = false # whether the player is invincible

func _ready(): # built in function, called when the scene loads
	pass # do nothing

func _physics_process(delta): # built in function, called once per frame
	# delta is the time elapsed since the last frame
	var a = Vector2(0, 0) # acceleration
	if Input.is_action_pressed("player_left"): # if the player is going left
		a.x = -SPEED # accelerate to the left
	if Input.is_action_pressed("player_right"):
		a.x = SPEED
	if Input.is_action_pressed("player_up"):
		a.y = -SPEED
	if Input.is_action_pressed("player_down"):
		a.y = SPEED
	a -= FRICTION * v # I think this is how physics works?
	v += a * delta # velocity is the integral of acceleration with respect to time
	move_and_slide(v) # built in KinematicBody2D function. Move based on velocity.

func take_damage(dmg, kb): # handles invicibility frames and death
	if not inv: # don't take damage when invincible
		health -= 1
		if health <= 0: # the player died
			get_tree().quit() # quit the game
		inv = true # turn invicibility on
		$"Sprite".modulate = Color(1, 1, 1, 0.8) # make the player transparent
		v = kb * SPEED # set velocity in knockback direction
		var t = get_tree().create_timer(1.0) # create a timer for 1 second
		t.connect("timeout", self, "set", ["inv", false]) # when the timer ends, set inv to true
		t.connect("timeout", $"Sprite", "set", ["modulate", Color(1, 1, 1, 1)]) # similar