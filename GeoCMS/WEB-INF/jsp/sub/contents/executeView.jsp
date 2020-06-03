<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
#kLayer{
		width: 100%;
    	text-align: center;
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
</style>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
			jAlert(data.Message, 'Info');
			jAlert("Local Layer Save Successed", 'Info');
			//viewMyProjects(null);
		}
	});
}
</script>
</head>

<body>
<div>
<table id="kLayer" style="border-spacing: 0 20px; margin-bottom: 30px;">
<tr>
	<td> Layer</td><td id="layerName" style="background: gray; color: white;">${layerName}</td>
</tr>
<tr>
	<td>Analysis Tool</td>
	<td style="background: gray; color: white;">
		${analysisName} 
	</td>
</tr>

</table>
Result Table
</div>
<table border="1">
	<tr>
		<td>RETURN TYPE</td>
		<td>BBOX DATA</td>
		<td>TIME DATA</td>
	</tr>
	<tr>
		<td>Slice</td>
		<td>[40.77, -73.95], [40.8, -74.0]</td>
		<td>2019-09-02 08:14:23, 2019-09-02 08:14:24</td>
	</tr>
	<tr>
		<td>SnapToGrid</td>
		<td>[40.8, -74.0], [40.8, -74.0]</td>
		<td>2019-09-02 08:14:21, 2019-09-02 08:14:22 </td>
	</tr>
</table>

<div style="text-align: center; margin-top: 40px;">

<button class="smallBlueBtn" onclick="addProjectName();">Save as layer</button>
<button class="smallGreyBtn">close</button>



</div>
</body>
</html>