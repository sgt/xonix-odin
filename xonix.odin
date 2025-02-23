package xonix

import "core:dynlib"
import "core:slice"
import rl "vendor:raylib"

// ** Constants

HUD_HEIGHT :: 30
GRID_WIDTH :: 160
GRID_HEIGHT :: 90
CELL_SIZE :: 10
INITIAL_AREA_WIDTH :: 2

WINDOW_TITLE :: "Xonix"
FPS :: 60
BG_COLOUR :: rl.BLACK
CAPTURED_AREA_COLOUR :: rl.GRAY
ENEMY_COLOUR :: rl.ORANGE
PLAYER_COLOUR :: rl.WHITE

NUM_OF_ENEMIES :: 3
PERCENT_TO_WIN :: 90

// ** Types

Grid :: [GRID_HEIGHT][GRID_WIDTH]Cell

Player :: struct {
	position:  rl.Vector2,
	direction: rl.Vector2,
}

Enemy :: struct {
	position:  rl.Vector2,
	direction: rl.Vector2,
}

Cell :: enum u8 {
	Unclaimed,
	Claimed,
}

Game :: struct {
	player:  Player,
	enemies: [NUM_OF_ENEMIES]Enemy,
	grid:    Grid,
}

init_grid :: proc(grid: ^Grid) {
	for i in 0 ..< GRID_HEIGHT {
		row := grid[i][:]
		switch i {
		case 0, 1, GRID_HEIGHT - 2, GRID_HEIGHT - 1:
			slice.fill(row, Cell.Claimed)
		case:
			{
				row[0] = .Claimed
				row[1] = .Claimed
				row[GRID_WIDTH - 2] = .Claimed
				row[GRID_WIDTH - 1] = .Claimed
			}
		}
	}
}

init_game :: proc(game: ^Game) {
	game.player = {
		position = {GRID_WIDTH / 2, 0},
	}
	init_grid(&game.grid)
}

draw_board_cell :: proc(position: rl.Vector2, colour: rl.Color) {
	pos := position * CELL_SIZE
	pos.y += HUD_HEIGHT
	rl.DrawRectangleV(pos, {CELL_SIZE, CELL_SIZE}, colour)
}

read_input :: proc(game: ^Game) {
	switch {
	case rl.IsKeyDown(.W) || rl.IsKeyDown(.UP):
		game.player.direction = {0, -1}
	case rl.IsKeyDown(.S) || rl.IsKeyDown(.DOWN):
		game.player.direction = {0, 1}
	case rl.IsKeyDown(.A) || rl.IsKeyDown(.LEFT):
		game.player.direction = {-1, 0}
	case rl.IsKeyDown(.D) || rl.IsKeyDown(.RIGHT):
		game.player.direction = {1, 0}
	case:
		game.player.direction = {0, 0}
	}
}

move_actors :: proc(game: ^Game) {
	game.player.position += game.player.direction * rl.GetFrameTime() * FPS / 10
}

render_hud :: proc(game: ^Game) {
	rl.DrawText("meow", 10, 2, 26, rl.PINK)
}

render_board :: proc(game: ^Game) {
	for row in 0 ..< GRID_HEIGHT {
		for col in 0 ..< GRID_WIDTH {
			cell := game.grid[row][col]
			colour := cell == .Unclaimed ? BG_COLOUR : CAPTURED_AREA_COLOUR
			draw_board_cell({f32(col), f32(row)}, colour)
		}
	}

	draw_board_cell(game.player.position, PLAYER_COLOUR)

	for enemy in game.enemies {
		draw_board_cell(enemy.position, ENEMY_COLOUR)
	}
}

main :: proc() {
	game: Game
	init_game(&game)

	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT, .WINDOW_HIGHDPI})
	window_width: i32 = GRID_WIDTH * CELL_SIZE
	window_height: i32 = HUD_HEIGHT + GRID_HEIGHT * CELL_SIZE
	rl.InitWindow(window_width, window_height, WINDOW_TITLE)
	defer rl.CloseWindow()
	rl.SetTargetFPS(FPS)

	for !rl.WindowShouldClose() {
		read_input(&game)
		rl.BeginDrawing()
		move_actors(&game)
		render_hud(&game)
		render_board(&game)
		defer rl.EndDrawing()
	}
}
