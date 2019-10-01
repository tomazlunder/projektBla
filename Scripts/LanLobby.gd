extends Node2D

export var isServer = 0

var listenForLFGsocket = PacketPeerUDP.new()
var replySocket = PacketPeerUDP.new()

var listenPort = 17702
var replyPort = 17701

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	
	if(get_tree().multiplayer.is_network_server()):
		listenForLFGsocket = PacketPeerUDP.new()
		listenForLFGsocket.listen(listenPort)
		
		var network = get_tree().multiplayer
		network.connect("peer_connected",self,"_peer_connected")
		network.connect("peer_disconnected",self,"_peer_disconnected")
		
		var btnStart = get_node("startButton")
		btnStart.disabled = false
		
		set_process(true)
	
func _process(delta):
	if(listenForLFGsocket.is_listening() && listenForLFGsocket.get_available_packet_count() > 0):
		var array_bytes = listenForLFGsocket.get_packet()
		print("something came:" + array_bytes.get_string_from_ascii())
		
		var msg = "I AM SERVER,"+globals.playerID
		var packet = msg.to_ascii()
		
		replySocket = PacketPeerUDP.new()
		replySocket.set_dest_address(listenForLFGsocket.get_packet_ip(), replyPort)
		replySocket.put_packet(packet)
		
		replySocket.close()
		
func _player_connected(id):
	print("Player connected to server")
	globals.otherPlayers.append(id)	
	
#Rename this and join to button:
remotesync func startGame():
	var game = preload("res://Scenes/Game/Game.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()


func _on_startButton_button_down():
	rpc("startGame")
	#startGame()
