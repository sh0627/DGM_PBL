# 📝Project

> DGM_PBL
>
> - 개발기간 : 2024.03 - 2024.06
> - 핵심 역할 : 팀원, "위치 기반 위험 구역 감시"의 주제로 JSP 내의 웹 페이지 지도에 구현하여 GPS의 위치가 위험구역에 진입 시 사용자에게 위험 알림을 보내는 시스템 구현
>   
>> - Language : JAVA, JSP
>> - IDE : Eclipse
>> - Skill : Firebase, PostgreSQL, PostGIS
>>
> <br/>
>
> - 프로젝트 내용
> ![image](https://github.com/user-attachments/assets/36306299-e1cc-416f-a503-af10df782786)
> <br/><br/><br/><br/>
> ![image](https://github.com/user-attachments/assets/249521aa-ee13-42f4-9fb4-f8f2c8082dd1)
> <br/><br/>
> PostgreSQL 내에서 PostGIS의 Geometry 타입을 이용히여 polygon(위험지역) 과 point(내 위치)의 SQL 작성
> <br/><br/><br/><br/>
> ![image](https://github.com/user-attachments/assets/013ae155-a6e9-4139-b380-0997591c6d81)
> <br/><br/>
> PostgreSQL에 저장된 polygon 데이터를 Geoserver를 이용해 JSP 내 지도에 이미지 영역으로 추가
> <br/><br/><br/><br/>
> ![image](https://github.com/user-attachments/assets/bc85b42d-6af3-451c-888c-05a4367d4053)
> <br/><br/>
> 앱으로 부터 받은 GPS 좌표가 저장된 Firebase를 연동하여(Firebase SDK 이용) JSP 내 지도에 추가
