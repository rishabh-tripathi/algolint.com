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
    templateHash: {},
    myTemplates: [],
    alTemplateCat : {},
    openFileId: null,
    codeEditor: null
};

Code.Def.Model = {
    Content: Backbone.Model.extend({
	url: function() {
	    var base = 'contents';
	    if(this.isNew()) return base;
	    return base + (base.charAt(base.length - 1) == '/' ? '' : '/') + this.id;
	}
    }),
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
    })	    
};	    

Code.Logic.load = function() {
    showTrans();    
    ele_show("loading");
    Code.Var.myContents = new Code.Def.Collection.Contents(uid);
    Code.Var.myContents.setUid(uid);
    Code.Var.myContents.fetch({
	success: function() { 
	    Code.Logic.loadSuccess()
	},         
	error: function() {
	    Code.Logic.loadFailure();
	}
    });
};

Code.Logic.loadSuccess = function() {        
    Code.Logic.updateMyContentHash();
    Code.Logic.prepareFileList();
    hideTrans();
    ele_hide("loading");
    Code.Var.openFileId = lastOpenFile;
    Code.Event.Onclick();
    Code.Event.Scheduled();
    Code.Event.Keyboard();
    if(objDef(Code.Var.openFileId)) {
	Code.Logic.openFile(Code.Var.openFileId);
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

Code.Logic.prepareFileList = function() {
    var allFileIds = get_hash_keys(Code.Var.myContentHash);
    var html = "";    
    if(objDef(allFileIds) && (allFileIds.length > 0)) {
	for(var i=0;i<allFileIds.length;i++) {
	    var fileObj = Code.Var.myContentHash[allFileIds[i]];
	    var variable = { file_id: fileObj.get("id"), file_name: fileObj.get("name") };
	    html += _.template($("#fileLinkTemp").html(), variable);	
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
	lineNumbers: true,
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
    Code.Logic.setCode(value);
}

Code.Logic.removeFile = function(id) {
    var file = Code.Var.myContentHash[id];
    if(!objDef(file)) {
	var file = Code.Var.templateHash[id];
    }
    if(objDef(file)) {    
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

Code.Logic.save_file = function(force) {
    var desc = ele("desc-area-te").value;
    var content = Code.Logic.getCode();
    if(objDef(Code.Var.openFileId)) {
	var fileObj = Code.Var.myContentHash[Code.Var.openFileId];
	if(objDef(fileObj)) {
	    if(((content != "") && (content.length > 0) && (content != fileObj.get("content"))) || force) {
		fileObj.set({name: ele("file_name").innerHTML, desc: desc, content: content, template: Code.Logic.getMyTemplate()})
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
	}, 
	error: function(response) {
	    ele_show("error-div");
	}
    });
};

Code.Logic.addNewNote = function() {
    Code.Logic.save_file(true);
    Code.Logic.addNewFile(0, "New Note", "", "");
    Code.Logic.setCode("");
    ele("file_name").innerHTML = "New Note";
    ele("desc-area-te").value = "";
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
	ele("compileStatus").innerHTML = "Testing <i>"+fileObj.get("name")+"</i>";
	ele("cfile_id").value = Code.Var.openFileId;
    }
    ele_show("compileStatus");
    ele_hide("output-window");
    ele_show("compileLoad");   
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
	$("#outputBtn").click(function() {
	    Code.Logic.showOutput();
	});
	$("#sel-code-template").click(function() {
	    Code.Logic.openTemplates();
	});
	$("#template-popup-close").click(function() {
	    Code.Logic.closeTemplates();
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
			   if(e.ctrlKey && e.shiftKey) {
			       if(code == 67) {
				   Code.Logic.compileCode();
			       } else if(code == 79) {
				   Code.Logic.showOutput();
			       }			 
			   }      
			   if(code == 27) { // esc
			       ele_hide('compile');
			       hideTrans();    
			   }
		       });    
    },    
    Scheduled: function() {
	setInterval(function() {
	    Code.Logic.save_file(false);
	}, 5000);    
    }
};
