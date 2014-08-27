function ele(id) {
    return document.getElementById(id);
}

function ele_show(id) {
    document.getElementById(id).style.display="";
}

function ele_hide(id) {
    document.getElementById(id).style.display="none";
}

function ele_toggle(id) {
    if(document.getElementById(id).style.display=="none") {
	document.getElementById(id).style.display="";
    } else {
	document.getElementById(id).style.display="none";
    }
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

function hasLen(obj) {
    return (obj.length > 0)? true : false;
}

function showTrans() {
    ele_show("transLayer");
}

function hideTrans() {
    ele_hide("transLayer");
}

function pasteHtmlAtCaret(html) {
    var sel, range;
    if (window.getSelection) {
        // IE9 and non-IE
        sel = window.getSelection();
        if (sel.getRangeAt && sel.rangeCount) {
            range = sel.getRangeAt(0);
            range.deleteContents();
            // Range.createContextualFragment() would be useful here but is
            // non-standard and not supported in all browsers (IE9, for one)
            var el = document.createElement("div");
            el.innerHTML = html;
            var frag = document.createDocumentFragment(), node, lastNode;
            while ( (node = el.firstChild) ) {
                lastNode = frag.appendChild(node);
            }
            range.insertNode(frag);
            
            // Preserve the selection
            if (lastNode) {
                range = range.cloneRange();
                range.setStartAfter(lastNode);
                range.collapse(true);
                sel.removeAllRanges();
                sel.addRange(range);
            }
        }
    } else if (document.selection && document.selection.type != "Control") {
        // IE < 9
        document.selection.createRange().pasteHTML(html);
    }
}
