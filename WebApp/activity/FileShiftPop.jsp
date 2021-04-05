<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>파일 이동/변경 및 삭제</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<link href="../css/System.css" rel="stylesheet" type="text/css">

<script language="javascript">
	function fun_move(){
		var varCnt;
		if(document.form_main.checkD != null){
			if(document.form_main.checkD.length == undefined){
				if(document.form_main.checkD.checked){
					if(document.form_main.chg_docbox_id.value == document.form_main.checkD.value){
						alert("폴더를 같은 이름으로 이동/변경할수 없습니다.");
						return
					}
				}			
			}else{
				varCnt = document.form_main.checkD.length;
			
				for(var i=0; i<varCnt; i++){
					if(document.form_main.checkD[i].checked){
						if(document.form_main.chg_docbox_id.value == document.form_main.checkD[i].value){
							alert("폴더를 같은 이름으로 이동/변경할수 없습니다.");
							return
						}
					}
				}		
			}
		}
		document.form_main.action = "./businfo/MoveDutyInfoProc.jsp";
		document.form_main.submit();				
	}

	function fun_delete(){

		document.form_main.action = "./businfo/DeleteDutyInfoProc.jsp";
		document.form_main.submit();
	}
</script>
</head>
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>
<%

	String strMessage = "";
	String strError = "yes";
	try
	{	
		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();
		int iResult = 0;

		HttpSession objSession = request.getSession();
		String strUserId = (String)objSession.getAttribute("USER_ID");	

		String strSize = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("tx_size"));
		String strDocboxId = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("docbox_id"));
		String strOrganId = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("organ_id"));
		String strSelectedOrganNm = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("organ_nm"));
		
		String strDocIds = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("doc_id"));
		String strDutyIds = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("duty_id"));	
		String strGubn = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("gubn")); //삭제인지 이동/변경인지 구분.

		
		Hashtable objParam = new Hashtable();
		Vector objDocVt = new Vector();
		Vector objDutyVt = new Vector();
		
		objParam.put("USER_ID", strUserId);
		
		if(strDocIds != null){
			objDocVt = ActComm.makeNoType(strDocIds, ",");
		}
		
		if(strDutyIds != null){
			objDutyVt = ActComm.makeNoType(strDutyIds, ",");

		}
		objParam.put("DOC_ID", objDocVt);
		objParam.put("DUTY_ID", objDutyVt);
		
		Hashtable objDocHt = objBusInfoDelegate.selectEqualUserIdInfo(objParam);
		
		ArrayList objResultDocIdArry = (ArrayList)objDocHt.get("DOC_ID");
		ArrayList objResultDutyIdArry = (ArrayList)objDocHt.get("DUTY_ID");
		String strEqual = (String)objDocHt.get("EQUAL");
		
		if ((objResultDocIdArry.size() + objResultDutyIdArry.size() < 1) 
			|| (strEqual.equals("N"))){  //strEqual => "N" 이면 선택한 데이터 중 작성자와 사용자가 틀릴 경우가 있음
%>
<script language="javascript">
<!--
	alert("업무정보의 작성자만 수정/변경할 수 있습니다.!");
	self.close();
//-->
</script>

<%
		}
		
%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="470" border="0" cellspacing="0" cellpadding="0">
<form name="form_main" method="post" action="./businfo/MoveDutyInfoProc.jsp">
<input type="hidden" name="user_id" value="<%=strUserId%>"><br>
<input type="hidden" name="organ_id"  value="<%=strOrganId%>"><br>
<input type="hidden" name="docbox_id"  value="<%=strDocboxId%>"><br>
  <tr class="td_mypage"> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td height="10"></td>
    <td height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td width="386" height="25" valign="middle"><span class="soti_reqsubmit"><img src="../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle"> 
      </span><span class="soti_mypage">파일 이동</span></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="2" colspan="2" class="td_mypage"></td>
        </tr>
        <tr class="td_top"> 
          <td width="36" height="22" align="center">&nbsp;</td>
          <td width="401" height="22" align="center">제 목</td>
        </tr>
        <tr> 
          <td height="1" colspan="2" class="td_mypage"></td>
        </tr>
 <%		
		/**** 분류함 테이블에서 작성자와 유저가 같은 데이터만 display -- start ****/
		String strDocId = "";
		String strDocNm = "";
		Hashtable objResultDocIdHt = new Hashtable();
		
		for(int j=0; j<objResultDocIdArry.size(); j++){
			objResultDocIdHt =(Hashtable)objResultDocIdArry.get(j);
			strDocId = (String)objResultDocIdHt.get("DOCBOX_ID");
			strDocNm = (String)objResultDocIdHt.get("DOCBOX_NM");
%>       
        <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
          <td height="11" align="center"><input type="checkbox" name="checkD" value="<%=strDocId%>" checked=true></td>
          <td height="25" class="td_lmagin">
            <img src="../image/common/icon_folder.gif" width="15" height="12" border="0">&nbsp;<%=strDocNm%></td>
        </tr>
        <tr class="tbl-line"> 
          <td height="1"></td>
          <td height="1"></td>
        </tr>
<%
		}//for(int j=0; j<objResultDocIdArry.size(); j++)
		/**** 분류함 테이블에서 작성자와 유저가 같은 데이터만 display -- end ****/		
		
		/**** 업무정보 테이블에서 작성자와 유저가 같은 데이터만 display -- start ****/
		String strDutyId = "";
		String strDutyNm = "";
		Hashtable objResultDutyIdHt = new Hashtable();
		
		for(int k=0; k<objResultDutyIdArry.size(); k++){
			objResultDutyIdHt =(Hashtable)objResultDutyIdArry.get(k);
			strDutyId = (String)objResultDutyIdHt.get("DUTY_ID");
			strDutyNm = (String)objResultDutyIdHt.get("FILE_NAME");
%>        
        <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
          <td height="11" align="center"><input type="checkbox" name="checkF" value="<%=strDutyId%>" checked=true></td>
          <td height="25" class="td_lmagin"><%=strDutyNm%></td>
        </tr>
        <tr class="tbl-line"> 
          <td height="1"></td>
          <td height="1"></td>
        </tr>
<%
		}//for(int j=0; j<objResultDutyIdArry.size(); j++)
		/**** 업무정보 테이블에서 작성자와 유저가 같은 데이터만 display -- end ****/		
%>	
      </table>     
    </td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="40" align="left"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="24%">&nbsp;</td>
          <td width="76%" align="right" valign="middle"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
<%
		
		if(strGubn.equals("M")){
		
%>	            
            <strong>폴더위치 : </strong> 
            <select name="chg_docbox_id" class="select">
<%
			Vector objListParam = new Vector();
			//objListParam.add(strUserId);
			objListParam.add(strOrganId);
			
			ArrayList objDocboxArray = objBusInfoDelegate.selectDocboxList(objListParam);
		
			Hashtable objListHt = new Hashtable();
			String strListNm = "";
			String strListId =  "";
%>
			<option value="0"><%=strSelectedOrganNm%>
<%
			
			for(int k=0; k < objDocboxArray.size() ; k++){
				objListHt = (Hashtable)objDocboxArray.get(k);
				strListNm = (String)objListHt.get("NM");
				strListId = (String)objListHt.get("DOCBOX_ID");
				strListNm = nads.lib.util.ActComm.chgSpace(strListNm);
%>
			<option value="<%=strListId%>"><%=strListNm%>
<%
			}	
%>	
            </select>
            <a href="javascript:fun_move()"><img src="../image/button/bt_shift.gif" width="42" height="20" align="absmiddle" border="0"></a></td>
<%
		
		}else{
%>            
            <a href="javascript:fun_delete()"><img src="../image/button/bt_delete.gif" width="42" height="20" align="absmiddle" border="0"></a></td>
<%
			
		}//if(strGubn.equals("M"))
%>       
        </tr>
      </table></td>
  </tr>
  <tr align="right"> 
    <td height="25" colspan="2" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</form>
</table>
</body>
<%
		
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
</html>
