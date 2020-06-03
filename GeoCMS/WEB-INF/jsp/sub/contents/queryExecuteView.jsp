<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link type="text/css" href="<c:url value='/css/font.css'/>" rel="Stylesheet"/>

<style>
body
{
	background:black;
	color:white;
}
#kLayer{
		width: 100%;
    	text-align: center;
	}
#resultTable tr:first-child{
	background: #6e778a;
	text-align: center;
	font-weight: bold;
	border-bottom: 1px solid black;
}

#resultTable tr{
	border-bottom: 1px solid black;
}

#resultTable tr td{
	padding-left: 10px;
    border-right: 1px solid black;
}

#resultTable tr th{
    border-right: 1px solid black;
}

#resultTable tr td:last-child{
	padding-left: 10px;
    border-right: 1px solid white;
}

#resultTable tr th:last-child{
    border-right: 1px solid white;
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

.bigBlueBtn {
	border: 1px solid;
	border-color : #297acc;
	border-radius : 3px;
	font-size: 16px;
	padding: 3px 15px; 
	background-color : #297acc;
	color: white;
	cursor: pointer;
	text-align: center;
	height: 40px;
}

.bigGreyBtn {
	border: 1px solid;
	border-color : #6e778a;
	border-radius : 3px;
	font-size: 16px;
	padding: 3px 15px; 
	background-color : #6e778a;
	color: white;
	cursor: pointer;
	text-align: center;
	height: 40px;
	margin-top:20px;
	margin-bottom: 20px;
	margin-left: 10px;
}
#queryWriteView{
    height: 230px;
    padding-top: 20px;
}
#queryResultView{
	margin-top:20px;
	height: 300px;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Query Execute</title>
<%
String loginId = (String)session.getAttribute("loginId");					//로그인 아이디
String loginToken = (String)session.getAttribute("loginToken");				//로그인 token
String loginType = (String)session.getAttribute("loginType");				//로그인 권한
%>
<title>Query Execute Result View</title>
<script type="text/javascript" src="<c:url value='/lib/jquery/js/jquery-1.5.1.min.js'/>"></script>
<script>

var loginId = '<%=loginId%>';
var loginToken = '<%=loginToken%>';
var loginType = '<%=loginType%>';
var queryNum = "${queryNum}";
var innerHTML = "";
var projectIdx = "";
var mainProjectIdx = "${mainProjectIdx}";
$(function(){
	var queryNum = "${queryNum}";
	var analysisName = "${analysisName}";
	var analysisData = "${analysisData}";
	if(queryNum == 2)
	{
		$("#inputQuery").text(analysisData);	
		/* if(analysisName == "Distance")
		{
			innerHTML = "SELECT M_Min('MDOUBLE (1.002 1503828254949, 1.042 1503828254969)');";
			$("#inputQuery").text(innerHTML);	
		}
		else if(analysisName == "Temporal Slice")
		{
			innerHTML = "SELECT m_slice(a.mv, 'Period(1558665000,1558666800)') FROM JeonJuCityData a WHERE (m_spatial(a.mv) && ST_MakeEnvelope(126.9331,37.5671,127.0809,37.6022,4326) AND m_intersects(Distance.mv,'Period(1558665000,1558666800)'))";
			$("#inputQuery").text(innerHTML);
		}
		else
		{
			innerHTML = "SELECT id, mv ";
			innerHTML += "FROM userVideos ";
			innerHTML += "WHERE M_Overlaps(mv, 'Period (1100, 1150)'); ";
			$("#inputQuery").text(innerHTML);
		} */
		
	}
});

function executeRealQuery()
{
	var Url			= "http://"+location.host+"/GeoCMS_Gateway/cms/analysisExecute/";
	var param		= loginToken + "/"+ loginId + "/" + projectNameTxt + "/" + projectShareType + "/" + projectShareUser + "/"+ projectEditYes;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "POST"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
 			$("#myVal").text(data.Key);
		},
		complete: function (a, b) {
			
		}
	});	
}
function execute()
{
	$("#resultTable").css("display", "inline-table");
	$("#layerBtn").css("display", "inline-block");
	$("#layerResult").css("display", "inline-block");
	
	var scrollHeight = $(document).height();
	$(document).scrollTop(scrollHeight);
}

function fnToTop() {
	$(document).scrollTop(0);
	$("#inputQuery").focus();
	$("#inputQuery").select();
}

function executeCancel()
{
	close();
}
function addProjectName(){
	var projectNameTxt = "Local Name";
	var projectShareUser = "1";
	var projectEditYes = "Y";
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

	if(projectShareUser == null || projectShareUser == ''){
		projectShareUser = '&nbsp';
	}
	
	if(projectEditYes == null || projectEditYes == ''){
		projectEditYes = '&nbsp';
	}
	
	var Url			= "http://"+location.host+"/GeoCMS_Gateway/cms/saveProject/";
	var param		= loginToken + "/"+ loginId + "/" + projectNameTxt + "/" + projectShareType + "/" + projectShareUser + "/"+ projectEditYes;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "POST"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			//closeAddProjectName();
// 			jAlert('Saving Success', 'Info');
// 			alert(data.Data);
			if(queryNum == 1)
			{
				close();
				opener.viewMyProjects(null);
			}
			else
			{
				projectIdx = data.Data;
				callProject(projectIdx);
				close();
				opener.close();
				opener.opener.makeSequenceColse();
				opener.opener.viewMyProjects(null);
			}
		},
		complete: function (a, b) {
			
		}
	});
}
function callProject(projectNum)
{
	var latlonAll = "${latlonAll}";
	var latlon = latlonAll.split(",");
	var minlon = latlon[0];
	var maxlon = latlon[1];
	var minlat = latlon[2];
	var maxlat = latlon[3];
	var Url			= "http://"+location.host+"/GeoCMS_Gateway/cms/callProject/";
	var param		= loginToken + "/"+ loginId;
	var callBack	= "?callback=?";
	$.ajax({
		type	: "POST"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, data : { 
			"mainProjectIdx" : mainProjectIdx,
			"projectIdx" : projectNum,
			"minlon" : minlon,
			"maxlon" : maxlon,
			"minlat" : minlat,
			"maxlat" : maxlat
		}
		, async	: false
		, cache	: false
		, success: function(data) {
			if (data.result == "success") {
// 				jAlert('Saving Success', 'Info');
			} else {
// 				jAlert("Saving Fail", 'Info');
			}
		}
	});
}
</script>
</head>
<body>
<div style="margin:0 auto; width:90%;">
<div style="margin-top:10px;margin-bottom: 20px; font-size: 25px; text-align: center; font-weight: bold;"><span>Query Execute</span>

</div>

<div style="border-top: 1px solid black; border-bottom: 1px solid black;">
	<div id = "queryWriteView">
		<span style="font-size: 25px; margin: 15px 58px 0px; height:90%; font-weight: bold;">Query</span><br/>
		<div style="margin:20px 58px 0px; height:125px;">
			<textarea placeholder="Input Query" id="inputQuery" style="width: 100%; height: 100px;"></textarea>
		</div>
		<div id="layerBtn2" style="text-align: center;" >
			<button class="smallBlueBtn" onclick="execute();">execute</button>
		</div>
	</div>
	<div id = "queryResultView">
		<div id = "layerResult" style="float:left; width:100%; height:100%;"><span style="font-size: 25px; margin: 30px 58px 0px;">Execute Result View</span><br/>
			<div style="margin:30px 58px 0px; background:white; color:black;">
				<table border="0" id="resultTable" style="display:none; border-collapse:collapse; width:100%; height:200px;">
					<tr style="">
						<th>RETURN TYPE</th>
						<th>BBOX DATA</th>
						<th>TIME DATA</th>
					</tr>
					<tr>
						<td>Slice</td>
						<td>[126.9331,37.5671], [127.0809,37.6022]</td>
						<td>2019-05-24 11:30:00, 2019-05-24 12:00:00</td>
					</tr>
					<tr>
						<td>SnapToGrid</td>
						<td>[126.9331,37.5671], [127.0809,37.6022]</td>
						<td>2019-05-24 11:30:00, 2019-05-24 12:00:00</td>
					</tr>
					
				</table>
			</div>
			<div id = "myVal"></div>
		</div>
		<!-- <div id="layerBtn" style="text-align: center; margin-top: 40px; float:right; margin-right:51px; display:none;" >
			<button class="smallBlueBtn" onclick="addProjectName();">Save as layer</button>
		</div> -->
	</div>
</div>


<div style="text-align:center;">
	<button class="bigBlueBtn" onclick="addProjectName();">Save as Layer</button>
	<button class="bigGreyBtn" onclick="executeCancel();">Close</button>
	<span style="float: right;"><button class="bigGreyBtn" onclick="fnToTop();">Top</button></span>
</div>
</body>
</html>