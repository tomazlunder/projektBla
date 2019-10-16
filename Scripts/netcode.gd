extends Node

var listenForLFGsocket = PacketPeerUDP.new()
var replySocket = PacketPeerUDP.new()

var LAN_lfg_poll_reply_port = 17701
var LAN_lfg_listen_port = 17702
var serverPort = 17703

var host

var max_players = 4
sync var players = []
sync var playerNames = {}
var players_ready = []

func _ready():
	print("Netcode loaded...")
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func create_server(lfg):
	print("Hosting network")
	host = NetworkedMultiplayerENet.new()
	var res = host.create_server(serverPort,10)
	if res != OK:
		print("Error creating server")
		return
		
	get_tree().set_network_peer(host)
	
	players.append(get_tree().get_network_unique_id())
	playerNames[get_tree().get_network_unique_id()] = globals.playerName
	
	#LFG listening port
	if(lfg):
		listenForLFGsocket = PacketPeerUDP.new()
		listenForLFGsocket.listen(LAN_lfg_listen_port)
		set_process(true)

func _process(delta):
	if(listenForLFGsocket.is_listening() && listenForLFGsocket.get_available_packet_count() > 0):
		var array_bytes = listenForLFGsocket.get_packet()
		print("something came:" + array_bytes.get_string_from_ascii())
		
		var msg = "I AM SERVER," + globals.playerName +","+str(players.size())
		var packet = msg.to_ascii()
		
		replySocket = PacketPeerUDP.new()
		replySocket.set_dest_address(listenForLFGsocket.get_packet_ip(), LAN_lfg_poll_reply_port)
		replySocket.put_packet(packet)
		
		replySocket.close()
	
func join_server(ip):
	host = NetworkedMultiplayerENet.new()
	host.create_client(ip, serverPort)
	get_tree().set_network_peer(host)
	
func _player_connected(id):
	if(get_tree().multiplayer.is_network_server()):
		print("Player connected to server (uID: " + str(id) + ")")
		players.append(id)
		rset("players",players)
	else:
		print("Connected to host")
	
func _player_disconnected(id):
	print("Player disconnected from server (uID: "+str(id)+")")
	players.erase(id)
	playerNames.erase(id)

func _server_disconnected():
	print("Server disconnected!")
	players = []
	playerNames = {}
	get_tree().change_scene("res://Scenes/Menus/LanMenu.tscn")

#Sends the client data to server
func _connected_ok():
	rpc("registerPlayer", get_tree().multiplayer.get_network_unique_id(), globals.playerName)
	
#Recieves client data
master func registerPlayer(var id, var name):
	playerNames[id] = name
	rset("playerNames", playerNames)