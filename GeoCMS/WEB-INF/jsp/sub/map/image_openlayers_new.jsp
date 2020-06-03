<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<meta http-equiv="content-type" content="text/html; charset=utf-8"/>

<!-- <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false&key=AIzaSyAZ4i-9lnjP3m46b2oqg4BlVxDmDfhExvU"></script> -->
<!-- <script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?version=2.0&apiKey=58C34064-4482-3303-B68E-100D063F8B0A"></script> -->
<script src="http://www.openlayers.org/api/2.13/OpenLayers.js" type="text/javascript"></script> 
<script type="text/javascript" src="https://map.vworld.kr/js/vworldMapInit.js.do?&apiKey=9522219E-56C3-36AC-ADDE-5AC0320A66E1"></script>
<!-- <script type="text/javascript" src="http://map.vworld.kr/js/apis.do?type=Base&apiKey=393E3826-9B75-3E91-8E63-B0DBD7177C1A"></script> -->

<script type='text/javascript'>

var selectNum = "";
var map = null;
var rectangleSequence = null;
var popup = null;
var minlo
var featureHover;

var minlon = "";
var minlat = "";
var maxlon = "";
var maxlat = "";
// var markers;
vworld.showMode = false;

var nowClickLine = 0;
var infoViewBoundX = 0;
var infoViewBoundY = 0;

var markerFileList = null;

var fov; //화각
var view_value; //촬영 거리

var direction_latlng;

var draw_angle_arr = new Array();
var draw_direction_arr = new Array();
var blackMarker = new Array();
var gpx_draw_direction = new Array();
var circle_arr = new Array();
var draw_sequence_arr = new Array();
var rectangleSequence = null;

var vectors;
var box;
var transform;
var mapList = new Array();
  

function endDrag(bbox) {
	var bounds = bbox.getBounds();
  setBounds(bounds);
  drawBox(bounds);
  box.deactivate();
  
  document.getElementById("bbox_drag_instruction").style.display = 'none';
  document.getElementById("bbox_adjust_instruction").style.display = 'block';        
}

function dragNewBox() {
  box.activate();
  transform.deactivate(); //The remove the box with handles
  vectors.destroyFeatures();
  
  document.getElementById("bbox_drag_instruction").style.display = 'block';
  document.getElementById("bbox_adjust_instruction").style.display = 'none';
  
  setBounds(null); 
}

function boxResize(event) {
  setBounds(event.feature.geometry.bounds);
}

function drawBox(bounds) {
  var feature = new OpenLayers.Feature.Vector(bounds.toGeometry());

  vectors.addFeatures(feature);
  transform.setFeature(feature);
}

function toPrecision(zoom, value) {
  var decimals = Math.pow(10, Math.floor(zoom/3));
  return Math.round(value * decimals) / decimals;
}

function setBounds(bounds) {
	if (bounds == null) {
	  document.getElementById("bbox_result").innerHTML = "";
	  
	} else {
    b = bounds.clone().transform(map.getProjectionObject(), new OpenLayers.Projection("EPSG:4326"))
    minlon = toPrecision(map.getZoom(), b.left);
    minlat = toPrecision(map.getZoom(), b.bottom);    
    maxlon = toPrecision(map.getZoom(), b.right);
    maxlat = toPrecision(map.getZoom(), b.top);  
           
    document.getElementById("bbox_result").innerHTML =
                    "minlon=" + minlon + ", " +
                    "minlat=" + minlat + ", " +
                    "maxlon=" + maxlon + ", " +
                    "maxlat=" + maxlat;  
  }
}

function init() {
  map = new OpenLayers.Map("mapdiv");
  var openstreetmap = new OpenLayers.Layer.OSM();
  map.addLayer(openstreetmap);


  var lonlat = new OpenLayers.LonLat(-1.788, 53.571).transform(
      new OpenLayers.Projection("EPSG:4326"), // transform from WGS 1984
      new OpenLayers.Projection("EPSG:900913") // to Spherical Mercator
    );

  var zoom = 13;


  vectors = new OpenLayers.Layer.Vector("Vector Layer", {
    displayInLayerSwitcher: false
  });
  map.addLayer(vectors);

  box = new OpenLayers.Control.DrawFeature(vectors, OpenLayers.Handler.RegularPolygon, {
    handlerOptions: {
      sides: 4,
      snapAngle: 90,
      irregular: true,
      persist: true
    }
  });
  box.handler.callbacks.done = endDrag;
  map.addControl(box);

  transform = new OpenLayers.Control.TransformFeature(vectors, {
    rotate: false,
    irregular: true
  });
  transform.events.register("transformcomplete", transform, boxResize);
  map.addControl(transform);
  
  map.addControl(box);
  
  box.activate();
  
  map.setCenter(lonlat, zoom);
  
}

function initialize() {
	
// 	markerArr = new Array();
	markerFileList = null;
	
// 	$('#vmap').empty();
	if(map != null){
		$.each($('.olAlphaImg'), function(idx, val){
			var tmpParentId = $(this).parent().attr('id');
			this.remove();
			$('#'+tmpParentId).remove();
		});
		if(typeShape == "marker") {	//main marker
			takeMarkerData(typeShape);
		}
		else if(typeShape == "forSearch") {	//searh page marker
// 			google.maps.event.addDomListener(window, 'load', gridMap(LocationData));
		}
	}
	else
	{
		$("#mapSelect option[value='']").remove();
		var selectMap = $("#mapSelect option:selected").val();
		if (selectMap == "OSM") {
			// OSM 지도 호출
// 			map = new OpenLayers.Map('map');
			map = new OpenLayers.Map({
				div: 'map',
				eventListeners: {
					featureover: function(e) {
						evtFeatureOver(e);
					},
					featureout: function(e) {
						evtFeatureOut(e);
					},
					featureclick: function(e) {
						evtFeatureClick(e);
					}
				}
			});
			var layer = new OpenLayers.Layer.OSM("mainLayer");
			map.addLayer(layer);
			var center = new OpenLayers.LonLat(126.9782914, 37.5666791);
			center.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
			map.setCenter(center, 8);
			
			$("[id^=OpenLayers_Control_Zoom_]").remove();
			// layer switch control
// 			map.addControl(new OpenLayers.Control.LayerSwitcher());
// 			$("#OpenLayers_Control_LayerSwitcher_64").css("top", "200px");
		} else if (selectMap == "VW") {
			vworld.init("map", "map-first", 
				function() {
					map = this.vmap;//브이월드맵 apiMap에 셋팅 
					map.setBaseLayer(map.vworldBaseMap);//기본맵 설정 
					map.setControlsType({"simpleMap":true}); //간단한 화면
					map.setCenterAndZoom(14135158.73848, 4518391.6622438, 8);//화면중심점과 레벨로 이동 (초기 화면중심점과 레벨)
					
					$("[id^=OpenLayers_Control_Attribution_]").css("display", "none");
				}
			);
			
// 			map.eventListeners = {
// 				featureover: function(e) {
// 					evtFeatureOver(e);
// 				},
// 				featureout: function(e) {
// 					evtFeatureOut(e);
// 				},
// 				featureclick: function(e) {
// 					evtFeatureClick(e);
// 				}
// 			}
		}
	}
	
	// [Intervention] Unable to preventDefault inside passive event listener due to target being treated as passive. See <URL> 처리
// 	$("#map").on('mousewheel', function(event) {
// 		event.preventDefault();
// 	},
// 	{
// 		passive: false
// 	});
}

function evtFeatureOver(e) {
	if (e.feature.uniquevalue != undefined && e.feature.uniquevalue != "") {
		// 이미 그려져 있는지
		if (map.getLayersByName("hover_circle_" + e.feature.uniquevalue).length == 0) {
//				e.feature.renderIntent = "select";
			e.feature.layer.drawFeature(e.feature);
//				console.log("Map says: Pointer entered " + e.feature.id + " on " + e.feature.layer.name);
			
			var featureData = e.feature.data;
			var kindStr = featureData.datakind;
			
			if (kindStr == "GeoVideo") {
				// 영상일 경우
				tmpThumbFileName1 = featureData.thumbnail;
			}
			
			// 동일한 위치에 다른 크기, 다른 스타일로 그려줌.
			var circleStyle = new OpenLayers.Style({
				'strokeColor':'#ff0000',
				'strokeOpacity':1,
				'strokeWidth':0.5,
				'fillColor':'#ff0000',
				'fillOpacity':0.4,
				'cursor':'default'
			});
			var circleStyleMap = new OpenLayers.StyleMap({
				'default': circleStyle
			});
			var circles = new OpenLayers.Layer.Vector("hover_circle_" + e.feature.uniquevalue, {
				styleMap: circleStyleMap
			});
			map.addLayer(circles);
			
			var lonlat = new OpenLayers.LonLat(e.feature.gpsLon, e.feature.gpsLat);
			lonlat.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
			var point = new OpenLayers.Geometry.Point(lonlat.lon, lonlat.lat);
			var circle = OpenLayers.Geometry.Polygon.createRegularPolygon(point, 60, 40, 0);
			
			var featureHover = new OpenLayers.Feature.Vector(circle);
			
			circles.addFeatures(featureHover);

			/* if (e.feature.layer.name != "hover_circle") {
				var contentStr = "<table>";
				contentStr += 		"<tr>";
				contentStr += 			"<td style='padding-right: 10px; padding-left: 10px; font-family: \'noto_r\''>Longitude</td>";
				contentStr += 			"<td style='padding-right: 10px; font-family: \'noto_r\''>" + e.feature.gpsLon + "</td>";
				contentStr += 		"</tr>";
				contentStr += 		"<tr>";
				contentStr += 			"<td style='padding-right: 10px; padding-left: 10px;'>Latitude</td>";
				contentStr += 			"<td style='padding-right: 10px; font-family: \'noto_r\''>" + e.feature.gpsLat + "</td>";
				contentStr += 		"</tr>";
				contentStr += 		"<tr>";
				contentStr += 			"<td style='padding-right: 10px; padding-left: 10px;'>File Name</td>";
				contentStr += 			"<td style='padding-right: 10px; font-family: \'noto_r\''>" + featureData.filename + "</td>";
				contentStr += 		"</tr>";
//					contentStr += 		"<tr>";
//					contentStr += 			"<td>Thumbnail</td>";
				
//					var thumbnail = "<img class='round' src='"+ftpBaseUrl()+"/"+kindStr +"/"+tmpThumbFileName1+"' width='100' height='100' style='border:2px solid #888888;'/>";
				
//					contentStr += 			"<td>" + thumbnail + "</td>";
//					contentStr += 		"</tr>";
				contentStr += 		"</table>";
//					popup = new OpenLayers.Popup('pop', lonlat, new OpenLayers.Size(204, 204), contentStr, false);
				popup = new OpenLayers.Popup.FramedCloud('gps_pop_' + e.feature.uniquevalue,
							lonlat,
//								new OpenLayers.Size(300, 300),
							null,
							contentStr,
							null,
							false
						);
				
				map.addPopup(popup);

				$(".olPopup").css("z-index", 9999);
			} */
		}
	}
}

function evtFeatureOut(e) {
	if (e.feature.uniquevalue != undefined && e.feature.uniquevalue != "") {
		e.feature.renderIntent = "default";
		e.feature.layer.drawFeature(e.feature);
//			console.log("Map says: Pointer left " + e.feature.id + " on " + e.feature.layer.name);
		
		var beforeCircle = map.getLayersByName("hover_circle_" + e.feature.uniquevalue);
		if (beforeCircle.length > 0) {
			$.each(beforeCircle, function(idx, val) {
				val.removeAllFeatures();
				map.removeLayer(val);
			});
		}
		
		/* while(map.popups.length) {
			map.removePopup(map.popups[0]);
		} */
	}
}

function evtFeatureClick(e) {
	if (e.feature.uniquevalue != undefined) 
	{
		if(e.feature.data.datakind == "GeoVideo")
		{
			//alert("filename : " + e.feature.data.filename);
			//alert("start time : " + e.feature.startTime);
			//alert("loginId : " + loginId);
			//alert("idx : " + e.feature.data.projectidx);
			//alert(clickedIdx);
			var encrypText = 'file_url='+ e.feature.data.filename +'&loginId='+ loginId +'&idx='+ e.feature.data.idx;
			var Url			= baseRoot() + "cms/encrypt";
			var param		= "/" + encrypText + "/encrypt";
			var callBack	= "?callback=?";
			
			$.ajax({
				type	: "get"
				, url	: Url + param + callBack
				, dataType	: "jsonp"
				, async	: false
				, cache	: false
				, success: function(data) {
					if(data.returnStr != null && data.returnStr != ''){

						var url = "/GeoVideo/geoVideo/video_url_viewer.do?urlData="+data.returnStr+"&linkType=CP1";
						$("#contentDiv").css("display", "block");
						$("#contentDiv").css("opacity", "1");
						$('#ifrmVideo').attr('src', url);

					}else{
//		 				jAlert(data.Message, 'Info');
					}
				}
			});
			

			/*
			var video = document.getElementById("video_player0");
			$("#video_player0").attr("src", ftpBaseUrl()+ '/GeoVideo/' + e.feature.data.filename + "#t=" + e.feature.startTime);
			// $("div#contentDiv #idx").val(index);
			$("#video_player0").load();
			
			// 재생
			video.ontimeupdate = function() {
				// var currentTime = parseInt(video.currentTime);
				// fnMoveMarker(currentTime, idx);
			}*/
		}
	}
	while(map.popups.length) {
		map.removePopup(map.popups[0]);
	}
	if (e.feature.uniquevalue != undefined && e.feature.uniquevalue != "") {
		// 이미 그려져 있는지
		//if (map.getLayersByName("hover_circle_" + e.feature.uniquevalue).length == 0) {
//				e.feature.renderIntent = "select";
			e.feature.layer.drawFeature(e.feature);
//				console.log("Map says: Pointer entered " + e.feature.id + " on " + e.feature.layer.name);
			
			var featureData = e.feature.data;
			var kindStr = featureData.datakind;
			
			if (kindStr == "GeoVideo") {
				// 영상일 경우
				tmpThumbFileName1 = featureData.thumbnail;
			}
			
			// 동일한 위치에 다른 크기, 다른 스타일로 그려줌.
			var circleStyle = new OpenLayers.Style({
				'strokeColor':'#ff0000',
				'strokeOpacity':1,
				'strokeWidth':0.5,
				'fillColor':'#ff0000',
				'fillOpacity':0.4,
				'cursor':'default'
			});
			var circleStyleMap = new OpenLayers.StyleMap({
				'default': circleStyle
			});
			var circles = new OpenLayers.Layer.Vector("hover_circle_" + e.feature.uniquevalue, {
				styleMap: circleStyleMap
			});
			map.addLayer(circles);
			
			var lonlat = new OpenLayers.LonLat(e.feature.gpsLon, e.feature.gpsLat);
			lonlat.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
			var point = new OpenLayers.Geometry.Point(lonlat.lon, lonlat.lat);
			var circle = OpenLayers.Geometry.Polygon.createRegularPolygon(point, 60, 40, 0);
			
			var featureHover = new OpenLayers.Feature.Vector(circle);
			
			circles.addFeatures(featureHover);

			if (e.feature.layer.name != "hover_circle") {
				var contentStr = "<table>";
				contentStr += 		"<tr>";
				contentStr += 			"<td style='padding-right: 10px; padding-left: 10px; font-family: \'noto_r\''>Longitude</td>";
				contentStr += 			"<td style='padding-right: 10px; font-family: \'noto_r\''>" + e.feature.gpsLon + "</td>";
				contentStr += 		"</tr>";
				contentStr += 		"<tr>";
				contentStr += 			"<td style='padding-right: 10px; padding-left: 10px;'>Latitude</td>";
				contentStr += 			"<td style='padding-right: 10px; font-family: \'noto_r\''>" + e.feature.gpsLat + "</td>";
				contentStr += 		"</tr>";
				contentStr += 		"<tr>";
				contentStr += 			"<td style='padding-right: 10px; padding-left: 10px;'>File Name</td>";
				contentStr += 			"<td style='padding-right: 10px; font-family: \'noto_r\''>" + featureData.filename + "</td>";
				contentStr += 		"</tr>";
//					contentStr += 		"<tr>";
//					contentStr += 			"<td>Thumbnail</td>";
				
//					var thumbnail = "<img class='round' src='"+ftpBaseUrl()+"/"+kindStr +"/"+tmpThumbFileName1+"' width='100' height='100' style='border:2px solid #888888;'/>";
				
//					contentStr += 			"<td>" + thumbnail + "</td>";
//					contentStr += 		"</tr>";
				contentStr += 		"</table>";
//					popup = new OpenLayers.Popup('pop', lonlat, new OpenLayers.Size(204, 204), contentStr, false);
				popup = new OpenLayers.Popup.FramedCloud('gps_pop_' + e.feature.uniquevalue,
							lonlat,
//								new OpenLayers.Size(300, 300),
							null,
							contentStr,
							null,
							false
						);
				
				map.addPopup(popup);

				$(".olPopup").css("z-index", 9999);
			}
		//}
	}
}

//마커 데이터 가져오기
function takeMarkerData(typeShape) {
	var tmpPageNum = '&nbsp;';
	var tmpContentNum = '&nbsp;';
	var tmpTabName = editMode == 1?tempTabName:nowTabName;
	var tmpLoginId = loginId;
	var tmpLoginToken = loginToken;
	var tmpIdx = '&nbsp;';
	
	if(tmpLoginId == null || tmpLoginId == '' ||  tmpLoginId == 'null'){
		tmpLoginId = '&nbsp;';
	}
	if(tmpLoginToken == null || tmpLoginToken == '' ||  tmpLoginToken == 'null'){
		tmpLoginToken = '&nbsp;';
	}
	if(b_url == 'cms/getBoard/'){
		gridMap(null);
		return;
	}
	
	var tmpTabIndex = 0;
	if(tmpTabName != null && tmpTabName != ''){
		tmpTabIndex = $.inArray(tmpTabName, b_contentTabArr)+1;
	}

	var Url			= baseRoot() + b_url;
	alert(b_url);
	var param		= typeShape + "/" + tmpLoginToken + "/" + tmpLoginId + "/" + tmpPageNum + "/" + tmpContentNum + "/" + tmpTabIndex + "/" + tmpIdx;
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

//mark load
function markDataMake(data){
	var id_arr = new Array();
	var title_arr = new Array();
	var content_arr = new Array();
	var file_url_arr = new Array();
	var udate_arr = new Array();
	var idx_arr = new Array();
	var lati_arr = new Array();
	var longi_arr = new Array();
	var origin_url_arr = new Array();
	var thumbnail_url_arr = new Array();
	var dataKind_arr = new Array();
	var projectUserId_arr = new Array();
	var seqNum_arr = new Array();
	var droneType_arr = new Array();
	var projectIdx_arr = new Array();
	
	if(data != null && data.length > 0){
		for(var i=0; i<data.length; i++) 
		{
			id_arr.push(data[i].id); //id 저장
			
			title_arr.push(data[i].title); //title 저장
			
			content_arr.push(data[i].content); //content 저장
			
			file_url_arr.push(data[i].filename); // file
			
			udate_arr.push(data[i].u_date); //찍은날짜
			
			idx_arr.push(data[i].idx);
			
			lati_arr.push(data[i].latitude); // 위도
			
			longi_arr.push(data[i].longitude); //경도
			
			thumbnail_url_arr.push(data[i].thumbnail);	//thumb file
			
			origin_url_arr.push(data[i].originname);	//origin file
			
			dataKind_arr.push(data[i].datakind); //데이터 타입
			
			projectUserId_arr.push(data[i].projectUserId); //project user id
			
			seqNum_arr.push(data[i].seqnum); //seq num
			
			droneType_arr.push(data[i].dronetype); //drone type
			
			projectIdx_arr.push(data[i].projectidx); //project idx
		}
	}
	
	var loca = [];
	
	var tmpProjectIdx = 0;
	var locaArr = new Array();
	var locaMap = null;
	var locaChildArr = [];
	
	for(var i=0; i < file_url_arr.length; i++)
	{	
		if(lati_arr[i] != null && lati_arr[i] != 'null' && lati_arr[i] != 0 && longi_arr[i] != null && longi_arr[i] != '' && longi_arr[i] != 0){
			if(tmpProjectIdx == 0)
		    {
		    	tmpProjectIdx = projectIdx_arr[i];
		    	locaMap = newMap();
		    	locaMap.put('projectIdx',tmpProjectIdx);
		    }
		    else if(tmpProjectIdx != projectIdx_arr[i])
		    {
		    	locaMap.put('data',locaChildArr);
		    	locaChildArr = [];
		    	locaArr.push(locaMap);
		    	tmpProjectIdx = projectIdx_arr[i];
		    	locaMap = newMap();
		    	locaMap.put('projectIdx',tmpProjectIdx);
			}
			
			var temp = new Array();
			temp[0] = lati_arr[i];
			temp[1] = longi_arr[i];
			temp[2] = file_url_arr[i];
			temp[3] = idx_arr[i];
			temp[4] = dataKind_arr[i];
			temp[5] = origin_url_arr[i];
			temp[6] = thumbnail_url_arr[i];
			temp[7] = id_arr[i];
			temp[8] = projectUserId_arr[i];
			temp[9] = seqNum_arr[i];
			temp[10] = droneType_arr[i];
			temp[11] = projectIdx_arr[i];
			loca.push(temp);
			locaChildArr.push(temp);
		}
	}
	
	if(locaChildArr != null && locaChildArr.length > 0){
		locaMap.put('data',locaChildArr);
		locaArr.push(locaMap);
	}

	LocationData = loca;
	markerFileList = locaArr;
	vworldMapCall(LocationData);
}

function vworldMapCall(LocationData){
	if(LocationData == null || LocationData.length <= 0){	//base map setting
		var center = new OpenLayers.LonLat(126.9782914, 37.5666791);
		center.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
		map.setCenter(center, 8);
		return;
	}
	
	for (var i in LocationData)
	{
		var p = LocationData[i];
		if(p[0] == 0 && p[1] == 0){
			continue;
		}
		
		fnMakeMarker(p, 'load');
		markerFileList.push(p[2]);
	}
}

//make marker
function fnMakeMarker(p, type){ //lat, lon, filename, idx, kind, origin , thumbnail , id, projectUserId, projectMarkerIcon  
// 	var point = apiMap.getTransformXY(p[1], p[0], "EPSG:4326","EPSG:900913");
	var isExist = false;
	var layers = map.layers;
	var markerLayer = null;
	$.each(layers, function(idx, val) {
		if (val.name == "marker_" + p[3]) {
			markerLayer = val;
			isExist = true;
			return false;
		}
	});
	
	var tmpMarkerIcon = 'http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	var tmpMarkerIconHover = 'http://maps.google.com/mapfiles/ms/icons/yellow-dot.png';
	
	// 마커가 없는 경우에만 만든다.
	if (isExist) {
		markerLayer.markers[0].setUrl(tmpMarkerIcon);
	} else {
		var markers = new OpenLayers.Layer.Markers("marker_" + p[3]);
		map.addLayer(markers);
		
		var size = new OpenLayers.Size(25, 25);
		var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
		var icon = new OpenLayers.Icon(tmpMarkerIcon, size, offset);
		var lonlat = new OpenLayers.LonLat(p[1], p[0]);
		lonlat.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
		var marker = new OpenLayers.Marker(lonlat, icon);
		
		console.log("making marker >> " + "marker_" + p[3] + " : lat > " + p[0] + ", lon > " + p[1]);
		
		var jpgStr = p[2];

		if(p[4] == 'GeoVideo'){
			jpgStr = p[6];
		}

		if(p[8] == null || p[8] == '' || p[8] == 'null' || p[8] == undefined){
			p[8] = '';
		}
		
		if(typeShape == 'mainMarker'){
			marker.title = p[12];
			marker.id = p[11];
			
			markers.title = p[12];
			markers.id = p[11];
		}else{
			marker.title = jpgStr;
			marker.id = p[3]+'_'+p[4]+'_'+p[7]+'_'+p[8];
			marker.label = {text:p[2]+'/'+p[5], fontSize:'0px'};
			
			markers.title = jpgStr;
			markers.id = p[3]+'_'+p[4]+'_'+p[7]+'_'+p[8];
			markers.label = {text:p[2]+'/'+p[5], fontSize:'0px'};
		}
		
// 		if(type != 'click'){
// 			markerArr.push(marker);
// 		}
		
		markers.addMarker(marker);
		
		marker.events.register('click', marker, function(e) {
			if(nowClickLine != 0){
				return;
			}
			if(typeShape == 'mainMarker'){
				return;
			}
			
			var kindStr = this.id.split("_")[1];
			if(kindStr == 'GeoPhoto'){
				imageViewer(this.title, this.id.split("_")[2], this.id.split("_")[0], this.id.split("_")[3]);
			}else if(kindStr == 'GeoVideo'){
				videoViewer(this.label.text.split('/')[0], this.label.text.split('/')[1], this.id.split("_")[2], this.id.split("_")[0], this.id.split("_")[3]);
			}
			
			if(popup){
				map.removePopup(popup);
			}
		});
		
		marker.events.register('mouseover', marker, function(e) {
			if(editMode == 1){
				return;
			}
			if(nowClickLine != 0){
				return;
			}
			
			var tmpBoundX = event.clientX;
			var tmpBoundY = event.clientY;
			
// 			if(popup){
// 				map.removePopup(popup);
// 			}
			
// 			if(popup){
// 				if(Math.abs(tmpBoundX - infoViewBoundX) > 5 || Math.abs(tmpBoundY - infoViewBoundY) > 5){
// 					map.removePopup(popup);
// 				}else{
// 					return;
// 				}
// 			}
			
			var kindStr = this.id.split("_")[1];
		
			var tmpThumbFileName = this.title.split('.');
			var tmpThumbFileName1 = tmpThumbFileName[0] +'_thumbnail_600.png';
			if(kindStr == 'GeoVideo'){
				tmpThumbFileName1 = this.title;
			}
			
			var contentStr = "<img class='round' src='" + ftpBaseUrl() + "/" + kindStr +"/"+tmpThumbFileName1+"' width='200' height='200' style='border:2px solid #888888;'/>";
			popup = new OpenLayers.Popup('pop', this.lonlat, new OpenLayers.Size(204, 204), contentStr, false);
			
			map.addPopup(popup);
			infoViewBoundX = event.clientX;
			infoViewBoundY = event.clientY;

			$(".olPopup").css("z-index", 9999);
			var currentIcon = this.icon.url;
			if (this.icon.url.indexOf("green-dot") == -1) {
				this.setUrl(tmpMarkerIconHover);
			}
// 			$.each($('.gm-style-iw'),function(){
// 				$(this).next('div').remove();
// 				$(this).parent().addClass('infoview_main_map');
// 				$(this).prev('div').children().eq(1).addClass('infoview_main_map_second');
// 				$(this).prev('div').children().eq(2).children().addClass('infoview_main_map_child');
// 				$(this).prev('div').children().last().addClass('infoview_main_map_last');
// 			});
		});
		
		marker.events.register('mouseout', marker, function() {
// 			if(nowClickLine != 0){
// 				return;
// 			}

// 			var tmpBoundX = event.clientX;
// 			var tmpBoundY = event.clientY; 
			
// 			if(popup){
// 				if(Math.abs(tmpBoundX - infoViewBoundX) > 5 || Math.abs(tmpBoundY - infoViewBoundY) > 5){
// 					map.removePopup(popup);
// 					infoViewBoundX = 0;
// 					infoViewBoundY = 0;
// 				}else{
// 					return;
// 				}
// 			}
			
			if (this.icon.url.indexOf("yellow-dot") > -1) {
				this.setUrl(tmpMarkerIcon);
			}
			if (popup) {
				map.removePopup(popup);
			}
		});
		
		/* markers.events.register('mousedown', markers, function() {
			if(event.target != null){
				return;
			}
			
			if(nowClickLine == 1){
				if(rectangleSequence != null)
				rectangleSequence.setMap(null);
				
				var sTmpLat = event.latLng.lat();
				var sTmpLon = event.latLng.lng();
				
				rectangleSequence = new google.maps.Rectangle({
					strokeColor: '#FF0000',
					strokeOpacity: 0.8,
					strokeWeight: 2,
					fillColor: '#FF0000',
					fillOpacity: 0.35,
					editable: false,
					draggable: false,
					bounds: {
						north: sTmpLat,
						south: sTmpLat,
						east: sTmpLon,
						west: sTmpLon
					}
				});
				
				rectangleSequence.setMap(map);
				nowClickLine = 2;
			}
		});
		
		markers.events.register('mouseup', markers, function(event){
			if(event.target != null){
				return;
			}
			
			if(nowClickLine == 3){
				var sTmpLat = event.latLng.lat();
				var sTmpLon = event.latLng.lng();
				
				var tmpLatLon = rectangleSequence.getBounds().getNorthEast();
				var oTmpLat = tmpLatLon.lat();
				var oTmpLon = tmpLatLon.lng();
		
				if(rectangleSequence != null) {
					rectangleSequence.setMap(null);
				}
				
				var minLat = sTmpLat > oTmpLat? oTmpLat:sTmpLat;
				var maxLat = sTmpLat > oTmpLat? sTmpLat:oTmpLat;
				var minLon = sTmpLon > oTmpLon? oTmpLon:sTmpLon;
				var maxLon = sTmpLon > oTmpLon? sTmpLon:oTmpLon;
			
				rectangleSequence = new google.maps.Rectangle({
					strokeColor: '#FF0000',
					strokeOpacity: 0.8,
					strokeWeight: 2,
					fillColor: '#FF0000',
					fillOpacity: 0.35,
					editable: true,
					draggable: true,
					bounds: {
						north: minLat,
						south: maxLat,
						east: maxLon,
						west: minLon
					}
				});
				rectangleSequence.setMap(map);
				nowClickLine = 1;
			}
		}); */
		
		marker.events.register('mousemove', map, function(){
			var tmpBoundX = event.clientX;
			var tmpBoundY = event.clientY;
			console.log('tmpBoundX : ' + tmpBoundX + " infoViewBoundX   : " + infoViewBoundX + '  tmpBoundY : '+ tmpBoundY + '  infoViewBoundY : '+ infoViewBoundY);
			 
			if(popup){
				if(Math.abs(tmpBoundX - infoViewBoundX) > 30 || Math.abs(tmpBoundY - infoViewBoundY) > 30){
					popup.destroy();
					infoViewBoundX = 0;
					infoViewBoundY = 0;
				}else{
					return;
				}
			}
			
			this.setUrl(tmpMarkerIcon);
			
			if(nowClickLine == 2){
				nowClickLine = 3;
			}
		});
	}
}

//get image exif data
function loadExif(rObj) {
	if(rObj != null && rObj != ''){
		if(rObj[10] != null && rObj[10] == 'Y'){
			reloadMap(rObj[0], rObj[1], "", "", rObj[10]);
		}else{
			var tmp_serverType = dataReplaceFun(b_serverType);
			var tmp_serverUrl = dataReplaceFun(b_serverUrl);
			var tmp_serverViewPort = dataReplaceFun(b_serverViewPort);
			var tmp_serverPath = dataReplaceFun(b_serverPath);
			
			var encode_file_name = encodeURIComponent('GeoPhoto/'+rObj[2]);
			getServer(encode_file_name,'EXIF', rObj);
		}
	}
}

function run(num) {
	var run = setInterval(function() {
		if (num > 7) {
			clearInterval(run);
		}
		// 현재 feature를 찾아 lon/lat 정보를 가져온다.
		var current = null;
		$.each(map.getLayersByName("gps_line")[0].features, function(idx, val) {
			if (val.time == num) {
				current = val;
				return false;
			}
		});
		var x = current.geometry.components[0].x;
		var y = current.geometry.components[0].y;
		// 현재 마커를 지움
		map.removeLayer(map.getLayersByName("mainMarker")[0]);
		
		// 마커를 새로 생성
		var tmpMarkerIcon = "http://maps.google.com/mapfiles/ms/icons/red-dot.png";

		// 마커 추가
		var markers = new OpenLayers.Layer.Markers("mainMarker");
		map.addLayer(markers);
		
		var size = new OpenLayers.Size(25, 25);
		var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
		var icon = new OpenLayers.Icon(tmpMarkerIcon, size, offset);
		var lonlat = new OpenLayers.LonLat(x, y);
// 		lonlat.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
		var marker = new OpenLayers.Marker(lonlat, icon);
		
		markers.addMarker(marker);
		map.setCenter(lonlat, 16);
		num++;
	}, 1000);
}

// layer 하위의 컨텐츠 클릭 시
// //이미지 클릭시 맵 center change
function mapCenterChange(data, gpsArrLat, gpsArrLon, type){		//tempObj: lat, lon, file, idx, dataKind, origin, thumbnail, id
// 	var center = new OpenLayers.LonLat(data.longitude, data.latitude);
// 	center.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
// 	map.setCenter(center, 15);

	var circleStyle
	if(type == "old")
	{
		circleStyle = new OpenLayers.Style({
			'strokeColor':'#07aca5',
			'strokeOpacity':1,
			'strokeWidth':1,
			'fillColor':'#07aca5',
			'fillOpacity':0.4,
			'cursor':'default'
		});
		
	}
	else
	{
		circleStyle = new OpenLayers.Style({
			'strokeColor':'#e62615',
			'strokeOpacity':2,
			'strokeWidth':2,
			'fillColor':'#e62615',
			'fillOpacity':0.4,
			'cursor':'default'
		});
	}
	// 스타일 정의
	
	var circleStyleMap = new OpenLayers.StyleMap({
		'default': circleStyle
	});
	
	if (data.datakind == "GeoVideo") {
		var circles = new OpenLayers.Layer.Vector("gps_circle_" + data.projectidx, {
			styleMap: circleStyleMap
		});
		map.addLayer(circles);
		
		var gpsArrLatgo = gpsArrLat;
		var gpsArrLongo = gpsArrLon;
		for(var j=0; j < gpsArrLatgo.length; j++)
		{
			var gpsLat = gpsArrLatgo[j];
			var gpsLon = gpsArrLongo[j];
			
			addGpsMarkerCircle(gpsLon, gpsLat, circles, data, j);
		}
	} else if (data.datakind == "GeoPhoto") {
		circleStyle = new OpenLayers.Style({
			'strokeColor':'#e62615',
			'strokeOpacity':5,
			'strokeWidth':5,
			'fillColor':'#07aca5',
			'fillOpacity':0.4,
			'cursor':'default'
		});
		
		var circleStylePhotoMap = new OpenLayers.StyleMap({
			'default': circleStyle
		});
		
		var circles = new OpenLayers.Layer.Vector("gps_circle_" + data.projectidx, {
			styleMap: circleStylePhotoMap
		});
		
		map.addLayer(circles);
		
		var gpsArrLatgo = gpsArrLat;
		var gpsArrLongo = gpsArrLon;
		for(var j=0; j < gpsArrLatgo.length; j++)
		{
			if(j % 5 == 0)
			{
				var gpsLat = gpsArrLatgo[j];
				var gpsLon = gpsArrLongo[j];
			
				addGpsMarkerCircle(gpsLon, gpsLat, circles, data, j);
			}
		}
	}else if (data.datakind == "GeoTraj") {
		var circles = new OpenLayers.Layer.Vector("gps_circle_" + data.projectidx, {
			styleMap: circleStyleMap
		});
		map.addLayer(circles);
		
		var gpsArrLatgo = gpsArrLat;
		var gpsArrLongo = gpsArrLon;
		for(var j=0; j < gpsArrLatgo.length; j++)
		{
			var gpsLat = gpsArrLatgo[j];
			var gpsLon = gpsArrLongo[j];
			
			addGpsMarkerCircle(gpsLon, gpsLat, circles, data, j);
		}
	}
	
	
}

function lookGps(gpsArrLat, gpsArrLon, num, idx)
{
	if($("#checkGps_"+num).is(":checked") == true)
	{
		var gpsArrLatgo = gpsArrLat.split(",");
		var gpsArrLongo = gpsArrLon.split(",");
		for(var i=0; i<gpsArrLatgo.length; i++)
		{
			var gpsLat = gpsArrLatgo[i];
			var gpsLon = gpsArrLongo[i];
			gpsLatNum = Number(gpsLat);
			gpsLonNum = Number(gpsLon);
			//gpsLat = gpsArrLatgo[i].length>5? gpsArrLatgo[i].substring(0,4) : gpsArrLatgo[i];
			//gpsLon = gpsArrLongo[i].length>5? gpsArrLongo[i].substring(0,4) : gpsArrLongo[i];
			gpsLatFix = gpsLatNum.toFixed(2);
			gpsLonFix = gpsLonNum.toFixed(2);
			var innerHTMLGps = "";
			innerHTMLGps += '<input type="checkbox" id="checkSubGps" style="float:left;" class="cb1" disabled/>';
			innerHTMLGps += '<label for="checkSubGps" style="background:#bebebe; cursor:default;"></label>'
			innerHTMLGps += "<label class='titleLabel' title='Point"+i+"("+gpsArrLatgo[i]+","+gpsArrLongo[i]+")' style='width:130px !important;font-size: 13px;margin-top:3px;'>Point"+i+"("+gpsLatFix+","+gpsLonFix+")</label>";
			$("#subGpsView_"+num).append("<li style='font-weight: 600; margin: 0px 0px 0px 108px;'><div style='padding:5px;'>"+innerHTMLGps+"</div></li>");
		}
	}
	else
	{
		$("#subGpsView_"+num).empty();
	}
}

function makeSequenceOpen(selectNumData, selectValData){
	selectNum = selectNumData;
	var lonlat = new OpenLayers.LonLat(127.10127,35.82015).transform(
	      new OpenLayers.Projection("EPSG:4326"), // transform from WGS 1984
	      new OpenLayers.Projection("EPSG:900913") // to Spherical Mercator
	    );
	
	  var zoom = 13;
	
	
	  vectors = new OpenLayers.Layer.Vector("Vector Layer", {
	    displayInLayerSwitcher: false
	  });
	  map.addLayer(vectors);
	
	  box = new OpenLayers.Control.DrawFeature(vectors, OpenLayers.Handler.RegularPolygon, {
	    handlerOptions: {
	      sides: 4,
	      snapAngle: 90,
	      irregular: true,
	      persist: true
	    }
	  });
	  box.handler.callbacks.done = endDrag;
	  map.addControl(box);
	
	  transform = new OpenLayers.Control.TransformFeature(vectors, {
	    rotate: false,
	    irregular: true
	  });
	  transform.events.register("transformcomplete", transform, boxResize);
	  map.addControl(transform);
	  
	  map.addControl(box);
	  
	  box.activate();
	 
	  map.setCenter(lonlat, zoom);
	  $('#copyReqNewOK').css('display','block');
	/* selectNum = selectNumData;
	selectVal = selectValData;
	if(markerProArr != null && markerProArr.length == 1){
		nowClickLine = 1;
		$('#copyReqStart').css('display','none');
		$('#copyReqExit').css('display','none');
		$('#copyReqNewOut').css('display','none');
		$('#copyReqNewOut').css('display','none');
		$('#copyReqNewOK').css('display','block');
	}else{
// 		jAlert("한 개의 프로젝트를 선택 하셔야 복사가 가능합니다.", '정보');
		jAlert("You can copy only one project at a time.", 'Info');
	} */
}

function addImagePoint(/* ol.source.Vector */ src) {
    var feature = new ol.Feature(
        {
            geometry: new ol.geom.Point([14827315, 4785815])
        }
    );
 
    var style = new ol.style.Style({
        image: new ol.style.Icon({
            src: 'http://www.gisdeveloper.co.kr/images/kochu.png',
            scale: 0.7,
        })
    });
 
    feature.setStyle(style);
    feature.set('name', '이미지 포인트 Feature');
 
    src.addFeature(feature);
}

function addPolygon(/* ol.source.Vector */ src) {
    var feature = new ol.Feature({
        geometry: new ol.geom.Polygon(
            [
                [
                    [13768449, 4871327],
                    [14556056, 5287144],
                    [14445986, 4166883],
                    [13995925, 3861135],
                    [13768449, 4871327],
                ]
            ]
        )
    });
 
    var style = new ol.style.Style({
        stroke: new ol.style.Stroke({
            color: 'blue',
            width: 3
        }),
        fill: new ol.style.Fill({
            color: 'rgba(0,0,255,0.6)'
        })
    });
 
    feature.setStyle(style);
    feature.set('name', '폴리곤 Feature');
 
    src.addFeature(feature);
}
 
function addPolyline(/* ol.source.Vector */ src) {
    var feature = new ol.Feature({
        geometry: new ol.geom.LineString([
            [16030985, 5565986],
            [15480638, 4318534],
            [14384837, 3780417],                            
        ])
    });
 
    var style = new ol.style.Style({
        stroke: new ol.style.Stroke({
            color: 'red',
            width: 4
        })
    });
 
    feature.setStyle(style);
    feature.set('name', '폴리라인 Feature');
 
    src.addFeature(feature);
}
 
function addTextPoint(/* ol.source.Vector */ src) {
    var feature = new ol.Feature({
        geometry: new ol.geom.Point([13778283, 4331832])
    });
 
    var style = new ol.style.Style({
        text: new ol.style.Text({
            text: "ol3",
            scale: 2,
            offsetY: 0,
            stroke: new ol.style.Stroke({
                color: 'black',
                width: 1
            }),
            fill: new ol.style.Fill({
                color: 'yellow'
            })
        })
    });
 
    feature.setStyle(style);
    feature.set('name', '텍스트 포인트 Feature');
 
    src.addFeature(feature);
}

function addGpsMarkerLine(gpsLon_start, gpsLat_start, gpsLon_end, gpsLat_end, lines) {
	var start = new OpenLayers.LonLat(gpsLon_start, gpsLat_start);
	start.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
	
	var end = new OpenLayers.LonLat(gpsLon_end, gpsLat_end);
	end.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
	
	var startPoint = new OpenLayers.Geometry.Point(start.lon, start.lat);
	var endPoint = new OpenLayers.Geometry.Point(end.lon, end.lat);
	
	var line = [startPoint, endPoint];
// 	var vector = new OpenLayers.Layer.Vector("line");
	var geom = new OpenLayers.Geometry.LineString(line);
	
	lines.addFeatures([new OpenLayers.Feature.Vector(geom)]);
// 	map.addLayers([vector]);
}

function addGpsMarkerCircle(gpsLon, gpsLat, circles, data, startTime) {
	var lonlat = new OpenLayers.LonLat(gpsLon, gpsLat);
	lonlat.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
	var point = new OpenLayers.Geometry.Point(lonlat.lon, lonlat.lat);
	var circle = OpenLayers.Geometry.Polygon.createRegularPolygon(point, 15, 40, 0);
	
	var featurecircle = new OpenLayers.Feature.Vector(circle);
	
	// feature mouseover, mouseout, click 시 필요한 정보
	featurecircle.data = data;
	featurecircle.startTime = startTime;
	featurecircle.gpsLon = gpsLon;
	featurecircle.gpsLat = gpsLat;
	featurecircle.idx = data.idx;
	featurecircle.uniquevalue = data.projectidx + "_" + startTime;
	var mapObj = new Object();
	mapObj.data = data;
	mapObj.startTime = startTime;
	mapObj.gpsLon = gpsLon;
	mapObj.gpsLat = gpsLat;
	mapObj.idx = data.idx;
	mapObj.uniquevalue = data.projectidx + "_" + startTime;
	
	mapList.push(mapObj);
	circles.addFeatures(featurecircle);
}

function addGpsMarkerCirclePhoto(lonlat, circles) {
	var point = new OpenLayers.Geometry.Point(lonlat.lon, lonlat.lat);
	var circle = OpenLayers.Geometry.Polygon.createRegularPolygon(point, 50, 40, 0);
	
	var featurecircle = new OpenLayers.Feature.Vector(circle);
	circles.addFeatures(featurecircle);
	circles.setZIndex(101);
}

function addGpsMarker(gpsLon, gpsLat, markers, idx, time) {
	var gpsMarkerIcon = 'http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	var gpsMarkerIconHover = 'http://maps.google.com/mapfiles/ms/icons/yellow-dot.png';
	var gpsMarkerIconStart = 'http://maps.google.com/mapfiles/ms/icons/green-dot.png';
	var gpsMarkerIconMove = 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png';
	
	var size = new OpenLayers.Size(25, 25);
	var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
	var icon = new OpenLayers.Icon(gpsMarkerIcon, size, offset);
	var lonlat = new OpenLayers.LonLat(gpsLon, gpsLat);
	lonlat.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
	var marker = new OpenLayers.Marker(lonlat, icon);
	
	marker.parentId = "marker_" + idx;
	marker.startTime = time;
	markers.addMarker(marker);
	
	if (time == 0) {
		marker.setUrl(gpsMarkerIconStart);
	}
	
	marker.events.register('click', marker, function(e) {
		if(popup){
			map.removePopup(popup);
		}
		
		var parentMarker = null;
		var parentId = this.parentId;
		$("#contentDiv").css("opacity", "1");
		$.each(map.layers, function(idx, val) {
			if (val.name == parentId) {
				parentMarker = val;
				return false;
			}
		});
		
		if (parentMarker != null) {
			var index = parentMarker.id.split("_")[0];
			var kindStr = parentMarker.id.split("_")[1];
			if(kindStr == 'GeoPhoto'){
// 				imageViewer(parentMarker.title, parentMarker.id.split("_")[2], parentMarker.id.split("_")[0], parentMarker.id.split("_")[3]);
			}else if(kindStr == 'GeoVideo'){
				$("#video_main_area").css("display", "block");
				$("#contentDiv").css("opacity", "1");
				
				// find marker
				var markerLayer = null;
				$.each(map.layers, function(idx, val) {
					if (val.name == "gps_marker_" + index) {
						markerLayer = val;
						return false;
					}
				});
				
				var gpsMarkers = markerLayer.markers;
				
				var video = document.getElementById("video_player0");
				$("#video_player0").attr("src", ftpBaseUrl()+ '/GeoVideo/' + parentMarker.label.text.split('/')[0] + "#t=" + this.startTime);
				$("div#contentDiv #idx").val(index);
				$("#video_player0").load();
// 				videoViewer(parentMarker.label.text.split('/')[0], parentMarker.label.text.split('/')[1], parentMarker.id.split("_")[2], parentMarker.id.split("_")[0], parentMarker.id.split("_")[3]);
				
				// 재생
				video.ontimeupdate = function() {
					var currentTime = parseInt(video.currentTime);
					fnMoveMarker(currentTime, idx);
// 					if (currentTime != 0) {
// 						gpsMarkers[currentTime].setUrl("http://maps.google.com/mapfiles/ms/icons/blue-dot.png");
// 					}
				}
				
				// 시작
// 				video.addEventListener('play', function(e) {
// 					console.log("play >> " + video.currentTime);
// 				});
				
				// 정지
// 				video.addEventListener('pause', function(e) {
// 					console.log("pause >> " + video.currentTime);
// 				});
			}
		}
	});
	
	marker.events.register('mouseover', marker, function(e) {
		if(popup){
			map.removePopup(popup);
		}
		
		var currentIcon = this.icon.url;
		// 영상 재생 중이 아닐 경우에만 mouseover 가능
		if (currentIcon.indexOf("red-dot") > -1) {
			this.setUrl(gpsMarkerIconHover);
		}
	});
	
	marker.events.register('mouseout', marker, function() {
		if(popup){
			map.removePopup(popup);
		}
		
		var currentIcon = this.icon.url;
		// 영상 재생 중이 아닐 경우메나 mouseout 가능
		if (currentIcon.indexOf("yellow-dot") > -1) {
			this.setUrl(gpsMarkerIcon);
		}
	});
}

var tmpPoint = -1;
function fnMoveMarker(point, idx) {
	if(isNaN(point)){
		return;
	}
	
	// 같은 시간의 위치 중복 처리
	if (tmpPoint != -1) {
		// 현재 포인트와 같은 포인트인지 확인
		if (point == tmpPoint) {
			return;
		} else {
			tmpPoint = point;
		}
	} else {
		tmpPoint = point;
	}
	
	// 모든 feature
	var features = map.getLayersByName("gps_line_" + idx)[0].features;
	
	// overflow 방지
	if (point > features.length - 1) {
		point = features.length - 1;
	}
	
	// 현재 시간에 해당하는 feature
	var currentFeature = features[point];
	
	// 현재 시간에 해당하는 feature의 좌표
	var x = currentFeature.geometry.components[0].x;
	var y = currentFeature.geometry.components[0].y;
	
	var newLonLat = new OpenLayers.LonLat(x, y);
	var newPx = map.getLayerPxFromLonLat(newLonLat);
	map.getLayersByName("marker_" + idx)[0].markers[0].moveTo(newPx);
// 	map.setCenter(lonlat, 18);
	
	/* // 마커 이동
	var newLonLat = new OpenLayers.LonLat(x, y);
	var newPx = map.getLayerPxFromLonLat(newLonLat);
	map.getLayersByName("marker_" + idx)[0].markers[0].moveTo(newPx);
	
	// 마커를 이동시킴
	var tmpMarkerIcon = "http://maps.google.com/mapfiles/ms/icons/red-dot.png";
	
	map.removeLayer(map.getLayersByName("mainMarker")[0]);
	var markers = new OpenLayers.Layer.Markers("mainMarker");
	map.addLayer(markers);
	
	var size = new OpenLayers.Size(25, 25);
	var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
	var icon = new OpenLayers.Icon(tmpMarkerIcon, size, offset);
	var lonlat = new OpenLayers.LonLat(x, y);
	var marker = new OpenLayers.Marker(lonlat, icon);
	
	markers.addMarker(marker);
	map.setCenter(lonlat, 18); */
}

function lookFile(file, num)
{
	var fileName = file.length>25? file.substring(0,25)+'...' : file;
	if($("#checkFile_"+num).is(":checked") == true)
	{
		var innerHTMLFile = "";
		innerHTMLFile += '<input type="checkbox" id="checkSubFile" style="float:left;" class="cb1" disabled/>';
		innerHTMLFile += '<label for="checkSubFile" style="background:#bebebe;"></label>'
		innerHTMLFile += "<label class='titleLabel' title="+file+" style='width:130px !important;font-size: 13px;margin-top:3px;'>"+fileName+"</label>";
		$("#subFileView_"+num).append("<li style='font-weight: 600; margin: 0px 0px 0px 108px;'><div style='padding:5px;'>"+innerHTMLFile+"</div></li>");	
	}
	else
	{
		$("#subFileView_"+num).empty();
	}
	
}
function lookAnno(xml, num)
{
	
	if($("#checkAnno_"+num).is(":checked") == true)
	{
		var xmlObj = xml.split("^");		
		for(var i=0; i<xmlObj.length; i++)
		{
			
			var xmlTag = xmlObj[i];
			var xmlLabel = xmlTag.length>35? xmlTag.substring(0,35)+'...' : xmlTag;
			var innerHTMLAnno = "";
			innerHTMLAnno += '<input type="checkbox" id="checkSubAnno" style="float:left;" class="cb1" disabled/>';
			innerHTMLAnno += '<label for="checkSubAnno" style="background:#bebebe;"></label>'
			innerHTMLAnno += "<label class='titleLabel' title='"+xmlTag+"' style='width:130px !important;font-size: 13px;margin-top:3px;'>"+xmlLabel+"</label>";
			$("#subAnnoView_"+num).append("<li style='font-weight: 600; margin: 0px 0px 0px 108px;'><div style='padding:5px;'>"+innerHTMLAnno+"</div></li>");
		}		
	}
	else
	{
		$("#subAnnoView_"+num).empty();
	}
	
}

 var gps_size;	//gps size;
// //gps 정보 load
   function loadGPS(fileName) {
 	var buf = fileName.split('.')[0];
 	var file_name = buf + '.gpx';
 	var lat_arr = new Array(); 
 	var lng_arr = new Array();
 	$.ajax({
 		type: "GET",
 		url: 'http://'+ location.host + '/GeoCMS/upload/GeoVideo/'+ file_name,
 		dataType: "xml",
 		cache: false,
 		success: function(xml) {
 			$(xml).find('trkpt').each(function(index) {
 				var lat_str = $(this).attr('lat');
 				var lng_str = $(this).attr('lon');
 				lat_arr.push(parseFloat(lat_str));
 				lng_arr.push(parseFloat(lng_str));
 			});
 			gps_size = lat_arr.length;
 			setGPSData(lat_arr, lng_arr);
 		},
 		error: function(xhr, status, error) {
 		}
 	});
 }
// //파일 바인드
var poly_arr;
function setGPSData(lat_arr, lng_arr) {
	poly_arr = new Array();
	if(lat_arr.length == lng_arr.length) {
		for(var i=0; i<lat_arr.length; i++) {
			poly_arr.push(new google.maps.LatLng(lat_arr[i], lng_arr[i]));
		}
	}
// 	else { jAlert('GPS 파일의 Latitude 와 Longitude 가 맞지 않습니다.', '정보'); }
	else { jAlert('Latitude and Longitude of the GPS file do not match.', 'Info'); }
	setDirection(poly_arr);
}

//이동 거리를 표현 (polyline)
function setDirection(poly_arr) {
	var draw_direction = new google.maps.Polyline({
		path: poly_arr,
		strokeColor: "#FF0000",
		strokeOpacity: 0.8,
		strokeWeight: 2
	});
	draw_direction.setMap(map);
	gpx_draw_direction.push(draw_direction);
}

//마커클릭 시 이미지 뷰어 
function imageViewer(file_url, user_id, idx, projectUserId) {   // 여기서 들어오는 file_url정보 ex)  upload/20140605_120541.jpg
	if(editMode == 1) return;
	var base_url = 'http://'+location.host;
	var conv_file_url = encodeURIComponent(file_url); // conv_file_url = upload%2F20140605_120541.jpg
	
	var map = $("#mapSelect option:selected").val();
	var mapMode = "";
	if (map == "VW") {
		mapMode = $("#mapModeChange option:selected").val();
	}
	
	if(projectImage == 1){
		var $dialog = jQuery.FrameDialog.create({ //객체정보를 로드
			url: base_url + '/GeoPhoto/geoPhoto/image_viewer.do?file_url='+conv_file_url+'&user_id='+user_id +'&idx='+ idx+'&loginId='+loginId+'&loginType='+loginType+'&loginToken='+loginToken+'&projectUserId='+projectUserId+'&map='+map+'&mapMode='+mapMode,
			title: 'Image Viewer',
			width:1127,
			height:800,
			buttons: {},
			autoOpen:false
		});
		$dialog.dialog('open');
	}else{
		window.open(ftpBaseUrl() +'/GeoPhoto/'+ conv_file_url, 'openImage', 'width=1170, height=860');
	}
}

//마커클릭 시 이미지 뷰어 
function imageViewerGoogle(file_url, user_id, idx, projectUserId) {   // 여기서 들어오는 file_url정보 ex)  upload/20140605_120541.jpg
	if(editMode == 1) return;
	var base_url = 'http://'+location.host;
	var conv_file_url = encodeURIComponent(file_url); // conv_file_url = upload%2F20140605_120541.jpg
	
	if(projectImage == 1){
		var $dialog = jQuery.FrameDialog.create({ //객체정보를 로드
			url: base_url + '/GeoPhoto/geoPhoto/image_viewer_google.do?file_url='+conv_file_url+'&user_id='+user_id +'&idx='+ idx+'&loginId='+loginId+'&loginType='+loginType+'&loginToken='+loginToken+'&projectUserId='+projectUserId,
			title: 'Image Viewer',
			width:1127,  
			height:850, 
			buttons: {},
			autoOpen:false
		});
		$dialog.dialog('open');
	}else{
		window.open(ftpBaseUrl() +'/GeoPhoto/'+ conv_file_url, 'openImage', 'width=1170, height=860');
	}
}

//비디오 뷰어 동작
function videoViewer(file_url, origin_url, id, idx, projectUserId) {
	if(editMode == 1) return;
	var base_url = 'http://'+location.host;
	var conv_origin_url = encodeURIComponent(origin_url);

	$.ajax({
		type	: "POST"
		, url	: '<c:url value="/geoVideoEncodingCheck.do"/>?origin_url='+conv_origin_url
		, dataType	: "json"
		, async	: false
		, cache	: false
		, success: function(response) {
			if(response =='true') {
// 				jAlert('인코딩 중 입니다...', '정보');
				jAlert('Encoding is in progress...', 'Info');
			}else {
				var map = $("#mapSelect option:selected").val();
				var mapMode = "";
				if (map == "VW") {
					mapMode = $("#mapModeChange option:selected").val();
				}
				
				if(projectVideo == 1){
					var $dialog = jQuery.FrameDialog.create({
						url: base_url + '/GeoVideo/geoVideo/video_viewer.do?&file_url='+file_url+'&user_id='+id+'&idx='+idx+'&loginId='+loginId+'&loginType='+loginType+'&loginToken='+loginToken+'&projectUserId='+projectUserId+'&map='+map+'&mapMode='+mapMode,
						title: 'Video Viewer',
						width: 1137,
						height: 835,
						buttons: {},
						autoOpen:false
					});
					$dialog.dialog('open');
				}else{
					window.open(ftpBaseUrl()+ '/GeoVideo/' + file_url, 'openImage', 'width=760, height=550');
				}
			}
		}
	});
}

//비디오 뷰어 동작
function videoViewerGoogle(file_url, origin_url, id, idx, projectUserId) {
	if(editMode == 1) return;
	var base_url = 'http://'+location.host;
	var conv_origin_url = encodeURIComponent(origin_url);

	$.ajax({
		type	: "POST"
		, url	: '<c:url value="/geoVideoEncodingCheck.do"/>?origin_url='+conv_origin_url
		, dataType	: "json"
		, async	: false
		, cache	: false
		, success: function(response) {
			if(response =='true') {
// 				jAlert('인코딩 중 입니다...', '정보');
				jAlert('Encoding is in progress...', 'Info');
			}else {
				if(projectVideo == 1){
					var $dialog = jQuery.FrameDialog.create({
						url: base_url + '/GeoVideo/geoVideo/video_viewer_google.do?&file_url='+file_url+'&user_id='+id+'&idx='+idx+'&loginId='+loginId+'&loginType='+loginType+'&loginToken='+loginToken+'&projectUserId='+projectUserId,
						title: 'Video Viewer',
						width: 1127,
						height: 850,
						buttons: {},
						autoOpen:false
					});
					$dialog.dialog('open');
				}else{
					window.open(ftpBaseUrl()+ '/GeoVideo/' + file_url, 'openImage', 'width=760, height=550');
				}
			}
		}
	});
}

function mapPolygonView(){
	if(editMode == 1) return;
	
	$.each(markerFileList, function(idx, val){
		var tmpMarkList = val.value.k_data;
		$.each(tmpMarkList,function(idxs, vals){
			if(vals != null){
				loadExif(vals);
				if(vals[4] != null && vals[4] == 'GeoVideo'){
					loadGPS(vals[2]);
				}
			}
		});
		createViewSeqLine(tmpMarkList, idx);
	});
}

function makeSequenceBounding(copyType)
{
	popup.openPop(selectNum, minlon, minlat, maxlon, maxlat);
	//box.activate();
  	transform.deactivate(); //The remove the box with handles
  	vectors.destroyFeatures();
    popup.focus();
    $('#copyReqNewOK').css('display','none');
}

// function contentMarker(response){
// 	markerArr = new Array();
// 	markerFileList = null;
	
// 	//set map option
// 	var myOptions = { mapTypeId: google.maps.MapTypeId.ROADMAP, streetViewControl:false, scaleControl:false };
// 	//create map
// 	map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
	
// 	markDataMake(response);
// }

</script>
</head>

<body style='margin:0px; padding:0px;'>
<!-- 	 <div id="vmap" style="width:100%; height:100%;"></div> -->
	<div id="map" style="width:100%; height:100%; cursor:default;"></div>
	<p id="bbox_result"> </p>
	<div onclick="makeSequenceBounding('On');return false;"
		id="copyReqNewOK" class="copyReqClass copyCssClass"
		style="display: none; z-index:750">SELECT OK
	</div>
<script>
	
// 	var mapController;
    
// 	 vw.MapControllerOption = {
//  			container : "vmap",
//  			mapMode: "2d-map",
//  			basemapType: vw.ol3.BasemapType.graphic,
//  			controlDensity:  vw.ol3.DensityType.basic,
// 				interactionDensity: vw.ol3.DensityType.basic,
// 				controlsAutoArrange: true,
// 				homePosition: vw.ol3.CameraPosition,
// 				initPosition: vw.ol3.CameraPosition,
//  		};
		
// 		mapController = new vw.MapController(vw.MapControllerOption); 
        
			 
	</script>
	<!-- 지도가 들어갈 영역 시작 -->
<!-- 	 <div id="map" style="width:100%; height:100%;"></div> -->
<!--     <div > -->
<!--         <button type="button" onclick="deleteLayerByName('VHYBRID');" name="rpg_1" >레이어삭제하기</button> -->
<!--     </div>  -->
<!-- <div id="vMap" style="width:100%;height:650px;left:0px;top:0px"></div> -->
<!-- 지도가 들어갈 영역 끝 -->
</body>
</html>
