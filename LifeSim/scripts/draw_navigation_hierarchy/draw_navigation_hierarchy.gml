function draw_navigation_hierarchy(_level_to_display) {
    var _lvl = _level_to_display;
    if (_lvl >= array_length(global.clusters)) {
        show_debug_message("Invalid level specified for drawing: " + string(_lvl));
        return;
    }

    var _csize = global.cluster_sizes[_lvl];
    var _clusters = global.clusters[_lvl];
    // We get the array lengths dynamically
    var _rows = array_length(_clusters);
    var _cols = array_length(_clusters[0]); // Assumes at least one column exists
    var _cell_size = CELL_SIZE; // Assumes CELL_SIZE is a defined macro

    // 1. Draw Cluster Boundaries
    draw_set_color(c_white);
    draw_set_alpha(0.5);
    for (var _cy = 0; _cy < _rows; _cy++) {
        for (var _cx = 0; _cx < _cols; _cx++) {
            var _clust = _clusters[_cy][_cx];
            var _x1 = _cx * _csize * _cell_size;
            var _y1 = _cy * _csize * _cell_size;
            var _width = min(_csize, global.cells_h - _cx * _csize) * _cell_size;
            var _height = min(_csize, global.cells_v - _cy * _csize) * _cell_size;

            // Draw rectangle outline for the cluster boundary
            draw_rectangle(_x1, _y1, _x1 + _width, _y1 + _height, true);
        }
    }

    // 2. Draw Portals
    draw_set_alpha(1.0);
    for (var _cy = 0; _cy < _rows; _cy++) {
        for (var _cx = 0; _cx < _cols; _cx++) {
            var _clust = _clusters[_cy][_cx];

            // Change color based on the level for clarity
            if (_lvl == 0) draw_set_color(c_fuchsia);
            else if (_lvl == 1) draw_set_color(c_aqua);
            else if (_lvl == 2) draw_set_color(c_lime);
            else draw_set_color(c_orange);

            var _portal_list = _clust.portals;
            // Use a standard GML for loop to iterate through the portals array
            for (var _i = 0; _i < array_length(_portal_list); _i++) {
                var _p = _portal_list[_i];
                
                // Portals are single cells on the boundary. Draw a small filled rectangle.
                var _px = _p.x * _cell_size;
                var _py = _p.y * _cell_size;
                var _p_size = 4; // Size of the drawn portal indicator

                // Adjust drawing position slightly to center the indicator
                draw_rectangle(_px + (_cell_size - _p_size) / 2,
                               _py + (_cell_size - _p_size) / 2,
                               _px + (_cell_size + _p_size) / 2,
                               _py + (_cell_size + _p_size) / 2,
                               false); // false for filled
            }
        }
    }
    draw_set_color(c_white); // Reset draw color
    draw_set_alpha(1.0);     // Reset alpha
}