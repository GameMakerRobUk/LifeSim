function generate_portal_connections() {
    // Loop through all levels of the hierarchy
    for (var _level = 0; _level < array_length(global.clusters); _level++) {
        
        var _clusters_lvl = global.clusters[_level];
        
        // Loop through all clusters in this level
        for (var _cell_y = 0; _cell_y < array_length(_clusters_lvl); _cell_y++) {
            for (var _cell_x = 0; _cell_x < array_length(_clusters_lvl[0]); _cell_x++) {
                
                var _current_cluster = _clusters_lvl[_cell_y][_cell_x];
                var _portals = _current_cluster.portals;

                // Ensure the connection storage struct exists
                if (!is_struct(_current_cluster.portal_connections)) {
                     _current_cluster.portal_connections = {}; 
                }
                
                // We need at least two portals to form a connection
                if (array_length(_portals) < 2) continue;
                
                // Iterate through every pair of portals (P1 is the start, P2 is the end)
                for (var i = 0; i < array_length(_portals); i++) {
                    var _p1 = _portals[i]; // Start Portal
                    
                    for (var j = 0; j < array_length(_portals); j++) {
                        var _p2 = _portals[j]; // End Portal
                        
                        // Don't calculate path from a portal to itself
                        if (_p1 == _p2) continue;
                        
                        // Use the unique IDs created in the Portal constructor for a reliable key
                        var _conn_key = _p1.id + "_" + _p2.id; 
                        
                        if (variable_struct_exists(_current_cluster.portal_connections, _conn_key)) {
                            continue; // Skip if already calculated
                        }

                        // --- RUN YOUR LOW-LEVEL A* HERE (expensive operation) ---
                        var _path_coords_array = find_path(_p1.cell_x, _p1.cell_y, _p2.cell_x, _p2.cell_y);
                        
                        if (array_length(_path_coords_array) > 0) {
                            // --- FIX: STORE THE FULL COORDINATE ARRAY ---
                            struct_set(_current_cluster.portal_connections, _conn_key, _path_coords_array);
                            
                            // You can discard the cost calculation here unless you need it for high-level A* heuristics
                            // var _cost = array_length(_path_coords_array); 
                        }
                    }
                }
				
				//show_debug_message("_current_cluster.portal_connections: " + string(_current_cluster.portal_connections))
            }
        }
    }
}

