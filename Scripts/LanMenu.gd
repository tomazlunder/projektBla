extends Node2D

var gameIPs = []
var gameNames = []
var gamePlayers = []

var listenSocket = PacketPeerUDP.new()
var pollSocket = PacketPeerUDP.new()

var listenPort = 17701
var pollPort = 17702
var gamePort = 17703

var addedToList = false

func _ready():
	randomize()
	var randomPlayerNum = rand_range(10000, 99999)
	get_node('nameTextEdit').text = "player_" + str(int(randomPlayerNum))
	
	var label = get_node('noGamesFoundLabel')
	label.hide()
	
	globals.playerName = "player_" + str(int(randomPlayerNum))
	search_for_games()
	
func _process(delta):
	#Listen for looking for game (LFG) packet reply
	if listenSocket.is_listening() && (listenSocket.get_available_packet_count() > 0):
		var array_bytes = listenSocket.get_packet()
		var ip = listenSocket.get_packet_ip()
		var strData = array_bytes.get_string_from_ascii()
		
		print("something came:" + strData)
		var arrayData = strData.rsplit(",")
		
		#When a proper reply is recieved, add server information into arrays
		if(arrayData[0] == "I AM SERVER"):
			gameIPs.append(ip)
			gameNames.append(arrayData[1])
			gamePlayers.append("test/4")
	
func search_for_games():
	print("Searching for games...")
	addedToList = false
	gameIPs = []
	gameNames = []
	gamePlayers = []
	
	var label = get_node('noGamesFoundLabel')
	label.hide()
	
	listenSocket = PacketPeerUDP.new()
	listenSocket.listen(listenPort)
	
	pollSocket = PacketPeerUDP.new()
	pollSocket.set_dest_address("255.255.255.255", pollPort);
	
	var msg = "LFG"
	var packet = msg.to_ascii()
	pollSocket.put_packet(packet)
	
	pollSocket.close()
	get_node("lanSearchTimeout").start()

func _on_refreshButton_button_down():
	var btn = get_node("refreshButton")
	btn.disabled = true
	search_for_games()


func _on_hostButton_button_down():
	listenSocket.close()
	pollSocket.close()
	
	print("Hosting network")
	var host = NetworkedMultiplayerENet.new()
	var res = host.create_server(gamePort,10)
	if res != OK:
		print("Error creating server")
		return
		
	get_tree().set_network_peer(host)
	
	get_tree().change_scene("res://Scenes/Menus/LanLobby.tscn")
	hide()

func _on_lanSearchTimeout_timeout():
	listenSocket.close()
	
	var itemList = get_node("gameItemList")
	itemList.clear()
			
	for i in gameIPs.size():
		var item = gameIPs[i] + " | " + gameNames[i] + " | " + gamePlayers[i]
		print("added item to list")
		itemList.add_item(str(item))
		
	if gameIPs.size() == 0:
		var label = get_node('noGamesFoundLabel')
		label.show()
		
	get_node("refreshButton").disabled = false


func _on_joinButton_button_down():
	var itemList = get_node("gameItemList")
	if itemList.get_selected_items().size() == 0:
		return
		
	print("Joining network")
	var ip = gameIPs[itemList.get_selected_items()[0]]
	
	get_tree().set_network_peer(null) 
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip,gamePort)
	get_tree().set_network_peer(host)
	get_tree().change_scene("res://Scenes/Menus/LanLobby.tscn")
	
func connectToIP(var ip):
	print("Joining network")

	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip,gamePort)
	get_tree().set_network_peer(host)
	get_tree().change_scene("res://Scenes/Menus/LanLobby.tscn")

func _on_gameItemList_item_selected(index):
	var btn = get_node("joinButton")
	btn.disabled = false
	

func _on_gameItemList_nothing_selected():
	var gameList = get_node("gameItemList")
	
	var btn = get_node("joinButton")
	btn.disabled = true

func _on_backButton_button_down():
	get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")