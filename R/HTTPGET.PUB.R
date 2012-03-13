HTTPGET.PUB <- function(uri, fnargs){
	
	#split uri
	Rpackage <- uri[1];
	Robject  <- uri[2];
	Routput  <- uri[3];
	Rhelpout <- uri[4];
	
	#GET /R/pub
	if(is.na(Rpackage)){
		allpackages <- row.names(installed.packages());
		return(object2jsonfile(allpackages, fnargs));
	} 
	
	#GET /R/pub/somepackage
	if(is.na(Robject)){
		envirname <- paste("package", Rpackage, sep=":");
		if(envirname %in% search()){
			allobjects <- ls(envirname);
		} else {
			mynamespace <- loadNamespace(Rpackage);		
			allobjects <- getNamespaceExports(mynamespace);
		}
		return(object2jsonfile(allobjects, fnargs));
	} 
	
	#GET /R/pub/somepackage/someobject defaults to ascii
	if(is.na(Routput)){
		myobject <- getExportedValue(Rpackage, Robject)
		return(object2jsonfile(outputformats, fnargs));
	} 	
	
	#GET /R/pub/somepackage/somefun/help
	if(Routput == "help"){
		return(
			HTTPGET.PUB.PACKAGE.OBJECT.HELP(Rpackage, Robject, Rhelpout)
		);
	}
	
	#GET /R/pub/somepackage/somefun/ascii
	return(
		HTTPGET.PUB.PACKAGE.OBJECT(Rpackage, Robject, Routput, fnargs)
	);
}