function Cluster(_level, _cell_x, _cell_y) constructor{
	static count = 0;
    level = _level;
    cell_x = _cell_x;
    cell_y = _cell_y;
    cells = [];
	portals = [];
	portal_connections = {};
	id = "cluster_" + string(count);
	count ++;
}