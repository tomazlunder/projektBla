extends Control

onready var ButtonStart = $Margin/VBoxMain/HBoxListButtons/VBoxButtons/startButton

onready var Player1NameLabel = $Margin/VBoxMain/HBoxListButtons/VBoxPlayers/playersHbox1/p1nameLabel

onready var VBoxPlayers = $Margin/VBoxMain/HBoxListButtons/VBoxPlayers

func _ready():	
	if(get_tree().multiplayer.is_network_server()):
		ButtonStart.disabled = false
		Player1NameLabel.text = globals.playerName
	set_process(true)
	
func _process(delta):
	updateUIplayers()

#Prepares data needed for UI update
func updateUIplayers():
	var players = []
	for id in netcode.players:
		players.append(netcode.playerNames[id])
	
	#Call UI update on server and clients
	updatePlayerList(players)
		
#Update players UI on the server and clients
func updatePlayerList(var players):
	var i = 1
	while(i <= 4):
		var label = VBoxPlayers.get_node("playersHbox" + str(i) + "/p"+ str(i) +"nameLabel")
		label.text = "EMPTY"
		if players.size() >= i:
			label.text = players[i-1]
		i+=1

#Starts the game for the server and clients
remotesync func startGame():
	get_tree().change_scene("res://Scenes/Game/Game.tscn")
	hide()

#Start button is only enabled for server
func _on_startButton_button_down():
	netcode.stopLFGlisten()
	rpc("startGame")
	pass

func _on_backButton_button_down():
	netcode.host.close_connection()
	get_tree().set_network_peer(null)
	get_tree().change_scene("res://Scenes/Menus/LanMenu.tscn")
	hide()
