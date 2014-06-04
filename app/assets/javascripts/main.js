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
    openFileId: null,
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
};

Code.Logic.loadFailure = function() {
    alert("error in loading your files");    
};

Code.Logic.updateMyContentHash = function() {
    Code.Var.myContentHash = {};
    if(Code.Var.myContents.length > 0) {	
	Code.Var.myContents.each(function(obj) {
	    Code.Var.myContentHash[obj.get('id')] = obj;
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
    ele("content-editor").innerHTML = file.get("content");
    ele("file_name").innerHTML = file.get("name");
    Code.Var.openFileId = id;
};

Code.Logic.removeFile = function(id) {
    var file = Code.Var.myContentHash[id];
    file.destroy({
	success: function(model, response) {     
	    Code.Logic.updateMyContentHash();
	    Code.Logic.prepareFileList();	    
	},
	error: function (model, response) {
	    ele_show("error-div");
	}
    });    
};

Code.Logic.clearEditor = function() {    
    if(ele('content-editor').innerHTML == "Click to add note") {
	ele('content-editor').innerHTML = "";
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
    var content = ele('content-editor').innerHTML;    
    if(objDef(Code.Var.openFileId)) {
	var fileObj = Code.Var.myContentHash[Code.Var.openFileId];
	if(objDef(fileObj)) {
	    if(((content != "Click to add note") && (content.length > 0) && (content != fileObj.get("content"))) || force) {
		fileObj.set({name: ele("file_name").innerHTML, content: content, template: Code.Logic.getMyTemplate()})
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
    ele("content-editor").innerHTML = "Click to add note";
    ele("file_name").innerHTML = "New Note";
    Code.Logic.selectBtn("addNote");
};

Code.Logic.addCPPFile = function() {
    Code.Logic.save_file(true);
    Code.Logic.addNewFile(10, "NewCode.cpp", "", "");
    ele("content-editor").innerHTML = "void main() { }";
    ele("file_name").innerHTML = "NewCode.cpp";
};

Code.Logic.addJavaFile = function() {
    Code.Logic.save_file(true);
    Code.Logic.addNewFile(20, "NewCode.java", "", "");
    ele("content-editor").innerHTML = "public static void main(args[]) { }";
    ele("file_name").innerHTML = "NewCode.java";
};

Code.Logic.addRubyFile = function() {
    Code.Logic.save_file(true);
    Code.Logic.addNewFile(30, "NewCode.rb", "", "");
    ele("content-editor").innerHTML = "def newAction \n end";
    ele("file_name").innerHTML = "NewCode.rb";
};

Code.Logic.addPythonFile = function() {
    Code.Logic.save_file(true);
    Code.Logic.addNewFile(40, "NewCode.py", "", "");
    ele("content-editor").innerHTML = "";
    ele("file_name").innerHTML = "NewCode.py";
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
};				

Code.Logic.getCode = function(text) {
    return text.replace(/(<span) class="(\w)+">/g, "").replace(/<\/span>/g,"");
};

Code.Logic.formatText = function() {
    var el = ele("content-editor");    
    var userInput = Code.Logic.getCode(el.innerHTML);     
    var sel = rangy.getSelection();
    var range = sel.getRangeAt(0);    
    var rangePrecedingBoundary = range.cloneRange();
    rangePrecedingBoundary.setStart(el, 0);
    var selEndOffset = rangePrecedingBoundary.text().length;
    rangePrecedingBoundary.setEnd(range.startContainer, range.startOffset);
    var selStartOffset = rangePrecedingBoundary.text().length;
    rangePrecedingBoundary.detach();
    var newHTML = prettyPrintOne(userInput);
    el.innerHTML = newHTML;    
    range.selectCharacters(el, selStartOffset, selEndOffset);
    sel.setSingleRange(range);
};

Code.Logic.setFontSize = function(size) {
    ele("content-editor").style.fontSize = size+"px";
};

Code.Logic.setLightTheme = function() {
    $("body").css({"background":"#FAFAFA"});
    $("#content-editor").css({"color":"#34495E"});
    $("#user_name").css({"color":"#34495E"});
    $("#file_name").css({"color":"#34495E"});
};

Code.Logic.setDarkTheme = function() {
    $("body").css({"background":"#8E8E93"});
    $("#content-editor").css({"color":"#ffffff"});
    $("#user_name").css({"color":"#ffffff"});
    $("#file_name").css({"color":"#ffffff"});
};

Code.Logic.compileCode = function() {
    Code.Logic.hideAll();
    showTrans();
};

Code.Logic.showOutput = function() {
    Code.Logic.hideAll();
    showTrans();
};

Code.Event = {
    Onclick: function() {	    
	$("#content-editor").click(function() {
	    Code.Logic.clearEditor();
	    Code.Logic.hideAll();
	});
	$("#file_name").click(function() {
	    Code.Logic.open_file_name_editor();	    
	});
	$("#update-file-name").click(function() {	   
	    Code.Logic.change_file_name();
	});
	$("#addNote").click(function() {	   
	    Code.Logic.addNewNote();
	});
	$("#addCode").click(function() {	   
	    Code.Logic.addNewCode();
	});
	$("#viewFile").click(function() {	   
	    Code.Logic.viewFiles();
	});
	$("#viewSetting").click(function() {	   
	    Code.Logic.viewSettings();
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
	$("#smallFont").click(function() {
	    Code.Logic.setFontSize(20);
	});
	$("#mediumFont").click(function() {
	    Code.Logic.setFontSize(30);
	});
	$("#largeFont").click(function() {
	    Code.Logic.setFontSize(50);
	});
	$("#lightTheme").click(function() {
	    Code.Logic.setLightTheme();
	});
	$("#darkTheme").click(function() {
	    Code.Logic.setDarkTheme();
	});
	$("#compileBtn").click(function() {
	    Code.Logic.compileCode();
	});
	$("#outputBtn").click(function() {
	    Code.Logic.showOutput();
	});
    },
    Keyboard: function() {
	$('#content-editor').bind('keydown mouseup',
				  function(e) {
				      var code = e.keyCode || e.which;
				      if(objDef(Code.Var.myContentHash[Code.Var.openFileId]) && (Code.Var.myContentHash[Code.Var.openFileId].get("file_type") != 0)) {
					  if((code == 32) || (code == 9) || (code == 13)) { // on space, tab and enter key
					      Code.Logic.formatText();			    		
					  }			
				      }	      
				      if(code == 9) {	
					  e.preventDefault();					  
					  // Insert tab space
					  pasteHtmlAtCaret('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
					  return;
				      }
				  });    
    },
    Scheduled: function() {
	setInterval(function() {
	    Code.Logic.save_file(false);
	}, 5000);    
    }
};

