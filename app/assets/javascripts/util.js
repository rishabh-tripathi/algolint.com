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

function getCodeEditorMode(file_type) { 
    var mode = "";
    if(file_type == 0) {
	mode = "text/plain";
    } else if(file_type == 10) {
	mode = "text/x-c++src";
    } else if(file_type == 20) {    	
	mode = "text/x-java";
    } else if(file_type == 30) {
	mode = "text/x-ruby";
    } else if(file_type == 40) {
	mode = "{name: 'python', version: 2, singleLineStringErrors: false}";
    }
    return mode;
}

function loadCodeEditorForView(id, file_type) {
    var mode = getCodeEditorMode(file_type);
    return CodeMirror.fromTextArea(ele(id), {
	mode: mode,
	indentUnit: 4,
	readOnly: true,
	smartIndent: true,
	lineNumbers: true,
	viewportMargin: Infinity
    });
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
