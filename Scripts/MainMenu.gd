extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_buttonStart_button_down():
	var game = preload("res://Scenes/Game/Game.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()

func _on_buttonLAN_button_down():
	get_tree().change_scene("res://Scenes/Menus/LanMenu.tscn")