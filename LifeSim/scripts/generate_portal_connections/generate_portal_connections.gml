function generate_portal_connections() {
    // Loop through all levels of the hierarchy
    for (var _level = 0; _level < array_length(global.clusters); _level++) {
        
        var _clusters_lvl = global.clusters[_level];
        
        // Loop through all clusters in this level
        for (var _cy = 0; _cy < array_length(_clusters_lvl); _cy++) {
            for (var _cx = 0; _cx < array_length(_clusters_lvl[0]); _cx++) {
                
                var _current_cluster = _clusters_lvl[_cy][_cx];
                var _portals = _current_cluster.portals;
                
                // We need at least two portals to form a connection
                if (array_length(_portals) < 2) continue;
                
                // Iterate through every pair of portals (P1 is the start, P2 is the end)
                for (var i = 0; i < array_length(_portals); i++) {
                    var _p1 = _portals[i]; // Start Portal
                    
                    for (var j = 0; j < array_length(_portals); j++) {
                        var _p2 = _portals[j]; // End Portal
                        
                        // Don't calculate path from a portal to itself
                        if (_p1 == _p2) continue;
                        
                        // Check if we've already calculated this path (optional optimization)
                        // A unique key for this connection pair is useful
                        var _conn_key = string(i) + "_" + string(j); 
                        if (_current_cluster.portal_connections[$ _conn_key] != undefined) {
                            continue; 
                        }

                        // --- RUN YOUR LOW-LEVEL A* HERE ---
                        // We use the coordinates of the portals to find the path INSIDE the cluster
                        var _path = find_path(_p1.x, _p1.y, _p2.x, _p2.y);
                        
                        if (array_length(_path) > 0) {
                            // Path found! Store the cost (G-cost = length of the path * average move cost)
                            // A* returns an array of coordinates, we can approximate the cost 
                            // by the number of steps, or run the A* code inline to get exact G-cost.
                            // For simplicity here, we'll store the length of the coordinate list
                            var _cost = array_length(_path); 

                            // Store the cost in the cluster's connection map
                            struct_set(_current_cluster.portal_connections, _conn_key, _cost);
                            
                            // NOTE: You might also want to store the reverse path j_i if you don't assume symmetry
                        }
                    }
                }
            }
        }
    }
}
