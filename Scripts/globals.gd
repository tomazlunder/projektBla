extends Node

var playerID = -1
var otherPlayers = []

func to_main_menu():
	var mainMenu = preload("res://Scenes/Menus/Main/MainMenu.tscn").instance()
	var current = get_tree().get_root().get_child(0)
	get_tree().get_root().add_child(mainMenu)
	get_tree().get_root().get_child(0)
