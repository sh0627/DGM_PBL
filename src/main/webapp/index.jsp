<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Accessible Map</title>
    <link rel="stylesheet" href="https://openlayers.org/en/v4.6.5/css/ol.css" type="text/css">
    <!-- The line below is only needed for old environments like Internet Explorer and Android 4.x -->
    <script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
    <script src="https://openlayers.org/en/v4.6.5/build/ol.js"></script>
    <style>
      a.skiplink {
        position: absolute;
        clip: rect(1px, 1px, 1px, 1px);
        padding: 0;
        border: 0;
        height: 1px;
        width: 1px;
        overflow: hidden;
      }
      a.skiplink:focus {
        clip: auto;
        height: auto;
        width: auto;
        background-color: #fff;
        padding: 0.3em;
      }
      #map:focus {
        outline: #4A74A8 solid 0.15em;
      }
    </style>
  </head>
  <body>
    <a class="skiplink" href="#map">Go to map</a>
    <div id="map" class="map" tabindex="0"></div>
    <script src="https://www.gstatic.com/firebasejs/8.8.1/firebase-app.js"></script>
    <script src="https://www.gstatic.com/firebasejs/8.8.1/firebase-database.js"></script>
    <script src="https://www.gstatic.com/firebasejs/8.8.1/firebase-analytics.js"></script>
    <script src="https://www.gstatic.com/firebasejs/8.8.1/firebase-auth.js"></script>
    <script src="https://www.gstatic.com/firebasejs/8.8.1/firebase-firestore.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
	var map = new ol.Map({
			layers: [
          		new ol.layer.Tile({
            		source: new ol.source.OSM()
				})
			],
        	target: 'map',
        	controls: ol.control.defaults({
          		attributionOptions: {
            		collapsible: false
				}
       		}),
       		
        	view: new ol.View({
          		center: [128.601722 ,35.890442]
         	 	,zoom: 19
         	 	,projection : 'EPSG:4326'
       		 })
      	});
      	
      	var wms = new ol.layer.Tile({
		source : new ol.source.TileWMS({
			url : 'http://localhost:8089/geoserver/ne/wms', // 1. 레이어 URL
			params : {
				'VERSION' : '1.1.0', // 2. 버전
				'LAYERS' : 'ne:knu', // 3. 작업공간:레이어 명
				'BBOX' : [195386.296875, 451467.875, 202027.125, 458928.375], 
				'SRS' : 'EPSG:4326', // SRID
				'FORMAT' : 'image/png' // 포맷
				},
			serverType : 'geoserver',
			})
		});
	
		map.addLayer(wms); // 맵 객체에 레이어를 추가함	
		
		var point1 = new ol.Feature({
	        geometry: new ol.geom.Point([128.602054 , 35.890685]) // 위도와 경도 값을 기준으로 점의 좌표를 설정합니다.
	      });

	      // 점의 스타일을 설정합니다.
	      var style = new ol.style.Style({
	        image: new ol.style.Circle({
	          radius: 6,
	          fill: new ol.style.Fill({ color: 'red' }),
	          stroke: new ol.style.Stroke({ color: 'white', width: 2 })
	        })
	      });

	      // 점을 표시할 벡터 레이어를 생성합니다.
	      var vectorLayer1 = new ol.layer.Vector({
			properties: {
				name: 'location'
			},
	        source: new ol.source.Vector({
	          features: [point1] // 점을 포함하는 Feature를 추가합니다.
	        }),
	        style: style // 스타일을 적용합니다.
	      });
	      var point2 = new ol.Feature({
		        geometry: new ol.geom.Point([128.601857,35.890588]) // 위도와 경도 값을 기준으로 점의 좌표를 설정합니다.
		      });

		      // 점의 스타일을 설정합니다.
		      var style = new ol.style.Style({
		        image: new ol.style.Circle({
		          radius: 6,
		          fill: new ol.style.Fill({ color: 'red' }),
		          stroke: new ol.style.Stroke({ color: 'white', width: 2 })
		        })
		      });

		      // 점을 표시할 벡터 레이어를 생성합니다.
		      var vectorLayer2 = new ol.layer.Vector({
				properties: {
					name: 'location'
				},
		        source: new ol.source.Vector({
		          features: [point2] // 점을 포함하는 Feature를 추가합니다.
		        }),
		        style: style // 스타일을 적용합니다.
		      });
		      
		      var point3 = new ol.Feature({
			        geometry: new ol.geom.Point([128.601722 ,35.890442]) // 위도와 경도 값을 기준으로 점의 좌표를 설정합니다.
			      });

			      // 점의 스타일을 설정합니다.
			      var style = new ol.style.Style({
			        image: new ol.style.Circle({
			          radius: 6,
			          fill: new ol.style.Fill({ color: 'red' }),
			          stroke: new ol.style.Stroke({ color: 'white', width: 2 })
			        })
			      });

			      // 점을 표시할 벡터 레이어를 생성합니다.
			      var vectorLayer3 = new ol.layer.Vector({
					properties: {
						name: 'location'
					},
			        source: new ol.source.Vector({
			          features: [point3] // 점을 포함하는 Feature를 추가합니다.
			        }),
			        style: style // 스타일을 적용합니다.
			      });
			      
			      var point4 = new ol.Feature({
				        geometry: new ol.geom.Point([128.601682 ,35.890364]) // 위도와 경도 값을 기준으로 점의 좌표를 설정합니다.
				      });

				      // 점의 스타일을 설정합니다.
				      var style = new ol.style.Style({
				        image: new ol.style.Circle({
				          radius: 6,
				          fill: new ol.style.Fill({ color: 'red' }),
				          stroke: new ol.style.Stroke({ color: 'white', width: 2 })
				        })
				      });

				      // 점을 표시할 벡터 레이어를 생성합니다.
				      var vectorLayer4 = new ol.layer.Vector({
						properties: {
							name: 'location'
						},
				        source: new ol.source.Vector({
				          features: [point4] // 점을 포함하는 Feature를 추가합니다.
				        }),
				        style: style // 스타일을 적용합니다.
				      });
	                
	    
	      
	      
	      
	
    </script>
  </body>
</html>