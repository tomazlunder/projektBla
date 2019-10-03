extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#First create ourselves
	var thisPlayer = preload("res://Scenes/Game/Player/Player.tscn").instance()
	thisPlayer.set_name(str(get_tree().get_network_unique_id()))
	thisPlayer.set_network_master(get_tree().get_network_unique_id())
	add_child(thisPlayer)
	
	#Now create the other players
	for i in globals.otherPlayers:
		var otherPlayer = preload("res://Scenes/Game/Player/Player.tscn").instance()
		otherPlayer.set_name(str(i))
		otherPlayer.set_network_master(i)
		add_child(otherPlayer)




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
