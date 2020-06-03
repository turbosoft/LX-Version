<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%-- <%@ page autoFlush="true" buffer="1094kb"%> --%>
<%@ page import="javax.servlet.http.HttpServletResponse,java.io.PrintWriter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<jsp:include page="page_common.jsp"></jsp:include>
<jsp:include page="mainSetting.jsp"></jsp:include>

<%
String loginId = (String)session.getAttribute("loginId");					//로그인 아이디
String loginToken = (String)session.getAttribute("loginToken");				//로그인 token
String loginType = (String)session.getAttribute("loginType");				//로그인 권한
%>
<title>GeoCMS</title>

<!-- login -->
<script type="text/javascript">
var loginId = '<%=loginId%>';
var loginToken = '<%=loginToken%>';
var loginType = '<%=loginType%>';

var typeShape ="marker";
var selectedIdxseq = "";
var LocationData = new Array();	//마커용
var editMode = 0;	//편집 모드 (0:일반 모드 , 1:편집모드)
var b_contentNum = [];
var menuArr = ['logo', /*'MakeContents',*/ 'MyProjects', /*'OpenApi',  'latestUpload',*/ 'searchBox']; 		//menu List
var projectImage = 0;	//GeoPhoto 다운여부
var projectVideo = 0;	//GeoVideo 다운여부
var b_url = '';			//url
var request = null;		//request;
var dMarkerLat = 0;		//default marker latitude
var dMarkerLng = 0;		//default marker longitude
var b_nowProjectIdx = 0;
var b_nowProjectContentNum = 18;
var b_orderType = 'DESC';

/* video play  */
var video_child_len = 1;
/* var video0 = document.getElementById("video_player0");
var video1 = document.getElementById("video_player1");
var video2 = document.getElementById("video_player2");
var video3 = document.getElementById("video_player3");
var video4 = document.getElementById("video_player4"); */

$(function(){
	
	/* $.get( "http://202.31.147.180/task?url=http://turbo.hopto.org:8127/GeoCMS/upload/GeoPhoto/20161213_113143%281%29_thumbnail_600.png&model_name=mscoco_maskrcnn&file_type=image", function( data ) {
		  alert( "Load was performed." );
	});
	 */
	session_check();	//login check
// 	$('#jstree').jstree();
	var mapWidth = $(window).width()- $('#image_list').width();	//화면 크기에 따라 이미지 크기 조정
	$('#image_map').css('width', '100%');
	var setMapHeight = $(window).height();//화면 크기에 따라 이미지 크기 조정
	if(setMapHeight > 500){
		$('#image_map').css('height', '94.7%');
	}
	var setFooterHeight = $('#image_map').height() + 35;
	$('#footer').css('top',setFooterHeight);
	$('.row-header').on('click', function(){
        $(this).parent().find('.row-content').slideToggle();
        $(this).parent().siblings().find('.row-content').slideUp();
    });

    $('.item span').on('click', function(){
        $(this).parent().find('ul').slideToggle();
    });
	
	
    $('#dialog').dialog({	//openApi dialog
      autoOpen: false,
      width:845,
      height:660,
      minHeight:660,
      top:100,
      modal:true,
      hide: {
        effect: 'explode',
        duration: 1000
      }
    });
    
    
    
    $('#LoginDig').dialog({	//projectName 추가, 수정 dialog
        autoOpen: false,
        width:400,
        height:160,
        title:'LOGIN',
        modal:true,
        background:"#99CCFF"
      });
    
    $('#projectNameAddDig').dialog({	//projectName 추가, 수정 dialog
        autoOpen: false,
        width:350,
        height:220,
        title:'Add Layer',
        modal:true,
        background:"#000000"
      });
    $('#tableViewDig').dialog({	//projectName 추가, 수정 dialog
        autoOpen: false,
        width:900,
        height:500,
        title:'Layer View',
        modal:true,
        background:"#99CCFF"
      });
    
    $('#insertFileDig').dialog({	//좌표 파일 추가
        autoOpen: false,
        width:360,
        height:210,
        title:'File Upload',
        modal:true,
        background:"#e5e5e5"
      });
    
    $('#uploadWorldFileDig').dialog({	//좌표 파일 추가
        autoOpen: false,
        width:360,
        height:210,
        title:'File Upload',
        modal:true,
        background:"#e5e5e5"
      });
    
    $('#copyPojectAddDig').dialog({	//projectName 추가, 수정 dialog
        autoOpen: false,
        width:320,
        height:130,
        title:'Add Layer',
        modal:true,
        background:"#99CCFF"
      });
    
    $('#serverDig').dialog({	//serverDig
        autoOpen: false,
        width:500,
        height:200,
        modal:true,
        background:"#99CCFF"
      });
    
    callRequest("BI", "/GeoPhoto/geoSetChkImage.do", null);
    
//     $(window).resize(function(){
//     	var mapWidth = 0;
//     	if($(window).width() < $('#menus').css('min-width').replace('px','')){
//     		mapWidth = $('#menus').css('min-width').replace('px','') - $('#image_list').width();
//     	}else{
//     		mapWidth = $(window).width()- $('#image_list').width();	//화면 크기에 따라 이미지 크기 조정
//     	}
//     	$('#image_map').css('width', '100%');
//     	$('#map_canvas').css('min-width',mapWidth);
//     }).resize();

    $('.offProjectDiv').bind('mousedown', function(){
    	alert("우클릭하자");
    });
    
    $("#mapModeChange").change(function() {
    	var selectMap = $("#mapModeChange option:selected").val();
    	vworld.setMode(selectMap);
    });
    
	$("#mapSelect").change(function() {
		var selectMap = $("#mapSelect option:selected").val();
		localStorage.mapType = selectMap;
		location.reload();
	});
	
	var mapType = localStorage.getItem("mapType");
	if (mapType == "OSM" || mapType == "VW") {
		$("#mapSelect option[value='" + mapType + "']").attr("selected", "selected");
		if (mapType == "VW") {
			$("#mapModeChange").css("display", "");
		} else {
			$("#mapModeChange").css("display", "none");
		}
	}
});
$(window).load(function(){
	
}); 
//GeoPhoto, GeoVideo 연결
function httpRequest(type, obj){
	if(window.XMLHttpRequest){
		try{
			request = new XMLHttpRequest();
		}catch(e){
			request = null;
		}

	}else if(window.ActiveXObject){
		//* IE
		try{
			request = new ActiveXObject("Msxml2.XMLHTTP");
		}catch(e){
			//* Old Version IE
			try{
				request = new ActiveXObject("Microsoft.XMLHTTP");
			}catch(e){
				request = null;
			}
		}
	}

	request.onreadystatechange = function(){
		if(request.readyState == 4 && request.status == 200){
			if(type == "BI"){
				projectImage = 1;
				callRequest("BV", "/GeoVideo/geoSetChkVideo.do", null);
			}
			else if(type == "BV"){
				projectVideo = 1;
				getBase();
			}
		}else if(request.readyState == 4 && type == "BI"){
			callRequest("BV", "/GeoVideo/geoSetChkVideo.do", null);
		}else if(request.readyState == 4 && type == "BV"){
			getBase();
		}
	}
}


//allfor 연동
function allforLoad()
{
	var win = window.open("http://all4ace507.iptime.org:30080/~leejy/Cesium/Apps/lx/#gotoPosition=127.07025957572726,35.805856877255465,127.15111208427824,35.836096242911474", "_blank");
	win.focus();
}

//GeoPhoto, GeoVideo 연결 function
function callRequest(type, textUrl, obj){
	httpRequest(type, obj);
	request.open("POST", "http://"+location.host + textUrl, true);
	request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
	request.send(null);
}

//login 여부
function session_check(){
	if(loginId != null && loginId != '' && loginId != 'null') {
		$('#login_page').css('display', 'none');
		$('#status_login').css('display', 'block');
		$('#userId').text(loginId);
		
		var tmpWidth = $('#userId').width();
		tmpWidth = tmpWidth + 130;
		if(loginType !='ADMIN'){
			tmpWidth += 100;
			$('#userId').css('right', tmpWidth+'px');
			$('#statusLogout').css('top', '-37px');
			$('#userId').css('top', '-38px');
			$('#status_login').find('img').css('right', '45px');
		}else{
			tmpWidth += 100;
			$('#userId').css('top', '50px');
			$('#userId').css('right', tmpWidth+'px');
			$('#statusLogout').css('top', '50px');
			$('#status_login').find('img').css('right', '45px');
		}
	}else{
		$('#login_page').css('display', 'block');
		$('#login_page').css('right', '130px');
		$('#status_login').css('display', 'none');
	}
}

//search word
function searchAction(){
	if(proEdit == 1){
		moveProContent();
	}
	$('#myProject_list').css('display','none');
	$('#copyReqStart').css('display','none');
	if(editMode == 1){	//편집 모드 시 검색 불가
		return;
	}
	var Skeyword = $('#srchBox').val();
	$('#search_bar').val(Skeyword);
	
	search();
	
	$('#image_list').css('display', 'none');
// 	$('#latestUpload').css('display', 'none');
// 	$('#moreViewImg').css('display', 'none');
// 	$('#image_latest_list').css('display', 'none');
	$('#image_list').next().css('display', 'none');
	
	$('#srch_page').css('display', 'block');
}

//검색어 입력
function submit1(e){
	var keycode;
	if(window.event) keycode = window.event.keyCode;
	else if(e) keycode = e.which;
	else return true;
	if(keycode == 13) {
		searchAction();
	}
}

//openAPI 팝업
function diagOpen(){
	 $('#dialog').dialog( 'open' );
}

//logout
function fnLogout(){
	if(editMode != 0){
		return;	
	}
	
	$.ajax({
		type: 'POST',
		url: "<c:url value='geoSetUserInfo.do'/>",
		data: 'typeVal=logout',
		success: function(data) {
			window.location.href='/GeoCMS';
		}
	});
}


//googleMap
function cmsLoadExif(){
	var markerCnt = 5;
	var tmpPageNum = '&nbsp;';
	var tmpTabName = editMode == 1?tempTabName:nowTabName;
	
	var Url			= baseRoot() + b_url;
	var param		= typeShape + "/" + tmpPageNum + "/" + markerCnt + "/" + tmpTabName;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			var response = data.Data;
			markDataMake(response);
		}
	});
}

function stopVideo() {
	$("#video_main_area").css("display", "none");
	$("#contentDiv").css("opacity", "0.3");
	$("#video_player0").attr("src", "");
	
// 	var parentMarker = map.getLayersByName("marker_ " + idx);
// 	addGpsMarker(parentMarker[0].markers[0].lonlat.lon, parentMarker[0].markers[0].lonlat.lat, map.getLayersByName("gps_marker_" + $("div#contentDiv #idx").val()), $("div#contentDiv #idx").val(), 0);
	
// 	var idx = $("div#contentDiv #idx").val();
	
	// 움직이고 있는 마커를 원래 위치로 옮겨놓는다.
// 	map.removeMarker(map.getLayersByName("gps_marker_" + idx)[0].markers[0]);
	
// 	var markers = new OpenLayers.Layer.Markers("gps_marker_" + idx);
// 	markers.parentId = "marker_" + idx;
// 	map.addLayer(markers);
	
// 	// 재생성할 위치 구하기.
// 	var parentMarker = map.getLayersByName("marker_ + "idx);
	
// 	addGpsMarker(parentMarker[0].markers[0].lonlat.lon, parentMarker[0].markers[0].lonlat.lat, markers, idx, 0);
	
	$("div#contentDiv #idx").val("");
}

var dataTable;

function dataTableLoad(newData) {
	if(dataTable != "") {
		dataTable.destroy();
		$("#tblDataList").children().remove();
		$("#tableName").val("");
	}
	
	var data = newData.data;
	var columnData = newData.columns;
	$("#tableName").val(newData.tableName);
	var tableNameData = newData.tableName;
	var tableSelect = tableNameData.split("_");
	var tableto = tableSelect[0];
	// dataTable columns
	var columns = new Array();
	columns.push({"title":""});
	for (var i = 0; i < columnData.length; i++) {
		var object = new Object();
		// video, photo, sensor, traj 제외
		if ($.inArray(columnData[i].column_name, allColumn) == -1) {
			if(columnData[i].column_name == "idxseq")
			{
				object.data = columnData[i].column_name;
				object.title = columnData[i].column_name;
				object.visible = "false";
			}
			object.data = columnData[i].column_name;
			object.title = columnData[i].column_name;
			columns.push(object);
		}
	}
	/* var object = new Object();
	object.title = "";
	object.width = "1.8%";
	columns.push(object);
	for(var k in keys)
	{
		var object1 = new Object();
		
		object1.data = keys[k];
		object1.title = keys[k];
		if(keys[k] == "mv" || keys[k] ==  "rn")
		{
			object1.visible = false;
		}
		
		columns.push(object1);
	} */
	
	// column 만드는 곳
	/* var columns = new Array();
	var object1 = new Object();
	
	object1.data = "id";
	object1.title = "ID";
	
	columns.push(object1);
	
	var object2 = new Object();
	
	object2.data = "trajnumber";
	object2.title = "trajnumber";
	
	columns.push(object2);
	 */
	//data 넣는 곳
	/* for (var i = 0; i < 100; i++) {
		var object = new Object();
		
		object.id = i;
		object.trajnumber = "trajnumber" + i;
		
		data.push(object);
	} */
	
	// draw
	dataTable = $('#tblDataList').DataTable({
		"processing": true,
		"paging" : false,
		"scrollY": 200,
        "scrollCollapse": true,
        "lengthChange":false,
		"serverSide": false,
		"data":data,
		"columnDefs":
		[{
			"searchable":false,
			"orderable":false,
			"className":"dt-body-center",
			"title":"<input type='checkbox' class='selectall'/>",
			"render":function (data, type, full, meta) 
			{
				return "<input type='checkbox'>";
			},
			"targets":0
		}],
		"order": [[1, "asc"]],
		"select": {
			"selector": "td:first-child"
		},
		"columns":columns,
		"initComplete": function(settings, json) {
			if(tableto == "video" || tableto == "photo")
			{
				addContextMenuOnDataTable(tableto);
			}
		 }
// 		"columns":[
// 			{"data":"id", 				"title":"ID",				"visible":true, 	"searchable":false},
// 			{"data":"trajnumber", 		"title":"trajnumber", 		"visible":true, 	"searchable":false}
// 		]
	});
	
	$(".dataTables_info").css("color", "white");
	
	$('.tblTurboList tbody').on('click', 'tr td, a', function(e)
	{
		e.stopPropagation();
		if(dataTable)
		{
			$(".dataTables_processing").css("display", "none");
			// 모든 체크 박스 해제
			//$('.tblTurboList input[type="checkbox"]').attr("checked", false);
			// 모든 선택된 행 해제
			//$('.tblTurboList tbody tr').removeClass('selected');
			//$('.tblTurboList tbody tr td').removeClass('selected_td');
			selectedRow = dataTable.row($(this).parents('tr')).data();
			selectedIdxseq = selectedRow.idxseq;
			var rowlist = new Array();
			
			var $row = $(this).closest('tr');
			var $col = $(this).closest('tr td');
			$row.addClass('selected');
			$col.addClass('selected_td');
			var ele = $row.find('input[type="checkbox"]');
			if (ele.length > 0){
				if(ele[0].checked){
					$row.addClass('selected');
					$col.addClass('selected_td');
				}
				else
				{
					$row.removeClass('selected');
					$col.removeClass('selected_td');
				}
			}
			clickRowNum(proIdx, null, selectedRow.idxseq);
		}
		else{
			var $row = $(this).closest('tr');
			var $col = $(this).closest('tr td');
			var $colAll = $row.find("td");
			var ele = $row.find('input[type="checkbox"]');
			var selectedChk = $row.attr("class").split(" ");

			if(selectedChk[1]){
				$row.removeClass('selected');
				$colAll.removeClass('selected_td');
				ele[0].checked = false;
			}else{
				$row.addClass('selected');
				$col.addClass('selected_td');
				ele[0].checked = true;
			}
		}
	});
	
	/* $('.tblTurboList tbody').on('mousedown', 'tr td, a', function(e)
	{
		if ((event.button == 2) || (event.which == 3)) {
			alert("alal");
			addContextMenuOnDataTable();
		}
	}); */
	
	function addContextMenuOnDataTable(tbName) {
		$("#jqContextMenu").css("z-index", "1005");
		$('[class$=odd]').contextMenu('context4', {
			bindings: {
				'context_view': function(t){
					openProjectViewer(proIdx, selectedIdxseq);
				},
				'context_edit': function(t){
	 				openProjectWriter(proIdx, selectedIdxseq, tbName);
	 			},
				'context_imp': function(t){
	 				if(tbName == "photo"){
	 					fnImageImport();
	 				} else {
		 				alert('이미지 레이어에서 가능한 기능입니다.');
	 				}
	 			},
				'context_exp': function(t){
	 				if(tbName == "photo"){
	 					fnImageExport();
	 				} else {
		 				alert('이미지 레이어에서 가능한 기능입니다.');
	 				}
	 			},
				'context_exp_vgg': function(t){
	 				if(tbName == "photo"){
	 					fnImageExportVgg();
	 				} else {
		 				alert('이미지 레이어에서 가능한 기능입니다.');
	 				}
	 			},
			}
		});
		$('[class$=even]').contextMenu('context4', {
			bindings: {
				'context_view': function(t){
					openProjectViewer(proIdx, selectedIdxseq);
				},
				'context_edit': function(t){
	 				openProjectWriter(proIdx, selectedIdxseq, tbName);
	 			},
				'context_imp': function(t){
	 				if(tbName == "photo"){
	 					fnImageImport();
	 				} else {
		 				alert('이미지 레이어에서 가능한 기능입니다.');
	 				}
	 			},
				'context_exp': function(t){
	 				if(tbName == "photo"){
	 					fnImageExport();
	 				} else {
		 				alert('이미지 레이어에서 가능한 기능입니다.');
	 				}
	 			},
				'context_exp_vgg': function(t){
	 				if(tbName == "photo"){
	 					fnImageExportVgg();
	 				} else {
		 				alert('이미지 레이어에서 가능한 기능입니다.');
	 				}
	 			},
			}
		});
	}
}

function fnImageImport()
{
	alert('fnImageImport');
}
function fnImageExport()
{
	if (dataTable)
	{
		var srows = dataTable.rows('.selected').data();
		if(srows && srows.length > 0)
		{
			for (var i=0; i<srows.length; i++) {
				var idx = srows[i].idx;
				var seq = srows[i].idxseq;

				var Url			= baseRoot() + "cms/getImage/";
				var param		= "one/" + loginToken + "/" + loginId + "/&nbsp/&nbsp/"+proIdx+"/&nbsp/" +seq;
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
								file_name = response.filename;
								pos = file_name.indexOf(".");
								if (pos > 0){
									file_name = file_name.substring(0, pos) + ".xml";
									$('<a href="/GeoCMS/geoImageExport.do?file_name=GeoPhoto/' + file_name + '" target="_blank"></a>')[0].click();
								}
							}
						}else{
							jAlert(data.Message, 'Info');
						}
					}
				});
			}
		}
		else
		{
			alert("데이터를 선택해주세요.");
		}
	}
}
function fnImageExportVgg()
{
	if (dataTable)
	{
		var srows = dataTable.rows('.selected').data();
		if(srows && srows.length > 0)
		{
			for (var i=0; i<srows.length; i++) {
				var idx = srows[i].idx;
				var seq = srows[i].idxseq;

				var Url			= baseRoot() + "cms/getImage/";
				var param		= "one/" + loginToken + "/" + loginId + "/&nbsp/&nbsp/"+proIdx+"/&nbsp/" +seq;
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
								file_name = response.filename;
								pos = file_name.indexOf(".");
								if (pos > 0){
									file_name = file_name.substring(0, pos) + ".xml";
									$('<a href="/GeoCMS/geoImageExportVgg.do?file_name=GeoPhoto/' + file_name + '&kind=vgg" target="_blank"></a>')[0].click();
								}
							}
						}else{
							jAlert(data.Message, 'Info');
						}
					}
				});
			}
		}
		else
		{
			alert("데이터를 선택해주세요.");
		}
	}
}


function fnRowDelete()
{
	if (dataTable)
	{
		var select_row = dataTable.row('.selected').data();
		if(select_row)
		{
			alert(select_row.idxseq);
			var deleteId = select_row.idxseq;
			var deleteUrl		= baseRoot() + "pgm/tableRowDelete/";
			var deleteparam		= proIdx +"/"+deleteId;
			var deletecallBack	= "?callback=?";
			
			$.ajax({
				type: 'POST',
				url: deleteUrl + deleteparam + deletecallBack,
				success: function(data) {
					if(data.Code == '100'){
						alert(data.Message);
						viewDataTable(proIdx);
					}
				}
			});
		}
	}
}

function viewDataTable(projectIdx)
{
	//var myUrl		= baseRoot() + "pgm/tableviewDataList/";
	var myUrl		= baseRoot() + "pgm/tableviewDataDoubleList/";
	var myparam		= projectIdx;
	var mycallBack	= "?callback=?";
	
	$.ajax({
		type: 'POST',
		url: myUrl + myparam + mycallBack,
		success: function(data) {
			dataTableLoad(data);
		}
	});
	
	/* $.ajax({
		type	: "GET"
		, url	: myUrl + myparam + mycallBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			if(data.Code == '100'){
				var result = data.Data;
				fnSetRow(data.Data);
			} else{
				jAlert(data.Message, 'Info');
			}
		}
	}); */
	
// 	$('#tblDataList').DataTable({
// 		"processing": true,
// 		"serverSide": false,
// 		"ajax": {
// 			"url": myUrl + myparam + mycallBack,
// 			"complete":function(a, b) {
// 				debugger;
// 			}
// 		},
// 		"data":data,
// 		"columns":[
// 				{"data":"id", 				"title":"ID",				"visible":true, 	"searchable":false},
// 				{"data":"trajnumber", 		"title":"trajnumber", 		"visible":true, 	"searchable":false}
// 		],
		
// 	});
	
	/* $('#tblDataList').dataTable({
        pageLength: 3,
        bPaginate: true,
        bLengthChange: true,
        lengthMenu : [ [ 3, 5, 10, -1 ], [ 3, 5, 10, "All" ] ],
        bAutoWidth: false,
        processing: true,
        ordering: true,
        serverSide: true,
        searching: true,
        ajax : {
            "url" : myUrl + myparam + mycallBack,
            "type" : "POST"
        }
        columns : [
            {data: "id"},
            {data: "trajnumber"}
        ]

    }); */

	
	/* dataTable = $("#tblDataList").DataTable({	
		"paging": false,
		"searching": false,
		"retrieve": true,
		"ajax": 
		{
			"type": "POST",
			"url": myUrl + myparam + mycallBack,
			"complete":function(jqXHR, textStatus){
				 alert("complete");
	         }
		},
		"columnDefs":
		[{
			"searchable":false,
			"orderable":false,
			"title":"<input type='checkbox' class='selectall'/>",
			"targets":0
		}],
		"columns":
		[
			{"title":"", "width":"1.8%"},
			{"data":"id",			"title":"test1", 	"visible":true,		"searchable":false},
			{"data":"trajnumber",	"title":"test2",	"visible":true,		"searchable":false}
		]
	}); */
	
	$('#tableViewDig').dialog('open');
}


/* video button start ----------------------------------- 비디오 버튼 설정 ------------------------------------- */

var videoLoding = 0;
function vidplay() {
	
    var button = document.getElementById("play");
    if(videoLoding == 0){
    	
    	if(video_child_len == 1){
        		video0.play();
    	}else if(video_child_len > 1){
        		video2.play();
    	}
    	
//     	button.textContent = "||";
    	button.src = "<c:url value='/images/geoImg/video/video_play.png'/>";
        videoLoding = 1;
    }else{
    	
    	if(video_child_len == 1){
    		video0.pause();
    	}else if(video_child_len > 1){
    		video1.pause();
    		video2.pause();
    	}
    	if(video_child_len > 2){video3.pause();}
    	if(video_child_len > 3){video4.pause();}
    	
//         button.textContent = ">";
        button.src = "<c:url value='/images/geoImg/video/video_pause.png'/>";
        videoLoding = 0;
    }
 }

 function restart(reType) {
	 if(video_child_len == 1){
		 video0.currentTime = 0;
	 }else if(video_child_len > 1){
		 video1.currentTime = 0;
		 video2.currentTime = 0;
	 }
	 if(video_child_len > 2){video3.currentTime = 0;}
 	 if(video_child_len > 3){video4.currentTime = 0;}
     
     if(reType == 'first'){
    	 timeUpdateVideo();
     } else {
    	var button = document.getElementById("play");
   	 	button.src = "<c:url value='/images/geoImg/video/video_pause.png'/>";
   	 	
   	 	seekBar.value = 0;
     }
 }

 function skip(value) {
	 if(video_child_len == 1){
		 video0.currentTime += value; 
 	 }else if(video_child_len > 1){
 		 video1.currentTime += value;
 		 video2.currentTime += value;
 	 }
	 if(video_child_len > 2){video3.currentTime += value;}
	 if(video_child_len > 3){video4.currentTime += value;}
 }
 
//볼륨조절        
 function updateVolume() {
	 if(video_child_len == 1){
		 video0.volume = volumecontrol.value;
		 if (volumecontrol.value == 0) {
			 video0.muted = true;
		 } else {
			 video0.muted = false;
		 }
 	 }else if(video_child_len > 1){
 		 video1.volume = volumecontrol.value;
 		 video2.volume = volumecontrol.value;
 		if (volumecontrol.value == 0) {
			 video1.muted = true;
			 video2.muted = true;
		 } else {
			 video1.muted = false;
			 video2.muted = false;
		 }
 	 }
 	 if(video_child_len > 2){
 		 video3.volume = volumecontrol.value;
 		if (volumecontrol.value == 0) {
 			video3.muted = true;
 		} else {
 			video3.muted = false;
 		}
 	 }
 	 if(video_child_len > 3){
 		 video4.volume = volumecontrol.value;
 		if (volumecontrol.value == 0) {
 			video4.muted = true;
 		} else {
 			video4.muted = false;
 		}
 	 }
 	 
 	 if (volumecontrol.value > 0 && sound.src.indexOf("video_mute.png") > -1) {
 		sound.src = "<c:url value='/images/geoImg/video/video_sound.png'/>";
 	 } else if (volumecontrol.value == 0) {
 		sound.src = "<c:url value='/images/geoImg/video/video_mute.png'/>";
 	 }
 }
 
//음소거
 var muteVol = 0;
  function mute(){
 	if (sound.src.indexOf("video_mute.png") > -1) {
 		if(video_child_len == 1){
 			 video0.muted = false;
 	 	 }else if(video_child_len > 1){
 	 		 video1.muted = false;
 	 		 video2.muted = false;
 	 	 }
 	 	 if(video_child_len > 2){video3.muted = false;}
 	 	 if(video_child_len > 3){video4.muted = false;}
 	 	 
 	 	volumecontrol.value = muteVol;
 	 	sound.src = "<c:url value='/images/geoImg/video/video_sound.png'/>";
 	} else {
 		muteVol = volumecontrol.value;
 		if(video_child_len == 1){
 			 video0.muted = true;
 	 	 }else if(video_child_len > 1){
 	 		 video1.muted = true;
 	 		 video2.muted = true;
 	 	 }
 	 	 if(video_child_len > 2){video3.muted = true;}
 	 	 if(video_child_len > 3){video4.muted = true;}
 	 	volumecontrol.value = 0;
 	 	sound.src = "<c:url value='/images/geoImg/video/video_mute.png'/>";
 	}
  }
 
 function timeUpdateVideo(){
     var mainVideo;
     var resdu = 0;
     
     var du1 = 0;
     var videoObject = new Object();
     
     if(video_child_len == 1){
    	 du1 = parseInt(video0.duration);
    	 videoObject.video = video0;
    	 mainVideo = video0;
 	 }else if(video_child_len > 1){
 		 du1 = parseInt(video1.duration);
 		 videoObject.video = video1;
 		 mainVideo = video1;
 	 }
     videoObject.duration = du1;
     resdu = du1;
     
     var tmpObjArr = new Array();
     tmpObjArr.push(videoObject);
     
     if(video_child_len > 1){
    	 var tmpDu = parseInt(video2.duration);
    	 videoObject = new Object();
         videoObject.duration = tmpDu;
         videoObject.video = video2;
    	 tmpObjArr.push(videoObject);
     }
     if(video_child_len > 2){
    	 var tmpDu = parseInt(video3.duration);
    	 videoObject = new Object();
         videoObject.duration = tmpDu;
         videoObject.video = video3;
    	 tmpObjArr.push(videoObject);
     }
     if(video_child_len > 3){
    	 var tmpDu = parseInt(video4.duration);
    	 videoObject = new Object();
         videoObject.duration = tmpDu;
         videoObject.video = video4;
    	 tmpObjArr.push(videoObject);
     }
     
     if(tmpObjArr != null && tmpObjArr.length > 1){
    	 for(k=1;k<tmpObjArr.length;k++){
        	 if(tmpObjArr[k].duration > resdu){
        		 resdu = tmpObjArr[k].duration;
        		 mainVideo = tmpObjArr[k].video;
        	 }
         }
     }
	
	 var seekBar = document.getElementById("seekBar");
	 seekBar.addEventListener("mousedown", function(e){
// 	     if(video_child_len == 1){
// 	    	 video0.pause();
// 	 	 }else if(video_child_len > 1){
// 	 		 video1.pause();
// 	 		 video2.pause();
// 	 	 }
// 	 	 if(video_child_len > 2){video3.pause();}
// 	 	 if(video_child_len > 3){video4.pause();}
	 });
	
	 seekBar.addEventListener("mouseup", function(e){
		var vTime = parseInt(mainVideo.duration * (this.value / 100), 10);
		if(video_child_len == 1){
			video0.currentTime = vTime;
	 	}else if(video_child_len > 1){
	 		video1.currentTime = vTime;
	 	}
	     
	    if(video_child_len > 1){
	    	if(vTime > video2.dutation){
	    		video2.currentTime = video2.dutation;
	    	}else{
	    		video2.currentTime = vTime;
	    	}
	    }
	    if(video_child_len > 2){
	    	if(vTime > video3.dutation){
	    		video3.currentTime = video3.dutation;
	    	}else{
	    		video3.currentTime = vTime;
	    	}
	    }
	    if(video_child_len > 3){
	    	if(vTime > video4.dutation){
	    		video4.currentTime = video4.dutation;
	    	}else{
	    		video4.currentTime = vTime;
	    	}
	    }
	     
// 	    vidplay();
	 });
	 
	 mainVideo.addEventListener("timeupdate", function(){
		 seekBar.value = (100 / mainVideo.duration) * mainVideo.currentTime;
	     timeUpdate(parseInt(this.currentTime), parseInt(this.duration));
	     if (this.currentTime == this.duration) {
	    	 var button = document.getElementById("play");
	    	 button.src = "<c:url value='/images/geoImg/video/video_pause.png'/>";
	     }
	 });
 }


</script>

</head>
<body bgcolor="#FFF" id="mainBody" oncontextmenu="return false;">

	<!-- allfor 통합 UI -->
	<div class="navbar-header">
        <div class = "top-header"><label style="color:white;">GeoCMS</label></div>
       <!--  <div class = "row-btn" onclick = "allforLoad();">
        	Show In 3D Map
        </div> -->
        <%-- <img  src="<c:url value='/images/geoImg/LX_Logo.png'/>"> --%>
        <img  src="<c:url value='/images/geoImg/logo.jpg'/>">
    </div>
	
<!-- 	<input type="text" id="aesText" style="width:100px;height: 30px;"> -->
<!-- 	<button id="aesBtn" onclick="getAes('A');">AES BTN</button> -->
<!-- 	<button id="aesBtn" onclick="getAes('D');">DES BTN</button> -->
	<!-- 상단 메뉴 -->
<!-- 	<div id="navbarMenu" style="float: right;height: 60px; min-width: 17px; z-index: 50; background: white; position: relative; margin:10px; width:240px; left:393%; top:-92px;"> -->
	<div id="navbarMenu" style="float: right;height: 60px; z-index: 50; position: relative; margin:10px; width: 170px;">
		<select id="mapSelect" style="margin-top: 2px; width: 170px; font-family: 'noto_r'; float: right;">
			<option value=""></option>
			<option value="OSM">Open Street Map</option>
			<option value="VW">V World(국토교통부)</option>
		</select>
		<select id="mapModeChange" style="margin-top: 2px; width: 100px; display: none; font-family: 'noto_r'; float: right;">
			<option value="0">2D 지도</option>
			<option value="1">2D 영상</option>
		</select>
		<div id="status_login" style="display:none;">
				<!-- user -->
				<div id="userId" style="height:30px; position:absolute; top:-38px;color: white; font-size:15px; right:435px;"></div>
				<!-- logout -->
				<%-- <img id="statusLogout" src="<c:url value='/images/geoImg/main_images/logout.png'/>" style="position:absolute; right:269px; top: 50px; width:50px; height:24px; cursor:pointer;" onclick="fnLogout();"/> --%>
				<div id="statusLogout" onclick="fnLogout();" style="position: absolute;right: 165px;top: -37px;width: 50px;height: 24px;background: black;color: white;cursor: pointer;">LOGOUT</div>
			</div>
			<div id="login_page" style="position:relative; right:0px; top:-100px; display:none; width: 100%;">
				<jsp:include page="sub/user/login.jsp"/>
			</div>
	</div>
	
	<!-- <div style="height: 100px; float: left; max-width: 390px;">
		<div id="navbarMenu" style="float: right;height: 60px; min-width: 17px; z-index: 50; background: white; position: relative; margin:10px; width:240px; left:393%; top:-92px;">
			<select id="mapSelect" style="margin-top: 2px; width: 170px; font-family: 'noto_r';">
				<option value=""></option>
				<option value="OSM">Open Street Map</option>
				<option value="VW">V World(국토교통부)</option>
			</select>
			<select id="mapModeChange" style="margin-top: 2px; width: 100px; display: none; font-family: 'noto_r';">
				<option value="0">2D 지도</option>
				<option value="1">2D 영상</option>
			</select>
		</div>
	</div> -->
	
		<%-- <div id="menus" style="width:100%;height:90px; min-width: 1500px; z-index:50; top:10px; left:10px; border-radius:10px;">
		
		</div>
		<div id="navbarMenu" style="float: right;height: 60px; min-width: 17px; z-index: 50; background: white; position: relative; margin:10px; width:240px; left:393%; top:-92px;">
			<div id="topMenu" style="height: 60px; float: left; width:100%;"></div>
			<select id="mapSelect" style="margin-top: 2px; width: 170px; font-family: 'noto_r';">
				<option value=""></option>
				<option value="OSM">Open Street Map</option>
				<option value="VW">V World(국토교통부)</option>
			</select>
			<select id="mapModeChange" style="margin-top: 2px; width: 100px; display: none; font-family: 'noto_r';">
				<option value="0">2D 지도</option>
				<option value="1">2D 영상</option>
			</select>
			<div id="status_login" style="display:none;">
				<!-- user -->
				<div id="userId" style="height:30px; position:absolute; top:50px;color: blue; right:345px;"></div>
				<!-- logout -->
				<img id="statusLogout" src="<c:url value='/images/geoImg/main_images/logout.png'/>" style="position:absolute; right:269px; top: 50px; width:50px; height:24px; cursor:pointer;" onclick="fnLogout();"/>
			</div>
			<div id="login_page" style="position:relative; right:0px; top:-100px; display:none; width: 100%;">
				<jsp:include page="sub/user/login.jsp"/>
			</div>
		</div>
		
		<div id="queryMenu" style="float: right;height: 56px; min-width: 17px; z-index: 50; background: white; position: relative; margin:9px; width:58px; left:98%; top:-87px;">
			<div id="topMenu" style="height: 100px; float: left; width:100%;">
				<img id="queryExecute" src="<c:url value='/images/geoImg/main_images/execute_query.png'/>" style="position:absolute;  height:56px; cursor:pointer;" onclick="queryExecute();"/>
			</div>
		</div>
	</div> --%>
	<!-- login -->
	
	<!-- map -->
	<div id="image_map" style="width: 99%; height:92.7%; position:absolute; background-color: #EAEAEA; z-index: 10; border:9.5px solid black;">
		<jsp:include page="sub/map/image_openlayers_new.jsp"/>
<%-- 		<jsp:include page="sub/map/image_openlayers.jsp"/> --%>
<%-- 		<jsp:include page="sub/map/image_googlemap_vWorld.jsp"/> --%>
<%-- 		<jsp:include page="sub/map/image_googlemap.jsp"/> --%>
	</div>
	
	<!-- left list table -->
	<div id="image_list" style="width:420px; top:100px; position:absolute; z-index: 1; display: none;">
		<jsp:include page="image_content_list.jsp"/>
	</div>
	
	<!-- my contents table -->
	<div id="myContent_list" style="width: 420px; height:800px; position: absolute; top: 100px; display: none; z-index: 490; background-color:white;">
		<jsp:include page="sub/contents/myContents.jsp"/>
	</div>
	
	<!-- my projects table -->
	<div id="myProject_list" style="width: 330px; height: 80%; padding-bottom: 20px; overflow-x: hidden; overflow-y:auto; position: absolute; top: 59px; display: block; z-index: 490; background-color:rgba(0, 0, 0, 0.8); left: 10px; color:white;">
<!-- 	<div id="myProject_list" style="width: 430px; height:90%; position: absolute; top: 70px; z-index: 490; background-color:rgba(255, 255, 255, 0.8); left: 10px;"> -->
		<jsp:include page="sub/project/myProjects_new.jsp"/>
<%-- 		<jsp:include page="sub/project/myProjects_ol.jsp"/> --%>
<%-- 		<jsp:include page="sub/project/myProjects.jsp"/> --%>
	</div>
	<%-- <div id="queryMenu" style="float:left; height: 56px; min-width: 17px; z-index: 50; background: white; position: relative; margin:9px; width:58px; left:18%;">
		<div id="topMenu" style="height: 100px; float: left; width:100%;">
			<img id="queryExecute" src="<c:url value='/images/geoImg/main_images/execute_query.png'/>" style="position:absolute;  height:56px; cursor:pointer;" onclick="analysisProject();"/>
		</div>
	</div>	 --%>
	
	<div id="contentDiv" style="float: right; height: 560px; min-width: 800px; z-index: 50; background: white; position: absolute; margin:10px; width:240px; right:0px; bottom:0px; border: none; display:none;">
		<iframe id="ifrmVideo" src="" style="border:none;" width="100%" height="100%"></iframe>
	</div>
	
	<!-- more view -->
<%-- 	<img src="<c:url value='/images/geoImg/btn_image/more_list.png'/>" id="moreViewImg" style="position:absolute; left:390px; top: 143px; width:20px; height:20px;z-index:1" onclick="moreListView(1,'','');"> --%>
	
	<!-- latest upload -->
	<img src="<c:url value='/images/geoImg/english_images/title_01.gif'/>" style="position:absolute; left:20px; top: 465px;" id="latestUpload"/>
<!-- 	<div id="image_latest_list" style="position:absolute; top:480px; left:12px; display:block; z-index: 0"> -->
<!-- 		<table border=0 id="left_list_table_2" style="margin-left: 10px;"> -->
<!-- 			<tbody> -->
<!-- 			</tbody> -->
<!-- 		</table> -->
<!-- 	</div> -->
	
	<div id="srch_page" style="display: none;">
		<jsp:include page="search_page.jsp"/>
	</div>
	<div id="make_contents" style="position:absolute; left:250px; top:430px; z-index:1;">
		<jsp:include page="sub/contents/make_contents.jsp"/>
	</div>
	<div id="edit_start_page" style="display: none;">
		<jsp:include page="sub/edit/edit_start_page.jsp"/>
	</div>
	<div id="footer" style="position:absolute; width:100%; height:40px; top:869px; z-index:2; min-width: 1500px; display:none; /* background-color:#EAEAEA; */ ">
		<jsp:include page="footer.jsp"/>
	</div>
	
	<div id="dialog" title="Open API" style="display:none;">
  		<img src="<c:url value='/images/geoImg/APIcontent2.jpg'/>">
	</div>
	
	<div style="display: none;">
		<jsp:include page="sub/moreList/board_list.jsp"></jsp:include>
	</div>
	
	<div style="display: none;">
		<jsp:include page="sub/moreList/content_list.jsp"></jsp:include>
	</div>
	
	
	
	<!-- server dialog -->
	<!-- <div id="serverDig">
		<div>
			<label style="display: block; height: 30px; font-size: 16px; float: left; width: 200px; font-weight: bold;">FILE SAVE URL</label>
			<button id="serverAddBtn" onclick="serverAdd();" style="width: 50px; float: right; border-radius: 2px; border: none; padding: 5px 10px; display: inline-block; background: #297ACC; color: white;">ADD</button>
		</div>
		<div style="font-size: 15px;" id="serverDiv">
		</div>
		<div style="text-align: center; margin-top: 15px;" id="serverBtnArea">
			<button style="border-radius: 2px;margin: 7px; border: none; font-size: 14px;padding: 9px 15px; display: inline-block; background:#297ACC; color:white;" onclick="serverSettingSave();">SAVE</button>
			<button style="border-radius: 2px;margin: 7px; border: none; font-size: 14px;padding: 9px 15px; display: inline-block; background:#6E778A; color:white;" onclick="serverCencle();">CANCEL</button>
		</div>
	</div> -->
	
	<!-- <div id="searchOptionDiv" style="width:418px; position:absolute; top:100px; border:1px solid black; display: none; z-index: 999;">
		<table style='width:100%;' >
		
			<tr bgcolor='#293B5A' style="border-bottom: 1px solid #293B5A;">
				<td align='left' colspan='2' style="height:50px;">
					<label style='font-size:15px; color:white; font-weight:bold;'><b style="font-size:18px; font-weight:bold;">Search Option</b></label>&nbsp;
					<span onclick="viewSearchOption('off');" style="width: 50px; color:white; float: right; vertical-align: middle; cursor: pointer; font-size:25px; font-weight:bold;">∧</span>
				</td>
			</tr>
			<tr bgcolor='#293B5A'>
				<td align='center' width=80><label style='color:white; font-size:12px;'><b>Search</b></label></td>
				<td>
					<div style="float:left;"><input type="checkbox" id="search_board" checked onclick="changeSearchKind();"/><label style="color:#000; font-size:12px;">Board</label></div>
					<div style="float:left;"><input type="checkbox" id="search_image" checked onclick="changeSearchKind();"/><label style="color:white; font-size:12px;">Image</label></div>
					<div style="float:left;"><input type="checkbox" id="search_video" checked onclick="changeSearchKind();"/><label style="color:white; font-size:12px;">Video</label></div>
				</td>
			</tr>
			<tr bgcolor='#293B5A'>
				<td align='center' width=70><label style='color:white; font-size:12px;'><b>Target</b></label></td>
				<td><input type="checkbox" name="search_check1" checked/><label style="color:white; font-size:12px;">Title/Content</label>
					<input type="checkbox" name="search_check2" checked/><label style="color:white; font-size:12px;">Annotation</label></td>
			</tr>
			<tr bgcolor='#293B5A'>
				<td align='center' width=70><label style='color:white; font-size:12px;'><b>Display</b></label></td>
				<td>&nbsp;&nbsp;&nbsp;<label style="color:white; font-size:12px;">Limit result count</label>
					<input id='display' type='text' value='100' style='width:30px;'></input></td>
			</tr>
		</table>
	</div> -->
</body>

</html>