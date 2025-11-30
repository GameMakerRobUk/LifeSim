function get_cluster_at_coords(_cell_x, _cell_y, _level) {
    //var _csize = global.cluster_sizes[_level];
    //var _cluster_x = floor(_cx / _csize);
    //var _cluster_y = floor(_cy / _csize);
    // Add boundary checks here if needed, but assuming valid input for now
    if (_cell_x < 0 || _cell_x >= array_length(global.clusters[_level][0])) return noone;
    if (_cell_y < 0 || _cell_y >= array_length(global.clusters[_level])) return noone;
	
    return global.clusters[_level][_cell_y][_cell_x];
}

function heuristic_euclidian(_portal, _end_x_cell, _end_y_cell) {
    return point_distance(_portal.cell_x, _portal.cell_y, _end_x_cell, _end_y_cell);
}

function find_path_hpa_high_level(_start_cell_x, _start_cell_y, _end_cell_x, _end_cell_y) {
	show_debug_message("!!! find_path_hpa_high_level")
    var _level_index = 0; // HPA* usually runs on the lowest/finest level abstraction first

    var _start_cluster = get_cluster_at_coords(_start_cell_x, _start_cell_y, _level_index);
    var _end_cluster   = get_cluster_at_coords(_end_cell_x, _end_cell_y, _level_index);

    if (_start_cluster == noone || _end_cluster == noone || _start_cluster == _end_cluster) {
        return { path_found: true, high_level_path: [] }; // Already in same cluster
    }
	
	show_debug_message("_start_cluster: " + " | level: " + string(_start_cluster.level) + " | cell_x: " + string(_start_cluster.cell_x) + " | cell_y: " + string(_start_cluster.cell_y))
	show_debug_message("_end_cluster: " + " | level: " + string(_end_cluster.level) + " | cell_x: " + string(_end_cluster.cell_x) + " | cell_y: " + string(_start_cluster.cell_y))

    var _open_list   = ds_priority_create();
    var _portal_data = ds_map_create(); 

    // ---------------------------------------------------------
    // START PORTALS: Initialize the search
    // ---------------------------------------------------------
    var _start_portals = _start_cluster.portals;
    for (var i = 0; i < array_length(_start_portals); i++) {
        var _p = _start_portals[i];

        var _data = {
            portal: _p, // The destination portal for this step
            from_cluster: _start_cluster,
            to_cluster: _p.to_cluster,
            g_cost: 0, 
            f_cost: point_distance(_p.cell_x, _p.cell_y, _end_cell_x, _end_cell_y), // Heuristic from portal to end
            parent_key: noone 
        };

        ds_priority_add(_open_list, _p.id, _data.f_cost); // Add ID to priority queue
        ds_map_add(_portal_data, _p.id, _data); // Use unique ID as key for data map
    }

    // ---------------------------------------------------------
    // MAIN LOOP
    // ---------------------------------------------------------
    while (!ds_priority_empty(_open_list)) {

        var _current_portal_id = ds_priority_delete_min(_open_list);
        var _current_data      = _portal_data[? _current_portal_id];
        var _current_portal    = _current_data.portal;
        var _entering_cluster  = _current_data.to_cluster; // The cluster we just entered

        // Reached goal?
        if (_entering_cluster == _end_cluster) {
            var _high_level_path = [];
            var _curr_data = _current_data;

            // Trace back the path. The previous portal becomes the 'entry' to this cluster.
            while (_curr_data.parent_key != noone) {
                var _parent_data = _portal_data[? _curr_data.parent_key];
                
                // --- FIX 1: Populate the high-level path segment correctly ---
                array_insert(_high_level_path, 0, {
                    cluster:     _curr_data.from_cluster, // The cluster containing this segment
                    entry_portal: _parent_data.portal,    // The portal we came *from*
                    exit_portal:  _curr_data.portal       // The portal we are going *to*
                });
                _curr_data = _parent_data;
            }
            
            ds_priority_destroy(_open_list);
            ds_map_destroy(_portal_data);
            return { path_found: true, high_level_path: _high_level_path };
        }

        // ---------------------------------------------------------
        // EXPLORE NEIGHBOR PORTALS IN THIS CLUSTER
        // ---------------------------------------------------------
        var _neighbors = _entering_cluster.portals;

        for (var j = 0; j < array_length(_neighbors); j++) {
            var _nbr = _neighbors[j];
            
            // --- FIX 2: Use the precomputed cost from our cache for A* G-cost calculation ---
            // We need the *full path coordinate array* lookup to work now. 
			show_debug_message("_current_portal.id: " + string(_current_portal.id));
			show_debug_message("_nbr.id: " + string(_nbr.id));
            var _cached_path_coords = get_cached_portal_path(_entering_cluster, _current_portal.id, _nbr.id);
            
            if (_cached_path_coords == undefined) {
                continue; // Cannot traverse between these two portals (e.g., blocked path inside cluster)
            }
            
            // The cost is the length of the cached path
            var _move_cost_from_cache = array_length(_cached_path_coords);

            var _new_g = _current_data.g_cost + _move_cost_from_cache; 

            var _nbr_id = _nbr.id;
            if (!ds_map_exists(_portal_data, _nbr_id) || _new_g < _portal_data[? _nbr_id].g_cost) {
                
                var _data2 = {
                    portal: _nbr,
                    from_cluster: _entering_cluster,
                    to_cluster: _nbr.to_cluster,
                    g_cost: _new_g,
                    f_cost: _new_g + point_distance(_nbr.cell_x, _nbr.cell_y, _end_cell_x, _end_cell_y), 
                    parent_key: _current_portal.id 
                };
                
                // Add or update the portal data
                if (!ds_map_exists(_portal_data, _nbr_id)) {
                    ds_map_add(_portal_data, _nbr_id, _data2);
                } else {
                    ds_map_replace(_portal_data, _nbr_id, _data2); // Simpler replacement using ds_map_replace
                }
                
                ds_priority_add(_open_list, _nbr.id, _data2.f_cost);
            }
        }
    }

    ds_priority_destroy(_open_list);
    ds_map_destroy(_portal_data);
    return { path_found: false, high_level_path: [] };
}
