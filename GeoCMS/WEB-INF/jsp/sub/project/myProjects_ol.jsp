<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%
String loginId = (String)session.getAttribute("loginId");					//로그인 아이디
String loginToken = (String)session.getAttribute("loginToken");				//로그인 token
%>



<style>
/* The container */
.container {
    display: block;
    position: relative;
    padding-left: 35px;
    margin-bottom: 12px;
    cursor: pointer;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
}

input[class="cb1"] + label {
	display: inline-block;
	width: 10px;
	height: 10px;
	border: 2px solid #bcbcbc;
	cursor: pointer;
}

input[class="cb1"]:checked + label {
	background-color: #666666;
}

input[class="cb1"] {
	display: none;
}

.layerName{
/* 	margin-top: 30px; */
    font-size: 18px;
    padding: 3px;
    top: 0px;
    z-index: 50;
    width: auto;
    color:white;
    margin-left: 10px;
    margin-bottom: 10px;
    font-weight: 600;
}

.serverName{
	/* background:white; */
	font-size:18px;
	color:#000000;
}

.layerName2{
	position:absolute;
	top:30px;
	left: 20px;
    font-size: 18px;
    background: white;
    padding: 3px;
}

/* Hide the browser's default radio button */
.container input {
    position: absolute;
    opacity: 0;
    cursor: pointer;
}

/* Create a custom radio button */
.checkmark {
    position: absolute;
    top: 0px;
    left: 4px;
    height: 20px;
    width: 20px;
    background-color: white;
    border-radius: 50%;
    border:1px solid #297ACC;
}

/* On mouse-over, add a grey background color */
.container:hover input ~ .checkmark {
    background-color: #ccc;
}

/* When the radio button is checked, add a blue background */
.container input:checked ~ .checkmark {
    background-color: white;
}

/* Create the indicator (the dot/circle - hidden when not checked) */
.checkmark:after {
    content: "";
    position: absolute;
    display: none;
}

/* Show the indicator (dot/circle) when checked */
.container input:checked ~ .checkmark:after {
    display: block;
}

/* Style the indicator (dot/circle) */
.container .checkmark:after {
 	top: 5px;
	left: 5px;
    width:10px;
    height:10px;
    border-radius:50%;
	background: #297ACC;
}

#jstree2{
    padding: 12px 0px 0px 0px;
    border-radius: 5px;
}

#jstree3{
    /* border: 1px solid black; */
    padding: 12px 0px;
    border-radius: 5px;
}
</style>

<script type="text/javascript">
var loginId = '<%= loginId %>';				//로그인 아이디
var loginToken = '<%= loginToken %>';		//로그인 token

var proContentNum = 12;
// var proType = '';
var proIdx = 0;
var proEdit = 0;
var oldShareUser = 0;

function projectGroupListSetup(response){
	$('.viewModeCls').css('display','block');
	typeShape = 'marker';
	
	$('#project_list_table').empty();
	proIdx = response[0].idx;
	shareInit();
	if(proEdit == 1){
		moveProContent();
	}
	
	markerProArr = new Array();
	addProjectGroupCell(response);
}

//project group list
function addProjectGroupCell(response){
	var innerHTML = '';
	var outerHTML = '';
	innerHTML += '<div id="jstree">';
	/* innerHTML += '<div id="serverLayer" class="layerName">';
	innerHTML += 'Server Layers';
	innerHTML += '</div>'; */	
	innerHTML += '<div id="jstree2">';
	innerHTML += '<div id="serverLayers" class="layerName"> <span id="serverSubject" class="serverName">Server Layers</span> <div style="float:right; margin-right:10px;"><button id="proAddBtn" onclick="openAddProjectName();">Add Layer</button></div> </div>';
	if(response != null){
		for(var i=0;i<response.length;i++){
			if(response[i].projectname == "Local Name")
			{
				var proShare = '';
				if(response[i].sharetype == '1'){
	// 				proShare = '전체공개';
					proShare = 'FULL';
				}else if(response[i].sharetype == '0'){
	// 				proShare = '비공개';
					proShare = 'NON';
				}else{
	// 				proShare = '선택공개';
					proShare = 'SELECTIVE';
				}
				var projectNameTxt = response[i].projectname.length>20? response[i].projectname.substring(0,20)+'...' : response[i].projectname;
				//innerHTML += '<div id="pName_'+ response[i].idx+'" ';
				outerHTML += '<ul>';
				outerHTML += '<li id="node_'+ response[i].idx+'" class="jstree-local-open">';
				outerHTML += '<div style="padding:5px;">';
				outerHTML += '<input type="checkbox" id="check_'+response[i].idx+'" style="float:left;" class="cb1"/>';
				outerHTML += '<label for="check_'+response[i].idx+'"></label>'
				outerHTML += "<label class='titleLabel' title='"+ response[i].projectname +"' style='width:130px !important;font-size: 15px;margin-top:3px;'>"+ projectNameTxt +"</label>";
				outerHTML += '</div>';
				outerHTML += '</li>';
				
	
				//innerHTML += 'class="offProjectDiv">';
				//innerHTML += 'class="jstree-open">';
				
				outerHTML += "<input type='hidden' id='hiddenProName_"+ response[i].idx +"' value='"+ response[i].projectname +"'/>";
				outerHTML += '<input type="hidden" id="hiddenProUserIn_'+ response[i].idx +'" value="'+ response[i].editUserIn +'"/>';
				outerHTML += '<input type="hidden" id="hiddenShareType_'+ response[i].idx +'" value="'+ response[i].sharetype +'"/>';
				//innerHTML += '<input type="checkbox" style="float:left;"/>';
				
				/* outerHTML += '<li id="child_node_1">';
				//innerHTML += '<input type="checkbox" style="float:left;"/>';
				outerHTML += "<label class='titleLabel' title='"+ response[i].projectname +"' style='width:130px !important;font-size: 16px;display: inline-block;margin-top:3px;'>"+ projectNameTxt +"</label>";
				outerHTML += '</li>'; */
	// 			//edit btn
	// 			if(loginId == response[i].id){
	// 				innerHTML += '<button onclick="editProject('+ response[i].idx +');" class="editProBtn" style="border-radius:5px; margin:3px 5px 0 0px;"> Manage </button>';
	// 	 		}
				
	// 			if(loginId == response[i].id){
	// 				innerHTML += '<button onclick="editProject('+ response[i].idx +');" class="editProBtn" style="border-radius:5px;"> EDIT </button>';
	// 				innerHTML += '<button onclick="openProjectWriter();" class="editProBtn" style="border-radius:5px; margin:3px 5px 0 5px;"> Edit Annotation </button>';
	// 			}
	
				//upload btn
	 			//innerHTML += '<button onclick="openProjectViewer('+ response[i].idx +');" class="editFileBtn" style="border-radius:5px; float:right; margin-top:3px;"> Viewer </button>';
				
				var tmpUserId = response[i].id.length>7? response[i].id.substring(0,7)+'...' : response[i].id;
				//innerHTML += '<div class="subDivCls" style="float:right;font-size:12px;margin-top:5px;color:#ddd;margin-right:5px;">';
				//innerHTML +='<label class="m_l_10" style="font-size: 11px;">WRITER: </label><label style="display:inline-block; width:45px;font-size: 11px;" title="'+ response[i].id +'">'+ tmpUserId + '</label><label class="margin-left:5px;" style="font-size: 11px;">DATE: </label><label style="font-size: 11px;">' + response[i].u_date + '</label><label style="margin-left:5px;font-size: 11px;">'+ proShare + '</label>';
				//innerHTML += '</div>';
				
				if(response[i].edituserin == 'Y' ||  (loginId != null && loginId != '' && loginId != 'null' && response[i].id == loginId)){
					//innerHTML += '<button id="makeContents'+ response[i].idx +'" onclick="myContentsMake('+ response[i].idx +');" style="border-radius: 2px; border: none; font-size: 11px; padding: 9px 15px; display: inline-block; background: #F0F2F5; color: #4789D1; margin-top: 15px; float:left;">Upload geoContents</button>';
					//innerHTML += '<button onclick="openProjectWriter();" class="editProBtn" style="border-radius: 2px; border: none; font-size: 11px; padding: 9px 15px; display: inline-block; background: #F0F2F5; color: #4789D1; margin-top: 15px; float:left;"> Edit Annotation </button>';
				}
				
				//innerHTML += '<button onclick="openProjectViewer('+ response[i].idx +');" class="editFileBtn" style="border-radius: 2px; border: none; font-size: 11px; padding: 9px 15px; display: inline-block; background: #F0F2F5; color: #4789D1; margin-top: 15px; float:left;"> Viewer </button>';
				//edit btn
				if(loginId == response[i].id){
					//innerHTML += '<button onclick="editProject('+ response[i].idx +');" class="editProBtn" style="border-radius: 2px; border: none; font-size: 11px; padding: 9px 15px; display: inline-block; background: #F0F2F5; color: #4789D1; margin-top: 15px; float:left;"> Manage </button>';
		 		}
				//innerHTML += '</li>';
				outerHTML += '</ul>';
	
				//innerHTML += '<table id="pChild_'+ response[i].idx + '" style="border:1px solid gray; width:100%;"/>';
				//innerHTML += '</div>';
			}
			else
			{
				var proShare = '';
				if(response[i].sharetype == '1'){
	// 				proShare = '전체공개';
					proShare = 'FULL';
				}else if(response[i].sharetype == '0'){
	// 				proShare = '비공개';
					proShare = 'NON';
				}else{
	// 				proShare = '선택공개';
					proShare = 'SELECTIVE';
				}
				var projectNameTxt = response[i].projectname.length>20? response[i].projectname.substring(0,20)+'...' : response[i].projectname;
				//innerHTML += '<div id="pName_'+ response[i].idx+'" ';
				innerHTML += '<ul>';
				innerHTML += '<li id="node_'+ response[i].idx+'" class="jstree-open">';
				innerHTML += '<div style="padding:5px;">';
				innerHTML += '<input type="checkbox" id="check_'+response[i].idx+'" style="float:left;" class="cb1"/>';
				innerHTML += '<label for="check_'+response[i].idx+'"></label>'
				innerHTML += "<label class='titleLabel' title='"+ response[i].projectname +"' style='width:130px !important;font-size: 15px;margin-top:3px;'>"+ projectNameTxt +"</label>";
				innerHTML += '</div>';
				innerHTML += '<div id="subNode_'+ response[i].idx+'" class="jstree-open"></div>';
				innerHTML += '</li>';
	
				//innerHTML += 'class="offProjectDiv">';
				//innerHTML += 'class="jstree-open">';
				
				innerHTML += "<input type='hidden' id='hiddenProName_"+ response[i].idx +"' value='"+ response[i].projectname +"'/>";
				innerHTML += '<input type="hidden" id="hiddenProUserIn_'+ response[i].idx +'" value="'+ response[i].editUserIn +'"/>';
				innerHTML += '<input type="hidden" id="hiddenShareType_'+ response[i].idx +'" value="'+ response[i].sharetype +'"/>';
				innerHTML += '<div id="subTimeNode_'+ response[i].idx+'" class="jstree-open" style="margin-right: 12px;"></div>';
				//innerHTML += '<input type="checkbox" style="float:left;"/>';
				
				/* innerHTML += '<li id="child_node_1">';
				//innerHTML += '<input type="checkbox" style="float:left;"/>';
				innerHTML += "<label class='titleLabel' title='"+ response[i].projectname +"' style='width:130px !important;font-size: 16px;display: inline-block;margin-top:3px;'>"+ projectNameTxt +"</label>";
				innerHTML += '</li>'; */
	// 			//edit btn
	// 			if(loginId == response[i].id){
	// 				innerHTML += '<button onclick="editProject('+ response[i].idx +');" class="editProBtn" style="border-radius:5px; margin:3px 5px 0 0px;"> Manage </button>';
	// 	 		}
				
	// 			if(loginId == response[i].id){
	// 				innerHTML += '<button onclick="editProject('+ response[i].idx +');" class="editProBtn" style="border-radius:5px;"> EDIT </button>';
	// 				innerHTML += '<button onclick="openProjectWriter();" class="editProBtn" style="border-radius:5px; margin:3px 5px 0 5px;"> Edit Annotation </button>';
	// 			}
	
				//upload btn
	 			//innerHTML += '<button onclick="openProjectViewer('+ response[i].idx +');" class="editFileBtn" style="border-radius:5px; float:right; margin-top:3px;"> Viewer </button>';
				
				var tmpUserId = response[i].id.length>7? response[i].id.substring(0,7)+'...' : response[i].id;
				//innerHTML += '<div class="subDivCls" style="float:right;font-size:12px;margin-top:5px;color:#ddd;margin-right:5px;">';
				//innerHTML +='<label class="m_l_10" style="font-size: 11px;">WRITER: </label><label style="display:inline-block; width:45px;font-size: 11px;" title="'+ response[i].id +'">'+ tmpUserId + '</label><label class="margin-left:5px;" style="font-size: 11px;">DATE: </label><label style="font-size: 11px;">' + response[i].u_date + '</label><label style="margin-left:5px;font-size: 11px;">'+ proShare + '</label>';
				//innerHTML += '</div>';
				
				if(response[i].edituserin == 'Y' ||  (loginId != null && loginId != '' && loginId != 'null' && response[i].id == loginId)){
					//innerHTML += '<button id="makeContents'+ response[i].idx +'" onclick="myContentsMake('+ response[i].idx +');" style="border-radius: 2px; border: none; font-size: 11px; padding: 9px 15px; display: inline-block; background: #F0F2F5; color: #4789D1; margin-top: 15px; float:left;">Upload geoContents</button>';
					//innerHTML += '<button onclick="openProjectWriter();" class="editProBtn" style="border-radius: 2px; border: none; font-size: 11px; padding: 9px 15px; display: inline-block; background: #F0F2F5; color: #4789D1; margin-top: 15px; float:left;"> Edit Annotation </button>';
				}
				
				//innerHTML += '<button onclick="openProjectViewer('+ response[i].idx +');" class="editFileBtn" style="border-radius: 2px; border: none; font-size: 11px; padding: 9px 15px; display: inline-block; background: #F0F2F5; color: #4789D1; margin-top: 15px; float:left;"> Viewer </button>';
				//edit btn
				if(loginId == response[i].id){
					//innerHTML += '<button onclick="editProject('+ response[i].idx +');" class="editProBtn" style="border-radius: 2px; border: none; font-size: 11px; padding: 9px 15px; display: inline-block; background: #F0F2F5; color: #4789D1; margin-top: 15px; float:left;"> Manage </button>';
		 		}
				//innerHTML += '</li>';
				innerHTML += '</ul>';
	
				innerHTML += '<div id="pChild_'+ response[i].idx + '" style="width:100%;"></div>';
				innerHTML += '</div>';
				
			}
		}
			
		if(response[0].idx != null && response[0].idx != '' && response[0].idx != undefined){
			//fnProjectDiv($('#pName_'+response[0].idx), response[0].idx);
		}
		
		
		clickProjectPage(1,proIdx, null);
	}
	
	innerHTML += '</div>';
	innerHTML += '<div id="jstree3">';
	innerHTML += '<div id="localLayers" class="layerName" style="margin-top: 20px;"> '
	innerHTML += '<span id="localSubject" class="serverName">Local Layers</span>';
	innerHTML += '</div>'
	innerHTML += outerHTML;
	innerHTML += '</div>';
	$("#check_17").change(function(){
		if($("#check_17").is(":checked") == true){
			alert("체크박스 체크");
		}
		else
		{
			alert("체크박스 미체크");
		}
	});
	$('#project_list_table').append(innerHTML);
	var checkId = $("#jstree").find('ul li').attr('id');
	
// 	$('[id^=node_]').hover(function() {
// 		$(this).css('background-color', 'gray');
// 	});
	
// 	$('.jstree-open').contextMenu('context3', {
	$('[id^=node_]').contextMenu('context3', {
		bindings: {
			'context_upload': function(t) {
				myContentsMake(t.id.split("_")[1]);
// 				if($("#check_"+t.id.split("_")[1]).is(":checked") == true) {
// 					myContentsMake(t.id.split("_")[1]);
// 				} else {
// 					$("#check_"+t.id.split("_")[1]).attr("checked", true);
// 					myContentsMake(t.id.split("_")[1]);
// 				}
			},
			'context_view': function(t){
				openProjectViewer(t.id.split("_")[1]);
			},
			'context_view_google': function(t){
				openProjectViewerGoogle(t.id.split("_")[1]);
			},
			'context_manage': function(t){
				editProject(t.id.split("_")[1]);
			},
			'context_analysis': function(t){
				analysisProject(t.id.split("_")[1]);
			}
// 			'context_edit': function(t){
// 				var tableId = $(t).closest('table').attr( 'id' );
// 				openProjectWriter();
// 			}
		}
	});
	/* $('.jstree-local-open').contextMenu('context4', {
		bindings: {
			'context_save': function(t){
				var tableId = $(t).closest('table').attr( 'id' );
				editProject(t.id.split("_")[1]);
			},
			'context_analysis': function(t){
				var tableId = $(t).closest('table').attr( 'id' );
				analysisProject(t.id.split("_")[1]);
			}
		}
	}); */
	
	$(".cb1").change(function(){
		var checkId = $(this).attr('id');
		var checkList = checkId.split("_");
		var checkNum = checkList[1];
		if($("#check_"+checkNum).is(":checked") == true){
// 			$("#node_"+checkNum).css("background", "#d3d6dc");
			projectMarkerData(checkNum);
			clickProjectPage(1,checkNum,null);
		}
		else
		{
// 			$("#node_"+checkNum).css("background", "white");
			projectMarkerData(checkNum);
			$("#subTimeNode_"+checkNum).empty();
		}
	});
	$("#checkGps").change(function(){
		var checkId = $(this).attr('id');
		var checkList = checkId.split("_");
		var checkNum = checkList[1];
		if($("#checkGps").is(":checked") == true)
		{
			$("#subGpsView").append("<")	
		}
		else
		{
			$("#node_"+checkNum).css("background", "white");
			projectMarkerData(checkNum);
			$("#subTimeNode_"+checkNum).empty();
		}
	});
	/* $("#check_26").change(function(){
		if($("#check_26").is(":checked") == true){
			projectMarkerData(26);
		}
		else
		{
			projectMarkerData(26);
		}
	}); */
}

//project group open close
var editBtnClk = 0;


function fnProjectDiv(obj, projectIdx){
	if(editBtnClk != 0){
		editBtnClk = 0;
		return;
	}
	
	if($(obj).hasClass('onProjectDiv')){
		$(obj).removeClass('onProjectDiv');
		$(obj).addClass('offProjectDiv');
		$('#pChild_'+ projectIdx).empty();
		projectMarkerData(projectIdx);
	}else{
		//$(obj).removeClass('offProjectDiv');
		//$(obj).addClass('onProjectDiv');
		//$('#pChild_'+ projectIdx).empty();
		proIdx = projectIdx;
		clickProjectPage(1,proIdx,null);
		projectMarkerData(projectIdx);
	}
}

//페이지 선택
function clickProjectPage(pageNum, tmpProIdx, dataType){
	var Url			= baseRoot() + "cms/getProjectContent/";
// 	var param		= loginToken + "/" + loginId + "/list/" + tmpProIdx + "/" + pageNum + "/" + proContentNum;
	var param		= loginToken + "/" + loginId + "/list/" + tmpProIdx + "/&nbsp;/&nbsp;";
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			var response = data.Data;
			if(response != null && response != '' && data.Code == '100'){
				if(dataType != 'editView' && dataType != 'removeView'){
					proIdx = tmpProIdx;
					
					addProjectChildCell(response, pageNum);
					
					//페이지 설정
					var dataLen = 1;
					if(data.DataLen != null && data.DataLen != "" && data.DataLen != "null"){
						dataLen = data.DataLen;
						//총 페이지 계산
						var min = 1;
						var max = 12;
						var totalPage = 1;
						if(dataLen % max == 0){
							totalPage = parseInt(dataLen / max);
						}else{
							totalPage = parseInt(dataLen / max)+1;
						}
						//테이블에 페이지 추가
						addProjectPageCell(totalPage, pageNum);
					}
				}else if(dataType == 'editView'){
					editDiagOpen(data.DataLen);
				}else if(dataType == 'removeView'){
					removeProjectName1(data.DataLen);
				}
			}else{
				if(dataType != 'editView' && dataType != 'removeView'){
					jAlert(data.Message, 'Info');
				}else if(dataType == 'editView'){
					editDiagOpen(0);
				}else if(dataType == 'removeView'){
					removeProjectName1(0);
				}
			}
		}
	});
}

function addProjectChildCell(response, pageNum){
	var nowPChild = 'pChild_'+ proIdx;
	$('#subNode_'+proIdx).empty();
	var target = document.getElementById(nowPChild);
	
	var blankImg = '<c:url value="/images/geoImg/blank(100x70).PNG"/>';

	var imgWidth = 70;		//image width
	var imgHeight = 50;		//image height
	var max_cell = 4;
	
	var totalLan = response.length;
	var list = [];
	for(var i=0; i<totalLan; i++) {
			//image add
			var img_row;
			//if(i % max_cell == 0){
			//	img_row = target.insertRow(-1);
			//}
			
			//var img_cell = img_row.insertCell(-1);
			var innerHTMLStr = '';
			//img_cell.setAttribute('height', '74px');
			
			if(response[i] == null || response[i] == '' || response[i] == undefined ) {	//등록한 이미지가 없을때 나 
				//innerHTMLStr += "<img class='round' src='"+ blankImg + "' width='" + imgWidth + "' height='" + imgHeight + "'hspace='10' vspace='10' style='border:2px solid white;'/>";
				//img_cell.innerHTML = innerHTMLStr;
			}else{
				var gpsArrLat = new Array();
				var gpsArrLon = new Array();
				//타입 별 file 주소 설정
				var localAddress = ftpBaseUrl() + "/" + response[i].datakind;
				if(response[i].datakind == "GeoPhoto"){
					var tmpThumbFileName = response[i].filename.split('.');
					localAddress += "/"+tmpThumbFileName[0] +'_thumbnail.png';
					
					gpsArrLat.push(response[i].latitude);
					gpsArrLon.push(response[i].longitude);
				}else if(response[i].datakind == "GeoVideo"){
					localAddress += "/"+response[i].thumbnail;
					
					var lat = response[i].latitude + "";
					var lon = response[i].longitude + "";
					
					var latLen = lat.split(".")[1].length;
					var lonLen = lon.split(".")[1].length;
					
					var latPos = Math.pow(10, latLen);
					var lonPos = Math.pow(10, lonLen);
					
					$.each(response[i].gpsdata.gpsData, function(idx, val) {
						var latVal = Math.floor(val.lat * latPos) / latPos;
						var lonVal = Math.floor(val.lon * lonPos) / lonPos;
						
						gpsArrLat.push(latVal);
						gpsArrLon.push(lonVal);
					});
				}
				
// 				gpsArr.push(response[i].gpsdata.gpsData);
				
				var selectId = "Pro_"+response[i].datakind+"_"+response[i].idx;
				innerHTMLStr += "<img style='width:20px; height:20px; background:white; display:none;' src='<c:url value="/images/geoImg/main_images/tree-node.png"/>'/>";
				innerHTMLStr += "<li id='subDetailNode_"+i+"' style='font-weight: 600; margin: 0px 0px 0px 36px;'>";
				innerHTMLStr += "<div class='imageTag' style='padding: 5px; font-size: 15px;' id='Pro_"+ response[i].datakind +"_"+response[i].idx +"' href='javascript:;'";
				var tempArr = new Array;  //mapCenterChange에 넘길 객체 생성
				var tempXml = new Array;  //mapCenterChange에 넘길 객체 생성
				tempArr.push(response[i].latitude);
				tempArr.push(response[i].longitude);
				tempArr.push(response[i].filename);
				tempArr.push(response[i].idx);
				tempArr.push(response[i].datakind);
				tempArr.push(response[i].originname);
				tempArr.push(response[i].thumbnail);
				tempArr.push(response[i].id);
				tempArr.push(response[i].projectUserId);
// 				tempArr.push("");
// 				tempArr.push("");
// 				tempArr.push(response[i].u_date);
				tempArr.push(response[i].seqnum);
				tempArr.push(response[i].dronetype);
				tempArr.push(response[i].projectidx);
				
				var xml = response[i].xmldata;
				var newName = "";
				var a = $.parseXML(xml);
				
				$xml = $(a);
				for(var k=0; k < $xml.find("obj").length; k++)
				{
					var obj = $xml.find("obj")[k];
					var children = obj.children;
					
					for (var l = 0; l < children.length; l++) 
					{
						var name = children[l].tagName;
						var value = children[l].textContent;
						
						if(children.length == l+1)
						{
							newName += ""+name+":"+value;
						}
						else if(l == 0)
						{
							if(value == "b")
							{
								newName += "Speech Bubble : ";
							}
							else if(value == "g")
							{
								newName += "Geometry : ";
							}
							else
							{
								newName += "Image : ";
							}
						}
						else
						{
							newName += ""+name+":"+value+",";
						}
					}
					if($xml.find("obj").length != k+1)
					{
						newName += "^";
					}
				}
				
				//innerHTMLStr += "mapCenterChange(\""+tempArr+"\", \""+selectId+"\", \""+i+"\" );";
// 				innerHTMLStr += '"'+" title='제목 : "+ response[i].title +"\n내용 : "+ response[i].content +"\n작성자 : "+ response[i].id +"\n작성일 : "+ response[i].u_date +"' border='0'>";
				innerHTMLStr += "title='TITLE : "+ response[i].title +"\nCONTENT : "+ response[i].content +"\nWRITER : "+ response[i].id +"\nDATE : "+ response[i].u_date +"' border='0'>";
				
				var tmpMarginTop = '0';
				if(totalLan/4 > 1){
					tmpMarginTop = '15px';
				}
				//image or video icon add
				//innerHTMLStr += "<div style='position:relative;width:30px; height:30px; margin:"+tmpMarginTop+" 0 0 20px;  background-image:url(<c:url value='images/geoImg/"+ response[i].datakind +"_marker.png'/>); zoom:0.7;'></div>";
				
				//xml file check icon add
				if(loadXML(response[i].filename, response[i].datakind) == 1){
					var tempTop = 8;
					var tempLeft = 66;
					//innerHTMLStr += "<div style='position:relative; margin:"+ tempTop +"px 0 0 "+ tempLeft +"px; width:15px; height:20px; background-image:url(<c:url value='images/geoImg/btn_image/xmlFile_w.png'/>);'></div>";
				}else{
					var tempTop = 8;
					var tempLeft = 66;
					//innerHTMLStr += "<div style='position:relative; margin:"+ tempTop +"px 0 0 "+ tempLeft +"px; width:15px; height:20px;'></div>";
				}
				mapCenterChange(tempArr, selectId, i, gpsArrLat, gpsArrLon, newName);
// 				innerHTMLStr += '<input type="checkbox" id="checkSub_'+i+'" style="float:left;" class="cb1" onclick="mapCenterChange(\''+tempArr+'\', \''+selectId+'\', \''+i+'\', '+gpsArr+');"/>';
				innerHTMLStr += '<input type="checkbox" id="checkSub_'+i+'" style="float:left;" class="cb1" onclick="mapCenterChange(\''+tempArr+'\', \''+selectId+'\', \''+i+'\', \''+gpsArrLat+'\', \''+gpsArrLon+'\', \''+newName+'\');"/>';
				//innerHTMLStr += '<input type="checkbox" id="checkSub_'+i+'" style="float:left;" class="cb1"/>';
				innerHTMLStr += '<label for="checkSub_'+i+'"></label>';
				if (response[i].datakind == "GeoVideo") {
					innerHTMLStr += "<label class='titleLabel' title='Video"+i+"' style='width:130px !important;font-size: 15px;margin-top:3px;'>Video"+i+"</label>";
				} else if (response[i].datakind == "GeoPhoto") {
					innerHTMLStr += "<label class='titleLabel' title='Video"+i+"' style='width:130px !important;font-size: 15px;margin-top:3px;'>Photo"+i+"</label>";
				} else {
					innerHTMLStr += "<label class='titleLabel' title='Video"+i+"' style='width:130px !important;font-size: 15px;margin-top:3px;'>Content"+i+"</label>";
				}
				//innerHTMLStr += "<img class='round' width='20px' height='20px'/>";
				//innerHTMLStr += "<span class='round' style='font-size: 15px;'>Video"+i+"</span>"
				//innerHTMLStr += "<img class='round' src='<c:url value='"+ localAddress +"'/>' width='" + imgWidth + "' height='" + imgHeight + "' hspace='10' vspace='10' ";
				var tmpViewId = "MOVE_"+ response[i].datakind + "_" + response[i].idx;
				if($.inArray(tmpViewId, moveContentArr) > -1){
					//innerHTMLStr += " style='border:3px solid red; margin: -51px 0 0 15px;/>";
				}else{
					//innerHTMLStr += " style='border:2px solid #888888; margin: -51px 0 0 15px;'/>";
				}
				
				//list.push({"tempArr" : tempArr},{"selectId" : selectId}, {"gpsArr" : gpsArr});
				
				innerHTMLStr += "</div>";
				innerHTMLStr += "</li>";
				innerHTMLStr += "<div id='subDetailView_"+i+"' style='font-size: 15px;' oncontextmenu='return false;'></div>"
				//$('#subTimeNode_'+proIdx).append(innerHTMLStr);
				
				$("[id^=subDetailNode_]").contextMenu('context2', {
					bindings: {
						'context_edit': function(t){
							openProjectWriter($(t).children().closest('div')[0].id);
						},
// 						'context_edit_google': function(t){
// 							openProjectWriterGoogle($(t).children().closest('div')[0].id);
// 						},
						'context_delete': function(t) {
							jConfirm('Are you sure you want to delete this content?', 'Info', function(type){ 
								if(type){
									var children = $(t).children()[0];
									var tbId = $(t).parent()[0].id;
									removeContents(children.id.split("_")[1], children.id.split("_")[2], tbId);
								}
							});
						}
					}
				});
				
				/* $("#checkSub_"+i).click(function() {
					alert(i);
// 					mapCenterChange(list[i].tempArr, selectId, i, gpsArr);
				}); */
				
				/* if(response[i].id == loginId || response[i].projectUserId == loginId){
					$('#Pro_'+response[i].datakind +"_"+response[i].idx).contextMenu('context2', {
						bindings: {
							'context_delete': function(t) {
// 								jConfirm('해당 컨텐츠를 삭제 하시겠습니까?', '정보', function(type){ 
								jConfirm('Are you sure you want to delete this content?', 'Info', function(type){ 
									if(type){
										var tbId = $(t).closest( 'table').attr( 'id' );
										removeContents(t.id.split("_")[1], t.id.split("_")[2], tbId.split('_')[1]);
									}
								});
							}
						}
					});
				} */
			}
	}//for end
}

//XML 유무에 따라 썸네일 아이콘 추가
function loadXML(file_url, data_kind){
	return 1;
	// 컨트롤러 없음
	/* var url_buf = file_url.split(".");
	var xml_file_name = url_buf[0] + '.xml';
	var file_check =0;
	
	$.ajax({
		type: "GET",
		url: 'Http://'+ location.host +'/'+ data_kind +'/upload/'+xml_file_name,
		dataType: "xml",
		cache: false,
		async: false,
		success: function(xml) {
			file_check = 1; //저작 됨
		},
		error: function(xhr, status, error) {
			file_check = 0; //저작 안됨
		}
	});
	
	return file_check; */
}

//테이블에 페이지 추가
function addProjectPageCell(totalPage, pageNum) {
	var target = document.getElementById('pChild_'+ proIdx);
	
	var row = target.insertRow(-1);
	var cell = row.insertCell(-1);
	cell.colSpan = '4';
	var leftMargin = 5;
	
	var innerHTMLStr = "<div id='pagingDiv_" + proIdx + "' style='margin-top:-8px;'>";
	var pageGroup = 0;
	if(pageNum%10 == 0){
		pageGroup = (pageNum/10-1)*10+1;
	}else{
		pageGroup = Math.floor(pageNum/10)*10+1;
	}
	
	if(pageGroup > 1){
		innerHTMLStr += "<div style='float:left; margin-top:4px; background-image: url(<c:url value='/images/geoImg/btn_image/paging_DL.png'/>); width: 18px;height: 14px; background-repeat:no-repeat;cursor:pointer;' onclick='clickProjectPage("+(pageGroup-10)+ ","+proIdx+",null);'></div>";
	}else{
		leftMargin += 18;
	}
	
	if(totalPage > 1){ 
		innerHTMLStr += "<div style='float:left; margin:4px 0 0 "+ leftMargin + "px; background-image: url(<c:url value='/images/geoImg/btn_image/paging_L.png'/>); width: 18px;height: 14px; background-repeat:no-repeat; cursor:pointer;' onclick='clickMovePageMP(\"prev\","+ totalPage +","+pageNum+","+proIdx+");'></div>";
	}
	
	innerHTMLStr += "<div style='float:left; text-align:center;width:320px;'>";
	for(var i=pageGroup; i<(pageGroup+10); i++) {
		if(i>totalPage){
			continue;
		}
		innerHTMLStr += "<font color='#000'><a href="+'"'+"javascript:clickProjectPage('"+(i).toString()+"',"+proIdx+",null);"+'"';
		innerHTMLStr += " style='padding:2px 0 0 2px; text-decoration:none;'> ";
		if(pageNum == i){
			innerHTMLStr += " <font color='#066ab0' style='font-weight:900; font-size:12px;'>";
		}else{
			innerHTMLStr += " <font color='#6d808f' style='font-size:12px;'> ";
		}
		innerHTMLStr += (i).toString()+"</font></a></font>";
	}
	innerHTMLStr += "</div>";

	if(totalPage > 1){
		innerHTMLStr += "<div style='float:left; margin-top:4px; background-image: url(<c:url value='/images/geoImg/btn_image/paging_R.png'/>); width: 18px;height: 14px; background-repeat:no-repeat; cursor:pointer;' onclick='clickMovePageMP(\"next\","+ totalPage +","+pageNum+","+proIdx+");'></div>";
	}
	
	if(totalPage >= (pageGroup+10)){
		innerHTMLStr += "<div style='float:left; margin-top:4px; background-image: url(<c:url value='/images/geoImg/btn_image/paging_DR.png'/>);width: 18px;height: 14px; background-repeat:no-repeat; cursor:pointer;' onclick='clickProjectPage("+(pageGroup+10)+","+proIdx+", null);'></div>";
	}
	
	innerHTMLStr += "</div>";
	cell.innerHTML = innerHTMLStr;
}

//move pageGroup : prev, next
function clickMovePageMP(cType, totalPage, pageNum, projectIdx){
	var movePage = 0;
	proIdx = projectIdx;
	$('#pChild_'+ proIdx).empty();
	if(cType == 'next'){
		if(pageNum+1 <= totalPage){
			movePage = pageNum+1;
		}
	}else{
		if(pageNum > 1){
			movePage = pageNum-1;
		}
	}
	if(movePage > 0){
		addProjectPageCell(totalPage, movePage);
		clickProjectPage(movePage, projectIdx ,null);
	}
}

//프로젝트 명 추가 dialog Open
function openAddProjectName(){
	proIdx = 0;
	$('#projectNameAddDig #saveBtn').css('display','inline-block');
	$('#projectNameAddDig #modifyBtn').css('display','none');
	$('#projectNameAddDig #removeBtn').css('display','none');
	$('#projectNameAddDig').dialog('option', 'title', 'Add Layer');
	$('#projectNameTxt').val('');
	$('input[name=shareRadio]:radio[value=0]').attr('checked',true);
	$('#projectNameAddDig').dialog('open');
}

//프로젝트 명 추가 dialog close
function closeAddProjectName(){
	shareInit();
	$('#projectNameAddDig').dialog('close');
} 
function analysisProject(projectIdx)
{
	var tmpProName = $('#hiddenProName_'+ projectIdx).val();
	var tmpProShare = $('#hiddenShareType_'+projectIdx).val();
	var tmpImgIcon = $('#markerIcon_'+projectIdx).attr('src');
	$('#projectNameTxt').val(tmpProName);
	oldShareUser = tmpProShare;
	proIdx = projectIdx;
	$('input[name=shareRadio]:radio[value='+ tmpProShare +']').attr('checked',true);
	//window.open('/GeoCMS/sub/contents/analysisView.jsp', 'analysisView', 'width=1150, height=830');
	
	var base_url = 'http://'+location.host;
	window.open('', 'analysisView', 'width=850, height=500, top=200, left=440');
	var form = document.createElement('form');
	form.setAttribute('method','post');
	form.setAttribute('action',base_url + "/GeoCMS/sub/contents/analysisView.do?loginToken="+loginToken+"&loginId="+loginId+'&projectBoard=1&tmpProName='+tmpProName+'&projectIdx='+projectIdx);
	form.setAttribute('target','analysisView');
	document.body.appendChild(form);
	
	/* var insert = document.createElement('input');
	insert.setAttribute('type','hidden');
	insert.setAttribute('name','file_url');
	insert.setAttribute('value',response.filename);
	form.appendChild(insert);
	
	var insertIdx = document.createElement('input');
	insertIdx.setAttribute('type','hidden');
	insertIdx.setAttribute('name','idx');
	insertIdx.setAttribute('value',tmpTIdx);
	form.appendChild(insertIdx); */
	
	form.submit();
	//clickProjectPage(1, projectIdx, 'analysisView');
}

function queryExecute()
{
	var base_url = 'http://'+location.host;
	window.open('', 'queryExecuteView', 'width=800, height=400, top=100, left=500');
	var form = document.createElement('form');
	form.setAttribute('method','post');
	form.setAttribute('action',base_url + "/GeoCMS/sub/contents/queryExecuteView.do?queryNum=1");
	form.setAttribute('target','queryExecuteView');
	document.body.appendChild(form);
	
	/* var insert = document.createElement('input');
	insert.setAttribute('type','hidden');
	insert.setAttribute('name','file_url');
	insert.setAttribute('value',response.filename);
	form.appendChild(insert);
	
	var insertIdx = document.createElement('input');
	insertIdx.setAttribute('type','hidden');
	insertIdx.setAttribute('name','idx');
	insertIdx.setAttribute('value',tmpTIdx);
	form.appendChild(insertIdx); */
	
	form.submit();
}
//project modify
function editProject(projectIdx){
	editBtnClk = 1;
	var tmpProName = $('#hiddenProName_'+ projectIdx).val();
	var tmpProShare = $('#hiddenShareType_'+projectIdx).val();
	var tmpImgIcon = $('#markerIcon_'+projectIdx).attr('src');
	
	$('#projectNameTxt').val(tmpProName);
	oldShareUser = tmpProShare;
	proIdx = projectIdx;
	$('input[name=shareRadio]:radio[value='+ tmpProShare +']').attr('checked',true);
	
	clickProjectPage(1, projectIdx, 'editView');
}

function editDiagOpen(totalLen){
	if(totalLen == 0){
		$('#projectNameAddDig #removeBtn').css('display','inline-block');
	}else{
		$('#projectNameAddDig #removeBtn').css('display','none');
	}
	$('#projectNameAddDig #saveBtn').css('display','none');
	$('#projectNameAddDig #modifyBtn').css('display','inline-block');
	$('#projectNameAddDig').dialog('option', 'title', 'Manage Layer');
	$('#projectNameAddDig').dialog('open');
}

//open shareUser list
function getShareUser(){
	contentViewDialog = jQuery.FrameDialog.create({
		url:'<c:url value="/geoCMS/share.do" />?shareIdx='+ proIdx +'&shareKind=GeoProject',
		width: 370,
		height: 535,
		buttons: {},
		autoOpen:false
	});
	contentViewDialog.dialog('widget').find('.ui-dialog-titlebar').remove();
	contentViewDialog.dialog('open');
}

//add project name
function addProjectName(){
	var projectNameTxt = $('#projectNameTxt').val();
	var projectShareUser = $('#shareAdd').val();
	var projectEditYes = $('#editYes').val();
	var projectShareType = $('input[name=shareRadio]:checked').val();
	
	if(projectNameTxt == null || projectNameTxt == ''){
// 		jAlert('프로젝트 명을 입력해 주세요.', '정보');
		jAlert('Please enter project name.', 'Info');
		return;
	}
	
	if(projectShareType != null && projectShareType == 2 && (projectShareUser == null || projectShareUser == '')){
// 	 	jAlert('공유 유저가 지정되지 않았습니다.', '정보');
	 	jAlert('No sharing user specified.', 'Info');
	 	return;
	}
	
	if(projectNameTxt != null && projectNameTxt.indexOf('\'') > -1){
// 		jAlert('프로젝트 명에 특수문자 \' 는 사용할 수 없습니다.', '정보');
		jAlert('You can not use the special character \' in the project name.', 'Info');
		return;
	}
	
	projectNameTxt = dataReplaceFun(projectNameTxt);

	if(projectShareUser == null || projectShareUser == ''){
		projectShareUser = '&nbsp;';
	}
	
	if(projectEditYes == null || projectEditYes == ''){
		projectEditYes = '&nbsp;';
	}
	
	var Url			= baseRoot() + "cms/saveProject/";
	var param		= loginToken + "/"+ loginId + "/" + projectNameTxt + "/" + projectShareType + "/" + projectShareUser + "/"+ projectEditYes;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "POST"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			closeAddProjectName();
			jAlert(data.Message, 'Info');
			viewMyProjects(null);
		}
	});
}

//modify project name
function modifyProjectName(){
	var projectNameTxt = $('#projectNameTxt').val();
	var projectShareType = $('input[name=shareRadio]:checked').val();
	
	var projectAddShareUser = $('#shareAdd').val();
	var projectRemoveShareUser = $('#shareRemove').val();
	var projectEditYes = $('#editYes').val();
	var projectEditNo = $('#editNo').val();
	
	if(projectNameTxt == null || projectNameTxt == ''){
// 		jAlert('프로젝트 명을 입력해 주세요.', '정보');
		jAlert('Please enter project name.', 'Info');
		return;
	}
	
	if(projectShareType != null && projectShareType == 2 && (projectAddShareUser == null || projectAddShareUser == '') && oldShareUser != 2){
// 	 	jAlert('공유 유저가 지정되지 않았습니다.', '정보');
	 	jAlert('No sharing user specified.', 'Info');
	 	return;
	}
	
	if(projectNameTxt != null && projectNameTxt.indexOf('\'') > -1){
// 		jAlert('프로젝트 명에 특수문자 \' 는 사용할 수 없습니다.', '정보');
		jAlert('You can not use the special character \' in the project name.', 'Info');
		return;
	}

	projectNameTxt = dataReplaceFun(projectNameTxt);
	
	if(projectAddShareUser == null || projectAddShareUser == ''){ projectAddShareUser = '&nbsp;'; }
	if(projectRemoveShareUser == null || projectRemoveShareUser == ''){ projectRemoveShareUser = '&nbsp;'; }
	if(projectEditYes == null || projectEditYes == ''){ projectEditYes = '&nbsp;'; }
	if(projectEditNo == null || projectEditNo == ''){ projectEditNo = '&nbsp;'; }
	
	var Url			= baseRoot() + "cms/updateProject/";
	var param		= loginToken + "/"+ loginId + "/" + proIdx + "/" + projectNameTxt + "/" + projectShareType + "/" + projectAddShareUser + "/"+ projectRemoveShareUser + "/" + projectEditYes+ "/" + projectEditNo;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "POST"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			viewMyProjects(proIdx);
			closeAddProjectName();
			jAlert(data.Message, 'Info');
		}
	});
}

//make content
function myContentsMake(makeContentIdx){
	editBtnClk = 1;
	ContentsMakes('Image', '','', makeContentIdx);
}

function removeContents(type, tmpIdArr, parentId){
	var Url			= baseRoot() + "cms/deleteContent/";
	var param		= loginToken + "/"+ loginId + "/" + type + "/" + tmpIdArr;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "POST"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			viewMyProjects(parentId);
			jAlert(data.Message, 'Info');
		}
	});
}

function shareInit(){
	$('#shareAdd').val('');
	$('#shareRemove').val('');
	$('#editYes').val('');
	$('#editNo').val('');
	$('#clonSharUser').empty();
	oldShareUser = 0;
}

//move btn click
function moveProContent(){
	if(proEdit == 0){
		proEdit = 1;
		//project name setting
		var innerHTML = '';
		$.each($('.titleLabel'), function(idx, val){
			var tmpIdx = $(this).parent().attr('id').split('_');
			var tmpProUserIn = $('#hiddenProUserIn_'+tmpIdx[1]).val();
			if(tmpProUserIn == 'Y' || $(this).parent().children().hasClass('editProBtn')){
				var tmpShare = $('#hiddenShareType_'+tmpIdx[1]).val();
				var tmpText = $('#hiddenProName_'+tmpIdx[1]).val();
				innerHTML += '<option value="'+ tmpIdx[1] +'_'+ tmpShare+'">'+ tmpText +'</option>';
			}
		});
		$('#moveContentSel').append(innerHTML);
		$('#moveContentBtn').removeClass('offMoveCon');
		$('#moveContentBtn').addClass('onMoveCon');
		$('#moveContentView').css('display','block');
		$('.editProBtn').css('display','none');
		$('.editFileBtn').css('display','none');
		$('#myProject_list #makeContents').css('display','none');
		$('#proAddBtn').css('visibility','hidden');
		$('#image_map').append('<div id="mapNo" style="width:'+ $('#image_map').width() +'px; height:'+ $('#image_map').height() +'px;top: 0;background-color: gray;position: absolute;z-index: 100;opacity: 0.2;"></div>');
	}else{
		proEdit = 0;
		moveContentArr = new Array();
		$('#moveContentBtn').addClass('offMoveCon');
		$('#moveContentBtn').removeClass('onMoveCon');
		$('.imageTag').find('img').css('border', '2px solid #888888');
		$('#moveContentSel').empty();
		$('#moveContentViewSub').empty();
		$('#moveContentView').css('display','none');
		$('.editProBtn').css('display','block');
		$('.editFileBtn').css('display','block');
		$('#myProject_list #makeContents').css('display','block');
		$('#proAddBtn').css('visibility','visible');
		$('#mapNo').remove();
	}
	
}

var moveContentArr = new Array();
//move content add
function moveContentAdd(objArr){
	objArr = objArr.split(",");
	
	if(objArr[7] != loginId){
// 		jAlert('다른 사용자의 컨텐츠는 이동 할 수 없습니다.', '정보');
		jAlert('Other users content can not be moved.', 'Info');
		return;
	}
	
	var tbId = $('#Pro_'+ objArr[4] + '_'+ objArr[3]).closest('table').attr('id');
	if(tbId != null && tbId != '' && tbId != undefined){
		var tmpProIdx = tbId.split('_')[1];
		var isEditCru = $('#pName_'+tmpProIdx).children().hasClass('editProBtn');
		if(isEditCru){
			var tmpDivID = 'MOVE_'+ objArr[4] + '_'+ objArr[3];
			if($.inArray(tmpDivID, moveContentArr) > -1){
				moveContentRemove(tmpDivID);
				return;
			}
			
			moveContentArr.push(tmpDivID);

			$('#Pro_'+ objArr[4] + '_'+ objArr[3]).find('img').css('border', '3px solid red');
			
			var localAddress = ftpBaseUrl() + "/" + objArr[4];
			
			if(objArr[4] == "GeoPhoto"){
				var tmpThumbFileName = objArr[2].split('.');
				localAddress += "/"+tmpThumbFileName[0] +'_thumbnail.png';
			}else if(objArr[4] == "GeoVideo"){
				localAddress += "/"+objArr[6];
			}
			
			var innerHTMLStr = '';
			innerHTMLStr += "<a class='imageTag' id='MOVE_"+ objArr[4] + "_"+ objArr[3] +"' href='javascript:;' ";
			var tempArr = new Array; //mapCenterChange에 넘길 객체 생성
			innerHTMLStr += '"'+" border='0'>";

			innerHTMLStr += "<img class='round' src='<c:url value='"+ localAddress +"'/>' width='90' height='70' hspace='10' vspace='10' style='border:2px solid #888888'/>";
			innerHTMLStr += "</a>";
			$('#moveContentViewSub').append(innerHTMLStr);
			
			/* $('#'+tmpDivID).contextMenu('context2', {
				bindings: {
					'context_delete': function(t) {
// 						jConfirm('현재 목록에서 제거 하시겠습니까?', '정보', function(type){
						jConfirm('Remove from current list?', 'Info', function(type){ 
							if(type){
								moveContentRemove(t.id);
							}
						});
					}
				}
			}); */
		}else{
// 			jAlert('공유받은 컨텐츠는 이동 할 수 없습니다.', '정보');
			jAlert('Shared content can not be moved.', 'Info');
		}
	}
}

function moveContentRemove(pId){
	var tmpArr = pId.split("_");
	if($.inArray(pId, moveContentArr) > -1){
		moveContentArr.splice($.inArray(pId, moveContentArr),1);
	}
	
	$('#'+pId).remove();
	$('#Pro_'+ tmpArr[1] + '_'+ tmpArr[2]).find('img').css('border', '2px solid #888888');
}

function moveProjectSave(){
	var moveProIS = $('#moveContentSel').val();
	if(moveContentArr == null || moveContentArr.length < 1){
// 		jAlert('컨텐츠를 선택해 주세요.', '정보');
		jAlert('Please select content.', 'Info');
		return;
	}
	
	var moveContentArrTmp = new Array();
	$.each(moveContentArr,function(idx,val){
		val = val.replace('MOVE_','');
		moveContentArrTmp.push(val);
	});
	
	var moveProISIdx = "";
	var moveProISShare = "";
	if(moveProIS != null && moveProIS != ""){
		moveProISIdx = moveProIS.split("_")[0];
		moveProISShare = moveProIS.split("_")[1];
	}
	
	if(moveProISIdx == null || moveProISIdx == "" || moveProISShare == null || moveProISShare == ""){
// 		jAlert('이동할 프로젝트를 선택해 주세요.', '정보');
		jAlert('Please select a project to move.', 'Info');
		return;
	}
	
	var Url			= baseRoot() + "cms/moveProject/";
	var param		= loginToken + "/" + loginId + "/"+ moveProISIdx + "/" + moveContentArrTmp;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "POST"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			if(data.Code == '100'){
				viewMyProjects(null);
			}
			jAlert(data.Message, 'Info');
		}
	});
}

function removeProjectName(){
	clickProjectPage(1, proIdx, 'removeView');
}

function removeProjectName1(dataTLen){
	
	if(dataTLen > 0){
		jAlert('It can be deleted only if there is no content in the layer.','info');
	}else{
//	 	jConfirm('정말 삭제하시겠습니까?', '정보', function(type){
		jConfirm('Are you sure you want to delete?', 'Info', function(type){
			if(type){ 
				var Url			= baseRoot() + "cms/removeProject/";
				var param		= loginToken + "/" + loginId + "/"+ proIdx;
				var callBack	= "?callback=?";
				
				$.ajax({
					type	: "POST"
					, url	: Url + param + callBack
					, dataType	: "jsonp"
					, async	: false
					, cache	: false
					, success: function(data) {
						viewMyProjects(null);
						closeAddProjectName();
						jAlert(data.Message, 'Info');
					}
				});
			} 
		});
	}
}

//project marker 
var markerProArr = new Array();
function projectMarkerData(tmpProIdx){
	$('#polygonView').attr('checked',false);
	//지도 데이터 초기화
	
	var layers = map.layers;
	var selectMap = $("#mapSelect option:selected").val();
	if (selectMap == "OSM") {
		var delLayers = new Array();
		if (layers.length > 1) {
			for (var i = 0; i < layers.length; i++) {
				var name = layers[i].name;
				if (name != "mainLayer") {
					delLayers.push(layers[i]);
				}
			}
		}
		
		$.each(delLayers, function(idx, val) {
			map.removeLayer(val);
		});
	} else if (selectMap == "VW") {
		var delLayers = new Array();
		if (layers.length > 9) {
			for (var i = 9; i < layers.length; i++) {
				var name = layers[i].name;
				delLayers.push(layers[i]);
			}
		}
		
		$.each(delLayers, function(idx, val) {
			map.removeLayer(val);
		});
	}
	
	var tmpIdx = $.inArray(tmpProIdx, markerProArr);
	if(tmpIdx < 0){
		markerProArr.push(tmpProIdx);
	}else{
		markerProArr.splice(tmpIdx,1);
	}

	if (markerProArr.length > 0) {
		var Url			= baseRoot() + "cms/getProjectContent/";
		var param		= loginToken + "/" + loginId + "/marker/" + markerProArr + "/&nbsp;/&nbsp;";
		var callBack	= "?callback=?";
		
		$.ajax({
			type	: "get"
			, url	: Url + param + callBack
			, dataType	: "jsonp"
			, async	: false
			, cache	: false
			, success: function(data) {
				var response = data.Data;
				if(response != null && response != '' && data.Code == '100'){
					markDataMake(response);
				}else{
					jAlert("Location information does not exist.", 'Info');
				}
			}
		});
	}
}

//file upload dialog open
function openProjectViewer(projectIdx){
	editBtnClk = 1;
	
	var Url			= baseRoot() + "cms/getProjectContent/";
	var param		= loginToken + "/" + loginId + "/list/" + projectIdx + "/1/1";
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			var response = data.Data;
			if(response != null && response != '' && data.Code == '100' && response.length > 0){
				if(response[0].datakind == 'GeoPhoto'){
					imageViewer(response[0].filename, response[0].id, response[0].idx, response[0].projectuserid);
				}else if(response[0].datakind == 'GeoVideo'){
					videoViewer(response[0].filename, response[0].orignname, response[0].id, response[0].idx, response[0].projectuserid);
				}
			}else{
				jAlert("There is no content.","Info");
			}
		}
	});
}

//file upload dialog open
function openProjectViewerGoogle(projectIdx){
	editBtnClk = 1;
	
	var Url			= baseRoot() + "cms/getProjectContent/";
	var param		= loginToken + "/" + loginId + "/list/" + projectIdx + "/1/1";
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			var response = data.Data;
			if(response != null && response != '' && data.Code == '100' && response.length > 0){
				if(response[0].datakind == 'GeoPhoto'){
					imageViewerGoogle(response[0].filename, response[0].id, response[0].idx, response[0].projectuserid);
				}else if(response[0].datakind == 'GeoVideo'){
					videoViewerGoogle(response[0].filename, response[0].orignname, response[0].id, response[0].idx, response[0].projectuserid);
				}
			}else{
				jAlert("There is no content.","Info");
			}
		}
	});
}

//새창 띄우기 (저작)
function openProjectWriter(objTIdx) {
	editBtnClk = 1;
	
// 	var objTIdx = 0; 
	
	var objTDataKind = "";
	var objTArr = [];
	$('.editAnno').each(function(idx,val){
		objTIdx =$(val).attr('id');
	});
	
	//objTIdx = k;
	
	if(objTIdx != null && objTIdx != '' ){
		objTArr = objTIdx.split('_');
		objTIdx = objTArr[2];
		objTDataKind = objTArr[1];
		
		if(objTIdx != null && objTIdx != '' && objTDataKind != null && objTDataKind != ''){
			var Url			= baseRoot() + "cms/getShareUser/";
			var param		= loginToken + "/" + loginId + "/" + objTIdx + "/"+objTDataKind+"/1";
			var callBack	= "?callback=?";
			var tmpEditUserYN  = 0;
			
			$.ajax({
				  type	: "get"
				, url	: Url + param + callBack
				, dataType	: "jsonp"
				, async	: false
				, cache	: false
				, success: function(response) {
					if(response.Code == 100 && response.Data[0].shareedit == 'Y'){
						tmpEditUserYN = 1;
					}
					if(objTDataKind == 'GeoPhoto'){
						getOneImageData(objTIdx, tmpEditUserYN);
					}else if(objTDataKind = 'GeoVideo'){
						getOneVideoData(objTIdx, tmpEditUserYN, '1');
					}
				}
			});
			
		}else{
			jAlert("Please select content.","Info");
		}
	}else{
		jAlert("Please select content.","Info");
	}
}

//새창 띄우기 (저작)
function openProjectWriterGoogle(objTIdx) {
	editBtnClk = 1;
	
// 	var objTIdx = 0; 
	
	var objTDataKind = "";
	var objTArr = [];
	$('.editAnno').each(function(idx,val){
		objTIdx =$(val).attr('id');
	});
	
	//objTIdx = k;
	
	if(objTIdx != null && objTIdx != '' ){
		objTArr = objTIdx.split('_');
		objTIdx = objTArr[2];
		objTDataKind = objTArr[1];
		
		if(objTIdx != null && objTIdx != '' && objTDataKind != null && objTDataKind != ''){
			var Url			= baseRoot() + "cms/getShareUser/";
			var param		= loginToken + "/" + loginId + "/" + objTIdx + "/"+objTDataKind+"/1";
			var callBack	= "?callback=?";
			var tmpEditUserYN  = 0;
			
			$.ajax({
				  type	: "get"
				, url	: Url + param + callBack
				, dataType	: "jsonp"
				, async	: false
				, cache	: false
				, success: function(response) {
					if(response.Code == 100 && response.Data[0].shareedit == 'Y'){
						tmpEditUserYN = 1;
					}
					if(objTDataKind == 'GeoPhoto'){
						getOneImageDataGoogle(objTIdx, tmpEditUserYN);
					}else if(objTDataKind = 'GeoVideo'){
						getOneVideoDataGoogle(objTIdx, tmpEditUserYN, '1');
					}
				}
			});
			
		}else{
			jAlert("Please select content.","Info");
		}
	}else{
		jAlert("Please select content.","Info");
	}
	
}

function openNumRight(k) {
	editBtnClk = 1;
	
	var objTIdx = 0; 
	
	var objTDataKind = "";
	var objTArr = [];
	$('.editAnno').each(function(idx,val){
		objTIdx =$(val).attr('id');
	});
	
	
	//objTIdx = k;
	
	if(objTIdx != null && objTIdx != '' ){
		objTArr = objTIdx.split('_');
		objTIdx = objTArr[2];
		objTDataKind = objTArr[1];
		
		if(objTIdx != null && objTIdx != '' && objTDataKind != null && objTDataKind != ''){
			var Url			= baseRoot() + "cms/getShareUser/";
			var param		= loginToken + "/" + loginId + "/" + objTIdx + "/"+objTDataKind + "/"+k;
			var callBack	= "?callback=?";
			var tmpEditUserYN  = 0;
			
			$.ajax({
				  type	: "get"
				, url	: Url + param + callBack
				, dataType	: "jsonp"
				, async	: false
				, cache	: false
				, success: function(response) {
					if(response.Code == 100 && response.Data[0].shareedit == 'Y'){
						tmpEditUserYN = 1;
					}
					if(objTDataKind == 'GeoPhoto'){
						getOneImageData(objTIdx, tmpEditUserYN);
					}else if(objTDataKind = 'GeoVideo'){
						getOneVideoData(objTIdx, tmpEditUserYN, k);
					}
				}
			});
			
		}else{
			jAlert("Please select content.","Info");
		}
	}else{
		jAlert("Please select content.","Info");
	}
	
}

//get on image
function getOneImageData(tmpTIdx, tmpEditUserYN){
	var Url			= baseRoot() + "cms/getImage/";
	var param		= "one/" + loginToken + "/" + loginId + "/&nbsp;/&nbsp;/&nbsp;/" +tmpTIdx;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			if(data.Code == 100){
				var response = data.Data;
				if(response != null && response != ''){
					var map = $("#mapSelect option:selected").val();
					var mapMode = "";
					if (map == "VW") {
						mapMode = $("#mapModeChange option:selected").val();
					}
					response = response[0];
					
					if(tmpEditUserYN == 0 && (response.projectuserid == loginId && response.projectuserid != response.id)){
						tmpEditUserYN = 1;
					}
					var base_url = 'http://'+location.host;
					window.open('', 'image_write_page', 'width=1150, height=610');
					var form = document.createElement('form');
					form.setAttribute('method','post');
					form.setAttribute('action',base_url + "/GeoPhoto/geoPhoto/image_write_page.do?loginToken="+loginToken+"&loginId="+loginId+'&projectBoard=1&editUserYN='+tmpEditUserYN+'&projectUserId='+response.projectuserid+'&map='+map+'&mapMode='+mapMode);
					form.setAttribute('target','image_write_page');
					document.body.appendChild(form);
					
					var insert = document.createElement('input');
					insert.setAttribute('type','hidden');
					insert.setAttribute('name','file_url');
					insert.setAttribute('value',response.filename);
					form.appendChild(insert);
					
					var insertIdx = document.createElement('input');
					insertIdx.setAttribute('type','hidden');
					insertIdx.setAttribute('name','idx');
					insertIdx.setAttribute('value',tmpTIdx);
					form.appendChild(insertIdx);
					
					form.submit();
				}
			}else{
				jAlert(data.Message, 'Info');
			}
		}
	});
}

//get on image
function getOneImageDataGoogle(tmpTIdx, tmpEditUserYN){
	var Url			= baseRoot() + "cms/getImage/";
	var param		= "one/" + loginToken + "/" + loginId + "/&nbsp;/&nbsp;/&nbsp;/" +tmpTIdx;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			if(data.Code == 100){
				var response = data.Data;
				if(response != null && response != ''){
					response = response[0];
					
					if(tmpEditUserYN == 0 && (response.projectuserid == loginId && response.projectuserid != response.id)){
						tmpEditUserYN = 1;
					}
					var base_url = 'http://'+location.host;
					window.open('', 'image_write_page', 'width=1150, height=830');
					var form = document.createElement('form');
					form.setAttribute('method','post');
					form.setAttribute('action',base_url + "/GeoPhoto/geoPhoto/image_write_page_google.do?loginToken="+loginToken+"&loginId="+loginId+'&projectBoard=1&editUserYN='+tmpEditUserYN+'&projectUserId='+response.projectuserid);
					form.setAttribute('target','image_write_page_google');
					document.body.appendChild(form);
					
					var insert = document.createElement('input');
					insert.setAttribute('type','hidden');
					insert.setAttribute('name','file_url');
					insert.setAttribute('value',response.filename);
					form.appendChild(insert);
					
					var insertIdx = document.createElement('input');
					insertIdx.setAttribute('type','hidden');
					insertIdx.setAttribute('name','idx');
					insertIdx.setAttribute('value',tmpTIdx);
					form.appendChild(insertIdx);
					
					form.submit();
				}
			}else{
				jAlert(data.Message, 'Info');
			}
		}
	});
}

//get one video
function getOneVideoData(tmpTIdx, tmpEditUserYN, k){
	var Url			= baseRoot() + "cms/getVideo/";
	var param		= "one/" + loginToken + "/" + loginId + "/&nbsp;/&nbsp;/&nbsp;/" +tmpTIdx;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			if(data.Code == 100){
				var response = data.Data;
				
				if(response != null && response != ''){
					var map = $("#mapSelect option:selected").val();
					var mapMode = "";
					if (map == "VW") {
						mapMode = $("#mapModeChange option:selected").val();
					}
					
					response = response[0];
					
					if(tmpEditUserYN == 0 && (response.projectuserid == loginId && response.projectuserid != response.id)){
						tmpEditUserYN = 1;
					}
					var base_url = 'http://'+location.host;
					window.open('', 'video_write_page', 'width=1138, height=720');
					var form = document.createElement('form');
					form.setAttribute('method','post');
					form.setAttribute('action',base_url + "/GeoVideo/geoVideo/video_write_page.do?loginToken="+loginToken+"&loginId="+loginId+'&projectBoard=1&editUserYN='+tmpEditUserYN+'&projectUserId='+response.projectuserid+'&flag='+k+'&map='+map+'&mapMode='+mapMode);
					form.setAttribute('target','video_write_page');
					document.body.appendChild(form);
					
					var insert = document.createElement('input');
					insert.setAttribute('type','hidden');
					insert.setAttribute('name','file_url');
					insert.setAttribute('value',response.filename);
					form.appendChild(insert);
					
					var insertIdx = document.createElement('input');
					insertIdx.setAttribute('type','hidden');
					insertIdx.setAttribute('name','idx');
					insertIdx.setAttribute('value',tmpTIdx);
					form.appendChild(insertIdx);
					
					form.submit();
				}
			}else{
				jAlert(data.Message, 'Info');
			}
		}
	});
}
//get one video
function getOneVideoDataGoogle(tmpTIdx, tmpEditUserYN, k){
	var Url			= baseRoot() + "cms/getVideo/";
	var param		= "one/" + loginToken + "/" + loginId + "/&nbsp;/&nbsp;/&nbsp;/" +tmpTIdx;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			if(data.Code == 100){
				var response = data.Data;
				
				if(response != null && response != ''){
					response = response[0];
					
					if(tmpEditUserYN == 0 && (response.projectuserid == loginId && response.projectuserid != response.id)){
						tmpEditUserYN = 1;
					}
					var base_url = 'http://'+location.host;
					window.open('', 'video_write_page', 'width=1145, height=926');
					var form = document.createElement('form');
					form.setAttribute('method','post');
					form.setAttribute('action',base_url + "/GeoVideo/geoVideo/video_write_page_google.do?loginToken="+loginToken+"&loginId="+loginId+'&projectBoard=1&editUserYN='+tmpEditUserYN+'&projectUserId='+response.projectuserid+'&flag='+k);
					form.setAttribute('target','video_write_page_google');
					document.body.appendChild(form);
					
					var insert = document.createElement('input');
					insert.setAttribute('type','hidden');
					insert.setAttribute('name','file_url');
					insert.setAttribute('value',response.filename);
					form.appendChild(insert);
					
					var insertIdx = document.createElement('input');
					insertIdx.setAttribute('type','hidden');
					insertIdx.setAttribute('name','idx');
					insertIdx.setAttribute('value',tmpTIdx);
					form.appendChild(insertIdx);
					
					form.submit();
				}
			}else{
				jAlert(data.Message, 'Info');
			}
		}
	});
}
function writerName(arr){
	alert(arr);
}
//file change
function fileChangeInfo(obj){
	$('#floorMap_pop_file_1').empty();
	
	var tmpHtml = '';
	for(var i=0; i<obj.files.length;i++){
		tmpHtml += "<div style='margin:5px 0 5px 10px; text-decoration:underline; color:gray;'>"+ obj.files[i].name +"</div>";
	}
	$('#floorMap_pop_file_1').append(tmpHtml);
}

//file upload save
function createUploadFile() {
	if(loginId != '' && loginId != null) {
		$('#fileinfo').append($('#file_1'));	//선택 파일 버튼 폼객체에 추가
		
		var uploadFileLen = $('#fileinfo').children().length;
		if(uploadFileLen <= 0){
// 			 jAlert('컨텐츠를 선택해 주세요.', '정보');
			 jAlert('Please select content.', 'Info');
			 return;
		}
		var uploadProIdx = $('#uploadFileProIdx').val();
		
		$('#uploadWorldFileDig').append('<div class="lodingOn"></div>');
		var iframe = $('<iframe name="postiframe" id="postiframe" style="display: none"></iframe>');
        $("body").append(iframe);

        var form = $('#fileinfo');
        var resAddress = baseRoot() + "cms/saveWorldFile/";
		resAddress += loginToken + "/" + loginId + "/" + uploadProIdx;
        resAddress += "?callback=?";
         
        form.attr("action", resAddress);
        form.attr("method", "POST");

        form.attr("encoding", "multipart/form-data");
        form.attr("enctype", "multipart/form-data");

        form.attr("target", "postiframe");
        form.attr("file", $('#file_1').val());
        form.submit();
         
        $("#postiframe").load(function (e) {
         	var doc = this.contentWindow ? this.contentWindow.document : (this.contentDocument ? this.contentDocument : this.document);
         	var root = doc.documentElement ? doc.documentElement : doc.body;
         	var data = root.textContent; ////////// ? root.textContent : root.innerText;
            data = data.replace("?","").replace("(","");
            data = data.substring(0, data.length -1);
         	var resData = JSON.parse(data);
            
         	if(resData != null && resData != ''){
         		if(resData.Code == 100){
         			viewMyProjects(uploadProIdx);
					jAlert(resData.Message, 'Info', function(res){
						$('.lodingOn').remove();
						cancelUploadFile();
					});
				}else{
					jAlert(resData.Message, 'Info');
					$('.lodingOn').remove();
				}
			}else{
				$('.lodingOn').remove();
			}
         });
	}
	else {
		window.parent.closeUpload();
// 		jAlert('로그인 정보를 잃었습니다.', 'Info');
		jAlert('I lost my login information.', 'Info');
	}
}

//file upload dialog close
function cancelUploadFile(){
	$('#uploadFileProIdx').val('');
	$('#uploadWorldFileDig').dialog('close');
}

</script>
	<div>
		<label style="margin-left: 15px; display:none;">Layer</label>
		<!-- <button id='proAddBtn' onclick='openAddProjectName();'>ADD</button> -->
<!-- 		<button onclick='moveProContent();' style="float:right; margin-right:10px; color:white; border-radius: 5px;" class='offMoveCon' id='moveContentBtn'>Move Content</button> -->
	</div>
	<div id="project_list_table" style="height: 100%; overflow-y:scroll;"></div>
<!--	<button id="makeContents" onclick="myContentsMake();">make Contents</button> -->
	
	<!-- projectName dialog -->
	<div id="projectNameAddDig">
		<table style="width: 100%;">
			<tr style="height:50px;">
				<td style="width:100px;">Layer Name</td>
				<td><input type="text" id="projectNameTxt" style="width:100%;" /></td>
			</tr>
			<tr class="showDivTR" style="height:50px;">
				<td colspan="2">
<!-- 					<div style="float:left;"><input type="radio" value="0" name="shareRadio" checked="checked" onclick="shareInit();">비공개</div> -->
<!-- 					<div style="float:left;"><input type="radio" value="1" name="shareRadio" onclick="shareInit();">전체공개</div> -->
<!-- 					<div style="float:left;"><input type="radio" value="2" name="shareRadio" onclick="getShareUser();">특정인 공개</div> -->
					<div style="float:left; margin-left: 80px;">
						<label class="container">private 
							<input type="radio" value="0" name="shareRadio" checked="checked" onclick="shareInit();">
							<span class="checkmark"></span>
						</label>
					</div>
					<div style="float:left; margin-left:10px;">
						<label class="container">public 
							<input type="radio" value="1" name="shareRadio" onclick="shareInit();">
							<span class="checkmark"></span>
						</label>
					</div>
<!-- 					<div style="float:left; margin-left:10px;"> -->
<!-- 						<label class="container">sharing with friends  -->
<!-- 							<input type="radio" value="2" name="shareRadio" onclick="getShareUser();"> -->
<!-- 							<span class="checkmark"></span> -->
<!-- 						</label> -->
<!-- 					</div> -->
				</td>
			</tr>
			<tr style="text-align: center; height:50px;">
				<td colspan="2">
					<input type="button" id="saveBtn" value="Save" onclick="addProjectName();"/>
					<input type="button" id="modifyBtn" value="Modify" style="display:none;" onclick="modifyProjectName();"/>
					<input type="button" id="removeBtn" value="Remove" style="display:none;" onclick="removeProjectName();"/>
					<input type="button" id="cancelBtn" value="Cancel" onclick="closeAddProjectName();"/>
				</td>
			</tr>
		</table>
	</div>
	
	
	<div style="display: none;" id="moveContentView">
		<div>
			<label style="color: white;">Layer Name:</label>
			<select id="moveContentSel"></select>
			<button onclick="moveProjectSave();" >Move Layer</button>
		</div>
		<div id="moveContentViewSub"></div>
	</div>
	
	<div id="context2" class="contextMenu">
		<ul>
			<li id="context_edit">Edit</li>
<!-- 			<li id="context_edit_google">Edit Google</li> -->
			<li id="context_delete">Delete</li>
		</ul>
	</div>
	<div id="context3" class="contextMenu">
		<ul>
			<li id="context_analysis">Analysis</li>
			<li id="context_upload">Upload</li>
			<li id="context_view">View</li>
<!-- 			<li id="context_view_google">View Google</li> -->
<!-- 			<li id="context_edit">Edit</li> -->
			<li id="context_manage">Manage</li>
		</ul>
	</div>
<!-- 	<div id="context4" class="contextMenu"> -->
<!-- 		<ul> -->
<!-- 			<li id="context_analysis">Analysis</li> -->
<!-- 			<li id="context_save">Save</li> -->
<!-- 		</ul> -->
<!-- 	</div> -->
	
	<div id="uploadWorldFileDig" style="background: #e5e5e5;">
		<table style="width: 100%;" border=1>
			<tr>
				<td style="width:50px; text-align: center;">FILE</td>
				<td id="file_upload_td">
					<div class="file_input_div" style="float: left;">
						<div class="file_input_img_btn"> Load </div>
					</div>
					
					<div id="floorMap_pop_file_1" class="text_box_dig" style="width:244px; height: 72px; overflow-y:auto; overflow-x:hidden; margin:8px 0 8px 10px; border:1px solid gray; float: left;"></div>
					<input type="hidden" id="uploadFileProIdx">
				</td>
			</tr>
			<tr>
				<td width="" height="25" align="center" colspan="2">
					<button class="create_button" onclick="createUploadFile();">SAVE</button>
					<button class="cancle_button" onclick="cancelUploadFile();">CANCEL</button>
				</td>
			</tr>
		</table>
	</div>
	
	<form enctype="multipart/form-data" method="POST" name="fileinfo" id="fileinfo" style="display:none;" >
	</form>

	<input type="hidden" id="shareAdd"/>
	<input type="hidden" id="shareRemove"/>
	<input type="hidden" id="editYes"/>
	<input type="hidden" id="editNo"/>
	<div id="clonSharUser" style="display:none;"></div>
