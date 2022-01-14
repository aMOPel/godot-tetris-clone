extends Node2D

class_name Grid

var row_max: int
var column_max: int

var size: int
var cell_x: float
var cell_y: float

# to group indices of rows and of columns together since they are constant
var row_index: Array
var column_index: Array

var tile: Resource
var method_add: int

onready var x := XScene.new(self, false, {count_start = 0})


func _ready():
	column_index = []
	row_index = []
	var flat_coordinates = []
	for i in row_max:
		row_index.append([])
	for i in column_max:
		column_index.append([])

	var y_coord = 0
	for i in row_max:
		var x_coord = 0
		for j in column_max:
			row_index[i].append(flat_coordinates.size())
			column_index[j].append(flat_coordinates.size())
			flat_coordinates.append(Vector2(x_coord, y_coord))
			x_coord += cell_x
		y_coord += cell_y

	x.defaults.method_add = method_add
	for i in size:
		x.add_scene(tile)
		x.x(i).position = flat_coordinates[i]


func _init(
	_column_max: int,
	_row_max: int,
	_tile: Resource,
	_cell_x: int,
	_cell_y: int,
	_method_add := 1
):
	column_max = _column_max
	row_max = _row_max

	size = _column_max * _row_max

	tile = _tile
	cell_x = _cell_x
	cell_y = _cell_y
	method_add = _method_add
