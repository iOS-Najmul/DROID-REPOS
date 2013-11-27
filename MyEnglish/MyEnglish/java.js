function a() {
	alert('javaScript');
}

function b() {
    return 'dalnimBest';
}
function changeWord(beforeStr, AfterStr)
{
    var word= "([^a-zA-Z])("+beforeStr+")([^a-zA-Z])";
    var rgExp = new RegExp(word,"gi");
    document.body.innerHTML= document.body.innerHTML.replace(rgExp,AfterStr);
}

function reloadOne()
{
//	alert('reloadOne');
    window.location.reload();	
}

function highlightSelWord()
{
	var txt = window.getSelection();
	var range = txt.getRangeAt(0);	
	var newNode = document.createElement("span");	
	newNode.setAttribute("style","background-color:yellow;");	
	range.surroundContents(newNode);	
}

function copySelWord() {
	
//	var x = window.getSelection() ;
//	var z = x.anchorNode.parentNode;
//	alert(z.innerText);
//
//	var zz = z.parentNode;
//	alert("zz.childNodes.length : " + zz.childNodes.length);
////	alert(zz.innerText);
//	
//	var cntChildNode = 0;
//	var strAll = "";
//	for(var i = 0; i < zz.childNodes.length; i++)
//	{
//		if (zz.childNodes[i].firstChild != null)			
//			strAll += "\n" + i + " : " +zz.childNodes[i].nodeType + ", " + zz.childNodes[i].nodeName + ", " + zz.childNodes[i].firstChild.nodeValue; 
//	}
//
//	alert("all : " + strAll);

	
	var txt = window.getSelection();
	var txtSel = txt.focusNode.textContent.substr(txt.anchorOffset, txt.focusOffset - txt.anchorOffset);
	return txtSel;
//	return (txt.anchorOffset + '|' + txt.anchorNode.textContent + '|' + txt.focusOffset + '|' + txt.focusNode.textContent + '|' + txt.focusNode);
}

function copySelText() {
	var txt = window.getSelection();
    var returnText = "";
    if (txt.anchorNode.textContent != "") {
        if (txt.anchorNode.textContent == txt.focusNode.textContent){
            returnText = txt.anchorNode.textContent;
        } else {
            returnText = txt.anchorNode.textContent + ' ' + txt.focusNode.textContent;
        }
//	return (txt.anchorOffset + '|' + txt.anchorNode.textContent + '|' + txt.focusOffset + '|' + txt.focusNode.textContent + '|' + txt.focusNode);
    }
    return returnText;
}

function f1() {
	var txt = '';
		if (window.getSelection)
		{
			txt = window.getSelection();
		}
		else if (document.getSelection)
		{
			txt = document.getSelection();
		}
		else if (document.selection)
		{
			txt = document.selection.createRange().text;
		}
		
		else return;
	return txt;
}

function findInPage(str) {
	var txt, i, found;
	if (str == "")
		return false;
		txt = win.document.body.createTextRange();		
		for (i = 0; i <= n && (found = txt.findText(str)) != false; i++) {
			txt.moveStart("character", 1);
			txt.moveEnd("textedit");
		}
		
		if(found) {
			txt.moveStart("character", -1);
			txt.findText(str);				
			txt.select();
			txt.scrollIntoView();
			var sel = document.selection;
			var rng = sel.createRange();
			rng.pasteHTML("<font style='background-color:red;color:white;'>"+ rng.htmlText + "</font>");
			n++;
		}else {
			if (n > 0) {
				n = 0;
				findInPage(str);
			}
			else
				alert(str + " 는(은) 페이지내에 없습니다..");
		}
	
	return false;
}


// helper function, recursively searches in elements and their child nodes
//function MyApp_HighlightAllOccurencesOfStringForElement(element,keyword) {
//	var word = "([^a-z])("+keyword+")([^a-z])";
//	var rgExp = new RegExp(word,"gi");
//	
//	if (element) {
//		if (element.nodeType == 3) {        // Text node
//			while (true) {
//				var value = element.nodeValue;  // Search for keyword in text node
//				var idx = value.toLowerCase().indexOf(keyword);
//
////				var resultArray = rgExp.test(value);
////				alert('array : ' + resultArray + ' ' + value);								
////				if (resultArray == false) break;
//				//var idx = value.indexOf(resultArray[0]);
//				if (idx < 0) break;             // not found, abort
////				alert("idx : " + idx);								
////				var resultArray1 = value.replace(rgExp,"$1(_$2_)$3");
////				alert("resultArray1 : " + resultArray1);
//				
//				var span = document.createElement("span");
//				var text = document.createTextNode(value.substr(idx,keyword.length));
////				var text = document.createTextNode(value.substr(idx,resultArray[0].length));
//				span.appendChild(text);
//				span.setAttribute("class","MyAppHighlight");
//				span.style.backgroundColor="yellow";
//				span.style.color="black";
//				text = document.createTextNode(value.substr(idx+keyword.length));
////				text = document.createTextNode(value.substr(idx+resultArray[0].length));
//				element.deleteData(idx, value.length - idx);
//				var next = element.nextSibling;
//				element.parentNode.insertBefore(span, next);
//				element.parentNode.insertBefore(text, next);
//				//element = text;
//				MyApp_SearchResultCount++;	// update the counter
//			}
//		} else if (element.nodeType == 1) { // Element node
//			if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
//				for (var i=element.childNodes.length-1; i>=0; i--) {
//					MyApp_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword);
//				}
//			}
//		}
//	}
//}

//정규표현식을 통한 하일라이트... 잘안됨...
//function MyApp_HighlightAllOccurencesOfStringForElement(element,keyword) {
//	var word = "([^a-z])("+keyword+")([^a-z])";
//	var rgExp = new RegExp(word,"gi");
//
//	if (element) {
//		if (element.nodeType == 3) {        // Text node
//			while (true) {
//				var value = element.nodeValue;  // Search for keyword in text node
//				if	((value == null) || (value.replace(/^\s\s*/, '').replace(/\s\s*$/, '') == ""))
//					break;
////				alert("value _" + value + "_");
////				var resultArray = rgExp.exec(value);
////				alert("resultArray " + resultArray.index + " length : " + keyword.length);
////				var idx = resultArray.index;
//				var idx = value.toLowerCase().indexOf(keyword);
////				alert("idx " + idx);				
//				if (idx < 0) break;             // not found, abort
//				
////				var resultArray = rgExp.exec(value);
////				alert("resultArray idx " + resultArray.index);
//				var resultArray1 = value.replace(rgExp,"$1(_$2_)$3");
////				alert("resultArray1\n" + resultArray1);
////				alert("value\n" + value);
//				var span = document.createElement("span");
//				var text = document.createTextNode(value.substr(idx,keyword.length)+"(?)");
//				span.appendChild(text);
//				span.setAttribute("class","MyAppHighlight");
////				span.style.backgroundColor="yellow";
//				span.style.color="blue";
//				
//				text = document.createTextNode(value.substr(idx+keyword.length));
////				alert("text2\n" + text.nodeValue);
//				element.deleteData(idx, value.length - idx);
//				var next = element.nextSibling;
//				element.parentNode.insertBefore(span, next);
//				element.parentNode.insertBefore(text, next);
//				element = text;
//				MyApp_SearchResultCount++;	// update the counter
//			}
//		} else if (element.nodeType == 1) { // Element node
//			if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
//				for (var i=element.childNodes.length-1; i>=0; i--) {
//					MyApp_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword);
//				}
//			}
//		}
//	}
//}

function aaa(keyword) {
	
	//var myRe=/d(b+)(d)/ig;
	
	//var myArray = myRe.exec("cdbBdbsbz");
	
	//alert('myArray ; ' + myArray);
	
	
	
	//var word = "(\b)("+"new"+")(\b)";
	
	//          var rgExp = /([^a-z])(+word+)([^a-z])/gi;
	
	//          var rgExp = /word/gi;
	
	alert('keyword : ' + keyword);
	var word = "([^a-zA-Z])("+ keyword+")([^a-zA-Z])";	
	var rgExp = new RegExp(word,"gi");
	var str = "my his(2) is myNew not new new  new  newis NEW new New neW nEW NEw nEw myNEWis and NEW NEw and (new) (new) or 9NEW's 9NEW's new";	
	//var result = str.replace(rgExp,"$1$2(dal)$3");
	var result2 = rgExp.exec(str);
	if	(result2)
		alert('test2 index: ' + result2.index);		
	else
		alert('test2 index: 0');
}


var count = 0;
var colorKnow1 = "blue";
var colorKnow2 = "brown";
// helper function, recursively searches in elements and their child nodes
function MyApp_HighlightAllOccurencesOfStringForElement(element,keyword, strKnow, strMeaning) {
	if (element) {
		if (element.nodeType == 3) {        // Text node
			while (true) {
				var value = element.nodeValue;  // Search for keyword in text node
				//var idx = value.toLowerCase().indexOf(keyword.toLowerCase());
                var idx = -1;
	            var word = "([^a-zA-Z]|^)("+keyword+")([^a-zA-Z]|$)";
	            var rgExp = new RegExp(word,"gi");
				
				var resultArray = rgExp.exec(value);
                if (resultArray != undefined)
                {
                    idx = resultArray.index; 
                }
				if (idx < 0) break;             // not found, abort
				
                
				var span = document.createElement("span");
                if  ((strMeaning == undefined) || (strMeaning == ""))
                {
//                    alert('keyword nomeaning : ' + keyword);
                    var text = document.createTextNode(resultArray[2]);
                }
                else
                {
//                    alert('keyword meaingn : ' + keyword + '[' + strMeaning + ']');
				    var text = document.createTextNode(resultArray[2]+'['+strMeaning+']');
                }
				span.appendChild(text);
                var attrName = "MyAppHighlight" + keyword.toLowerCase();
				span.setAttribute("class",attrName);
				//span.setAttribute("class","MyAppHighlight");
//                span.style.backgroundColor="yellow";
				span.style.fontWeight="normal";
                if  (strKnow == "1"){
				    span.style.color=colorKnow1;
                } else if (strKnow == "2") {
//				    span.style.backgroundColor="yellow";
				    span.style.color=colorKnow2;
//					span.style.textDecoration="underline"
				    //span.style.fontWeight="bold";
                } else {
				    span.style.color="black";
                }
				
				//text = document.createTextNode(value.substr(idx+keyword.length));
				text = document.createTextNode(resultArray[3] + value.substr(rgExp.lastIndex));
				//element.deleteData(idx+resultArray[0].length, value.length - idx);
				element.deleteData(idx+resultArray[1].length, value.length - idx);
				var next = element.nextSibling;
				element.parentNode.insertBefore(span, next);
				element.parentNode.insertBefore(text, next);
				element = text;
				MyApp_SearchResultCount++;	// update the counter
			}
		} else if (element.nodeType == 1) { // Element node
			if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
				for (var i=element.childNodes.length-1; i>=0; i--) {
					//for (var i=0; i < element.childNodes.length-1; i++) {
					MyApp_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword, strKnow, strMeaning);
				}
			}
		}
	}
}

// the main entry point to start the search
function MyApp_HighlightAllOccurencesOfString(keyword,strKnow, strMeaning) {
    count = 0;
	MyApp_RemoveAllHighlights(keyword);
	//alert('keyword : ' + keyword);
	MyApp_HighlightAllOccurencesOfStringForElement(document.body, keyword, strKnow, strMeaning);
}

// helper function, recursively removes the highlights in elements and their childs
function MyApp_RemoveAllHighlightsForElement(element,keyword) {
    if (element) {        
      	if (element.nodeType == 1) {
            var attrName = "MyAppHighlight" + keyword.toLowerCase();
            if (element.getAttribute("class") == attrName) {
                MyApp_SearchResultCount++;
                var keywordInTxt = element.firstChild.nodeValue;
                var word = "(" + keyword+")(.*)";
	            var rgExp = new RegExp(word,"gi");
                var result = keywordInTxt.replace(rgExp,"$1");
                //if  ( MyApp_SearchResultCount == 1) {
				//alert('keywordInTxt : ' + keywordInTxt);
				//alert('onlyKeyword : ' + result);
                //}
                var text = element.removeChild(element.firstChild);
                //element.parentNode.insertBefore(text,element);
                var textNode = document.createTextNode(result);
                element.parentNode.insertBefore(textNode,element);
                element.parentNode.removeChild(element);
                return true;
            } else {
                var normalize = false;
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    if (MyApp_RemoveAllHighlightsForElement(element.childNodes[i], keyword)) {
                        normalize = true;
                    }
                }
            }
            if (normalize) {
                element.normalize();
            }
        } 
	}
	return false;
}

// the main entry point to remove the highlights
function MyApp_RemoveAllHighlights(keyword) {
	MyApp_SearchResultCount = 0;
	MyApp_RemoveAllHighlightsForElement(document.body,keyword);
}

function MyApp_changeColor() {
    document.bgColor = "blue";
    document.fgColor = "gray";
}

function MyApp_changeBackgoundColor(strColor) {
    document.bgColor = strColor;
}

function MyApp_changeFontColor(strColor) {
    document.fgColor = strColor;
}

function MyApp_changeColorKnow1(strColor) {
    colorKnow1 = strColor;
}

function MyApp_changeColorKnow2(strColor) {
    colorKnow2 = strColor;
}
//================
// 웟첨자를 다는 소스
//================
// helper function, recursively searches in elements and their child nodes
function MyApp_AddSubForElement(element,keyword, strKnow, count) {
	if (element) {
		if (element.nodeType == 3) {        // Text node
			while (true) {				
				var value = element.nodeValue;  // Search for keyword in text node
				//var idx = value.toLowerCase().indexOf(keyword.toLowerCase());
                var idx = -1;
	            var word = "([^a-zA-Z]|^)("+keyword+")([^a-zA-Z]|$)";
	            var rgExp = new RegExp(word,"gi");
				
				var resultArray = rgExp.exec(value);
                if (resultArray != undefined)
                {
                    idx = resultArray.index; 
                }
				if (idx < 0) break;             // not found, abort
				
                alert('keyword : ' + keyword);
				var span = document.createElement("span");
//				alert('count : ' + count);
                if  ((count == undefined) || (count == "") || (count == "0"))
                {
                    var text = document.createTextNode(resultArray[2]);
					span.appendChild(text);
                }
                else
                {
				    var text = document.createTextNode(resultArray[2]);
					var para = document.createElement("sup");
					para.innerHTML = count;					
					span.appendChild(text);						
					span.appendChild(para);	
                }
                var attrName = "MyAppSub" + keyword.toLowerCase();
				span.setAttribute("class",attrName);
				//span.setAttribute("class","MyAppHighlight");
				//                span.style.backgroundColor="yellow";
				span.style.fontWeight="normal";
                if  (strKnow == "1"){
				    span.style.color= colorKnow1;
                } else if (strKnow == "2") {
				    span.style.backgroundColor="yellow";
				    span.style.color= colorKnow2;
				    //span.style.fontWeight="bold";
                } else {
				    span.style.color="black";
                }
				
				//text = document.createTextNode(value.substr(idx+keyword.length));
				text = document.createTextNode(resultArray[3] + value.substr(rgExp.lastIndex));
				//element.deleteData(idx+resultArray[0].length, value.length - idx);
				element.deleteData(idx+resultArray[1].length, value.length - idx);
				var next = element.nextSibling;
				element.parentNode.insertBefore(span, next);
				element.parentNode.insertBefore(text, next);
				element = text;
				MyApp_SearchResultCount++;	// update the counter
			}
		} else if (element.nodeType == 1) { // Element node
			if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
				for (var i=element.childNodes.length-1; i>=0; i--) {
					//for (var i=0; i < element.childNodes.length-1; i++) {
					MyApp_AddSubForElement(element.childNodes[i],keyword, strKnow, count);
				}
			}
		}
	}
}

// the main entry point to start the search
function MyApp_AddSub(keyword, strKnow, count) {
	MyApp_RemoveSub(keyword);
	MyApp_AddSubForElement(document.body, keyword, strKnow, count);
}

// helper function, recursively removes the highlights in elements and their childs
function MyApp_RemoveSubForElement(element,keyword) {
    if (element) {
      	if (element.nodeType == 1) {
            var attrName = "MyAppSub" + keyword.toLowerCase();
            if (element.getAttribute("class") == attrName) {
                MyApp_SearchResultCount++;
                var keywordInTxt = element.firstChild.nodeValue;
                var word = "(" + keyword+")(.*)";
	            var rgExp = new RegExp(word,"gi");
                var result = keywordInTxt.replace(rgExp,"$1");
                //if  ( MyApp_SearchResultCount == 1) {
				//alert('keywordInTxt : ' + keywordInTxt);
				//alert('onlyKeyword : ' + result);
                //}
                var text = element.removeChild(element.firstChild);
                //element.parentNode.insertBefore(text,element);
                var textNode = document.createTextNode(result);
                element.parentNode.insertBefore(textNode,element);
                element.parentNode.removeChild(element);
                return true;
            } else {
                var normalize = false;
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    if (MyApp_RemoveSubForElement(element.childNodes[i], keyword)) {
                        normalize = true;
                    }
                }
            }
            if (normalize) {
                element.normalize();
            }
        } 
	}
	return false;
}

// the main entry point to remove the highlights
function MyApp_RemoveSub(keyword) {
	MyApp_SearchResultCount = 0;
	MyApp_RemoveSubForElement(document.body,keyword);
}



// We're using a global variable to store the number of occurrences
//var MyApp_SearchResultCount = 0;
//
// helper function, recursively searches in elements and their child nodes
//function MyApp_HighlightAllOccurencesOfStringForElement(element,keyword, strKnow, strMeaning) {
//	if (element) {		
//		if (element.nodeType == 3) {        // Text node			
//			while (true) {				
//				var value = element.nodeValue;  // Search for keyword in text node				
//				var idx = -1;				
//				var word = "([^a-zA-Z]|^)("+keyword+")([^a-zA-Z]|$)";				
//				var rgExp = new RegExp(word,"gi");
//				var resultArray = rgExp.exec(value);				
//                if (resultArray == undefined)					
//                {					
//                    idx = -1;					
//                }else					
//                {					
//                    idx = resultArray.index;	
//                }
//				
//				if (idx < 0) break;             // not found, abort
//				
//				var span = document.createElement("span");				
//                if  ((strMeaning == undefined) || (strMeaning == ""))					
//                {
//                    var text = document.createTextNode(resultArray[2]);					
//                }			
//                else					
//                {					
//					var text = document.createTextNode(resultArray[2] + '['+strMeaning+']');					
//                }				
//				span.appendChild(text);				
//				span.setAttribute("class","MyAppHighlight" + keyword.toLowerCase());				
//				span.style.fontWeight="normal";				
//                if  (strKnow == "1"){					
//					span.style.color="blue";					
//                } else if (strKnow == "2") {					
//					//span.style.backgroundColor="yellow";					
//					span.style.color="lime";					
//					//bold는 지우지말것
//					//span.style.fontWeight="bold";					
//                } else {					
//					span.style.color="black";					
//                }
//				
//				text = document.createTextNode(resultArray[3] + value.substr(rgExp.lastIndex));
//				element.deleteData(idx+resultArray[1].length, value.length - idx);				
//				var next = element.nextSibling;				
//				element.parentNode.insertBefore(span, next);				
//				element.parentNode.insertBefore(text, next);				
//				element = text;				
//				MyApp_SearchResultCount++;      // update the counter				
//			}			
//		} else if (element.nodeType == 1) { // Element node			
//			if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {				
//				for (var i=element.childNodes.length-1; i>=0; i--) {					
//					//for (var i=0; i < element.childNodes.length-1; i++) {					
//					MyApp_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword, strKnow, strMeaning);					
//				}				
//			}			
//		}		
//	}
//}
//
// the main entry point to start the search
//function MyApp_HighlightAllOccurencesOfString(keyword, strKnow, strMeaning) {
//	//remove가 제대로 안되는것 같다.
//	MyApp_RemoveAllHighlights(keyword, strKnow);
//	alert('sel : ' + keyword + "," + strKnow);
//	MyApp_HighlightAllOccurencesOfStringForElement(document.body, keyword, strKnow, strMeaning);		
//}
//
//function MyApp_RemoveAllHighlightsForElement(element,keyword) {	
//    if (element) {
//		if (element.nodeType == 1) {			
//            var attrName = "MyAppHighlight" + keyword.toLowerCase();			
//            if (element.getAttribute("class") == attrName) {				
//                MyApp_SearchResultCount++;				
//                var keywordInTxt = element.firstChild.nodeValue;				
//                var word = "(" + keyword+")(.*)";				
//				var rgExp = new RegExp(word,"gi");				
//                var result = keywordInTxt.replace(rgExp,"$1");				
//                if  ( MyApp_SearchResultCount == 1) {					
//                    alert('keywordInTxt : ' + keywordInTxt);					
//                    alert('onlyKeyword : ' + result);					
//                }				
//                var text = element.removeChild(element.firstChild);				
//                //element.parentNode.insertBefore(text,element);				
//                var textNode = document.createTextNode(result);				
//                element.parentNode.insertBefore(textNode,element);				
//                element.parentNode.removeChild(element);				
//                return true;				
//            } else {				
//                var normalize = false;				
//                for (var i=element.childNodes.length-1; i>=0; i--) {					
//                    if (MyApp_RemoveAllHighlightsForElement(element.childNodes[i], keyword)) {						
//                        normalize = true;						
//                    }					
//                }				
//            }			
//            if (normalize) {				
//                element.normalize();				
//            }			
//        }		
//	}	
//	return false;	
//}
//
// the main entry point to remove the highlights
//function MyApp_RemoveAllHighlights(keyword) {	
//	MyApp_SearchResultCount = 0;	
//	MyApp_RemoveAllHighlightsForElement(document.body,keyword);	
//}
