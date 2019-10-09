extends Node2D

var serverIPs = []
var serverNames = []
var serverNumPlayers = []

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
			serverIPs.append(ip)
			serverNames.append(arrayData[1])
			serverNumPlayers.append(int(arrayData[2]))
	
func search_for_games():
	print("Searching for games...")
	addedToList = false
	serverIPs = []
	serverNames = []
	serverNumPlayers = []
	
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
	
	netcode.create_server(true)
	
	get_tree().change_scene("res://Scenes/Menus/LanLobby.tscn")
	hide()

func _on_lanSearchTimeout_timeout():
	listenSocket.close()
	
	var itemList = get_node("gameItemList")
	itemList.clear()
			
	for i in serverIPs.size():
		var item
		item = rightSpacePad(serverIPs[i],16) +"|"
		item+= rightSpacePad((serverNames[i]+"'s game"), 40)+"|"
		item+= leftSpacePad(str(serverNumPlayers[i]) +"/"+str(constants.maxPlayers),5)
		if(serverNumPlayers[i] >= constants.maxPlayers):
			item += " (FULL)"
		#print("added item to list")
		itemList.add_item(str(item))
		
	if serverIPs.size() == 0:
		var label = get_node('noGamesFoundLabel')
		label.show()
		
	get_node("refreshButton").disabled = false


func _on_joinButton_button_down():
	#Valid server sellection check
	var itemList = get_node("gameItemList")
	if itemList.get_selected_items().size() == 0:
		return
		
	print("Joining network")
	var ip = serverIPs[itemList.get_selected_items()[0]]
	
	get_tree().set_network_peer(null) 
	netcode.join_server(ip)
	get_tree().change_scene("res://Scenes/Menus/LanLobby.tscn")

func _on_gameItemList_item_selected(index):
	if(serverNumPlayers[index] < constants.maxPlayers):
		var btn = $joinButton
		btn.disabled = false

func _on_gameItemList_nothing_selected():
	var btn = $joinButton
	btn.disabled = true

func _on_backButton_button_down():
	get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
	
func leftSpacePad(var string, var total):
	var newString = string
	while(newString.length() < total):
		newString = " " + newString
	return newString
	
func rightSpacePad(var string, var total):
	var newString = string
	while(newString.length() < total):
		newString+= " "
	return newString
	
	