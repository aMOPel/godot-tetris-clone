class_name Tetromino

var c = Constants

var grid: Grid setget _set_grid
var name: String setget _set_name
var color: Color
var position: int setget _set_position
var rotation: int setget _set_rotation
var indices: Array

signal moved


func _init(
	_grid: Grid, _name := '', _position := 0, _rotation := 0, _color = Color()
	):
	grid = _grid
	name = _name
	if _color == Color() && _name:
		color = c.COLORS[c.TETROMINOS[_name].color]
	else:
		color = _color
	position = _position
	rotation = _rotation
	if _name:
		indices = get_indices()
	self.connect('moved', self, 'update_current_indices')


func _set_grid(new_grid: Grid) -> void:
	grid = new_grid
	emit_signal('moved')


func _set_name(new_name: String) -> void:
	name = new_name
	emit_signal('moved')


func _set_rotation(new_rotation: int) -> void:
	rotation = new_rotation
	emit_signal('moved')


func _set_position(new_position: int) -> void:
	position = new_position
	emit_signal('moved')


func bulk_set(new_values: Dictionary, recalculate_indices:= true) -> void:
	for k in new_values:
		match k:
			'grid':
				grid = new_values[k] 
			'name':
				name = new_values[k] 
			'color':
				color = new_values[k] 
			'position':
				position = new_values[k] 
			'rotation':
				rotation = new_values[k] 
	if recalculate_indices:
		emit_signal('moved')


func update_current_indices() -> void:
	indices = get_indices()


func get_indices(v := Vector2.ZERO, _rotation := rotation, _name := name) -> Array:
	var indices = []
	var i = 0
	for row in c.TETROMINOS[_name].rotations[_rotation]:
		var j = 0
		for cell in row:
			if cell:
				var index: int = (
					position
					+ grid.column_max * int(i + v.y)
					+ (j + v.x)
				)
				indices.append(index)
			j += 1
		i += 1
	return indices


func copy_from(tetromino: Tetromino, recalculate_indices:= true) -> void:
	grid = tetromino.grid
	name = tetromino.name
	color = tetromino.color
	position = tetromino.position
	rotation = tetromino.rotation
	if recalculate_indices:
		emit_signal('moved')



func move(v: Vector2, extra_collision = null) -> bool:
	if collision(v):
		return false
	if extra_collision is FuncRef:
		if extra_collision.call_func(v):
			return false
	self.position += v.x + v.y * c.COLUMNS
	return true


func rotete(dir := 1, extra_collision = null) -> bool:
	var next_rotation = rotation + dir
	var max_rotations = c.TETROMINOS[name].rotations.size()

	if next_rotation == max_rotations:
		next_rotation = 0
	if next_rotation < 0:
		next_rotation = max_rotations - 1

	if collision(Vector2.ZERO, next_rotation):
		return false
	if extra_collision is FuncRef:
		if extra_collision.call_func(Vector2.ZERO, next_rotation):
			return false

	self.rotation = next_rotation
	return true


func collision(v := Vector2.ZERO, next_rotation := rotation, next_name := name) -> bool:
	var next_indices = get_indices(v, next_rotation, next_name)

	# special case for I because it can wrap if vertical
	if name == 'I':
		for i in next_indices.size():
			if v.x:
				if (
					grid.x.x(indices[i]).row
					!= grid.x.x(next_indices[i]).row
				):
					return true

	var col_first = false
	var col_last = false
	for i in next_indices:
		# floor collision
		if i >= grid.size:
			return true

		# no wrapping
		var column = grid.x.x(i).column

		if column == 0:
			col_first = true
		elif column == grid.column_max - 1:
			col_last = true

		if col_first && col_last:
			return true

	return false


