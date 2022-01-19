var q = 'TAG:"critical"';
  
var mynodes = new Array();
    
var pageSize        = 1000; // no more than 1000!!!
var currentPage     = 0;
var currentPageSize = -1;

var paging = { maxItems: pageSize, skipCount: 0 };
var def    = { query: q, store: 'workspace://SpacesStore', language: 'fts-alfresco', page: paging };

var i = 0;        

while (currentPageSize != 0) {
  paging.skipCount = currentPage * pageSize; 
  var nodes        = search.query(def);
  currentPage      = currentPage + 1;
  currentPageSize  = (null != nodes ? nodes.length : 0);
  if (currentPageSize > 0) {
    for each(var node in nodes) {
      mynodes.push(node.nodeRef + ';' + decodeURI(node.parent.webdavUrl.replace("/webdav/","")) + ';' + node.name);
    }  
  }
}

model.nodes   = mynodes;