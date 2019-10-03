extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_buttonStart_button_down():
	var host = NetworkedMultiplayerENet.new()
	var res = host.create_server(12345,1)
	get_tree().set_network_peer(host)
	globals.players.append(get_tree().get_network_unique_id())
	globals.playerNames[get_tree().get_network_unique_id()] = "Player"
	
	get_tree().change_scene("res://Scenes/Game/Game.tscn")
	hide()

func _on_buttonLAN_button_down():
	get_tree().change_scene("res://Scenes/Menus/LanMenu.tscn")