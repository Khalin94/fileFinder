<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language="javascript">
	function openWin(url,width,height){
		var hWin;
		hWin = window.open(url, 'up' ,"toolbar=no,scrollbars=yes,left=1,top=1,width="+width+",height="+height+",resizable=no, screenX=0,screenY=0,top=100,left=100");
	}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu05.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu05.jsp" flush="true"/>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg_info.jpg) no-repeat left top;">
        <h3>시스템소개<!-- <span class="sub_stl" >- 상세보기</span> --></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > 이용안내 > 시스템소개</div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 각페이지 내용 -->

        <div class="myP">
        <p><img src="../images2/foundation/syetem_info_01.jpg"  /></p>
        
        </div>
          <!-- /각페이지 내용 -->
        </div>
        <!-- /contents -->

      </div>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
