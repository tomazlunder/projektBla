extends HBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var attribute

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(attr, rank):
	attribute = attr
	var attribName = constants.AttributeNames[attribute]
	var currentValue = constants.getAttributeValue(attr, rank)
	var nextValue = constants.getAttributeValue(attr, rank+1)
	
	$LabelAtribName.text = constants.AttributeNames[attribute]
	$LabelCurrent.text = str(currentValue)
	$LabelCurrentRank.text = str(rank)
	$HBoxNext/LabelNext.text = str(nextValue)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ButtonRankUp_pressed():
	MySignals.emit_signal("use_attribute_point", attribute)

