<%@ page import="kr.co.kcc.bf.log.Log" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*"%>

<script src="/js/common.js"></script>
<script>

function scriptIt(val){

val.value=val.value.replace(/"/gi,"&#34;")

val.value=val.value.replace(/'/gi,"&#39;")

valArr=escape(val.value).split("%0D%0A")

val.value=""

for (i=0; i<valArr.length; i++){

//val.value+= (i==0) ? "<script>\ninfo=" : ""

val.value+= "\"" + unescape(valArr[i])

val.value+= (i!=valArr.length-1) ? "\" + \n" : "\"\n" 

}

//val.value+="\nvar win = window.open('/common/blank.jsp','','width=100,height=100')\n"

//val.value+="\nwin.document.write(info)\n<\/script>"

}
</script>
<%@ include file="/board/common/GetBoardProperty.jsp" %>


<%

	Config objConfig = PropertyConfig.getInstance();
	String strWebPath = objConfig.get("nads.dsdm.webapp.path");  

	String strPopType = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("strTypeParam"));
	
	if(strPopType == null || strPopType.equals("")) {
			strPopType = "002";
	}


	String strReqSubmtFlag = (String)session.getAttribute("REQ_SUBMT_FLAG");
	if ( !(strReqSubmtFlag == null || strReqSubmtFlag.equals("")) && strPopType.equals("002") ) {
		if (strReqSubmtFlag.equals("003")) {		// 요구, 제출 권한
			strPopType = strPopType + ", 003, 004";
		}else if (strReqSubmtFlag.equals("001")) {	// 요구 권한
			strPopType = strPopType + ", 003";
		}else if (strReqSubmtFlag.equals("002")) {	// 제출 권한
			strPopType = strPopType + ", 004";
		}
	}

	Hashtable objHshPopUpInfoList = new Hashtable();
	nads.dsdm.app.main.MainDelegate objMain = new nads.dsdm.app.main.MainDelegate();
	ArrayList objAryPopUpInfo = new ArrayList();
	
	try{

		//팝업정보를 가져온다.
		objAryPopUpInfo = objMain.getPopUpInfo(strPopType);
		
	}catch (Exception e) {					
		// 에러 발생 메세지 페이지로 이동한다.
%>
		<jsp:forward page="/common/message/ViewMsg2.jsp"/>
<%
		return;
		
	}
	
	if(objAryPopUpInfo != null){
		
		for(int i=0;i < objAryPopUpInfo.size();i++){
			
			objHshPopUpInfoList = (Hashtable)objAryPopUpInfo.get(i);
			
			String strPopUpId = (String)objHshPopUpInfoList.get("POPUP_ID");
			String strPopUpGbn = (String)objHshPopUpInfoList.get("POPUP_GBN");
			String strPopUpNm = (String)objHshPopUpInfoList.get("POPUP_NM");
			String strUrl = (String)objHshPopUpInfoList.get("URL");
			String strWidth = (String)objHshPopUpInfoList.get("WIDTH");
			String strHgt = (String)objHshPopUpInfoList.get("HGT");
			String strCont = (String)objHshPopUpInfoList.get("CONT");
			String strFileName = (String)objHshPopUpInfoList.get("FILE_NAME");
			String strFileId = (String)objHshPopUpInfoList.get("FILE_ID");
			

			String strCont_Temp = "<link href='/css/System.css' rel='stylesheet' type='text/css'> " + (String)objHshPopUpInfoList.get("CONT");
			


			
			//int intHgt = Integer.valueOf(strHgt).intValue() + 30;
			//int intWidth = Integer.valueOf(strWidth).intValue() + 10;

			int intHgt = Integer.valueOf(strHgt).intValue();
			int intWidth = Integer.valueOf(strWidth).intValue();
			
			
			//쿠키값 있을 경우 - 팝업을 띄우지 않는다.
			Cookie[] cookies = request.getCookies();
			String strCookievalue = "N";
			
			if (cookies != null) {
				for (int j = 0; j < cookies.length; j++) {
					if (cookies[j].getName().equals(strPopUpId)) {
						strCookievalue = URLDecoder.decode(cookies[j].getValue(), "UTF-8");					
						break;
					}
				}
			}

			if(strCookievalue.equals("N")){
				
				String strScriptCont = "<link href='/css/System.css' rel='stylesheet' type='text/css'>";
				strScriptCont = strScriptCont + "<script language='JavaScript'> ";
				strScriptCont = strScriptCont + " function setCookie(name, value, expiredays){ ";
				strScriptCont = strScriptCont + "	var todayDate = new Date(); ";
				strScriptCont = strScriptCont + "	todayDate.setDate( todayDate.getDate() + expiredays ); ";
				strScriptCont = strScriptCont + "	document.cookie = name + '=' + escape( value ) + '; path=/; expires=' + todayDate.toGMTString() + ';' } ";
				strScriptCont = strScriptCont + " function closeWin(){ if(document.frm.chkClose.checked){ setCookie('" + strPopUpId + "', 'Y' , 1); } self.close(); }";
				strScriptCont = strScriptCont + "</script>";
				
				if(strPopUpGbn.equals("1")){			//등록
					
					strCont = strCont + "<html><head><title> "+strPopUpNm+" </title></head>";
					strCont = strCont + "<body leftmargin='0' topmargin='0' marginwidth='0' marginheight='0'>";
					strCont = strCont + "<table width='"+strWidth+"' height='"+strHgt+"' border='0'>";
					strCont = strCont + "<tr><td valign='bottom'><iframe src='"+ strUrl +"' width='"+ strWidth + "'  height='"+strHgt+"'  frameborder='0' scrolling='no' frame border='0' name=''></iframe></td></tr>";
					strCont = strCont + "<form name='frm'><tr height='10'><td bgcolor='#F5F5F5'><div align='right'>";
					strCont = strCont + "<input type='checkbox' name='chkClose' value='' onClick='javascript:closeWin();'>";
					strCont = strCont + "<font color='#330000'>오늘 하루 이 창 닫기</font>&nbsp;&nbsp;</div></font>";
					strCont = strCont + "</td></tr></form>";
					strCont = strCont + "</table></body></html>";
				} 
				else if (strPopUpGbn.equals("2")){		//작성
					
					
					strCont = "<html><head><title> "+strPopUpNm+" </title></head>" + strCont;
					strCont = strCont + "<table width='100%' height='10' bgcolor='#F5F5F5' border='0'><form name='frm'>";
					strCont = strCont + "<tr height='10'><td><div align='right'><input type='checkbox' name='chkClose' value=''  onClick='javascript:closeWin();'>";
					strCont = strCont + "<font color='#330000'>오늘 하루 이 창 닫기</font>&nbsp;&nbsp;</div></font>";
					strCont = strCont + "</td></tr></form></table>";
									

				}
				
				strCont = strScriptCont + strCont;
%>
				<table>
				
				<form name="f<%=i%>">
					<textarea name="t" cols="60" rows="10" style="display:none"><%=strCont%></textarea>
				</form>
				
				<form name="form_<%=i%>">
					<textarea name="strPopUpNm" cols="60" rows="10" style="display:none"><%=strPopUpNm%></textarea>
					<textarea name="strCont" cols="60" rows="10" style="display:none"><%=strCont_Temp%></textarea>					
					<textarea name="strUrl" cols="60" rows="10" style="display:none"><%=strUrl%></textarea>
					<input type=hidden name="linkurl" value="/common/FileDownload.jsp?dataid=<%=strPopUpId%>&filepath=/upload/popup&fileid=<%=strFileId%>&webpath=<%=strWebPath%>">
					<input type=hidden name="linkfilename" value="<%=strFileName%>">
				</form>
				
				</table>
			
				
				<script>
					
					/*
					var win<%=i%> = window.open('/common/blank.jsp','<%=strPopUpId%>','scrollbars=auto,resizable=no,width=<%=intWidth%>,height=<%=intHgt%>');
					
					win<%=i%>.document.open()>win<%=i%>.document.write(document.f<%=i%>.t.value);
					*/
					function getCookie(name) { 
						var Found = false 
						var start, end 
						var i = 0 
			 
						while(i <= document.cookie.length) { 
							start = i 
							end = start + name.length 
							if(document.cookie.substring(start, end) == name) { 
								Found = true 
								break 
							} 
							i++ 
						} 
			 
						if(Found == true) { 
							start = end + 1 
							end = document.cookie.indexOf(";", start) 
							if(end < start) end = document.cookie.length 
							return document.cookie.substring(start, end) 
						} 
						return "" 
					} 
				 
					
					var noticeCookie=getCookie("<%=strPopUpId%>");  // 쿠키네임 지정
					if (noticeCookie != "Y") 
					var win<%=i%> = window.open('/common/ShowPopUp.jsp?Form=form_<%=i%>&Flag=flag_<%=strPopUpGbn%>&PopUpId=<%=strPopUpId%>','<%=strPopUpId%>','scrollbars=no,resizable=no,width=<%=intWidth%>,height=<%=intHgt%>');							
				</script>


<%
			}	//end if (strCookievalue)
			
		}	//end for
		
	} //end if(objAryPopUpInfo != null)

%>





