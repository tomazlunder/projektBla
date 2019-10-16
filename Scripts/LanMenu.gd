extends Control

var serverIPs = []
var serverNames = []
var serverNumPlayers = []

var listenSocket = PacketPeerUDP.new()
var pollSocket = PacketPeerUDP.new()

var listenPort = 17701
var pollPort = 17702
var gamePort = 17703

var addedToList = false

onready var PlayerNameEdit=$Margin/VBox/HBox/VBoxButtons/nameTextEdit
onready var GameItemList=$Margin/VBox/HBox/VBoxList/gameItemList
onready var NoGamesFoundLabel=$Margin/VBox/HBox/VBoxList/gameItemList/noGamesFoundLabel
onready var RefreshButton=$Margin/VBox/HBox/VBoxList/refreshButton
onready var JoinButton=$Margin/VBox/HBox/VBoxButtons/joinButton
onready var LanSearchTimeout=$lanSearchTimeout

func _ready():
	randomize()
	var randomPlayerNum = rand_range(10000, 99999)
	PlayerNameEdit.text = "player_" + str(int(randomPlayerNum))
	
	NoGamesFoundLabel.hide()
	
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
	
	NoGamesFoundLabel.hide()
	
	listenSocket = PacketPeerUDP.new()
	listenSocket.listen(listenPort)
	
	pollSocket = PacketPeerUDP.new()
	pollSocket.set_dest_address("255.255.255.255", pollPort);
	
	var msg = "LFG"
	var packet = msg.to_ascii()
	pollSocket.put_packet(packet)
	
	pollSocket.close()
	LanSearchTimeout.start()

func _on_refreshButton_button_down():
	RefreshButton.disabled = true
	search_for_games()


func _on_hostButton_button_down():
	listenSocket.close()
	pollSocket.close()
	
	netcode.create_server(true)
	
	get_tree().change_scene("res://Scenes/Menus/LanLobby.tscn")
	hide()

func _on_lanSearchTimeout_timeout():
	listenSocket.close()
	GameItemList.clear()
			
	for i in serverIPs.size():
		var item
		item = rightSpacePad(serverIPs[i],16) +"|"
		item+= rightSpacePad((serverNames[i]+"'s game"), 40)+"|"
		item+= leftSpacePad(str(serverNumPlayers[i]) +"/"+str(netcode.max_players),5)
		if(serverNumPlayers[i] >= netcode.max_players):
			item += " (FULL)"
		#print("added item to list")
		GameItemList.add_item(str(item))
		
	if serverIPs.size() == 0:
		NoGamesFoundLabel.show()
		
	RefreshButton.disabled = false


func _on_joinButton_button_down():
	#Valid server sellection check
	if GameItemList.get_selected_items().size() == 0:
		return
		
	print("Joining network")
	var ip = serverIPs[GameItemList.get_selected_items()[0]]
	
	get_tree().set_network_peer(null) 
	netcode.join_server(ip)
	get_tree().change_scene("res://Scenes/Menus/LanLobby.tscn")

func _on_gameItemList_item_selected(index):
	if(serverNumPlayers[index] < netcode.max_players):
		JoinButton.disabled = false

func _on_gameItemList_nothing_selected():
	JoinButton.disabled = true

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
	
	