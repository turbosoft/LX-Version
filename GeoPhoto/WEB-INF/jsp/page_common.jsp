<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- css -->
<link type="text/css" href="<c:url value='/css/font.css'/>" rel="Stylesheet"/>
<link type="text/css" href="<c:url value='/css/content_common.css'/>" rel="Stylesheet"/>

<!-- image detecting -->
<!-- <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script> -->

<!-- jQuery & jQuery UI -->
<link type="text/css" href="<c:url value='/lib/jquery/css/smoothness/jquery-ui-1.8.11.custom.css'/>" rel="Stylesheet" />
<script type="text/javascript" src="<c:url value='/lib/jquery/js/jquery-1.7.1.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/lib/jquery/js/jquery-ui-1.8.11.custom.min.js'/>"></script>

<!-- jAlert -->
<link type="text/css" href="<c:url value='/lib/jalert/jquery.alerts.css'/>" rel="Stylesheet" />
<script type="text/javascript" src="<c:url value='/lib/jalert/jquery.alerts.js'/>"></script>

<!-- framedialog -->
<script type="text/javascript" src="<c:url value='/lib/framedialog/jquery.framedialog.js'/>"></script>

<!-- icolorpicker -->
<script type="text/javascript" src="<c:url value='/lib/icolorpicker/iColorPicker.js'/>"></script>

<!-- accordion -->
<link type="text/css" href="<c:url value='/lib/accordion/jquery.accordion.css" rel="Stylesheet'/>" />
<script type="text/javascript" src="<c:url value='/lib/accordion/jquery.accordion.js'/>"></script>

<!-- zindex -->
<script type="text/javascript" src="<c:url value='/lib/zindex/zindex.js'/>"></script>

<!-- contextmenu -->
<script type="text/javascript" src="<c:url value='/lib/contextmenu/jquery.contextmenu.r2.js'/>"></script>

<!-- contextmenu -->
<script type="text/javascript" src="<c:url value='/lib/reel/jquery.reel.js'/>"></script>

<!-- html2canvas -->
<script type="text/javascript" src="<c:url value='/lib/html2canvas/html2canvas.js'/>"></script>


<script type="text/javascript">
var baseRoot = function(){ 
	var br = "http://"+ location.host+"/GeoCMS_Gateway/";
	return br;
};

var imageBaseUrl = function(){ 
	var br = "";
	if(b_serverType == "URL"){
		br = "http://"+ b_serverUrl + ":" + b_serverViewPort +"/shares/" + b_serverPath;
	}else{
		br = "http://"+ location.host + "/GeoCMS/" + b_serverPath;
	}
	return br;
};

var b_serverType = "LOCAL";
var b_serverUrl = "";
var b_serverViewPort = "";
var b_serverPath = "";

var dataReplaceFun = function(oldData){
	var replaceResultData = "";
	if(oldData != null && oldData != undefined){
		oldData = oldData.toString();
		replaceResultData = oldData.replace(/\//g,'&sbsp');
		replaceResultData = replaceResultData.replace(/\?/g,'&mbsp');
		replaceResultData = replaceResultData.replace(/\#/g,'&pbsp');
		replaceResultData = replaceResultData.replace(/\./g,'&obsp');
		replaceResultData = replaceResultData.replace(/</g,'&lt');
		replaceResultData = replaceResultData.replace(/>/g,'&gt');
		replaceResultData = replaceResultData.replace(/\\/g,'&bt');
		replaceResultData = replaceResultData.replace(/%/g,'&mt');
		replaceResultData = replaceResultData.replace(/;/g,'&vbsp');
		replaceResultData = replaceResultData.replace(/\r/g,'&rnsp');
		replaceResultData = replaceResultData.replace(/\n/g,'&nnsp');
	}
	return replaceResultData;
}

$(function() {
	$.loadingBlockShow = function(opts) {
		var defaults = {
			imgPath: '<c:url value="/images/geoImg/waiting4.png"/>',
			imgStyle: {
				width: 'auto',
				textAlign: 'center',
				marginTop: '15%'
			},
			text: '',
			style: {
				position: 'fixed',
				width: '100%',
				height: '100%',
				background: 'rgba(0, 0, 0, 0.38)',
				left: 0,
				top: 0,
				zIndex: 10000
			}
		};
		$.extend(defaults, opts);
		$.loadingBlockHide();
	
		var img = $('<div id="waiting"><img src="' + defaults.imgPath + '"><p style="margin: 0px; padding: 0px; width: 128px; height: 24px; font-size:24px; text-align: center; position: fixed; left: calc(50vw - 64px); color: coral;">Loading...</p></div>');
		var block = $('<div id="loading_block"></div>');
	
		block.css(defaults.style).appendTo('body');
		img.css(defaults.imgStyle).appendTo(block);
	};
	
	$.loadingBlockHide = function() {
		$('div#loading_block').remove();
	};
});


</script>