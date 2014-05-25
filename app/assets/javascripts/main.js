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

setInterval(function() {
    save_file(false);
}, 5000);
