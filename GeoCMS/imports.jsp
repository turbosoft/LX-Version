<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<!-- jQuery & jQuery UI -->
<link type="text/css" href="<c:url value='/lib/jquery/css/smoothness/jquery-ui-1.8.11.custom.css'/>" rel="Stylesheet" />
<script type="text/javascript" src="<c:url value='/lib/jquery/js/jquery-1.8.1.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/lib/jquery/js/jquery-ui-1.8.11.custom.min.js'/>"></script>

<!-- css -->
<link type="text/css" href="<c:url value='/css/font.css'/>" rel="Stylesheet"/>
<link type="text/css" href="<c:url value='/css/content_common.css'/>" rel="Stylesheet"/>


<script type="text/javascript">

$(function() {

	$('#file').change(function(){
		name = $('#file').val();
		if (!!name){

			i = name.lastIndexOf("\\");
			if (i > 0){
				name2 = name.substring(i+1);
				ii = name2.lastIndexOf(".");
				if (ii > 0){
					name3 = name2.substring(0, ii);
					$('#file_url').val(name3 + ".mp4");
				}
			}
		}
	});

});

function fnImportUrbanJson(){

	/*var idx = $('#idx').val();
	if (!idx){
		alert("idx 값을 입력하세요.");
		return;
	}*/
	var file = $('#file').val();
	if (!file){
		alert("파일을 선택하세요.");
		return;
	}

	var name = $('#file_url').val();
	if (!name){
		alert("file_name 값을 입력하세요.");
		return;
	}
	
	var formData = new FormData($('#formImport')[0]);

	$.ajax({
		type	: "POST"
//		, url	: "/GeoCMS/geoVideoImportUrbanAI.do?idx="+idx+"&file_url="+name
		, url	: "/GeoCMS/geoVideoImportUrbanAI.do?file_url="+name
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
					alert('done');
		}
		, error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}

</script>

<title>GeoCMS : imports</title>
</head>
<body>

	<h5>UrbanAI JSON 파일 입력기</h5>
	<form id="formImport" enctype="multipart/form-data" style="">
		UrbanAI json file : <input type='file' name='file' id='file'/><br/>
		<br/>
		file name : <input type="text" name="file_url" id="file_url" size="50"/> ex) 20190524_143033_NF(2)_mp4.mp4
	</form>
	<button class='smallBlueBtn' style='margin-top:15px;' onclick='fnImportUrbanJson();'>Import</button>
	
</body>
</html>