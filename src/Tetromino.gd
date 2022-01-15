class_name Tetromino

var c = Constants

var grid: Grid setget _set_grid
var name: String setget _set_name
var color: Color
var position: Vector2 setget _set_position
var base_index: int setget _set_base_index
var rotation: int setget _set_rotation
var indices: Array

signal moved


func _init(
	_grid: Grid,
	_name := '',
	_position := Vector2.ZERO,
	_base_index := 0,
	_rotation := 0,
	_color = Color()
):
	self.connect('moved', self, 'update_indices')

	grid = _grid
	name = _name
	if _color == Color() && _name:
		color = c.COLORS[c.TETROMINOS[_name].color]
	else:
		color = _color
	position = _position
	base_index = _base_index
	if _position != Vector2.ZERO:
		update_index()
	elif _base_index != 0:
		update_position()
	rotation = _rotation
	if _name:
		indices = get_indices()


func _set_grid(new_grid: Grid) -> void:
	grid = new_grid
	emit_signal('moved')


func _set_name(new_name: String) -> void:
	name = new_name
	emit_signal('moved')


func _set_rotation(new_rotation: int) -> void:
	rotation = new_rotation
	emit_signal('moved')


func _set_base_index(new_base_index: int) -> void:
	base_index = new_base_index
	update_position()
	emit_signal('moved')


func _set_position(v: Vector2) -> void:
	position = v
	update_index()
	emit_signal('moved')


func bulk_set(new_values: Dictionary, recalculate_indices := true) -> void:
	var both = false
	if 'position' in new_values and 'base_index' in new_values:
		both = true
	for k in new_values:
		match k:
			'grid':
				grid = new_values[k]
				continue
			'name':
				name = new_values[k]
				continue
			'color':
				color = new_values[k]
				continue
			'position':
				position = new_values[k]
				if not both:
					update_index()
				continue
			'base_index':
				base_index = new_values[k]
				if not both:
					update_position()
				continue
			'rotation':
				rotation = new_values[k]
				continue
	if recalculate_indices:
		emit_signal('moved')


func update_indices() -> void:
	indices = get_indices()


func update_index() -> void:
	base_index = get_index(position, false)


func update_position() -> void:
	# grid.x is onready so it can be null if the game is still loading
	position = Vector2(
		base_index % grid.column_max, base_index / grid.column_max
	)


func get_index(v := Vector2.ZERO, with_base := true) -> int:
	return (
		(base_index if with_base else 0)
		+ grid.column_max * int(v.y)
		+ int(v.x)
	)


func get_indices(v := Vector2.ZERO, _rotation := rotation, _name := name) -> Array:
	var next_indices = []
	var i := 0
	for row in c.TETROMINOS[_name].rotations[_rotation]:
		var j := 0
		for cell in row:
			if cell:
				next_indices.append(get_index(v) + int(grid.column_max * i) + j)
			j += 1
		i += 1
	return next_indices


# func copy_from(tetromino: Tetromino, recalculate_indices := true) -> void:
# 	grid = tetromino.grid
# 	name = tetromino.name
# 	color = tetromino.color
# 	position = tetromino.position
# 	base_index = tetromino.base_index
# 	rotation = tetromino.rotation
# 	if recalculate_indices:
# 		emit_signal('moved')


func move(v: Vector2, extra_collision = null) -> bool:
	if collision(v):
		return false
	if extra_collision is FuncRef:
		if extra_collision.call_func(v):
			return false
	self.position += v
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

	# special case for I because it can wrap if vertical
	if name == 'I':
		for i in next_indices.size():
			if v.x:
				if grid.x.x(indices[i]).row != grid.x.x(next_indices[i]).row:
					return true

	return false

