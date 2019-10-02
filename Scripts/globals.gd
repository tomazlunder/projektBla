extends Node

var playerName = ""
var otherPlayers = []
var otherPlayerNames = {}

#MENU_LEVEL.MAIN is index 1 not zero so keep that in mind if you change to an array
#enum MENU_LEVEL {
#        NONE,
#        MAIN,
#        START,
#        JOIN,
#        OPTIONS
#    }
#
#var menus = {
#    MENU_LEVEL.MAIN : preload("res://gui/MainMenuScreen.tscn").instance(), 
#    MENU_LEVEL.START : preload("res://gui/StartGameScreen.tscn").instance(),
#    MENU_LEVEL.JOIN : preload("res://gui/JoinGameScreen.tscn").instance(),
#    MENU_LEVEL.OPTIONS : preload("res://gui/OptionsScreen.tscn").instance()
#}