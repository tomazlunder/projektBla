extends Node2D

var players_ready = []

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	pre_configure_game()
	pass
	
func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().set_network_peer(null)
		get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
	
func pre_configure_game():
	get_tree().set_pause(true) # Pre-pause
	
	#Create all players
	for pid in globals.players:
		var player = preload("res://Scenes/Game/Player/Player.tscn").instance()
		player.set_name(str(pid))
		player.set_network_master(pid)
		add_child(player)
	
	print("pre configured game")
	rpc("ready_to_start", get_tree().get_network_unique_id())

master func ready_to_start(id):
	print("client done preconfiguring ("+str(id)+")")

	if not id in players_ready:
		players_ready.append(id)
	if players_ready.size() == globals.players.size():
		rpc("post_configure_game")
		
remotesync func post_configure_game():
	print("Starting game!")
	get_tree().set_pause(false) # Unpause and unleash the game!
	
func _player_disconnected(id):
	print("Player disconnected (PID:"+str(id)+")")
	globals.playerNames.erase(id)
	globals.players.erase(id)
	
func _server_disconnected():
	print("Server disconnected!")
	globals.players = []
	globals.playerNames = {}
	hide()
	get_tree().change_scene("res://Scenes/Menus/LanMenu.tscn")