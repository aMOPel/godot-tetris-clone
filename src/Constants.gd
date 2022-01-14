extends Node

const SETTINGS = {
	STOP_COUNTER_MAX = 4,
	MD_WAIT_TIME_START = 0.5,
}

const TILE = preload('res://src/Tile.tscn')

const ROWS := 20
const ROWS_ABOVE := 4
const COLUMNS := 10
const START_POS := 3

var CELL_X
var CELL_Y


func _init():
	var t = TILE.instance()
	var cell_rect = t.get_rect()
	t.free()
	CELL_X = cell_rect.position.x + cell_rect.size.x
	CELL_Y = cell_rect.position.y + cell_rect.size.y


const QUEUE_SIZE := 5
const QUEUE_GRID_POS := Vector2(14 * 16, 4 * 16)
const QUEUE_GRID_COLUMNS := 4
const QUEUE_GRID_ROWS := 14

const KEEP_GRID_POS := Vector2(-8 * 16, 6 * 16)
const KEEP_GRID_COLUMNS := 4
const KEEP_GRID_ROWS := 2

enum { YELLOW, ORANGE, RED, PURPLE, BLUE, TEAL, GREEN }
const COLORS := [
	Color('ffd700'),
	Color('ff7e00'),
	Color('d80000'),
	Color('6b00ec'),
	Color('2460ff'),
	Color('00b7c0'),
	Color('00b91d'),
	Color('70ffd700'),
	Color('70ff7e00'),
	Color('70d80000'),
	Color('706b00ec'),
	Color('702460ff'),
	Color('7000b7c0'),
	Color('7000b91d'),
]

const TETROMINOS := {
	I = {
		rotations = [
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
			[
				[0, 0, 0, 0],
				[0, 0, 0, 0],
				[1, 1, 1, 1],
				[0, 0, 0, 0],
			],
		],
		color = TEAL,
		start_offset = 0,
		queue_offset = 0,
	},
	O = {
		rotations = [
			[
				[1, 1],
				[1, 1],
			],
			[
				[1, 1],
				[1, 1],
			],
			[
				[1, 1],
				[1, 1],
			],
			[
				[1, 1],
				[1, 1],
			],
		],
		color = YELLOW,
		start_offset = 2 * COLUMNS + 1,
		queue_offset = 0 * QUEUE_GRID_COLUMNS + 1,
	},
	T = {
		rotations = [
			[
				[0, 0, 1],
				[0, 1, 1],
				[0, 0, 1],
			],
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
		],
		color = PURPLE,
		start_offset = 1 * COLUMNS,
		queue_offset = -1 * QUEUE_GRID_COLUMNS,
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
		start_offset = 1 * COLUMNS,
		queue_offset = -1 * QUEUE_GRID_COLUMNS,
	},
	J = {
		rotations = [
			[
				[0, 1, 1],
				[0, 1, 0],
				[0, 1, 0],
			],
			[
				[0, 0, 0],
				[1, 1, 1],
				[0, 0, 1],
			],
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
		],
		color = BLUE,
		start_offset = 1 * COLUMNS,
		queue_offset = -1 * QUEUE_GRID_COLUMNS,
	},
	Z = {
		rotations = [
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
			[
				[1, 1, 0],
				[0, 1, 1],
				[0, 0, 0],
			],
		],
		color = RED,
		start_offset = 1 * COLUMNS,
		queue_offset = -1 * QUEUE_GRID_COLUMNS,
	},
	S = {
		rotations = [
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
			[
				[0, 1, 1],
				[1, 1, 0],
				[0, 0, 0],
			],
		],
		color = GREEN,
		start_offset = 1 * COLUMNS,
		queue_offset = -1 * QUEUE_GRID_COLUMNS,
	},
}

const QUEUE := [
	{
		position = 0 * QUEUE_GRID_COLUMNS,
	},
	{
		position = 3 * QUEUE_GRID_COLUMNS,
	},
	{
		position = 6 * QUEUE_GRID_COLUMNS,
	},
	{
		position = 9 * QUEUE_GRID_COLUMNS,
	},
	{
		position = 12 * QUEUE_GRID_COLUMNS,
	},
]

const SCORE_DATA = [
	{
		completed_rows = 1,
		score = 100,
	},
	{
		completed_rows = 2,
		score = 300,
	},
	{
		completed_rows = 3,
		score = 600,
	},
	{
		completed_rows = 4,
		score = 1000,
	},
]
