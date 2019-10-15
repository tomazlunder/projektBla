extends HBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(attribName, current, currentRank, next):
	$LabelAtribName.text = attribName
	$LabelCurrent.text = str(current)
	$LabelCurrentRank.text = str(currentRank)
	$HBoxNext/LabelNext.text = str(next)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
