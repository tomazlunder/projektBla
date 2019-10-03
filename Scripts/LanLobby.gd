extends Node2D

var listenForLFGsocket = PacketPeerUDP.new()
var replySocket = PacketPeerUDP.new()

var listenPort = 17702
var replyPort = 17701

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	
	globals.players.append(get_tree().get_network_unique_id())
	globals.playerNames[get_tree().get_network_unique_id()] = globals.playerName
	
	if(get_tree().multiplayer.is_network_server()):
		listenForLFGsocket = PacketPeerUDP.new()
		listenForLFGsocket.listen(listenPort)
		
		var btnStart = get_node("startButton")
		btnStart.disabled = false
		
		get_node("playersVbox/playersHbox1/p1nameLabel").text = globals.playerName
		
		set_process(true)
	
func _process(delta):
	if(listenForLFGsocket.is_listening() && listenForLFGsocket.get_available_packet_count() > 0):
		var array_bytes = listenForLFGsocket.get_packet()
		print("something came:" + array_bytes.get_string_from_ascii())
		
		var msg = "I AM SERVER," + globals.playerName
		var packet = msg.to_ascii()
		
		replySocket = PacketPeerUDP.new()
		replySocket.set_dest_address(listenForLFGsocket.get_packet_ip(), replyPort)
		replySocket.put_packet(packet)
		
		replySocket.close()
		
func _player_connected(id):
	if(get_tree().multiplayer.is_network_server()):
		print("Player connected to server (uID: " + str(id) + ")")
	else:
		print("Connected to host")
		
	globals.players.append(id)
	
func _player_disconnected(id):
	print("Player disconnected from server (uID: "+str(id)+")")
	globals.players.erase(id)
	globals.playerNames.erase(id)
	updateUIplayers()

func _server_disconnected():
	print("Server disconnected!")
	globals.players = []
	globals.playerNames = {}
	hide()
	get_tree().change_scene("res://Scenes/Menus/LanMenu.tscn")

#Sends the client data to server
func _connected_ok():
	rpc("setClientDataMaster", get_tree().multiplayer.get_network_unique_id(), globals.playerName)
	
#Recieves client data
master func setClientDataMaster(var id, var name):
	globals.playerNames[id] = name
	updateUIplayers()

#Prepares data needed for UI update
func updateUIplayers():
	var players = []
	for id in globals.players:
		players.append(globals.playerNames[id])
	
	#Call UI update on server and clients
	rpc("updateUIplayersPuppet",players)
		
#Update players UI on the server and clients
remotesync func updateUIplayersPuppet(var players):
	var i = 1
	while(i <= 4):
		var label = get_node("playersVbox/playersHbox" + str(i) + "/p"+ str(i) +"nameLabel")
		label.text = "EMPTY"
		if players.size() >= i:
			label.text = players[i-1]
		i+=1
		
puppet func updatePlayerNamesPuppet(var names):
	globals.playerNames = names

#Starts the game for the server and clients
remotesync func startGame():
	get_tree().change_scene("res://Scenes/Game/Game.tscn")
	hide()
	
#Start button is only enabled for server
func _on_startButton_button_down():
	rpc("updatePlayerNamesPuppet", globals.playerNames)
	rpc("startGame")

func _on_backButton_button_down():
	get_tree().set_network_peer(null)
	get_tree().change_scene("res://Scenes/Menus/LanMenu.tscn")
