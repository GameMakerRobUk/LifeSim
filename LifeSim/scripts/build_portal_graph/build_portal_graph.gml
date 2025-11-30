// Call once after detect_portals_for_level(_lvl) and after clusters are created
function build_portal_graph(_lvl) {
    var _clusters = global.clusters[_lvl];
    var _rows = array_length(_clusters);
    var _cols = array_length(_clusters[0]);

    // Ensure global portal counter exists (only for unique ids if you want them)
    if (!variable_global_exists("_portal_uid_counter")) global._portal_uid_counter = 0;

    for (var _cy = 0; _cy < _rows; _cy++) {
        for (var _cx = 0; _cx < _cols; _cx++) {
            var _clust = _clusters[_cy][_cx];

            // Prepare container for actual stored paths (array of points) for each portal pair
            // Keep the existing portal_connections for numeric costs; add portal_connection_paths for arrays
            if (!is_undefined(_clust.portal_connection_paths) == false) {
                _clust.portal_connection_paths = {};
            }

            var _portals = _clust.portals;
            var _plen = array_length(_portals);

            // give each portal a stable id/index in the cluster if not already present
            for (var i = 0; i < _plen; i++) {
                var _p = _portals[i];
                if (is_undefined(_p.__cluster_index)) _p.__cluster_index = i;
                if (is_undefined(_p.id)) {
                    _p.id = "portal_" + string(global._portal_uid_counter);
                    global._portal_uid_counter += 1;
                }
            }

            // compute shortest path (low-level A*) between every pair of portals inside this cluster
            // store both cost and actual path so we can reuse them when stitching
            for (var a = 0; a < _plen; a++) {
                for (var b = 0; b < _plen; b++) {
                    if (a == b) continue;
                    var _pa = _portals[a];
                    var _pb = _portals[b];

                    // key: "a_b"
                    var _key = string(a) + "_" + string(b);

                    // If cost already exists (maybe from previous build), skip recompute
                    if (!is_undefined(_clust.portal_connections) && !is_undefined(_clust.portal_connections[$ _key])) {
                        // nothing
                    } else {
                        // compute the low-level path inside the cluster between portal coords
                        var _path = find_path(_pa.x, _pa.y, _pb.x, _pb.y);

                        if (array_length(_path) > 0) {
                            var _cost = max(1, array_length(_path) - 1);
                            if (is_undefined(_clust.portal_connections)) _clust.portal_connections = {};
                            _clust.portal_connections[$ _key] = _cost;
                            _clust.portal_connection_paths[$ _key] = _path;
                        } else {
                            // no connection (should be rare if portals are valid)
                            if (is_undefined(_clust.portal_connections)) _clust.portal_connections = {};
                            _clust.portal_connections[$ _key] = undefined;
                            _clust.portal_connection_paths[$ _key] = undefined;
                        }
                    }
                }
            }
        }
    }
}
