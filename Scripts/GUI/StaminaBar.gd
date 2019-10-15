extends TextureProgress

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var stamina_max = 100
var stamina_regen = 1
var stamina = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = 100
	value = 100
	MySignals.connect("attributes_changed", self, "_updateMeta")
	MySignals.connect("stamina_changed", self, "_updateValue")
	pass # Replace with function body.

func _updateValue(newVal):
	value = newVal	
	$Label.text = str(int(value))
	
func _updateMeta(Stats):
	stamina_max = Stats.stamina_max
	stamina_regen = Stats.stamina_regen
	
	max_value = stamina_max
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
