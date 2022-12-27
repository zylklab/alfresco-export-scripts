var myproj = args.proj; 
var myuser = args.user || "johndoe"; 
var myrole = args.role || "SiteManager"; 

function GetFolder(folder, user, role){
  var mypath = folder.displayPath + "/" + folder.name;
  var myrow  = mypath + ";" + user + ";" + role + ";" + folder.nodeRef;
  //logger.log(myrow);
  return myrow;
}

var project = search.findNode(myproj);
var mynodes = new Array();

var q       = 'TYPE:"cm:folder" AND NOT TYPE:"cm:systemfolder" AND NOT TYPE:"fm:forum" AND PATH:"'+project.qnamePath;
var depth   = 0;

while (currentQuery != 0){
    depth = depth + 1;            
    var pageSize        = 1000;
    var currentPage     = 0;
    var currentPageSize = -1;
    var paging          = { maxItems: pageSize, skipCount: 0 };
    var myquery         = q+'/*';
    var def             = { query: myquery+'"', store: 'workspace://SpacesStore', language: 'fts-alfresco', page: paging };
    var currentQuery    = 0;

    //logger.log("Depth: "+depth);
    while (currentPageSize != 0) {
      
      paging.skipCount = currentPage * pageSize; 
      var nodes        = search.query(def);
      currentPage      = currentPage + 1;
      currentPageSize  = (null != nodes ? nodes.length : 0);
      if (currentPageSize > 0) {
        for each(var node in nodes) {
          var aux = GetFolder(node, myuser, myrole);
          mynodes.push(aux);
        }  
      }
      		
	  //logger.log(nodes.length);
	  currentQuery = currentQuery + nodes.length;
    } 
        
	q = myquery;
}

model.nodes   = mynodes;
