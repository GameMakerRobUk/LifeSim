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

function find_path_hpa_master(_start_x, _start_y, _end_x, _end_y) {
    show_debug_message("find_path_hpa_master")
    var _final_path = [];
    var _hpa_result = find_path_hpa_high_level(_start_x, _start_y, _end_x, _end_y);
    
    if (!_hpa_result.path_found) {
        return _final_path;
    }
    
    var _high_level_path = _hpa_result.high_level_path;
    
    // Case A: Start and end are in the same cluster
    if (array_length(_high_level_path) == 0) {
        _final_path = find_path(_start_x, _start_y, _end_x, _end_y);
        return _final_path;
    }
    
    // Case B: Traversing multiple clusters
    var _current_x = _start_x;
    var _current_y = _start_y;
    var _all_segments = []; // Store segments here first

    // Iterate through the sequence of clusters we must visit
    for (var i = 0; i < array_length(_high_level_path); i++) {
        var _segment = _high_level_path[i];
        var _exit_portal = _segment.exit_portal;
        
        // Find path from current location to the exit portal of this cluster
        var _path_segment = find_path(_current_x, _current_y, _exit_portal.x, _exit_portal.y);
        
        // Add the segment
        array_push(_all_segments, _path_segment);
        
        // Update current position to the location of the exit portal for the next iteration
        _current_x = _exit_portal.x;
        _current_y = _exit_portal.y;
    }
    
    // --- 3. Add the final segment from the last portal to the final destination ---
    var _path_segment = find_path(_current_x, _current_y, _end_x, _end_y);
    array_push(_all_segments, _path_segment);
    
    // Flatten the array of segments into one long list of coordinates
    _final_path = array_flatten(_all_segments);

    // Filter out consecutive duplicate points (the stitching points)
    var _unique_path = [];
    if (array_length(_final_path) > 0) {
        array_push(_unique_path, _final_path[0]);
        for (var i = 1; i < array_length(_final_path); i++) {
            var _prev = _final_path[i-1];
            var _curr = _final_path[i];
            // Check if current coordinate is identical to the last one pushed
            if (_curr.x != _prev.x || _curr.y != _prev.y) {
                array_push(_unique_path, _curr);
            }
        }
    }
    
    //show_debug_message("_unique_path: " + string(_unique_path));
    return _unique_path;
}
