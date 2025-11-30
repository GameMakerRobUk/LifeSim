function Portal(_x, _y, _to_cluster, _side) constructor{
	static count = 0;
	x = _x;
	y = _y;
	to_cluster = _to_cluster;
	side = _side;
	id = "portal_" + string(count);
	count ++;
}
