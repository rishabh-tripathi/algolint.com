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

function get_hash_keys(hsh) {
    var keys = [];
    for(var i in hsh) { if (hsh.hasOwnProperty(i)) keys.push(i); }
    return keys;
}

function objDef(obj) {
    return ((obj != undefined) && (obj != null))? true : false;
}
