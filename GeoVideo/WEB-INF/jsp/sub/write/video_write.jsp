<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<jsp:include page="../../page_common.jsp"></jsp:include>

<%
String file_url = request.getParameter("file_url");
String idx = request.getParameter("idx");
String loginToken = request.getParameter("loginToken");
String loginId = request.getParameter("loginId");
String projectBoard = request.getParameter("projectBoard");
String editUserYN = request.getParameter("editUserYN");
String flag = request.getParameter("flag");

String map = request.getParameter("map");
String mapMode = request.getParameter("mapMode");

String linkType = request.getParameter("linkType");	//project User id
String urlData = request.getParameter("urlData");	//url data
%>
<style type="text/css">
img {
	cursor: pointer;
}
.menuIcon:hover{
background-color: rgb(45, 120, 197);
}

.selectExifTabTitle{
	color:blue;
	border-top: 1px solid #d1d1d1;
	border-bottom: none;
/* 	border-left: 1px solid #d1d1d1; */
	border-right: 1px solid #d1d1d1;
	font-weight: bold;
	cursor: pointer;
}

.noSlectExifTabTitle{
	color:#555555;
	background-color : #fafafa;
	border-top: none;
	border-bottom: 1px solid #ebebeb;
	border-left: none;
	border-right: 1px solid #ebebeb;
	font-weight: bold;
	cursor: pointer;
}

.selectExifTabChild{
	display:block;
	font-weight: bold;
	font-size:13px;
}

.noSelectExifTabChild{
	display:none;
}

/* 20181122 강대훈 작업 */

/* 버튼 스타일 */
.smallWhiteBtn {
	border: 1px solid;
	border-color : #b3b3b3;
	border-radius : 3px;
	font-size: 12px;
	padding: 3px 15px; 
	background-color : white;
	color: #656565;
	cursor: pointer;
	text-align: center;
	height: 30px;
}

.smallBlueBtn {
	border: 1px solid;
	border-color : #297acc;
	border-radius : 3px;
	font-size: 12px;
	padding: 3px 15px; 
	background-color : #297acc;
	color: white;
	cursor: pointer;
	text-align: center;
	height: 30px;
}

.smallGreyBtn {
	border: 1px solid;
	border-color : #6e778a;
	border-radius : 3px;
	font-size: 12px;
	padding: 3px 15px; 
	background-color : #6e778a;
	color: white;
	cursor: pointer;
	text-align: center;
	height: 30px;
}

.smallWhiteActiveBtn {
	border: 1px solid;
	border-color : #b3b3b3;
	border-radius : 3px;
	font-size: 12px;
	padding: 3px 15px; 
	background-color : white;
	color: #297acc;
	cursor: pointer;
	text-align: center;
	height: 30px;
}
/* 버튼 스타일 끝 */

/* 뷰어 스타일 */

.activeControlArea {
	background-color: #1e2b41;
	height : 200px;
}

.imgMoveBtn {
	width: 35px;
	height: 110px;
	background-color: #394458;
	float: left;
	color : #9ca2ac;
	font-size: 20pt;
	font-weight: bolder;
	margin-top: 10px;
	cursor: pointer;
}

.imgMoveBtnImg {
	margin-top: 40px;
}

.imageSlideBar {
	width: 90%;
	height: 100%;
	float: left;
}

.imgMoveArea {
	width:90%; 
	height:75%; 
	display:block; 
	overflow-y:hidden;
	margin-left : 75px;
}

.rightArea {
	float: left; 
	width: 27.5%; 
	height: 100%;
	background-color: white;
	color: #333333;
}

.infoTabs {
	height: 30px;
/* 	width: 120px; */
	width: 33%;
/* 	float: left;  */
	font-size: 13px; 
	text-align: center;
}

.moveAreaBar{
	width: 1%;
	height: 100%;
	background-color: #f5f5f5;
	float: left;
	cursor: e-resize;
	border-color: #b3b3b3;
	border-width : 0px 1px 0px 1px;
	border-style: solid;
}

.titleLabel {
	float:left;
	font-size: 10pt;
	color : white;
}

.normalTextInput {
	border: #d1d1d1 1px solid;
	color : #656565;
	font-size: 9pt;
	width: 100%;
}

.tableLabel {
	color : #333333;
	font-size: 9pt;
}

.editorSideBar tr{
/* 	border-bottom: 1px solid; */
/* 	border-color: #131b2a; */
}

.editor_side_btn {
	cursor : pointer;
	margin : auto;
	margin-top: 5px;
}

.menuIcon {
	padding-top: 5px;
	cursor: pointer;
}

.menuIconText {
	font-size: 8pt;
	color: white;
	text-align: center;
	margin-top: 10px;
}

.btn_td {
	height: 80px;
	width: 100%;
}

.writer_btn_class {
	height: 60px;
	background-color: white;
}
/* 20181122 강대훈 작업 끝*/

/* 재생 바 스타일 */
#seekBar {
  height: 27px;
  -webkit-appearance: none;
  margin: 10px 0;
  width: 100%;
}
#seekBar:focus {
  outline: none;
}
#seekBar::-webkit-slider-runnable-track {
  width: 100%;
  height: 7px;
  cursor: pointer;
  animate: 0.2s;
  box-shadow: 0px 0px 0px #000000;
  background: #FFFFFF;
  border-radius: 5px;
  border: 1px solid #B0B0B0;
}
#seekBar::-webkit-slider-thumb {
  box-shadow: 0px 0px 0px #000000;
  border: 1px solid #1F1F1F;
  height: 20px;
  width: 20px;
  border-radius: 10px;
  background: #1F1F1F;
  cursor: pointer;
  -webkit-appearance: none;
  margin-top: -7.5px;
}
#seekBar:focus::-webkit-slider-runnable-track {
  background: #FFFFFF;
}
#seekBar::-moz-range-track {
  width: 100%;
  height: 7px;
  cursor: pointer;
  animate: 0.2s;
  box-shadow: 0px 0px 0px #000000;
  background: #FFFFFF;
  border-radius: 5px;
  border: 1px solid #B0B0B0;
}
#seekBar::-moz-range-thumb {
  box-shadow: 0px 0px 0px #000000;
  border: 1px solid #1F1F1F;
  height: 20px;
  width: 20px;
  border-radius: 10px;
  background: #1F1F1F;
  cursor: pointer;
}
#seekBar::-ms-track {
  width: 100%;
  height: 7px;
  cursor: pointer;
  animate: 0.2s;
  background: transparent;
  border-color: transparent;
  color: transparent;
}
#seekBar::-ms-fill-lower {
  background: #FFFFFF;
  border: 1px solid #B0B0B0;
  border-radius: 10px;
  box-shadow: 0px 0px 0px #000000;
}
#seekBar::-ms-fill-upper {
  background: #FFFFFF;
  border: 1px solid #B0B0B0;
  border-radius: 10px;
  box-shadow: 0px 0px 0px #000000;
}
#seekBar::-ms-thumb {
  margin-top: 1px;
  box-shadow: 0px 0px 0px #000000;
  border: 1px solid #1F1F1F;
  height: 20px;
  width: 20px;
  border-radius: 10px;
  background: #1F1F1F;
  cursor: pointer;
}
#seekBar:focus::-ms-fill-lower {
  background: #FFFFFF;
}
#seekBar:focus::-ms-fill-upper {
  background: #FFFFFF;
}

#volumecontrol {
  height: 17px;
  -webkit-appearance: none;
  margin: 10px 0;
  width: 100%;
}
#volumecontrol:focus {
  outline: none;
}
#volumecontrol::-webkit-slider-runnable-track {
  width: 100%;
  height: 2px;
  cursor: pointer;
  animate: 0.2s;
  box-shadow: 0px 0px 0px #000000;
  background: #FFFFFF;
  border-radius: 0px;
  border: 1px solid #030303;
}
#volumecontrol::-webkit-slider-thumb {
  box-shadow: 0px 0px 0px #000000;
  border: 1px solid #000000;
  height: 10px;
  width: 5px;
  border-radius: 0px;
  background: #000000;
  cursor: pointer;
  -webkit-appearance: none;
  margin-top: -5px;
}
#volumecontrol:focus::-webkit-slider-runnable-track {
  background: #FFFFFF;
}
#volumecontrol::-moz-range-track {
  width: 100%;
  height: 2px;
  cursor: pointer;
  animate: 0.2s;
  box-shadow: 0px 0px 0px #000000;
  background: #FFFFFF;
  border-radius: 0px;
  border: 1px solid #030303;
}
#volumecontrol::-moz-range-thumb {
  box-shadow: 0px 0px 0px #000000;
  border: 1px solid #000000;
  height: 10px;
  width: 5px;
  border-radius: 0px;
  background: #000000;
  cursor: pointer;
}
#volumecontrol::-ms-track {
  width: 100%;
  height: 2px;
  cursor: pointer;
  animate: 0.2s;
  background: transparent;
  border-color: transparent;
  color: transparent;
}
#volumecontrol::-ms-fill-lower {
  background: #FFFFFF;
  border: 1px solid #030303;
  border-radius: 0px;
  box-shadow: 0px 0px 0px #000000;
}
#volumecontrol::-ms-fill-upper {
  background: #FFFFFF;
  border: 1px solid #030303;
  border-radius: 0px;
  box-shadow: 0px 0px 0px #000000;
}
#volumecontrol::-ms-thumb {
  margin-top: 1px;
  box-shadow: 0px 0px 0px #000000;
  border: 1px solid #000000;
  height: 10px;
  width: 5px;
  border-radius: 0px;
  background: #000000;
  cursor: pointer;
}
#volumecontrol:focus::-ms-fill-lower {
  background: #FFFFFF;
}
#volumecontrol:focus::-ms-fill-upper {
  background: #FFFFFF;
}
</style>
<script type="text/javascript">

/* init_start ----- 초기 설정 ------------------------------------------------------------ */
var map = '<%= map %>';
var mapMode = '<%= mapMode %>';

var idx = '<%= idx %>';
var loginToken = '<%= loginToken %>';
var loginId = '<%= loginId %>';
var projectBoard = '<%= projectBoard %>';
var editUserYN = '<%= editUserYN %>';
var flag = '<%= flag %>';

var linkType = '<%= linkType %>';			//link type
var urlData = '<%= urlData %>';			//url data
var copyUserId = '';
var copyUrlIdx = 0;

// var nowSelTab;
var nowShareType;
var oldShareUserLen = 0;

var file_url = '<%= file_url %>';
var base_url = '';
var upload_url = '';
var icon_css = ' style="width: 25px; height: 25px; margin: 3px; cursor:pointer;" ';

var video_child_len = 1;
var video0 = document.getElementById("video_player0");
var video1 = document.getElementById("video_player1");
var video2 = document.getElementById("video_player2");
var video3 = document.getElementById("video_player3");
var video4 = document.getElementById("video_player4");

var dMarkerLat = 0;		//default marker latitude
var dMarkerLng = 0;		//default marker longitude
var dMapZoom = 10;		//default map zoom

var imageSelectMode = 0;
var imageMoveMode = 0;
var nowX = 0;
var nowY = 0;
var marginImgL = 0;
var marginImgT = 0;

$(function() {
	if(urlData != null && urlData != '' && linkType != null && linkType == 'CP4'){
		getCopyUrlDecode();
	}
	
	//marginImgL = $('#video_main_area').css('left');
	//marginImgL = parseInt(marginImgL.replace('px','')) + 2;
	//marginImgT = $('#video_main_area').css('top');
	//marginImgT = parseInt(marginImgT.replace('px','')) + 2;
	
	$('.menuIcon img').hover(function(){
// 		$(this).parent().css('border-left','1px solid #6d808f');
// 		$(this).parent().css('border-top','1px solid #6d808f');
	},function(){
		$('.menuIcon').css('border','none');
	});
	
	//프레임 라인 설정
	$('.frame_plus').button({ icons: { primary: 'ui-icon-plusthick'}, text: false });
	$('.frame_minus').button({ icons: { primary: 'ui-icon-minusthick'}, text: false });

	//프레임 가이드 zindex 설정
	$('#video_guide').maxZIndex({inc:1});
	//지도 zindex 설정
	$('#video_map_area').maxZIndex({inc:1});
	
	$('html').mousemove(function(e) {
		var container = $('#video_main_area');
		if(container.has(e.target).length == 0){
			imageSelectMode = 0;
		}
	});
	
	$('#video_main_area').mousemove(function(event){
		var regX = /^pc|^pb|^i\d/;
		var testRes = regX.test(event.target.id);
		if(testRes && imageSelectMode == 1){
			imageMoveMode = 1;
		}
		
		if(imageSelectMode == 1 && imageMoveMode == 0){
			var x = event.pageX;
			var y = event.pageY;
			
			var tmpX = x - nowX;
			var tmpY = y - nowY;
			
			nowX = x;
			nowY = y;
			
			var tmpLeft = $('#video_main_area').css("left").replace('px','');
			var tmptop = $('#video_main_area').css("top").replace('px','');
			
			var tmpML = Number(tmpLeft) + Number(tmpX);
			var tmpMT = Number(tmptop) + Number(tmpY);
			if(tmpML > 0){
				tmpML = 0;
				$('.viewerMoreR').css('display','block');
				$('.viewerMoreL').css('display','none');
			}else if(-(imgWidth - $('#image_main_area').width()) > tmpML){
				tmpML = -(imgWidth - $('#image_main_area').width());
				$('.viewerMoreR').css('display','none');
				$('.viewerMoreL').css('display','block');
			}else{
				$('.viewerMoreR').css('display','block');
				$('.viewerMoreL').css('display','block');
			}
			
			if(tmpMT > 0){
				tmpMT = 0;
			}else if(-(imgHeight - $('#image_main_area').height()) > tmpMT){
				tmpMT = -(imgHeight - $('#image_main_area').height());
			}
			
			$('#video_main_area').css("left", tmpML +'px');
			$('#video_main_area').css("top", tmpMT + 'px');
			
		}
		event.preventDefault();
	});
	
	$('#video_main_area').mouseup(function(event){
		if(imageSelectMode == 1){
			imageSelectMode = 0;
		}
		if(bubbleTextArea == 1){
			createBubble();
		}else if(bubbleTextArea == 2){
			replaceBubble(bubbleTextAreaId);
		}
		
		event.preventDefault();
		if($('.ui-button').css('display') != 'inline-block'){
			imageMoveMode = 0;
		}
	});
	
});

// $(document).ready(function(){
// 	if(flag == "3")
// 	{
// 		this.close();
// 		saveVideoWrite1(3);
// 	}
// });
/* $(window).load(function(){
	if(flag == "3")
	{
		this.close();
		saveVideoWrite1(3);
	}
}); */

function getOneVideoData(){
	var Url = '';
	var param = '';
	var callBack = '';
	if(urlData != null && urlData != '' && linkType != null && linkType == 'CP4'){
		idx = copyUrlIdx;
		loginId = copyUserId;
		Url			= baseRoot() + "cms/getCopyDataUrl/";
		param		= "VIDEOONE/" + linkType + "/" + file_url + "/" +idx;
		callBack	= "?callback=?";
	}else{
		Url			= baseRoot() + "cms/getVideo/";
		param		= "one/" + loginToken + "/" + loginId + "/&nbsp/&nbsp/&nbsp/" +idx +"/&nbsp";
		callBack	= "?callback=?";
	}
	
	$.ajax({
		type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			if(data.Code == 100){
				var response = data.Data;
				var tmpShareList = data.shareList;
				
				if(response != null && response != ''){
					response = response[0];
					nowShareType = response.sharetype;
					
					if(response.dronetype == 'Y'){
						$('#droneTypeChk').attr('checked',true);
					}else{
						response.dronetype = 'N';
					}
					$('#title_area').val(response.title);
					$('#content_area').val(response.content);
// 					var nowShareTypeText = nowShareType == 0? '비공개':nowShareType== 1? '전체공개':'특정인 공개';
					var nowShareTypeText = nowShareType == 0? "private":nowShareType== 1? "public":"sharing with friends";
					
					$('#shareKindLabel').text(nowShareTypeText);
					
					$('#title_text').val(response.title);
					$('#content_text').val(response.content);
					$('#share_text').val(nowShareTypeText);
					$('#drone_text').val(response.dronetype);
					
					$("input[name=shareRadio][value=" + nowShareType + "]").attr("checked", true);
					
					if(tmpShareList != null && tmpShareList.length > 0){
						oldShareUserLen = tmpShareList.length;
					}
				}
			}else{
// 				jAlert(data.Message, 'Info');
			}
		}
	});
}

//초기 설정 데이터 불러오기
function getVideoBase() {
	
	var Url			= baseRoot() + "cms/getbase";
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "get"
		, url	: Url + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			if(data.Code == '100'){
				var result = data.Data;
				if(result != null && result.length > 0){
					dMarkerLat = result[0].latitude;
					dMarkerLng = result[0].longitude;
					dMapZoom = result[0].mapzoom;
					$('#openlayers').get(0).contentWindow.setDefaultData(dMarkerLat, dMarkerLng, dMapZoom);
				}
			}else{
// 				jAlert(data.Message, 'Info');
			}
		}
	});
}

//get server
function getServer(tmpFileType){
	var Url			= baseRoot() + "cms/selectServerList/";
	var param		= loginToken + "/" + loginId +"/" +"Y";
	var callBack	= "?callback=?";
	$.ajax({
		type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			var response = data.Data;
			var tmpServerId = '';
			var tmpServerPass = '';
			var tmpServerPort = '';
			
			if(data.Code == '100'){
				b_serverUrl = response[0].serverurl;
				b_serverViewPort = response[0].serverviewport;
				b_serverPath = response[0].serverpath;
				if(b_serverUrl != null && b_serverUrl != "" && b_serverUrl != undefined){
					b_serverType = "URL";
				}else{
					b_serverType = "LOCAL";
				}
				tmpServerId = response[0].serverid;
				tmpServerPass = response[0].serverpass;
				tmpServerPort = response[0].serverport;
				
			}else if(data.Code != '200'){
				b_serverPath = "upload";
				jAlert(data.Message, 'Info');
			}else{
				b_serverPath = "upload";
			}
			
			if(tmpFileType != null){
				if(tmpFileType == 'XML'){
					loadXML2(tmpServerId, tmpServerPass, tmpServerPort);
				}else if(tmpFileType == 'GPS'){
					loadGPS2(tmpServerId, tmpServerPass, tmpServerPort);
				}else if(tmpFileType == "1" || tmpFileType == "2"){
					saveVideoWrite(tmpFileType, tmpServerId, tmpServerPass, tmpServerPort);
				}
			}
		}
	});
}

function dataChangeClick(){
	bubbleTextArea = 0;
	compHide();
	$('#data_dialog').css('display','block');
}

function videoGetShareUser(){
	contentViewDialog = jQuery.FrameDialog.create({
		url:'http://'+location.host + '/GeoCMS/geoCMS/share.do?shareIdx='+ idx +'&shareKind=GeoVideo',
		width: 370,
		height: 535,
		buttons: {},
		autoOpen:false
	});
	contentViewDialog.dialog('widget').find('.ui-dialog-titlebar').remove();
	contentViewDialog.dialog('open');
}

/* init_start ----- 비디오 소스 설정 ------------------------------------- */
function videoWriteInit() {
	if(projectBoard == 1){
		base_url = 'http://'+ location.host + '/GeoCMS';
		upload_url = '/GeoVideo/';
		if(editUserYN != 1){
			//ui 
// 			$('#showInfoDiv').css('display','block');
// 			$('.menuIcon').css('width','14%');
			$('.menuIconData').css('display', 'block');
		}
		
		getOneVideoData();
		getVideoBase();
		getServer("");
	}else{
		base_url = '<c:url value="/"/>';
		upload_url = '/upload/';

// 		$('.menuIcon').each(function(idx, val){
// 			if(idx != 0){
// 				var tmpNum = 150*idx;
// 				$(this).css('left', tmpNum+'px');
// 			}
// 		});
	}
	
	//비디오 설정
	changeVideo();
	//프레임 설정
	createFrameLine(1);
	createObjLine();
	//GPX or KML 데이터 설정
// 	loadGPS();
	//XML 데이터 설정
	loadXML();
}

function changeVideo() {
	if(projectBoard == 1){
		var Url = '';
		var param = '';
		var callBack = '';
		if(urlData != null && urlData != '' && linkType != null && linkType == 'CP4'){
			Url			= baseRoot() + "cms/getCopyDataUrl/";
			param		= "VIDEO/" + linkType + "/" + file_url + "/" +idx;
			callBack	= "?callback=?";
		}else{
			Url			= baseRoot() + "cms/getContentChild/";
		 	param		= loginToken + "/" + loginId + "/" +idx;
		 	callBack	= "?callback=?";
		}
		
		$.ajax({
			type	: "get"
			, url	: Url + param + callBack
			, dataType	: "jsonp"
			, async	: false
			, cache	: false
			, success: function(data) {
				if(data.Code == 100){
					var response = data.Data;
					video_child_len = 1;
					if(response != null && response != ''){
						video_child_len = response.length;
						$('#video_player2').css('background','none');
						$('#video_player3').css('background','none');
						$('#video_player4').css('background','none');
						
						for(var k=0;k<response.length; k++){
							var tmpFileName = response[k].filename;
							
							if(video_child_len > 1 ){
								$('.multi_class').css('display','block');
								$('#video_player0').css('display','none');
								var video = document.getElementById('video_player'+(k+1));
								video.src = videoBaseUrl() + upload_url + tmpFileName;
								video.load();
							}else{
								$('.multi_class').css('display','none');
								$('#video_player0').css('display','block');
								var video = document.getElementById('video_player0');
								video.src = videoBaseUrl() + upload_url + tmpFileName;
								video.load();
							}
							
// 							var video = document.getElementById('video_player'+(k+1));
// 							video.src = videoBaseUrl() + upload_url + tmpFileName;
// 							video.load();
							
							if(k == 0){
								file_url =  response[k].filename;
								videoTime1 = response[k].fileTime;
							}
						}
						
						//좌표
						var gpsDataStr = response[0].gpsdata;
						if(gpsDataStr != null){
							gpsDataStr = gpsDataStr.gpsData
							loadGPSForData(gpsDataStr);
						}
						
						if(video_child_len > 1){
							if(video_child_len < 4){
								var tmpHtmlStr = "<div style='width:380px; height:230px;'>No video</div>";
								$('#video_player4').css('background','url("../images/geoImg/novideo.png")');
								$('#video_player4').css('board','none');
							}
							if(video_child_len < 3){
								var tmpHtmlStr = "<div style='width:380px; height:230px;'>No video</div>";
								$('#video_player3').css('background','url("../images/geoImg/novideo.png")');
								$('#video_player3').css('board','none');
							}
							if(video_child_len < 2){
								var tmpHtmlStr = "<div style='width:380px; height:230px;'>No video</div>";
								$('#video_player2').css('background','url("../images/geoImg/novideo.png")');
								$('#video_player2').css('board','none');
							}
						}
						
						video0 = document.getElementById("video_player0");
						video1 = document.getElementById("video_player1");
						video2 = document.getElementById("video_player2");
						video3 = document.getElementById("video_player3");
						video4 = document.getElementById("video_player4");
						
						setTimeout(function(){
							restart('first');
						},500);
					}
				}else{
// 					jAlert(data.Message, 'Info');
				}
			}
		});
	}else{
		//GPX or KML 데이터 설정
	 	loadGPS();
	}
}

/* map_start ----------------------------------- 맵 설정 ------------------------------------- */
var gps_size;
function loadGPS() {
	getServer('GPS');
}

function loadGPS2(tmpServerId, tmpServerPass, tmpServerPort) {
	var buf = file_url.split('.');
	var xml_file_name = buf[0] + '_modify.gpx';
	xml_file_name = upload_url + xml_file_name;
	xml_file_name = xml_file_name.substring(1);
	
	lat_arr = new Array();
	lng_arr = new Array();
	
	$.ajax({
		type: "POST",
		url: base_url + '/geoXml.do',
		data: 'file_name='+xml_file_name+'&type=load&serverType='+b_serverType+'&serverUrl='+b_serverUrl+
		'&serverPath='+b_serverPath+'&serverPort='+tmpServerPort+'&serverViewPort='+ b_serverViewPort +'&serverId='+tmpServerId+'&serverPass='+tmpServerPass,
		success: function(xml) {
			$(xml).find('trkpt').each(function(index) {
				var lat_str = $(this).attr('lat');
				var lng_str = $(this).attr('lon');
				lat_arr.push(parseFloat(lat_str));
				lng_arr.push(parseFloat(lng_str));
			});
			gps_size = lat_arr.length;
			$('#openlayers').get(0).contentWindow.setGPSData(lat_arr, lng_arr);
		},
		error: function(xhr, status, error) {
			//KML 파일 처리
			$('#openlayers').get(0).contentWindow.setCenter(0, 0, 1);
		}
	});
}

function loadGPSForData(gpsData){
// 	$('#openlayers').get(0).contentWindow.map = null;
// 	$('#openlayers').get(0).contentWindow.marker = null;
// 	$('#openlayers').get(0).contentWindow.init();
	
	var lat_arr = new Array();
	var lng_arr = new Array();
	if(gpsData != null && gpsData.length > 0 ){
		for(var i=0; i<gpsData.length;i++){
			lat_arr.push(parseFloat($.trim(gpsData[i].lat)));
			lng_arr.push(parseFloat($.trim(gpsData[i].lon)));
		}
		gps_size = lat_arr.length;
		$('#openlayers').get(0).contentWindow.setGPSData(lat_arr, lng_arr);
	}else{
		$('#openlayers').get(0).contentWindow.setCenter(0, 0, 1);
	}
}

/* frame_start ----------------------------------- 프레임 기능 설정 ------------------------------------- */
var auto_frameline_str;
var auto_frameline_num = 0;
function createFrameLine(type) {
	auto_frameline_str = 'video_frame_line' + auto_frameline_num;
	var top = auto_frameline_num * 25;
	var btn_top = 30 + top;
	var div_element = $(document.createElement('div'));
	div_element.attr('id', auto_frameline_str); div_element.attr('style', 'position:absolute; left:0px; top:'+top+'px; width:6000px; height:25px; background-image: url(<c:url value="/images/geoImg/write/timeline_frame.png"/>);');
	div_element.appendTo('#video_obj_area');
	$('.frame_plus').attr('style', 'position:absolute; left:0px; top:'+btn_top+'px; width:25px; height:25px;');
	$('.frame_minus').attr('style', 'position:absolute; left:25px; top:'+btn_top+'px; width:25px; height:25px;');
	var obj_area_height = $('#video_obj_area').css('height'); obj_area_height = obj_area_height.replace('px','');
	$('#video_obj_area').css({height: parseInt(obj_area_height) + 25});
	var video_guide_height = $('#video_guide').css('height'); video_guide_height = video_guide_height.replace('px','');
	$('#video_guide').css({height: parseInt(video_guide_height) + 25});
	if(type==2) {
		$('#video_obj_line').css({top: top+25});
	}
	auto_frameline_num++;
}
function createObjLine() {
	var top = auto_frameline_num * 25;
	var div_element = $(document.createElement('div'));
	div_element.attr('id', 'video_obj_line'); div_element.attr('style', 'position:absolute; left:0px; top:'+top+'px; width:6000px; height:25px; background-image: url(<c:url value="/images/geoImg/write/timeline_frame.png"/>);');
	div_element.appendTo('#video_obj_area');
}
function removeFrameLine() {
	if(auto_frameline_num>1) {
		auto_frameline_num--;
		var btn_top = 30 + ((auto_frameline_num-1) * 25);
		$('.frame_plus').css({top:btn_top}); $('.frame_minus').css({top:btn_top});
		$('#video_frame_line'+auto_frameline_num).remove();
		var obj_area_height = $('#video_obj_area').css('height'); obj_area_height = obj_area_height.replace('px','');
		$('#video_obj_area').css({height: parseInt(obj_area_height) - 25});
		var video_guide_height = $('#video_guide').css('height'); video_guide_height = video_guide_height.replace('px','');
		$('#video_guide').css({height: parseInt(video_guide_height) - 25});
		var top = $('#video_obj_line').css('top');
		top = top.replace('px','');
		$('#video_obj_line').css({top: parseInt(top)-25});
	}
	else {
// 		jAlert('프레임 라인을 더이상 제거할수 없습니다.', '정보');
		jAlert('The frame line can no longer be removed.', 'Info');
	}
}
function inputFrameObj(type) {
	var obj_str, obj_text;
	if(type=='caption') { obj_str = 'framec' + (auto_caption_num-1); obj_text = 'Caption'; }
	else if(type=='bubble') { obj_str = 'frameb' + (auto_bubble_num-1); obj_text = 'Bubble'; }
	else if(type=='icon') { obj_str = 'framei' + (auto_icon_num-1); obj_text = 'Icon'; }
	else if(type=='geometry') { obj_str = 'frameg' + (auto_geometry_num-1); obj_text = 'Geometry'; }
	else {}

	var top = $('#video_obj_line').css('top');
	top = top.replace('px','');
	createFrameObj(obj_str, 0, parseInt(top), 100, obj_text);
}
var frameline_obj_top;
function createFrameObj(id, left, top, width, text) {
	var div_element = $(document.createElement('div'));
	div_element.attr('id', id); div_element.attr('style', 'position:absolute; left:'+left+'px; top:'+top+'px; width:'+width+'px; height:25px; background:#CCF; text-align:left; font-size:10px; overflow:hidden; z-index:1;');
	div_element.html('ID:'+id+' Type:'+text);
	div_element.draggable({ containment:'#video_obj_area', grid:[1,25]});
	div_element.resizable({ minHeight:25, maxHeight:25, minWidth:10 });
	div_element.appendTo('#video_obj_area');
}
function timeUpdate(time, totaltime) {
	var point = time * 5;
	$('#video_guide').css({left:point});
 	visibleFrameObj(point);
	moveMap(time, totaltime);
}
function visibleFrameObj(point) {
	var objCount = $('#video_obj_area').children().size();
	for(var i=0; i<objCount; i++) {
		var frame_obj = $('#video_obj_area').children().eq(i);
		var id = frame_obj.attr('id');
		if(id.length > 5) {
			if(id.substring(0, 5)=='frame') {
				var buf1 = frame_obj.css('left');
				buf1 = buf1.replace('px','');
				var start_point = parseInt(buf1);
				var buf2 = frame_obj.css('width');
				buf2 = buf2.replace('px','');
				var end_point = parseInt(buf1) + parseInt(buf2);
				var obj = $('#'+id.substring(5, id.length));
				if(start_point <= point && point <= end_point) { obj.css({visibility:'visible'}); }
				else { obj.css({visibility:'hidden'}); }
			}
		}
	}
}

function moveMap(time, totaltime) {
// 	var ratio = time * gps_size / totaltime;
	if(gps_size > 0){
		$('#openlayers').get(0).contentWindow.moveMarker(time);
	}else{
		$('#openlayers').get(0).contentWindow.setCenter(0, 0);
	}
}

/* bubble_start ----------------------------------- 말풍선 삽입 버튼 설정 ------------------------------------- */
var bubbleTextArea = 0;
var bubbleTextAreaId = 0;
/* bubble_start ----------------------------------- 말풍선 삽입 버튼 설정 ------------------------------------- */
function inputBubble(id, text) {
	$('#bubble_font_color').attr('disabled', true);
	$('#bubble_bg_color').attr('disabled', true);
	
	if(id==0 & text=="") {
		//bubble dialog 내부 객체 초기화
		$('#bubble_font_select').val('Normal'); $('#bubble_font_color').val('#000000'); $('#bubble_font_color').css('background-color', '#000000'); $('#bubble_bg_color').val('#FFFFFF'); $('#bubble_bg_color').css('background-color', '#FFFFFF'); $('input[name=bubble_bg_checkbok]').attr('checked', true); $('#icp_bubble_bg_color').removeAttr('onclick'); $('#bubble_check').html('<input type="checkbox" id="bubble_bold" style="display:none;"/><img src="<c:url value="/images/geoImg/write/bold_off.png"/>" '+icon_css+' onclick="captionCheck(this);"><input type="checkbox" id="bubble_italic" style="display:none;" /><img src="<c:url value="/images/geoImg/write/italic_off.png"/>" '+icon_css+' onclick="captionCheck(this);"><input type="checkbox" id="bubble_underline" style="display:none;" /><img src="<c:url value="/images/geoImg/write/underLine_off.png"/>" '+icon_css+' onclick="captionCheck(this);"><input type="checkbox" id="bubble_link" style="display:none;"/><img src="<c:url value="/images/geoImg/write/hyperLink_off.png"/>" '+icon_css+' onclick="captionCheck(this);">'); $('#bubble_button').html('<button class="ui-state-default ui-corner-all" style="width:80px; height:30px; font-size:12px;" onclick="createBubble();">input</button>'); $('#bubble_text').val('');
		$('body').append('<textarea id="bubble_text" style="font-size:12px;border:solid 2px #777;position: absolute;left: 160px;top: 30px;width: 150px;height:50px;text-align:left;"></textarea>');
		$("#bubble_text").resizable({
		    maxWidth: 700,
		    minHeight: 50,
		    minWidth: 150
		});
		bubbleTextArea = 1;
	}	
	else {
		//caption dialog 내부 객체 설정
		var font_size = $('#f'+id).css('font-size');
		if(font_size == '14px') $('#bubble_font_select').val('H3');
		else if(font_size == '18px') $('#bubble_font_select').val('H2');
		else if(font_size == '22px') $('#bubble_font_select').val('H1');
		else $('#bubble_font_select').val('Normal');
		var font_color = rgb2hex($('#f'+id).css('color')); $('#bubble_font_color').val(font_color); $('#bubble_font_color').css('background-color', font_color);
		var bg_color_value = $('#p'+id).css('backgroundColor'); var bg_color = '';
		if(bg_color_value!='rgba(0, 0, 0, 0)') { bg_color = rgb2hex($('#p'+id).css('backgroundColor')); $('input[name=bubble_bg_checkbok]').attr('checked', false); }
		else { bg_color = '#FFFFFF'; $('input[name=bubble_bg_checkbok]').attr('checked', true); }
		
		$('#bubble_bg_color').val(bg_color); $('#bubble_bg_color').css('background-color', bg_color);
		
		var check_html = ""; 
		var html_text = $('#'+id).html();
		var img_kind = 'off';
		check_html += '<input type="checkbox" id="bubble_bold" style="display:none;" ';
		if(html_text.indexOf('<b id') != -1){
			check_html += ' checked="checked" ';
			img_kind = 'on';
		}
		check_html += ' /><img src="<c:url value="/images/geoImg/write/bold_'+img_kind+'.png"/>" '+icon_css+' onclick="captionCheck(this);">';
		
		img_kind = 'off';
		check_html += '<input type="checkbox" id="bubble_italic" style="display:none;"';
		if(html_text.indexOf('<i id') != -1){
			check_html += ' checked="checked" ';
			img_kind = 'on';
		}
		check_html += ' /><img src="<c:url value="/images/geoImg/write/italic_'+img_kind+'.png"/>" '+icon_css+' onclick="captionCheck(this);">';
		
		img_kind = 'off';
		check_html += '<input type="checkbox" id="bubble_underline"  style="display:none;"';
		if(html_text.indexOf('<u id') != -1){
			check_html += ' checked="checked" ';
			img_kind = 'on';
		}
		check_html += ' /><img src="<c:url value="/images/geoImg/write/underLine_'+img_kind+'.png"/>" '+icon_css+' onclick="captionCheck(this);">';
		
		img_kind = 'off';
		check_html += '<input type="checkbox" id="bubble_link" style="display:none;"';
		if(html_text.indexOf('<a href') != -1){
			check_html += ' checked="checked" ';
			img_kind = 'on';
		}
		check_html += ' /><img src="<c:url value="/images/geoImg/write/hyperLink_'+img_kind+'.png"/>" '+icon_css+' onclick="captionCheck(this);">';
		
		$('#bubble_check').html(check_html);
		var tmpMinHeight = $('#'+id).height();
		var tmpMinWidth = $('#'+id).width();
		$('body').append('<textarea id="bubble_text" style="font-size:12px;border:solid 2px #777;position: absolute;left: '+ $('#p'+id).offset().left + 'px;top: '+ $('#p'+id).offset().top + 'px;width: '+ tmpMinWidth + 'px; height:'+ tmpMinHeight +'px;"></textarea>');
		$("#bubble_text").resizable({
		    maxWidth: 700,
		    minHeight: 50,
		    minWidth: 150
		});
		$('#bubble_text').val($('#p'+id).html());
		
		bubbleTextAreaId = id;
		bubbleTextArea = 2;
	}
	compHide();
	document.getElementById('bubble_dialog').style.display='block';
}

function checkBubble() {
	if(!$('input[name=bubble_bg_checkbok]').attr('checked')) { $('#icp_bubble_bg_color').bind('click', function() { iColorShow('bubble_bg_color','icp_bubble_bg_color'); }); }
	else { $('#icp_bubble_bg_color').unbind('click'); }
}

var auto_bubble_str;
var auto_bubble_num = 0;
function createBubble() {
	auto_bubble_str = "b" + auto_bubble_num;
	var font_size = $('#bubble_font_select').val(); var font_color = $('#bubble_font_color').val(); var bg_color = $('#bubble_bg_color').val(); var bg_check = $('input[name=bubble_bg_checkbok]').attr('checked'); var bold_check = $('#bubble_bold').attr('checked'); var italic_check = $('#bubble_italic').attr('checked'); var underline_check = $('#bubble_underline').attr('checked'); var link_check = $('#bubble_link').attr('checked'); var text = $('#bubble_text').val();
	if(bg_check==true) bg_color = '';
	var html_text;
	
	//폰트, 색상 설정
	if(font_size=='H3') html_text = '<font id="f'+auto_bubble_str+'" style="font-size:14px; color:'+font_color+';"><pre id="p'+auto_bubble_str+'" style="font-size:14px;background:'+bg_color+';text-align:left;">'+text+'</pre></font>';
	else if(font_size=='H2') html_text = '<font id="f'+auto_bubble_str+'" style="font-size:18px; color:'+font_color+';"><pre id="p'+auto_bubble_str+'" style="font-size:18px;background:'+bg_color+';text-align:left;">'+text+'</pre></font>';
	else if(font_size=='H1') html_text = '<font id="f'+auto_bubble_str+'" style="font-size:22px; color:'+font_color+';"><pre id="p'+auto_bubble_str+'" style="font-size:22px;background:'+bg_color+';text-align:left;">'+text+'</pre></font>';
	else html_text = '<font id="f'+auto_bubble_str+'" style="color:'+font_color+';"><pre id="p'+auto_bubble_str+'" style="background:'+bg_color+';text-align:left;">'+text+'</pre></font>';
	//bold, italic, underline, hyperlink 설정
	if(bold_check==true) html_text = '<b id="b'+auto_bubble_str+'">'+html_text+'</b>';
	if(italic_check==true) html_text = '<i id="i'+auto_bubble_str+'">'+html_text+'</i>';
	if(underline_check==true) html_text = '<u id="u'+auto_bubble_str+'">'+html_text+'</u>';
	if(link_check==true) {
		if(html_text.indexOf('http://')== -1) html_text = '<a href="http://'+text+'" id="h'+auto_bubble_str+'" target="_blank">'+html_text+'</a>';
		else html_text = '<a href="'+text+'" id="h'+auto_bubble_str+'" target="_blank">'+html_text+'</a>';
	}
	var div_element = $(document.createElement('div'));
	div_element.attr('id', auto_bubble_str);
	div_element.attr('style', 'position:absolute; left:160px; top:30px; display:block;');
	div_element.html(html_text); 

	compHide();
	div_element.draggable(); //div_element.dblclick(function() { inputBubble(div_element.attr('id'), text); });
	if(bubbleTextArea == 1){
		bubbleTextArea = 0;
		$('#bubble_text').remove();
	}
	if(text == null || text == 'null' || text == '' || text == undefined){
		return;
	}
	
	div_element.appendTo('#video_main_area');
	auto_bubble_num++;
	$('#'+div_element.attr('id')).contextMenu('context1', {
		bindings: {
			'context_modify': function(t) { inputBubble(t.id, text); },
// 			'context_delete': function(t) { jConfirm('정말 삭제하시겠습니까?', '정보', function(type){ 	if(type) { $('#'+t.id).remove(); removeTableObject(t.id); } }); }
			'context_delete': function(t) { jConfirm('Are you sure you want to delete?', 'Info', function(type){ 	if(type) { $('#'+t.id).remove(); removeTableObject(t.id); $('#frame'+t.id).remove(); } }); }
		}
	});
	
	var data_arr = new Array();
	data_arr.push(auto_bubble_str); data_arr.push("Bubble"); data_arr.push(text);
	insertTableObject(data_arr);
	inputFrameObj('bubble');
}

function replaceBubble(id) {
	var font_size = $('#bubble_font_select').val();
	var font_color = $('#bubble_font_color').val();
	var bg_color = $('#bubble_bg_color').val();
	var bg_check = $('input[name=bubble_bg_checkbok]').attr('checked');
	var bold_check = $('#bubble_bold').attr('checked');
	var italic_check = $('#bubble_italic').attr('checked');
	var underline_check = $('#bubble_underline').attr('checked');
	var link_check = $('#bubble_link').attr('checked');
	var text = $('#bubble_text').val();
	
	if(text == null || text == 'null' || text == '' || text == undefined){
		compHide();
		$('#'+id).remove();
		if(bubbleTextArea == 2){
			bubbleTextArea = 0;
			$('#bubble_text').remove();
		}
		removeTableObject(id);
		return;
	}
	
	if(bg_check==true) bg_color = '';
	var html_text;
	//폰트, 색상 설정
	if(font_size=='H3') html_text = '<font id="f'+id+'" style="font-size:14px; color:'+font_color+';"><pre id="p'+id+'" style="font-size:14px;background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H2') html_text = '<font id="f'+id+'" style="font-size:18px; color:'+font_color+';"><pre id="p'+id+'" style="font-size:18px;background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H1') html_text = '<font id="f'+id+'" style="font-size:22px; color:'+font_color+';"><pre id="p'+id+'" style="font-size:22px;background:'+bg_color+';">'+text+'</pre></font>';
	else html_text = '<font id="f'+id+'" style="color:'+font_color+';"><pre id="p'+id+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	//bold, italic, underline, hyperlink 설정
	if(bold_check==true) html_text = '<b id="b'+id+'">'+html_text+'</b>';
	if(italic_check==true) html_text = '<i id="i'+id+'">'+html_text+'</i>';
	if(underline_check==true) html_text = '<u id="u'+id+'">'+html_text+'</u>';
	if(link_check==true) {
		if(html_text.indexOf('http://')== -1) html_text = '<a href="http://'+text+'" id="h'+id+'" target="_blank">'+html_text+'</a>';
		else html_text = '<a href="'+text+'" id="h'+id+'" target="_blank">'+html_text+'</a>';
	}
	$('#a'+id).remove(); $('#u'+id).remove(); $('#i'+id).remove(); $('#b'+id).remove(); $('#f'+id).remove(); $('#p'+id).remove();
	$('#'+id).html(html_text);
	
	compHide();
	if(bubbleTextArea == 2){
		bubbleTextArea = 0;
		$('#bubble_text').remove();
	}
	var data_arr = new Array();
	data_arr.push(id); data_arr.push("Bubble"); data_arr.push(text);
	replaceTableObject(data_arr);
}

/* icon_start ----------------------------------- 아이콘 & 이미지 삽입 버튼 설정 ------------------------------------- */
function inputIcon() {
	bubbleTextArea = 0;
	compHide();
	
	for(var i=1; i<133; i++) {
		$('#icon_img'+i).attr('src', '<c:url value="/images/geoImg/icon/newBlack/d'+i+'.png"/>');
		$('#icon_img'+i).css('height', '23px');
		$('#icon_img'+i).css('width', '23px');
		$('#icon_img'+i).css('padding', '2px');
		
// 		$('#icon_img'+i).unbind('mouseover');
// 		$('#icon_img'+i).bind('mouseover', function() {
// 			var buf = this.id.split('icon_img');
// 			$('#'+this.id).css("border", "1px solid gray");
// 			$('#'+this.id).attr('src', '<c:url value="/images/geoImg/icon/white/d'+buf[1]+'_over.png"/>');
// 		});
		$('#icon_img'+i).unbind('mouseout');
		$('#icon_img'+i).bind('mouseout', function() {
			var buf = this.id.split('icon_img');
			$('#'+this.id).attr('src', '<c:url value="/images/geoImg/icon/newBlack/d'+buf[1]+'.png"/>');
		});
		$('#icon_img'+i).unbind('click');
		$('#icon_img'+i).bind('click', function() {
			var buf = this.id.split('icon_img');
			var src = '<c:url value="/images/geoImg/icon/newBlack/d'+buf[1]+'.png"/>';
			createIcon(src);
		});
	}
	document.getElementById('icon_dialog').style.display='block';
}

function tabImage(num) {
	if(num==1) {
		document.getElementById('icon_div1').style.display='block';
		document.getElementById('icon_div2').style.display='none';
	}
	else if(num==2) {
		document.getElementById('icon_div1').style.display='none';
		document.getElementById('icon_div2').style.display='block';
	}
	else {}
}

//text icon change
function captionCheck(obj){
	if(obj.src.indexOf('off') > -1){
		obj.src = obj.src.replace("off","on");
		$(obj).prev().attr('checked', true);
	}else{
		obj.src = obj.src.replace("on","off");
		$(obj).prev().attr('checked', false);
	}
}

var auto_icon_str;
var auto_icon_num = 0;
function createIcon(img_src) {
	auto_icon_str = "i" + auto_icon_num;
	
	var img_element = $(document.createElement('img'));
	img_element.attr('id', auto_icon_str);
	img_element.attr('src', img_src);
	img_element.attr('style', 'position:absolute; display:block; left:30px; top:30px;');
	img_element.attr('width', 100);
	img_element.attr('height', 100);
	img_element.appendTo('#video_main_area');
	$('#'+img_element.attr('id')).resizable().parent().draggable();
	$('#'+img_element.attr('id')).contextMenu('context2', {
		bindings: {
			'context_delete': function(t) {
// 				jConfirm('정말 삭제하시겠습니까?', '정보', function(type){ if(type) $('#'+t.id).remove(); removeTableObject(t.id); $('#frame'+t.id).remove(); });
				jConfirm('Are you sure you want to delete?', 'Info', function(type){ if(type) $('#'+t.id).remove(); removeTableObject(t.id); $('#frame'+t.id).remove(); });
			}
		}
	});
	
	auto_icon_num++;
	
	compHide();
	
	var data_arr = new Array();
	data_arr.push(auto_icon_str); data_arr.push("Image"); data_arr.push(img_src);
	insertTableObject(data_arr);
	inputFrameObj('icon');
}


/* geo_start ----------------------------------- 지오매트리 삽입 버튼 설정 ------------------------------------- */

function inputGeometry() {
	bubbleTextArea = 0;
	$("input[name='geo_shape']:checked").val('');
	compHide();
	$('#geometry_line_color').attr('disabled', true); $('#geometry_bg_color').attr('disabled', true); $('#geometry_line_color').val('#FF0000'); $('#geometry_line_color').css('background-color', '#FF0000'); $('#geometry_bg_color').val('#FF0000'); $('#geometry_bg_color').css('background-color', '#FF0000');
	document.getElementById('geometry_dialog').style.display='block';
}

function setGeometry(geo_type) {
// 	var geo_type = $("input[name='geo_shape']:checked").val();
// 	alert('geo_Type'+geo_type);
	if(geo_type=='circle') { inputGeometryShape(1); }
	else if(geo_type=='rect') { inputGeometryShape(2); }
	else { inputGeometryShape(3); }
}

//Geometry Common Value
var auto_geometry_str; var auto_geometry_num = 0; var geometry_point_arr_1 = new Array(); var geometry_point_arr_2 = new Array();
var geometry_total_arr_1 = new Array(); var geometry_total_arr_2 = new Array();
var geometry_total_arr_buf_1 = new Array(); var geometry_total_arr_buf_2 = new Array();
//Geometry Circle & Rect Value
var geometry_click_move_val = false; var geometry_click_move_point_x = 0; var geometry_click_move_point_y = 0;
//Geometry Point Value
var geometry_point_before_x = 0; var geometry_point_before_y = 0; var geometry_point_num = 1;

function inputGeometryShape(type) {
	compHide();
	imageMoveMode = 1;
	var left = 0; var top = 0; var width = $('#video_main_area').css('width'); var height = $('#video_main_area').css('height');
	width = width.replace('px','');
	height = height.replace('px','');
	var canvas_element = $(document.createElement('canvas'));
	canvas_element.attr('id', 'geometry_draw_canvas'); canvas_element.attr('style', 'position:absolute; display:block; left:'+left+'; top:'+top+';'); canvas_element.attr('width', width); canvas_element.attr('height', height);
	if(type==1) {
		canvas_element.mousedown(function(e) {
			geometry_click_move_val = true;
			//좌표점 계산
			var left_str = $('#video_main_area').css('left'); var top_str = $('#video_main_area').css('top'); var left = parseInt(left_str.replace('px','')); var top = parseInt(top_str.replace('px','')); geometry_click_move_point_x = e.pageX - (this.offsetLeft + left)-marginImgL; geometry_click_move_point_y = e.pageY - (this.offsetTop + top)-marginImgT;
			geometry_point_arr_1 = null; geometry_point_arr_2 = null; geometry_point_arr_1 = new Array(); geometry_point_arr_2 = new Array();
			geometry_point_arr_1.push(geometry_click_move_point_x); geometry_point_arr_2.push(geometry_click_move_point_y);
		});
		canvas_element.mouseup(function(e) {
			geometry_click_move_val = false;
			//좌표점 계산
			var left_str = $('#video_main_area').css('left'); var top_str = $('#video_main_area').css('top'); var left = parseInt(left_str.replace('px','')); var top = parseInt(top_str.replace('px',''));
			geometry_point_arr_1.push(e.pageX - (this.offsetLeft + left)-marginImgL); geometry_point_arr_2.push(e.pageY - (this.offsetTop + top)-marginImgT);
			createGeometry(type);
		});
		canvas_element.mousemove(function(e) {
			if(geometry_click_move_val) {
				//마우스 좌표 가져오기
				var left_str = $('#video_main_area').css('left'); var top_str = $('#video_main_area').css('top');
				var left = parseInt(left_str.replace('px','')); var top = parseInt(top_str.replace('px',''));
				var mouse_x = e.pageX - (this.offsetLeft + left)-marginImgL;
				var mouse_y = e.pageY - (this.offsetTop + top)-marginImgT;
				//각 좌표 설정
				var start_x, start_y, width, height; width = Math.abs(geometry_click_move_point_x - mouse_x); height = Math.abs(geometry_click_move_point_y - mouse_y);
				if(geometry_click_move_point_x > mouse_x) start_x = mouse_x; else start_x = geometry_click_move_point_x;
				if(geometry_click_move_point_y > mouse_y) start_y = mouse_y; else start_y = geometry_click_move_point_y;
				var kappa = .5522848;
					ox = (width/2) * kappa, oy = (height/2) * kappa, xe = start_x + width, ye = start_y + height, xm = start_x + width/2, ym = start_y + height/2;
				
				//원 그리기
				var canvas = $('#geometry_draw_canvas');
				var context = document.getElementById('geometry_draw_canvas').getContext("2d");
				var tmpCanW = parseInt(canvas.css('width').replace('px',''));
				var tmpCanH = parseInt(canvas.css('height').replace('px',''));
				context.clearRect(0,0, tmpCanW, tmpCanH);
				context.strokeStyle = '#f00';
				context.beginPath(); context.moveTo(start_x, ym);
				context.bezierCurveTo(start_x, ym - oy, xm - ox, start_y, xm, start_y); context.bezierCurveTo(xm + ox, start_y, xe, ym - oy, xe, ym); context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye); context.bezierCurveTo(xm - ox, ye, start_x, ym + oy, start_x, ym);
				context.closePath(); context.stroke();
			}
		});
	}
	else if(type==2) {
		canvas_element.mousedown(function(e) {
			geometry_click_move_val = true;
			//좌표점 계산
			var left_str = $('#video_main_area').css('left'); var top_str = $('#video_main_area').css('top'); 
			var left = parseInt(left_str.replace('px','')); var top = parseInt(top_str.replace('px','')); 
// 			geometry_click_move_point_x = e.pageX - (this.offsetLeft + left)-marginImgL; 
// 			geometry_click_move_point_y = e.pageY - (this.offsetTop + top)-marginImgT;

			geometry_click_move_point_x = e.pageX - (this.offsetLeft)-marginImgL; 
			geometry_click_move_point_y =e.pageY - (this.offsetTop)-marginImgT;
			geometry_point_arr_1 = null; geometry_point_arr_2 = null; geometry_point_arr_1 = new Array(); geometry_point_arr_2 = new Array();
			geometry_point_arr_1.push(geometry_click_move_point_x); geometry_point_arr_2.push(geometry_click_move_point_y);
		});
		canvas_element.mouseup(function(e) {
			geometry_click_move_val = false;
			//좌표점 계산
			var left_str = $('#video_main_area').css('left'); var top_str = $('#video_main_area').css('top'); var left = parseInt(left_str.replace('px','')); var top = parseInt(top_str.replace('px',''));
// 			geometry_point_arr_1.push(e.pageX - (this.offsetLeft + left)-marginImgL); 
// 			geometry_point_arr_2.push(e.pageY - (this.offsetTop + top)-marginImgT);
			geometry_point_arr_1.push(e.pageX - (this.offsetLeft)-marginImgL); 
			geometry_point_arr_2.push(e.pageY - (this.offsetTop)-marginImgT);
			createGeometry(type);
		});
		canvas_element.mousemove(function(e) {
			if(geometry_click_move_val) {
				//마우스 좌표 가져오기
				var left_str = $('#video_main_area').css('left'); var top_str = $('#video_main_area').css('top');
				var left = parseInt(left_str.replace('px','')); var top = parseInt(top_str.replace('px',''));
// 				var mouse_x = e.pageX - (this.offsetLeft + left)-marginImgL;
// 				var mouse_y = e.pageY - (this.offsetTop + top)-marginImgT;
				
				var mouse_x = e.pageX - (this.offsetLeft)-marginImgL;
				var mouse_y = e.pageY - (this.offsetTop)-marginImgT;
				//각 좌표 설정
				var start_x, start_y, width, height;
				width = Math.abs(geometry_click_move_point_x - mouse_x); height = Math.abs(geometry_click_move_point_y - mouse_y);
				if(geometry_click_move_point_x > mouse_x) start_x = mouse_x;
				else start_x = geometry_click_move_point_x;
				if(geometry_click_move_point_y > mouse_y) start_y = mouse_y;
				else start_y = geometry_click_move_point_y;
				//사각형 그리기
				var canvas = $('#geometry_draw_canvas');
				var context = document.getElementById('geometry_draw_canvas').getContext("2d");
				var tmpCanW = parseInt(canvas.css('width').replace('px',''));
				var tmpCanH = parseInt(canvas.css('height').replace('px',''));
				context.clearRect(0,0, tmpCanW, tmpCanH);
				context.strokeStyle = '#f00';
				context.strokeRect(start_x, start_y, width, height);
			}
		});
	}
	else {
		canvas_element.click(function(e) {
			//좌표점 계산
			var left_str = $('#video_main_area').css('left'); var top_str = $('#video_main_area').css('top');
			var left = parseInt(left_str.replace('px','')); var top = parseInt(top_str.replace('px',''));
// 			var x = e.pageX - (this.offsetLeft + left)-marginImgL; var y = e.pageY - (this.offsetTop + top) - marginImgT;
			var x = e.pageX - left; var y = e.pageY - top;
			console.log('x : ' +  x + ' , y : ' + y);
			var xyBool = false;
			for(var i = 0; i<geometry_point_arr_1.length; i++){
				if(x >= (geometry_point_arr_1[i]-5) && x <= (geometry_point_arr_1[i]+5) 
						&& y >= (geometry_point_arr_2[i]-5) && y <= (geometry_point_arr_2[i]+5)){
					xyBool = true;
				}
			}
			if(xyBool){
				createGeometry(type);
			}else{
				//클릭 좌표점에 원과 숫자 그리기
				var context = document.getElementById('geometry_draw_canvas').getContext("2d"); context.strokeStyle = '#f00'; context.beginPath(); context.arc(x, y, 5, 0, 2*Math.PI, true); context.stroke();
				if(geometry_point_num>=10) context.fillText(geometry_point_num, x-7, y-6); else context.fillText(geometry_point_num, x-3, y-6);
				geometry_point_num++;
				if(geometry_point_before_x == 0 && geometry_point_before_y == 0) { geometry_point_before_x = x; geometry_point_before_y = y; }
				else { context.moveTo(geometry_point_before_x, geometry_point_before_y); context.lineTo(x, y); geometry_point_before_x = x; geometry_point_before_y = y; context.stroke(); }
				context.closePath();
				geometry_point_arr_1.push(x);
				geometry_point_arr_2.push(y);
			}
		});
	}
	canvas_element.appendTo('#video_main_area');
	
	//그리기 완료 및 그리기 취소 버튼
// 	var html_text = '<button class="geometry_complete_button" onclick="createGeometry('+type+');" style="left:0px; top:0px;">Draw complete</button>';
// 	html_text += '<button class="geometry_cancel_button" onclick="cancelGeometry();" style="left:10px; top:0px;">Undo drawing</button>';
// 	$('#image_main_area').append(html_text);
// 	$('.geometry_complete_button').button(); $('.geometry_cancel_button').button();
// 	$('.geometry_complete_button').width(115); $('.geometry_cancel_button').width(115);
// 	$('.geometry_complete_button').height(30); $('.geometry_cancel_button').height(30);
// 	$('.geometry_complete_button').css('fontSize', 12); $('.geometry_cancel_button').css('fontSize', 12);
}

function createGeometry(type) {
	auto_geometry_str = "g" + auto_geometry_num;
	var min_x, max_x, min_y, max_y;
	if(type==1 || type==2) {
		if(geometry_point_arr_1[0] < geometry_point_arr_1[1]) { min_x = geometry_point_arr_1[0]; max_x = geometry_point_arr_1[1]; }
		else { min_x = geometry_point_arr_1[1]; max_x = geometry_point_arr_1[0]; }
		if(geometry_point_arr_2[0] < geometry_point_arr_2[1]) { min_y = geometry_point_arr_2[0]; max_y = geometry_point_arr_2[1]; }
		else { min_y = geometry_point_arr_2[1]; max_y = geometry_point_arr_2[0]; }
	}
	else {
		//좌표점에서 사각형 찾기
		min_x = Math.min.apply(Math, geometry_point_arr_1);
		max_x = Math.max.apply(Math, geometry_point_arr_1);
		min_y = Math.min.apply(Math, geometry_point_arr_2);
		max_y = Math.max.apply(Math, geometry_point_arr_2);
	}
	var left = min_x; var top = min_y; var width = max_x - min_x; var height = max_y - min_y;
	var left_str = $('#video_main_area').css('left'); var top_str = $('#video_main_area').css('top');
	var left_offset = parseInt(left_str.replace('px','')); var top_offset = parseInt(top_str.replace('px',''));
// 	left += (left_offset); top += (top_offset);
	//canvas 객체 삽입
	console.log('ccc: ' + left + ' top : ' + top + ' width : '+ width + ' height: '+ height +' geometry_point_arr_1 :'+ geometry_point_arr_1 + " \ngeometry_point_arr_2 : " +geometry_point_arr_2);
	var canvas_element = $(document.createElement('canvas'));
	canvas_element.attr('id', auto_geometry_str);
	if(type == 3){
		left = min_x; top = min_y;
		canvas_element.attr('style', 'position:absolute; display:block; left:'+left+'px; top:'+top+'px;');
	}else{
		canvas_element.attr('style', 'position:absolute; display:block; left:'+left+'px; top:'+top+'px;');
	}
	
	canvas_element.attr('style', 'position:absolute; display:block; left:'+left+'px; top:'+top+'px;');
	canvas_element.attr('width', width);
	canvas_element.attr('height', height);
	canvas_element.mouseover(function() {
		mouseeventGeometry(this.id, true, type);
	});
	canvas_element.mouseout(function() {
		mouseeventGeometry(this.id, false, type);
	});
	canvas_element.appendTo('#video_main_area');
	
	$('#'+canvas_element.attr('id')).contextMenu('context2', {
		bindings: {
// 			'context_add': function(t) {
// 				var obj = $('#'+t.id);
// 				var top = obj.css('top'); top = top.replace('px','');
// 				var left = obj.css('left'); left = left.replace('px','');
// // 				autoCreateText('b', 'Normal', '#000000', '#FFFFFF', 'false', 'false', 'false', 'false', t.id+'의 말풍선', top, left);
// 				autoCreateText('b', 'Normal', '#000000', '#FFFFFF', 'false', 'false', 'false', 'false', t.id+' speech bubble', top, left);
// 			},
// 			'context_delete': function(t) { jConfirm('정말 삭제하시겠습니까?', '정보', function(type){ if(type) $('#'+t.id).remove(); removeTableObject(t.id); }); }
			'context_delete': function(t) { jConfirm('Are you sure you want to delete?', 'Info', function(type){ if(type) $('#'+t.id).remove(); removeTableObject(t.id); $('#frame'+t.id).remove(); }); }
		}
	});
	//canvas 객체에 Geometry 그리기
	var canvas = $('#'+auto_geometry_str);
	var context = canvas[0].getContext("2d");
	
	var x, y;
	var x_str = auto_geometry_str+'@'+left+'@'; var y_str = auto_geometry_str+'@'+top+'@';
	var x_str_buf = auto_geometry_str+'@'+left+'@'; var y_str_buf = auto_geometry_str+'@'+top+'@';
	
	var line_color = $('#geometry_line_color').val();
	line_color = line_color.substring(1, line_color.length);
	var bg_color = $('#geometry_bg_color').val();
	bg_color = bg_color.substring(1, bg_color.length);
	context.strokeStyle = css3color(line_color, 1);
	context.lineWidth = 1;
	
	if(type==1) {
		x = 0;
		y = 0;
		width = max_x - min_x; height = max_y - min_y;
		var kappa = .5522848;
			ox = (width/2) * kappa, oy = (height/2) * kappa, xe = x + width, ye = y + height, xm = x + width/2, ym = y + height/2;
		context.beginPath();
		context.moveTo(x, ym);
		context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y); context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym); context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye); context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
		context.closePath(); context.stroke();
		x_str += x + '_' + width + '@' + line_color; y_str += y + '_' + height + '@' + bg_color + '@circle';
		x_str_buf += geometry_point_arr_1[0] + '_' + geometry_point_arr_1[1] + '@' + line_color; y_str_buf += geometry_point_arr_2[0] + '_' + geometry_point_arr_2[1] + '@' + bg_color + '@circle';
	}
	else if(type==2) {
		width = max_x - min_x; height = max_y - min_y;
		context.strokeRect(0, 0, width, height);
		x_str += 0 + '_' + width + '@' + line_color; y_str += 0 + '_' + height + '@' + bg_color + '@rect';
		x_str_buf += geometry_point_arr_1[0] + '_' + geometry_point_arr_1[1] + '@' + line_color; y_str_buf += geometry_point_arr_2[0] + '_' + geometry_point_arr_2[1] + '@' + bg_color + '@rect';
	}
	else {
		console.log('xxxx: ' + left + ' top : ' + top + ' width : '+ width + ' height: '+ height +' geometry_point_arr_1 :'+ geometry_point_arr_1 + " \ngeometry_point_arr_2 : " +geometry_point_arr_2);
		context.beginPath();
		for(var i=0; i<geometry_point_arr_1.length; i++) {
// 			x = Math.abs(left - geometry_point_arr_1[i]-left_offset);
// 			y = Math.abs(top - geometry_point_arr_2[i]-top_offset);
			x = Math.abs(left - geometry_point_arr_1[i]);
			y = Math.abs(top - geometry_point_arr_2[i]);
// 			x = Math.abs(geometry_point_arr_1[i]);
// 			y = Math.abs(geometry_point_arr_2[i]);
// 			x =geometry_point_arr_1[i];
// 			y = geometry_point_arr_2[i];
			
			if(i==0) context.moveTo(x, y);
			else context.lineTo(x, y);
			if(i==geometry_point_arr_1.length-1) { x_str += x + '@' + line_color; y_str += y + '@' + bg_color + '@point'; }
			else { x_str += x + '_'; y_str += y + '_'; }
			if(i==geometry_point_arr_1.length-1) { x_str_buf += geometry_point_arr_1[i] + '@' + line_color; y_str_buf += geometry_point_arr_2[i] + '@' + bg_color + '@point'; }
			else { x_str_buf += geometry_point_arr_1[i] + '_'; y_str_buf += geometry_point_arr_2[i] + '_'; }
		}
		context.closePath();
		context.stroke();
	}
	auto_geometry_num++;
	//데이터 저장
	geometry_total_arr_1.push(x_str);
	geometry_total_arr_2.push(y_str);
	geometry_total_arr_buf_1.push(x_str_buf);
	geometry_total_arr_buf_2.push(y_str_buf);
	
	cancelGeometry();
	
	var data_arr = new Array();
	data_arr.push(auto_geometry_str); data_arr.push("Geometry");
	if(type==1) { data_arr.push("Circle"); }
	else if(type==2) { data_arr.push("Rectangle"); }
	else { data_arr.push("Point"); }
	insertTableObject(data_arr);
	inputFrameObj('geometry');
}

function mouseeventGeometry(id, over, type) {
	//좌표 배열에서 좌표 가져옴
	var x_arr, y_arr, x_str, y_str, line_color, bg_color;
	for(var i=0; i<geometry_total_arr_1.length; i++) {
		if(id==geometry_total_arr_1[i].split("\@")[0]) {
			line_color = geometry_total_arr_1[i].split("\@")[3]; bg_color = geometry_total_arr_2[i].split("\@")[3];
			x_str = geometry_total_arr_1[i].split("\@")[2]; y_str = geometry_total_arr_2[i].split("\@")[2];
			x_arr = x_str.split("_"); y_arr = y_str.split("_");
		}
	}
	
	var x, y, width, height;
	var canvas = $('#'+id);
	var context = canvas[0].getContext("2d");
	context.clearRect(0,0,canvas.attr('width'),canvas.attr('height'));
	context.strokeStyle = css3color(line_color, 1); context.lineWidth = 1;
	
	if(type==1) {
		x = parseInt(x_arr[0]); y = parseInt(y_arr[0]); width = parseInt(x_arr[1]); height = parseInt(y_arr[1]);
		var kappa = .5522848;
			ox = (width/2) * kappa, oy = (height/2) * kappa, xe = x + width, ye = y + height, xm = x + width/2, ym = y + height/2;
		context.beginPath(); context.moveTo(x, ym);
		context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y); context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym); context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye); context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
		context.closePath();
		if(over) { context.fillStyle = css3color(bg_color, 0.2); context.fill(); }
		context.stroke();
	}
	else if(type==2) {
		x = x_arr[0]; y = y_arr[0]; width = x_arr[1]; height = y_arr[1];
		if(over) { context.fillStyle = css3color(bg_color, 0.2); context.fillRect(x, y, width, height); }
		context.strokeRect(x, y, width, height);
	}
	else {
		context.beginPath();
		for(var i=0; i<x_arr.length; i++) { x = parseInt(x_arr[i]); y = parseInt(y_arr[i]); if(i==0) context.moveTo(x, y); else context.lineTo(x, y); }
		context.closePath();
		if(over) { context.fillStyle = css3color(bg_color, 0.2); context.fill(); }
		context.stroke();
	}
}

function cancelGeometry() {
	//데이터 초기화
	$('.geometry_complete_button').remove(); $('.geometry_cancel_button').remove(); $('#geometry_draw_canvas').remove();
	geometry_point_arr_1 = null; geometry_point_arr_1 = new Array(); geometry_point_arr_2 = null; geometry_point_arr_2 = new Array();
	geometry_click_move_val = false; geometry_click_move_point_x = 0; geometry_click_move_point_y = 0; geometry_point_before_x = 0; geometry_point_before_y = 0; geometry_point_num = 1;
	imageMoveMode = 0;
}

/* save_start ----------------------------------- 저장 버튼 및 불러오기 설정 ------------------------------------- */
//저장 버튼 다이얼로그 오픈
// function saveSetting() {
// 	$('#save_dialog').dialog('open');
// }

//저장 실행
function saveVideoWrite1(type) {
	if(type == "1" || type == "2"){
		getServer(type);
	}else{
		saveVideoWrite(type, "", "", "");
	}
}

//저장 실행
function saveVideoWrite(type, tmpServerId, tmpServerPass, tmpServerPort) {
// 	$('#save_dialog').dialog('close');
	
	var obj_data_arr = new Array();
	
	var html_text = '';
	
	var objCount = $('#video_main_area').children().size();
	for(var i=0; i<objCount; i++) {
		var obj = $('#video_main_area').children().eq(i);
		var id = obj.attr('id');
		if(id=='') { obj = obj.children().eq(0); id = obj.attr('id'); }
		
		if(id!='video_player0' && id!='video_player1' && id!='video_player2' && id!='video_player3' && id!='video_player4') {
			var buf1 = $('#frame'+id).css('top'); var frame_line = parseInt(buf1.replace('px',''));
			var buf2 = $('#frame'+id).css('left'); var frame_start = parseInt(buf2.replace('px',''));
			var buf3 = $('#frame'+id).css('width'); var frame_end = parseInt(buf3.replace('px','')) + frame_start;
			if(id.indexOf("c")!=-1) {
				var obj_font = $('#f'+id);
				var obj_pre = $('#p'+id);
				obj_data_arr.push([id.substring(0, 1), obj.position().top, obj.position().left, obj.html(), obj_font.css('font-size'), obj_font.css('color'), obj_pre.css('backgroundColor'), obj_pre.html(), frame_line, frame_start, frame_end]);
			}
			else if(id.indexOf("b")!=-1) {
				var obj_font = $('#f'+id);
				var obj_pre = $('#p'+id);
				var obj_pre_text = obj_pre.html();
				obj_pre_text = obj_pre_text.replace(/(\n|\r)+/g, "@line@");
				obj_data_arr.push([id.substring(0, 1), obj.position().top, obj.position().left, obj.html(), obj_font.css('font-size'), obj_font.css('color'), obj_pre.css('backgroundColor'), obj_pre_text, frame_line, frame_start, frame_end]);
			}
			else if(id.indexOf("i")!=-1) {
				obj_data_arr.push([id.substring(0, 1), obj.parent().position().top, obj.parent().position().left, obj.css('width'), obj.css('height'), obj.attr('src'), frame_line, frame_start, frame_end]);
			}
			else if(id.indexOf("g")!=-1) {
				var check_id, left, top, x_str, y_str, line_color, bg_color, geo_type;
				for(var j=0; j<geometry_total_arr_buf_1.length; j++) {
					var buf1 = geometry_total_arr_buf_1[j].split("\@");
					var buf2 = geometry_total_arr_buf_2[j].split("\@");
					check_id = buf1[0]; left = buf1[1]; top = buf2[1]; x_str = buf1[2]; y_str = buf2[2]; line_color = buf1[3]; bg_color = buf2[3]; geo_type = buf2[4];
					if(check_id==id) { obj_data_arr.push([id.substring(0, 1), top, left, x_str, y_str, line_color, bg_color, geo_type, frame_line, frame_start, frame_end]); }
				}
			}
			else {}
		}
	}
	var xml_text = makeXMLStr(obj_data_arr);
	var encode_xml_text = encodeURIComponent(xml_text);

	var encode_file_name = upload_url + file_url;
	encode_file_name = encode_file_name.substring(1, encode_file_name.lastIndexOf(".")+1) +"xml" ;
	encode_file_name = encodeURIComponent(encode_file_name);
	
	if(type==1 || type==2) {
		var tmpTitle = $('#title_area').val();
		var tmpContent = document.getElementById('content_area').value;
		var tmpShareType = $('input[name=shareRadio]:checked').val();
		var tmpAddShareUser = $('#shareAdd').val();
		var tmpRemoveShareUser = $('#shareRemove').val();
		var tmpEditYes = $('#editYes').val();
		var tmpEditNo = $('#editNo').val();
		
		if(tmpTitle == null || tmpTitle == "" || tmpTitle == 'null'){
// 			 jAlert('제목을 입력해 주세요.', '정보');
			 jAlert('Please enter the title.', 'Info');
			 return;
		 }
		 
		 if(tmpContent == null || tmpContent == "" || tmpContent == 'null'){
// 			 jAlert('내용을 입력해 주세요.', '정보');
			 jAlert('Please enter your details.', 'Info');
			 return;
		 }
		 if(tmpShareType != null && tmpShareType == 2 && (tmpAddShareUser == null || tmpAddShareUser == '') && oldShareUserLen == 0){
// 			 jAlert('공유 유저가 지정되지 않았습니다.', '정보');
			 jAlert('No sharing user specified.', 'Info');
			 return;
		 }
		 
		 if(tmpTitle != null && tmpTitle.indexOf('\'') > -1){
// 			 jAlert('제목에 특수문자 \' 는 사용할 수 없습니다.', '정보');
			 jAlert('Can not use special character \' in title.', 'Info');
			 return;
		 }
		 
		 if(tmpContent != null && tmpContent.indexOf('\'') > -1){
// 			 jAlert('내용에 특수문자 \' 는 사용할 수 없습니다.', '정보');
			 jAlert('Can not use special character \' in content.', 'Info');
			 return;
		 }

		//xml 저장
		$.ajax({
			type: 'POST',
			url: base_url + '/geoXml.do',
			data: 'file_name='+encode_file_name+'&xml_data='+ encode_xml_text+'&type=save&serverType='+b_serverType+'&serverUrl='+b_serverUrl+
			'&serverPath='+b_serverPath+'&serverPort='+tmpServerPort+'&serverViewPort='+ b_serverViewPort +'&serverId='+tmpServerId+'&serverPass='+tmpServerPass,
			success: function(data) {
				var response = data.trim();
				if(response == 'XML_SAVE_SUCCESS'){
					if(projectBoard == 1){
						var tmp_xml_text = xml_text.replace(/\//g,'&sbsp');
						tmp_xml_text = tmp_xml_text.replace(/\?/g,'&mbsp');
						tmp_xml_text = tmp_xml_text.replace(/\#/g,'&pbsp');
						tmp_xml_text = tmp_xml_text.replace(/\./g,'&obsp');
						
						if(tmpAddShareUser == null || tmpAddShareUser.length <= 0){ tmpAddShareUser = '&nbsp'; }
						if(tmpRemoveShareUser == null || tmpRemoveShareUser.length <= 0){ tmpRemoveShareUser = '&nbsp'; }
						if(tmpEditYes == null || tmpEditYes == ''){ tmpEditYes = '&nbsp'; }
						if(tmpEditNo == null || tmpEditNo == ''){ tmpEditNo = '&nbsp'; }
						
						tmpTitle = dataReplaceFun(tmpTitle);
						tmpContent = dataReplaceFun(tmpContent);
						
						var coplyUrlSave = '&nbsp';
						if(urlData != null && urlData != '' && linkType != null && linkType == 'CP4'){
							coplyUrlSave = 'Y';
						}
						var tmpImgDroneType = 'N';
						if($('#droneTypeChk').attr('checked')){
							tmpImgDroneType = 'Y';
						}
						
						var Url			= baseRoot() + "cms/updateVideo/";
						var param		= loginToken + "/" + loginId + "/" + idx + "/" + tmpTitle + "/" + tmpContent + "/" + tmpShareType + "/" + 
							tmpAddShareUser + "/" + tmpRemoveShareUser + "/" + tmp_xml_text +"/" + tmpEditYes + "/" + tmpEditNo +"/"+ coplyUrlSave +"/" + tmpImgDroneType;
						var callBack	= "?callback=?";
						$.ajax({
							type	: "POST"
							, url	: Url + param + callBack
							, dataType	: "jsonp"
							, async	: false
							, cache	: false
							, success: function(data) {
								var response = data.Data;
								if(data.Code == '100'){
					 				$('#shareKindLabel').text();
// 					 				jAlert('정상적으로 저장 되었습니다.', '정보');
					 				jAlert('Saved successfully.', 'Info');
								}else{
									jAlert(data.Message, 'Info');
								}
							}
						});
					}
				}
			}
		});
	}
	else if(type==3) {
		
		if(flag == 3)
		{
			window.opener.writerName(obj_data_arr);
			opener.parent().writerName(obj_data_arr);
			window.opener.close();
			close();
		}
		else
		{
			
		}
		xml_text = xml_text.replace(/><+/g, "\>\\n\<");
		var conv_xml_text = encodeURIComponent(xml_text);
		
		window.open('', 'xml_view_page', 'width=530, height=630');
		var form = document.createElement('form');
		form.setAttribute('method','post');
		form.setAttribute('action','<c:url value="/geoVideo/xml_view.do"/>');
		form.setAttribute('target','xml_view_page');
		document.body.appendChild(form);
		
		var insert = document.createElement('input');
		insert.setAttribute('type','hidden');
		insert.setAttribute('name','xml_data');
		insert.setAttribute('value',conv_xml_text);
		form.appendChild(insert);
		
		form.submit();
	}
	else {}
}


function makeXMLStr(obj_data_arr) {
	var xml_text = '<?xml version="1.0" encoding="utf-8"?>';
	xml_text += "<GeoCMS>";
	for(var i=0; i<obj_data_arr.length; i++) {
		var buf_arr = obj_data_arr[i];
		var id = buf_arr[0];
		xml_text += "<obj>";
		xml_text += "<id>" + id + "</id>";
		var frame_line, frame_start, frame_end;
		if(id == "c" || id == "b") {
			var top = buf_arr[1];
			xml_text += "<top>" + top + "</top>";
			
			var left = buf_arr[2];
			xml_text += "<left>" + left + "</left>";
			
			var html_text = buf_arr[3];
			var href = "false";
			if(html_text.indexOf("<a href=")!=-1) href = "true";
			var underline = "false";
			if(html_text.indexOf("<u id=")!=-1) underline = "true";
			var italic = "false";
			if(html_text.indexOf("<i id=")!=-1) italic = "true";
			var bold = "false";
			if(html_text.indexOf("<b id=")!=-1) bold = "true";
			xml_text += "<href>" + href + "</href><underline>" + underline + "</underline><italic>" + italic + "</italic><bold>" + bold + "</bold>";
			
			var font_size = buf_arr[4];
			if(font_size == '14px') xml_text += "<fontsize>H3</fontsize>";
			else if(font_size == '18px') xml_text += "<fontsize>H2</fontsize>";
			else if(font_size == '22px') xml_text += "<fontsize>H1</fontsize>";
			else xml_text += "<fontsize>Normal</fontsize>";
			
			var font_color = rgb2hex(buf_arr[5]);
			xml_text += "<fontcolor>" + font_color + "</fontcolor>";
			
			var background_color = "none";
			if(buf_arr[6]!='rgba(0, 0, 0, 0)') 
			{	background_color = rgb2hex(buf_arr[6]);
				xml_text += "<backgroundcolor>" + background_color + "</backgroundcolor>";
			}
			else if(buf_arr[6]=='rgba(0, 0, 0, 0)')
			{
				xml_text += "<backgroundcolor></backgroundcolor>";
			}
			
			var text = buf_arr[7];
			xml_text += "<text>" + text + "</text>";

			frame_line = buf_arr[8]; frame_start = buf_arr[9]; frame_end = buf_arr[10];
		}
		else if(id == "i") {
			var top = buf_arr[1];
			xml_text += "<top>" + top + "</top>";
			
			var left = buf_arr[2];
			xml_text += "<left>" + left + "</left>";
			
			var width = buf_arr[3];
			xml_text += "<width>" + width + "</width>";
			
			var height = buf_arr[4];
			xml_text += "<height>" + height + "</height>";
			
			var src = buf_arr[5];
			xml_text += "<src>" + src + "</src>";

			frame_line = buf_arr[6]; frame_start = buf_arr[7]; frame_end = buf_arr[8];
		}
		else if(id == "g") {
			var top = buf_arr[1];
			xml_text += "<top>" + top + "</top>";
			
			var left = buf_arr[2];
			xml_text += "<left>" + left + "</left>";
			
			var x_str = buf_arr[3];
			xml_text += "<xstr>" + x_str + "</xstr>";
			
			var y_str = buf_arr[4];
			xml_text += "<ystr>" + y_str + "</ystr>";
			
			var line_color = '#' + buf_arr[5];
			xml_text += "<linecolor>" + line_color + "</linecolor>";
			
			var background_color = '#' + buf_arr[6];
			xml_text += "<backgroundcolor>" + background_color + "</backgroundcolor>";
			
			var type = buf_arr[7];
			xml_text += "<type>" + type + "</type>";

			frame_line = buf_arr[8]; frame_start = buf_arr[9]; frame_end = buf_arr[10];
		}
		else {}
		xml_text += "<frameline>" + frame_line + "</frameline>";
		xml_text += "<framestart>" + frame_start + "</framestart>";
		xml_text += "<frameend>" + frame_end + "</frameend>";
		
		xml_text += "</obj>";
	}
	xml_text += "</GeoCMS>";
	
	return xml_text;
}
//소스가 길어서 따로 함수로 생성
function autoCreateText(id, font_size, font_color, bg_color, bold, italic, underline, href, text, top, left) {
	if(id == "c") {
		if(font_size == 'H3') $('#caption_font_select').val('H3');
		else if(font_size == 'H2') $('#caption_font_select').val('H2');
		else if(font_size == 'H1') $('#caption_font_select').val('H1');
		else $('#caption_font_select').val('Normal');
		
		$('#caption_font_color').val(font_color);
		if(bg_color!='none') { $('#caption_bg_color').val(bg_color); $('input[name=caption_bg_checkbok]').attr('checked', false); }
		else { bg_color = '#FFFFFF'; $('input[name=caption_bg_checkbok]').attr('checked', true); }
		
		var check_html = "";
		var img_kind = 'off';
		
		check_html += '<input type="checkbox" id="caption_bold" style="display:none;"';
		if(bold == 'true'){
			check_html += ' checked="checked" ';
			img_kind = 'on'; 
		}
		check_html += ' /><img src="<c:url value="/images/geoImg/write/bold_'+img_kind+'.png"/>" '+icon_css+' onclick="captionCheck(this);">';
		
		img_kind = 'off';
		check_html += '<input type="checkbox" id="caption_italic" style="display:none;"';
		if(italic == 'true'){
			check_html += ' checked="checked" ';
			img_kind = 'on'; 
		}else{
			check_html += ' /><img src="<c:url value="/images/geoImg/write/italic_'+img_kind+'.png"/>" '+icon_css+' onclick="captionCheck(this);">';
		}
		
		img_kind = 'off';
		check_html += '<input type="checkbox" id="caption_underline" style="display:none;"';
		if(underline == 'true'){
			check_html += ' checked="checked" ';
			img_kind = 'on'; 
		}else{
			check_html += ' /><img src="<c:url value="/images/geoImg/write/underLine_'+img_kind+'.png"/>" '+icon_css+' onclick="captionCheck(this);">';
		}
		
		img_kind = 'off';
		check_html += '<input type="checkbox" id="caption_link" style="display:none;"';
		if(href == 'true'){
			check_html += ' checked="checked" ';
			img_kind = 'on'; 
		}else{
			check_html += ' /><img src="<c:url value="/images/geoImg/write/link_'+img_kind+'.png"/>" '+icon_css+' onclick="captionCheck(this);">';
		}
		
		$('#caption_check').html(check_html);
		$('#caption_text').val(text);
		
		createCaption();
		var obj = $('#'+auto_caption_str);
		obj.attr('style', 'position:absolute; left:'+left+'px; top:'+top+'px; display:block;');
	}
	else if(id == "b") {
		if(font_size == 'H3') $('#bubble_font_select').val('H3');
		else if(font_size == 'H2') $('#bubble_font_select').val('H2');
		else if(font_size == 'H1') $('#bubble_font_select').val('H1');
		else $('#bubble_font_select').val('Normal');
		
		$('#bubble_font_color').val(font_color);
		if(bg_color!='none') { $('#bubble_bg_color').val(bg_color); $('input[name=bubble_bg_checkbok]').attr('checked', false); }
		else { bg_color = '#FFFFFF'; $('input[name=bubble_bg_checkbok]').attr('checked', true); }
		
		var check_html = "";
		var img_kind = 'off';
		check_html += '<input type="checkbox" id="bubble_bold" style="display:none;"';
		if(bold == 'true'){
			check_html += ' checked="checked" ';
			img_kind = 'on'; 
		}
		check_html += ' /><img src="<c:url value="/images/geoImg/write/bold_'+img_kind+'.png"/>" '+icon_css+' onclick="captionCheck(this);">';
		
		img_kind = 'off';
		check_html += '<input type="checkbox" id="bubble_italic" style="display:none;"';
		if(italic == 'true'){
			check_html += ' checked="checked" ';
			img_kind = 'on'; 
		}else{
			check_html += ' /><img src="<c:url value="/images/geoImg/write/italic_'+img_kind+'.png"/>" '+icon_css+' onclick="captionCheck(this);">';
		}
		
		img_kind = 'off';
		check_html += '<input type="checkbox" id="bubble_underline" style="display:none;"';
		if(underline == 'true'){
			check_html += ' checked="checked" ';
			img_kind = 'on'; 
		}else{
			check_html += ' /><img src="<c:url value="/images/geoImg/write/underLine_'+img_kind+'.png"/>" '+icon_css+' onclick="captionCheck(this);">';
		}
		
		img_kind = 'off';
		check_html += '<input type="checkbox" id="bubble_link" style="display:none;"';
		if(href == 'true'){
			check_html += ' checked="checked" ';
			img_kind = 'on'; 
		}else{
			check_html += ' /><img src="<c:url value="/images/geoImg/write/link_'+img_kind+'.png"/>" '+icon_css+' onclick="captionCheck(this);">';
		}
		
		$('#bubble_check').html(check_html);
		text = text.replace(/@line@/g, "\r\n");
		$('body').append('<textarea id="bubble_text" style="font-size:12px;border:solid 2px #777;position: absolute;left: 160px;top: 30px;width: 150px;height:50px;text-align:left;"></textarea>');
		$("#bubble_text").resizable({
		    maxWidth: 700,
		    minHeight: 50,
		    minWidth: 150
		});
		$('#bubble_text').val(text);
		
		createBubble();
		$('#bubble_text').remove();
		var obj = $('#'+auto_bubble_str);
		obj.attr('style', 'position:absolute; left:'+left+'px; top:'+top+'px; display:block;');
	}
}

function loadXML() {
	getServer('XML');
}

function loadXML2(tmpServerId, tmpServerPass, tmpServerPort) {
	var file_arr = file_url.split(".");   		
	var xml_file_name = file_arr[0] + '.xml';
	xml_file_name = upload_url + xml_file_name;
	xml_file_name = xml_file_name.substring(1);
	
	$.ajax({
		type: "POST",
		url: base_url + '/geoXml.do',
		data: 'file_name='+xml_file_name+'&type=load&serverType='+b_serverType+'&serverUrl='+b_serverUrl+
		'&serverPath='+b_serverPath+'&serverPort='+tmpServerPort+'&serverViewPort='+ b_serverViewPort +'&serverId='+tmpServerId+'&serverPass='+tmpServerPass,
		success: function(xml) {
			var max_top = 0;
			$(xml).find('obj').each(function(index) {
				var frameline = $(this).find('frameline').text();
				if(max_top < parseInt(frameline)) max_top = parseInt(frameline);
			});
			var max_line = max_top / 25
			for(var i=0; i<max_line; i++) { createFrameLine(2); }
			$(xml).find('obj').each(function(index) {
				var id = $(this).find('id').text();
				var frame_obj;
				if(id == "c" || id == "b") {
					var font_size = $(this).find('fontsize').text(); var font_color = $(this).find('fontcolor').text(); var bg_color = $(this).find('backgroundcolor').text();
					var bold = $(this).find('bold').text(); var italic = $(this).find('italic').text(); var underline = $(this).find('underline').text(); var href = $(this).find('href').text();
					var text = $(this).find('text').text(); var top = $(this).find('top').text(); var left = $(this).find('left').text();
					autoCreateText(id, font_size, font_color, bg_color, bold, italic, underline, href, text, top, left);
					if(id == 'c') frame_obj = $('#frame'+auto_caption_str); else frame_obj = $('#frame'+auto_bubble_str);
				}
				else if(id == "i") {
					var top = $(this).find('top').text();
					var left = $(this).find('left').text();
					var width = $(this).find('width').text();
					var height = $(this).find('height').text();
					var src = $(this).find('src').text();
					
					createIcon(src);
					var obj = $('#'+auto_icon_str);
					obj.parent().position().top = top;
					obj.parent().position().left = left;
					
					obj.parent().attr('style', 'overflow: hidden; position: absolute; width:'+width+'; height:'+height+'; top:'+top+'px; left:'+left+'px; margin:0px;');
					obj.attr('style', 'position:static; display: block; top:'+top+'px; left:'+left+'px; width:'+width+'; height:'+height+';');
					frame_obj = $('#frame'+auto_icon_str);
				}
				else if(id == "g") {
					var buf = $(this).find('type').text();
					var type;
					if(buf=='circle') type = 1;
					else if(buf=='rect') type = 2;
					else if(buf=='point') type = 3;
					else {}
					
					var top = $(this).find('top').text();
					var left = $(this).find('left').text();
					var x_str = $(this).find('xstr').text();
					var y_str = $(this).find('ystr').text();
					var line_color = $(this).find('linecolor').text();
					var bg_color = $(this).find('backgroundcolor').text();
					$('#geometry_line_color').val(line_color);
					$('#geometry_bg_color').val(bg_color);
					var buf1 = x_str.split('_');
					for(var i=0; i<buf1.length; i++) { geometry_point_arr_1.push(parseInt(buf1[i])); }
					var buf2 = y_str.split('_');
					for(var i=0; i<buf2.length; i++) { geometry_point_arr_2.push(parseInt(buf2[i])); }
					createGeometry(type);
					frame_obj = $('#frame'+auto_geometry_str);
				}
				else {}
				var frame_obj_top = parseInt($(this).find('frameline').text());
				var frame_obj_left = parseInt($(this).find('framestart').text());
				var frame_obj_width = parseInt($(this).find('frameend').text()) - frame_obj_left;
				frame_obj.css({top:frame_obj_top, left:frame_obj_left, width:frame_obj_width});
			});
		},
		complete: function() {
			if (flag == "3") {
				saveVideoWrite1(flag);
				self.opener = self;
				window.close();
				self.close();
			}
		},
		error: function(xhr, status, error) {
			//alert('XML 호출 오류! 관리자에게 문의하여 주세요.');
		}
	});
}


/* ------------------- 공통 기능 ----------------- */
//컴포넌트 숨기기
function compHide() {
	document.getElementById('bubble_dialog').style.display='none';
	document.getElementById('icon_dialog').style.display='none';
	document.getElementById('geometry_dialog').style.display='none';
	document.getElementById('data_dialog').style.display='none';
	cancelGeometry();
	
	if(bubbleTextArea == 0){
		$('#bubble_text').remove();
	}
}
//맵 크기 조절
var resize_map_state = 1;
var resize_scale = 400;
var init_map_left, init_map_top, init_map_width, init_map_height;
function resizeMap() {
	if(resize_map_state==1) {
		init_map_left = 801;
		init_map_top = 580;
		init_map_width = $('#video_map_area').width();
		init_map_height = $('#video_map_area').height();
		resize_map_state=2;
		$('#video_map_area').animate({left:init_map_left-resize_scale, top:init_map_top-resize_scale, width:init_map_width+resize_scale, height:init_map_height+resize_scale},"slow", function() { $('#resize_map_btn').css('background-image','url(<c:url value="/images/geoImg/icon_map_min.jpg"/>)'); reloadMap(); });
	}
	else if(resize_map_state==2) {
		resize_map_state=1;
		$('#video_map_area').animate({left:init_map_left, top:init_map_top, width:init_map_width, height:init_map_height},"slow", function() { $('#resize_map_btn').css('background-image','url(<c:url value="/images/geoImg/icon_map_max.jpg"/>)'); reloadMap(); });
	}
	else {}
}
function reloadMap() {
	$('#openlayers').get(0).contentWindow.resetCenter();
}
//객체 테이블
function insertTableObject(data_arr) {
	var html_text = "";
	html_text += "<tr id='obj_tr"+data_arr[0]+"' bgcolor='#e3e3e3' style='font-size:12px; height:18px; color:rgb(21, 74, 119);'>";
	html_text += "<td align='center'><label>"+data_arr[0]+"</label></td>";
	html_text += "<td align='center'><label>"+data_arr[1]+"</label></td>";
	html_text += "<td id='obj_td"+data_arr[0]+"'><label>"+data_arr[2]+"</label></td>";
	html_text += "</tr>";
	
	$('#object_table tr:last').after(html_text);
	$('.ui-widget-content').css('fontSize', 12);
}
function replaceTableObject(data_arr) {
	$('#obj_td'+data_arr[0]).html(data_arr[2]);
}
function removeTableObject(id) {
	$('#obj_tr'+id).remove();
}

/* util_start ----------------------------------- Util ------------------------------------- */
rgb2hex = function(rgb) {
	rgb = rgb.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*(\d+))?\)$/);
    function hex(x) {
        return ("0" + parseInt(x).toString(16)).slice(-2);
    }
    return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
};
hex_to_decimal = function(hex) {
	return Math.max(0, Math.min(parseInt(hex, 16), 255));
};
css3color = function(color, opacity) {
	if(color.length==3) { var c1, c2, c3; c1 = color.substring(0, 1); c2 = color.substring(1, 2); c3 = color.substring(2, 3); color = c1 + c1 + c2 + c2 + c3 + c3; }
	return 'rgba('+hex_to_decimal(color.substr(0,2))+','+hex_to_decimal(color.substr(2,2))+','+hex_to_decimal(color.substr(4,2))+','+opacity+')';
};

/* exit_start ----------------------------------- 종료 버튼 설정 ------------------------------------- */
function closeVideoWrite(){
// 	jConfirm('저작을 종료하시겠습니까?', '정보', function(type){
	jConfirm('Do you want to end authoring?', 'Info', function(type){
		if(type) { top.window.opener = top; top.window.open('','_parent',''); top.window.close(); }
	});
}

/* video button start ----------------------------------- 비디오 버튼 설정 ------------------------------------- */
var videoLoding = 0;
function vidplay() {
	
    var button = document.getElementById("play");
    if(videoLoding == 0){
    	
    	if(video_child_len == 1){
    		if(!video0.ended){
        		video0.play();
        	}
    	}else if(video_child_len > 1){
    		if(!video1.ended){
        		video1.play();
        	}
    		if(!video2.ended){
        		video2.play();
        	}
    	}	
    
    	if(video_child_len > 2 && !video3.ended){
    		video3.play();
    	}
    	if(video_child_len > 3 && !video4.ended){
    		video4.play();
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
// 	    if(video_child_len == 1){
// 	    	video0.pause();
// 	 	}else if(video_child_len > 1){
// 	 		video1.pause();
// 	 		video2.pause();
// 	 	}
// 	 	if(video_child_len > 2){video3.pause();}
// 	 	if(video_child_len > 3){video4.pause();}
	 	
// 	 	var button = document.getElementById("play");
// 	    if (button.src.indexOf("video_play.png") > -1) {
// 	    	vidplay();
// 	 	 }
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
	     
// 	    var button = document.getElementById("play");
// 	    if (button.src.indexOf("video_play.png") > -1) {
// 	    	button.src = "<c:url value='/images/geoImg/video/video_pause.png'/>";
// 	 	 }
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
 
//copy Url
 function getCopyUrlDecode(){
 	var Url			= baseRoot() + "cms/encrypt";
 	var param		= "/" + urlData + "/decrypt";
 	var callBack	= "?callback=?";
 	
 	$.ajax({
 		type	: "get"
 		, url	: Url + param + callBack
 		, dataType	: "jsonp"
 		, async	: false
 		, cache	: false
 		, success: function(data) {
 			if(data.returnStr != null && data.returnStr != ''){
 				var  tmpStr = data.returnStr;
 				tmpStr = tmpStr.split("&");
 				$.each(tmpStr, function(idx, val){
 					if(val.indexOf('file_url') > -1){
 						file_url = val.split('=')[1];
 					}else if(val.indexOf('loginId') > -1){
 						copyUserId = val.split('=')[1];
 					}else if(val.indexOf('idx') > -1){
 						copyUrlIdx = val.split('=')[1];
 					}
 				});
 				projectBoard = 1;
 			}else{
//  				jAlert(data.Message, 'Info');
 			}
 		}
 	});
 }
 
 function exifViewFunction(sType){
		if(sType == 'on'){
			$('#exifViewOn').css('display','none');
			$('#exifViewOff').css('display','block');
			$('#image_exif_area').css('display','block');
			$('#image_exif_area').maxZIndex({inc:1});
//	 		$('#image_map_area').css('top','220px');
//	 		$('#image_map_area').css('height','51%');
		}else{
			$('#exifViewOn').css('display','block');
			$('#exifViewOff').css('display','none');
			$('#image_exif_area').css('display','none');
//	 		$('#image_map_area').css('top','10px');
//	 		$('#image_map_area').css('height','94%');
//	 		$('#exifViewOn').maxZIndex({inc:1});
		}
	}

	//right image infomation view type change
	function fnViewTabs(tempTabId){
		$('.selectExifTabTitle').addClass('noSlectExifTabTitle');
		$('.selectExifTabTitle').removeClass("selectExifTabTitle");
		$('.selectExifTabChild').addClass('noSelectExifTabChild');
		$('.selectExifTabChild').removeClass("selectExifTabChild");
		
		$('#tabs_'+tempTabId).removeClass('noSlectExifTabTitle');
		$('#tabs_'+tempTabId).addClass('selectExifTabTitle');
		
		$('#tabsChild_'+tempTabId).removeClass("noSelectExifTabChild");
		$('#tabsChild_'+tempTabId).addClass("selectExifTabChild");
		
	}
	
function closeBubbleConfirm(){
	bubbleTextArea = 0;
	compHide();
}

function fnImportUrbanJson(){

	$('#file').change(function(){
		if($(this).val()){
			var formData = new FormData($('#formImport')[0]);

			$.ajax({
				type	: "POST"
				, url	: "/GeoCMS/geoVideoImportUrbanAI.do?idx=<%= idx %>&file_url=<%= file_url %>"
				, dataType	: "xml"
				, data	: formData
				, async	: false
				, cache	: false
				, contentType: false
				, processData: false
				, success: function(data) {
/*
					if(data && data.startsWith('<?xml')){
						alert('Success');
					}
					else {
						alert('Failed');
					}*/
//					alert(data);
//					alert('done');
					location.reload();
				}
				, error:function(request,status,error){
					alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				}
			});
			$(this).val(null);
		}
		else {
			alert('파일을 선택해주세요.');
		}
	});
	$('#file').click();
}

</script>
</head>
<body onload='videoWriteInit();' bgcolor='#FFF' style="margin:0px;">

<!------------------------------------------------------ 화면 영역 ----------------------------------------------------------->
<!-- 저작 버튼 영역 -->
<!-- 저작 버튼 영역 -->
<div id="writerBtnViewOff" class="editorSideBar" style="height: 642px; width : 60px; font-size: 10px; background-color: #1e2b41; position: fixed; left: 0px; top: 0px;">
	<div align="center" style="width:100%;height:30px; border-bottom: 1px solid #293B5A;color: #ffffff;text-align: center;font-weight: bold;font-size: 12px;">
		<div class="menuIconText">EDITOR</div>
	</div>
	<div class="menuIcon" onclick='inputBubble(0,"");'>
		<div class="btn_td" align="center">
			<div style="margin-top: 10px;"><img class="editor_side_btn" src="<c:url value='/images/geoImg/write/editor_speech_bubble_icon.png'/>"></div>
			<div class="menuIconText">
				Speech<br>Bubble
			</div>
		</div>
	</div>
	<div class="menuIcon" onclick='inputIcon();'>
		<div class="btn_td" align="center">
			<div style="margin-top: 10px;"><img class="editor_side_btn" src="<c:url value='/images/geoImg/write/editor_image_icon.png'/>"></div>
			<div class="menuIconText">
				Image
			</div>
		</div>
	</div>
	<div class="menuIcon" onclick='inputGeometry();'>
		<div class="btn_td" align="center">
			<div style="margin-top: 10px;"><img class="editor_side_btn" src="<c:url value='/images/geoImg/write/editor_geometry_icon.png'/>" ></div>
			<div class="menuIconText">
				Geometry
			</div>
		</div>
	</div>
	<div class="menuIcon" onclick='dataChangeClick();'>
		<div class="btn_td" align="center">
			<div style="margin-top: 10px;"><img class="editor_side_btn" src="<c:url value='/images/geoImg/write/editor_data_icon.png'/>" ></div>
			<div class="menuIconText">
				Data
			</div>
		</div>
	</div>
</div>

<!-- 탭 , 공유 우저 영역 -->
<!-- <div id="showInfoDiv" style="position:absolute; left:805px; top:13px; color:white;display: none;"> -->
<!-- 	<div style="margin-top: 5px;"> Sharing settings : <label id="shareKindLabel" style="display: block;"></label></div> -->
<!-- </div> -->

<!-- 비디오 영역 -->
<div id='video_main_area' style='position:absolute; left:60px; top:0px; width:780px; height:545px; display:block; border-right:1px solid #ebebeb; overflow: hidden;'>
<!-- 	<video id='video_player' width='760' height='500' controls='true' style='position:absolute; left:10px; top:10px;'> -->
<!-- 		<source id='video_src' src='' type='video/ogg'></source> -->
<!-- 		<source src="http://localhost:8088/GeoCMS/upload/GeoVideo/aaaaa(1)_ogg.ogg" type="video/ogg" /> -->
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
<!-- 	</video> -->
	<video id='video_player0' width='760' height='460' style='position:absolute; left:0px; top:0px; border: 1px solid gray;' preload="metadata">
		<source type='video/mp4'></source>
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
		Supported in HTML5-enabled browsers (Firefox 3.6 or later or Chrome).
	</video>
	
	<video id='video_player1' class='multi_class' width='387' height='230' style='position:absolute; left:0px; top:0px; display: none;' preload="metadata">
		<source type='video/mp4'></source>
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
		Supported in HTML5-enabled browsers (Firefox 3.6 or later or Chrome).
	</video>
	<video id='video_player2' class='multi_class' width='387' height='230' style='position:absolute; left:393px; top:0px; display: none;' preload="metadata" >
		<source type="video/mp4" />
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
		Supported in HTML5-enabled browsers (Firefox 3.6 or later or Chrome).
	</video>
	<video id='video_player3' class='multi_class' width='387' height='230' style='position:absolute; left:0px; top:230px; display: none;' preload="metadata" >
		<source type="video/mp4" />
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
		Supported in HTML5-enabled browsers (Firefox 3.6 or later or Chrome).
	</video>
	<video id='video_player4' class='multi_class' width='387' height='230' style='position:absolute; left:393px; top:230px; display: none;' preload="metadata" >
		<source type="video/mp4" />
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
		Supported in HTML5-enabled browsers (Firefox 3.6 or later or Chrome).
	</video>
</div>

<div id="buttonbar" style="position: absolute;left: 80px;top: 470px;">
	<input type="range" id="seekBar" value="0" style="display: block; margin-left: 20px; width: 700px; margin-bottom: 0px; margin-top: 0px;">
	<p style="margin: 0 auto; margin-left: 40px;">
		<img class="videoControlImg" src="<c:url value='/images/geoImg/video/video_sound.png'/>" id="sound" onclick="mute();" style="width: 20px; padding-bottom: 6px; cursor: pointer;"/>
		<input type="range" id="volumecontrol" min="0" max="1" step="0.1" value="1" style="width: 50px; padding-bottom: 8px;" onchange="updateVolume();">
		<img class="videoControlImg" src="<c:url value='/images/geoImg/video/video_stop.png'/>" id="restart" onclick="restart('');" style="width: 35px; margin-right: 10px; margin-left: 150px; cursor: pointer;"/>
		<img class="videoControlImg" src="<c:url value='/images/geoImg/video/video_back.png'/>" id="rew" onclick="skip(-10);" style="width: 20px; padding: 7px 8px 7px 7px; margin-right: 10px; cursor: pointer;"/>
		<img class="videoControlImg" src="<c:url value='/images/geoImg/video/video_pause.png'/>" id="play" onclick="vidplay();" style="width: 35px; margin-right: 10px; cursor: pointer;"/>
		<img class="videoControlImg" src="<c:url value='/images/geoImg/video/video_front.png'/>" id="fastFwd" onclick="skip(10)" style="width: 20px; padding: 7px 8px 7px 7px; margin-right: 10px; cursor: pointer;"/>
	</p>
	
<!--     <button id="restart" onclick="restart('');" style="display: block;float: left;">[]</button>  -->
    <!-- <button id="rew" onclick="skip(-10)" style="display: block;float: left; margin-left: 10px;">&lt;&lt;</button>
    <button id="play" onclick="vidplay()" style="display: block;float: left; margin-left: 10px;">&gt;</button>
    <button id="fastFwd" onclick="skip(10)" style="display: block;float: left; margin-left: 10px;">&gt;&gt;</button> -->
<!--     <input type="range" id="volumecontrol" min="0" max="1" step="0.1" value="1" style="display: block; with: 70px;" onchange="updateVolume();"> -->
<!--     <button onclick="mute();" style="margin-left: 10px;">Mute</button> -->
</div> 

<!-- 프레임 영역 -->
<div id='video_frame_area' style='position:absolute;left: 60px;top: 540px;width:780px;height:100px;display:block;border:1px solid #999999;overflow:scroll;'>
	<div style='position:absolute; left:50px; width:6000px; height:30px; background-image: url(<c:url value="/images/geoImg/write/timeline_time.png"/>);'></div>
	<button class='frame_plus' style='position:absolute; left:0px; top:30px; width:25px; height:25px;' onclick='createFrameLine(2);'>Plus</button>
	<button class='frame_minus' style='position:absolute; left:25px; top:30px; width:25px; height:25px;' onclick='removeFrameLine();'>Minus</button>
	<div id='video_obj_area' style='position:absolute; left:50px; top:30px; width:6000px; height:25px; background:#CCF;'>
		<div id='video_guide' style='position:absolute; left:0px; top:-30px; width:2px; height:30px; background:#F00;'></div>
	</div>
</div>

<!-- 후보군 영역 -->
<%-- <div id="etc_title" style="position:absolute; left:800px; top:73px; width:330px; height:50px;"><img src="<c:url value='/images/geoImg/title_03.gif'/>"></div> --%>
<!-- <div id='video_candidate_area' style='position:absolute; left:800px; top:92px; width:330px; height:245px; display:block; border:1px solid #999999; overflow-y:scroll;'> -->
<!-- 	<table id='candidate_table'> -->
<!-- 		<tr style='font-size:12px; height:20px;' class="col_black"> -->
<!-- 			<td width=10 align='center'></td> -->
<!-- 			<td width=50 align='center' style='color:#FFF;'>ID</td> -->
<!-- 			<td width=130 align='center' style='color:#FFF;'>Name</td> -->
<!-- 			<td width=60 align='center' style='color:#FFF;'>X1</td> -->
<!-- 			<td width=60 align='center' style='color:#FFF;'>X2</td> -->
<!-- 		</tr> -->
<!-- 	</table> -->
<!-- </div> -->

<!-- 추가 객체 영역 -->
<%-- <div id="ioa_title" style="position:absolute; left:800px; top:345px; width:330px; height:50px;"><img src="<c:url value='/images/geoImg/title_02.jpg'/>" alt="Add Object List"></div> --%>
<!-- <div id='video_object_area' style='position:absolute; left:800px; top:365px; width:330px; height:210px; display:block; border:1px solid #999999; overflow-y:scroll;'> -->
<!-- 	<table id='object_table'> -->
<!-- 		<tr style='font-size:12px; height:20px;' class='col_black'> -->
<!-- 			<td width=50 class='anno_head_tr'>ID</td> -->
<!-- 			<td width=80 class='anno_head_tr'>Type</td> -->
<!-- 			<td width=180 class='anno_head_tr'>Data</td> -->
<!-- 		</tr> -->
<!-- 	</table> -->
<!-- </div> -->

<!-- EXIF 삽입 다이얼로그 객체 -->
	<div style="position:absolute; left:841px; top:0px; width:292px; display:block; font-size:13px; height: 30px; border-bottom : 1px solid #ebebeb;">
		<label style="padding: 5px 10px;line-height: 30px;font-size: 13px;">Video Infomation</label>
		<button id="exifViewOff" class="smallWhiteBtn" onclick="exifViewFunction('off');" style="display:none; float: right;height:25px; margin: 3px 10px;" align="center">HIDE</button>
		<button id="exifViewOn" class="smallWhiteActiveBtn" onclick="exifViewFunction('on');" style="display:block;height:25px;float: right;margin: 3px 10px;" align="center">SHOW</button>
	</div>
	<div id='image_exif_area' style='display:none; width: 292px; background: #ffffff;position: absolute;top: 31px;border-bottom: 1px solid rgb(235, 235, 235);left: 841px;z-index:2;'>
		<!-- EXIF 삽입 다이얼로그 객체 -->
		<table style="width: 100%;">
			<tr>
				<td id="tabs_1" onclick="fnViewTabs(1);" class="infoTabs selectExifTabTitle">
					<label style="padding: 5px;display: inline-block;">Data Info</label>
				</td>
				<td id="tabs_2" onclick="fnViewTabs(2);" class="infoTabs noSlectExifTabTitle">
					<label style="padding: 5px;display: inline-block;">Object Data</label>
				</td>
				<td style="padding: 0px; width:34%;border-bottom: 1px solid #ebebeb;">
					<div id="tabs_3"></div>
				</td>
			</tr>
		</table>
		<div id="tabsChild_1" style='height: 195px;' class="selectExifTabChild">
			<table id='normal_exif_table' style="margin-top: 10px;">
				<tr><td width='15'></td><td width='80'><label class="tableLabel">Title</label></td><td width='160'><input class="normalTextInput" id='title_text' name='text' type='text' readonly/></td></tr>
				<tr><td width='15'></td><td width='80'><label class="tableLabel">Content</label></td><td width='160'><textarea class="normalTextInput" id='content_text' name='text' style='font-size:12px;width: 98%;height: 50px;' readonly></textarea></td></tr>
				<tr><td width='15'></td><td width='80'><label class="tableLabel">Sharing settings</label></td><td width='160'><input class="normalTextInput" id='share_text' name='text' type='text' readonly/></td></tr>
				<tr><td width='15'></td><td width='80'><label class="tableLabel">Drone Type</label></td><td width='160'><input class="normalTextInput" id='drone_text' name='text' type='text' readonly/></td></tr>
			</table>
		</div>
		<div id="tabsChild_2" style='height: 235px; overflow-y:scroll;' class="noSelectExifTabChild">
			<table id='object_table'>
				<tr style='font-size:12px; height:20px;' class='col_black'>
					<td width='50' class='anno_head_tr'>ID</td>
					<td width='80' class='anno_head_tr'>Type</td>
					<td width='160' class='anno_head_tr'>Data</td>
				</tr>
			</table>
		</div>
	</div>

<!-- 지도 영역 -->
<div id='video_map_area' style='position: absolute;left: 841px;top: 31px;width: 292px;height: 609px;display: block;z-index: 1;'>
	<iframe id='openlayers' src='<c:url value="/geoVideo/video_openlayers.do"/>' style='width:100%; height:100%; margin:1px; border:none;'></iframe>
</div>

<!----------------------------------------------------- 서브 영역 ------------------------------------------------------------->

<!-- 말풍선 삽입 다이얼로그 객체 -->
<div id='bubble_dialog' style='display:none; position: absolute;left: 60px;top: 461px; background-color: rgb(229, 229, 229);width: 778px; border: 1px solid #ebebeb;'>
	<div style='display:table; width:100%; height:100%;'>
		<div align="left" style='display:table-cell; vertical-align:middle;'>
			<table border='0' style="width: 100%;">
				<tr>
					<td width=65 style="padding-left: 20px;"><label style="font-size:12px;font-weight: bold;">Font Size  </label></td>
					<td><select id="bubble_font_select" style="font-size:12px;width: 100px;"><option>Normal<option>H3<option>H2<option>H1</select></td>
					<td><label style="font-size:12px;margin-left: 15px;font-weight: bold;">Font Color  </label></td>
					<td><input id="bubble_font_color" type="text" class="iColorPicker" value="#FFFFFF" style="width: 100px;background-color: rgb(0, 0, 0); margin-left: 5px;text-align: center;"/></td>
					<td><label style="font-size:12px;margin-left: 15px;font-weight: bold;">BG Color  </label></td>
					<td><input id="bubble_bg_color" type="text" class="iColorPicker" value="#000000" style="width: 100px;background-color: rgb(255, 255, 255);margin-left: 5px; text-align: center;"/></td>
					<td id='bubble_checkbox_td'><input type="checkbox" name="bubble_bg_checkbok" style="margin-left: 20px;font-weight: bold;" onclick="checkBubble();"/><label style=" font-size:12px;">Transparency</label></td>
					<td rowspan="3" style="width: 30px;background-color: #ffffff;margin-left: 50px;font-size: 20px;text-align: center; cursor: pointer;" onclick="closeBubbleConfirm();">x</td>
				</tr>
				<tr style="height: 1px;border-bottom: 1px solid #999999;"><td colspan='7'></td></tr>
				<tr><td colspan='7' id='bubble_check' style="padding: 5px 20px;"></td></tr>
			</table>
		</div>
	</div>
</div>

<!-- 이미지 삽입 다이얼로그 객체 -->
<div id='icon_dialog' style='display:none; position: absolute;left: 61px;top: 460px;background-color: rgb(229, 229, 229);width: 778px;'>
	<div id='icon_div1' style='position:absolute; width:750px; height:80px; background-color: rgb(229, 229, 229);overflow-x:auto;'>
		<table id='icon_table1' border="0">
			<tr>
				<td><img id='icon_img1' src=''></td><td><img id='icon_img2' src=''></td><td><img id='icon_img3' src=''></td><td><img id='icon_img4' src=''></td><td><img id='icon_img5' src=''></td><td><img id='icon_img6' src=''></td><td><img id='icon_img7' src=''></td><td><img id='icon_img8' src=''></td><td><img id='icon_img9' src=''></td><td><img id='icon_img10' src=''></td><td><img id='icon_img11' src=''></td><td><img id='icon_img12' src=''></td><td><img id='icon_img13' src=''></td><td><img id='icon_img14' src=''></td><td><img id='icon_img15' src=''></td><td><img id='icon_img16' src=''></td><td><img id='icon_img17' src=''></td><td><img id='icon_img18' src=''></td><td><img id='icon_img19' src=''></td><td><img id='icon_img20' src=''></td>
				<td><img id='icon_img21' src=''></td><td><img id='icon_img22' src=''></td><td><img id='icon_img23' src=''></td><td><img id='icon_img24' src=''></td><td><img id='icon_img25' src=''></td><td><img id='icon_img26' src=''></td><td><img id='icon_img27' src=''></td><td><img id='icon_img28' src=''></td><td><img id='icon_img29' src=''></td><td><img id='icon_img30' src=''></td><td><img id='icon_img31' src=''></td><td><img id='icon_img32' src=''></td><td><img id='icon_img33' src=''></td><td><img id='icon_img34' src=''></td><td><img id='icon_img35' src=''></td><td><img id='icon_img36' src=''></td><td><img id='icon_img37' src=''></td><td><img id='icon_img38' src=''></td><td><img id='icon_img39' src=''></td><td><img id='icon_img40' src=''></td>
				<td><img id='icon_img41' src=''></td><td><img id='icon_img42' src=''></td><td><img id='icon_img43' src=''></td><td><img id='icon_img44' src=''></td><td><img id='icon_img45' src=''></td><td><img id='icon_img46' src=''></td><td><img id='icon_img47' src=''></td><td><img id='icon_img48' src=''></td><td><img id='icon_img49' src=''></td><td><img id='icon_img50' src=''></td><td><img id='icon_img51' src=''></td><td><img id='icon_img52' src=''></td><td><img id='icon_img53' src=''></td><td><img id='icon_img54' src=''></td><td><img id='icon_img55' src=''></td><td><img id='icon_img56' src=''></td><td><img id='icon_img57' src=''></td><td><img id='icon_img58' src=''></td><td><img id='icon_img59' src=''></td><td><img id='icon_img60' src=''></td>
				<td><img id='icon_img61' src=''></td><td><img id='icon_img62' src=''></td><td><img id='icon_img63' src=''></td><td><img id='icon_img64' src=''></td><td><img id='icon_img65' src=''></td><td><img id='icon_img66' src=''></td><td><img id='icon_img67' src=''></td><td><img id='icon_img68' src=''></td><td><img id='icon_img69' src=''></td><td><img id='icon_img70' src=''></td><td><img id='icon_img71' src=''></td><td><img id='icon_img72' src=''></td><td><img id='icon_img73' src=''></td><td><img id='icon_img74' src=''></td><td><img id='icon_img75' src=''></td>
			</tr>
			<tr>
				<td><img id='icon_img76' src=''></td><td><img id='icon_img77' src=''></td><td><img id='icon_img78' src=''></td><td><img id='icon_img79' src=''></td><td><img id='icon_img80' src=''></td>
				<td><img id='icon_img81' src=''></td><td><img id='icon_img82' src=''></td><td><img id='icon_img83' src=''></td><td><img id='icon_img84' src=''></td><td><img id='icon_img85' src=''></td><td><img id='icon_img86' src=''></td><td><img id='icon_img87' src=''></td><td><img id='icon_img88' src=''></td><td><img id='icon_img89' src=''></td><td><img id='icon_img90' src=''></td><td><img id='icon_img91' src=''></td><td><img id='icon_img92' src=''></td><td><img id='icon_img93' src=''></td><td><img id='icon_img94' src=''></td><td><img id='icon_img95' src=''></td><td><img id='icon_img96' src=''></td><td><img id='icon_img97' src=''></td><td><img id='icon_img98' src=''></td><td><img id='icon_img99' src=''></td><td><img id='icon_img100' src=''></td>
				<td><img id='icon_img101' src=''></td><td><img id='icon_img102' src=''></td><td><img id='icon_img103' src=''></td><td><img id='icon_img104' src=''></td><td><img id='icon_img105' src=''></td><td><img id='icon_img106' src=''></td><td><img id='icon_img107' src=''></td><td><img id='icon_img108' src=''></td><td><img id='icon_img109' src=''></td><td><img id='icon_img110' src=''></td><td><img id='icon_img111' src=''></td><td><img id='icon_img112' src=''></td><td><img id='icon_img113' src=''></td><td><img id='icon_img114' src=''></td><td><img id='icon_img115' src=''></td><td><img id='icon_img116' src=''></td><td><img id='icon_img117' src=''></td><td><img id='icon_img118' src=''></td><td><img id='icon_img119' src=''></td><td><img id='icon_img120' src=''></td>
				<td><img id='icon_img121' src=''></td><td><img id='icon_img122' src=''></td><td><img id='icon_img123' src=''></td><td><img id='icon_img124' src=''></td>
			</tr>
		</table>
	</div>
	<div style="width: 30px;background-color: #ffffff;font-size: 20px;text-align: center;cursor: pointer;position: absolute;left: 751px;top: 0px;height: 80px;line-height: 80px;" onclick="closeBubbleConfirm();">x</div>
</div>

<!-- Geometry 삽입 다이얼로그 객체 -->
<div id='geometry_dialog' style='display:none; position: absolute;left: 61px;top: 461px;background-color: rgb(229, 229, 229);width: 778px; border: 1px solid #ebebeb;'>
	<div style='display:table; width:100%; height:100%;'>
		<div align="center" style='display:table-cell; vertical-align:middle;'>
			<table id='geometry_table' border="0" style="width: 100%;">
				<tr>
					<td style="padding:5px 15px;"><label style="font-size:12px;">Line Color  </label>
					<input id="geometry_line_color" type="text" class="iColorPicker" value="#999999" style="width:80px; margin-left: 8px;"/>
					&nbsp;&nbsp;&nbsp;
					<label style="font-size:12px;">MouseOver Color  </label>
					<input id="geometry_bg_color" type="text" class="iColorPicker" value="#FF0000" style="width:80px; margin-left: 8px;"/></td>
					
					<td><label style="font-size:12px;">Shape Style  </label>
					<input type='radio' name='geo_shape' value='circle' onclick="setGeometry('circle');"><label style="font-size:12px;">Circle</label>
					<input type='radio' name='geo_shape' value='rect' onclick="setGeometry('rect');"><label style="font-size:12px;">Rect</label>
					<input type='radio' name='geo_shape' value='point' onclick="setGeometry('point');"><label style="font-size:12px;">Point</label></td>
					
					<td style="width: 30px;background-color: #ffffff;margin-left: 50px;font-size: 20px;text-align: center; cursor: pointer;" onclick="closeBubbleConfirm();">x</td>
<!-- 					<td rowspan='3'><button class="ui-state-default ui-corner-all" style="width:80px; height:30px; font-size:12px;" onclick="setGeometry();">Confirm</button></td> -->
				</tr>
			</table>
		</div>
	</div>
</div>

<div id='data_dialog' style='display:none; font-size:13px; position: absolute;left: 61px;top: 373px;background-color: rgb(229, 229, 229);width: 778px; border: 1px solid #ebebeb;'>
	<div style='display:table; width:100%; height:100%;'>
		<div align="center" style='display:table-cell; vertical-align:middle;'>
			<table id="upload_table" border='0' style="width:100%;">
				<tr>
					<td colspan="2">
<!-- 						<div><input type="radio" value="0" name="shareRadio">비공개</div> -->
<!-- 						<div><input type="radio" value="1" name="shareRadio">전체공개</div> -->
<!-- 						<div><input type="radio" value="2" name="shareRadio" onclick="videoGetShareUser();">특정인 공개</div> -->
						<div><input type="radio" value="0" name="shareRadio">private</div>
						<div><input type="radio" value="1" name="shareRadio">public</div>
<!-- 						<div><input type="radio" value="2" name="shareRadio" onclick="videoGetShareUser();">sharing with friends</div> -->
						
						<div style="float: right;">Drone Type <input type="checkbox" id="droneTypeChk"></div>
					</td>
					<td rowspan="5" style="width: 30px;background-color: #ffffff;margin-left: 50px;font-size: 20px;text-align: center; cursor: pointer;" onclick="closeBubbleConfirm();">x</td>
				</tr>
				<tr class='tr_line'><td colspan='2'><hr/></td></tr>
				<tr>
					<td width="40">TITLE</td>
					<td>
						<input id="title_area" type="text">
					</td>
				</tr>
				<tr class='tr_line'><td colspan='2'><hr/></td></tr>
				<tr>
					<td>CONTENT</td>
					<td>
						<textarea id="content_area" style="height:60px;"></textarea>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
<!----------------------------------------------------- 서브 영역 ------------------------------------------------------------->

<input type="hidden" id="shareAdd"/>
<input type="hidden" id="shareRemove"/>
<input type="hidden" id="editYes"/>
<input type="hidden" id="editNo"/>
<div id="clonSharUser" style="display:none;"></div>

<!-- 오른클릭 Context Menu -->
<div id="context1" class="contextMenu">
	<ul>
		<li id="context_modify">Modify</li>
		<li id="context_delete">Delete</li>
	</ul>
</div>
<div id="context2" class="contextMenu">
	<ul>
		<li id="context_delete">Delete</li>
	</ul>
</div>

<!-- 편집기 버튼 영역 -->
<div style="width:100%; position: absolute;top:640px;" align="center" class="writer_btn_class">

	<form id="formImport" enctype="multipart/form-data" style="display:none;">
		<input type='file' name='file' id='file'/>
	</form>
	<button class='smallBlueBtn' style='margin-top:15px;' onclick='fnImportUrbanJson();'>Import</button>

	<button class='smallBlueBtn' style='margin-top:15px;' onclick='saveVideoWrite1(1);'>Save</button>
	<button class='smallWhiteBtn' style='margin-top:15px;margin-left:5px;margin-right: 10px;' onclick='saveVideoWrite1(3);'>view XML</button>
	<button class='smallBlueBtn' style='margin-top:15px;' onclick='javascript:close();'>close</button>
</div>

</body>
</html>
