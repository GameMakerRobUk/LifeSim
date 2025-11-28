function Cluster(_level, _cx, _cy) constructor{
	static count = 0;
    level = _level;
    cell_x = _cx;
    cell_y = _cy;
    cells = [];
	portals = [];
	portal_connections = {};
	id = "cluster_" + string(count);
	count ++;
}