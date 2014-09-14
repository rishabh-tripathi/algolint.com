_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};

var Code = {
    Var: {},
    Def: {
	Model: {},
	Collection: {}
    },
    Logic: {},
    Event: {}
};

Code.Var = {
    myContents: [],
    myContentHash: {},
    myFolders: [],
    myFolderHash: {},
    templateHash: {},
    myTemplates: [],
    alTemplateCat : {},
    openFileId: null,
    codeEditor: null,
    currFolder: 0
};

Code.Def.Model = {
    Content: Backbone.Model.extend({
	url: function() {
	    var base = 'contents';
	    if(this.isNew()) return base;
	    return base + (base.charAt(base.length - 1) == '/' ? '' : '/') + this.id;
	}
    }),
    Folder: Backbone.Model.extend({
	url: function() {
	    var base = 'folders';
	    if(this.isNew()) return base;
	    return base + (base.charAt(base.length - 1) == '/' ? '' : '/') + this.id;
	}
    })
};

Code.Def.Collection = {
    Contents: Backbone.Collection.extend({
	model: Code.Def.Model.Content,
	url: function() {
	    base_url = '/contents';
	    if(this.uid != null) 
		base_url += '?uid='+this.uid;
	    return base_url;
	},
	initialize: function(uid) {
	    this.uid = uid;
	},
	setUid: function(uid) {
	    this.uid = uid;
	}
    }),
    Folders: Backbone.Collection.extend({
	model: Code.Def.Model.Folder,
	url: function() {
	    base_url = '/folders';
	    if(this.uid != null) 
		base_url += '?uid='+this.uid;
	    return base_url;
	},
	initialize: function(uid) {
	    this.uid = uid;
	},
	setUid: function(uid) {
	    this.uid = uid;
	}
    })	    	    
};	    

Code.Logic.load = function() {
    showTrans();    
    ele_show("loading");
    Code.Var.myContents = new Code.Def.Collection.Contents(uid);
    Code.Var.myContents.setUid(uid);
    Code.Var.myContents.fetch({
	success: function() { 
	    Code.Var.myFolders = new Code.Def.Collection.Folders(uid);
	    Code.Var.myFolders.setUid(uid);
	    Code.Var.myFolders.fetch({
		success: function() { 		    
		    Code.Logic.loadSuccess()
		},         
		error: function() {
		    Code.Logic.loadFailure();
		}
	    });
	},         
	error: function() {
	    Code.Logic.loadFailure();
	}
    });
};

Code.Logic.loadSuccess = function() {        
    Code.Logic.updateMyContentHash();
    Code.Logic.updateFolderHash();
    Code.Logic.prepareFileList();
    hideTrans();
    ele_hide("loading");
    Code.Var.openFileId = lastOpenFile;
    Code.Event.Onclick();
    Code.Event.Scheduled();
    Code.Event.Keyboard();
    if(objDef(Code.Var.openFileId)) {
	Code.Logic.openFile(Code.Var.openFileId);
    } else {
	Code.Logic.initEditor("code-editor", "text/plain", "");
	Code.Logic.nofileState();
    }
    // Setting User Preferences
    Code.Logic.setFontSize(ele('size-pref').value, false);
    var curTheme = ele('theme-pref').value;
    if(curTheme == 0) {
	Code.Logic.setLightTheme(false);
    } else {
	Code.Logic.setDarkTheme(true);
    }
};

Code.Logic.loadFailure = function() {
    alert("error in loading your files");    
};

Code.Logic.nofileState = function() {
    var autonote = _.template($("#howtoNoteTemp").html(), {});	
    Code.Logic.addNewNote("How To Use","",autonote);
}

Code.Logic.updateMyContentHash = function() {
    Code.Var.templateHash = {};    
    Code.Var.myTemplates = [];
    Code.Var.alTemplateCat = {};
    Code.Var.myContentHash = {};    
    if(Code.Var.myContents.length > 0) {	
	Code.Var.myContents.each(function(obj) {
	    if(obj.get("template") == 10) {				
		Code.Var.templateHash[obj.get('id')] = obj;
		if(objDef(obj.get('template_cat'))) {
		    if(!(Code.Var.alTemplateCat.hasOwnProperty(obj.get('template_cat')))) {
			Code.Var.alTemplateCat[obj.get('template_cat')] = [];
		    }
		    Code.Var.alTemplateCat[obj.get('template_cat')].push(obj);
		}
	    } else if(obj.get("template") == 20) {
		Code.Var.templateHash[obj.get('id')] = obj;		
		Code.Var.myTemplates.push(obj);
	    } else {	    
		Code.Var.myContentHash[obj.get('id')] = obj;
	    }
	});    
    }
};

Code.Logic.updateFolderHash = function() {
    Code.Var.myFolderHash = {};
    if(Code.Var.myFolders.length > 0) {	
	Code.Var.myFolders.each(function(obj) {
	    Code.Var.myFolderHash[obj.get("id")] = obj;
	});    
    }    
};

Code.Logic.prepareFileList = function() {
    var allFileIds = get_hash_keys(Code.Var.myContentHash);
    var html = "";        
    if(objDef(allFileIds) && (allFileIds.length > 0)) {
	allFileIds = allFileIds.sort(function(a,b) { return b-a });
	for(var i=0;i<10;i++) {
	    var fileObj = Code.Var.myContentHash[allFileIds[i]];
	    if(objDef(fileObj)) {
		var variable = { file_id: fileObj.get("id"), file_name: fileObj.get("name") };
		html += _.template($("#fileLinkTemp").html(), variable);	
	    }
	}
    }
    ele("file-list").innerHTML = html;
};

Code.Logic.openFile = function(id) {
    var file = Code.Var.myContentHash[id];
    if(objDef(file)) {
	var content = file.get("content");
	ele("file_name").innerHTML = file.get("name");
	if(objDef(file.get("desc")) && hasLen(file.get("desc"))) {
	    ele("desc-area-te").value = file.get("desc");
            ele_show("desc-area");	          
	} else {
	    ele("desc-area-te").value = "";          
	    ele_hide("desc-area");	  
	}
	if(file.get("file_type") == 0) {
	    ele_hide("add-desc-btn");
	} else {
	    ele_show("add-desc-btn");
	}
	Code.Logic.loadEditor("code-editor", file.get("file_type"), content);
	Code.Var.openFileId = id;
	Code.Logic.closePopup();
    }
};

Code.Logic.getCode = function() {
    return Code.Var.codeEditor.getValue();    
}

Code.Logic.setCode = function(code) {
    Code.Var.codeEditor.setValue(code);        
}

Code.Logic.clearEditor = function() {    
    Code.Logic.setCode("");
};

Code.Logic.setFontSize = function(size, save) {
    ele("editor-area").style.fontSize = size+"px";
    if(save) {
	ele('size-pref').value = size
	submit_ajax_form("save-user-pref");
    }
};

Code.Logic.setKeyBinding = function(type) { 
    Code.Var.codeEditor.setOption("keyMap", type);	    
    if(type == "emacs")
	key = 10;
    else if(type == "vim")
	key = 20;
    else if(type == "sublime")
	key = 30;
    ele('key-pref').value = key;
    submit_ajax_form("save-user-pref");
};

Code.Logic.initEditor = function(id, mode, value) {    
    Code.Var.codeEditor = CodeMirror.fromTextArea(ele(id), {
	mode: mode,
	value: value,
	indentUnit: 4,
	smartIndent: true,
	indentWithTabs: true,
	tabSize: 4,
	lineWrapping: true,
	lineNumbers: false,
	autofocus: true,
	dragDrop: true,
	autoCloseBrackets: true,
	matchBrackets: true,
	showCursorWhenSelecting: true,
	keyMap: (objDef(ele("key-name")))? ele("key-name").value : "sublime",
	viewportMargin: Infinity
    });
};

Code.Logic.removeLineNumber = function() {
    Code.Var.codeEditor.setOption("lineNumbers", false);	
}

Code.Logic.loadEditor = function(id, file_type, value) {    
    var mode = getCodeEditorMode(file_type);
    if(Code.Var.codeEditor == null) {	
	Code.Logic.initEditor(id, mode, value);
    } else {
	Code.Var.codeEditor.setOption("mode", mode);		
    }
    if(mode == "text/plain") {
	Code.Var.codeEditor.setOption("lineNumbers", false);		
    } else {
	Code.Var.codeEditor.setOption("lineNumbers", true);			
    }
    Code.Logic.setCode(value);
}

Code.Logic.removeFile = function(id) {
    var file = Code.Var.myContentHash[id];
    if(!objDef(file)) {
	var file = Code.Var.templateHash[id];
    }
    if(objDef(file)) {    
	var destroy = false;
	if(file.get("content").length > 0) {
	    destroy = confirm("File "+file.get("name")+" is not empty, Do you really want to delete this?");
	} else {
	    destroy = true;
	}
	if(destroy) {
	    if(objDef(Code.Var.myContents) && (Code.Var.myContents.length > 1)) {		
		var nextOpenFileindex = Code.Var.myContents.indexOf(file) - 1;
		var nextFile = Code.Var.myContents.at(nextOpenFileindex);
		if(objDef(nextFile)) {
		    Code.Var.openFileId = nextFile.get("id");			
		    Code.Logic.openFile(Code.Var.openFileId);
		} else {
		    Code.Var.openFileId = Code.Var.myContents.at(0).get("_id");			
		    if(Code.Var.openFileId != file.get("_id")) {
			Code.Logic.openFile(Code.Var.openFileId);
		    } else {
			Code.Logic.nofileState();
		    }
		}
	    } else {
		Code.Logic.nofileState();
	    }		    
	    Code.Logic.save_file(true);
	    file.destroy({
		success: function(model, response) {     
		    Code.Logic.updateMyContentHash();
		    Code.Logic.prepareFileList();	    
		},
		error: function (model, response) {
		    ele_show("error-div");
		}
	    });    
	}
    }
};

Code.Logic.save_failed = function() {
    ele_show('error-div');
    ele('file_name').style.color = "#FF2A68";
};   

Code.Logic.save_success = function() {
    ele_hide('error-div');
    ele('file_name').style.color = "#0BD318";
};

Code.Logic.getMyTemplate = function() {
    if($("#my-template").is(":checked")) { 
	return 20;
    } else {
	return 0;
    }    
};

Code.Logic.getFileSharability = function() {
    if($("#private-code").is(":checked")) { 
	return 0;
    } else {
	return 10;
    }    
}

Code.Logic.save_file = function(force) {
    var desc = ele("desc-area-te").value;
    var content = Code.Logic.getCode();
    if(objDef(Code.Var.openFileId)) {
	var fileObj = Code.Var.myContentHash[Code.Var.openFileId];
	if(objDef(fileObj)) {
	    if(((content != "") && (content.length > 0) && (content != fileObj.get("content"))) || force) {
		fileObj.set({name: ele("file_name").innerHTML, desc: desc, content: content, template: Code.Logic.getMyTemplate(), sharability: Code.Logic.getFileSharability()})
		fileObj.save({}, {
		    success: function(model, response) {
			Code.Logic.prepareFileList();
			Code.Logic.save_success();
		    }, 
		    error: function(response) {
			Code.Logic.save_failed();
		    }
		});		    		
	    }
	}
    }
};

Code.Logic.open_file_name_editor = function() {
    ele_show('edit-file-name');
    ele('file-name-tb').value = ele('file_name').innerHTML;
};

Code.Logic.change_file_name = function() {
    ele('file_name').innerHTML = ele('file-name-tb').value;
    ele_hide('edit-file-name');
    Code.Logic.save_file(true);
};

Code.Logic.addNewFile = function(type, name, desc, content) {
    var newFile = new Code.Def.Model.Content();
    newFile.set({name: name, content: content, desc: desc, file_type: type, compile: 0, status: 0, sharability: 0, template: Code.Logic.getMyTemplate()});    
    newFile.save({}, {
	success: function(model, response) {
	    Code.Var.myContents.push(model);
	    Code.Logic.updateMyContentHash();
	    Code.Logic.prepareFileList();
	    Code.Var.openFileId = model.get("id"); 	    
	    Code.Logic.loadEditor("code-editor", model.get("file_type"), model.get("content"));
	}, 
	error: function(response) {
	    ele_show("error-div");
	}
    });
};

Code.Logic.addNewNote = function(file_name, desc, content) {
    if(!objDef(file_name)) {
	file_name = "New Note";
    }
    if(!objDef(desc)) {
	desc = "";
    }
    if(!objDef(content)) {
	content = "";
    }
    Code.Logic.save_file(true);
    Code.Logic.addNewFile(0, file_name, desc, content);
    Code.Logic.setCode(content);
    ele("file_name").innerHTML = file_name;
    ele("desc-area-te").value = desc;
    ele_hide("desc-area");
    ele_hide("add-desc-btn");
    Code.Logic.selectBtn("addNote");
};

Code.Logic.addCPPFile = function() {
    Code.Logic.save_file(true);
    Code.Logic.addNewFile(10, "NewCode.cpp", "", "");
    Code.Logic.setCode("");
    ele("file_name").innerHTML = "NewCode.cpp";
    ele("desc-area-te").value = "";
    ele_hide("desc-area");
};

Code.Logic.addJavaFile = function() {
    Code.Logic.save_file(true);
    Code.Logic.addNewFile(20, "NewCode.java", "", "");
    Code.Logic.setCode("");
    ele("file_name").innerHTML = "NewCode.java";
    ele("desc-area-te").value = "";
    ele_hide("desc-area");
};

Code.Logic.addRubyFile = function() {
    Code.Logic.save_file(true);
    Code.Logic.addNewFile(30, "NewCode.rb", "", "");
    Code.Logic.setCode("");
    ele("file_name").innerHTML = "NewCode.rb";
    ele("desc-area-te").value = "";
    ele_hide("desc-area");
};

Code.Logic.addPythonFile = function() {
    Code.Logic.save_file(true);
    Code.Logic.addNewFile(40, "NewCode.py", "", "");
    Code.Logic.setCode("");
    ele("file_name").innerHTML = "NewCode.py";
    ele("desc-area-te").value = "";
    ele_hide("desc-area");
};

Code.Logic.addNewCode = function() {
    Code.Logic.selectBtn("addCode");
};

Code.Logic.viewFiles = function() {
    Code.Logic.selectBtn("viewFile");
};
	
Code.Logic.viewSettings = function() {
    Code.Logic.selectBtn("viewSetting");
};

Code.Logic.selectBtn = function(id) {
    $(".btn-group a").removeClass("active");
    $("#"+id).addClass("active");
    $(".top-popup").hide();
    if(ele(id+"-popup") != null) {
	$("#"+id+"-popup").show();
    }
};

Code.Logic.hideAll = function() {
    $(".top-popup").hide();    
    // ele_hide('edit-file-name');    
};				

Code.Logic.setLightTheme = function(save) {
    if(save) {
	ele('theme-pref').value = 0;
	submit_ajax_form("save-user-pref");
    }
    $("body").css({"background":"#FAFAFA"});
    $("#user_name").css({"color":"#34495E"});
    $("#file_name").css({"color":"#34495E"});
    $("#al-top-bar").css({"background":"#FAFAFA"});        
};

Code.Logic.setDarkTheme = function(save) {
    if(save) {
	ele('theme-pref').value = 10;
	submit_ajax_form("save-user-pref");
    }
    $("body").css({"background":"#000000"});
    $("#user_name").css({"color":"#ffffff"});
    $("#file_name").css({"color":"#ffffff"});
    $("#al-top-bar").css({"background":"#000000"});    
};

Code.Logic.compileCode = function() {
    Code.Logic.save_file(true);
    Code.Logic.hideAll();
    showTrans();
    ele_show("compile");
    if(objDef(Code.Var.openFileId)) {
	var fileObj = Code.Var.myContentHash[Code.Var.openFileId];
	ele("compileStatus").innerHTML = fileObj.get("name");
	ele("output-window").innerHTML = "Compiling '"+fileObj.get("name")+"'...";
	ele("cfile_id").value = Code.Var.openFileId;
    }
    ele_show("compileStatus");
    submit_ajax_form("compile_code");
};

Code.Logic.showOutput = function() {
    Code.Logic.hideAll();
    showTrans();
    ele_show("compile");
    ele_show("compileStatus");
    ele_show("output-window");
};

Code.Logic.openTemplates = function() {
    Code.Logic.hideAll();
    showTrans();
    ele_show("template-popup");
    var getAllCats = get_hash_keys(Code.Var.alTemplateCat);    
    var html = "";
    for(var i=0;i<getAllCats.length;i++) {
	var allTempOfCat = Code.Var.alTemplateCat[getAllCats[i]];
	var buttonHtml = "";	
	for(var j=0;j<allTempOfCat.length;j++) {
	    var tempObj = allTempOfCat[j];
	    var variable = { name: tempObj.get("name"), id: tempObj.get("template_cat"), code_id: tempObj.get("id"), removable: false };
	    buttonHtml += _.template($("#templateListButton").html(), variable);		    
	}
	var variable = { category_name: Code.Logic.getTemplateCategoryName(getAllCats[i]), button_html: buttonHtml };
	html += _.template($("#templateListSection").html(), variable);		    	
    }
    ele("temp-list").innerHTML = html;
    var myTempIds = Code.Var.myTemplates;
    if(myTempIds.length > 0) {
	var html = "";
	var buttonHtml = "";	
	for(var i=0;i<myTempIds.length;i++) {
	    var tempObj = myTempIds[i];
	    var variable = { name: tempObj.get("name"), id: "my-temp", code_id: tempObj.get("id"), removable: true };
	    buttonHtml += _.template($("#templateListButton").html(), variable);		    
	}
	var variable = { category_name: "My Template", button_html: buttonHtml };
	html += _.template($("#templateListSection").html(), variable);		    	
	ele("myTemplateList").innerHTML = html;	
    }
};

Code.Logic.closeTemplates = function() {
    hideTrans();
    ele_hide("template-popup");
};

Code.Logic.getTemplateCategoryName = function(cat_id) {
    var cat_hash = {
	0 : "Not a template",
	10 : "Linked List",
	20 : "Stack",
	30 : "Queue"
    }   
    return cat_hash[cat_id]
};

Code.Logic.chooseTemplate = function(id) {
    var tempObj = Code.Var.templateHash[id];
    var currText = Code.Logic.getCode();
    if(currText == "") {
	Code.Logic.setCode(tempObj.get("content"));
    } else {
	var r = confirm("Your editor area is not empty, this will replace your current content with the template code. Do you want to continue?");
	if(r == true) {
	    Code.Logic.setCode(tempObj.get("content"));
	} 
    }
    Code.Logic.closeTemplates();
};

Code.Logic.addDescription = function() {
    ele_toggle("desc-area");
};

Code.Logic.addNewFolder = function() {
    var newFolder = new Code.Def.Model.Folder();
    newFolder.set({name: "New Folder", user_id: uid, parent_id: 0});        
    newFolder.save({}, {
	success: function(model, response) {
	    Code.Var.myFolders.push(model);
	    Code.Logic.updateFolderHash();
	    Code.Logic.manageFiles(0);
	}, 
	error: function(response) {
	    ele_show("error-div");
	}
    });

};

Code.Logic.openPopup = function() {
    ele_show('fill-popup');
};

Code.Logic.closePopup = function() {
    ele_hide('fill-popup');
};

Code.Logic.getMangeFileIconImg = function(file_type) { 
    var mode = "";
    if(file_type == 0) {
	mode = "/assets/notes-icon.png";
    } else if(file_type == 10) {
	mode = "/assets/cpp-icon.png";
    } else if(file_type == 20) {    	
	mode = "/assets/java-icon.png";
    } else if(file_type == 30) {
	mode = "/assets/ruby-icon.png";
    } else if(file_type == 40) {
	mode = "/assets/py-icon.png";
    }
    return mode;
}

Code.Logic.manageFiles = function(folder_id) {    
    ele('popup-title').innerHTML = "Manage Your Files";
    var html = "";    
    if(folder_id == 0) {
	Code.Var.currFolder = 0;
	var allFolderIds = get_hash_keys(Code.Var.myFolderHash);
	if(objDef(allFolderIds) && (allFolderIds.length > 0)) {
	    for(var i=0;i<allFolderIds.length;i++) {
		var fileObj = Code.Var.myFolderHash[allFolderIds[i]];
		var variable = { div_id: fileObj.get("id"), name: fileObj.get("name") };
		html += _.template($("#templateManageFolderIcon").html(), variable);	
	    }
	}
    } else {
	Code.Var.currFolder = folder_id;
	html += _.template($("#templateBackIcon").html(), {});
    }
    var allFileIds = get_hash_keys(Code.Var.myContentHash);   
    if(objDef(allFileIds) && (allFileIds.length > 0)) {
	for(var i=0;i<allFileIds.length;i++) {
	    var fileObj = Code.Var.myContentHash[allFileIds[i]];
	    if(fileObj.get("folder_id") == folder_id) {
		var variable = { div_id: fileObj.get("id"), name: fileObj.get("name"), img_src: Code.Logic.getMangeFileIconImg(fileObj.get("file_type")) };
		html += _.template($("#templateManageFileIcon").html(), variable);	
	    }
	}
    }
    if(folder_id == 0) {
	html += _.template($("#templateAddFolderIcon").html(), {});	
    }
    html += "<div style='clear:both;'></div>";
    ele("popup-content").innerHTML = html;    
    $(".file-icon").draggable({ revert: true });        
    $(".folder-icon").droppable({
	accept: ".file-icon",
	activeClass: "file-drag",
	hoverClass: "folder-drop-hover",
	drop: function(event, ui) {
	    var drop_id = $(this).attr('id');
	    var drag_id = ui.draggable.context.id
	    Code.Logic.addFileToFolder(drop_id, drag_id);
	}
    });
    Code.Logic.openPopup();
};

Code.Logic.addFileToFolder = function(folder_id, file_id) {
    var fileObj = Code.Var.myContentHash[parseInt(file_id.replace("file-",""))];
    fileObj.set({folder_id: parseInt(folder_id.replace("folder-",""))});
    Code.Logic.manageFiles(Code.Var.currFolder);
    if(objDef(fileObj)) {
	fileObj.save({}, {
	    success: function(model, response) {
	    }, 
	    error: function(response) {
	    }
	});		    		
    }
};

Code.Logic.saveFolderName = function(folder_id) {    
    var folderObj = Code.Var.myFolderHash[folder_id];
    var newName = ele('edit-name-'+folder_id).value;
    folderObj.set({name: newName});    
    Code.Logic.manageFiles(Code.Var.currFolder);
    if(objDef(folderObj)) {
	folderObj.save({}, {
	    success: function(model, response) {
	    }, 
	    error: function(response) {
	    }
	});
    }
};

Code.Logic.saveFileName = function(file_id) {
    var fileObj = Code.Var.myContentHash[file_id];
    var newName = ele('edit-file-name-'+file_id).value;
    fileObj.set({name: newName});    
    Code.Logic.manageFiles(Code.Var.currFolder);
    if(objDef(fileObj)) {
	fileObj.save({}, {
	    success: function(model, response) {
	    }, 
	    error: function(response) {
	    }
	});
    }
};

Code.Event = {
    Onclick: function() {	    
	$("#file_name").click(function() {
	    Code.Logic.open_file_name_editor();	    
	    return false;
	});
	$("#update-file-name").click(function() {	   
	    Code.Logic.change_file_name();
	});
	$("#addNote").click(function() {	   
	    Code.Logic.addNewNote();
	});
	$("#addCode").click(function() {	   
	    Code.Logic.addNewCode();
	    return false;
	});
	$("#viewFile").click(function() {	   
	    Code.Logic.viewFiles();
	    return false;
	});
	$("#viewSetting").click(function() {	   
	    Code.Logic.viewSettings();
	    return false;
	});
	$("#my-template").click(function() {	   
	    Code.Logic.save_file(true);
	    return false;
	});
	$("#private-code").click(function() {	   
	    Code.Logic.save_file(true);
	    return false;
	});
	$("#nf-cpp").click(function() {
	    Code.Logic.addCPPFile();
	});
	$("#nf-java").click(function() {
	    Code.Logic.addJavaFile();
	});
	$("#nf-ruby").click(function() {
	    Code.Logic.addRubyFile();
	});
	$("#nf-py").click(function() {
	    Code.Logic.addPythonFile();
	});
	$("#smallFont").click(function() {
	    Code.Logic.setFontSize(20, true);
	});
	$("#mediumFont").click(function() {
	    Code.Logic.setFontSize(30, true);
	});
	$("#largeFont").click(function() {
	    Code.Logic.setFontSize(40, true);
	});
	$("#lightTheme").click(function() {
	    Code.Logic.setLightTheme(true);
	});
	$("#darkTheme").click(function() {
	    Code.Logic.setDarkTheme(true);
	});
	$("#compileBtn").click(function() {
	    Code.Logic.compileCode();
	});
	$("#manageFile").click(function() {
	    Code.Logic.manageFiles(0);
	});
	$("#outputBtn").click(function() {
	    Code.Logic.showOutput();
	});
	$("#sel-code-template").click(function() {
	    Code.Logic.openTemplates();
	});
	$("#template-popup-close").click(function() {
	    Code.Logic.closeTemplates();
	});
	$("#fill-popup-close").click(function() {
	    Code.Logic.closePopup();
	});
	$("#add-desc-btn").click(function() {
	    Code.Logic.addDescription();
	});
	$("#editor-area").click(function() {
	    Code.Logic.hideAll();
	});
	$("#keyEmacs").click(function() {
	    Code.Logic.setKeyBinding("emacs");
	});
	$("#keyVim").click(function() {
	    Code.Logic.setKeyBinding("vim");
	});
	$("#keySublime").click(function() {
	    Code.Logic.setKeyBinding("sublime");
	});
    },
    Keyboard: function() {
	$('body').bind('keydown mouseup',
		       function(e) {
			   var code = e.keyCode || e.which;
			   if(code == 67) {
			       if(e.ctrlKey && e.shiftKey) {				   
				   e.preventDefault();
				   Code.Logic.compileCode();
			       } 
			   } else if(code == 79) {
			       if(e.ctrlKey && e.shiftKey) {				   
				   e.preventDefault();
				   Code.Logic.showOutput();
			       }			 		        
			   } else if(code == 83) {
			       if(e.ctrlKey) {
				   e.preventDefault();
				   Code.Logic.save_file(false);				   
			       }			 		        
			   } else if(code == 84) {
			       if(e.ctrlKey && e.shiftKey) {				   
				   e.preventDefault();
				   Code.Logic.openTemplates();				   
			       }
			   } else if(code == 77) {
			       if(e.ctrlKey && e.shiftKey) {				   
				   e.preventDefault();
				   Code.Logic.manageFiles(0);				   
			       }
			   } else if(code == 27) { // esc
			       ele_hide('compile');
			       Code.Logic.closeTemplates();
			       hideTrans();    
			       Code.Logic.closePopup();
			   }
		      });    
},    
    Scheduled: function() {
	setInterval(function() {
	    Code.Logic.save_file(false);
	}, 5000);    
    }
};
