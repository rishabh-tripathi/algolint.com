function ele(id) {
    return document.getElementById(id);
}

function ele_show(id) {
    document.getElementById(id).style.display="";
}

function ele_hide(id) {
    document.getElementById(id).style.display="none";
}

function submit_ajax_form(id) {
    $("#"+id).trigger("submit.rails");
}


function clearEditor() {    
    if(ele('content-editor').innerHTML == "Click to add note") {
	ele('content-editor').innerHTML = "";
    }    
}

function save_failed() {
    ele_show('error-div');
    ele('file_name').style.color = "#FF2A68";
}

function save_success() {
    ele_hide('error-div');
    ele('file_name').style.color = "#0BD318";
}

function save_file(force) {
    var content = ele('content-editor').innerHTML;
    if(((content != "Click to add note") && (content.length > 0) && (content != ele("sfile_content").value)) || force) {
	ele("sfile_name").value = ele("file_name").innerHTML;
	ele("sfile_content").value = content;
	submit_ajax_form("save_content");
    }
}

function open_file_name_editor() {
    ele_show('edit-file-name');
    ele('file-name-tb').value = ele('file_name').innerHTML;
}

function change_file_name() {
    ele('file_name').innerHTML = ele('file-name-tb').value;
    ele_hide('edit-file-name');
    save_file(true);
}

function addNewNote() {
    save_file(true);
    ele("sfile_id").value = "";
    ele("sfile_name").value = "";
    ele("sfile_desc").value = "";
    ele("sfile_content").value = "";
    ele("content-editor").innerHTML = "Click to add note";
    ele("file_name").innerHTML = "New Note";
    selectBtn("addNote");
}

function addNewCode() {
    selectBtn("addCode");
}

function viewFiles() {
    selectBtn("viewFile");
}

function viewSettings() {
    selectBtn("viewSetting");
}

function selectBtn(id) {
    $(".btn-group a").removeClass("active");
    $("#"+id).addClass("active");
    $(".top-popup").hide();
    if(ele(id+"-popup") != null) {
	$("#"+id+"-popup").show();
    }
}

function hideAll() {
    $(".top-popup").hide();    
}

setInterval(function() {
    save_file(false);
}, 5000);
