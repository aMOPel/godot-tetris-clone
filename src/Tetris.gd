extends Node2D

# FIXED: tile stuck on left or right cage when moving it too quickly to one side

# DONE: ghost tile
# DONE: better random tiles, never the same 2 in a row
# DONE: quicker repeated moving down
# DONE: cell access row and col
# DONE: constant cols and rows
# DONE: seed and randomness
# DONE: game over
# DONE: correct starting position for each tile
# DONE: tile forecast
# DONE: keep tile
# DONE: blinking when on the floor

# DOING: score

# TODO: redo game over screen with grid and tetro classes from script
# TODO: better randomness, no tile should appear too rarely
# TODO: gradually increasing move down speed
# TODO: better drop
# TODO: particles
# TODO: animations
# TODO: floating text
# TODO: music
# TODO: sfx with mausi

onready var md_timer = $MoveDownTimer
onready var blink = $Blink

var c := Constants
var queue: Queue
var keep: Keep
var tetris_grid: Grid

var current: Tetromino

var static_cells := {}

var score := 0 setget _set_score

# how many times the tetromino touched the ground, at 4 its made static
var stop_counter := 0 setget _set_stop_counter

signal moved(v)
signal rotated(dir)
signal dropped(tetromino)
signal row_completed(completed_rows, with_tetromino)
signal score_changed(old_score, new_score)
signal bottom_reached
signal new_static
signal game_over


func _init():
	tetris_grid = Grid.new(c.COLUMNS, c.ROWS + c.ROWS_ABOVE, c.TILE, c.CELL_X, c.CELL_Y)
	add_child(tetris_grid)

	queue = Queue.new(c.QUEUE_SIZE)
	add_child(queue)

	keep = Keep.new()
	add_child(keep)

	current = Tetromino.new(tetris_grid)


func _ready():
	md_timer.connect('timeout', self, '_on_md_timer_timeout')
	self.connect('bottom_reached', self, '_on_bottom_reached')
	self.connect('new_static', self, '_on_new_static')
	self.connect('row_completed', self, '_on_row_completed')

	spawn()

	md_timer.wait_time = c.SETTINGS.MD_WAIT_TIME_START
	md_timer.start()


func _process(delta):
	tetris_grid.x.remove_scenes(tetris_grid.x.active, tetris_grid.x.HIDDEN)
	paint_ghost()
	paint_tetromino(current)
	for i in static_cells:
		paint(tetris_grid, i, c.COLORS[static_cells[i]])


func _input(event):
	if not tetris_grid.x.active.empty():
		var ca = CONTROLS.actions
		for k in ca:
			if event.is_action_pressed(k, ca[k].hold_enabled):
				for f in ca[k].functions:
					if ca[k].has('object'):
						ca[k].object.callv(f, ca[k].arguments)
					else:
						callv(f, ca[k].arguments)


func get_current_lowest_possible_position() -> int:
	for i in tetris_grid.row_max + 1:
		if collision(Vector2(0, i)):
			return i
	return 0


func make_static() -> void:
	for i in current.indices:
		static_cells[i] = c.TETROMINOS[current.name].color
	emit_signal('new_static')
	if collision_roof():
		emit_signal('game_over')


func clear_rows() -> void:
	var completed_rows = get_completed_rows()
	for row in completed_rows:
		for i in tetris_grid.row_index[row]:
			static_cells.erase(i)

		# move keys above completed row 1 cell down
		var keys = static_cells.keys()
		keys.sort()
		keys.invert()
		for i in keys:
			var row_of_i: int = tetris_grid.x.x(i).row
			if row >= row_of_i:
				static_cells[i + c.COLUMNS] = static_cells[i]
				static_cells.erase(i)
	if completed_rows.size() > 0:
		emit_signal('row_completed', completed_rows, current)


func get_completed_rows() -> Array:
	var rows = []
	for i in current.indices:
		var row: int = tetris_grid.x.x(i).row
		var consecutive_counter = 0
		for j in tetris_grid.row_index[row]:
			if not j in static_cells.keys():
				break
			consecutive_counter += 1
		if consecutive_counter == tetris_grid.column_max:
			if not row in rows:
				rows.append(row)
	return rows


func spawn() -> void:
	queue.move_queue(current)
	if blink.is_active():
		blink.remove(current)
	md_timer.start()  # to reset


func move(v: Vector2) -> bool:
	var indices = current.indices
	for i in indices:
		if collision(v):
			return false
	current.position += v.x + v.y * c.COLUMNS
	return true


func move_down() -> void:
	if not move(Vector2.DOWN):
		emit_signal('bottom_reached')


func rotete(dir := 1) -> void:
	if current.name == 'O':
		return
	var next_rotation = current.rotation + dir
	if next_rotation == 4:
		next_rotation = 0
	if next_rotation == -1:
		next_rotation = 3

	if collision(Vector2.ZERO, next_rotation):
		return

	current.rotation = next_rotation


func drop() -> void:
	move(Vector2(0, get_current_lowest_possible_position() - 1))
	self.stop_counter = c.SETTINGS.STOP_COUNTER_MAX
	emit_signal('dropped', current)


func collision(v := Vector2.ZERO, next_rotation := current.rotation) -> bool:
	var next_indices = current.get_indices(v, next_rotation)

	# special case for I because it can wrap if vertical
	if current.name == 'I':
		for i in next_indices.size():
			if v.x:
				var current_cell = current.indices[i]
				var next_cell = next_indices[i]

				if (
					tetris_grid.x.x(current_cell).row
					!= tetris_grid.x.x(next_cell).row
				):
					return true

	var col_first = false
	var col_last = false
	for i in next_indices:
		# floor collision
		if i >= tetris_grid.size:
			return true

		# no wrapping
		var column = tetris_grid.x.x(i).column

		if column == 0:
			col_first = true
		elif column == tetris_grid.column_max - 1:
			col_last = true

		if col_first && col_last:
			return true

		# static cells collision
		if i in static_cells.keys():
			return true

	return false


func collision_roof() -> bool:
	for i in static_cells.keys():
		if i < c.ROWS_ABOVE * c.COLUMNS:
			return true
	return false


func paint_tetromino(tetromino: Tetromino) -> void:
	for i in tetromino.indices:
		paint(tetromino.grid, i, tetromino.color)


func paint_ghost() -> void:
	var lowest = get_current_lowest_possible_position()
	for index in current.get_indices(Vector2(0, lowest - 1)):
		paint(
			tetris_grid,
			index,
			c.COLORS[c.TETROMINOS[current.name].color + (c.COLORS.size() / 2)]
		)


func paint(grid: Grid, index: int, color: Color) -> void:
	if grid.x.scenes.has(index):
		grid.x.x(index).modulate = color
		grid.x.show_scene(index)


func inc_stop_counter() -> void:
	blink()
	self.stop_counter += 1


func blink() -> void:
	var color = current.color
	var duration = md_timer.wait_time / 2
	blink.interpolate_property(current, "color", color, Color.white, duration)
	blink.interpolate_property(current, "color", Color.white, color, duration)
	blink.start()


func calculate_score(completed_rows: Array, with_tetromino: Tetromino) -> int:
	for i in c.SCORE_DATA:
		if completed_rows.size() == i.completed_rows:
			if i.has('tetromino_name'):
				if with_tetromino.name == i.tetromino_name:
					if i.has('tetromino_rotation'):
						if with_tetromino.rotation == i.tetromino_rotation:
							return i.score
					else:
						return i.score
			else:
				return i.score
	return -1


func _on_md_timer_timeout() -> void:
	move_down()


func _on_bottom_reached() -> void:
	inc_stop_counter()


func _on_new_static() -> void:
	clear_rows()
	spawn()


func _on_row_completed(completed_rows: Array, with_tetromino: Tetromino) -> void:
	var score_addition = calculate_score(completed_rows, with_tetromino)
	print(score_addition)
	assert(score_addition != -1, 'calculate_score error')
	self.score += score_addition


func _set_stop_counter(new_value: int) -> void:
	if new_value >= c.SETTINGS.STOP_COUNTER_MAX:
		make_static()
		stop_counter = 0
	else:
		stop_counter = new_value


func _set_score(new_value: int) -> void:
	emit_signal('score_changed', score, new_value)
	score = new_value


onready var CONTROLS := {
	actions = {
		ui_right = {
			functions = ['move'],
			arguments = [Vector2.RIGHT],
			hold_enabled = true,
		},
		ui_left = {
			functions = ['move'],
			arguments = [Vector2.LEFT],
			hold_enabled = true,
		},
		ui_down = {
			functions = ['move'],
			arguments = [Vector2.DOWN],
			hold_enabled = true,
		},
		ui_up = {
			functions = ['move'],
			arguments = [Vector2.UP],
			hold_enabled = true,
		},
		ui_rotate_cw = {
			functions = ['rotete'],
			arguments = [1],
			hold_enabled = true,
		},
		ui_rotate_ccw = {
			functions = ['rotete'],
			arguments = [-1],
			hold_enabled = true,
		},
		ui_drop = {
			functions = ['drop'],
			arguments = [],
			hold_enabled = false,
		},
		ui_keep = {
			object = keep,
			functions = ['keep'],
			arguments = [current],
			hold_enabled = false,
		},
	},
}
