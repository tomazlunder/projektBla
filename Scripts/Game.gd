extends Node2D

var players_ready = []

onready var spawns = [$Spawn1, $Spawn2, $Spawn3, $Spawn4]

# Called when the node enters the scene tree for the first time.
func _ready():	
	pre_configure_game()
	pass
	
func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().set_network_peer(null)
		get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
	
func pre_configure_game():
	get_tree().set_pause(true) # Pre-pause
	
	#Create all players
	var i = 0
	for pid in netcode.players:
		var player = preload("res://Scenes/Game/Player.tscn").instance()
		player.set_name(str(pid))
		player.set_network_master(pid)
		player.position = spawns[i].position
		$YSort.add_child(player)
		i+=1
	
	print("pre configured game")
	rpc("ready_to_start", get_tree().get_network_unique_id())

master func ready_to_start(id):
	print("client done preconfiguring ("+str(id)+")")

	if not id in players_ready:
		players_ready.append(id)
	if players_ready.size() == netcode.players.size():
		rpc("post_configure_game")
		
remotesync func post_configure_game():
	print("Starting game!")
	get_tree().set_pause(false) # Unpause and unleash the game!
	