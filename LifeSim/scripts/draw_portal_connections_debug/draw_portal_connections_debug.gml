function draw_portal_connections_debug() {
    // Set up drawing properties for visibility
    draw_set_alpha(0.5);
    draw_set_color(c_lime); // Bright green lines for visibility
    var _line_width = 2;

    // Loop through all levels (maybe just level 0 for initial debugging)
    var _level_to_draw = 0; 
    var _clusters_lvl = global.clusters[_level_to_draw];
    
    for (var _cy = 0; _cy < array_length(_clusters_lvl); _cy++) {
        for (var _cx = 0; _cx < array_length(_clusters_lvl); _cx++) {
            
            var _current_cluster = _clusters_lvl[_cy][_cx];
            var _portals_list = _current_cluster.portals;
            var _connections_map = _current_cluster.portal_connections;
            
            if (array_length(_portals_list) < 2) continue;

            // Iterate through the connections map to draw the lines
           // var _key = ds_map_find_first(_connections_map);
			var _names = struct_get_names(_connections_map);
			//show_debug_message("_names: " + string(_names))
			//show_debug_message("_connections_map: " + string(_connections_map))
           // while (!is_undefined(_key)) {
		   for (var i = 0; i < array_length(_names); i ++){
			    var _name = _names[i];
                // The key is a string like "0_5"
                // Parse the key back into our portal indices (i, j)
                var _indices = string_split(_name, "_");
                var _p1_index = real(_indices[0]);
                var _p2_index = real(_indices[1]);

                var _p1 = _portals_list[_p1_index]; // Start Portal data
                var _p2 = _portals_list[_p2_index]; // End Portal data

                // Convert grid coordinates (cell_x, cell_y) to room coordinates (x, y) using your macro
                var _x1 = _p1.x * CELL_SIZE + CELL_SIZE/2; // Center of cell
                var _y1 = _p1.y * CELL_SIZE + CELL_SIZE/2;
                var _x2 = _p2.x * CELL_SIZE + CELL_SIZE/2;
                var _y2 = _p2.y * CELL_SIZE + CELL_SIZE/2;

                // Draw the line representing the pre-calculated path connection
                draw_line_width(_x1, _y1, _x2, _y2, _line_width);
                
               // _key = ds_map_find_next(_connections_map, _key);
			}
        }
    }
    draw_set_alpha(1.0); // Reset alpha
    draw_set_color(c_white); // Reset color
}
