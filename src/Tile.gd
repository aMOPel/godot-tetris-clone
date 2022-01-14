extends Sprite

var column: int
var row: int
onready var parent := get_parent()


func _ready():
	if parent is Grid:
		parent.connect('ready', self, '_on_parent_ready')


func _on_parent_ready():
	if parent is Grid:
		column = position.x / parent.cell_x
		row = position.y / parent.cell_y
