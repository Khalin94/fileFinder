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
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
%>
<% 
 /*************************************************************************************************/
 /** 					������ ȣ�� Part 														  */
 /*************************************************************************************************/
%>

<jsp:include page="/inc/header.jsp" flush="true"/>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<script language="JavaScript">
	//�߰����� Ȯ��.
	function checkInput(){
		if(formName.elements['Rsn'].value==""){
			alert("�߰��䱸 ������ �Է����ּ���");
			formName.elements['Rsn'].focus();
			return false;
		}
		if(formName.elements['Rsn'].value.length>255){
			alert("�߰��䱸 ������ 255���� �̳��� �ۼ����ּ���!!");
			formName.elements['Rsn'].focus();
			return false;		
		}
		//window.returnValue=formName.elements['Rsn'].value;
		
		//20180917 hgyoo �߰��亯�䱸
		var returnValue=formName.elements['Rsn'].value;
		
		window.opener.procAddAnswer(returnValue);	
		
		self.close();
	}
</script>
</head>

<body onblur="self.focus();">
<div class="popup">
    <p>�߰� �亯 �䱸</p>

    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%" style="padding:10px;">  <!-- list --> 
        <!-- <span class="list01_tl">�䱸 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : 2�� </span></span> -->
        
        
        
        
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="popup_lis">
          <thead>
            <tr>          
              <th scope="col">�߰� �䱸 ������ �Է��� �ּ���.</th>
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
    <!-- ����Ʈ ��ư-->
    <div id="btn_all" class="t_right">
	<span class="list_bt"><a href="#" onClick="javascript:checkInput()">���</a></span>&nbsp;&nbsp;
	<span class="list_bt"><a href="#" onClick="javascript:self.close()">â�ݱ�</a></span>&nbsp;&nbsp;
	</div>
</form>    
    <!-- /����Ʈ ��ư--> 
</div>
</body>
</html>