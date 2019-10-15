extends TextureProgress

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mana_max = 100
var mana_regen = 1
var mana = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = 100
	value = 100
	MySignals.connect("attributes_changed", self, "_updateMeta")
	MySignals.connect("mana_changed", self, "_updateValue")
	pass # Replace with function body.

func _updateValue(newVal):
	value = newVal	
	$Label.text = str(int(value))
	
func _updateMeta(Stats):
	mana_max = Stats.mana_max
	mana_regen = Stats.mana_regen
	
	max_value = mana_max
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
