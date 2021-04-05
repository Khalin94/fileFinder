<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%@ page import="nads.lib.message.MessageBean" %>


<%
	String strUserId = (String)session.getAttribute("USER_ID");  //사용자 ID
	String strMainOrganIdLeft = (String)session.getAttribute("ORGAN_ID");  //사용자 주 기관ID
	String strDocboxId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("docbox_id"), ""));  //좌측메뉴에서 클릭한 분류함ID
	String strOrganId   = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("organ_id"), ""));  //좌측메뉴에서 클릭한 기관ID
	
	String strOrganIdLeft = "";  //분류함의 기관ID
	String strDocboxIdLeft = "";  //분류함ID
	String strDocboxNmLeft = "";  //분류함명
	String strTopDocboxIdLeft = "";  //분류함의 상위분류함ID
	String strSeqLeft = "";  //분류함(폴더)의 단계(1,2,3...)
	String strNumber = "";  //분류함(폴더)의 단계==>(strSeqLeft + 3) /2 == 몫)
	String strNmMenuLeft = "";  //분류함(폴더)의 단계(0,2,4...)
	
	Hashtable objDocboxLeftHt = new Hashtable();
	ArrayList objDocboxLeftArry = new ArrayList();

	try 
	{
		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();	
		objDocboxLeftArry = objBusInfoDelegate.selectOrganDocboxList(strUserId);	
	} catch (AppException objAppEx) {
		
		//에러 발생 메세지 페이지로 이동한다.
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
		//out.println("메뉴목록 조회 중 에러 발생 || 메세지 페이지로 이동");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}	
%>	

			<!-------------------------------------- 메뉴 Tree Start ------------------------------>						
			<SCRIPT LANGUAGE="JavaScript" >
			<!--
			

			aux0=gFld("부서자료실","", "", "");
<%
		String strUserAllOrganId = "";
		String strOrgGbn = "";
		for (int i=0; i < objDocboxLeftArry.size(); i++)
		{
			objDocboxLeftHt = (Hashtable)objDocboxLeftArry.get(i);

			strOrganIdLeft = (String)objDocboxLeftHt.get("ORGAN_ID");
			strDocboxIdLeft = (String)objDocboxLeftHt.get("DOCBOX_ID");
			strDocboxNmLeft = (String)objDocboxLeftHt.get("DOCBOX_NM");
			strNmMenuLeft = (String)objDocboxLeftHt.get("NM_MENU");
			strTopDocboxIdLeft = (String)objDocboxLeftHt.get("TOP_DOCBOX_ID");
			strSeqLeft = (String)objDocboxLeftHt.get("SEQ");
			//strDocboxNmLeft = nads.lib.util.ActComm.chgSpace(strDocboxNmLeft);

			if (strDocboxIdLeft.equals("M")){
				strUserAllOrganId = strUserAllOrganId + "," + strOrganIdLeft;
				strNumber = "1";
				strOrgGbn = (String)objDocboxLeftHt.get("ORG_POSI_GBN") ;
				if(!strOrgGbn.equals("1")){   //겸직 구분 '1'->원직
					strNmMenuLeft = "(겸무)" + strNmMenuLeft;
				}
%>
				aux<%=strNumber%> = insFld(aux<%=String.valueOf(Integer.parseInt(strNumber)-1)%>, gFld("<%=strNmMenuLeft%>", "fun_organleft", "0" , "<%=strOrganIdLeft%>", "<%=strNumber%>"));

<%
			}else{
				strNumber = Integer.toString((Integer.parseInt(strSeqLeft) + 3) /2) ;
%>
				aux<%=strNumber%> = insFld(aux<%=String.valueOf(Integer.parseInt(strNumber)-1)%>, gFld("<%=strNmMenuLeft%>", "fun_organleft", "<%=strDocboxIdLeft%>" , "<%=strOrganIdLeft%>", "<%=strNumber%>"));
<%
			}
		}
		strNumber = "1";
%>
			aux<%=strNumber%> = insFld(aux<%=String.valueOf(Integer.parseInt(strNumber)-1)%>, gFld("소속부서자료조회", "fun_alldutyinfo", "0" , "<%=strUserAllOrganId%>", "<%=strNumber%>"));
			
			if (document.all) {  // IE4
			     document.write("<table border='0' cellpadding='0' cellspacing='0'>");
			     document.write("<td valign='top'>");
			     reloadDocument("<%=strDocboxId%>", "<%=strOrganId%>");
			     document.write("</td>");
			     document.write("</table>");
			}
			else {  // NS4
				 reloadDocument("<%=strDocboxId%>", "<%=strOrganId%>");
			}
		
			//-->
			</SCRIPT>
								