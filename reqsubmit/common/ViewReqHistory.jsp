<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="./RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/
	
	/**요구정보 파라미터 체크..*/
	boolean blnParamCheck=false;
	String strReqInfoID=(String)request.getParameter("ReqInfoID");
	if(!StringUtil.isAssigned(strReqInfoID)){
		strReqInfoID=(String)request.getParameter("ReqID");
		if(StringUtil.isAssigned(strReqInfoID)){
			blnParamCheck=true;
		}
	} else {
		blnParamCheck=true;
	}
	/**전달된 파리미터 체크 */
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("요구정보ID가 전달되지 않았습니다");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif

	/*************************************************************************************************/
	/** 					데이터 호출 Part 														  */
	/*************************************************************************************************/

	/*** 데이터 Container객체 선언 */
	ResultSetHelper objRs=null;				/** 답변정보 목록 출력*/
	try{
	
		/**요구 정보 대리자 New */
		RequestInfoDelegate objReqInfo=new RequestInfoDelegate();
		/**요구함 이용 권한 체크 */
		
		objRs=new ResultSetHelper(objReqInfo.getRequestInfoHistory(strReqInfoID));
	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
%>

<jsp:include page="/inc/header.jsp" flush="true"/>

<style>
.scrolltbody {
    display: block;
    width: 100%;
    
}

.scrolltbody tbody {
    display: block;
    height: 200px;
    overflow: auto;
}
.scrolltbody th:nth-of-type(1), .scrolltbody td:nth-of-type(1) { width: 40px; }
.scrolltbody th:nth-of-type(2), .scrolltbody td:nth-of-type(2) { width: 120px; }
.scrolltbody th:nth-of-type(3), .scrolltbody td:nth-of-type(3) { width: 250px; }
.scrolltbody th:last-child { width: 150px; }
.scrolltbody td:last-child { width: calc( 150px - 19px );  }
</style>
</head>

<body>
<div class="popup">
    <p>요구이력보기</p>

    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%" style="padding:10px;">  <!-- list --> 
        <!-- <span class="list01_tl">요구 목록 <span class="list_total">&bull;&nbsp;전체자료수 : 2개 </span></span> -->
        
        
        
        
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="scrolltbody popup_lis">
        	
          <thead>
            <tr>
          
              <th scope="col" >NO</th>
              <th scope="col" >작업</th>
              <th scope="col" >이력내용</th>
              <th scope="col" >작업일<img src="/images2/btn/bt_td.gif" width="11" height="11" alt="" /></th>
             
            </tr>
          </thead>
   
          <tbody>          	
        <%
         int intCounter=1;
         while(objRs.next()){
        %>
            <tr>
              <td ><%=intCounter%></td>
              <td ><%=objRs.getObject("DOING_JOB")%></td>   
              <td ><%=objRs.getObject("DOING_CONTENT")%></td>
              <td ><%= StringUtil.getDate2((String)objRs.getObject("REAL_DATE")) %></td>
            </tr>
        <%
          intCounter++;
         }//endwhile
        %>
          </tbody>
        </table>
        
        <!-- /list --> 


        
       </td>
        </tr>
    </table>
    <p style= "height:2px;padding:0;"></p>
    <!-- 리스트 버튼-->
    <div id="btn_all" class="t_right"> <span class="list_bt"><a href="javascript:self.close();">창닫기</a></span>&nbsp;&nbsp;</div>
    <!-- /리스트 버튼--> 
</div>
</body>
</html>