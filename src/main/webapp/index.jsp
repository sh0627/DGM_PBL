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
    <script>
    
    // Openlayers를 이용하여 지도 생성 
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
          		center: [128.610129, 35.889253]
         	 	,zoom: 17
         	 	,projection : 'EPSG:4326'
       		 })
      	});
      	
		// Geoserver로부터 위험지역을 이미지(png)형식으로 openlayers 지도에 위에 표시
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
		
		
	 // FireBase SDK
 	 const firebaseConfig = {
   	 apiKey: "AIzaSyB5x9AcJA5JN9zWXj-9SjbHRlaG_-Ywfzo",
   	 authDomain: "gis-test-b5ceb.firebaseapp.com",
   	 databaseURL: "https://gis-test-b5ceb-default-rtdb.firebaseio.com",
   	 projectId: "gis-test-b5ceb",
   	 storageBucket: "gis-test-b5ceb.appspot.com",
   	 messagingSenderId: "781890371927",
   	 appId: "1:781890371927:web:a3156f7ecc0f225091fe12",
   	 measurementId: "G-KRRXTJZR71"
 	 };

  	  firebase.initializeApp(firebaseConfig);
	  
	  const database = firebase.database();
	  let vectorLayer;
	  
	  
	  // FireBase 실시간 데이터베이스 내의 GPS 좌표를 갱신
	  database.ref("/GPS_Information/-Njm3wiyPOCqplIZN76C").on("value",snapshot => {
		  const object = snapshot.val();		
		  const latitude = object.latitude;
      	  const longitude = object.longitude  
      	  
      	  // 이전에 생성한 벡터 레이어가 존재하는 경우 제거
 		 if (vectorLayer) {
    		map.removeLayer(vectorLayer);
  		 }		 		          	
		 		          	
      	// 128.611696 , 35.887483 longitude, latitude
      	// 점을 표시할 위치를 정의합니다.
      var point = new ol.Feature({
        geometry: new ol.geom.Point([longitude, latitude]) // 위도와 경도 값을 기준으로 점의 좌표를 설정합니다.
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
      vectorLayer = new ol.layer.Vector({
		properties: {
			name: 'location'
		},
        source: new ol.source.Vector({
          features: [point] // 점을 포함하는 Feature를 추가합니다.
        }),
        style: style // 스타일을 적용합니다.
      });
                
      map.addLayer(vectorLayer);   
	});
    </script>
    <%
    Connection connection = null;
    Statement st = null;
    ResultSet rs = null;
    
    // PostgreSQL SDK 
    String url = "jdbc:postgresql://localhost:5432/gis_test";
    String user = "postgres";
    String password = "1234";
    
    // PostgreSQL 내에서 사용자의 위치가 위험구역에 진입하였을 때 진입했다는 것을 표시
    try
    {
    	String driver = "org.postgresql.Driver";
    	Class.forName(driver);
    	
    	connection = DriverManager.getConnection(url,user,password);
    	st = connection.createStatement();
    	
    	String query = "SELECT CASE WHEN ST_Contains(a.geom, b.geom) THEN 1 ELSE 0 END as is_contained FROM knu a, gis_point b";
    	rs = st.executeQuery(query);
    	
    	while(rs.next()){
         out.println(rs.getInt("is_contained"));
    	}
    } catch (SQLException ex){
    	throw ex;
    }
    %>
  </body>
</html>
