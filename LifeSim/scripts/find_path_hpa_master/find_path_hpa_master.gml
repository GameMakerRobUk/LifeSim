function array_flatten(_array_of_arrays) {
    var _flat = [];
    for (var i = 0; i < array_length(_array_of_arrays); i++) {
        var _sub_array = _array_of_arrays[i];
        for (var j = 0; j < array_length(_sub_array); j++) {
            array_push(_flat, _sub_array[j]);
        }
    }
    return _flat;
}

function find_path_hpa_master(_start_cell_x, _start_cell_y, _end_cell_x, _end_cell_y) {
	show_debug_message("!!! find_path_hpa_master")
	show_debug_message("[" + string(_start_cell_x) + "," + string(_start_cell_y) + "] > [" + string(_end_cell_x) + "," + string(_end_cell_y) + "]")
    var _final_path = [];
    var _hpa_result = find_path_hpa_high_level(_start_cell_x, _start_cell_y, _end_cell_x, _end_cell_y);
    
    if (!_hpa_result.path_found) {
        return _final_path;
    }
    
    var _high_level_path_segments = _hpa_result.high_level_path;
    
    // Case A: Start and end are in the same cluster
    if (array_length(_high_level_path_segments) == 0) {
        _final_path = find_path(_start_cell_x, _start_cell_y, _end_cell_x, _end_cell_y);
        return _final_path;
    }
    
    // Case B: Traversing multiple clusters
    var _current_cell_x = _start_cell_x;
    var _current_cell_y = _start_cell_y;
    var _all_segments = []; 

    // Iterate through the sequence of high-level 'steps' provided by the high-level A*
    for (var i = 0; i < array_length(_high_level_path_segments); i++) {
        var _segment_data = _high_level_path_segments[i];
        
        var _entry_portal  = _segment_data.entry_portal; 
        var _exit_portal   = _segment_data.exit_portal;  
        var _current_cluster = _segment_data.cluster; 

        var _path_segment;

        // If this is the first segment, the start point is the player's actual location
        if (i == 0) {
            // Must run low-level A* ONCE for start to the first entry portal
            _path_segment = find_path(_current_cell_x, _current_cell_y, _exit_portal.cell_x, _exit_portal.cell_y);
        } else {
            // We have both an entry and exit portal for an internal cluster traverse
            // --- THE OPTIMIZATION: USE CACHED PATHS FOR INTER-PORTAL TRAVEL ---
			show_debug_message("_entry_portal.id: " + string(_entry_portal.id));
			show_debug_message("_exit_portal.id: " + string(_exit_portal.id));
            _path_segment = get_cached_portal_path(_current_cluster, _entry_portal.id, _exit_portal.id);
        }
        
        if (_path_segment == undefined || array_length(_path_segment) == 0) {
            show_debug_message("HPA* Stitching failed due to missing path segment.");
            return []; // Pathfinding failed
        }

        array_push(_all_segments, _path_segment);
        
        // Update current position to the location of the exit portal for the next iteration
        _current_cell_x = _exit_portal.cell_x;
        _current_cell_y = _exit_portal.cell_y;
    }
    
    // --- Add the final segment from the last portal to the final destination ---
    // This *must* be calculated fresh every time using low-level A*
    var _path_segment_final = find_path(_current_cell_x, _current_cell_y, _end_cell_x, _end_cell_y);
    array_push(_all_segments, _path_segment_final);
    
    // Flatten the array of segments into one long list of coordinates (as before)
    _final_path = array_flatten(_all_segments);
    
    // Filter out consecutive duplicate points (optional cleanup)
    var _unique_path = [];
    if (array_length(_final_path) > 0) {
        array_push(_unique_path, _final_path[0]);
        for (var i = 1; i < array_length(_final_path); i++) {
            var _prev = _final_path[i-1];
            var _curr = _final_path[i];
            if (_curr.x != _prev.x || _curr.y != _prev.y) {
                array_push(_unique_path, _curr);
            }
        }
    }
    
    return _unique_path;
}
