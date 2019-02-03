extends KinematicBody2D

export(float) var SPEED = 10.0 
export(float) var FRICTION = 10.0

var player # reference to the player node
var v = Vector2(0, 0)

func _ready():
	player = $"../player" # go to the parent node and find a node named "player"
	if player == null: # if there was no node named "player"
		print("player not found")
		set_physics_process(false) # don't bother to run physics

func _physics_process(delta):
	var diff = player.position - position # points toward player
	var dir = diff.normalized() # unit vector in player direction
	var a = SPEED * dir # accelerate toward the player
	a -= FRICTION * v
	v += a * delta
	# move_and_slide(v)
	var body = move_and_collide(v * delta) # move_and_collide uses distance, not velocity
	# it returns data about whatever it collided with
	if body != null and body.collider == player: # the enemy collided with the player
		player.take_damage(1, -body.normal)