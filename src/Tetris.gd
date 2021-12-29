extends Node2D

const CELL_SIZE := 16
const START_POS := 5
var grid := []
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
var tile := preload('res://src/Tile.tscn')

onready var md_timer = $MoveDownTimer

onready var x := XScene.new(self, false, {count_start = 0})

const shapes := {
	L = {
		rotations = [
			[0, 1, 2, 3],
			[0, 10, 20, 30],
			[],
			[],
		],
		color = TEAL,
	},
	T = {
		rotations = [
			[1, 10, 11, 12],
			[],
			[],
			[],
		],
		color = PURPLE,
	}
}

var current := {
	shape = '',
	positions = [],
	rotation = 0,
}

var static_cells = {}

func _ready():
	md_timer.connect('timeout', self, 'move_down')
	x.defaults.method_add = x.HIDDEN
	var coords = make_coords(10,20)
	for i in 200:
		x.add_scene(tile)
		x.x(i).position = coords[i]
		
	spawn('L')
	move(Vector2(0,10))
	make_static()
	spawn('L')

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

func spawn(shape: String):
	current.shape = shape
	current.positions = []
	for i in shapes[shape].rotations[0]:
		current.positions.append(i + START_POS)

func rotate():
	positions = []
	for i in 

	for i in current.positions:
		if collision(i, v):
			return
func make_static():
	for i in current.positions:
		static_cells[i] = shapes[current.shape].color

func move(v: Vector2):
	for i in current.positions:
		if collision(i, v):
			return
	for i in current.positions.size():
		current.positions[i] += v.x + v.y * 10

func move_down():
	move(Vector2.DOWN)

# func rotation(rot: int):


func collision(i: int, v: Vector2) -> bool:
	var row = i / 10
	# no wrapping
	if v.x:
		if int(i + v.x) / 10 != row:
			return true
	# floor collision
	if v.y:
		if (i + v.y * 10) / 10 >= 20:
			return true
	# static cells collision
	if (i + v.x + v.y * 10) in static_cells.keys():
		return true

	return false

func paint_current():
	for i in current.positions:
		paint(i, shapes[current.shape].color)

func paint(index: int, color: int):
	x.x(index).modulate = colors[color]
	x.show_scene(index)


func make_coords(x_max: int, y_max: int):
	var coords = []

	var y = 0
	for i in y_max:
		var x = 0
		for j in x_max:
			coords.append(Vector2(x,y))
			x += CELL_SIZE
		y += CELL_SIZE

	return coords



# [node name="Sprite" parent="." instance=ExtResource( 3 )]
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 0 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 0 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 0 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 0 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 0 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 0 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 0 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 0 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 0 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 16 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 16 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 16 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 16 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 16 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 16 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 16 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 16 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 16 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 16 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 32 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 32 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 32 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 32 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 32 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 32 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 32 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 32 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 32 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 32 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 48 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 48 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 48 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 48 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 48 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 48 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 48 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 48 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 48 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 48 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 64 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 64 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 64 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 64 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 64 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 64 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 64 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 64 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 64 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 64 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 80 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 80 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 80 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 80 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 80 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 80 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 80 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 80 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 80 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 80 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 96 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 96 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 96 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 96 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 96 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 96 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 96 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 96 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 96 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 96 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 112 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 112 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 112 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 112 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 112 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 112 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 112 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 112 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 112 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 112 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 128 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 128 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 128 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 128 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 128 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 128 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 128 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 128 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 128 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 128 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 144 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 144 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 144 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 144 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 144 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 144 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 144 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 144 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 144 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 144 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 160 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 160 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 160 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 160 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 160 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 160 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 160 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 160 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 160 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 160 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 176 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 176 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 176 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 176 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 176 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 176 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 176 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 176 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 176 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 176 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 192 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 192 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 192 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 192 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 192 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 192 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 192 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 192 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 192 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 192 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 208 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 208 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 208 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 208 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 208 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 208 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 208 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 208 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 208 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 208 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 224 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 224 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 224 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 224 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 224 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 224 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 224 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 224 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 224 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 224 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 240 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 240 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 240 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 240 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 240 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 240 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 240 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 240 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 240 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 240 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 256 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 256 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 256 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 256 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 256 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 256 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 256 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 256 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 256 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 256 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 272 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 272 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 272 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 272 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 272 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 272 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 272 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 272 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 272 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 272 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 288 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 288 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 288 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 288 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 288 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 288 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 288 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 288 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 288 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 288 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 0, 304 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 16, 304 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 32, 304 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 48, 304 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 64, 304 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 80, 304 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 96, 304 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 112, 304 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 128, 304 )
#
# [node name="Sprite" parent="." instance=ExtResource( 3 )]
# position = Vector2( 144, 304 )
