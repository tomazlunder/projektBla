extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SPEED = 250
var direction = Vector2()
var playerID = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if($LifeTime.time_left < 1.5):
		var velocity = direction.normalized() * SPEED * delta
		translate(velocity)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	queue_free()
