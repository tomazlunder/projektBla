extends Node2D

var listenForLFGsocket = PacketPeerUDP.new()
var replySocket = PacketPeerUDP.new()

var listenPort = 17702
var replyPort = 17701

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
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
		
	globals.otherPlayers.append(id)
	rpc_id(id,"getClientDataPuppet")
	
func _player_disconnected(id):
	print("Player disconnected from server (uID: "+str(id)+")")
	globals.otherPlayers.erase(id)
	globals.otherPlayerNames.erase(id)
	updateUIplayers()

func _server_disconnected():
	print("Server disconnected!")
	globals.otherPlayers = []
	globals.otherPlayerNames = {}
	hide()
	get_tree().change_scene("res://Scenes/Menus/LanMenu.tscn")

#Sends the client data to server
puppet func getClientDataPuppet():
	rpc_id(0, "setClientDataMaster", str(get_tree().multiplayer.get_network_unique_id()), globals.playerName)
	
#Recieves client data
master func setClientDataMaster(var id, var name):
	globals.otherPlayerNames[id] = name
	updateUIplayers()
	
#Prepares data needed for UI update
func updateUIplayers():
	var i = 2
	var players = []
	players.append(globals.playerName)
	for id in globals.otherPlayers:
		players.append(globals.otherPlayerNames[str(id)])
		i = i+1
	
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

#Starts the game for the server and clients
remotesync func startGame():
	var game = preload("res://Scenes/Game/Game.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()
	
#Start button is only enabled for server
func _on_startButton_button_down():
	rpc("startGame")

func _on_backButton_button_down():
	get_tree().set_network_peer(null)
	get_tree().change_scene("res://Scenes/Menus/LanMenu.tscn")
