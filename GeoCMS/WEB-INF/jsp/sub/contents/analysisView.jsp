<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	#allLayer tr td:nth-child(1)
	{
    	padding:9px;
	}
	
	/*#allLayer tr td:nth-child(3)
	{
    	background:#cad8db;
	} */
	#allDiv
	{
		width:80%;
		margin:20px auto;
		text-align: center;
	}
	#kLayer{
		width: 100%;
    	text-align: center;
    	border-collapse: collapse;
	}
	
	#allLayer{
		width: 100%;
    	text-align: center;
    	border-collapse: collapse;
	}
	
	#kLayer tr{
		height:60px;
		border-top:0.5px solid white;
		border-bottom:0.5px solid white;
	}
	
	#kLayer tr th{
		height:30px;
		/* border-top:0.5px solid #BDBEBF;
		border-bottom:0.5px solid #BDBEBF; */
		font-weight:normal;
	}
	.executeMenuBar{
	
		/* background-color:#F2F3F5;
		border-top:0.5px solid #BDBEBF;
		border-bottom:0.5px solid #BDBEBF; */
		background-color:#F2F3F5;
		font-weight:normal;
	}
	#kLayer tr td{
		/* border-top:0.5px solid #BDBEBF;
		border-bottom:0.5px solid #BDBEBF; */
		font-weight:bold;
		font-size:18px;
	}
	#allLayer tr{
		height:60px;
		border-top:0.5px solid black;
		border-bottom:0.5px solid black;
	}
	
	#allLayer tr:last-child{
		height:60px;
	}
	#allLayer tr td{
		font-weight:normal;
	}
	select
	{
		width: 83%;
		padding: .8em .5em;
		border: 1px solid #999;
		font-family: inherit;
		border-radius: 0px;
	}
	.inputView
	{
		padding: .8em .5em;
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

.smallWhiteGreyBtn {
	border: 1px solid;
	border-color : #6e778a;
	border-radius : 3px;
	font-size: 12px;
	padding: 3px 15px; 
	background-color : #F2F3F5;
	cursor: pointer;
	text-align: center;
	height: 30px;
	margin-left:17px;
}

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
	height: 50px;
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
	height: 50px;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
String loginId = (String)session.getAttribute("loginId");					//로그인 아이디
String loginToken = (String)session.getAttribute("loginToken");				//로그인 token
String loginType = (String)session.getAttribute("loginType");				//로그인 권한
%>
<title>Analysis Tool</title>
<link rel="stylesheet" href="//mugifly.github.io/jquery-simple-datetimepicker/jquery.simple-dtpicker.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script src="//mugifly.github.io/jquery-simple-datetimepicker/jquery.simple-dtpicker.js"></script>
<script type="text/javascript">

var loginId = '<%=loginId%>';
var loginToken = '<%=loginToken%>';
var loginType = '<%=loginType%>';
var realObj = new Object();
var myData = new Array;
	var selectVal = "";
	var selectRange = "";
	var latlonAll = "";
	$(function(){
		
		$('.datetimepicker').appendDtpicker({'locale':'ko'});
		
		$("#analysisTool").change(function(){
			
			$("#allLayer > tbody:last > tr").remove();
			
			selectVal = this.value;
			if(this.value == "Distance")
			{
				$("#allLayer > tbody:last").append('<tr><td><button class="smallWhiteBtn" onclick="plusClick(\'Distance\');">+</button></td></tr>');
			}
			if(this.value == "Count")
			{
				$("#allLayer > tbody:last").append('<tr><td><button class="smallWhiteBtn" onclick="plusClick(\'Count\');">+</button></td></tr>');
			}
			if(this.value == "Temporal Slice")
			{
				$("#allLayer > tbody:last").append('<tr><td><button class="smallWhiteBtn" onclick="plusClick(\'Temporal Slice\');">+</button></td></tr>');
			}
			if(this.value == "Spatial Slice")
			{
				$("#allLayer > tbody:last").append('<tr><td><button class="smallWhiteBtn" onclick="plusClick(\'Spatial Slice\');">+</button></td></tr>');
			}
			if(this.value == "Spatiotemporal Slice")
			{
				$("#allLayer > tbody:last").append('<tr><td><button class="smallWhiteBtn" onclick="plusClick(\'Spatiotemporal Slice\');">+</button></td></tr>');
			}
			if(this.value == "Temporal Predicates")
			{
				$("#allLayer > tbody:last").append('<tr><td><button class="smallWhiteBtn" onclick="plusClick(\'Temporal Predicates\');">+</button></td></tr>');
			}
			if(this.value == "Spatial Predicates")
			{
				$("#allLayer > tbody:last").append('<tr><td><button class="smallWhiteBtn" onclick="plusClick(\'Spatial Predicates\');">+</button></td></tr>');
			}
			if(this.value == "Spatiotemporal Predicates")
			{
				$("#allLayer > tbody:last").append('<tr><td><button class="smallWhiteBtn" onclick="plusClick(\'Spatiotemporal Predicates\');">+</button></td></tr>');
			}
			
		});
		
		var kUrl		= "http://"+location.host+"/GeoCMS_Gateway/cms/selectAllLayer/";
		var kparam		= loginToken + "/" +loginId;
		var kcallBack	= "?callback=?";
		
		debugger;
		$.ajax({
			type	: "POST"
			, url	: kUrl + kparam + kcallBack
			, dataType	: "jsonp"
			, data : {
				"jsonArray" : latlonAll
			}
			, async	: false
			, cache	: false
			, success: function(data) {
				myData = data.Data;
			},
			complete : function(a,b) {
				
			}
		});
		
		
		for(var g=0; g<myData.length; g++)
		{
			var layerObj = myData[g];
			var layerName = Object.values(layerObj);
			$('#selectLayer').append('<option value="'+layerName+'"> '+layerName+' </option>');
		}
	});
	
	function plusClick(value)
	{
		$("#allLayer > tbody:last > tr:last").remove();
		var innerHTML = "";
		var realSeq = $("#allLayer tbody tr").length;
		var selectSeq = $("#allLayer tbody tr").length + 1;
		innerHTML += "<tr id='searchNum_"+realSeq+"'><td><button class='smallWhiteBtn' onclick='minusClick("+realSeq+");'>-</button></td><td>";
		innerHTML += "<select id='selectSearch_"+selectSeq+"' onChange='selectSearch("+selectSeq+");'>";
		innerHTML += "<option value='' style='display:none;' selected></option>";
		if(value == "Distance")
		{
			innerHTML += "<option value='Type of Distance'>Type of Distance</option>";
			innerHTML += "<option value='Input Collection b'>Input Collection b</option>";
			innerHTML += "<option value='Bounding Box'>Bounding Box</option>";
			innerHTML += "<option value='Time Condition'>Time Condition</option>";
			innerHTML += "</select></td><td></td></tr>";
			$("#allLayer > tbody:last").append(innerHTML);
			$("#allLayer > tbody:last").append('<tr><td colspan="3"><button class="smallWhiteBtn" onclick="plusClick(\'Distance\');">+</button></td></tr>');
		}
		else if(value == "Count")
		{
			innerHTML += "<option value='Bounding Box'>Bounding Box</option>";
			innerHTML += "<option value='Time Condition'>Time Condition</option>";
			innerHTML += "</select></td><td></td></tr>";
			$("#allLayer > tbody:last").append(innerHTML);
			$("#allLayer > tbody:last").append('<tr><td colspan="3"><button class="smallWhiteBtn" onclick="plusClick(\'Count\');">+</button></td></tr>');
		}
		else if(value == "Temporal Slice")
		{
			innerHTML += "<option value='Bounding Box'>Bounding Box</option>";
			innerHTML += "<option value='Temporal Slice'>Temporal Slice</option>";
			innerHTML += "<option value='Time Condition'>Time Condition</option>";
			innerHTML += "</select></td><td></td></tr>";
			$("#allLayer > tbody:last").append(innerHTML);
			$("#allLayer > tbody:last").append('<tr><td colspan="3"><button class="smallWhiteBtn" onclick="plusClick(\'Temporal Slice\');">+</button></td></tr>');
		}
		else if(value == "Spatial Slice")
		{
			innerHTML += "<option value='Bounding Box'>Bounding Box</option>";
			innerHTML += "<option value='Spatial Slice'>Spatial Slice</option>";
			innerHTML += "<option value='Time Condition'>Time Condition</option>";
			innerHTML += "</select></td><td></td></tr>";
			$("#allLayer > tbody:last").append(innerHTML);
			$("#allLayer > tbody:last").append('<tr><td colspan="3"><button class="smallWhiteBtn" onclick="plusClick(\'Spatial Slice\');">+</button></td></tr>');
		}
		else if(value == "Spatiotemporal Slice")
		{
			innerHTML += "<option value='Bounding Box'>Bounding Box</option>";
			innerHTML += "<option value='Temporal Slice'>Temporal Slice</option>";
			innerHTML += "<option value='Spatial Slice'>Spatial Slice</option>";
			innerHTML += "<option value='Time Condition'>Time Condition</option>";
			innerHTML += "</select></td><td></td></tr>";
			$("#allLayer > tbody:last").append(innerHTML);
			$("#allLayer > tbody:last").append('<tr><td colspan="3"><button class="smallWhiteBtn" onclick="plusClick(\'Spatiotemporal Slice\');">+</button></td></tr>');
		}
		else if(value == "Temporal Predicates")
		{
			innerHTML += "<option value='Temporal Predicates'>Temporal Predicates</option>";
			innerHTML += "<option value='Time Condition'>Time Condition</option>";
			innerHTML += "</select></td><td></td></tr>";
			$("#allLayer > tbody:last").append(innerHTML);
			$("#allLayer > tbody:last").append('<tr><td colspan="3"><button class="smallWhiteBtn" onclick="plusClick(\'Temporal Predicates\');">+</button></td></tr>');
		}
		else if(value == "Spatial Predicates")
		{
			innerHTML += "<option value='Spatial Predicates'>Spatial Predicates</option>";
			innerHTML += "<option value='Spatial literal'>Spatial literal</option>";
			innerHTML += "</select></td><td></td></tr>";
			$("#allLayer > tbody:last").append(innerHTML);
			$("#allLayer > tbody:last").append('<tr><td colspan="3"><button class="smallWhiteBtn" onclick="plusClick(\'Spatial Predicates\');">+</button></td></tr>');
		}
		else if(value == "Spatiotemporal Predicates")
		{
			innerHTML += "<option value='Spatiotemporal Predicates'>Spatiotemporal Predicates</option>";
			innerHTML += "<option value='Spatial literal'>Spatiotemporal literal</option>";
			innerHTML += "<option value='Time Condition'>Time Condition</option>";
			innerHTML += "</select></td><td></td></tr>";
			$("#allLayer > tbody:last").append(innerHTML);
			$("#allLayer > tbody:last").append('<tr><td colspan="3"><button class="smallWhiteBtn" onclick="plusClick(\'Spatiotemporal Predicates\');">+</button></td></tr>');
		}
		
		
	}
	function minusClick(value)
	{
		$("#searchNum_"+value).remove();
	}
	
	function selectSearch(selectNum)
	{
		var myValue = $("#selectSearch_"+selectNum+" option:selected").val();
		var i = $("#selectSearch_"+selectNum).parent("td").parent("tr").find("td").length;
		if(i > 2)
		{
			$("#selectSearch_"+selectNum).parent("td").parent("tr").find("td:last").remove();
		}
		if(myValue == "Type of Distance")
		{
			var innerHTML = "";
			innerHTML += '<td>';
			innerHTML += '<select id="selectId_'+selectNum+'">';
			innerHTML += '<option value="M_min">M_min</option>';
			innerHTML += '<option value="M_max">M_max</option>';
			innerHTML += '<option value="M_distance">M_distance</option>';
			innerHTML += '<option value="M_avg">M_avg</option>';
			innerHTML += '</select>';
			innerHTML += '</td>';
			$("#selectSearch_"+selectNum).parent("td").parent("tr").append(innerHTML);
		}
		if(myValue == "Bounding Box")
		{
			$("#selectSearch_"+selectNum).parent("td").parent("tr").append('<td><input type="text"  id="boundingView_'+selectNum+'" class="inputView" style="width:253px;"/><button class="smallWhiteGreyBtn" onclick="boundingLine(\''+selectNum+'\',\''+selectVal+'\');">Bounding Box</button></td>');
		}
		if(myValue == "Spatial literal" || myValue == "Spatial Slice")
		{
			$("#selectSearch_"+selectNum).parent("td").parent("tr").append('<td><input type="text"  id="polygonView_'+selectNum+'" class="inputView" style="width:253px;"/><button class="smallWhiteGreyBtn" onclick="polygonLine(\''+selectNum+'\',\''+selectVal+'\');">Polygon Box</button></td>');
		}
		if(myValue == "Time Condition")
		{
			$("#selectSearch_"+selectNum).parent("td").parent("tr").append('<td><div><input type="text"  id="dateFromId_'+selectNum+'" class="datetimepicker inputView"/> ~ <input type="text" id="dateToId_'+selectNum+'" class="datetimepicker inputView"/></div></td>');
		}
		if(myValue == "Temporal Slice")
		{
			$("#selectSearch_"+selectNum).parent("td").parent("tr").append('<td><div><input type="text" id="dateFromId_'+selectNum+'" class="datetimepicker inputView"/> ~ <input type="text" id="dateToId_'+selectNum+'" class="datetimepicker inputView"/></div></td>');
		}
		if(myValue == "Input Collection b")
		{
			var innerHTML = "";
			innerHTML += '<td>';
			innerHTML += '<select id="selectId_'+selectNum+'">';
			for(var k=0; k<myData.length; k++)
			{
				var layerObj = myData[k];
				var layerName = Object.values(layerObj);
				innerHTML += '<option value="'+layerName+'"> '+layerName+' </option>';
			}
			innerHTML += '</select>';
			innerHTML += '</td>';
			$("#selectSearch_"+selectNum).parent("td").parent("tr").append(innerHTML);
		}
		if(myValue == "Temporal Predicates")
		{
			var innerHTML = "";
			innerHTML += '<td>';
			innerHTML += '<select id="selectId_'+selectNum+'">';
			innerHTML += '<option value="Contains">Contains</option>';
			innerHTML += '<option value="Equals">Equals</option>';
			innerHTML += '<option value="Overlaps">Overlaps precede</option>';
			innerHTML += '<option value="Succeeds">SUCCEEDS</option>';
			innerHTML += '</select>';
			innerHTML += '</td>';
			$("#selectSearch_"+selectNum).parent("td").parent("tr").append(innerHTML);
		}
		if(myValue == "Spatial Predicates")
		{
			var innerHTML = "";
			innerHTML += '<td>';
			innerHTML += '<select id="selectId_'+selectNum+'">';
			innerHTML += '<option value="Equals">Equals</option>';
			innerHTML += '<option value="Disjoint Touches">Disjoint Touches</option>';
			innerHTML += '<option value="Within Overlaps Crosses">Within Overlaps Crosses</option>';
			innerHTML += '<option value="Intersects Contains">Intersects Contains</option>';
			innerHTML += '<option value="Relate">Relate</option>';
			innerHTML += '</select>';
			innerHTML += '</td>'
			$("#selectSearch_"+selectNum).parent("td").parent("tr").append(innerHTML);
		}
		if(myValue == "Spatiotemporal Predicates")
		{
			var innerHTML = "";
			innerHTML += '<td>';
			innerHTML += '<select id="selectId_'+selectNum+'">';
			innerHTML += '<option value="StayIn">StayIn</option>';
			innerHTML += '<option value="Bypasses">Bypasses</option>';
			innerHTML += '<option value="Enters">Enters</option>';
			innerHTML += '<option value="Leaves">Leaves</option>';
			innerHTML += '<option value="Crosses">Crosses</option>';
			innerHTML += '<option value="mStayIn">mStayIn</option>';
			innerHTML += '<option value="mBypasses">mBypasses</option>';
			innerHTML += '<option value="mEnters">mEnters</option>';
			innerHTML += '<option value="mLeaves">mLeaves</option>';
			innerHTML += '<option value="mCrosses">mCrosses</option>';
			innerHTML += '</select>';
			innerHTML += '</td>'
			$("#selectSearch_"+selectNum).parent("td").parent("tr").append(innerHTML);
		}
		
		$('.datetimepicker').appendDtpicker({'locale':'ko'});
		
		
	}
	
	function Map() {

		 this.elements = {};
		 this.length = 0;
	}
		
	
	Map.prototype.put = function(key,value) {
		 this.length++;
		 this.elements[key] = value;
	}

	Map.prototype.get = function(key) {
		 return this.elements[key];
	}
	function executeAnalysis()
	{
		var layerName = $("#layerName option:selected").val();
		var analysisName = $("#analysisTool").val();
		var realSeq = $("#allLayer tbody tr").length -1;
		var analysisList = [];
		if(layerName == "" || analysisName == "" || realSeq < 1)
		{
			//유효성 검사
		}

		var realArray = new Array();
		for(var i=1; i<realSeq+1; i++)
		{
			var realMap = new Map();
			var myValue = $("#selectSearch_"+i+" option:selected").val();
			if(myValue == "Type of Distance" || myValue == "Temporal Predicates" || myValue == "Spatial Predicates" || myValue == "Spatiotemporal Predicates" )
			{
				var selectVal = $("#selectId_"+i+" option:selected").val();
				realObj = new Object();
				realObj.myValue = selectVal;
				realArray.push(realObj);
			}
			else if(myValue == "Bounding Box")
			{
				var boundingViewVal = $("#boundingView_"+i).val();
				
				realObj = new Object();
				realObj.bbox = boundingViewVal;
				realArray.push(realObj);
			}
			else if(myValue == "Input Collection b")
			{
				var selectVal = $("#selectId_"+i+" option:selected").val();
				realObj = new Object();
				realObj.collection = selectVal;
				realArray.push(realObj);
			}
			else if(myValue == "Spatial literal" || myValue == "Spatial Slice")
			{
				var polygonViewVal = $("#polygonView_"+i).val();
				
				realObj = new Object();
				realObj.polygon = polygonViewVal;
				realArray.push(realObj);
			}
			else if(myValue == "Temporal Slice")
			{
				//from .. to .. Time
				var dateFromVal = $("#dateFromId_"+i).val();
				var dateToVal = $("#dateToId_"+i).val();
				realObj = new Object();
				realObj.temp = dateFromVal+","+dateToVal;
				realArray.push(realObj);
			}
			else
			{
				//from .. to .. Time
				var dateFromVal = $("#dateFromId_"+i).val();
				var dateToVal = $("#dateToId_"+i).val();
				realObj = new Object();
				realObj.time = dateFromVal+","+dateToVal;
				realArray.push(realObj);
			}
		}
		
		var Url			= "http://"+location.host+"/GeoCMS_Gateway/cms/analysisToolProject/";
		var param		= loginToken + "/"+ loginId;
		var callBack	= "?callback=?";
		var analysisData = "";
		
		$.ajax({
			type	: "POST"
			, url	: Url + param + callBack
			, dataType	: "jsonp"
			, data : {
				"jsonArray" : JSON.stringify(realArray),
				"layerName" : layerName,
				"toolName" : analysisName
			}
			, async	: false
			, cache	: false
			, success: function(data) {
				analysisData = data.sqlData;
			},
			complete : function(a,b) {
				
			}
		});
		var projectIdx = "${projectIdx}";
		var base_url = 'http://'+location.host;
		window.open('', 'queryExecuteView', 'width=800, height=400, top=100, left=500');
		var form = document.createElement('form');
		form.setAttribute('method','post');
		form.setAttribute('action',base_url + "/GeoCMS/sub/contents/queryExecuteView.do?queryNum=2&analysisName="+analysisName+"&projectIdx="+projectIdx+"&analysisData="+encodeURIComponent(analysisData)+"&latlonAll="+encodeURIComponent(latlonAll));
		
		form.setAttribute('target','queryExecuteView');
		document.body.appendChild(form);
		form.submit();
		//ajax 를 통한 query 값 넘겨서 json 받아오기
		//해당 json data를 table에 뿌리기
	}
	
	function boundingLine(selectNum, selectVal)
	{
		selectRange = "BBOX";
		opener.popup = this;
		parent.window.opener.focus();
		parent.window.focus();
		window.opener.makeSequenceOpen(selectNum, selectVal);
		window.resizeTo(0,0);
		window.moveTo(100,0);
	}
	function polygonLine(selectNum, selectVal)
	{
		selectRange = "POLYGON";
		opener.popup = this;
		parent.window.opener.focus();
		parent.window.focus();
		window.opener.makeSequenceOpen(selectNum, selectVal);
		window.resizeTo(0,0);
		window.moveTo(100,0);
	}
	
	function openPop(selectId, minlon, minlat, maxlon, maxlat){
		this.focus();
		window.resizeTo(850,600);
		window.moveTo(440,200);
		
		if(selectVal == "Distance")
		{
			$("#boundingView_"+selectId).val("["+minlon+","+minlat+"],["+maxlon+","+maxlat+"]");
		}
		else if(selectRange == "BBOX")
		{
			$("#boundingView_"+selectId).val("["+minlon+","+minlat+"],["+maxlon+","+maxlat+"]");
		}
		else if(selectRange == "POLYGON")
		{
			$("#polygonView_"+selectId).val("["+minlon+","+minlat+"],["+minlon+","+maxlat+"],["+maxlon+","+minlat+"],["+maxlon+","+maxlat+"]");
		}
		else
		{
			$("#selectId_"+selectId).val("[22,45],[91,61]");
		}
		latlonAll = minlon+","+maxlon+","+minlat+","+maxlat;
	}
	
	function queryExecute()
	{
		var projectIdx = "${projectIdx}";
		var base_url = 'http://'+location.host;
		window.open('', 'queryExecuteView', 'width=800, height=400, top=50, left=500');
		var form = document.createElement('form');
		form.setAttribute('method','post');
		form.setAttribute('action',base_url + "/GeoCMS/sub/contents/queryExecuteView.do?loginToken="+loginToken+"&loginId="+loginId+"&projectIdx="+projectIdx);
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
	function executeCancel()
	{
		close();
	}
</script>
</head>
<body>
	<div id="allDiv">
		<span style="font-size: 25px; margin: 30px 58px 0px; height:90%;">Analysis Tool</span><br/>
		<div id="subjectDiv">
			<table id="kLayer" style="border-spacing: 0 20px; margin-bottom: 20px; margin-top: 20px; color:white;">
			<colgroup>
				<col width=5%>
				<col width=25%>
				<col width=70%>
			</colgroup>
				<tbody>
					<tr>
						<th colspan="2">Layer</th>
						<td id="layerName" >
							<select id="selectLayer">
							</select>
						</td>
					</tr>
					<tr>
						<th colspan="2">Analysis Tool</th>
						<td>
							<select id="analysisTool">
								<option value="" style="display:none;" selected></option>
								<option value="Distance">Distance</option>
								<option value="Count">Count</option>
								<option value="Temporal Slice">Temporal Slice</option>
								<option value="Spatial Slice">Spatial Slice</option>
								<option value="Spatiotemporal Slice">Spatiotemporal Slice</option>
								<option value="Temporal Predicates">Temporal Predicates</option>
								<option value="Spatial Predicates">Spatial Predicates</option>
								<option value="Spatiotemporal Predicates">Spatiotemporal Predicates</option>
							</select>
						</td>
					</tr>
				</tbody>	
			</table>
		</div>
		<div id="selectDiv">
			<table id="allLayer" style="border-spacing: 0 20px;">
				<colgroup>
					<col width=5%>
					<col width=25%>
					<col width=70%>
				</colgroup>
				<tbody>
					<tr>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
<div style=" text-align: center; margin: 25px auto; margin-left: 333px;">
	<div style="float:left;"><button class="bigBlueBtn" onclick="executeAnalysis();">Execute</button></div>
	<div style="float:left; margin-left:20px;"><button class="bigGreyBtn" onclick="executeCancel();">Cancel</button></div>
</div>
</body>
</html>