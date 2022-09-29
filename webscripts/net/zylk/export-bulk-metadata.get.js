// Format 0\d
function pad(d) {
    return (d < 10) ? '0' + d.toString() : d.toString();
}

// ISODate format
function isodate(d) {
    var iso = d.getFullYear() + "-" + pad(d.getMonth() + 1) + "-" + pad(d.getDate()) + "T" + pad(d.getHours()) + ":" + pad(d.getMinutes()) + ":" + pad(d.getSeconds());
    return (iso);
}

// Clean aspects information
function aspectShort(asp){
    var asp = asp.replace(/{http:\/\/www.alfresco.org\/model\/content\/1.0}/g,"cm:");
    asp = asp.replace(/{http:\/\/www.alfresco.org\/model\/system\/1.0}/g,"sys:");
    asp = asp.replace(/{http:\/\/www.alfresco.org\/model\/forum\/1.0}/g,"fm:");
    asp = asp.replace(/{http:\/\/www.alfresco.org\/model\/site\/1.0}/g,"st:");
    asp = asp.replace(/{http:\/\/www.alfresco.org\/model\/rendition\/1.0}/g,"rn:");
    asp = asp.replace(/{http:\/\/www.alfresco.org\/model\/exif\/1.0}/g,"exif:");
    asp = asp.replace(/{http:\/\/www.alfresco.org\/model\/application\/1.0}/g,"app:");
    asp = asp.replace(/{http:\/\/www.alfresco.org\/model\/imap\/1.0}/g,"imap:");
    asp = asp.replace(/{http:\/\/www.alfresco.org\/model\/qshare\/1.0}/g,"qshare:");
    asp = asp.replace(/{http:\/\/www.zylk.net\/model\/zpr\/1.0}/g,"zpr:");
    asp = asp.replace(/{http:\/\/drwolf.it\/model\/1.0}/g,"dw:");
    return asp;
}

function getdoc_properties(n) {

    var d1 = new Date(n.properties["cm:created"]);
    var d2 = new Date(n.properties["cm:modified"]);
    var exp = '<?xml version="1.0" encoding="UTF-8"?>\n';
    exp = exp + '<!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">\n';
    exp = exp + '<properties>\n';
    exp = exp + '  <entry key="type">' + n.typeShort + '</entry>\n';
    exp = exp + '  <entry key="aspects">' + aspectShort(n.aspects.toString()) + '</entry>\n';
    exp = exp + '  <entry key="path">' + n.displayPath + '</entry>\n';
    exp = exp + '  <entry key="cm:name">' + n.properties["cm:name"] + '</entry>\n';
    exp = exp + '  <entry key="cm:title">' + n.properties["cm:title"] + '</entry>\n';
    exp = exp + '  <entry key="cm:description">' + n.properties["cm:description"] + '</entry>\n';
    exp = exp + '  <entry key="cm:creator">' + n.properties["cm:creator"] + '</entry>\n';
    exp = exp + '  <entry key="cm:modifier">' + n.properties["cm:modifier"] + '</entry>\n';
    exp = exp + '  <entry key="cm:created">' + isodate(d1) + '</entry>\n';
    exp = exp + '  <entry key="cm:modified">' + isodate(d2) + '</entry>\n';
    if (n.isDocument){
  		exp = exp + '  <entry key="noderef">' + n.nodeRef + '</entry>\n';
  		exp = exp + '  <entry key="sys:locale">' +  n.properties["sys:locale"] + '</entry>\n';
  		exp = exp + '  <entry key="sys:node-dbid">' +  n.properties["sys:node-dbid"] + '</entry>\n';
        exp = exp + '  <entry key="sys:store-protocol">' +  n.properties["sys:store-protocol"] + '</entry>\n';
        exp = exp + '  <entry key="sys:store-identifier">' +  n.properties["sys:store-identifier"] + '</entry>\n';
        exp = exp + '  <entry key="sys:node-uuid">' +  n.properties["sys:node-uuid"] + '</entry>\n';
	} 
    exp = exp + '</properties>\n';
    return exp;
}

var resultString = "Could not export bulk metadata";
var resultCode   = false;
var path         = args.path;

if ((path == null) || (path == "")) {

    resultString = "A valid path needed";

} else {

    var noderef  = companyhome.childByNamePath(path);
    resultString = getdoc_properties(noderef);

}

model.resultString = resultString;