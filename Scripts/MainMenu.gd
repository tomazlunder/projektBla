extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_buttonStart_button_down():
	netcode.create_server(false)
	get_tree().change_scene("res://Scenes/Game/Game.tscn")
	#hide()

func _on_buttonLAN_button_down():
	get_tree().change_scene("res://Scenes/Menus/LanMenu.tscn")