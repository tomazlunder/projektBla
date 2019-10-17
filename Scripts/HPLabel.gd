extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	if(!is_network_master()):
		set_process(true)
	pass # Replace with function body.

func _process(delta):
	text = g
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
