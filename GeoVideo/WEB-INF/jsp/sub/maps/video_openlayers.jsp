<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<meta http-equiv="content-type" content="text/html; charset=utf-8"/>

<script type="text/javascript" src="<c:url value='/lib/jquery/js/jquery-1.5.1.min.js'/>"></script>
<script src="http://www.openlayers.org/api/2.13/OpenLayers.js" type="text/javascript"></script>
<script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?&apiKey=88C38F8E-3FAC-3602-8562-B9724AF967DC"></script>
<script type='text/javascript'>

/* --------------------- 내부 함수 --------------------*/
var map1;

var marker;

vworld.showMode = false;

var marker_latlng;

var vDMarkerLat = 0;		//default marker latitude
var vDMarkerLng = 0;		//default marker longitude
var vDMapZoom = 10;		//defalut map zoom

var currentPoint = -1;

function init() {
	var selectMap = parent.map;
	if (selectMap == "OSM") {
		map1 = new OpenLayers.Map('map');
		var layer = new OpenLayers.Layer.OSM("main");
		map1.addLayer(layer);
		
		$("[id^=OpenLayers_Control_Attribution_]").css("bottom", "0.5em");
		$("[id^=OpenLayers_Control_Attribution_]").css("right", "-25px");
		
		var center = new OpenLayers.LonLat(vDMarkerLng, vDMarkerLat);
		center.transform(new OpenLayers.Projection("EPSG:4326"), map1.getProjectionObject());
		map1.setCenter(center, vDMapZoom);
	} else if (selectMap == "VW") {
		vworld.init("map", "map-first", 
			function() {
				map1 = this.vmap;//브이월드맵 apiMap에 셋팅 
				map1.setBaseLayer(map1.vworldBaseMap);//기본맵 설정 
				map1.setControlsType({"simpleMap":true}); //간단한 화면
				map1.setCenterAndZoom(14135158.73848, 4518391.6622438, 8);//화면중심점과 레벨로 이동 (초기 화면중심점과 레벨)
				
				$("[id^=OpenLayers_Control_Attribution_]").css("display", "none");
			}
		);
		
		var mapMode = parent.mapMode;
		vworld.setMode(mapMode);
	}
}

//base map setting
function setDefaultData(dMarkerLat, dMarkerLng, dMapZoom){
	vDMarkerLat = dMarkerLat;
	vDMarkerLng = dMarkerLng;
	vDMapZoom = dMapZoom;
}

/* --------------------- 초기 설정 함수 --------------------*/

//촬영 지점 설정
function setCenter(lat_str, lng_str) {
	var lat = parseFloat(lat_str);
	var lng = parseFloat(lng_str);
	
	if(map1 == null || map1 == undefined){
		init();
	}
	
	if(lat_str != 0 && lng_str != 0) {
		vDMarkerLat = lat;
		vDMarkerLng = lng;
	}else{
		if(vDMarkerLat == null || vDMarkerLat == ""){
			vDMarkerLat = 37.5666791;
		}
		if(vDMarkerLng == null || vDMarkerLng == ""){
			vDMarkerLng = 126.9782914;
		}
	}
	
	var tmpMarkerIcon = "http://maps.google.com/mapfiles/ms/icons/red-dot.png";

	// 마커 추가
	if (map1.getLayersByName("mainMarker").length > 0) {
		$.each(map1.getLayersByName("mainMarker"), function(idx, val) {
			map1.removeLayer(val);
		});
	}
	
	var markers = new OpenLayers.Layer.Markers("mainMarker");
	map1.addLayer(markers);
	
	var size = new OpenLayers.Size(25, 25);
	var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
	var icon = new OpenLayers.Icon(tmpMarkerIcon, size, offset);
	var lonlat = new OpenLayers.LonLat(vDMarkerLng, vDMarkerLat);
	lonlat.transform(new OpenLayers.Projection("EPSG:4326"), map1.getProjectionObject());
	var marker = new OpenLayers.Marker(lonlat, icon);
	
	markers.addMarker(marker);
	map1.setCenter(lonlat, 16);
}

function resetCenter() {
	map1.setCenter(marker_latlng);
}

var tmpPoint = -1;
function moveMarker(point) {
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
	var features = map1.getLayersByName("mainLine")[0].features;
	
	// overflow 방지
	if (point > features.length - 1) {
		point = features.length - 1;
	}
	
	// 현재 시간에 해당하는 feature
	var currentFeature = features[point];
	
	// 현재 시간에 해당하는 feature의 좌표
	var x = currentFeature.geometry.components[0].x;
	var y = currentFeature.geometry.components[0].y;
	
	// 마커를 이동시킴
	var tmpMarkerIcon = "http://maps.google.com/mapfiles/ms/icons/red-dot.png";
	
	map1.removeLayer(map1.getLayersByName("mainMarker")[0]);
	var markers = new OpenLayers.Layer.Markers("mainMarker");
	map1.addLayer(markers);
	
	var size = new OpenLayers.Size(25, 25);
	var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
	var icon = new OpenLayers.Icon(tmpMarkerIcon, size, offset);
	var lonlat = new OpenLayers.LonLat(x, y);
	var marker = new OpenLayers.Marker(lonlat, icon);
	
	markers.addMarker(marker);
	map1.setCenter(lonlat, 16);
	
// 	map.setCenter(lonlat, 16);
	
// 	if(point > poly_arr.length-1){
// 		point = poly_arr.length-1;
// 	}
// 	marker.setPosition(poly_arr[point]);
// 	map.setCenter(poly_arr[point]);
}

//이동 거리를 표현 (polyline)
// function setDirection(poly_arr) {
// 	console.log(poly_arr);
// 	var draw_direction = new google.maps.Polyline({
// 		path: poly_arr,
// 		strokeColor: "#FF0000",
// 		strokeOpacity: 0.8,
// 		strokeWeight: 2
// 	});
// 	draw_direction.setMap(map);
// }

// line을 그린다.
function setDirection(lat_arr, lng_arr) {
	if (map1.getLayersByName("mainLine").length > 0) {
		$.each(map1.getLayersByName("mainLine"), function(idx, val) {
			val.removeFeatures(val.features[0]);
		});
		
		$.each(map1.getLayersByName("mainLine"), function(idx, val) {
			map1.removeLayer(val);
		});
	}
	
	// 스타일 정의
	var lineStyle = new OpenLayers.Style({
		'strokeColor':"#ff0000",
		'strokeOpacity':1,
		'strokeWeight':2
	});
	var lineStyleMap = new OpenLayers.StyleMap(lineStyle);
	
	var lines = new OpenLayers.Layer.Vector("mainLine", {styleMap: lineStyle});
	map1.addLayer(lines);
	
	for (var i = 0; i < lat_arr.length; i++) {
		var gpsLat = parseFloat(lat_arr[i]);
		var gpsLon = parseFloat(lng_arr[i]);
		
		if (i != lat_arr.length - 1) {
			// 마지막은 제외한다.
			var gpsLat2 = parseFloat(lat_arr[i+1]);
			var gpsLon2 = parseFloat(lng_arr[i+1]);
			
			addGpsMarkerLine(gpsLon, gpsLat, gpsLon2, gpsLat2, lines, i);
		} else if (i == lat_arr.length - 1) {
// 			var gpsLat2 = parseFloat(lat_arr[0]);
// 			var gpsLon2 = parseFloat(lng_arr[0]);
			
			addGpsMarkerLine(gpsLon, gpsLat, gpsLon, gpsLat, lines, i);
		}
	}
}

function addGpsMarkerLine(gpsLon_start, gpsLat_start, gpsLon_end, gpsLat_end, lines, i) {
	var start = new OpenLayers.LonLat(gpsLon_start, gpsLat_start);
	start.transform(new OpenLayers.Projection("EPSG:4326"), map1.getProjectionObject());
	
	var end = new OpenLayers.LonLat(gpsLon_end, gpsLat_end);
	end.transform(new OpenLayers.Projection("EPSG:4326"), map1.getProjectionObject());
	
	var startPoint = new OpenLayers.Geometry.Point(start.lon, start.lat);
	var endPoint = new OpenLayers.Geometry.Point(end.lon, end.lat);
	
	var line = [startPoint, endPoint];
	var geom = new OpenLayers.Geometry.LineString(line);
	
	var feature = new OpenLayers.Feature.Vector(geom);
	feature.time = i;
	
	lines.addFeatures(feature);
}

//파일 바인드
// var poly_arr;
function setGPSData(lat_arr, lng_arr) {
	setCenter(lat_arr[0], lng_arr[0]);
	setDirection(lat_arr, lng_arr);
// 	poly_arr = new Array();
// 	if(lat_arr.length == lng_arr.length) {
// 		for(var i=0; i<lat_arr.length; i++) {
// 			poly_arr.push(new google.maps.LatLng(lat_arr[i], lng_arr[i]));
// 			if(i == 0) {
// 				setCenter(lat_arr[i], lng_arr[i]);
// 			}
// 		}
// 	}
// 	else { jAlert('GPS 파일의 Latitude 와 Longitude 가 맞지 않습니다.', '정보'); }
// 	else { jAlert('The Latitude and Longitude of the GPS file do not match.', 'Info'); }
// 	setDirection(poly_arr);
}


function abcde(lat_arr, lng_arr){
	for(var i=0; i<lat_arr.length; i++) {
		var marker = new google.maps.Marker({
			position: new google.maps.LatLng(lat_arr[i], lng_arr[i]),
			map: map,
			title: "Center",
			icon: "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
			draggable: false
		});
	}
}
</script>
</head>

<body style='margin:0px; padding:0px;' onload='init();'>
	<div id="map" style="width:100%; height:100%;"></div>
</body>
</html>
