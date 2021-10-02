extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var level : GridMap
var gridpos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	level = get_parent()
	gridpos = Vector2(level.world_to_map(translation).x,level.world_to_map(translation).y)

func update():
	pass


func undo():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
