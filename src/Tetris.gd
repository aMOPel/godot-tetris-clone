extends Node2D

# TODO: correct starting position for each tile
# TODO: blinking when on the floor
# TODO: gradually increasing move down speed
# TODO: quicker repeated moving down
# TODO: better drop
# TODO: better random tiles, never the same 2 in a row
# TODO: ghost tile
# TODO: hold tile
# TODO: tile forecast
# TODO: score
# TODO: particles
# TODO: animations
# TODO: floating text
# TODO: music

const ROWS = 20
const COLUMNS = 10
const GRID_SIZE = ROWS * COLUMNS
const CELL_SIZE := 16
const START_POS := -27

enum { YELLOW, ORANGE, RED, PURPLE, BLUE, TEAL, GREEN }
const colors := [
	Color('ffd700'),
	Color('ff7e00'),
	Color('d80000'),
	Color('6b00ec'),
	Color('2460ff'),
	Color('00b7c0'),
	Color('00b91d'),
]

var grid := []

var tile := preload('res://src/Tile.tscn')

onready var md_timer = $MoveDownTimer
onready var blink = $Blink

onready var x := XScene.new(self, false, {count_start = 0})

signal bottom_reached

var stop_counter = 0

const shapes := {
	I = {
		rotations = [
			[
				[0, 0, 0, 0],
				[0, 0, 0, 0],
				[1, 1, 1, 1],
				[0, 0, 0, 0],
			],
			[
				[0, 1, 0, 0],
				[0, 1, 0, 0],
				[0, 1, 0, 0],
				[0, 1, 0, 0],
			],
			[
				[0, 0, 0, 0],
				[1, 1, 1, 1],
				[0, 0, 0, 0],
				[0, 0, 0, 0],
			],
			[
				[0, 0, 1, 0],
				[0, 0, 1, 0],
				[0, 0, 1, 0],
				[0, 0, 1, 0],
			],
		],
		color = TEAL,
	},
	O = {
		rotations = [
			[
				[1, 1],
				[1, 1],
			],
		],
		color = YELLOW,
	},
	T = {
		rotations = [
			[
				[0, 0, 0],
				[0, 1, 0],
				[1, 1, 1],
			],
			[
				[1, 0, 0],
				[1, 1, 0],
				[1, 0, 0],
			],
			[
				[1, 1, 1],
				[0, 1, 0],
				[0, 0, 0],
			],
			[
				[0, 0, 1],
				[0, 1, 1],
				[0, 0, 1],
			],
		],
		color = PURPLE,
	},
	L = {
		rotations = [
			[
				[0, 1, 0],
				[0, 1, 0],
				[0, 1, 1],
			],
			[
				[0, 0, 0],
				[1, 1, 1],
				[1, 0, 0],
			],
			[
				[1, 1, 0],
				[0, 1, 0],
				[0, 1, 0],
			],
			[
				[0, 0, 1],
				[1, 1, 1],
				[0, 0, 0],
			],
		],
		color = ORANGE,
	},
	J = {
		rotations = [
			[
				[0, 1, 0],
				[0, 1, 0],
				[1, 1, 0],
			],
			[
				[1, 0, 0],
				[1, 1, 1],
				[0, 0, 0],
			],
			[
				[0, 1, 1],
				[0, 1, 0],
				[0, 1, 0],
			],
			[
				[0, 0, 1],
				[1, 1, 1],
				[0, 0, 0],
			],
		],
		color = BLUE,
	},
	Z = {
		rotations = [
			[
				[1, 1, 0],
				[0, 1, 1],
				[0, 0, 0],
			],
			[
				[0, 0, 1],
				[0, 1, 1],
				[0, 1, 0],
			],
			[
				[0, 0, 0],
				[1, 1, 0],
				[0, 1, 1],
			],
			[
				[0, 1, 0],
				[1, 1, 0],
				[1, 0, 0],
			],
		],
		color = RED,
	},
	S = {
		rotations = [
			[
				[0, 1, 1],
				[1, 1, 0],
				[0, 0, 0],
			],
			[
				[0, 1, 0],
				[0, 1, 1],
				[0, 0, 1],
			],
			[
				[0, 0, 0],
				[0, 1, 1],
				[1, 1, 0],
			],
			[
				[1, 0, 0],
				[1, 1, 0],
				[0, 1, 0],
			],
		],
		color = GREEN,
	},
}

var current := {
	shape = '',
	position = START_POS,
	rotation = 0,
}

var static_cells = {}


func _ready():
	md_timer.connect('timeout', self, 'move_down')
	self.connect('bottom_reached', self, 'stop_shape')
	x.defaults.method_add = x.HIDDEN
	var coords = make_coords(COLUMNS, ROWS)
	for i in GRID_SIZE:
		x.add_scene(tile)
		x.x(i).position = coords[i]

	spawn_random()

	md_timer.wait_time = 0.5
	md_timer.start()


func _process(delta):
	x.remove_scenes(x.active, x.HIDDEN)
	paint_current()
	for i in static_cells:
		paint(i, static_cells[i])


func _input(event):
	if event.is_action_pressed('ui_right'):
		move(Vector2.RIGHT)
	if event.is_action_pressed('ui_left'):
		move(Vector2.LEFT)
	if event.is_action_pressed('ui_down'):
		move(Vector2.DOWN)
	if event.is_action_pressed('ui_up'):
		move(Vector2.UP)
	if event.is_action_pressed('ui_rotate_cw'):
		rotete(1)
	if event.is_action_pressed('ui_rotate_ccw'):
		rotete(-1)
	if event.is_action_pressed('ui_drop'):
		drop()


func drop() -> void:
	for i in ROWS:
		if collision(Vector2(0, i)):
			move(Vector2(0, i - 1))
			stop_counter = 3
			stop_shape()
			return


func stop_shape() -> void:
	if stop_counter == 3:
		make_static()
		stop_counter = 0
	else:
		stop_counter += 1
		# TODO: not working
		# for index in get_current_indices():
		# 	if x.scenes.has(index):
		# 		blink.interpolate_property(x.x(index),
		# 		"modulate", colors[shapes[current.shape].color], Color.white, 0.2,
		# 						Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		# 		blink.interpolate_property(x.x(index),
		# 		"modulate", Color.white, colors[shapes[current.shape].color], 0.2,
		# 						Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		# 	blink.start()


func spawn_random() -> void:
	var r = randi() % shapes.size()
	spawn(shapes.keys()[r])


func spawn(shape: String) -> void:
	current.shape = shape
	current.position = START_POS
	current.rotation = 0


func rotete(dir := 1) -> void:
	if current.shape == 'O':
		return
	var next_rotation = current.rotation + dir
	if next_rotation == 4:
		next_rotation = 0
	if next_rotation == -1:
		next_rotation = 3

	if collision(Vector2.ZERO, next_rotation):
		return

	current.rotation = next_rotation


func make_static() -> void:
	for i in get_current_indices():
		static_cells[i] = shapes[current.shape].color
	clear_rows()
	spawn_random()


func clear_rows() -> void:
	var rows = row_completed()
	for row in rows:
		for i in COLUMNS:
			static_cells.erase((row * COLUMNS) + i)

		# move keys above row 1 down
		var keys = static_cells.keys()
		keys.sort()
		keys.invert()
		for i in keys:
			var row_of_i: int = i / COLUMNS
			if row >= row_of_i:
				static_cells[i + COLUMNS] = static_cells[i]
				static_cells.erase(i)


func row_completed() -> Array:
	var rows = []
	for i in get_current_indices():
		var row: int = i / COLUMNS
		var consecutive_counter = 0
		for j in COLUMNS:
			if not ((row * COLUMNS) + j) in static_cells.keys():
				break
			consecutive_counter += 1
		if consecutive_counter == COLUMNS:
			if not row in rows:
				rows.append(row)
	return rows


func move(v: Vector2) -> bool:
	var indices = get_current_indices()
	for i in indices:
		if collision(v):
			return false
	current.position += v.x + v.y * COLUMNS
	return true


func move_down() -> void:
	if not move(Vector2.DOWN):
		emit_signal('bottom_reached')


func collision(v := Vector2.ZERO, next_rotation := current.rotation) -> bool:
	var next_indices = get_current_indices(v, next_rotation)

	# special case for I because it can wrap if vertical
	if current.shape == 'I':
		var current_indices = get_current_indices()
		for i in 4:
			var current_row = current_indices[i] / COLUMNS
			var next_row = next_indices[i] / COLUMNS

			if v.x:
				if current_row != next_row:
					return true

	var col_first = false
	var col_last = false
	for i in next_indices:
		# floor collision
		if i >= GRID_SIZE:
			return true

		# no wrapping
		var column = i % COLUMNS

		if column == 0:
			col_first = true
		elif column == COLUMNS - 1:
			col_last = true

		if col_first && col_last:
			return true

		# static cells collision
		if i in static_cells.keys():
			return true

	return false


func get_current_indices(v := Vector2.ZERO, rotation := current.rotation) -> Array:
	var indices = []
	var i = 0
	for row in shapes[current.shape].rotations[rotation]:
		var j = 0
		for cell in row:
			if cell:
				var index: int = (
					current.position
					+ COLUMNS * int(i + v.y)
					+ (j + v.x)
				)
				indices.append(index)
			j += 1
		i += 1
	return indices


func paint_current() -> void:
	for index in get_current_indices():
		paint(index, shapes[current.shape].color)


func paint(index: int, color: int) -> void:
	if x.scenes.has(index):
		x.x(index).modulate = colors[color]
		x.show_scene(index)
	# else:
	# 	print(index, "not in xscenes")


func make_coords(x_max: int, y_max: int) -> Array:
	var coords = []

	var y = 0
	for i in y_max:
		var x = 0
		for j in x_max:
			coords.append(Vector2(x, y))
			x += CELL_SIZE
		y += CELL_SIZE

	return coords
