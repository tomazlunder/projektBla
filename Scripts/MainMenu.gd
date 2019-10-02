extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_buttonStart_button_down():
	var game = preload("res://Scenes/Game/Game.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()

func _on_buttonLAN_button_down():
	var lanMenu = preload("res://Scenes/Menus/LanMenu.tscn").instance()
	get_tree().get_root().add_child(lanMenu)
	hide()
