<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>

<%
 response.setHeader("Cache-Control","no-cache");
 response.setHeader("Pragma","no-cache");
 response.setDateHeader("Expires",0);
%>

<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
<script src="http://www.openlayers.org/api/2.13/OpenLayers.js" type="text/javascript"></script>
<script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?&apiKey=88C38F8E-3FAC-3602-8562-B9724AF967DC"></script>
<jsp:include page="../../page_common.jsp"></jsp:include>

<script type='text/javascript'>

/* --------------------- 내부 함수 --------------------*/
var map1;

var map_type;

vworld.showMode = false;

// var marker, view_marker;
var marker_latlng, view_marker_latlng;

var fov; //화각
var view_value; //촬영 거리

var draw_angle;

var direction_latlng;

var draw_direction;

var circle;

var imgDMarkerLat = 0;		//default marker latitude
var imgDMarkerLng = 0;		//default marker longitude
var imgDMapZoom = 17;		//defalut map zoom
var imgCoordinate = false;	//coordinate boolean

function init() {
	var selectMap = parent.map;
	if (selectMap == "OSM") {
		map1 = new OpenLayers.Map('map');
		var layer = new OpenLayers.Layer.OSM("main");
		map1.addLayer(layer);
		
		$("[id^=OpenLayers_Control_Attribution_]").css("bottom", "0.5em");
		$("[id^=OpenLayers_Control_Attribution_]").css("right", "-25px");
		
		var center = new OpenLayers.LonLat(imgDMarkerLng, imgDMarkerLat);
		center.transform(new OpenLayers.Projection("EPSG:4326"), map1.getProjectionObject());
		map1.setCenter(center, imgDMapZoom);
	} else if (selectMap == "VW") {
		var mapMode = parent.mapMode;
		vworld.init("map", "map-first", 
			function() {
				map1 = this.vmap;//브이월드맵 apiMap에 셋팅 
				map1.setBaseLayer(map1.vworldBaseMap);//기본맵 설정 
				map1.setControlsType({"simpleMap":true}); //간단한 화면
				map1.setCenterAndZoom(14135158.73848, 4518391.6622438, 8);//화면중심점과 레벨로 이동 (초기 화면중심점과 레벨)
				
				$("[id^=OpenLayers_Control_Attribution_]").css("display", "none");
			}
		);
		
		var mapMode = $("#mapModeChange option:selected", parent.parent.document).val();
		vworld.setMode(mapMode);
	}
}

//base map setting
function setDefaultData(dMarkerLat, dMarkerLng, dMapZoom){
	imgDMarkerLat = dMarkerLat;
	imgDMarkerLng = dMarkerLng;
	imgDMapZoom = dMapZoom;
}

/* --------------------- 초기 설정 함수 --------------------*/

//촬영 지점 설정
function setCenter(lat_str, lng_str, type) {
	map_type = type;
	var lat = parseFloat(lat_str);
	var lng = parseFloat(lng_str);
	
	if(map1 == null || map1 == undefined){
		init();
	}
	
	if(lat_str != 0 && lng_str != 0) {
		marker_latlng = new OpenLayers.LonLat(lng, lat);
		marker_latlng.transform(new OpenLayers.Projection("EPSG:4326"), map1.getProjectionObject());
// 		map.setZoom(17);
	}else{
		if(imgDMarkerLat == null || imgDMarkerLat == ""){
			imgDMarkerLat = 37.5666791;
		}
		if(imgDMarkerLng == null || imgDMarkerLng == ""){
			imgDMarkerLng = 126.9782914;
		}
		marker_latlng = new OpenLayers.LonLat(lng, lat);
		marker_latlng.transform(new OpenLayers.Projection("EPSG:4326"), map1.getProjectionObject());
	}
	
	var tmpMarkerIcon = "http://maps.google.com/mapfiles/ms/icons/red-dot.png";

	// 마커 추가
	if (map_type == 2) {
		var vectorLayer = new OpenLayers.Layer.Vector("dragMarker");
		map1.addLayer(vectorLayer);
		
 		var lonlat = new OpenLayers.LonLat(lng_str, lat_str);
 		lonlat.transform(new OpenLayers.Projection("EPSG:4326"), map1.getProjectionObject());
		var point = new OpenLayers.Geometry.Point(marker_latlng.lon, marker_latlng.lat);
		
		var featurePoint = new OpenLayers.Feature.Vector(
			point,
			{description: 'info'},
			{externalGraphic: tmpMarkerIcon, graphicHeight: 25, graphicWidth: 25, graphicXOffset: -12, graphicYOffset: -25 }
		);
		
		vectorLayer.addFeatures(featurePoint);
		
		var drag = new OpenLayers.Control.DragFeature(vectorLayer, {
			autoActivate: true,
			onComplete: function(feature) {
				map1.removeLayer(map1.getLayersByName("mainCircle")[0]);
				
				// 스타일 정의
				var circleStyle = new OpenLayers.Style({
					'strokeColor':'#07aca5',
					'strokeOpacity':0.8,
					'strokeWeight':1,
					'fillColor':'#07aca5',
					'fillOpacity':0.2
				});
				var circleStyleMap = new OpenLayers.StyleMap(circleStyle);
				
				var circles = new OpenLayers.Layer.Vector("mainCircle", {styleMap: circleStyleMap});
				map1.addLayer(circles);
				
				//var lonlat = new OpenLayers.LonLat(feature.geometry.x, feature.geometry.y);
// 				lonlat.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
				var point = new OpenLayers.Geometry.Point(lonlat.lon, lonlat.lat);
				var circle = OpenLayers.Geometry.Polygon.createRegularPolygon(point, 100, 40, 0);
				
				var featurecircle = new OpenLayers.Feature.Vector(circle);
				
				circles.addFeatures(featurecircle);
				
				//var newLonLat = new OpenLayers.LonLat(feature.geometry.x, feature.geometry.y);
				newLonLat.transform(new OpenLayers.Projection("EPSG:900913"), new OpenLayers.Projection("EPSG:4326"));
				parent.setExifData(newLonLat.lat, newLonLat.lon);
			}
		});
		
		map1.addControl(drag);
		map1.setCenter(lonlat, 17);
	} else {
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
// 		var lonlat = new OpenLayers.LonLat(marker_latlng.lon, marker_latlng.lat);
// 		lonlat.transform(new OpenLayers.Projection("EPSG:4326"), map1.getProjectionObject());
		var marker = new OpenLayers.Marker(marker_latlng, icon);
		
		markers.addMarker(marker);
		map1.setCenter(marker_latlng, 17);
	}
}
// var bounds = new google.maps.LatLngBounds();

//촬영 각도와 거리를 계산하여 지도에 표현
function setAngle(direction_str, focal_str) {
	var direction = parseInt(direction_str);
	var focal = parseFloat(focal_str);
	parent.setNewDirection = direction_str;
	parent.setNewFocal = focal_str; 
	
	fov = getFOV(focal);
	view_value = getViewLength(0.3); //km 단위
	
	if(direction>0 && focal>0) {
		setViewPoint(marker_latlng, view_value, direction);
		createViewPolygon(view_value, direction, fov);
		createViewPolyline(marker_latlng, direction_latlng);
// 		createViewMarker(direction_latlng);
	}
}
//화각 구하기
getFOV = function(focal_length) {
	//var diagonalLength = Math.sqrt(Math.pow(36, 2) + Math.pow(24, 2));
	//var diagonalLength = Math.sqrt(Math.pow(3.626, 2) + Math.pow(2.709, 2));
	var fov = (2 * Math.atan(3.626 / (2 * focal_length))) * 180 / Math.PI;
	
	return fov;
};
//촬영 거리 구하기
getViewLength = function(focus) {
	return focus;
};

//촬영 각도 및 거리에 맞추어 좌표 설정
function setViewPoint(point, km, direction) {
	var rad = (km * 1000) / 1609.344;
	var d2r = Math.PI / 180;
	var circleLatLngs = new Array();
	var circleLat = (rad / 3963.189) / d2r;
	var circleLng = circleLat / Math.cos(point.lat * d2r);
	
	var theta = direction * d2r;
	var vertexLat = point.lat + (circleLat * Math.cos(theta));
	var vertexLng = point.lon + (circleLng * Math.sin(theta));
// 	direction_latlng = new google.maps.LatLng(parseFloat(vertexLat), parseFloat(vertexLng));
	direction_latlng = new OpenLayers.LonLat(parseFloat(vertexLng), parseFloat(vertexLat));
}
//촬영 범위를 폴리곤으로 표현
function createViewPolygon(km, direction, angle) {
	direction = parseInt(direction);
	var angle_val = angle / 2;
	var min_direction = direction - angle_val;
	if(min_direction<0) min_direction = min_direction + 360;
	var max_direction = direction + angle_val;
	if(max_direction>360) max_direction = Math.abs(360 - max_direction);
	
	var rad = (km * 1000) / 1609.344;
	var d2r = Math.PI / 180;
	var circleLatLngs = new Array();
	var circleLat = (rad / 3963.189) / d2r;
	var circleLng = circleLat / Math.cos(marker_latlng.lat * d2r);
	circleLatLngs.push(marker_latlng);
	
	var theta, vertexLat, vertexLng, vertextLatLng;
	if(min_direction<max_direction) {
		for(var i=min_direction; i<max_direction; i++) {
			theta = i * d2r;
			vertexLat = marker_latlng.lat + (circleLat * Math.cos(theta));
			vertexLng = marker_latlng.lon + (circleLng * Math.sin(theta));
// 			vertextLatLng = new google.maps.LatLng(parseFloat(vertexLat), parseFloat(vertexLng));
			vertextLatLng = new OpenLayers.LonLat(parseFloat(vertexLng), parseFloat(vertexLat));
			if(i==0) { circleLatLngs.push(marker_latlng); }
// 			if(i==direction) { direction_latlng = new google.maps.LatLng(parseFloat(vertexLat), parseFloat(vertexLng)); }
			if(i==direction) { direction_latlng = new OpenLayers.LonLat(parseFloat(vertexLng), parseFloat(vertexLat)); }
			circleLatLngs.push(vertextLatLng);
		}
	}
	else {
		for(var i=min_direction; i<361; i++) {
			theta = i * d2r;
			vertexLat = marker_latlng.lat + (circleLat * Math.cos(theta));
			vertexLng = marker_latlng.lon + (circleLng * Math.sin(theta));
// 			vertextLatLng = new google.maps.LatLng(parseFloat(vertexLat), parseFloat(vertexLng));
			vertextLatLng = new OpenLayers.LonLat(parseFloat(vertexLat), parseFloat(vertexLng));
			if(i==min_direction) { circleLatLngs.push(marker_latlng); }
// 			if(i==direction) { direction_latlng = new google.maps.LatLng(parseFloat(vertexLat), parseFloat(vertexLng)); }
			if(i==direction) { direction_latlng = new OpenLayers.LonLat(parseFloat(vertexLng), parseFloat(vertexLat)); }
			circleLatLngs.push(vertextLatLng);
		}
		for(var i=0; i<max_direction; i++) {
			theta = i * d2r;
			vertexLat = marker_latlng.lat + (circleLat * Math.cos(theta));
			vertexLng = marker_latlng.lon + (circleLng * Math.sin(theta));
			vertextLatLng = new google.maps.LatLng(parseFloat(vertexLat), parseFloat(vertexLng));
// 			if(i==direction) { direction_latlng = new google.maps.LatLng(parseFloat(vertexLat), parseFloat(vertexLng)); }
			if(i==direction) { direction_latlng = new OpenLayers.LonLat(parseFloat(vertexLng), parseFloat(vertexLat)); }
			circleLatLngs.push(vertextLatLng);
		}
	}
	
// 	if(draw_angle!=null) draw_angle.setMap(null);
	
	draw_angle = new OpenLayers.Layer.Vector("mainSector");
	
	var sectorLine = new OpenLayers.Geometry.LineString(circleLatLngs);
	var angle = new OpenLayers.Feature.Vector(sectorLine);
	
	var ftArcPt0 = new OpenLayers.Feature.Vector(circleLatLngs[1]);
	var ftArcPt1 = new OpenLayers.Feature.Vector(circleLatLngs[circleLatLngs.length-2]);
	var ftArcSehne = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.LineString([circleLatLngs[1], circleLatLngs[circleLatLngs.length-2]]));
	var arrArc = [angle, ftArcPt0, ftArcPt1, ftArcSehne];
	
	draw_angle.addFeatures([angle, ftArcPt0, ftArcPt1, ftArcSehne]);
// 	draw_angle = new google.maps.Polygon({
// 		paths: circleLatLngs,
// 		strokeColor: "#FF0000",
// 		strokeOpacity: 0.8,
// 		strokeWeight: 2,
// 		fillColor: "#FF0000",
// 		fillOpacity: 0.3
// 	});
// 	draw_angle.setMap(map);
}
//촬영 위치와 촬영 범위 위치를 선으로 연결
function createViewPolyline(point1, point2) {
	draw_direction = new OpenLayers.Layer.Vector("mainLine");
	map1.addLayer(draw_direction);
	
	var start = new OpenLayers.LonLat(point1.lon, point1.lat);
// 	start.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
	
	var end = new OpenLayers.LonLat(point2.lon, point2.lat);
// 	end.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
	
	var startPoint = new OpenLayers.Geometry.Point(start.lon, start.lat);
	var endPoint = new OpenLayers.Geometry.Point(end.lon, end.lat);
	
	var line = [startPoint, endPoint];
// 	var vector = new OpenLayers.Layer.Vector("line");
	var geom = new OpenLayers.Geometry.LineString(line);
	
	draw_direction.addFeatures([new OpenLayers.Feature.Vector(geom)]);
}
//촬영 범위 좌표 설정
function createViewMarker(point) {
	var marker_image = "<c:url value='/images/geoImg/maps/view_marker.png'/>";
	
	if(view_marker==null || marker == undefined) {
		var drag = false;
		if(map_type==2 || imgCoordinate) drag = true;
		view_marker = new google.maps.Marker({
			position: point,
			map: map,
			title: "View",
			icon: marker_image,
			draggable: drag
		});
	}
	else {
		view_marker.setPosition(point);
	}
	if(map_type==2 || imgCoordinate) {
		google.maps.event.addListener(view_marker, 'dragend', function() {
			dragEvent(1);
		});
		google.maps.event.addListener(marker, 'dragend', function() {
			dragEvent(2);
		});
	}

	if(!imgCoordinate){
		bounds.extend(point);
		map.fitBounds(bounds);
	}
}
//마커 드래그 이벤트
function dragEvent(type) {
	draw_direction.setPath([marker.getPosition(), view_marker.getPosition()]);
	if(type==2 || imgCoordinate) {marker_latlng = new google.maps.LatLng(marker.getPosition().lat(), marker.getPosition().lng());}
	var km = draw_direction.inKm();
	var degree = draw_direction.Bearing();
	parent.setNewDirection = degree;
	parent.setNewFocal = 3.626 / (2 * Math.tan(Math.PI * fov / 360));
// 	double fov = (2 * Math.atan(diagonalLength / (2 * focalLength))) * 180 / Math.PI;
// 	var fov = (2 * Math.atan(3.626 / (2 * focal_length))) * 180 / Math.PI;
// 	 double focal = 3.626 / (2 * Math.tan(Math.PI * fov / 360));
	
	createViewPolygon(km, degree, fov);
	parent.setExifData(marker.getPosition().lat(), marker.getPosition().lng(), parseInt(degree));
}

//좌표없는 마커 드래그 이벤트
function dragEventEmpty() {
	parent.setExifData(marker.getPosition().lat(), marker.getPosition().lng(), 0);
	if(circle!=null){
		drawCircleOnMap(marker.getPosition().lat(), marker.getPosition().lng(), 100, 2);
	}
}

/**
 * 반경 그리기
 * @param : xy 좌표, 반경사이즈
 */
function drawCircleOnMap(lat_str, lng_str, radius, rType){ //반경중앙좌표, 반경(단위: m)
	if (map1.getLayersByName("mainCircle").length > 0) {
		$.each(map1.getLayersByName("mainCircle"), function(idx, val) {
			val.removeFeatures(val.features[0]);
		});
		
		$.each(map1.getLayersByName("mainCircle"), function(idx, val) {
			map1.removeLayer(val);
		});
	}
	
	// 스타일 정의
	var circleStyle = new OpenLayers.Style({
		'strokeColor':'#07aca5',
		'strokeOpacity':0.8,
		'strokeWeight':1,
		'fillColor':'#07aca5',
		'fillOpacity':0.2
	});
	var circleStyleMap = new OpenLayers.StyleMap(circleStyle);
	
 	var lat = parseFloat(lat_str);
	var lng = parseFloat(lng_str);
	
	var circles = new OpenLayers.Layer.Vector("mainCircle", {styleMap: circleStyleMap});
	map1.addLayer(circles);
	
	var lonlat = new OpenLayers.LonLat(lng, lat);
	lonlat.transform(new OpenLayers.Projection("EPSG:4326"), map1.getProjectionObject());
	var point = new OpenLayers.Geometry.Point(lonlat.lon, lonlat.lat);
	var circle = OpenLayers.Geometry.Polygon.createRegularPolygon(point, radius, 40, 0);
	
	var featurecircle = new OpenLayers.Feature.Vector(circle);
	
	circles.addFeatures(featurecircle);
}

//-------------------------------------------------------------좌표 추가------------------------------------------------

//촬영 지점 설정
function graySetCenter() {
	imgCoordinate = true;
	
	if(map1 == null || map1 == undefined){
		init();
	}
	
	if(imgDMarkerLat == null || imgDMarkerLat == "" || imgDMarkerLat == 0){
		imgDMarkerLat = 37.5666791;
	}
	if(imgDMarkerLng == null || imgDMarkerLng == "" || imgDMarkerLng == 0){
		imgDMarkerLng = 126.9782914;
	}
	marker_latlng = new OpenLayers.LonLat(imgDMarkerLng, imgDMarkerLat);
// 	var center = new OpenLayers.LonLat(imgDMarkerLng, imgDMarkerLat);
	marker_latlng.transform(new OpenLayers.Projection("EPSG:4326"), map1.getProjectionObject());
	map1.setCenter(marker_latlng, 16);
	
// 	var marker_image = "<c:url value='/images/geoImg/maps/photo_marker.png'/>";
	var tmpMarkerIcon = "http://maps.google.com/mapfiles/ms/icons/red-dot.png";

	// 마커 추가
	var markers = new OpenLayers.Layer.Markers("mainMarker");
	map1.addLayer(markers);
	
	var size = new OpenLayers.Size(25, 25);
	var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
	var icon = new OpenLayers.Icon(tmpMarkerIcon, size, offset);
// 	var lonlat = new OpenLayers.LonLat(imgDMarkerLng, imgDMarkerLat);
// 	lonlat.transform(new OpenLayers.Projection("EPSG:4326"), map1.getProjectionObject());
	var marker = new OpenLayers.Marker(marker_latlng, icon);
	
	markers.addMarker(marker);
	
	marker.events.register('click', marker, function(e) {
		var latitude = event.latLng.lat;
		var longitude = event.latLng.lng;
		var newLonLat = new OpenLayers.LonLat(longitude, latitude);
		var newPx = map1.getLayerPxFromLonLat(newLonLat);
		map1.getLayersByName("mainMarker")[0].markers[0].moveTo(newPx);
		marker_latlng = newLonLat;
		setAngle(100, 5);
	});
	
	//앵글 추가
	setAngle(100, 5);
	
	$('.imgModeCls2').css('display','block');
	
// 	$('#searchDefaultPlace').val("");
	
	$('.imgModeCls2').css('display','block');
}

// var mapAutocomplete = null;
// //place text click
// function onPlaceChanged() {
// 	var place = mapAutocomplete.getPlace();
//     if (place.geometry) {
//       map.panTo(place.geometry.location);
//       map.setZoom(15);
//       marker.setPosition(place.geometry.location);
//       marker_latlng = new google.maps.LatLng(place.geometry.location);
//       setAngle(100, 5);
//     }else {
//       document.getElementById('searchDefaultPlace').placeholder = 'Enter a city';
//     }
// }

function grayMarkerSet(setType){
	imgCoordinate = false;
	if(setType == 'ok'){
// 		$('.imgModeCls2').css('display','none');
		parent.setNewMarkerLat = marker.getPosition().lat();
		parent.setNewMarkerLng = marker.getPosition().lng();
		google.maps.event.clearListeners(map, 'click');
		marker.setDraggable = false;
		
	}else if(setType == 'cancel'){
		if(marker != null && marker != undefined){
			marker.setDraggable = false;
			google.maps.event.clearListeners(map, 'click');
			$('.imgModeCls2').css('display','none');
		}
		
	}else if(setType == 'reset'){
		setNewMarkerLat = imgDMarkerLat;
		setNewMarkerLng = imgDMarkerLng;
		
		marker_latlng = new google.maps.LatLng(imgDMarkerLat, imgDMarkerLng);
		map.setZoom(imgDMapZoom);
		map.setCenter(marker_latlng);
	}
}
</script>
</head>

<body style='margin:0px; padding:0px;' onload='init();'>
	<!-- center setting -->
<!-- 	<div class="imgModeCls1" id="morkerModeOpen" onclick="defaultMarkerSet('open');" style="display: none; height: 30px;width: 130px;position: absolute;left: 100px;top: 10px;z-index: 9;background-color: #ffffff;text-align: center;cursor: pointer;"> -->
<!-- 		<div style="margin-top: 3px; display: inline-block;">Set default location</div> -->
<!-- 	</div> -->
	<div class="imgModeCls2" id="morkerModeReset" onclick="grayMarkerSet('reset');" style="display: none; height: 30px;width: 50px;position: absolute;left: 105px;top: 10px;z-index: 9;background-color: #ffffff;text-align: center;cursor: pointer;">
		<div style="margin-top: 3px; display: inline-block;">Reset</div>
	</div>
	
	<!-- <div class="imgModeCls2" style="display: none;height: 30px;width: 290px;position: absolute;left: 40px;/* top: 10px; */z-index: 9;text-align: center;cursor: pointer;">
		<input type="text" id="searchDefaultPlace" style="margin-top: 3px; display: inline-block; width: 100%;" placeholder="Enter location">
	</div> -->
	
	<div id="map" style="width:100%; height:100%;"></div>
</body>
</html>
