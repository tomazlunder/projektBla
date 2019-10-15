extends Panel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	MySignals.connect("attribute_panel_open", self, "loadAttributes")

func loadAttributes(Stats):
	if(visible):
		hide()
		return
	
	var first = true
	for i in $MarginContainer/HBoxContainer/VBoxAttributes.get_children():
		if(first == true):
			first = false
			continue
		i.queue_free()
	
	show()
	var atribs = Stats.getAllAttributes()
	for each in atribs:
		var line = preload("res://Scenes/GUI/HBoxAttributeLine.tscn").instance()
		var atribName = constants.AttributeNames[each]
		var currentValue = atribs[each]
		
		line.init(atribName, currentValue, 0, currentValue+1000)
		$MarginContainer/HBoxContainer/VBoxAttributes.add_child(line)
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
