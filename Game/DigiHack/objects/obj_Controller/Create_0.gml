// Initialize globals only if they don’t exist yet
if (!variable_global_exists("points"))    global.points = 0;
if (!variable_global_exists("currency"))  global.currency = 0;
if (!variable_global_exists("game_paused")) global.game_paused = false;

if (!variable_global_exists("points")) {
    global.points = 0;
}
