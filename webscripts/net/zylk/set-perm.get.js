var nref   = search.findNode(args.noderef);
var user   = args.user;
var role   = args.role; 

nref.setPermission(role, user);

var res    = nref.displayPath+"/"+nref.name + ";" + user + ";" + role;

logger.warn(res);

model.res  = res;