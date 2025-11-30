draw_set_alpha(0.5);

for (var i = 0; i < array_length(path); i++) {
    var _cx = path[i].cell_x;
    var _cy = path[i].cell_y;

    draw_set_color(c_lime);
    draw_rectangle(
        _cx * CELL_SIZE,
        _cy * CELL_SIZE,
        _cx * CELL_SIZE + (CELL_SIZE - 1),
        _cy * CELL_SIZE + (CELL_SIZE - 1),
        false
    );
}

draw_set_alpha(1);