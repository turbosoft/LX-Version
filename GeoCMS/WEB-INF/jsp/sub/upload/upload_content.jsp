<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<jsp:include page="../../page_common.jsp"></jsp:include>

<%
String loginId = (String)session.getAttribute("loginId");				//로그인 아이디
String loginToken = (String)session.getAttribute("loginToken");			//로그인 token

String makeContentIdx = request.getParameter("projectId");			// 선택한 프로젝트 인덱스
%>

<style type="text/css">

#upload_table tr
{
	border-top:1px solid #E0E0E1;
	border-bottom: 1px solid #E0E0E1;
}

th, td
{
	padding:10px;
}

#upload_table tr th
{
	background-color:#F2F3F5;
}
/* The container Check*/
.containerCheck {
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

/* Hide the browser's default checkbox */
.containerCheck input {
    position: absolute;
    opacity: 0;
    cursor: pointer;
    height: 0;
    width: 0;
}

/* Create a custom checkbox */
.checkmarkCheck {
    position: absolute;
    top: 0;
    left: 0;
    height: 20px;
    width: 20px;
    background-color: #ffffff;
    border:1px solid #297ACC;
    
}

/* On mouse-over, add a grey background color */
.containerCheck:hover input ~ .checkmarkCheck {
    background-color: #ccc;
}

/* When the checkbox is checked, add a blue background */
.containerCheck input:checked ~ .checkmarkCheck {
    background-color: #2196F3;
}

/* Create the checkmark/indicator (hidden when not checked) */
.checkmarkCheck:after {
    content: "";
    position: absolute;
    display: none;
}

/* Show the checkmark when checked */
.containerCheck input:checked ~ .checkmarkCheck:after {
    display: block;
}

/* Style the checkmark/indicator */
.containerCheck .checkmarkCheck:after {
    left: 7px;
    top: 2px;
    width: 5px;
    height: 10px;
    border: solid white;
    border-width: 0 3px 3px 0;
    -webkit-transform: rotate(45deg);
    -ms-transform: rotate(45deg);
    transform: rotate(45deg);
}


/* The container Radio*/
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

/* content style */
.contentUploadTr {
	display: none;
}

.file_input_div_video {
	margin: 0;
	height: auto;
}

.file_input_img_btn_video {
	margin: 0;
}

.file_input_hidden_video_s, .file_input_hidden_video_m, .file_input_hidden_gps, .file_input_hidden_json {
	font-size: 13px;
}
</style>

<script type="text/javascript">
var loginId = '<%= loginId %>';					//로그인 아이디
var loginToken = '<%= loginToken %>';			//로그인 token
var makeContentIdx = '<%= makeContentIdx %>';	//선택한 프로젝트 인덱스
var viewFileArr = new Array();
var projectNameArr = new Array();		//project name array
var projectIdxArr = new Array();		//project idx array

var inputAttrList = new Array();

$(function() {
	inputAttrList = new Array();
	getVideoUpProjectList();
	$('#upload_table tr td').css('fontSize', 12);
	
	// 속성 및 타입 불러오기
	var Url			= baseRoot() + "pgm/getLayer/";
	var param		= makeContentIdx;
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
				fnSetInputColumns(data.Data, data.userData);
			} else{
				jAlert(data.Message, 'Info');
			}
		}
	});
});

function fnSetInputColumns(data, userData) {
	// 4가지 타입 중 어떤 타입이 있는 확인
	var isVideo = false;
	var isPhoto = false;
	var isSensor = false;
	var isTraj = false;
	
	var sensorAttrList = ["accx", "accy", "accz", "gyrox", "gyroy", "gyroz"];
	
// 	var inputAttrList = new Array();
	
	$.each(data, function(idx, val) {
		if (val.type == "USER-DEFINED") {
			$.each(userData, function(idx2, val2) {
				if(val2.type == "mvideo")
				{
					isVideo = true;
				}
				else if (val2.type == "mpoint") 
				{
					isTraj = true;
				} 
				else if (val2.type == "stphoto") 
				{
					isPhoto = true;
				} 
				else if ($.inArray(val.attr, sensorAttrList) != -1) 
				{
					isSensor = true;
				} 
			});
		} else {
			inputAttrList.push(val.attr);
		}
	});
	
	var target = $("#targetTr");
	
	var content = "";
	$.each(inputAttrList, function(idx, val) {
		if(val != "idxseq")
		{
			content += "<tr>";
			content += 		"<th align='center' style='width:80px;'>" + val + "</th>";
			content += 		"<td align='center'><input type='text' id='" + val + "' name='" + val + "' style='width:300px;'/></td>";
			content += "</tr>";
		}
	});
	
	target.before(content);
	
	if (!isVideo) {
		$(".v_tr").remove();
		$("#contentSelTopDiv_v").remove();
	}
	
	if (!isPhoto) {
		$(".p_tr").remove();
		$("#contentSelTopDiv_p").remove();
	}
	
	if (!isSensor) {
		$(".s_tr").remove();
		$("#contentSelTopDiv_s").remove();
	}
	
	if (!isTraj) {
		$(".t_tr").remove();
		$("#contentSelTopDiv_t").remove();
	}
	
// 	$($("#targetTr div")[0]).css("background-color", "#F2F3F5");
	$($("#targetTr div")[0]).click(); // 첫번째를 기본 클릭
}

//get proejct List
function getVideoUpProjectList(){
	var orderIdx  = '&nbsp';
	var tmeShareEdit = 'Y';
	var Url			= baseRoot() + "cms/getProjectList/";
	var param		= loginToken + "/" + loginId + "/" + orderIdx + "/" + tmeShareEdit;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			var response = data.Data;
			if(data.Code == '100'){
					projectNameArr = new Array();
					projectIdxArr = new Array();
					if(response != null && response.length > 0){
						$.each(response, function(idx, val){
							projectNameArr.push(val.projectname);
							projectIdxArr.push(val.idx);
						});
					}
			}else{
// 				jAlert('프로젝트 생성 후 컨텐츠를 업로드 할수 있습니다.', '정보');
				jAlert('You can upload content after creating a project.', 'Info');
				jQuery.FrameDialog.closeDialog();
			}
		}
	});
}

// video, photo, sensor, traj 별로 저장
function saveContent() {
	$.each($("[id^=contentSelTopDiv_]"), function(idx, val) {
		var saveType = this.id.split("_")[1];
		if (saveType == "v") {
			createVideoContent(); // video 저장
		} else if (saveType == "p") {
			createPhotoContent();
		} else if (saveType == "s") {
			createSensorContent();
		} else if (saveType == "t") {
			createTrajContent();
		}
	});
}

// 동영상 게시물 생성
function createVideoContent() {
	if(loginId != '' && loginId != null) {
		var title = $('#title_area').val();
		var content = document.getElementById('content_area').value;
// 		var projectIdxNum = $('#projectKind').val();
		var projectIdxNum = makeContentIdx;
		var droneType = '&nbsp';
		var chkVideoGps = '&nbsp';
		var m_s_check = 's';
		
		if($("#droneDataChk").is(":checked")){
			droneType = 'Y';
		}
		 
		//게시물 정보 전송 설정
		if(title == null || title == "" || title == 'null'){
// 			jAlert('제목을 입력해 주세요.', '정보');
			jAlert('Please enter the title.', 'Info');
			$('#title_area').focus();
			return;
		}
		 
		if(content == null || content == "" || content == 'null'){
// 			jAlert('내용을 입력해 주세요.', '정보');
			jAlert('Please enter your details.', 'Info');
			$('#content_area').focus();
			return;
		}
		
		if(title != null && title.indexOf('\'') > -1){
// 			jAlert('제목에 특수문자 \' 는 사용할 수 없습니다.', '정보');
			jAlert('Can not use special character \' in title.', 'Info');
			return;
		}
		 
		if(content != null && content.indexOf('\'') > -1){
// 			jAlert('내용에 특수문자 \' 는 사용할 수 없습니다.', '정보');
			jAlert('Can not use special character \' in content.', 'Info');
			 return;
		}
		
		
		if(m_s_check == 's'){
			var tmpFile1 = $('#file_video').val();
			var tmpFile2 = $('#file_photo').val();
			var tmpFile3 = $('#gpx_2').val();
			if(tmpFile1 == null || tmpFile1 == undefined || tmpFile1 == ''){
				if(tmpFile2 == null || tmpFile2 == undefined || tmpFile2 == ''){
					if(tmpFile3 == null || tmpFile3 == undefined || tmpFile3 == ''){
		//	 			jAlert('컨텐츠를 선택해 주세요.', '정보');
						jAlert('Please select content.', 'Info');
						return;
					}
				}
			}
		}else{
			jAlert('System Error.', 'Info');
			return;
		}
		var chkFileIn = false;
		$.each($('.file_input_hidden_gps'),function(idx,val){
			if($(val).val() != null && $(val).val() != undefined && $(val).val() != ''){
				chkFileIn = true;
			}
		});
		/* if(!chkFileIn){
			jAlert('Please select gps file.', 'Info');
			return;
		} */
		
		$('#fileinfo').append($('.file_input_hidden_video_'+ m_s_check));
		$('#fileinfo').append($('.file_input_hidden_gps'));

		title = dataReplaceFun(title);
		content = dataReplaceFun(content);
		
		$('body').append('<div class="lodingOn"></div>');
		var iframe = $('<iframe name="postiframe" id="postiframe" style="display: none"></iframe>');
		$("body").append(iframe);
		
		var form = $('#fileinfo');
		var resAddress = baseRoot() + "cms/saveVideoAll/";
		resAddress += loginToken +"/"+ loginId +"/"+ title +"/"+ content +"/"+ projectIdxNum +"/"+droneType +"/2/"+ chkVideoGps;
		resAddress += "?callback=?";
		
		form.attr("action", resAddress);
		form.attr("method", "POST");
		
		form.attr("encoding", "multipart/form-data");
		form.attr("enctype", "multipart/form-data");
		
		form.attr("target", "postiframe");
		form.submit();
		
		$("#postiframe").load(function (e) {
			var doc = this.contentWindow ? this.contentWindow.document : (this.contentDocument ? this.contentDocument : this.document);
			var root = doc.documentElement ? doc.documentElement : doc.body;
			var data = root.textContent; ////////// ? root.textContent : root.innerText;
			data = data.replace("?","").replace("(","").replace(")","");
			var resData = JSON.parse(data);
			
			if(resData != null && resData != ''){
				if(resData.Code == 100){
					// pgmAPI save video
					fnSavePgmVideoContent(resData.logKey);
// 					window.parent.viewMyProjects(projectIdxNum);
// 					window.parent.closeUpload();
				}else{
					jAlert(resData.Message, 'Info', function(res){
						$('.lodingOn').remove();
					});
				}
			}else{
				$('.lodingOn').remove();
			}
		});
	}
	else {
		window.parent.closeUpload();
		jAlert('I lost my login information.', 'Info');
	}
}

function createTrajContent() {
	if(loginId != '' && loginId != null) {
		var title = $('#title_area').val();
		var content = document.getElementById('content_area').value;
// 		var projectIdxNum = $('#projectKind').val();
		var projectIdxNum = makeContentIdx;
		var droneType = '&nbsp';
		var chkVideoGps = '&nbsp';
		var m_s_check = 's';
		
		if($("#droneDataChk").is(":checked")){
			droneType = 'Y';
		}
		 
		//게시물 정보 전송 설정
		if(title == null || title == "" || title == 'null'){
// 			jAlert('제목을 입력해 주세요.', '정보');
			jAlert('Please enter the title.', 'Info');
			$('#title_area').focus();
			return;
		}
		 
		if(content == null || content == "" || content == 'null'){
// 			jAlert('내용을 입력해 주세요.', '정보');
			jAlert('Please enter your details.', 'Info');
			$('#content_area').focus();
			return;
		}
		
		if(title != null && title.indexOf('\'') > -1){
// 			jAlert('제목에 특수문자 \' 는 사용할 수 없습니다.', '정보');
			jAlert('Can not use special character \' in title.', 'Info');
			return;
		}
		 
		if(content != null && content.indexOf('\'') > -1){
// 			jAlert('내용에 특수문자 \' 는 사용할 수 없습니다.', '정보');
			jAlert('Can not use special character \' in content.', 'Info');
			 return;
		}
		
		
		if(m_s_check == 's'){
			var tmpFile1 = $('#file_video').val();
			var tmpFile2 = $('#file_photo').val();
			var tmpFile3 = $('#gpx_2').val();
			if(tmpFile1 == null || tmpFile1 == undefined || tmpFile1 == ''){
				if(tmpFile2 == null || tmpFile2 == undefined || tmpFile2 == ''){
					if(tmpFile3 == null || tmpFile3 == undefined || tmpFile3 == ''){
		//	 			jAlert('컨텐츠를 선택해 주세요.', '정보');
						jAlert('Please select content.', 'Info');
						return;
					}
				}
			}
		}else{
			jAlert('System Error.', 'Info');
			return;
		}
		var chkFileIn = false;
		$.each($('.file_input_hidden_gps'),function(idx,val){
			if($(val).val() != null && $(val).val() != undefined && $(val).val() != ''){
				chkFileIn = true;
			}
		});
		/* if(!chkFileIn){
			jAlert('Please select gps file.', 'Info');
			return;
		} */
		
		$('#fileinfo').append($('.file_input_hidden_video_'+ m_s_check));
		$('#fileinfo').append($('.file_input_hidden_gps'));

		title = dataReplaceFun(title);
		content = dataReplaceFun(content);
		
		$('body').append('<div class="lodingOn"></div>');
		var iframe = $('<iframe name="postiframe" id="postiframe" style="display: none"></iframe>');
		$("body").append(iframe);
		
		var form = $('#fileinfo');
		var resAddress = baseRoot() + "cms/saveTrajAll/";
		resAddress += loginToken +"/"+ loginId +"/"+ title +"/"+ content +"/"+ projectIdxNum +"/"+droneType +"/2/"+ chkVideoGps;
		resAddress += "?callback=?";
		
		form.attr("action", resAddress);
		form.attr("method", "POST");
		
		form.attr("encoding", "multipart/form-data");
		form.attr("enctype", "multipart/form-data");
		
		form.attr("target", "postiframe");
		form.submit();
		
		$("#postiframe").load(function (e) {
			var doc = this.contentWindow ? this.contentWindow.document : (this.contentDocument ? this.contentDocument : this.document);
			var root = doc.documentElement ? doc.documentElement : doc.body;
			var data = root.textContent; ////////// ? root.textContent : root.innerText;
			data = data.replace("?","").replace("(","").replace(")","");
			var resData = JSON.parse(data);
			
			if(resData != null && resData != ''){
				if(resData.Code == 100){
					// pgmAPI save video
					fnSavePgmTrajContent(resData.logKey);
// 					window.parent.viewMyProjects(projectIdxNum);
// 					window.parent.closeUpload();
				}else{
					jAlert(resData.Message, 'Info', function(res){
						$('.lodingOn').remove();
					});
				}
			}else{
				$('.lodingOn').remove();
			}
		});
	}
	else {
		window.parent.closeUpload();
		jAlert('I lost my login information.', 'Info');
	}
}
function createSensorContent() {
	if(loginId != '' && loginId != null) {
		var title = $('#title_area').val();
		var content = document.getElementById('content_area').value;
// 		var projectIdxNum = $('#projectKind').val();
		var projectIdxNum = makeContentIdx;
		var droneType = '&nbsp';
		var chkVideoGps = '&nbsp';
		var m_s_check = 's';
		
		if($("#droneDataChk").is(":checked")){
			droneType = 'Y';
		}
		 
		//게시물 정보 전송 설정
		if(title == null || title == "" || title == 'null'){
// 			jAlert('제목을 입력해 주세요.', '정보');
			jAlert('Please enter the title.', 'Info');
			$('#title_area').focus();
			return;
		}
		 
		if(content == null || content == "" || content == 'null'){
// 			jAlert('내용을 입력해 주세요.', '정보');
			jAlert('Please enter your details.', 'Info');
			$('#content_area').focus();
			return;
		}
		
		if(title != null && title.indexOf('\'') > -1){
// 			jAlert('제목에 특수문자 \' 는 사용할 수 없습니다.', '정보');
			jAlert('Can not use special character \' in title.', 'Info');
			return;
		}
		 
		if(content != null && content.indexOf('\'') > -1){
// 			jAlert('내용에 특수문자 \' 는 사용할 수 없습니다.', '정보');
			jAlert('Can not use special character \' in content.', 'Info');
			 return;
		}
		
		
		if(m_s_check == 's'){
			var tmpFile1 = $('#file_video').val();
			var tmpFile2 = $('#file_photo').val();
			var tmpFile3 = $('#json_1').val();
			if(tmpFile1 == null || tmpFile1 == undefined || tmpFile1 == ''){
				if(tmpFile2 == null || tmpFile2 == undefined || tmpFile2 == ''){
					if(tmpFile3 == null || tmpFile3 == undefined || tmpFile3 == ''){
		//	 			jAlert('컨텐츠를 선택해 주세요.', '정보');
						jAlert('Please select content.', 'Info');
						return;
					}
				}
			}
		}else{
			jAlert('System Error.', 'Info');
			return;
		}
		var chkFileIn = false;
		$.each($('.file_input_hidden_gps'),function(idx,val){
			if($(val).val() != null && $(val).val() != undefined && $(val).val() != ''){
				chkFileIn = true;
			}
		});
		/* if(!chkFileIn){
			jAlert('Please select gps file.', 'Info');
			return;
		} */
		
		$('#fileinfo').append($('.file_input_hidden_video_'+ m_s_check));
		$('#fileinfo').append($('.file_input_hidden_json'));

		title = dataReplaceFun(title);
		content = dataReplaceFun(content);
		
		$('body').append('<div class="lodingOn"></div>');
		var iframe = $('<iframe name="postiframe" id="postiframe" style="display: none"></iframe>');
		$("body").append(iframe);
		
		var form = $('#fileinfo');
		var resAddress = baseRoot() + "cms/saveSensorAll/";
		resAddress += loginToken +"/"+ loginId +"/"+ title +"/"+ content +"/"+ projectIdxNum +"/"+droneType +"/2/"+ chkVideoGps;
		resAddress += "?callback=?";
		
		form.attr("action", resAddress);
		form.attr("method", "POST");
		
		form.attr("encoding", "multipart/form-data");
		form.attr("enctype", "multipart/form-data");
		
		form.attr("target", "postiframe");
		form.submit();
		
		$("#postiframe").load(function (e) {
			var doc = this.contentWindow ? this.contentWindow.document : (this.contentDocument ? this.contentDocument : this.document);
			var root = doc.documentElement ? doc.documentElement : doc.body;
			var data = root.textContent; ////////// ? root.textContent : root.innerText;
			data = data.replace("?","").replace("(","").replace(")","");
			var resData = JSON.parse(data);
			
			if(resData != null && resData != ''){
				if(resData.Code == 100){
					// pgmAPI save video
					fnSavePgmSensorContent(resData.logKey);
// 					window.parent.viewMyProjects(projectIdxNum);
// 					window.parent.closeUpload();
				}else{
					jAlert(resData.Message, 'Info', function(res){
						$('.lodingOn').remove();
					});
				}
			}else{
				$('.lodingOn').remove();
			}
		});
	}
	else {
		window.parent.closeUpload();
		jAlert('I lost my login information.', 'Info');
	}
}

function createPhotoContent() {
	if(loginId != '' && loginId != null) {
		$('#fileinfoPhoto').append($('#file_photo'));	//선택 파일 버튼 폼객체에 추가
		
		var uploadFileLen = $('#fileinfoPhoto').children().length;
		if(uploadFileLen <= 0){
// 			 jAlert('컨텐츠를 선택해 주세요.', '정보');
			 jAlert('Please select content.', 'Info');
			 return;
		}
		
		//게시물 정보 전송 설정
		var title = $('#title_area').val();
		var content = document.getElementById('content_area').value;
// 		var projectIdxNum = $('#projectKind').val();
		var projectIdxNum = makeContentIdx;
		var droneType = '&nbsp';
		if( $(':checkbox[id="droneDataChk"]').is(":checked")){
			droneType = 'Y';
		}
		
		if(title == null || title == "" || title == 'null'){
// 			 jAlert('제목을 입력해 주세요.', '정보');
			 jAlert('Please enter the title.', 'Info');
			 $('#title_area').focus();
			 return;
		 }
		 
		 if(content == null || content == "" || content == 'null'){
// 			 jAlert('내용을 입력해 주세요.', '정보');
			 jAlert('Please enter your details.', 'Info');
			 $('#content_area').focus();
			 return;
		 }
		 
		 if(title != null && title.indexOf('\'') > -1){
// 			 jAlert('제목에 특수문자 \' 는 사용할 수 없습니다.', '정보');
			 jAlert('Can not use special character \' in title.', 'Info');
			 return;
		 }
		 
		 if(content != null && content.indexOf('\'') > -1){
// 			 jAlert('내용에 특수문자 \' 는 사용할 수 없습니다.', '정보');
			 jAlert('Can not use special character \' in content.', 'Info');
			 return;
		 }
		 
		 title = dataReplaceFun(title);
		 content = dataReplaceFun(content);
		 
		 $('input[name=uploadDateArr]').val(JSON.stringify(viewTimeArr));
		 
		 $('body').append('<div class="lodingOn"></div>');
		 var iframe = $('<iframe name="postiframe" id="postiframe" style="display: none"></iframe>');
         $("body").append(iframe);

         var form = $('#fileinfoPhoto');
         
         var resAddress = baseRoot() + "cms/saveImageAll/";
		 resAddress += loginToken + "/" + loginId + "/" + title + "/" + content + "/" + projectIdxNum + "/"+ droneType;
         resAddress += "?callback=?";
         
         form.attr("action", resAddress);
         form.attr("method", "POST");

         form.attr("encoding", "multipart/form-data");
         form.attr("enctype", "multipart/form-data");

         form.attr("target", "postiframe");
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
         			window.parent.viewMyProjects(projectIdxNum);
					jAlert(resData.Message, 'Info', function(res){
						window.parent.closeUpload();
						fnSavePgmImageContent(resData.logKey);
					});
					$('.lodingOn').remove();
				}else{
					jAlert(resData.Message, 'Info', function(res){
						$('.lodingOn').remove();
					});
				}
			}else{
				$('.lodingOn').remove();
			}
         });
	}
	else {
		window.parent.closeUpload();
// 		jAlert('로그인 정보를 잃었습니다.', '정보');
		jAlert('I lost my login information.', 'Info');
	}
}


function fnSavePgmVideoContent(logKey) {
	var dataObject = new Object();
	
	// logKey
	dataObject.logKey = logKey;
	
	// 일반 컬럼 데이터
	var object = new Object();
	$.each(inputAttrList, function(idx, val) {
		object[val] = $("#" + val).val();
	});
	
	dataObject.inputAttrData = object;
	dataObject.projectId = makeContentIdx;
	
	var iframe = $('<iframe name="videoframe" id="videoframe" style="display: none"></iframe>');
	$("body").append(iframe);
	
	var form = $('#fileinfo');
	var resAddress = baseRoot() + "pgm/addPgmVideoLayer/";
	resAddress += JSON.stringify(dataObject);
	resAddress += "?callback=?";
	
	form.attr("action", resAddress);
	form.attr("method", "POST");
	
	form.attr("encoding", "multipart/form-data");
	form.attr("enctype", "multipart/form-data");
	
	form.attr("target", "videoframe");
	form.submit();
	
	$("#videoframe").load(function (e) {
		var doc = this.contentWindow ? this.contentWindow.document : (this.contentDocument ? this.contentDocument : this.document);
		var root = doc.documentElement ? doc.documentElement : doc.body;
		var data = root.textContent; ////////// ? root.textContent : root.innerText;
		data = data.replace("?","").replace("(","").replace(")","");
		var resData = JSON.parse(data);
		
		if(resData != null && resData != ''){
			if(resData.Code == 100){
				jAlert(resData.Message, 'Info');
				window.parent.viewDataTable(makeContentIdx);
				window.parent.closeUpload();
			}else{
				jAlert(resData.Message, 'Info', function(res){
					$('.lodingOn').remove();
				});
			}
		}else{
			$('.lodingOn').remove();
		}
	});
	
	/* var Url			= baseRoot() + "pgm/addPgmVideoLayer/";
	var param		= JSON.stringify(dataObject);
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
				window.parent.viewDataTable(projectIdxNum);
// 				window.parent.viewMyProjects(projectIdxNum);
				window.parent.closeUpload();
			} else {
				jAlert(data.Message, 'Info');
			}
		}
	}); */
// 	window.parent.viewMyProjects(projectIdxNum);
// 	window.parent.closeUpload();
}
function fnSavePgmTrajContent(logKey) {
	var dataObject = new Object();
	
	// logKey
	dataObject.logKey = logKey;
	
	// 일반 컬럼 데이터
	var object = new Object();
	$.each(inputAttrList, function(idx, val) {
		object[val] = $("#" + val).val();
	});
	
	dataObject.inputAttrData = object;
	dataObject.projectId = makeContentIdx;
	
	var iframe = $('<iframe name="trajframe" id="trajframe" style="display: none"></iframe>');
	$("body").append(iframe);
	
	var form = $('#fileinfo');
	var resAddress = baseRoot() + "pgm/addPgmTrajLayer/";
	resAddress += JSON.stringify(dataObject);
	resAddress += "?callback=?";
	
	form.attr("action", resAddress);
	form.attr("method", "POST");
	
	form.attr("encoding", "multipart/form-data");
	form.attr("enctype", "multipart/form-data");
	
	form.attr("target", "trajframe");
	form.submit();
	
	$("#trajframe").load(function (e) {
		var doc = this.contentWindow ? this.contentWindow.document : (this.contentDocument ? this.contentDocument : this.document);
		var root = doc.documentElement ? doc.documentElement : doc.body;
		var data = root.textContent; ////////// ? root.textContent : root.innerText;
		data = data.replace("?","").replace("(","").replace(")","");
		var resData = JSON.parse(data);
		
		if(resData != null && resData != ''){
			if(resData.Code == 100){
				jAlert(resData.Message, 'Info');
				window.parent.viewDataTable(makeContentIdx);
				window.parent.closeUpload();
			}else{
				jAlert(resData.Message, 'Info', function(res){
					$('.lodingOn').remove();
				});
			}
		}else{
			$('.lodingOn').remove();
		}
	});
	
	/* var Url			= baseRoot() + "pgm/addPgmVideoLayer/";
	var param		= JSON.stringify(dataObject);
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
				window.parent.viewDataTable(projectIdxNum);
// 				window.parent.viewMyProjects(projectIdxNum);
				window.parent.closeUpload();
			} else {
				jAlert(data.Message, 'Info');
			}
		}
	}); */
// 	window.parent.viewMyProjects(projectIdxNum);
// 	window.parent.closeUpload();
}
function fnSavePgmSensorContent(logKey) {
	var dataObject = new Object();
	
	// logKey
	dataObject.logKey = logKey;
	
	// 일반 컬럼 데이터
	var object = new Object();
	$.each(inputAttrList, function(idx, val) {
		object[val] = $("#" + val).val();
	});
	
	dataObject.inputAttrData = object;
	dataObject.projectId = makeContentIdx;
	
	var iframe = $('<iframe name="trajframe" id="trajframe" style="display: none"></iframe>');
	$("body").append(iframe);
	
	var form = $('#fileinfo');
	var resAddress = baseRoot() + "pgm/addPgmSensorLayer/";
	resAddress += JSON.stringify(dataObject);
	resAddress += "?callback=?";
	
	form.attr("action", resAddress);
	form.attr("method", "POST");
	
	form.attr("encoding", "multipart/form-data");
	form.attr("enctype", "multipart/form-data");
	
	form.attr("target", "trajframe");
	form.submit();
	
	$("#trajframe").load(function (e) {
		var doc = this.contentWindow ? this.contentWindow.document : (this.contentDocument ? this.contentDocument : this.document);
		var root = doc.documentElement ? doc.documentElement : doc.body;
		var data = root.textContent; ////////// ? root.textContent : root.innerText;
		data = data.replace("?","").replace("(","").replace(")","");
		var resData = JSON.parse(data);
		
		if(resData != null && resData != ''){
			if(resData.Code == 100){
				jAlert(resData.Message, 'Info');
				window.parent.viewDataTable(makeContentIdx);
				window.parent.closeUpload();
			}else{
				jAlert(resData.Message, 'Info', function(res){
					$('.lodingOn').remove();
				});
			}
		}else{
			$('.lodingOn').remove();
		}
	});
	
	/* var Url			= baseRoot() + "pgm/addPgmVideoLayer/";
	var param		= JSON.stringify(dataObject);
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
				window.parent.viewDataTable(projectIdxNum);
// 				window.parent.viewMyProjects(projectIdxNum);
				window.parent.closeUpload();
			} else {
				jAlert(data.Message, 'Info');
			}
		}
	}); */
// 	window.parent.viewMyProjects(projectIdxNum);
// 	window.parent.closeUpload();
}
function fnSavePgmImageContent(logKey) {
	var dataObject = new Object();
	
	// logKey
	dataObject.logKey = logKey;
	
	// 일반 컬럼 데이터
	var object = new Object();
	$.each(inputAttrList, function(idx, val) {
		object[val] = $("#" + val).val();
	});
	dataObject.inputAttrData = object;
	dataObject.projectId = makeContentIdx;
	
	var fileName = viewFileArr[0].name;
	var fName = fileName.split(".");
	
	var iframe = $('<iframe name="postiframe" id="postiframe" style="display: none"></iframe>');
	$("body").append(iframe);
	
	var form = $('#fileinfoPhoto');
	var resAddress = baseRoot() + "pgm/addPgmImageLayer/";
	resAddress += JSON.stringify(dataObject)+"/"+fName[0]+"/"+fName[1];
	resAddress += "?callback=?";
	
	form.attr("action", resAddress);
	form.attr("method", "POST");
	
	form.attr("encoding", "multipart/form-data");
	form.attr("enctype", "multipart/form-data");
	
	form.attr("target", "postiframe");
	form.submit();
	
	$("#postiframe").load(function (e) {
		var doc = this.contentWindow ? this.contentWindow.document : (this.contentDocument ? this.contentDocument : this.document);
		var root = doc.documentElement ? doc.documentElement : doc.body;
		var data = root.textContent; ////////// ? root.textContent : root.innerText;
		data = data.replace("?","").replace("(","").replace(")","");
		var resData = JSON.parse(data);
		
		if(resData != null && resData != ''){
			if(resData.Code == 100){
				jAlert(resData.Message, 'Info');
				window.parent.viewDataTable(makeContentIdx);
				window.parent.closeUpload();
			}else{
				jAlert(resData.Message, 'Info', function(res){
					$('.lodingOn').remove();
				});
			}
		}else{
			$('.lodingOn').remove();
		}
	});
	
	/* var Url			= baseRoot() + "pgm/addPgmVideoLayer/";
	var param		= JSON.stringify(dataObject);
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
				window.parent.viewDataTable(projectIdxNum);
// 				window.parent.viewMyProjects(projectIdxNum);
				window.parent.closeUpload();
			} else {
				jAlert(data.Message, 'Info');
			}
		}
	}); */
// 	window.parent.viewMyProjects(projectIdxNum);
// 	window.parent.closeUpload();
}

//게시물 생성 취소
function cancelContent() {
// 	jConfirm('게시물 생성을 취소하시겠습니까?', '정보', function(type){
	jConfirm('Are you sure you want to cancel creating posts?', 'Info', function(type){
		window.parent.closeUpload();
	});
}

//file change
function fileChangeInfoVideo(obj){
	var objId = obj.id;
	var objFileName = "";
	$('#floorMap_pop_'+ objId).empty();
	$('#floorMap_pop_'+objId).css("display", "none");
	$('#btn_'+objId).css("display", "none");
	$('#file_input_div_'+objId).css("height", "auto");
	
	if(obj.files[0] != null && obj.files[0] != undefined){
		objFileName = obj.files[0].name;
		if(objFileName.length > 25){
			objFileName = objFileName.substring(0,20) + "...";
		}
		var tmpHtml = "<div title='"+ obj.files[0].name  +"' style='text-decoration:underline; color:gray;'>"+ objFileName +"</div>";
		$('#floorMap_pop_'+objId).append(tmpHtml);
		$('#floorMap_pop_'+objId).css("display", "");
		$('#btn_'+objId).css("display", "");
		$('#file_input_div_'+objId).css("height", "70px");
	}else{
		$('#'+objId).val(null);
	}
}

function fileChangeInfoTraj(obj){
	var objId = obj.id;
	var objFileName = "";
	$('#floorMap_pop_'+ objId).empty();
	$('#floorMap_pop_'+objId).css("display", "none");
	$('#btn_'+objId).css("display", "none");
	$('#file_input_div_'+objId).css("height", "auto");
	
	if(obj.files[0] != null && obj.files[0] != undefined){
		objFileName = obj.files[0].name;
		if(objFileName.length > 25){
			objFileName = objFileName.substring(0,20) + "...";
		}
		var tmpHtml = "<div title='"+ obj.files[0].name  +"' style='text-decoration:underline; color:gray; position:absolute;'>"+ objFileName +"</div>";
		$('#floorMap_pop_'+objId).append(tmpHtml);
		$('#floorMap_pop_'+objId).css("display", "");
		$('#btn_'+objId).css("display", "");
		$('#file_input_div_'+objId).css("height", "70px");
	}else{
		$('#'+objId).val(null);
	}
}
function fileChangeInfoSensor(obj){
	var objId = obj.id;
	var objFileName = "";
	$('#floorMap_pop_'+ objId).empty();
	$('#floorMap_pop_'+objId).css("display", "none");
	$('#btn_'+objId).css("display", "none");
	$('#file_input_div_'+objId).css("height", "auto");
	
	if(obj.files[0] != null && obj.files[0] != undefined){
		objFileName = obj.files[0].name;
		if(objFileName.length > 25){
			objFileName = objFileName.substring(0,20) + "...";
		}
		var tmpHtml = "<div title='"+ obj.files[0].name  +"' style='text-decoration:underline; color:gray; position:absolute;'>"+ objFileName +"</div>";
		$('#floorMap_pop_'+objId).append(tmpHtml);
		$('#floorMap_pop_'+objId).css("display", "");
		$('#btn_'+objId).css("display", "");
		$('#file_input_div_'+objId).css("height", "70px");
	}else{
		$('#'+objId).val(null);
	}
}

var viewTimeArr = new Array();
function fileChangeInfoPhoto(obj){
	$('#floorMap_pop_file_photo').empty();
	
	viewTimeArr = new Array();
	var viewIdx = 0;
	var tmpViewArr = new Array();
	var chkTime = false;
	var mxFileSize = 0;
	
	var i = document.getElementById('file_photo');
	for(var i=0; i<obj.files.length;i++){
		
		var date = new Date(obj.files[i].lastModifiedDate);
		viewTimeArr.push(obj.files[i].lastModifiedDate);	//마지막 수정 날짜
		
		viewIdx = 0;
		chkTime = false;
		for(var j=0; j<obj.files.length;j++){
			var date2 = new Date(obj.files[j].lastModifiedDate);
			if(date.getTime() > date2.getTime()){
				viewIdx++;
			}else if(date.getTime() == date2.getTime() && i != j && !chkTime){
				for(var m=0;m<tmpViewArr.length;m++){
					if(tmpViewArr[m].date == date.getTime()){
						chkTime = true;
						var tmpObjTime = tmpViewArr[m];
						viewIdx += tmpObjTime.cnt;
						tmpViewArr[m].cnt = tmpObjTime.cnt += 1;
					}
				}
				
				if(!chkTime){
					var tmpObjTime = new Object();
					tmpObjTime.date = date.getTime();
					tmpObjTime.cnt = 1;
					tmpViewArr.push(tmpObjTime);
					chkTime = true;
				}
			}
			
		}
		mxFileSize += obj.files[i].size;
		obj.files[i].seq = viewIdx;
		viewFileArr[viewIdx] = obj.files[i];
	}
	var tmpHtml = '';
// 	tmpHtml += "<div style='margin:5px 0 5px 10px; text-decoration:underline; color:gray;'>"+ mxFileSize +"</div>";
	for(var i=0; i<viewFileArr.length;i++){
		tmpHtml += "<div style='margin:5px 0 5px 10px; text-decoration:underline; color:gray;'>"+ viewFileArr[i].name +"</div>";
	}
		
	$('#floorMap_pop_file_photo').append(tmpHtml);
	
}

//gpx file remove button
function removeGpxFileBtn(thisIndex){
	$('#gpx_'+thisIndex).val(null);
	$('#floorMap_pop_gpx_'+thisIndex).empty();
	$('#floorMap_pop_gpx_'+thisIndex).css("display", "none");
	$('#btn_gpx_'+thisIndex).css("display", "none");
}

//video file remove button
function removeVideoFileBtn(thisIndex){
	$('#file_'+thisIndex).val(null);
	$('#floorMap_pop_file_'+thisIndex).empty();
	$('#floorMap_pop_file_'+thisIndex).css("display", "none");
	$('#btn_file_'+thisIndex).css("display", "none");
	$('#file_input_div_file_'+thisIndex).css("height", "auto");
}

// content select
function fnContentMainChange(tType){
	$(".contentUploadTr").css("display", "none");
	$(".contentSelTopDiv").css("background-color", "#ffffff");
	
	$("." + tType + "_tr").css("display", "table-row");
	$("#contentSelTopDiv_" + tType).css("background-color","#F2F3F5");
}
</script>

</head>

<body>

<table id='upload_table'>
	<tr id="showDivTR">
		<td colspan="2" style="font-size: 12px;">
			<div style="float:right; padding:3px; height: 20px;">
				<label class="containerCheck">Drone Data
					<input type="checkbox" id="droneDataChk">
					<span class="checkmarkCheck"></span>
				</label>
			</div>
		</td>
	</tr>
	<tr style="display: none;">
		<th align='center' style="width:80px;">TITLE</th>
		<td align='center'>
			<input id='title_area' type='text' style='width:316px;' value='TITLE'>
		</td>
	</tr>
	<tr style="display: none;">
		<th align='center' colspan='2'>CONTENT</th>
		<td align='center' colspan='2'>
			<textarea id='content_area' style='width:400px; height:150px;' value='CONTENT'>CONTENT</textarea>
		</td>
	</tr>
	<tr id="targetTr">
		<td colspan="2">
			<div id="contentSelTopDiv_v" class="contentSelTopDiv" style="float: left;width: 100px;height: 28px;text-align: center;" onclick="fnContentMainChange('v');return;">
				<label style="line-height: 25px;">video</label>
			</div>
			<div id="contentSelTopDiv_p" class="contentSelTopDiv" style="float: left;width: 100px;height: 28px;text-align: center;" onclick="fnContentMainChange('p');return;">
				<label style="line-height: 25px;">photo</label>
			</div>
			<div id="contentSelTopDiv_s" class="contentSelTopDiv" style="float: left;width: 100px;height: 28px;text-align: center;" onclick="fnContentMainChange('s');return;">
				<label style="line-height: 25px;">sensor</label>
			</div>
			<div id="contentSelTopDiv_t" class="contentSelTopDiv" style="float: left;width: 100px;height: 28px;text-align: center;" onclick="fnContentMainChange('t');return;">
				<label style="line-height: 25px;">traj</label>
			</div>
		</td>
	</tr>
	<tr class="contentUploadTr v_tr">
		<th align='center' style='width:80px;' rowspan="2">video</th>
		<td align='center'>
			<div id="video_area">
				<div class="file_input_div_video" id="file_input_div_file_1">
					<div class="file_input_img_btn_video">파일 업로드</div>
					<input type="file" name="file_1" id="file_video" class="file_input_hidden_video_s" style="left:0;" onchange="fileChangeInfoVideo(this);"/>
					<div id="floorMap_pop_file_video" class="text_box_dig" style="padding-top: 40px; display: none;"></div>
					<input type="button" id="btn_file_1" value="X" onclick="removeVideoFileBtn(1);" style="border-radius: 2px; border: none; font-size: 14px; padding: 3px 8px; background: #6D808F; color: white; display: none; float: right; cursor: pointer;">
				</div>
			</div>
		</td>
	</tr>
	<tr class="contentUploadTr v_tr">
		<td align='center'>
			<!-- gps file add area -->
			<div id="gps_file_add_area">
				<div id="gps_area">
					<div class="file_input_div_video file_input_div_gpxFile" style="float: left;">
						<div class="file_input_img_btn_video file_label_txt" style="margin:0px;">GPX</div>
						<input type="file" name="gpx_1" id="gpx_1" class="file_input_hidden_gps" onchange="fileChangeInfoVideo(this);" style="left:0px;" accept='.GPX, .gpx' />
						<div id="floorMap_pop_gpx_1" class="text_box_dig text_box_gps" style="display: none; padding-top: 40px;"></div>
						<input type="button" id="btn_gpx_1" value="X" onclick="removeGpxFileBtn(1);" style="border-radius: 2px; border: none; font-size: 14px; padding: 3px 8px; background: #6D808F; color: white; display: none; float: right; cursor: pointer;">
					</div>
				</div>
			</div>
			
			<!-- get gps file video select area -->
			<div id="gps_file_select_area" style="display: none; margin-left:30px;"></div>
		</td>
	</tr>
	<tr class="contentUploadTr p_tr">
		<th align="center" style="width:80px;">photo</th>
		<td id="file_upload_td">
			<div class="file_input_div" style="float: left;">
				<div class="file_input_img_btn"> LOAD </div>
	    		<input type="file" multiple name="file_a[]" id="file_photo" class="file_input_hidden" onchange="fileChangeInfoPhoto(this);" accept='.jpg,.gif,.png,.bmp'  />
			</div>
<!-- 				webkitdirectory -->
			<div id="floorMap_pop_file_photo" class="text_box_dig" style="width:240px; height: 72px; overflow-y:auto; margin:8px 0 8px 10px; border:1px solid gray; float: left;"></div>
		</td>
	</tr>
	<tr class="contentUploadTr s_tr">
		<th align="center" style="width:80px;">sensor</th>
		<td align='center'>
			<!-- gps file add area -->
			<div id="gps_file_add_area">
				<div id="gps_area">
					<div class="file_input_div_video file_input_div_jsonFile" style="float: left;">
						<div class="file_input_img_btn_video file_label_txt" style="margin:0px;">JSON</div>
						<input type="file" name="json_1" id="json_1" class="file_input_hidden_json" onchange="fileChangeInfoSensor(this);" style="left:0px;" accept='.JSON, .json' />
						<div id="floorMap_pop_json_1" class="text_box_dig text_box_json" style="display: none; padding-top: 40px;"></div>
						<input type="button" id="btn_json_1" value="X" onclick="removeGpxFileBtn(1);" style="border-radius: 2px; border: none; font-size: 14px; padding: 3px 8px; background: #6D808F; color: white; display: none; float: right; cursor: pointer;">
					</div>
				</div>
			</div>
			
			<!-- get gps file video select area -->
			<div id="gps_file_select_area" style="display: none; margin-left:30px;"></div>
		</td>
	</tr>
	<tr class="contentUploadTr t_tr">
		<th align="center" style="width:80px;">traj</th>
		<td align='center'>
			<!-- gps file add area -->
			<div id="gps_file_add_area">
				<div id="gps_area">
					<div class="file_input_div_video file_input_div_gpxFile" style="float: left;">
						<div class="file_input_img_btn_video file_label_txt" style="margin:0px;">GPX</div>
						<input type="file" name="gpx_2" id="gpx_2" class="file_input_hidden_gps" onchange="fileChangeInfoTraj(this);" style="left:0px;" accept='.GPX, .gpx' />
						<div id="floorMap_pop_gpx_2" class="text_box_dig text_box_gps" style="display: none; padding-top: 40px;"></div>
						<input type="button" id="btn_gpx_2" value="X" onclick="removeGpxFileBtn(2);" style="border-radius: 2px; border: none; font-size: 14px; padding: 3px 8px; background: #6D808F; color: white; display: none; float: right; cursor: pointer;">
					</div>
				</div>
			</div>
			
			<!-- get gps file video select area -->
			<div id="gps_file_select_area" style="display: none; margin-left:30px;"></div>
		</td>
	</tr>
	<tr>
		<td width='' height='25' align='center' colspan='2'>
			<button id="saveBtn" onclick='saveContent();'>SAVE</button>
			<button id="cancelBtn" onclick='cancelContent();'>CANCEL</button>
		</td>
	</tr>
</table>

	<form enctype="multipart/form-data" method="post" name="fileinfo" id="fileinfo" style="display:none;" >
		<input type="hidden" name="uploadType" id="uploadType" value="GeoVideo"/>
	</form>
	<form enctype="multipart/form-data" method="POST" name="fileinfoPhoto" id="fileinfoPhoto" style="display:none;" >
		<input type="hidden" name="uploadDateArr"/>
	</form>
	

</body>