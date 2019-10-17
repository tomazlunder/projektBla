extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var unlockedSpells = []
var selectedSpells = []
var selectedSpellID

# Called when the node enters the scene tree for the first time.
func _ready():
	unlockedSpells.append(constants.Spells.FIREBALL)
	unlockedSpells.append(constants.Spells.ICEWALL)
	
	unlockedSpells.append(constants.Spells.FIREBALL)
	unlockedSpells.append(constants.Spells.ICEWALL)
	
	selectedSpellID = 0