package xonix

import rl "vendor:raylib"

WINDOW_WIDTH :: 1280
WINDOW_HEIGHT :: 720
WINDOW_TITLE :: "Xonix"
FPS :: 60

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
	rl.SetTargetFPS(FPS)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground({0x0, 0x8f, 0xff, 0xff})
		rl.EndDrawing()
	}
	rl.CloseWindow()
}
