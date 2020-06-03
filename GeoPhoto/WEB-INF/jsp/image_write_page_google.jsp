<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<title>GeoPhoto</title>

<%
String file_url = request.getParameter("file_url");
String idx = request.getParameter("idx");
String loginToken = request.getParameter("loginToken");
String loginId = request.getParameter("loginId");
String projectBoard = request.getParameter("projectBoard");
String editUserYN = request.getParameter("editUserYN");

String urlData = request.getParameter("urlData");
String linkType = request.getParameter("linkType");
%>
<script type="text/javascript">

//move image write page
function init() {
	var file_url = '<%=file_url%>';
	var idx = '<%=idx%>';
	var loginToken = '<%=loginToken%>';
	var loginId = '<%=loginId%>';
	var projectBoard = '<%=projectBoard%>';
	var editUserYN = '<%=editUserYN%>';
	var urlData = '<%=urlData%>';
	var linkType = '<%=linkType%>';

	var image_write_frame = document.getElementById('image_write_frame');
	image_write_frame.contentWindow.location.href = "<c:url value='/geoPhoto/image_write_google.do'/>?file_url="+file_url+"&idx="+ 
			idx+"&loginToken="+loginToken+"&loginId="+loginId+'&projectBoard='+projectBoard+'&editUserYN='+editUserYN+'&urlData='+urlData+'&linkType='+linkType;
}
</script>

</head>
<body onload='init();'>
	<div id="image_write_div" style="position:absolute; width:100%; height:100%; left:0px; top:0px; display:block;">
		<iframe id='image_write_frame' frameborder='0' style='width:100%; height:100%; margin:0px; padding:0px;'></iframe>
	</div>
</body>
</html>