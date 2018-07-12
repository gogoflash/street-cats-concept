// Output iOS Icons.jsx
// 2014 Todd Linkner
// License: none (public domain)
// v1.2
//
// This script is for Photoshop CS6. It outputs iOS icons of the following 
// sizes from a source 1024px x 1024px PSD
//
// [name]-29.png
// [name]-29@2x.png
// [name]-29@3x.png
// [name]-40.png
// [name]-40@2x.png
// [name]-40@3x.png
// [name]-60@2x.png
// [name]-60@3x.png
// [name]-76.png
// [name]-76@2x.png
// [name]-512.png		(512px x 512px)
// [name]-512@2x.png	(1024px x 1024px)

// bring Photoshop into focus
#target Photoshop

main();

function main() {

    alert("This script outputs iPhone, iPad, and iTunes icons, "
        + "from a 1024px x 1024px PSD source file.\r\r");

    // Ask user for input folder
	var inputFile = File.openDialog("Select a 1024px x 1024px PSD file","PSD File:*.psd");
	if (inputFile == null) throw "No file selected. Exting script.";

	// Open file
	open(inputFile);

    // Set ruler untis to pixels
    app.preferences.typeUnits = TypeUnits.PIXELS

    // iOS 8 Icons

    resize(48);
    resize(57);
    resize(72);
    resize(76);
    resize(114);
    resize(120);
    resize(144);
    resize(152);
    resize(512);
    resize(1024);

    // Clean up
    app.activeDocument.close(SaveOptions.DONOTSAVECHANGES);
    alert("Done!");
}

function resize(size) {
     // Setup file name
    var pname = app.activeDocument.path + "/";
    var fname = app.activeDocument.name;
    var append = "";
    var fsize = size;
    n = fname.lastIndexOf(".");
    if (n > 0) {
        fname = "icon_" + size + ".png";
   }

   // Set export options
    var opts, file;
    opts = new ExportOptionsSaveForWeb();
    opts.format = SaveDocumentType.PNG;
    opts.PNG8 = false; 
    opts.transparency = true;
    opts.interlaced = 0;
    opts.includeProfile = false;
    opts.optimized = true;

    // Duplicate, resize and export
    var tempfile = app.activeDocument.duplicate();
    tempfile.resizeImage(fsize+"px",fsize+"px");
    file = new File(pname+fname);
    tempfile.exportDocument(file, ExportType.SAVEFORWEB, opts);
    tempfile.close(SaveOptions.DONOTSAVECHANGES);
}

