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
    /* padding-left: 35px; */
    /* margin-bottom: 12px; */
    cursor: pointer;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
}

.layerCheck{
	background-color : gray !important;
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
/* .container:hover input ~ .checkmark {
    background-color: #ccc;
} */

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

.hideDiv {
	display: none;
}

.btnBlue {border-radius: 2px; border: none; padding: 4px 10px; display: inline-block; background: #297ACC; color: white;}
.btnGray {border-radius: 2px; border: none; padding: 4px 10px; display: inline-block; background: #6E778A; color: white;}

/* #layerAttrTbl thead tr {background-color: #F2F3F5; border-bottom: 1px solid #E0E0E1;} */
#layerAttrTbl thead tr td {text-align: center;}
/* #layerAttrTbl tbody tr {border-bottom: 1px solid #E0E0E1;} */
#layerAttrTbl tbody tr td {text-align: center; padding: 5px;}
#layerAttrTbl {font-family: 'noto_r';}
/* .ui-dialog, #popup_container {
	left: 50% !important;
	top: 50% !important;
	margin-left: -175px !important; 
	margin-top: -175px !important; 
} */

/* dataTable Style */
#tblDataList {text-align: center;}
#tblDataList thead tr {background-color: #F2F3F5; border-bottom: 1px solid #E0E0E1;}
#tblDataList tbody tr {background-color: #000000; color:white;}
</style>

<script type="text/javascript">
var loginId = '<%= loginId %>';				//로그인 아이디
var loginToken = '<%= loginToken %>';		//로그인 token
var dataTable = false;
var proContentNum = 12;
var proIdx = 0;
var proEdit = 0;
var oldShareUser = 0;
var projectNum = 0;

var treeDataArray = new Array();
var attrArray = ['video', 'photo', 'sensor', 'traj'];
var videoColumn = "mv";
var photoColumn = "st";
var trajColumn = "mt";
var sensorColumn = ['accx', 'accy', 'accz', 'gyrox', 'gyroy', 'gyroz'];
var allColumn = ['mv', 'st', 'mt', 'accx', 'accy', 'accz', 'gyrox', 'gyroy', 'gyroz'];

// 가져온 프로젝트 정보로 프로젝트 트리를 그려줌.
function projectGroupListSetup(response){
	$('.viewModeCls').css('display','block');
// 	proIdx = response[0].idx;
	if (response != undefined) {
		addProjectGroupCell(response);
	} else {
		treeDataArray = new Array();
		$('#project_tree').jstree(true).settings.core.data = treeDataArray;
		$('#project_tree').jstree(true).refresh();
	}
}

// project group list with jstree
function addProjectGroupCell(response){
	// jstree data 구성
	treeDataArray = new Array();
	
	for (var i = 0; i < response.length; i++) {
		var treeData = {};
		
		treeData.id = response[i].idx;
		treeData.text = response[i].projectname;
		treeData.parent = "#";
		
		treeDataArray.push(treeData);
	}
	
	if (treeDataArray.length > 0) {
		// make jstree
		$('#project_tree').jstree({
			'core': {
				
				'data': treeDataArray,
				'icon': '/images/geoImg/color.png'
			},
			'plugins': ['wholerow']
			
		});
		
		$(".jstree-default-contextmenu").css("z-index", 1000);
		
		// jstree event binding
		$('#project_tree')
// 		.on('changed.jstree', function (e, data) {
// 			console.log('changed');
// 		})
		.on('select_node.jstree', function (e, data) {
			if($("#"+data.node.id).hasClass("layerCheck") == true)
			{
				$("#"+data.node.id).removeClass("layerCheck");
				$("#myData_"+data.node.id).remove();
				$("#"+data.node.id).append("<div id = 'myData_"+data.node.id+"'style='float:right;'><img style='height: 20px; width:25px; margin: 2px;' src='images/geoImg/switch1.png'/></div>");
				var nodeLayers = map.getLayersByName("gps_circle_" + data.node.id);
				
				$.each(nodeLayers, function(idx, val) {
					// remove all circle feature
					val.removeAllFeatures();
					
					// remove layer in map
					map.removeLayer(val);
				});
				
				// video stop
				stopVideo();
				projectNum = 1;
			}
			else
			{
				clickProjectPage(data.node.id, null);
				projectNum = 1;
				$("#"+data.node.id).addClass("layerCheck");
				$("#myData_"+data.node.id).remove();
				$("#"+data.node.id).append("<div id = 'myData_"+data.node.id+"'style='float:right;'><img style='height: 20px; width:25px; margin: 2px;' src='images/geoImg/switch.png'/></div>");
			}
			
			// 노드 선택
		})
		.on('deselect_node.jstree', function (e, data) {
			alert("non");
			// 노드 선택 해제
			var nodeLayers = map.getLayersByName("gps_circle_" + data.node.id);
			
			$.each(nodeLayers, function(idx, val) {
				// remove all circle feature
				val.removeAllFeatures();
				
				// remove layer in map
				map.removeLayer(val);
			});
			
			// video stop
			stopVideo();
		})
		.on('loaded.jstree', function (e, data) {
			addContextMenuOnTree();
			for(var j=0; j<response.length; j++)
			{
				$("#"+response[j].idx).append("<div id = 'myData_"+response[j].idx+"'style='float:right;'><img style='height: 20px; width:25px; margin: 2px;' src='images/geoImg/switch1.png'/></div>");
			}
		})
		.on('refresh.jstree', function (e, data) {
			addContextMenuOnTree();
		})
		.jstree();
	}
	
	
}

function addContextMenuOnTree() {
	$('[id$=_anchor]').contextMenu('context3', {
		bindings: {
			'context_upload': function(t) {
				myContentsMake(t.id.split("_")[0], t.id.split("_")[1]);
			},
			'context_view': function(t){
				openProjectViewer(t.id.split("_")[0]);
			},
			'context_table_view': function(t){
				tableViewProject(t.id.split("_")[0]);
			},
			'context_edit': function(t){
 				openProjectWriter(t.id.split("_")[0]);
 			},
			'context_analysis': function(t){
				analysisProject(t.id.split("_")[0]);
			},
			'context_manage': function(t){
				editProject(t.id.split("_")[0]);
			}
		}
	});
}

// upload in layer
function myContentsMake(makeContentIdx, tableName){
	editBtnClk = 1;
	ContentsMakes(tableName, '','', makeContentIdx);
}

//upload in layer
function myContentsMake2(proIdx){
	editBtnClk = 1;
	ContentsMakes2(proIdx);
}

// layer contents view
function openProjectViewer(projectIdx, nodeType){
	editBtnClk = 1;
	
	var Url			= baseRoot() + "cms/getProjectContent/";
	var param		= loginToken + "/" + loginId + "/list/" + projectIdx + "/1/1/"+nodeType;
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

// layer contents edit
function openProjectWriter(objTIdx, objNum, tbName) {
	editBtnClk = 1;
	
// 	var objTIdx = 0; 
	
	/* var objTDataKind = "";
	var objTArr = [];
	$('.editAnno').each(function(idx,val){
		objTIdx =$(val).attr('id');
	}); */
	
	//objTIdx = k;
	if(objTIdx != null && objTIdx != '' ){
		//objTArr = objTIdx.split('_');
		//objNum = objNum + 1;
		if(tbName == "video")
		{
			objTDataKind = "GeoVideo";
		}
		else if(tbName == "photo")
		{
			objTDataKind = "GeoPhoto";
		}
		
		
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
						getOneImageData(objTIdx, objNum, tmpEditUserYN);
					}else if(objTDataKind = 'GeoVideo'){
						getOneVideoData(objTIdx, objNum, tmpEditUserYN, '1');
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

function getOneImageData(tmpTIdx, objNum, tmpEditUserYN){
	var Url			= baseRoot() + "cms/getImage/";
	var param		= "one/" + loginToken + "/" + loginId + "/&nbsp;/&nbsp;/"+tmpTIdx+"/&nbsp;/" +objNum;
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
					insertIdx.setAttribute('value',response.idx);
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
function getOneVideoData(tmpTIdx, objNum, tmpEditUserYN, k){
	var Url			= baseRoot() + "cms/getVideo/";
	var param		= "one/" + loginToken + "/" + loginId + "/&nbsp;/&nbsp;/" +tmpTIdx+"/&nbsp;/"+objNum;
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
					insertIdx.setAttribute('value',response.idx);
					form.appendChild(insertIdx);
					
					form.submit();
				}
			}else{
				jAlert(data.Message, 'Info');
			}
		}
	});
}
// layer contents analysis
function analysisProject(projectIdx)
{
	var tmpProName = $('#hiddenProName_'+ projectIdx).val();
	var tmpProShare = $('#hiddenShareType_'+projectIdx).val();
	var tmpImgIcon = $('#markerIcon_'+projectIdx).attr('src');
	$('#projectNameTxt').val(tmpProName);
	oldShareUser = tmpProShare;
	proIdx = projectIdx;
	$('input[name=shareRadio]:radio[value='+ tmpProShare +']').attr('checked',true);
	
	var base_url = 'http://'+location.host;
	window.open('', 'analysisView', 'width=850, height=500, top=200, left=440');
	var form = document.createElement('form');
	form.setAttribute('method','post');
	form.setAttribute('action',base_url + "/GeoCMS/sub/contents/analysisView.do?loginToken="+loginToken+"&loginId="+loginId+'&projectBoard=1&tmpProName='+tmpProName+'&projectIdx='+projectIdx);
	form.setAttribute('target','analysisView');
	document.body.appendChild(form);
	
	form.submit();
}

function queryExecute()
{
	var base_url = 'http://'+location.host;
	window.open('', 'queryExecuteView', 'width=1100, height=850, top=100, left=500');
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
// project info edit
function editProject(projectIdx){
	editBtnClk = 1;
// 	var tmpProName = $('#hiddenProName_'+ projectIdx).val();
// 	var tmpProShare = $('#hiddenShareType_'+projectIdx).val();
// 	var tmpImgIcon = $('#markerIcon_'+projectIdx).attr('src');
	
// 	$('#projectNameTxt').val(tmpProName);
	proIdx = projectIdx;
	
	clickProjectPage(projectIdx, 'editView');
}

function tableViewProject(projectIdx){
	editBtnClk = 1;
	var tmpProName = $('#hiddenProName_'+ projectIdx).val();
	var tmpProShare = $('#hiddenShareType_'+projectIdx).val();
	var tmpImgIcon = $('#markerIcon_'+projectIdx).attr('src');
	
	$('#projectNameTxt').val(tmpProName);
	proIdx = projectIdx;
	
	editDiagOpenTable(projectIdx);
}

// 레이어 클릭시 저장
var clickedIdx = 0;

// select project
function clickProjectPage(projectId, dataType) {
	var Url			= baseRoot() + "cms/getProjectContent/";
	var param		= loginToken + "/" + loginId + "/list/" + projectId + "/&nbsp;/&nbsp;/1";
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			//initialize();
			var response = data.Data;
			if(response != null && response != '' && data.Code == '100'){
				
				if (response.length > 0) {
					clickedIdx = response[0].idx;
				}
				if(dataType != 'editView' && dataType != 'removeView'){
					addProjectChildCell(response, 'old');
				}else if(dataType == 'editView'){
					editDiagOpen(data.DataLen, projectId);
				}else if(dataType == 'removeView'){
					removeProjectName1(data.DataLen);
				}
			}else{
				if(dataType != 'editView' && dataType != 'removeView'){
					//Data Does Not Exist 문구 제거
					//jAlert(data.Message, 'Info');
				}else if(dataType == 'editView'){
					editDiagOpen(0, projectId);
				}else if(dataType == 'removeView'){
					removeProjectName1(0);
				}
			}
		}
	});
}

function clickRowNum(projectId, dataType, rowId) {
	var Url			= baseRoot() + "pgm/getProjectRowContent/";
	var param		= loginToken + "/" + loginId + "/list/" + projectId + "/"+rowId+"/&nbsp;";
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
					clickProjectPage(projectId, null);
					addProjectChildCell(response, 'new');
				}else if(dataType == 'editView'){
					editDiagOpen(data.DataLen, projectId);
				}else if(dataType == 'removeView'){
					removeProjectName1(data.DataLen);
				}
			}else{
				if(dataType != 'editView' && dataType != 'removeView'){
					//Data Does Not Exist 문구 제거
					//jAlert(data.Message, 'Info');
				}else if(dataType == 'editView'){
					editDiagOpen(0, projectId);
				}else if(dataType == 'removeView'){
					removeProjectName1(0);
				}
			}
		}
	});
}

function editDiagOpen(totalLen, projectId){
	$('#projectNameTxt').val('');
	$(".addRow").remove();
	
	// Layer 이름
	var layerName = "";
	$.each(treeDataArray, function(idx, val) {
		if (val.id == projectId) {
			layerName = val.text;
		}
	});
	
	$("#projectNameTxt").val(layerName);
	
	// 속성 및 타입 불러오기
	var Url			= baseRoot() + "pgm/getLayer/";
	var param		= projectId;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "GET"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			if(data.Code == '100'){
				var result = data.Data;
				fnSetRow(data.Data, data.userData);
			} else{
				jAlert(data.Message, 'Info');
			}
		}
	});
	
	if(totalLen == 0){
		$('#projectNameAddDig #removeBtn').css('display','inline-block');
	}else{
		$('#projectNameAddDig #removeBtn').css('display','none');
	}
	$('#projectNameAddDig #saveBtn').css('display','none');
	$('#projectNameAddDig').css('background','black');
	$('#projectNameAddDig #modifyBtn').css('display','inline-block');
	$('#projectNameAddDig').dialog('option', 'title', 'Manage Layer');
	$('#projectNameAddDig').dialog({height:'auto', width:'500px'});
	$('#projectNameAddDig').dialog('open');
}

function editDiagOpenTable(projectIdx)
{
	$('#tableViewDig').dialog('option', 'title', 'Table View');
	$('#tableViewDig').dialog({height:'auto', width:'620px'});
	
	//$('#tableViewDig #saveBtn').css('display','none');
	//$('#projectNameAddDig #modifyBtn').css('display','inline-block');
	//$('#tableViewDig').dialog('option', 'title', 'Manage Layer');
	viewDataTable(projectIdx);
	
	proIdx = projectIdx;
}

// 현재는 gpsData를 맵에 표시만 해줌. 이후 child node 생성 예정
function addProjectChildCell(response, type) {
	var totalLan = response.length;
	var halfLan = Math.floor(totalLan/2);
	var list = [];
	for(var i=0; i<totalLan; i++) {
		if(response[i] == null || response[i] == '' || response[i] == undefined ) {	//등록한 이미지가 없을때 나 
			
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
					if(idx % 2 == 0)
					{
						gpsArrLat.push(latVal);
						gpsArrLon.push(lonVal);
					}
				});
			}else if(response[i].datakind == "GeoTraj")
			{
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
			
			mapCenterChange(response[i], gpsArrLat, gpsArrLon, type);
		}
		
	}
	//alert(mapList);
	
// 	var center = new OpenLayers.LonLat(response[response.length-1].longitude, response[response.length-1].latitude);
	var center = new OpenLayers.LonLat(response[halfLan].longitude, response[halfLan].latitude);
	center.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
	map.setCenter(center, 15);
}

function removeProjectName(){
	clickProjectPage(proIdx, 'removeView');
}

// remove project
function removeProjectName1(dataTLen){
	if(dataTLen > 0){
		jAlert('It can be deleted only if there is no content in the layer.','info');
	}else{
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
						if (data.Code == "100") {
							viewMyProjects(null);
							closeAddProjectName();
							
							// pgm remove layer call
							fnPgmRemoveLayer(proIdx, false);
						} else {
							jAlert(data.Message, 'Info');
						}
						/* viewMyProjects(null);
						closeAddProjectName();
						jAlert(data.Message, 'Info'); */
					}
				});
			} 
		});
	}
}

function fnPgmRemoveLayer(projectId, noMsg) {
	var Url			= baseRoot() + "pgm/removeLayer/";
	var param		= projectId;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "GET"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			if (data.Code == "100") {
				if (!noMsg) {
					jAlert(data.Message, 'Info');
				}
				$('#project_tree').jstree(true).settings.core.data = treeDataArray;
				$('#project_tree').jstree(true).refresh();
			} else {
				if (!noMsg) {
					jAlert(data.Message, 'Info');
				}
			}
		}
	});
}

//프로젝트 명 추가 dialog Open
function openAddProjectName(){
	proIdx = 0;
	$('#projectNameAddDig #saveBtn').css('display','inline-block');
	$('#projectNameAddDig #modifyBtn').css('display','none');
	$('#projectNameAddDig #removeBtn').css('display','none');
	$('#projectNameAddDig').dialog('option', 'title', 'Add Layer');
	$('#projectNameAddDig').dialog({height:'auto', width:'500px'});
// 	$('input[name=shareRadio]:radio[value=0]').attr('checked',true);
	$('#projectNameAddDig').dialog('open');
	$('#projectNameTxt').val('');
	$(".addRow").remove();
}

//프로젝트 명 추가 dialog close
function closeAddProjectName(){
	$('#projectNameAddDig').dialog('close');
}

function closeDataTable(){
	$('#tableViewDig').dialog('close');
}

// INSERT
function insertFile(){
	myContentsMake2(proIdx);
// 	var tableName = "";
// 	// 속성 및 타입 불러오기
// 	var Url			= baseRoot() + "pgm/getTableName/";
// 	var param		= proIdx;
// 	var callBack	= "?callback=?";
	
// 	$.ajax({
// 		type	: "GET"
// 		, url	: Url + param + callBack
// 		, dataType	: "jsonp"
// 		, async	: false
// 		, cache	: false
// 		, success: function(data) {
// 			tableName = data.Data;
			
// 		}
// 	});
// 	var selectName = tableName.split("_")[0];
// 	myContentsMake(proIdx, selectName);
}

//add project name
function addProjectName(){
	var projectNameTxt = $('#projectNameTxt').val();
	var projectShareUser = $('#shareAdd').val();
	var projectEditYes = $('#editYes').val();
	var projectShareType = "1";
	
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
	
	var message = "";
	var attributes = new Array();
	if ($(".addRow:visible").length == 0) {
		jAlert('Add row, please', 'Info');
		return;
	} else {
		var tblPrefix = "";
		
		$.each($(".addRow"), function(idx, val) {
			var id = val.id;
			var object = new Object();
			var textValue = $("#attr_" + id).val();
			var selectValue = $("#type_" + id).val();
			
			object.attribute = textValue;
			object.type = selectValue;
			
			attributes.push(object);
		});
		
		$.each($(".addRow:visible"), function(idx, val) {
			var id = val.id;
			var textValue = $("#attr_" + id).val();
			var selectValue = $("#type_" + id).val();
			
			if (selectValue == "mvideo") {
				tblPrefix += "vd";
			} else if (selectValue == "stphoto") {
				tblPrefix += "pt";
			} else if (selectValue == "mdouble") {
				tblPrefix += "ss";
			} else if (selectValue == "mpoint") {
				tblPrefix += "tj";
			}
			else if (selectValue == "video") {
				tblPrefix += "novid";
			}
			else if (selectValue == "photo") {
				tblPrefix += "nopho";
			}
			
			if (textValue == "") {
				message = "Please enter attribute.";
				return false;
			}
			
			if (selectValue == "(select)") {
				message = "Please select type.";
				return false;
			}
		});
		
		if (message != "") {
			attributes = new Array();
			jAlert(message, 'info');
			return;
		} else {
			if (tblPrefix == "vd") {
				tblPrefix = "video";
			} else if (tblPrefix == "pt") {
				tblPrefix = "photo";
			} else if (tblPrefix == "ss") {
				tblPrefix = "sensor";
			} else if (tblPrefix == "tj") {
				tblPrefix = "traj";
			}
		}
		
		var typeNum = 0;
		$.each(attributes, function(idx, val) {
			if ($.inArray(val.type, attrArray) > -1) {
				typeNum++;
			}
		});
		
		/* if (typeNum == 0) {
			jAlert('One of video, photo, sensor, traj must be selected. ', 'info');
			return;
		} */
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
			if (data.Code == "100") {
				closeAddProjectName();
				viewMyProjects(null);
				
				// pgm create layer call
				fnPgmCreateLayer(tblPrefix + "_" + data.Data, attributes);
			} else {
				jAlert(data.Message, 'Info');
			}
		}
	});
}

function fnPgmCreateLayer(tableName, attributes) {
	var Url			= baseRoot() + "pgm/saveLayer/";
 	var param		= tableName + "/"+ encodeURI(JSON.stringify(attributes));
	var callBack	= "?callback=?";

	$.ajax({
		type	: "POST"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			if (data.Code == "100") {
				jAlert(data.Message, 'Info');
				$('#project_tree').jstree(true).settings.core.data = treeDataArray;
				$('#project_tree').jstree(true).refresh();
			} else {
				jAlert(data.Message, 'Info');
				// 실패 시, 생성된 레이어는 지운다.
				fnRemoveProject(tableName.split("_")[1]);
			}
		}
	});
}

function fnRemoveProject(projectId) {
	var Url			= baseRoot() + "cms/removeProject/";
	var param		= loginToken + "/" + loginId + "/"+ projectId;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "POST"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			if (data.Code == "100") {
				viewMyProjects(null);
				closeAddProjectName();
			} else {
				jAlert(data.Message, 'Info');
			}
		}
	});
}

function fnAddRow() {
	var index = 1;
	
	if ($("#layerAttrTbl tbody tr").length > 1) {
		index = parseInt($("#layerAttrTbl tbody tr:eq(" + ($("#layerAttrTbl tbody tr").length - 2) + ")").attr("id")) + 1;
	}
	
	var target = $("#layerAttrTbl tbody tr:last");
	
	var options = ['integer', 'text', 'mvideo', 'mdouble', 'stphoto', 'mpoint'];
	
	var content = 	"<tr id='" + index + "' class='addRow' command='INSERT'>";
	
	// 타입
	content += 			"<td>"
	content += 				"<select id='type_" + index + "' style='height: 24px;' onchange='fnCheckType(this);'>";
	content += 					"<option>(select)</option>";
	for (var i = 0; i < options.length; i++) {
		content += 				"<option value='" + options[i] + "'>" + options[i] + "</option>";
	}
	content += 				"</select>";
	content += 			"</td>"
	
	// 속성명
	content += 			"<td>"
	content += 				"<input id='attr_" + index + "' type='text' style='width:100%;'/>";
	content += 			"</td>"
	
	// 삭제
	content += 			"<td>"
	content += 				"<input type='button' class='btnGray' value='delete' onclick='fnDeleteRow(this);'>";
	content += 			"</td>"
	
	content += 		"</tr>";
	
	target.before(content);
}

function fnSetRow(data, userData) {
	var displayData = new Array();
	
	var v = false;
	var p = false;
	var s = false;
	var t = false;
	
	var index = 1;
	
	$.each(data, function(idx, val) {
		if (val.attr != "idxseq") 
		{
			if (val.type == "USER-DEFINED")
			{
				$.each(userData, function(idx2, val2){
					if(val.attr == val2.attr)
					{
						var object = new Object();
						
						object.attr = val2.attr;
						object.type = val2.type;
						
						fnAddRowData(index, object, true);
						index++;
					}
				});
			}
			else 
			{
				var object = new Object();
				
				object.attr = val.attr;
				object.type = val.type;
				
				displayData.push(object);
			}
		}
			// video
			/* 	v = true;
			else if (val.attr == "st") {
				// photo
				p = true;
			} else if ($.inArray(val.attr, sensorColumn) != -1) {
				// sensor
				s = true;
			} else if (val.attr == "mt") {
				// traj
				t = true; 
			} */
		/* else 
		{
			var object = new Object();
			
			object.attr = val.attr;
			object.type = val.type;
			
			displayData.push(object);
		} */
	});
	
	// add row
	/* var index = 1;
	
	// add row - specific column
	if (v) {
		var object = new Object();
		object.attr = "mv";
		object.type = "video";
		
		fnAddRowData(index, object, true);
		index++;
	}
	
	if (p) {
		var object = new Object();
		object.attr = "st";
		object.type = "photo";
		
		fnAddRowData(index, object, true);
		index++;
	}
	
	if (s) {
		var object = new Object();
		object.attr = "accx, accy, accz, gyrox, gyroy, gyroz";
		object.type = "sensor";
		
		fnAddRowData(index, object, true);
		index++;
	}
	
	if (t) {
		var object = new Object();
		object.attr = "mt";
		object.type = "traj";
		
		fnAddRowData(index, object, true);
		index++;
	} */
	
	// add row - normal
	$.each(displayData, function(idx, val) {
		fnAddRowData(index, val, false);
		index++;
	});
}

function fnAddRowData(index, data, disable) {
	var target = $("#layerAttrTbl tbody tr:last");
	
	var options = ['integer', 'text', 'mvideo', 'stphoto', 'mdouble', 'mpoint'];
	
	var content = 	"<tr id='" + index + "' class='addRow' command='UPDATE'>";
	
	// 타입
	content += 			"<td>"
	content += 				"<select id='type_" + index + "' style='height: 24px;' onchange='fnCheckType(this);' originalValue='" + data.type + "'>";
	content += 					"<option>(select)</option>";
	for (var i = 0; i < options.length; i++) {
		content += 				"<option value='" + options[i] + "' " + (data.type == options[i] ? "selected" : "") + ">" + options[i] + "</option>";
	}
	content += 				"</select>";
	content += 			"</td>"
	
	// 속성명
	content += 			"<td>"
	content += 				"<input id='attr_" + index + "' type='text' style='width:100%;' originalValue='" + data.attr + "' value='" + data.attr + "' " + (disable ? "\disabled=\'disabled\'" : '') + "/>";
	content += 			"</td>"
	
	// 삭제
	content += 			"<td>"
	content += 				"<input type='button' class='btnGray' value='delete' onclick='fnDeleteRow(this);'>";
	content += 			"</td>"
	
	content += 		"</tr>";
	
	target.before(content);
}

function fnCheckType(obj) {
	var msg = "";
	var id = obj.id;
	var index = id.split("_")[1];
	$("#attr_" + index).val("");
	
	$.each($(".addRow:visible"), function(idx, val) {
		var select = $(this).find("select")[0];
		if (id != select.id) {
			if (select.value != "(select)" && select.value == $("#"+id).val() && $.inArray(select.value, attrArray) > -1) {
				msg = "Please check type";
				return false;
			}
		}
	});
	
	if (msg != "") {
		jAlert(msg, 'info');
		$(obj).val("(select)");
		$("#attr_" + index).removeAttr("disabled");
	} else {
		var selectVal = $("#"+id).val();
		if (selectVal == "video") {
			$("#attr_" + index).val("mv");
			$("#attr_" + index).attr("disabled", "disabled");
		} else if (selectVal == "photo") {
			$("#attr_" + index).val("st");
			$("#attr_" + index).attr("disabled", "disabled");
		} else if (selectVal == "sensor") {
			$("#attr_" + index).val("accx, accy, accz, gyrox, gyroy, gyroz");
			$("#attr_" + index).attr("disabled", "disabled");
		} else if (selectVal == "traj") {
			$("#attr_" + index).val("mt");
			$("#attr_" + index).attr("disabled", "disabled");
		} else {
			$("#attr_" + index).removeAttr("disabled");
		}
	}
}

function fnDeleteRow(obj) {
	if ($(obj).closest("tr").attr("command") == "UPDATE") {
		$(obj).closest("tr").attr("command", "DELETE");
		$(obj).closest("tr").css("display", "none");
	} else if ($(obj).closest("tr").attr("command") == "INSERT") {
		$(obj).closest("tr").remove();
	}
}

//modify project name
function modifyProjectName(){
	var projectNameTxt = $('#projectNameTxt').val();
	var projectShareType = "1";
	
	var projectAddShareUser = $('#shareAdd').val();
	var projectRemoveShareUser = $('#shareRemove').val();
	var projectEditYes = $('#editYes').val();
	var projectEditNo = $('#editNo').val();
	
	if(projectNameTxt == null || projectNameTxt == ''){
		jAlert('Please enter project name.', 'Info');
		return;
	}
	
	if(projectShareType != null && projectShareType == 2 && (projectAddShareUser == null || projectAddShareUser == '') && oldShareUser != 2){
		jAlert('No sharing user specified.', 'Info');
		return;
	}
	
	if(projectNameTxt != null && projectNameTxt.indexOf('\'') > -1){
		jAlert('You can not use the special character \' in the project name.', 'Info');
		return;
	}

	projectNameTxt = dataReplaceFun(projectNameTxt);
	
	if(projectAddShareUser == null || projectAddShareUser == ''){ projectAddShareUser = '&nbsp;'; }
	if(projectRemoveShareUser == null || projectRemoveShareUser == ''){ projectRemoveShareUser = '&nbsp;'; }
	if(projectEditYes == null || projectEditYes == ''){ projectEditYes = '&nbsp;'; }
	if(projectEditNo == null || projectEditNo == ''){ projectEditNo = '&nbsp;'; }
	
	var message = "";
	var attributes = new Array();
	if ($(".addRow:visible").length == 0) {
		jAlert('Add row, please', 'Info');
		return;
	} else {
		var tblPrefix = "";
		
		$.each($(".addRow"), function(idx, val) {
			var id = val.id;
			var command = $(val).attr("command");
			var object = new Object();
			var textValue = $("#attr_" + id).val();
			var oriTextValue = $("#attr_" + id).attr("originalValue");
			var selectValue = $("#type_" + id).val();
			var oriSelectValue = $("#type_" + id).attr("originalValue");
			
			object.attribute = textValue;
			object.oriAttribute = oriTextValue
			object.type = selectValue;
			object.oriType = oriSelectValue;
			object.command = command;
			
			attributes.push(object);
		});
		
		$.each($(".addRow:visible"), function(idx, val) {
			var id = val.id;
			var command = $(val).attr("command");
			var textValue = $("#attr_" + id).val();
			var selectValue = $("#type_" + id).val();
			
			if (selectValue == "video") {
				tblPrefix += "vd";
			} else if (selectValue == "photo") {
				tblPrefix += "pt";
			} else if (selectValue == "sensor") {
				tblPrefix += "ss";
			} else if (selectValue == "traj") {
				tblPrefix += "tj";
			}
			
			if (textValue == "") {
				message = "Please enter attribute.";
				return false;
			}
			
			if (selectValue == "(select)") {
				message = "Please select type.";
				return false;
			}
		});
		
		if (message != "") {
			attributes = new Array();
			jAlert(message, 'info');
			return;
		} else {
			if (tblPrefix == "vd") {
				tblPrefix = "video";
			} else if (tblPrefix == "pt") {
				tblPrefix = "photo";
			} else if (tblPrefix == "ss") {
				tblPrefix = "sensor";
			} else if (tblPrefix == "tj") {
				tblPrefix = "traj";
			}
		}
		
		var typeNum = 0;
		$.each(attributes, function(idx, val) {
			if ($.inArray(val.type, attrArray) > -1) {
				typeNum++;
			}
		});
		
		/* if (typeNum == 0) {
			jAlert('One of video, photo, sensor, traj must be selected.', 'info');
			return;
		} */
	}
	
	jConfirm('Are you sure you want to modify?<br>Data in columns that change can be deleted.', 'Info', function(type){
		if(type) {
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
					if (data.Code == "100") {
						viewMyProjects(proIdx);
						closeAddProjectName();
						
						// pgm update layer call
						fnPgmUpdateLayer(tblPrefix + "_" + proIdx, attributes);
					} else {
						jAlert(data.Message, 'Info');
					}
				}
			});
		}
	});
}

function fnPgmUpdateLayer(newTableName, attributes) {
	var Url			= baseRoot() + "pgm/updateLayer/";
	var param		= newTableName + "/" + JSON.stringify(attributes);
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "POST"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			if (data.Code == "100") {
				jAlert(data.Message, 'Info');
				$('#project_tree').jstree(true).settings.core.data = treeDataArray;
				$('#project_tree').jstree(true).refresh();
				
			} else {
				jAlert(data.Message, 'Info');
			}
		}
	});
}
</script>
	<div>
		<label style="margin-left: 15px; display:none;">Layer</label>
	</div>
	<div id="project_list_table" style="">
		<div class="container">
	        <div class="row">
	            <div class="row-header" onclick="openAddProjectName();">레이어 생성</div>
	        </div>
	        <div class="row">
	            <div class="row-header" onclick="analysisProject();">Analysis</div>
	        </div>
	        <div class="row">
	            <div class="row-header">Layer List</div>
	            <div class="row-content" style="display: block;">
	            	<div id="project_tree"></div>
	            </div>
	        </div>
	        <!-- <div class="row">
	            <div class="row-header">즐겨찾기</div>
	            <div class="row-content">
	            </div>
	        </div> -->
	    </div>
		<!-- <div id="project_tree">
			<ul>
				<li>TEST01</li>
				<li>TEST02</li>
			</ul>
		</div> -->
	</div>
	<!-- projectName dialog -->
	<div id="projectNameAddDig" class="hideDiv" style="color:white; background:black;">
		<table style="width: 100%;">
			<tr style="height:50px;">
				<td style="width:100px;">Layer Name</td>
				<td><input type="text" id="projectNameTxt" style="width:100%;" /></td>
			</tr>
		</table>
		
		<table id="layerAttrTbl" style="width: 100%;">
			<thead>
				<tr>
					<th>Type</th>
					<th>Attribute</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<tr id="addTr">
					<td colspan="3" style="text-align: center;">
						<input type="button" class="btnBlue" id="addRow" value="add row" onclick="fnAddRow();"/>
					</td>
				</tr>
			</tbody>
		</table>
		
		<table style="width: 100%; margin-top: 10px;">
			<tr style="text-align: center; height:50px;">
				<td>
					<input type="button" id="saveBtn" value="Save" onclick="addProjectName();"/>
					<input type="button" id="modifyBtn" value="Modify" style="display:none;" onclick="modifyProjectName();"/>
					<input type="button" id="removeBtn" value="Remove" style="display:none;" onclick="removeProjectName();"/>
					<input type="button" id="cancelBtn" value="Cancel" onclick="closeAddProjectName();"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="tableViewDig" class="hideDiv" style="background:black; color:white;">
		<input type="hidden" id="tableName" name="tableName"/>
		<table id="tblDataList" class="tblTurboList" style="cellspacing:0; width:100%; padding-top: 10px;"></table>
		<table style="width: 100%;">
			<tr style="text-align: center; height:50px;">
				<td colspan="2">
					<input type="button" id="saveBtn" value="Insert" onclick="insertFile();"/>
					<input type="button" id="modifyBtn" value="Modify" onclick="updateFile();"/>
					<input type="button" id="removeBtn" value="Remove" onclick="fnRowDelete();"/>
					<input type="button" id="cancelBtn" value="Cancel" onclick="closeDataTable();"/>
				</td>
			</tr>
		</table>
		<div id="context4" class="contextMenu hideDiv">
			<ul>
				<li id="context_view">View</li>
				<li id="context_edit">Edit</li>
				<!-- li id="context_imp">Import</li-->
				<li id="context_exp">Export</li>
				<li id="context_exp_vgg">Export(VGG)</li>
			</ul>
		</div>
	</div>
	
	
	<div style="display: none;" id="moveContentView">
		<div>
			<label style="color: white;">Layer Name:</label>
			<select id="moveContentSel"></select>
			<button onclick="moveProjectSave();" >Move Layer</button>
		</div>
		<div id="moveContentViewSub"></div>
	</div>
	
	<div id="context2" class="contextMenu hideDiv">
		<ul>
			<li id="context_edit">Edit</li>
			<li id="context_delete">Delete</li>
		</ul>
	</div>
	<div id="context3" class="contextMenu hideDiv">
		<ul>
			<!-- <li id="context_analysis">Analysis</li>
			<li id="context_upload">Upload</li>
			<li id="context_view">View</li>
			<li id="context_edit">Edit</li> -->
			<li id="context_table_view">Table View</li>
			<li id="context_manage">Manage</li>
		</ul>
	</div>
	
	<div id="uploadWorldFileDig" style="background: #e5e5e5;" class="hideDiv">
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
	<div id="insertFileDig" style="background: #e5e5e5;" class="hideDiv">
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
