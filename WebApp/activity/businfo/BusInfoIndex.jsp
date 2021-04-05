<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<title>국회 의정활동 서류제출 정보관리 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../../css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
  function fun_delete(){
    form_main.submit();
  }

  function fun_organ(strDocboxId, strOrganId){
  	
  	strTmp = "./../BizInfo.jsp?docbox_id=" + strDocboxId + "&organ_id=" + strOrganId;
    parent.location.href = strTmp;
  }  
  
  function fun_open(strOrganId){
  	
  	strTmp = "./../OpenBizInfo.jsp?organ_id=" + strOrganId;
    parent.location.href = strTmp;
  }    
	function fun_organleft(strDocboxId, strOrganId){  	
		strTmp = "/activity/BizInfo.jsp?docbox_id=" + strDocboxId + "&organ_id=" + strOrganId;
		parent.location.href = strTmp
	}  

	function fun_alldutyinfo(strInTmp, strOrganId){  //strInTmp : 사용하지 않는 변수로 fun_organleft와 변수개수를 맞추기 위해 사용.	
		strTmp = "/activity/AllOrganBizInfo.jsp?organ_id=" + strOrganId;
		parent.location.href = strTmp
	}  
	
	
</script>
<SCRIPT LANGUAGE="JavaScript" src="/js/bustree.js"></SCRIPT>
</HEAD>
<BODY >
<link href="/css/System.css" rel="stylesheet" type="text/css">  
	<table border="0" cellpadding="0" cellspacing="0" >	
	  <tr>
	    <td height="13" align="left" valign="top" class="menu_mypage">
		  <%@ include file="/activity/businfo/BusInfoDeptProc.jsp" %>	
	    </td>
	  </tr>
	</table>
</BODY>
</HTML>
