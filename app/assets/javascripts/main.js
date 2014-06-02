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
    openFileId: null
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
    ele_hide("loading");
    Code.Var.openFileId = lastOpenFile;
    Code.Event.Onclick();
    Code.Event.Scheduled();
};

Code.Logic.loadFailure = function() {
    alert("error in loading your files");    
};

Code.Logic.updateMyContentHash = function() {
    if(Code.Var.myContents.length > 0) {
	Code.Var.myContentHash = {};
	Code.Var.myContents.each(function(obj) {
	    Code.Var.myContentHash[obj.get('id')] = obj;
	});    
    }
};

Code.Logic.prepareFileList = function() {
    var allFileIds = get_hash_keys(Code.Var.myContentHash);
    var html = "";
    for(var i=0;i<allFileIds.length;i++) {
	var fileObj = Code.Var.myContentHash[allFileIds[i]];
	var variable = { file_id: fileObj.get("id"), file_name: fileObj.get("name") };
	html += _.template($("#fileLinkTemp").html(), variable);	
    }
    ele("file-list").innerHTML = html;
};

Code.Logic.openFile = function(id) {
    var file = Code.Var.myContentHash[id];
    ele("content-editor").innerHTML = file.get("content");
    ele("file_name").innerHTML = file.get("name");
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

Code.Logic.save_file = function(force) {
    var content = ele('content-editor').innerHTML;
    if(((content != "Click to add note") && (content.length > 0) && (content != ele("sfile_content").value)) || force) {
	// rish to add save code here
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
    newFile.set({name: name, content: content, desc: desc, file_type: type, compile: 0, status: 0, sharability: 0});    
    newFile.save({}, {
	success: function(model, response) {
	    Code.Var.myContents.push(model);
	    Code.Logic.updateMyContentHash();
	    Code.Logic.prepareFileList();
	}, 
	error: function(response) {
	}
    })
};

Code.Logic.addNewNote = function() {
    // save_file(true);
    Code.Logic.addNewFile(0, "New Note", "", "");
    ele("content-editor").innerHTML = "Click to add note";
    ele("file_name").innerHTML = "New Note";
    Code.Logic.selectBtn("addNote");
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
}				

Code.Event = {
    Onclick: function() {	    
	$("#content-editor").click(function() {
	    Code.Logic.clearEditor();
	    Code.Logic.hideAll();
	});
	$("#file_name").click(function() {
	    Code.Logic.open_file_name_editor	    
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
    },
    Scheduled: function() {
	setInterval(function() {
	    Code.Logic.save_file(false);
	}, 5000);    
    }
};

