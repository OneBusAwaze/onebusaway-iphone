var sourceFolder = Folder.selectDialog( 'Select the icon output folder', '~' );var vehicleTypes = ["Bus","Ferry","LightRail","Rail"];var directions = ["","N","NE","E","SE","S","SW","W","NW"];for( var x=0; x<vehicleTypes.length; x++) {	for( var y=0; y<directions.length; y++ ) {		configureAndSaveImage(vehicleTypes[x],directions[y]);	}}function configureAndSaveImage(vehicleType,direction) {		var rootLayers = app.activeDocument.layers;	var vehicleTypesLayer = rootLayers.getByName("VehicleTypes");	for( var i=0; i<vehicleTypesLayer.layers.length; i++) {		var layer = vehicleTypesLayer.layers[i];		var viz = layer.name == vehicleType;		layer.visible = viz;	}		var directionLayers = rootLayers.getByName("Directions");	var items = directionLayers.pathItems;	for( var i=0; i<items.length; i++) {		var item = items[i];		item.hidden = item.name != direction;	}	var bounds = [];	bounds[""] = [-15,15,15,-15];	bounds["N"] = [-15,26,15,-15];	bounds["NE"] = [-15,20,20,-15];	bounds["E"] = [-15,15,26,-15];	bounds["SE"] = [-15,15,20,-20];	bounds["S"] = [-15,15,15,-26];	bounds["SW"] = [-20,15,15,-20];	bounds["W"] = [-26,15,15,-15];	bounds["NW"] = [-20,20,15,-15];		app.activeDocument.cropBox = bounds[direction];		var exportOptions = new ExportOptionsPNG24();	var type = ExportType.PNG24;		var fileSpec = new File(sourceFolder+"/" + vehicleType + "StopIcon" + direction + ".png");	app.activeDocument.exportFile( fileSpec, type, exportOptions );	var fileSpec2 = new File(sourceFolder+"/" + vehicleType + "StopIcon" + direction + "@2x.png");	exportOptions.horizontalScale = 200;	exportOptions.verticalScale = 200;	app.activeDocument.exportFile( fileSpec2, type, exportOptions );}