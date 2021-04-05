<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
<%@ include file="/common/CheckSession.jsp" %>

<%
	ArrayList objItetArry = new ArrayList();
	String strForumNotice = "";
	String strForumFree = "";

	String strFreeBoard = "";
	String strNoticeBoard = "";
	String strReportBoard = "";
	String strDataBoard = "";
	String strUserId = "";

	try{
		strUserId = (String)session.getAttribute("USER_ID");

		nads.dsdm.app.activity.useritet.UserItetDelegate objUserItetDelegate = new nads.dsdm.app.activity.useritet.UserItetDelegate();

		objItetArry = objUserItetDelegate.selectUserItetinfo(strUserId);

		Config objConfig = PropertyConfig.getInstance();
		strForumNotice = objConfig.get("activity.useritet.forumNotice");
		strForumFree = objConfig.get("activity.useritet.forumFree");


		strFreeBoard = objConfig.get("activity.useritet.board.freeBoard");
		strNoticeBoard = objConfig.get("activity.useritet.board.noticeBoard");
		strReportBoard = objConfig.get("activity.useritet.board.reportBoard");
		strDataBoard = objConfig.get("activity.useritet.board.dataBoard");
	}
	catch(AppException objAppEx)
	{
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>

</head>

<body>
<script src='/js/forum.js'></script>
<script src='/js/activity.js'></script>

<script language="javascript">
	function fun_winopen(strUrl, strTitle){
		window.open(strUrl, strTitle, "status=yes, resizable=yes, menubar=yes,scrollbars=yes");
	}

	function fun_busowinopen(strUrl, strNm){
		window.open(strUrl, strNm);
	}
</script>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu01.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu01.jsp" flush="true"/>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg_my.jpg) no-repeat left top;">
        <h3>관심정보 <!-- <span class="sub_stl" >- 상세보기</span> --></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > 나의페이지 > 관심정보</div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 각페이지 내용 -->

        <div class="myP">
<%
	Hashtable objPrgHt = new Hashtable();
	String strPrgId = "";
	String strPrgNm = "";
	String strPrgUrl = "";
	String strPrgSrc = "";
	Vector objPrgSrcVt = new Vector();

	String strUserGubn = (String)session.getAttribute("IS_REQUESTER");
	String strInOutGbun = (String)session.getAttribute("INOUT_GBN");

	for(int k=0; k<objItetArry.size(); k++){
		objPrgHt = (Hashtable)objItetArry.get(k);
		strPrgId = (String)objPrgHt.get("APP_ID");
		strPrgNm = (String)objPrgHt.get("APP_NM");
		strPrgUrl = (String)objPrgHt.get("APP_URL");
		objPrgSrcVt = nads.lib.util.ActComm.makeNoType(strPrgUrl, "/");
		strPrgSrc = (String)objPrgSrcVt.elementAt(objPrgSrcVt.size() - 1);
		if(k != 0){
%>

<%
		}
		//--포럼목록-포럼
		if(strPrgSrc.equals("ForumSearch.jsp")){
%>
<%@ include file="useritet/Con_ForumSearch.jsp" %>
<%
			continue;
		}
%>
 <p class="mt20"></p> <!-- 위테이블과의 공간 확보를 위해 넣어줍니다 -->
<%
		//--포럼공지사항-포럼
		if(strPrgSrc.equals("ForumBoardList.jsp") && strForumNotice.equals(strPrgId)&&1==2){
%>
<%//@ include file="useritet/Con_ForumBoardList.jsp" %>
<%
			continue;
		}
%>
<p class="mt20"></p> <!-- 위테이블과의 공간 확보를 위해 넣어줍니다 -->
<%
		//--포럼자유게시판-포럼
		if(strPrgSrc.equals("ForumBoardList.jsp") && strForumFree.equals(strPrgId)&&1==2){
%>
<%//@ include file="useritet/Con_ForumBoardList.jsp" %>
<%
			continue;
		}
%>
<p class="mt20"></p> <!-- 위테이블과의 공간 확보를 위해 넣어줍니다 -->
<%
		//--관련기관 웹 사이트 검색-정보검색
		if(!strInOutGbun.equals("X") && strPrgSrc.equals("ISearch_Relation.jsp")&&1==2){
			//임시
%>
<%//@ include file="useritet/Con_ISearch_Relation.jsp" %>
<%
			continue;
		}
%>
<p class="mt20"></p> <!-- 위테이블과의 공간 확보를 위해 넣어줍니다 -->
<%
		//--위원회 홈페이지 검색-정보검색
		if(strPrgSrc.equals("ISearch_Committee.jsp")){
			//임시
%>
<%//@ include file="useritet/Con_ISearch_Committee.jsp" %>
<%
			continue;
		}
%>
<p class="mt20"></p> <!-- 위테이블과의 공간 확보를 위해 넣어줍니다 -->
<%
		//--뉴스검색-정보검색
		if(strPrgSrc.equals("SelectNewList.jsp")){
			//임시
%>
<%@ include file="useritet/Con_SelectNewList.jsp" %>
<%
			continue;
		}
%>
<p class="mt20"></p> <!-- 위테이블과의 공간 확보를 위해 넣어줍니다 -->
<%
		//--정부제출목록-서류제출
		if(strPrgSrc.equals("SGovSubDataBoxList.jsp")){
			//임시
%>
<%@ include file="useritet/Con_SGovSubDataBoxList.jsp" %>
<%
			continue;
		}
%>
<p class="mt20"></p> <!-- 위테이블과의 공간 확보를 위해 넣어줍니다 -->
<%
		//--공개요구제출목록-서류제출
		if(strUserGubn.equals("true") && strPrgSrc.equals("ROpenReqList.jsp")){
			//임시
%>
<%@ include file="useritet/Con_ROpenReqList.jsp" %>
<%
			continue;
		}
%>
<p class="mt20"></p> <!-- 위테이블과의 공간 확보를 위해 넣어줍니다 -->

<%
		//--요구/제출목록
		if(strPrgSrc.equals("RSubReqList.jsp")){
			//임시
%>
<%@ include file="useritet/Con_RSubReqList.jsp" %>
<%
			continue;
		}
%>
<p class="mt20"></p> <!-- 위테이블과의 공간 확보를 위해 넣어줍니다 -->
<%
		//--공개업무정보-나의의정활동

		if(strInOutGbun.equals("I") && strPrgSrc.equals("OpenBizInfo.jsp")){  //요구자일 경우에만 공개업무정보를 보여준다.
			//임시
%>
<%@ include file="useritet/Con_OpenBizInfo.jsp" %>
<%
			continue;
		}
%>
<p class="mt20"></p> <!-- 위테이블과의 공간 확보를 위해 넣어줍니다 -->
<%
		//--개인업무정보-나의의정활동
		if(strInOutGbun.equals("I") && strPrgSrc.equals("BizInfo.jsp")){  //요구자일 경우에만 업무정보를 보여준다.
			//임시
%>
<%@ include file="useritet/Con_BizInfo.jsp" %>
<%
			continue;
		}
%>
<p class="mt20"></p> <!-- 위테이블과의 공간 확보를 위해 넣어줍니다 -->
<%
		//--게시판
		if(strPrgSrc.equals("BoardList.jsp")){
%>
<%@ include file="useritet/Con_BoardList.jsp" %>
<%
			continue;
		}
%>
<p class="mt20"></p> <!-- 위테이블과의 공간 확보를 위해 넣어줍니다 -->
<%
	}
%>
       <!-- list -->
<!--  해당 게시판 목록을 Include 하기 때문에 하위 Html은 각 include 페이지에 적용한다.

          <span class="list01_tl">
          공지사항<span class="sbt"><a href="#"><img src="/images2/btn/bt_all.gif" width="78" height="19" /></a></span></span>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
            <thead>
              <tr>
                <th scope="col">NO</th>
                <th scope="col" style="width:300px; "><a href="#">요구제목</a></th>
                <th scope="col"><a href="#">위원회</a></th>
                <th scope="col"><a href="#">제출기관</a></th>
                <th scope="col">답변</th>
                <th scope="col"><a href="#">최종답변일<img src="/images2/btn/bt_td.gif" width="11" height="11" alt="" /></a></th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>1</td>
                <td style="text-align:left;"><a href="#">홍준표 의원실 등록 직원확인</a></td>
                <td>요구기관요구기관</td>
                <td>위원회이름위원회이름</td>
                <td><img src="/images2/common/icon_noAnswer.gif" width="26" height="20" /></td>
                <td>2011-07-11</td>
              </tr>
            </tbody>
          </table>

          !-- /list --


          !-- list --
          <p class="mt20"></p> !-- 위테이블과의 공간 확보를 위해 넣어줍니다 --
          <span class="list01_tl">
          자료실	<span class="sbt"><a href="#"><img src="../images2/btn/bt_all.gif" width="78" height="19" /></a></span></span>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
            <thead>
              <tr>
                <th scope="col">NO</th>
                <th scope="col" style="width:300px; "><a href="#">요구제목</a></th>
                <th scope="col"><a href="#">위원회</a></th>
                <th scope="col"><a href="#">제출기관</a></th>
                <th scope="col">답변</th>
                <th scope="col"><a href="#">최종답변일<img src="/images2/btn/bt_td.gif" width="11" height="11" alt="" /></a></th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>1</td>
                <td style="text-align:left;"><a href="#">홍준표 의원실 등록 직원확인</a></td>
                <td>요구기관요구기관</td>
                <td>위원회이름위원회이름</td>
                <td><img src="/images2/common/icon_noAnswer.gif" width="26" height="20" /></td>
                <td>2011-07-11</td>
              </tr>
            </tbody>
          </table>
-->
          <!-- /list -->
  <!-- 리스트 버튼-->
                <div id="btn_all" > <span class="right"> <span class="list_bt"><a href="/activity/SetupPerEnv_ConcernInfo.jsp">관심정보설정</a></span></span> </div>

                <!-- /리스트 버튼-->

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