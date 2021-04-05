<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
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
%>
<% 
 /*************************************************************************************************/
 /** 					데이터 호출 Part 														  */
 /*************************************************************************************************/
%>

<jsp:include page="/inc/header.jsp" flush="true"/>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<script language="JavaScript">
	//추가내용 확인.
	function checkInput(){
		if(formName.elements['Rsn'].value==""){
			alert("추가요구 사유를 입력해주세요");
			formName.elements['Rsn'].focus();
			return false;
		}
		if(formName.elements['Rsn'].value.length>255){
			alert("추가요구 사유를 255글자 이내로 작성해주세요!!");
			formName.elements['Rsn'].focus();
			return false;		
		}
		//window.returnValue=formName.elements['Rsn'].value;
		
		//20180917 hgyoo 추가답변요구
		var returnValue=formName.elements['Rsn'].value;
		
		window.opener.procAddAnswer(returnValue);	
		
		self.close();
	}
</script>
</head>

<body onblur="self.focus();">
<div class="popup">
    <p>추가 답변 요구</p>

    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%" style="padding:10px;">  <!-- list --> 
        <!-- <span class="list01_tl">요구 목록 <span class="list_total">&bull;&nbsp;전체자료수 : 2개 </span></span> -->
        
        
        
        
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="popup_lis">
          <thead>
            <tr>          
              <th scope="col">추가 요구 사유를 입력해 주세요.</th>
			</tr>
<form name="formName">
            <tr>          
              <td scope="col">
			  <textarea name="Rsn" wrap="hard" rows="5" style="width:100%;"></textarea>
			  </td>
            </tr>
          </thead>
        </table>
        
        <!-- /list --> 
       </td>
        </tr>
    </table>
    <p style= "height:2px;padding:0;"></p>
    <!-- 리스트 버튼-->
    <div id="btn_all" class="t_right">
	<span class="list_bt"><a href="#" onClick="javascript:checkInput()">등록</a></span>&nbsp;&nbsp;
	<span class="list_bt"><a href="#" onClick="javascript:self.close()">창닫기</a></span>&nbsp;&nbsp;
	</div>
</form>    
    <!-- /리스트 버튼--> 
</div>
</body>
</html>