extends Panel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	MySignals.connect("attribute_panel_open", self, "_togglePanel")
	MySignals.connect("attributes_changed", self, "loadAttributes")
func loadAttributes(Stats):	
	var first = true
	#Remove all children except for first (Collum titles of the table)
	for i in $MarginContainer/HBoxContainer/VBoxAttributes.get_children():
		if(first == true):
			first = false
			continue
		i.queue_free()
	
	var attribs = Stats.getAllAttributeRanks()
	for attr in attribs:
		var line = preload("res://Scenes/GUI/HBoxAttributeLine.tscn").instance()
		line.init(attr, attribs[attr])
		$MarginContainer/HBoxContainer/VBoxAttributes.add_child(line)
	
func _togglePanel(Stats):
	if(visible):
		hide()
		return
	
	show()
	loadAttributes(Stats)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
