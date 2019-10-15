extends TextureProgress

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hp_max = 100
var hp_regen = 1
var hp = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = 100
	value = 100
	MySignals.connect("attributes_changed", self, "_updateMeta")
	MySignals.connect("hp_changed", self, "_updateValue")
	pass # Replace with function body.

func _updateValue(newVal):
	value = newVal	
	$Label.text = str(int(value))
	
func _updateMeta(Stats):
	hp_max = Stats.hp_max
	hp_regen = Stats.hp_regen
	
	max_value = hp_max
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
