extends Node2D

var players_ready = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pre_configure_game()
	pass
	
func pre_configure_game():
	get_tree().set_pause(true) # Pre-pause
	
	#Create all players
	for pid in globals.players:
		var player = preload("res://Scenes/Game/Player/Player.tscn").instance()
		player.set_name(str(pid))
		player.set_network_master(pid)
		add_child(player)
	
	print("pre configured game")
	
	if not get_tree().is_network_server():
		# Tell server we are ready to start
		rpc("ready_to_start", get_tree().get_network_unique_id())
	else:
		players_ready.append(get_tree().get_network_unique_id())
		
	if(globals.players.size() == 1):
		post_configure_game()

master func ready_to_start(id):
	assert(get_tree().is_network_server())

	print("client done preconfiguring ("+str(id)+")")

	if not id in players_ready:
		players_ready.append(id)
	if players_ready.size() == globals.players.size():
		rpc("post_configure_game")
		#for player in globals.players:
			#rpc_id(player, "post_configure_game()")
		
remotesync func post_configure_game():
	print("Starting game!")
	get_tree().set_pause(false) # Unpause and unleash the game!