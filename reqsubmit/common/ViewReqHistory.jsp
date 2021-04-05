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
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/
	
	/**�䱸���� �Ķ���� üũ..*/
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
	/**���޵� �ĸ����� üũ */
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("�䱸����ID�� ���޵��� �ʾҽ��ϴ�");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/

	/*** ������ Container��ü ���� */
	ResultSetHelper objRs=null;				/** �亯���� ��� ���*/
	try{
	
		/**�䱸 ���� �븮�� New */
		RequestInfoDelegate objReqInfo=new RequestInfoDelegate();
		/**�䱸�� �̿� ���� üũ */
		
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
    <p>�䱸�̷º���</p>

    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%" style="padding:10px;">  <!-- list --> 
        <!-- <span class="list01_tl">�䱸 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : 2�� </span></span> -->
        
        
        
        
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="scrolltbody popup_lis">
        	
          <thead>
            <tr>
          
              <th scope="col" >NO</th>
              <th scope="col" >�۾�</th>
              <th scope="col" >�̷³���</th>
              <th scope="col" >�۾���<img src="/images2/btn/bt_td.gif" width="11" height="11" alt="" /></th>
             
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
    <!-- ����Ʈ ��ư-->
    <div id="btn_all" class="t_right"> <span class="list_bt"><a href="javascript:self.close();">â�ݱ�</a></span>&nbsp;&nbsp;</div>
    <!-- /����Ʈ ��ư--> 
</div>
</body>
</html>